/obj/machinery/computer/camera_advanced/manager
	name = "managerial camera console"
	desc = "A computer used for remotely handling a facility."
	icon_screen = "mechpad"
	icon_keyboard = "generic_key"
	resistance_flags = INDESTRUCTIBLE
	var/datum/action/innate/cyclemanagerbullet/cycle
	var/datum/action/innate/firemanagerbullet/fire
	var/datum/action/innate/cyclecommand/cyclecommand
	var/datum/action/innate/managercommand/command
	var/datum/action/innate/manager_track/follow
	var/ammo = 4
	var/bullettype = 0
	var/commandtype = 1
	var/command_delay = 0.5 SECONDS
	var/command_cooldown
	//Used for limiting the amount of commands that can exist.
	var/current_commands = 0
	var/max_commands = 10
	///Variable stolen from AI. Essential for tracking feature.
	var/static/datum/trackable/track = new
	//Command Types sorted in order.
	var/list/commandtypes = list(
		/obj/effect/temp_visual/HoloCommand/commandMove,
		/obj/effect/temp_visual/HoloCommand/commandWarn,
		/obj/effect/temp_visual/HoloCommand/commandGaurd,
		/obj/effect/temp_visual/HoloCommand/commandHeal,
		/obj/effect/temp_visual/HoloCommand/commandFightA,
		/obj/effect/temp_visual/HoloCommand/commandFightB
		)
	/// Used for radial menu; Type = list(name, desc, icon_state)
	/// List of bullets available for use are defined in lobotomy_corp subsystem
	var/list/bullet_types = list(
		list("name" = HP_BULLET, "desc" = "These bullets speed up the recovery of an employee.", "icon_state" = "green"),
		list("name" = SP_BULLET, "desc" = "Bullets that inject an employee with diluted Enkephalin.", "icon_state" = "blue"),
		list("name" = RED_BULLET, "desc" = "Attach a RED DAMAGE forcefield onto a employee.", "icon_state" = "red"),
		list("name" = WHITE_BULLET, "desc" = "Attach a WHITE DAMAGE forcefield onto a employee.", "icon_state" = "white"),
		list("name" = BLACK_BULLET, "desc" = "Attach a BLACK DAMAGE forcefield onto a employee.", "icon_state" = "black"),
		list("name" = PALE_BULLET, "desc" = "Attach a PALE DAMAGE forcefield onto a employee.", "icon_state" = "pale"),
		list("name" = YELLOW_BULLET, "desc" = "Overload a abnormalities Qliphoth Control to reduce their movement speed.", "icon_state" = "yellow"),
		)

	/* Locked actions */
	// Unlocked by completing records core suppression
	var/datum/action/innate/swap_cells/swap

/obj/machinery/computer/camera_advanced/manager/Initialize(mapload)
	. = ..()
	GLOB.manager_consoles += src

	cycle = new
	fire = new
	cyclecommand = new
	command = new
	follow = new

	command_cooldown = world.time
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/RechargeMeltdown)

/obj/machinery/computer/camera_advanced/manager/Destroy()
	GLOB.manager_consoles -= src
	return ..()

/obj/machinery/computer/camera_advanced/manager/examine(mob/user)
	. = ..()
	if(ammo)
		. += "<span class='notice'>It has [round(ammo)] bullets loaded.</span>"

/obj/machinery/computer/camera_advanced/manager/GrantActions(mob/living/carbon/user) //sephirah console breaks off from this branch so any edits you want on both must be done manually.
	..()

	//List abilities here:
	if(cycle)
		cycle.target = src
		cycle.Grant(user)
		actions += cycle

	if(fire)
		fire.target = src
		fire.Grant(user)
		actions += fire

	if(cyclecommand)
		cyclecommand.target = src
		cyclecommand.Grant(user)
		actions += cyclecommand

	if(command)
		command.target = src
		command.Grant(user)
		actions += command

	if(follow)
		follow.target = src
		follow.Grant(user)
		actions += follow

	if(swap)
		swap.target = src
		swap.Grant(user)
		swap.selected_abno = null
		actions += swap

	RegisterSignal(user, COMSIG_MOB_CTRL_CLICKED, .proc/HotkeyClick) //wanted to use shift click but shift click only allowed applying the effects to my player.
	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT, .proc/altClick)
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, .proc/ManagerExaminate)
	RegisterSignal(user, COMSIG_MOB_CTRLSHIFTCLICKON, .proc/OnCtrlShiftClick)

