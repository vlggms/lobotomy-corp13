// EGO Printer
/obj/machinery/ego_printer
	name = "EGO printer"
	desc = "This device is capable of printing most EGO on demand."
	icon = 'icons/obj/machines/droneDispenser.dmi'
	icon_state = "on"
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/ego_printer/attack_hand(mob/living/user)
	. = ..()
	var/list/ego_list = list()
	for(var/path in subtypesof(/datum/ego_datum))
		var/datum/ego_datum/ego = path
		if(ego.item_path != /obj/item/ego_weapon/sorrow)
			ego_list += initial(ego.item_path)
		else
			continue
	user.playsound_local(user, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/chosen_ego = tgui_input_list(user,"Which EGO do you want to print","Select EGO", ego_list)
	if(!chosen_ego)
		user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
		to_chat(user, span_warning("No EGO was specified."))
		return
	new chosen_ego((get_turf(user)))
	to_chat(user, span_nicegreen("You successfully printed the EGO."))

//Abnormality Spawner
/obj/machinery/computer/testrangespawner
	name = "Abnormality Spawner"
	desc = "This device is used to spawn an abnormality to fight"
	resistance_flags = INDESTRUCTIBLE
	var/list/whitelist = list(
		/mob/living/simple_animal/hostile/abnormality/forsaken_murderer,
		/mob/living/simple_animal/hostile/abnormality/redblooded,
		/mob/living/simple_animal/hostile/abnormality/pinocchio,
		/mob/living/simple_animal/hostile/abnormality/funeral,
		/mob/living/simple_animal/hostile/abnormality/scarecrow,
		/mob/living/simple_animal/hostile/abnormality/blue_shepherd,
		/mob/living/simple_animal/hostile/abnormality/ebony_queen,
		/mob/living/simple_animal/hostile/abnormality/judgement_bird,
		/mob/living/simple_animal/hostile/abnormality/warden,
		/mob/living/simple_animal/hostile/abnormality/nothing_there,
		/mob/living/simple_animal/hostile/abnormality/silentorchestra,
		/mob/living/simple_animal/hostile/abnormality/last_shot,
		/mob/living/simple_animal/hostile/abnormality/distortedform,
	)

/obj/machinery/computer/testrangespawner/attack_hand(mob/living/user)
	. = ..()
	var/arena_z = z + 3
	var/mob/living/simple_animal/hostile/abnormality/chosen_abno = tgui_input_list(user,"Choose which Abnormality to fight.","Select Abnormality", whitelist)
	var/turf/location = locate(13,14,arena_z) //Might not be the best way to set it up right now but it works.
	if(chosen_abno)
		var/mob/living/simple_animal/hostile/abnormality/abnospawned = new chosen_abno(location)
		abnospawned.core_enabled = FALSE
		if(istype(abnospawned, /mob/living/simple_animal/hostile/abnormality/pinocchio)) //To check if BreachEffect() is needed for the abno to work properly
			abnospawned.BreachEffect()

/obj/machinery/computer/testrangespawner/process()
	var/area/A = get_area(src)
	for(var/mob/living/carbon/human/H in A)
		if(H.stat != DEAD)
			return
	for(var/mob/M in A)
		if(M.stat != DEAD)
			qdel(M)
