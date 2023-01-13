/obj/machinery/computer/camera_advanced/manager
	name = "managerial camera console"
	desc = "A computer used for remotely handling a facility."
	icon_screen = "mechpad"
	icon_keyboard = "generic_key"
	var/datum/action/innate/cyclemanagerbullet/cycle
	var/datum/action/innate/firemanagerbullet/fire
	var/datum/action/innate/cyclecommand/cyclecommand
	var/datum/action/innate/managercommand/command
	var/ammo = 6
	var/maxAmmo = 5
	var/bullettype = 0
	var/commandtype = 1
	var/command_delay = 0.5 SECONDS
	var/command_cooldown
	var/static/list/commandtypes = typecacheof(list(
		/obj/effect/temp_visual/commandMove,
		/obj/effect/temp_visual/commandWarn,
		/obj/effect/temp_visual/commandGaurd,
		/obj/effect/temp_visual/commandHeal,
		/obj/effect/temp_visual/commandFightA,
		/obj/effect/temp_visual/commandFightB
		))

/obj/machinery/computer/camera_advanced/manager/Initialize(mapload)
	. = ..()
	cycle = new
	fire = new
	cyclecommand = new
	command = new

	command_cooldown = world.time
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/recharge_meltdown)

/obj/machinery/computer/camera_advanced/manager/examine(mob/user)
	. = ..()
	if(ammo)
		. += "<span class='notice'>It has [ammo] BULLETS loaded.</span>"

/obj/machinery/computer/camera_advanced/manager/GrantActions(mob/living/carbon/user)
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
	UnregisterSignal(user, COMSIG_MOB_MIDDLECLICKON)
	UnregisterSignal(user, COMSIG_MOB_SHIFTCLICKON)
	..()

/obj/machinery/computer/camera_advanced/manager/proc/on_hotkey_click(datum/source, atom/clicked_atom) //system control for hotkeys
	SIGNAL_HANDLER
	if(!isliving(clicked_atom))
		return
	if(ishuman(clicked_atom))
		clickedemployee(source, clicked_atom)
		return
	if(isabnormalitymob(clicked_atom))
		clickedabno(source, clicked_atom)
		return

/obj/machinery/computer/camera_advanced/manager/proc/clickedemployee(mob/living/owner, mob/living/carbon/employee) //contains carbon copy code of fire action
	if(ammo >= 1)
		var/mob/living/carbon/human/H = employee
		switch(bullettype)
			if(1)
				H.adjustBruteLoss(-0.15*H.maxHealth)
			if(2)
				H.adjustSanityLoss(0.15*H.maxSanity)
			if(3)
				H.apply_status_effect(/datum/status_effect/interventionshield)
			if(4)
				H.apply_status_effect(/datum/status_effect/interventionshield/white)
			if(5)
				H.apply_status_effect(/datum/status_effect/interventionshield/black)
			if(6)
				H.apply_status_effect(/datum/status_effect/interventionshield/pale)
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

	if(istype(clicked_atom, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/monster = clicked_atom
		if(!LAZYLEN(monster.damage_coeff))
			return

		to_chat(user, "<span class='notice'>[clicked_atom]'s resistances are : </span>")
		var/list/damage_types = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
		for(var/i in damage_types)
			var/resistance = monster.damage_coeff[i]
			if(isnull(resistance))
				continue

//I could use the standard roman numeral system, but I prefer making the resistances more like records.
			switch(resistance)
				if(-INFINITY to -0.1)
					resistance = "Absorbed"
				if(0)
					resistance = "Immune"
				if(0 to 0.5)
					resistance = "Endured"
				if(0.5 to 0.9)
					resistance = "Resistant"
				if(0.9 to 1)
					resistance = "Normal"
				if(1 to 1.5)
					resistance = "Weak"
				if(1.5 to INFINITY)
					resistance = "Fatal"
			to_chat(user, "<span class='notice'>[i] : [resistance].</span>")

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

/datum/action/innate/cyclemanagerbullet
	name = "Cycle Bullet Type"
	desc = "Welfare apologizes for any complications with the technology."
	icon_icon = 'icons/obj/ammo.dmi'
	button_icon_state = "40mm"

/datum/action/innate/cyclemanagerbullet/Activate()
	var/obj/machinery/computer/camera_advanced/manager/X = target
	playsound(get_turf(src), 'sound/weapons/kenetic_reload.ogg', 10, 0, 3)
	switch(X.bullettype)
		if(0) //if 0 change to 1
			to_chat(owner, "<span class='notice'>HP-N BULLET INITIALIZED.</span>")
			name = "HP-N Bullet"
			desc = "These bullets speed up the recovery of an employee."
			X.alterbullettype(1)
		if(1)
			to_chat(owner, "<span class='notice'>SP-E BULLET INITIALIZED.</span>")
			name = "SP-E Bullet"
			desc = "Bullets that inject an employee with diluted Enkephalin."
			X.alterbullettype(1)
		if(2)
			to_chat(owner, "<span class='notice'>RED BULLET INITIALIZED.</span>")
			name = "Physical Intervention Shield"
			desc = "Attach a RED DAMAGE forcefield onto a employee."
			X.alterbullettype(1)
		if(3)
			to_chat(owner, "<span class='notice'>WHITE BULLET INITIALIZED.</span>")
			name = "Trauma Shield"
			desc = "Temporarily slow down the perception of a employee, allowing them to resist WHITE DAMAGE."
			X.alterbullettype(1)
		if(4)
			to_chat(owner, "<span class='notice'>BLACK BULLET INITIALIZED.</span>")
			name = "Erosion Shield"
			desc = "Attach a shield that protects an employees flesh from BLACK DAMAGE type attacks."
			X.alterbullettype(1)
		if(5)
			to_chat(owner, "<span class='notice'>PALE BULLET INITIALIZED.</span>")
			name = "Pale Shield"
			desc = "Through poorly understood technology you attach a shield to a employees soul."
			X.alterbullettype(1)
		if(6)
			to_chat(owner, "<span class='notice'>YELLOW BULLET INITIALIZED.</span>")
			name = "Qliphoth Intervention Field"
			desc = "Overload a abnormalities Qliphoth Control to reduce their movement."
			X.alterbullettype(1)
		else
			X.alterbullettype(-6)
			to_chat(owner, "<span class='notice'>HP-N BULLET INITIALIZED.</span>")
			name = "HP-N Bullet"
			desc = "These bullets speed up the recovery of an employee."

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
			if(1 to 6)
				for(var/mob/living/carbon/human/H in range(0, T))
					switch(X.bullettype)
						if(1)
							H.adjustBruteLoss(-0.15*H.maxHealth)
						if(2)
							H.adjustSanityLoss(0.15*H.maxSanity)
						if(3)
							H.apply_status_effect(/datum/status_effect/interventionshield) //shield status effects located in lc13unique items.
						if(4)
							H.apply_status_effect(/datum/status_effect/interventionshield/white)
						if(5)
							H.apply_status_effect(/datum/status_effect/interventionshield/black)
						if(6)
							H.apply_status_effect(/datum/status_effect/interventionshield/pale)
						else
							to_chat(owner, "<span class='warning'>ERROR: BULLET INITIALIZATION FAILURE.</span>")
							return
					X.ammo--
					playsound(get_turf(C), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
					playsound(get_turf(T), 'ModularTegustation/Tegusounds/weapons/guns/manager_shock.ogg', 10, 0, 3)
					to_chat(owner, "<span class='warning'>Loading [X.ammo] Bullets.</span>")
					return
			if(7)
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
