#define HP_BULLET 1
#define SP_BULLET 2
#define RED_BULLET 3
#define WHITE_BULLET 4
#define BLACK_BULLET 5
#define PALE_BULLET 6
#define YELLOW_BULLET 7

/obj/machinery/computer/camera_advanced/manager
	name = "managerial camera console"
	desc = "A computer used for remotely handling a facility."
	icon_screen = "mechpad"
	icon_keyboard = "generic_key"
	var/datum/action/innate/cyclemanagerbullet/cycle
	var/datum/action/innate/firemanagerbullet/fire
	var/datum/action/innate/cyclecommand/cyclecommand
	var/datum/action/innate/managercommand/command
	var/datum/action/innate/manager_track/follow
	var/ammo = 6
	var/maxAmmo = 5
	var/bullettype = 1
	var/commandtype = 1
	var/command_delay = 0.5 SECONDS
	var/command_cooldown
	var/mob/living/tracking_subject
	var/tracking = FALSE
	///Variable stolen from AI. Essential for tracking feature.
	var/static/datum/trackable/track = new
	var/static/list/commandtypes = typecacheof(list(
		/obj/effect/temp_visual/commandMove,
		/obj/effect/temp_visual/commandWarn,
		/obj/effect/temp_visual/commandGaurd,
		/obj/effect/temp_visual/commandHeal,
		/obj/effect/temp_visual/commandFightA,
		/obj/effect/temp_visual/commandFightB
		))
	/// Used for radial menu; Type = list(name, desc, icon_state)
	var/list/bullet_types = list(
		HP_BULLET = list("name" = "HP-N", "desc" = "These bullets speed up the recovery of an employee.", "icon_state" = "green"),
		SP_BULLET = list("name" = "SP-E", "desc" = "Bullets that inject an employee with diluted Enkephalin.", "icon_state" = "blue"),
		RED_BULLET = list("name" = "Physical Shield", "desc" = "Attach a RED DAMAGE forcefield onto a employee.", "icon_state" = "red"),
		WHITE_BULLET = list("name" = "Trauma Shield", "desc" = "Attach a WHITE DAMAGE forcefield onto a employee.", "icon_state" = "white"),
		BLACK_BULLET = list("name" = "Erosion Shield", "desc" = "Attach a BLACK DAMAGE forcefield onto a employee.", "icon_state" = "black"),
		PALE_BULLET = list("name" = "Soul Shield", "desc" = "Attach a PALE DAMAGE forcefield onto a employee.", "icon_state" = "pale"),
		YELLOW_BULLET = list("name" = "Qliphoth Intervention Field", "desc" = "Overload a abnormalities Qliphoth Control to reduce their movement speed.", "icon_state" = "yellow"),
		)

/obj/machinery/computer/camera_advanced/manager/Initialize(mapload)
	. = ..()
	cycle = new
	fire = new
	cyclecommand = new
	command = new
	follow = new

	command_cooldown = world.time
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/recharge_meltdown)

/obj/machinery/computer/camera_advanced/manager/examine(mob/user)
	. = ..()
	if(ammo)
		. += "<span class='notice'>It has [round(ammo)] bullets loaded.</span>"

/obj/machinery/computer/camera_advanced/manager/GrantActions(mob/living/carbon/user) //sephirah console breaks off from this branch so any edits you want on both must be done manually.
	..()

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

	RegisterSignal(user, COMSIG_MOB_CTRL_CLICKED, .proc/on_hotkey_click) //wanted to use shift click but shift click only allowed applying the effects to my player.
	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT, .proc/on_alt_click)
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, .proc/ManagerExaminate)

/obj/machinery/computer/camera_advanced/manager/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/managerbullet) && ammo <= maxAmmo)
		ammo++
		to_chat(user, "<span class='notice'>You load [O] in to the [src]. It now has [ammo] bullets stored.</span>")
		playsound(get_turf(src), 'sound/weapons/kenetic_reload.ogg', 10, 0, 3)
		qdel(O)
		return
	..()

/obj/machinery/computer/camera_advanced/manager/remove_eye_control(mob/living/user)
	UnregisterSignal(user, COMSIG_MOB_CTRL_CLICKED)
	UnregisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT)
	UnregisterSignal(user, COMSIG_MOB_SHIFTCLICKON)
	..()