/obj/machinery/computer/camera_advanced/manager/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/managerbullet) && ammo <= GetFacilityUpgradeValue(UPGRADE_BULLET_COUNT))
		ammo++
		to_chat(user, "<span class='notice'>You load [O] in to the [src]. It now has [ammo] bullets stored.</span>")
		playsound(get_turf(src), 'sound/weapons/kenetic_reload.ogg', 10, 0, 3)
		qdel(O)
		return
	..()

/obj/machinery/computer/camera_advanced/manager/remove_eye_control(mob/living/user)
	UnregisterSignal(user, list(COMSIG_MOB_CTRL_CLICKED, COMSIG_XENO_TURF_CLICK_ALT, COMSIG_MOB_SHIFTCLICKON, COMSIG_MOB_CTRLSHIFTCLICKON))
	..()

/obj/machinery/computer/camera_advanced/manager/proc/HotkeyClick(datum/source, atom/clicked_atom) //system control for hotkeys
	SIGNAL_HANDLER

	// No target :(
	if(!isliving(clicked_atom))
		return

	// No bullets :(
	if(!ammo)
		playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
		to_chat(source, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
		return

	// AOE bullets
	if(SSlobotomy_corp.manager_bullet_area > -1)
		var/success = FALSE
		for(var/mob/living/L in range(SSlobotomy_corp.manager_bullet_area, clicked_atom))
			if(ishuman(clicked_atom))
				clickedEmployee(source, clicked_atom)
				success = TRUE
			if(ishostile(clicked_atom))
				clickedAbno(source, clicked_atom)
				success = TRUE
		if(success)
			ammo--
		return

	// Non-AOE
	if(ishuman(clicked_atom))
		clickedEmployee(source, clicked_atom)
		ammo--
		return
	if(ishostile(clicked_atom))
		clickedAbno(source, clicked_atom)
		ammo--
		return

/obj/machinery/computer/camera_advanced/manager/proc/clickedEmployee(mob/living/owner, mob/living/carbon/employee) //contains carbon copy code of fire action
	var/mob/living/carbon/human/H = employee
	switch(bullettype)
		if(HP_BULLET)
			H.adjustBruteLoss(-0.15*H.maxHealth)
		if(SP_BULLET)
			H.adjustSanityLoss(-0.15*H.maxSanity)
		if(RED_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield)
		if(WHITE_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield/white)
		if(BLACK_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield/black)
		if(PALE_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield/pale)
		if(YELLOW_BULLET)
			if(!owner.faction_check_mob(H))
				H.apply_status_effect(/datum/status_effect/qliphothoverload)
			else
				to_chat(owner, "<span class='warning'>WELFARE SAFETY SYSTEM ERROR: TARGET SHARES CORPORATE FACTION.</span>")
				return
		else
			to_chat(owner, "<span class='warning'>ERROR: BULLET INITIALIZATION FAILURE.</span>")
			return
	playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
	playsound(get_turf(H), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)

	if(!istype(H))
		to_chat(owner, "<span class='warning'>NO VALID TARGET.</span>")
		return

	switch(bullettype)
		if(HP_BULLET)
			H.adjustBruteLoss(-0.15*H.maxHealth)
		if(SP_BULLET)
			H.adjustSanityLoss(-0.15*H.maxSanity)
		if(RED_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield)
		if(WHITE_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield/white)
		if(BLACK_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield/black)
		if(PALE_BULLET)
			H.apply_status_effect(/datum/status_effect/interventionshield/pale)
		if(YELLOW_BULLET)
			if(!owner.faction_check_mob(H))
				H.apply_status_effect(/datum/status_effect/qliphothoverload)
			else
				to_chat(owner, "<span class='warning'>WELFARE SAFETY SYSTEM ERROR: TARGET SHARES CORPORATE FACTION.</span>")
				return
		else
			to_chat(owner, "<span class='warning'>ERROR: BULLET INITIALIZATION FAILURE.</span>")
			return
	ammo--
	playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
	playsound(get_turf(H), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
	to_chat(owner, "<span class='warning'><b>[ammo]</b> bullets remaining.</span>")

/obj/machinery/computer/camera_advanced/manager/proc/clickedabno(mob/living/owner, mob/living/simple_animal/hostile/H)
	if(ammo <= 0)
		playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
		return

	if(!istype(H))
		to_chat(owner, "<span class='warning'>NO VALID TARGET.</span>")
		return

	if(bullettype == 7)
		H.apply_status_effect(/datum/status_effect/qliphothoverload)
		ammo--
		playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
		playsound(get_turf(H), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
		to_chat(owner, "<span class='warning'><b>[ammo]</b> bullets remaining.</span>")
		return

	to_chat(owner, "<span class='warning'>ERROR: BULLET INITIALIZATION FAILURE.</span>")
	return

/obj/machinery/computer/camera_advanced/manager/proc/ManagerExaminate(mob/living/user, atom/clicked_atom)
	user.examinate(clicked_atom) //maybe put more info on the agent/abno they examine if we want to be fancy later

	if(ishuman(clicked_atom))
		var/mob/living/carbon/human/H = clicked_atom
		to_chat(user, "<span class='notice'>Agent level [get_user_level(H)].</span>")
		to_chat(user, "<span class='notice'>Fortitude level [get_attribute_level(H, FORTITUDE_ATTRIBUTE)].</span>")
		to_chat(user, "<span class='notice'>Prudence level [get_attribute_level(H, PRUDENCE_ATTRIBUTE)].</span>")
		to_chat(user, "<span class='notice'>Temperance level [get_attribute_level(H, TEMPERANCE_ATTRIBUTE)].</span>")
		to_chat(user, "<span class='notice'>Justice level [get_attribute_level(H, JUSTICE_ATTRIBUTE)].</span>")
		return

	if(istype(clicked_atom, /mob/living/simple_animal))
		var/mob/living/simple_animal/monster = clicked_atom

		var/message = "<span class='notice'>[clicked_atom]'s resistances are :"

		var/list/damage_types = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
		for(var/i in damage_types)
			var/resistance = SimpleResistanceToText(monster.damage_coeff.getCoeff(i))
			message += "\n[capitalize(i)]: [resistance]"

		message += "</span>"

		to_chat(user, message)

/obj/machinery/computer/camera_advanced/manager/proc/altClick(mob/living/user, turf/open/T)
	var/mob/living/C = user
	if(command_cooldown <= world.time)
		for(var/obj/effect/temp_visual/HoloCommand/V in T)
			qdel(V)
			return
		if(current_commands >= max_commands)
			to_chat(C, "<span class='warning'>COMMAND CAPACITY REACHED.</span>")
			return
		playsound(get_turf(src), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		playsound(get_turf(T), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		if(commandtype > 0 && commandtype <= 6)
			var/thing_to_spawn = commandtypes[commandtype]
			var/thing_spawned = new thing_to_spawn(get_turf(T))
			current_commands++
			RegisterSignal(thing_spawned, COMSIG_PARENT_QDELETING, .proc/ReduceCommandAmount)
		else
			to_chat(C, "<span class='warning'>ERROR: Calibration Faliure.</span>")
		commandtimer()

/obj/machinery/computer/camera_advanced/manager/proc/OnCtrlShiftClick(mob/living/user, atom/target)
	if(!istype(swap))
		return
	swap.Activate(target)

//Used in the tracking of existing commands.
/obj/machinery/computer/camera_advanced/manager/proc/ReduceCommandAmount()
	SIGNAL_HANDLER
	current_commands--

//Numerical Procs that alter variables
/obj/machinery/computer/camera_advanced/manager/proc/commandtimer()
	command_cooldown = world.time + command_delay
	return

/obj/machinery/computer/camera_advanced/manager/proc/alterbullettype(amount)
	bullettype = bullettype + amount
	return

/obj/machinery/computer/camera_advanced/manager/proc/altercommandtype(amount)
	commandtype = commandtype + amount
	return

/obj/machinery/computer/camera_advanced/manager/proc/RechargeMeltdown()
	playsound(get_turf(src), 'sound/weapons/kenetic_reload.ogg', 10, 0, 3)
	ammo = GetFacilityUpgradeValue(UPGRADE_BULLET_COUNT)

//Employee Tracking Code: Butchered AI Tracking

/*--------------------------------------------\
|Employee Tracking Code: Butchered AI Tracking|
\--------------------------------------------*/
//Shows a list of creatures that can be tracked.
/obj/machinery/computer/camera_advanced/manager/proc/TrackableCreatures()
	track.initialized = TRUE
	track.names.Cut()
	track.namecounts.Cut()
	track.humans.Cut()
	track.others.Cut()

	if(current_user.stat == DEAD)
		return list()

	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		if(!L.can_track(current_user))
			continue

		var/name = L.name
		if(name in track.names)
			continue

		if(ishuman(L))
			track.humans[name] = L
		else
			track.others[name] = L

	var/list/targets = sortList(track.humans) + sortList(track.others)

	return targets

//Proc for following a target.
/obj/machinery/computer/camera_advanced/manager/proc/MobTracking(mob/living/target)
	if(!istype(target))
		to_chat(current_user, "<span class='warning'>ERROR: Invalid Tracking Target.</span>")
		return

	if(!target || !target.can_track(current_user))
		to_chat(current_user, "<span class='warning'>Target is not near any active cameras.</span>")
		return

	to_chat(current_user, "<span class='notice'>Now tracking [target.get_visible_name()] on camera.</span>")
	if(eyeobj)
		//Orbit proc is essentially follow.
		eyeobj.orbit(target)
	else
		to_chat(current_user, "<span class='notice'>ERROR: Camera Eye Unresponsive.</span>")

	/*----------\
	|Action Code|
	\----------*/
/datum/action/innate/cyclemanagerbullet
	name = "HP-N bullet"
	desc = "These bullets speed up the recovery of an employee."
	icon_icon = 'icons/obj/manager_bullets.dmi'
	button_icon_state = "green"

/datum/action/innate/cyclemanagerbullet/Activate()
	var/list/bullets = list()
	var/list/display_bullets = list()
	var/obj/machinery/computer/camera_advanced/manager/console = target
	for(var/i = 1 to console.bullet_types.len)
		// Missing upgrade!
		if(!GetFacilityUpgradeValue(console.bullet_types[i]["name"]))
			continue
		bullets[console.bullet_types[i]["name"]] = i
		var/image/bullet_image = image(icon = 'icons/obj/manager_bullets.dmi', icon_state = console.bullet_types[i]["icon_state"])
		display_bullets += list(console.bullet_types[i]["name"] = bullet_image)
	var/chosen_bullet = show_radial_menu(owner, owner.remote_control, display_bullets, radius = 38, require_near = FALSE)
	chosen_bullet = bullets[chosen_bullet]
	if(QDELETED(src) || QDELETED(target) || QDELETED(owner) || !chosen_bullet)
		return FALSE

	to_chat(owner, "<span class='notice'>[console.bullet_types[chosen_bullet]["name"]] bullet selected.</span>")
	name = "[console.bullet_types[chosen_bullet]["name"]] bullet"
	desc = console.bullet_types[chosen_bullet]["desc"]
	button_icon_state = console.bullet_types[chosen_bullet]["icon_state"]
	console.bullettype = chosen_bullet
	UpdateButtonIcon()
	playsound(get_turf(target), 'sound/weapons/kenetic_reload.ogg', 15, TRUE)

/datum/action/innate/firemanagerbullet
	name = "Fire Initialized Bullet"
	desc = "Hotkey = Ctrl + Click"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "projectile"

/datum/action/innate/firemanagerbullet/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/turf/T = get_turf(C.remote_control)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	var/list/valid_targets = list()
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		if(!ishuman(L) && !ishostile(L))
			continue
		valid_targets += L
	if(!LAZYLEN(valid_targets))
		to_chat(C, "<span class='warning'>No valid targets found!</span>")
		return FALSE
	return X.on_hotkey_click(C, pick(valid_targets))

/datum/action/innate/cyclecommand
	name = "Cycle Command"
	desc = "Welfare apologizes for any complications with the technology."
	icon_icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	button_icon_state = "Move_here_wagie"
	var/button_icon1 = "Move_here_wagie"
	var/button_icon2 = "Watch_out_wagie"
	var/button_icon3 = "Guard_this_wagie"
	var/button_icon4 = "Heal_this_wagie"
	var/button_icon5 = "Fight_this_wagie1"
	var/button_icon6 = "Fight_this_wagie2"

/datum/action/innate/cyclecommand/Activate()
	var/obj/machinery/computer/camera_advanced/manager/X = target
	switch(X.commandtype)
		if(0) //if 0 change to 1
			to_chat(owner, "<span class='notice'>MOVE IMAGE INITIALIZED.</span>")
			button_icon_state = button_icon1
			X.altercommandtype(1)
		if(1)
			to_chat(owner, "<span class='notice'>WARN IMAGE INITIALIZED.</span>")
			button_icon_state = button_icon2
			X.altercommandtype(1)
		if(2)
			to_chat(owner, "<span class='notice'>GAURD IMAGE INITIALIZED.</span>")
			button_icon_state = button_icon3
			X.altercommandtype(1)
		if(3)
			to_chat(owner, "<span class='notice'>HEAL IMAGE INITIALIZED.</span>")
			button_icon_state = button_icon4
			X.altercommandtype(1)
		if(4)
			to_chat(owner, "<span class='notice'>FIGHT_LIGHT IMAGE INITIALIZED.</span>")
			button_icon_state = button_icon5
			X.altercommandtype(1)
		if(5)
			to_chat(owner, "<span class='notice'>FIGHT_HEAVY IMAGE INITIALIZED.</span>")
			button_icon_state = button_icon6
			X.altercommandtype(1)
		else
			X.altercommandtype(-5)
			to_chat(owner, "<span class='notice'>MOVE IMAGE INITIALIZED.</span>")
			button_icon_state = button_icon1
	UpdateButtonIcon()

/datum/action/innate/managercommand
	name = "Deploy Command"
	desc = "Hotkey = Alt + Click"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"

/datum/action/innate/managercommand/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/ai_eye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/manager/X = E.origin
	var/cooldown = X.command_cooldown
	if(cooldown <= world.time)
		X.altClick(C, get_turf(E))

//////////////
// Unlockables
//////////////

// Records core reward
/datum/action/innate/swap_cells
	name = "Swap Abnormality Cells"
	desc = "Hotkey = Alt + Shift + Click"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_ff_off"
	/// Currently selected abnormality; Next activation will do the swap
	var/datum/abnormality/selected_abno = null

/datum/action/innate/swap_cells/Activate(mob/living/simple_animal/hostile/abnormality/A = null)
	if(isnull(A))
		A = locate() in get_turf(owner.remote_control)

	if(!istype(A) || !istype(A.datum_reference) || !A.IsContained())
		to_chat(owner, span_warning("The target must be an abnormality within your containment zone!"))
		return

	if(!selected_abno)
		selected_abno = A.datum_reference
		to_chat(owner, span_notice("[A.datum_reference.name] selected as first argument for a cell swap. Activate on a second abnormality to perform."))
		return

	if(!selected_abno.SwapPlaceWith(A.datum_reference))
		to_chat(owner, span_danger("Cell swap failed! Both arguments have been reset."))
		selected_abno = null
		return
	to_chat(owner, span_notice("Cell swap between <b>[selected_abno.name] and [A.datum_reference.name]</b> was successful! Arguments reset."))
	selected_abno = null
	playsound(get_turf(target), 'sound/machines/terminal_success.ogg', 10, TRUE)

// Temp Effects

/obj/effect/temp_visual/commandMove
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Move_here_wagie"
	duration = 150 		//15 Seconds

/obj/effect/temp_visual/commandWarn
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Watch_out_wagie"
	duration = 150

/obj/effect/temp_visual/commandGaurd
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Guard_this_wagie"
	duration = 150

/obj/effect/temp_visual/commandHeal
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Heal_this_wagie"
	duration = 150

/obj/effect/temp_visual/commandFightA
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Fight_this_wagie1"
	duration = 150

/obj/effect/temp_visual/commandFightB
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Fight_this_wagie2"
	duration = 150

/turf/open/AltClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_TURF_CLICK_ALT, src)
	..()

#undef HP_BULLET
#undef SP_BULLET
#undef RED_BULLET
#undef WHITE_BULLET
#undef BLACK_BULLET
#undef PALE_BULLET
#undef YELLOW_BULLET

//Manager Camera Tracking Code
/datum/action/innate/manager_track
	name = "Follow Creature"
	desc = "Track a creature."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "meson"

/datum/action/innate/manager_track/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/ai_eye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/manager/X = E.origin

	var/target_name = input(C, "Choose who you want to track", "Tracking") as null|anything in X.TrackableCreatures()
	///Complicated stuff
	var/list/trackeable = list()
	trackeable += X.track.humans + X.track.others
	var/list/targets = list()
	for(var/I in trackeable)
		var/mob/M = trackeable[I]
		if(M.name == target_name)
			targets += M
	if(name == target_name)
		targets += src
	if(targets.len)
		X.MobTracking(pick(targets))

//TODO:
// Due to the sephirah console being a weaker form of manager console
// it would of been smarter to make manager a subtype of manager that had only the command
// feature. But due to that requiring mappers to replace the manager console with a new manager console
// it was safer to make this downgraded form.

/obj/machinery/computer/camera_advanced/manager/sephirah //crude and lazy but i think it may work.
	name = "sephirah camera console"
	ammo = 0

/obj/machinery/computer/camera_advanced/manager/sephirah/Initialize(mapload)
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START) //unsure if this is the most effective way of doing it.

/obj/machinery/computer/camera_advanced/manager/sephirah/GrantActions(mob/living/carbon/user)
	if(off_action)
		off_action.target = user
		off_action.Grant(user)
		actions += off_action

	if(jump_action)
		jump_action.target = user
		jump_action.Grant(user)
		actions += jump_action
	//replaces proc from camera_advance origin.

	if(cyclecommand)
		cyclecommand.target = src
		cyclecommand.Grant(user)
		actions += cyclecommand

	if(command)
		command.target = src
		command.Grant(user)
		actions += command

	if(follow)
		follow.target = src
		follow.Grant(user)
		actions += follow

	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT, .proc/altClick)
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, .proc/ManagerExaminate)

/obj/machinery/computer/camera_advanced/manager/sephirah/clickedEmployee()
	return

/obj/machinery/computer/camera_advanced/manager/sephirah/RechargeMeltdown()
	return
