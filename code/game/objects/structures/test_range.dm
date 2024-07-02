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
	//Blacklist for abnormalities that will teleport to the facility, or might cause problems
	var/list/blacklist = list(/mob/living/simple_animal/hostile/abnormality/greed_king,
				/mob/living/simple_animal/hostile/abnormality/alriune,
				/mob/living/simple_animal/hostile/abnormality/crying_children,
				/mob/living/simple_animal/hostile/abnormality/pale_horse,
				/mob/living/simple_animal/hostile/abnormality/faelantern,
				/mob/living/simple_animal/hostile/abnormality/road_home,
				/mob/living/simple_animal/hostile/abnormality/snow_whites_apple,
				/mob/living/simple_animal/hostile/abnormality/space_lady,
				/mob/living/simple_animal/hostile/abnormality/hatred_queen,
				/mob/living/simple_animal/hostile/abnormality/despair_knight,
				/mob/living/simple_animal/hostile/abnormality/porccubus,
				/mob/living/simple_animal/hostile/abnormality/rose_sign, //Just placing this here just in case it manages to cause the Agents be in danger.
				/mob/living/simple_animal/hostile/abnormality/nihil, //Might Cause issues
				/mob/living/simple_animal/hostile/abnormality/wrath_servant, //Will likely cause problems with Hermit.
				/mob/living/simple_animal/hostile/abnormality/highway_devotee //You literally can't fight it.
				)

/obj/machinery/computer/testrangespawner/attack_hand(mob/living/user)
	. = ..()
	var/list/fightlist = list()
	var/list/starting_list = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/A in starting_list)
		var/mob/living/simple_animal/hostile/abnormality/abnocheck = A
		if(!abnocheck.can_breach)
			continue
		if(abnocheck in blacklist)
			continue
		fightlist += abnocheck
	var/mob/living/simple_animal/hostile/abnormality/chosen_abno = tgui_input_list(user,"Choose which Abnormality to fight.","Select Abnormality", fightlist)
	var/turf/location = locate(13,14,6) //Might not be the best way to set it up right now but it works.
	if(chosen_abno)
		var/mob/living/simple_animal/hostile/abnormality/abnospawned = new chosen_abno(location)
		abnospawned.core_enabled = FALSE