/obj/machinery/computer/camera_advanced/manager/proc/on_hotkey_click(datum/source, atom/clicked_atom) //system control for hotkeys
	SIGNAL_HANDLER
	if(!isliving(clicked_atom))
		return
	if(ishuman(clicked_atom))
		clickedemployee(source, clicked_atom)
		return
	if(ishostile(clicked_atom))
		clickedabno(source, clicked_atom)
		return

/obj/machinery/computer/camera_advanced/manager/proc/clickedemployee(mob/living/owner, mob/living/carbon/employee) //contains carbon copy code of fire action
	if(ammo >= 1)
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
		ammo--
		playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
		playsound(get_turf(H), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
		to_chat(owner, "<span class='warning'>Loading [ammo] Bullets.</span>")
		return
	if(ammo <= 0)
		playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
	else
		to_chat(owner, "<span class='warning'>NO TARGET.</span>")
		return

/obj/machinery/computer/camera_advanced/manager/proc/clickedabno(mob/living/owner, mob/living/simple_animal/hostile/critter)
	if(ammo >= 1)
		var/mob/living/simple_animal/hostile/abnormality/ABNO = critter
		if(bullettype == 7)
			ABNO.apply_status_effect(/datum/status_effect/qliphothoverload)
			ammo--
			playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
			playsound(get_turf(ABNO), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
			to_chat(owner, "<span class='warning'>Loading [ammo] Bullets.</span>")
			return
		else
			to_chat(owner, "<span class='warning'>ERROR: BULLET INITIALIZATION FAILURE.</span>")
			return
	if(ammo <= 0)
		playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
	else
		to_chat(owner, "<span class='warning'>NO TARGET.</span>")
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
		if(!LAZYLEN(monster.damage_coeff))
			return

		to_chat(user, "<span class='notice'>[clicked_atom]'s resistances are : </span>")
		var/list/damage_types = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
		for(var/i in damage_types)
			var/resistance = SimpleResistanceToText(monster.damage_coeff[i])
			if(isnull(resistance))
				continue
			to_chat(user, "<span class='notice'>[i]: [resistance].</span>")

/obj/machinery/computer/camera_advanced/manager/proc/on_alt_click(mob/living/user, turf/open/T)
	var/mob/living/C = user
	if(command_cooldown <= world.time)
		playsound(get_turf(src), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		playsound(get_turf(T), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		for(var/obj/effect/temp_visual/V in range(T, 0))
			if(is_type_in_typecache(V, commandtypes))
				qdel(V)
				return
		switch(commandtype)
			if(1)
				new /obj/effect/temp_visual/commandMove(get_turf(T))
			if(2)
				new /obj/effect/temp_visual/commandWarn(get_turf(T))
			if(3)
				new /obj/effect/temp_visual/commandGaurd(get_turf(T))
			if(4)
				new /obj/effect/temp_visual/commandHeal(get_turf(T))
			if(5)
				new /obj/effect/temp_visual/commandFightA(get_turf(T))
			if(6)
				new /obj/effect/temp_visual/commandFightB(get_turf(T))
			else
				to_chat(C, "<span class='warning'>CALIBRATION ERROR.</span>")
		commandtimer()

/obj/machinery/computer/camera_advanced/manager/proc/commandtimer()
	command_cooldown = world.time + command_delay
	return

/obj/machinery/computer/camera_advanced/manager/proc/alterbullettype(amount)
	bullettype = bullettype + amount
	return

/obj/machinery/computer/camera_advanced/manager/proc/altercommandtype(amount)
	commandtype = commandtype + amount
	return

/obj/machinery/computer/camera_advanced/manager/proc/recharge_meltdown()
	playsound(get_turf(src), 'sound/weapons/kenetic_reload.ogg', 10, 0, 3)
	maxAmmo += 0.25
	ammo = maxAmmo

//Employee Tracking Code: Butchered AI Tracking
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

/obj/machinery/computer/camera_advanced/manager/proc/ActualTrack(mob/living/target)
	if(!istype(target))
		to_chat(current_user, "<span class='warning'>Invalid Tracking Error.</span>")
		return

	tracking_subject = target
	tracking = TRUE

	if(!target || !target.can_track(current_user))
		to_chat(current_user, "<span class='warning'>Target is not near any active cameras.</span>")
		tracking_subject = null
		return

	to_chat(current_user, "<span class='notice'>Now tracking [target.get_visible_name()] on camera.</span>")

	INVOKE_ASYNC(src, .proc/LoopingTrack, target)

/obj/machinery/computer/camera_advanced/manager/proc/LoopingTrack(mob/living/target)
	var/cameraticks = 0

	while(tracking_subject == target)
		if(tracking_subject == null || !current_user)
			return

		if(!target.can_track(current_user))
			tracking = TRUE
			if(!cameraticks)
				to_chat(current_user, "<span class='warning'>Target is not near any active cameras. Attempting to reacquire...</span>")
			cameraticks++
			if(cameraticks > 9)
				tracking_subject = null
				to_chat(current_user, "<span class='warning'>Unable to reacquire, cancelling track...</span>")
				tracking = FALSE
				return
			else
				sleep(10)
				continue

		else
			cameraticks = 0
			tracking = FALSE

		if(eyeobj)
			eyeobj.setLoc(get_turf(target))

		else
			eyeobj.setLoc(get_turf(src))
			tracking_subject = null
			return

		sleep(5)

//Actions
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
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		switch(X.bullettype)
			if(HP_BULLET to YELLOW_BULLET)
				for(var/mob/living/carbon/human/H in range(0, T))
					switch(X.bullettype)
						if(HP_BULLET)
							H.adjustBruteLoss(-0.15*H.maxHealth)
						if(SP_BULLET)
							H.adjustSanityLoss(-0.15*H.maxSanity)
						if(RED_BULLET)
							H.apply_status_effect(/datum/status_effect/interventionshield) //shield status effects located in lc13unique items.
						if(WHITE_BULLET)
							H.apply_status_effect(/datum/status_effect/interventionshield/white)
						if(BLACK_BULLET)
							H.apply_status_effect(/datum/status_effect/interventionshield/black)
						if(YELLOW_BULLET)
							H.apply_status_effect(/datum/status_effect/interventionshield/pale)
						else
							to_chat(owner, "<span class='warning'>ERROR: BULLET INITIALIZATION FAILURE.</span>")
							return
					X.ammo--
					playsound(get_turf(C), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
					playsound(get_turf(T), 'ModularTegustation/Tegusounds/weapons/guns/manager_shock.ogg', 10, 0, 3)
					to_chat(owner, "<span class='warning'>Loading [X.ammo] Bullets.</span>")
					return
			if(YELLOW_BULLET)
				for(var/mob/living/simple_animal/hostile/abnormality/ABNO in T.contents)
					ABNO.apply_status_effect(/datum/status_effect/qliphothoverload)
					X.ammo--
					to_chat(owner, "<span class='warning'>Loading [X.ammo] Bullets.</span>")
					return
	if(X.ammo < 1)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
		playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
	else
		to_chat(owner, "<span class='warning'>NO TARGET.</span>")
		return

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
		playsound(get_turf(C), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		playsound(get_turf(E), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		switch(X.commandtype)
			if(1)
				new /obj/effect/temp_visual/commandMove(get_turf(E))

			if(2)
				new /obj/effect/temp_visual/commandWarn(get_turf(E))

			if(3)
				new /obj/effect/temp_visual/commandGaurd(get_turf(E))

			if(4)
				new /obj/effect/temp_visual/commandHeal(get_turf(E))

			if(5)
				new /obj/effect/temp_visual/commandFightA(get_turf(E))

			if(6)
				new /obj/effect/temp_visual/commandFightB(get_turf(E))

			else
				to_chat(owner, "<span class='warning'>CALIBRATION ERROR.</span>")
		X.commandtimer()

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
	if(X.tracking_subject)
		X.tracking_subject = null
		to_chat(owner, "<span class='notice'>Tracking canceled.</span>")
		return

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
		X.ActualTrack(pick(targets))

//TODO:
// Due to the sephirah console being a weaker form of manager console
// it would of been smarter to make manager a subtype of manager that had only the command
// feature. But due to that requiring mappers to replace the manager console with a new manager console
// it was safer to make this downgraded form.

/obj/machinery/computer/camera_advanced/manager/sephirah //crude and lazy but i think it may work.
	name = "sephirah camera console"
	ammo = 0
	maxAmmo = 0

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

	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT, .proc/on_alt_click)
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, .proc/ManagerExaminate)

/obj/machinery/computer/camera_advanced/manager/sephirah/clickedemployee()
	return

/obj/machinery/computer/camera_advanced/manager/sephirah/recharge_meltdown()
	return
