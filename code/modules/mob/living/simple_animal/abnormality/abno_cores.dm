/obj/structure/abno_core
	name = "blank abnormality core"
	desc = "You shouldn't be seeing this. Please let someone know!"
	icon = 'ModularTegustation/Teguicons/abno_cores/zayin.dmi'
	icon_state = ""//blank icon states exist for each risk level.
	anchored = FALSE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	base_pixel_x = -16
	pixel_x = -16
	var/mob/living/simple_animal/hostile/abnormality/contained_abno
	var/release_time = 420 SECONDS//this is going to be reduced by a minute for every risk level
	var/threat_level
	var/ego_list = list()

/obj/structure/abno_core/proc/Release()
	if(!contained_abno)//Is this core properly generated?
		return
	new contained_abno(get_turf(src))
	qdel(src)
	return TRUE

/obj/structure/abno_core/MouseDrop(over_object)
	if(!Adjacent(over_object) || !Adjacent(usr))
		return
	var/obj/machinery/abno_core_extractor/O = over_object//abno core extractor
	if(istype(O))
		var/response = alert(usr,"Will you extract [src]?","This cannot be reversed.","Yes","No")
		if(response == "Yes" && do_after(usr, 10, O))
			forceMove(get_turf(O))
			O.GrabAnimation()
			Extract()
		return
	var/obj/structure/itemselling/I = over_object//item selling machine
	if(istype(I))
		var/response = alert(usr,"Will you sell [src]?","This cannot be reversed.","Yes","No")
		if(response == "Yes" && do_after(usr, 10, I))
			if(!contained_abno || !threat_level)//is there no risk level or abnormality inside?
				qdel(src)
				return
			var/payment_amt = threat_level * threat_level * 100
			var/obj/item/holochip/holochip = new (get_turf(src), payment_amt)
			usr.put_in_hands(holochip)
			qdel(src)
			return
	var/obj/machinery/abno_core_seller/P = over_object//item selling machine
	if(istype(P))//This code requires some serious cleanup.
		var/response = alert(usr,"Will you sell [src]?","This cannot be reversed.","Yes","No")
		if(response == "Yes" && do_after(usr, 10, src))
			if(!contained_abno || !threat_level)//is there no risk level or abnormality inside?
				qdel(src)
				return
			var/payment_amt = threat_level * threat_level * 50//this is awarded to every player. Should be lower than the regular fixer selling machine
			for(var/mob/living/carbon/human/person in GLOB.mob_living_list)
				if(person.stat == DEAD || !person.client)
					continue
				var/obj/structure/closet/supplypod/centcompod/pod = new()
				new /obj/item/holochip(pod, payment_amt)
				pod.explosionSize = list(0,0,0,0)
				to_chat(person, "<span class='nicegreen'>An abnormality core has been shipped to HQ. All employees on site earn a bonus!</span>")
				new /obj/effect/pod_landingzone(get_turf(person), pod)
			qdel(src)

/obj/structure/abno_core/proc/Extract()
	if(!LAZYLEN(GLOB.abnormality_room_spawners) || !contained_abno)
		return
	var/mob/living/simple_animal/hostile/abnormality/A = contained_abno
	var/datum/abnormality/abno_ref = A
	for(abno_ref in SSlobotomy_corp.all_abnormality_datums) //Check if they're already in the facility
		if(abno_ref.abno_path == A)
			for(var/mob/living/carbon/human/H in livinginview(1, src))
				to_chat(H, span_boldwarning("This abnormality is already contained!"))
			return FALSE//If the abnormality already exists in a cell, the proc returns early here.
	anchored = TRUE
	icon_state = ""
	animate(src, alpha = 1,pixel_x = -16, pixel_z = 32, time = 3 SECONDS)
	playsound(src,'ModularTegustation/Tegusounds/abno_extract.ogg', 50, 5)
	sleep(3 SECONDS)
	//FIXME: Causes a runtime for abnormalities with spawn disabled
	SSabnormality_queue.queued_abnormality = contained_abno
	SSabnormality_queue.SpawnAbno()

	log_admin("[key_name(usr)] has spawned [contained_abno].")
	message_admins("[key_name(usr)] has spawned [contained_abno].")

	SSblackbox.record_feedback("nested tally", "core_spawn_abnormality", 1, list("Initiated Spawn Abnormality", "[SSabnormality_queue.queued_abnormality]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


	qdel(src)

/obj/machinery/abno_core_extractor
	name = "abnormality core containment unit"
	desc = "A device used to transfer abnormalities into containment cells."
	icon = 'ModularTegustation/Teguicons/lc13_structures_64x64.dmi'
	icon_state = "extraction"
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = 16
	base_pixel_y = 16
	density = FALSE
	layer = ABOVE_ALL_MOB_LAYER

/obj/machinery/abno_core_extractor/proc/GrabAnimation()
	flick("extraction_closed", src)
	animate(src, pixel_y = 56, time = 3 SECONDS, loop = 1, ANIMATION_RELATIVE)
	animate(pixel_y = initial(pixel_y), time = 1 SECONDS, ANIMATION_RELATIVE)

/obj/machinery/abno_core_seller
	name = "abnormality core telepad"
	desc = "A device using W corp technology to bring abnormality cores to the company headquarters."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "broadcaster"
	density = TRUE
