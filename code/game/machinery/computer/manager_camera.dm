/obj/machinery/computer/camera_advanced/manager
	name = "managerial camera console"
	desc = "A computer used for remotely handling a facility."
	icon_screen = "mechpad"
	icon_keyboard = "generic_key"
	var/datum/action/innate/door_bolt/bolt_action
	var/datum/action/innate/healthheal/hpbullet
	var/datum/action/innate/sanityheal/spbullet
	var/datum/action/innate/redshield/rshield
	var/datum/action/innate/whiteshield/wshield
	var/datum/action/innate/blackshield/bshield
	var/datum/action/innate/paleshield/pshield
	var/datum/action/innate/slowdown/abnoslowdown
	var/ammo = 0
	var/maxAmmo = 5

/obj/machinery/computer/camera_advanced/manager/Initialize(mapload)
	. = ..()
	bolt_action = new
	hpbullet = new
	spbullet = new
	rshield = new
	wshield = new
	bshield = new
	pshield = new
	abnoslowdown = new

/obj/machinery/computer/camera_advanced/manager/GrantActions(mob/living/carbon/user)
	..()

	if(bolt_action)
		bolt_action.Grant(user)
		actions += bolt_action

	if(hpbullet)
		hpbullet.target = src
		hpbullet.Grant(user)
		actions += hpbullet

	if(spbullet)
		spbullet.target = src
		spbullet.Grant(user)
		actions += spbullet

	if(rshield)
		rshield.target = src
		rshield.Grant(user)
		actions += rshield

	if(wshield)
		wshield.target = src
		wshield.Grant(user)
		actions += wshield

	if(bshield)
		bshield.target = src
		bshield.Grant(user)
		actions += bshield

	if(pshield)
		pshield.target = src
		pshield.Grant(user)
		actions += pshield

	if(abnoslowdown)
		abnoslowdown.target = src
		abnoslowdown.Grant(user)
		actions += abnoslowdown

/obj/machinery/computer/camera_advanced/manager/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/managerbullet) && ammo <= maxAmmo)
		ammo++
		to_chat(user, "<span class='notice'>You load [O] in to the [src]. It now has [ammo] bullets stored.</span>")
		qdel(O)
		return
	..()

/datum/action/innate/door_bolt
	name = "Bolt Airlock"
	icon_icon = 'icons/mob/actions/actions_construction.dmi'
	button_icon_state = "airlock_select"

/datum/action/innate/door_bolt/Activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control

	var/turf/T = get_turf(remote_eye)
	for(var/obj/machinery/door/airlock/A in T.contents)
		if(A.locked)
			A.unbolt()
		else
			A.bolt()

/datum/action/innate/healthheal
	name = "HP-N Bullet"
	desc = "These bullets speed up the recovery of an employee."
	icon_icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	button_icon_state = "fortitude_icon"

/datum/action/innate/healthheal/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		for(var/mob/living/carbon/human/H in T.contents)
			H.adjustBruteLoss(-10)
			X.ammo--
			to_chat(owner, "<span class='warning'>BLAM.</span>")
			return
	if(X.ammo <= 0)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
	else
		to_chat(owner, "<span class='warning'>NO TARGET.</span>")
		return

/datum/action/innate/sanityheal
	name = "SP-E Bullet"
	desc = "Bullets that inject an employee with diluted Enkephalin."
	icon_icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	button_icon_state = "prudence_icon"

/datum/action/innate/sanityheal/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		for(var/mob/living/carbon/human/H in T.contents)
			H.adjustSanityLoss(10)
			X.ammo--
			to_chat(owner, "<span class='warning'>BLAM.</span>")
			return
	if(X.ammo <= 0)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
	else
		to_chat(owner, "<span class='warning'>NO TARGET.</span>")
		return

/datum/action/innate/redshield
	name = "Physical Intervention Shield"
	desc = "Attach a RED DAMAGE forcefield onto a employee."
	icon_icon = 'icons/obj/ammo.dmi'
	button_icon_state = "sleeper-live"


/datum/action/innate/redshield/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		for(var/mob/living/carbon/human/H in T.contents)
			H.apply_status_effect(/datum/status_effect/interventionshield)
			X.ammo--
	if(X.ammo <= 0)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")

/datum/action/innate/whiteshield
	name = "Trauma Shield"
	desc = "Temporarily slow down the perception of a employee, allowing them to resist WHITE DAMAGE."
	icon_icon = 'icons/obj/ammo.dmi'
	button_icon_state = "sleeper-live"


/datum/action/innate/whiteshield/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		for(var/mob/living/carbon/human/H in T.contents)
			H.apply_status_effect(/datum/status_effect/interventionshield/white)
			X.ammo--
	if(X.ammo <= 0)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")

/datum/action/innate/blackshield
	name = "Erosion Shield"
	desc = "Attach a shield that protects an employees flesh from BLACK DAMAGE type attacks."
	icon_icon = 'icons/obj/ammo.dmi'
	button_icon_state = "sleeper-live"

/datum/action/innate/blackshield/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		for(var/mob/living/carbon/human/H in T.contents)
			H.apply_status_effect(/datum/status_effect/interventionshield/black)
			X.ammo--
	if(X.ammo <= 0)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")

/datum/action/innate/paleshield
	name = "Pale Shield"
	desc = "Through poorly understood technology you attach a shield to a employees soul."
	icon_icon = 'icons/obj/ammo.dmi'
	button_icon_state = "sleeper-live"


/datum/action/innate/paleshield/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		for(var/mob/living/carbon/human/H in T.contents)
			H.apply_status_effect(/datum/status_effect/interventionshield/pale)
			X.ammo--
	if(X.ammo <= 0)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")

/datum/action/innate/slowdown
	name = "Qliphoth Intervention Field"
	desc = "Overload a abnormalities Qliphoth Control to reduce their movement."
	icon_icon = 'icons/obj/ammo.dmi'
	button_icon_state = "sleeper-live"

/datum/action/innate/slowdown/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/turf/T = get_turf(remote_eye)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	if(X.ammo >= 1)
		for(var/mob/living/simple_animal/hostile/abnormality/ABNO in T.contents)
			ABNO.apply_status_effect(/datum/status_effect/qliphothoverload)
			X.ammo--
			to_chat(owner, "<span class='warning'>BLAM.</span>")
			return
	if(X.ammo <= 0)
		to_chat(owner, "<span class='warning'>AMMO RESERVE EMPTY.</span>")
	else
		to_chat(owner, "<span class='warning'>NO TARGET.</span>")
		return


