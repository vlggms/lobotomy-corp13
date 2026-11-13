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
	var/release_time = 420 SECONDS //this is going to be reduced by a minute for every risk level
	var/threat_level
	var/ego_list = list()
	var/extracting = FALSE
	var/datum/abnormality/datum_reference = null // Was this spawned in a cell?
	var/opened = FALSE // An employee decided to release us early
	var/closed = FALSE // An employee delayed this abnormality's spawn
	var/obj/effect/bar = null // Progress bar for opening.
	var/progress = 0 // Used to manipulate/manage progress bar
	var/respawning = FALSE
	var/list/core_whitelist = list(
	/mob/living/simple_animal/hostile/abnormality/training_rabbit,
	/mob/living/simple_animal/hostile/abnormality/bill,
	/mob/living/simple_animal/hostile/abnormality/cube,
	/mob/living/simple_animal/hostile/abnormality/fairy_swarm,
	/mob/living/simple_animal/hostile/abnormality/shadow
	)

/obj/structure/abno_core/proc/Release()
	if(datum_reference)
		datum_reference.RespawnAbno()
		if(!respawning)
			datum_reference.PostSpawnAbno()
		if(bar)
			qdel(bar)
		qdel(src)
		return
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
			if(extracting)
				return
			extracting = TRUE
			forceMove(get_turf(O))
			O.GrabAnimation()
			Extract()
		extracting = FALSE
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

	var/obj/machinery/abno_core_seller/P = over_object//Abnocore selling machine
	if(istype(P))
		var/response = alert(usr,"Will you sell [src]?","This cannot be reversed.","Yes","No")
		if(response == "Yes" && do_after(usr, 10, src))
			if(!contained_abno || !threat_level)//is there no risk level or abnormality inside?
				qdel(src)
				return
			var/payment_amt = threat_level * threat_level * 50//this is awarded to every player
			var/list/typecache_bank = typecacheof(list(/datum/bank_account/department, /datum/bank_account/remote))//similar loop to the market report
			for(var/i in SSeconomy.bank_accounts_by_id)
				var/datum/bank_account/current_acc = SSeconomy.bank_accounts_by_id[i]
				if(typecache_bank[current_acc.type])
					continue
				var/datum/bank_account/B = SSeconomy.bank_accounts_by_id["[i]"]
				if(B)
					B.adjust_money(payment_amt)
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				to_chat(H, span_notice("[payment_amt] ahn has been deposited into your account."))
			sound_to_playing_players('sound/weapons/ego/executive_reload.ogg', 70, FALSE)
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

/obj/structure/abno_core/proc/Countdown() // Egg starts opening up, unused outside of cells currently.
	set waitfor = FALSE
	var/progress_interval = round(release_time * 0.05) // Progress in pixel-sized chunks of time
	if((datum_reference.abno_path in core_whitelist) && !respawning) // For training dummy and the tutorial abnos to not spawn boxed in
		release_time = 5 SECONDS // So basically, instant.
		progress_interval = 1 SECONDS
	if(!bar)
		bar = new(get_turf(src))
	bar.icon = 'icons/effects/progessbar.dmi'
	bar.icon_state = "prog_bar_0"
	bar.plane = ABOVE_HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	bar.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	bar.alpha = 0
	animate(bar, pixel_y = 48, alpha = 255, time = 10, easing = SINE_EASING)
	while(progress <= release_time && !opened)
		sleep(progress_interval)
		progress += progress_interval
		bar.icon_state = "prog_bar_[round(((progress / release_time) * 100), 5)]"
	if(opened)
		return
	Release()

// This code handles player interactions for cores contained in a cell after arrival.
/obj/structure/abno_core/attack_hand(mob/living/carbon/human/user)
	if(!datum_reference || opened || respawning)
		return ..()
	. = ..()
	var/list/choice_icons = list()
	if(closed)
		choice_icons = list(
		"key" = image(icon = 'ModularTegustation/Teguicons/teguitems.dmi', icon_state = "key_active")
	)
	else
		choice_icons = list(
			"key" = image(icon = 'ModularTegustation/Teguicons/teguitems.dmi', icon_state = "key_active"),
			"lock"  = image(icon = 'ModularTegustation/Teguicons/teguitems.dmi', icon_state = "lock_active"),
		)
	choice_icons = sortList(choice_icons)
	var/choice = show_radial_menu(user, src, choice_icons, custom_check = CALLBACK(src, PROC_REF(CheckMenu), user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	if(choice == "key")
		playsound(get_turf(src), 'sound/machines/closet_open.ogg', 100, TRUE, 3)
		opened = TRUE
		// So we need to speed up ordeal timelock and next abno spawn here. We subtract whatever time is left on the core and use 30 seconds as a buffer.
		// Our formula is (release_time - progress) - 30s
		var/decrement = (release_time - progress)
		if(decrement >= 30 SECONDS)
			decrement -= 30 SECONDS
			SSabnormality_queue.next_abno_spawn -= decrement
			for(var/i=1,i<=SSlobotomy_corp.ordeal_timelock.len,i++)
				SSlobotomy_corp.ordeal_timelock[i] -= decrement
		Release()
		return
	else
		closed = TRUE
		playsound(get_turf(src), 'sound/machines/door_locked.ogg', 100, TRUE, 3)
		color = COLOR_RED
		// Add our extra time to ordeal timelocks and the abnormality queue, this effectively delays round progression.
		SSabnormality_queue.next_abno_spawn += release_time
		for(var/i=1,i<=SSlobotomy_corp.ordeal_timelock.len,i++)
			SSlobotomy_corp.ordeal_timelock[i] += release_time
		release_time *= 2
		bar.icon_state = "prog_bar_[round(((progress / release_time) * 100), 5)]"

// Sanity check for radial menu
/obj/structure/abno_core/proc/CheckMenu(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

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
