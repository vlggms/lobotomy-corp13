/obj/item/organ/body_egg/cuckoospawn_embryo
	name = "cuckoospawn embryo"
	icon = 'icons/mob/cuckoospawn.dmi'
	icon_state = "parasitispawn_dead"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/toxin/acid = 10)
	///What stage of growth the embryo is at. Developed embryos give the host symptoms suggesting that an embryo is inside them.
	var/stage = 0
	/// Are we bursting out of the poor sucker who's the xeno mom?
	var/bursting = FALSE
	/// How long does it take to advance one stage? Growth time * 5 = how long till we make a Larva!
	var/growth_time = 1.2 MINUTES

/obj/item/organ/body_egg/cuckoospawn_embryo/Initialize()
	. = ..()
	advance_embryo_stage()

/obj/item/organ/body_egg/cuckoospawn_embryo/on_find(mob/living/finder)
	..()
	if(stage < 5)
		to_chat(finder, span_notice("It's small and weak, barely the size of a foetus."))
	else
		to_chat(finder, span_notice("It's grown quite large, and writhes slightly as you look at it."))
		if(prob(10))
			AttemptGrow()

/obj/item/organ/body_egg/cuckoospawn_embryo/on_life()
	. = ..()
	switch(stage)
		if(2, 3)
			if(prob(2))
				owner.emote("sneeze")
			if(prob(2))
				owner.emote("cough")
			if(prob(2))
				to_chat(owner, span_danger("Your throat feels sore."))
			if(prob(2))
				to_chat(owner, span_danger("Mucous runs down the back of your throat."))
		if(4)
			if(prob(4))
				owner.emote("sneeze")
			if(prob(4))
				owner.emote("cough")
			if(prob(4))
				to_chat(owner, span_danger("Your muscles ache."))
				if(prob(20))
					owner.take_bodypart_damage(1)
			if(prob(4))
				to_chat(owner, span_danger("Your stomach hurts."))
		if(5)
			if(prob(4))
				owner.emote("sneeze")
			if(prob(4))
				owner.emote("cough")
			if(prob(8))
				to_chat(owner, span_danger("Your muscles ache."))
				if(prob(50))
					owner.take_bodypart_damage(5)
			if(prob(10))
				to_chat(owner, span_danger("Your stomach heavily hurts."))
				if(ishuman(owner))
					var/mob/living/carbon/human/pained_human = owner
					pained_human.adjustStaminaLoss(5)
		if(6)
			to_chat(owner, span_danger("You feel something tearing its way out of your chest..."))
			owner.take_bodypart_damage(10)
			if(prob(10))
				owner.emote("stomach unnaturally chirps")

/// Controls Xenomorph Embryo growth. If embryo is fully grown (or overgrown), stop the proc. If not, increase the stage by one and if it's not fully grown (stage 6), add a timer to do this proc again after however long the growth time variable is.
/obj/item/organ/body_egg/cuckoospawn_embryo/proc/advance_embryo_stage()
	if(owner == DEAD)
		addtimer(CALLBACK(src, PROC_REF(advance_embryo_stage)), growth_time)
		return
	if(stage >= 6)
		return
	if(++stage < 6)
		INVOKE_ASYNC(src, PROC_REF(RefreshInfectionImage))
		addtimer(CALLBACK(src, PROC_REF(advance_embryo_stage)), growth_time)


/obj/item/organ/body_egg/cuckoospawn_embryo/egg_process()
	if(stage == 6 && prob(50))
		for(var/datum/surgery/S in owner.surgeries)
			if(S.location == BODY_ZONE_CHEST && istype(S.get_surgery_step(), /datum/surgery_step/manipulate_organs))
				AttemptGrow()
				return
		AttemptGrow()

/obj/item/organ/body_egg/cuckoospawn_embryo/proc/AttemptGrow()
	if(!owner || bursting)
		return

	bursting = TRUE

	var/list/candidates = pollGhostCandidates("Do you want to play as an cuckoospawn parasite that will burst out of [owner.real_name]?", ROLE_ALIEN, null, null, 100, POLL_IGNORE_ALIEN_LARVA)

	if(QDELETED(src) || QDELETED(owner))
		return

	if(!candidates.len || !owner)
		GrowingSimple()
	else
		var/mob/dead/observer/ghost = pick(candidates)
		GrowingCarbon(ghost)

	qdel(src)

/obj/item/organ/body_egg/cuckoospawn_embryo/proc/GrowingSimple()
	var/mutable_appearance/overlay = mutable_appearance('icons/mob/alien.dmi', "burst_lie")
	owner.add_overlay(overlay)

	var/atom/cuckoo_loc = get_turf(owner)
	var/mob/living/simple_animal/hostile/cuckoospawn_parasite/new_cuckoo = new(cuckoo_loc)
	SEND_SOUND(new_cuckoo, sound('sound/voice/hiss5.ogg',0,0,0,100))	//To get the player's attention
	ADD_TRAIT(new_cuckoo, TRAIT_IMMOBILIZED, type) //so we don't move during the bursting animation
	ADD_TRAIT(new_cuckoo, TRAIT_HANDS_BLOCKED, type)
	new_cuckoo.notransform = 1
	new_cuckoo.invisibility = INVISIBILITY_MAXIMUM

	sleep(6)

	if(QDELETED(src) || QDELETED(owner))
		qdel(new_cuckoo)
		CRASH("AttemptGrow failed due to the early qdeletion of source or owner.")

	if(new_cuckoo)
		REMOVE_TRAIT(new_cuckoo, TRAIT_IMMOBILIZED, type)
		REMOVE_TRAIT(new_cuckoo, TRAIT_HANDS_BLOCKED, type)
		new_cuckoo.notransform = 0
		new_cuckoo.invisibility = 0
	new_cuckoo.visible_message(span_danger("[new_cuckoo] wriggles out of [owner]!"), span_userdanger("You exit [owner], your previous host."))
	playsound(owner, 'sound/magic/exit_blood.ogg', 50)
	new /obj/effect/gibspawner/generic(get_turf(owner))
	owner.adjustBruteLoss(240)
	owner.cut_overlay(overlay)

/obj/item/organ/body_egg/cuckoospawn_embryo/proc/GrowingCarbon(mob/dead/observer/newclient)
	var/mutable_appearance/overlay = mutable_appearance('icons/mob/alien.dmi', "burst_lie")
	owner.add_overlay(overlay)

	var/atom/cuckoo_loc = get_turf(owner)
	var/mob/living/simple_animal/hostile/cuckoospawn_parasite/intelligent/new_cuckoo = new(cuckoo_loc)
	new_cuckoo.key = newclient.key
	SEND_SOUND(new_cuckoo, sound('sound/voice/hiss5.ogg',0,0,0,100))	//To get the player's attention
	ADD_TRAIT(new_cuckoo, TRAIT_IMMOBILIZED, type) //so we don't move during the bursting animation
	ADD_TRAIT(new_cuckoo, TRAIT_HANDS_BLOCKED, type)
	new_cuckoo.notransform = 1
	new_cuckoo.invisibility = INVISIBILITY_MAXIMUM

	sleep(6)

	if(QDELETED(src) || QDELETED(owner))
		qdel(new_cuckoo)
		CRASH("AttemptGrow failed due to the early qdeletion of source or owner.")

	if(new_cuckoo)
		REMOVE_TRAIT(new_cuckoo, TRAIT_IMMOBILIZED, type)
		REMOVE_TRAIT(new_cuckoo, TRAIT_HANDS_BLOCKED, type)
		new_cuckoo.notransform = 0
		new_cuckoo.invisibility = 0

	new_cuckoo.visible_message(span_danger("[new_cuckoo] wriggles out of [owner]!"), span_userdanger("You exit [owner], your previous host."))
	playsound(owner, 'sound/magic/exit_blood.ogg', 50)
	new /obj/effect/gibspawner/generic(get_turf(owner))
	owner.adjustBruteLoss(240)
	owner.cut_overlay(overlay)

/*----------------------------------------
Proc: AddInfectionImages(C)
Des: Adds the infection image to all aliens for this embryo
----------------------------------------*/
/obj/item/organ/body_egg/cuckoospawn_embryo/AddInfectionImages()
	for(var/mob/living/carbon/alien/alien in GLOB.player_list)
		var/I = image('icons/mob/alien.dmi', loc = owner, icon_state = "infected[stage]")
		alien.client.images += I

/*----------------------------------------
Proc: RemoveInfectionImage(C)
Des: Removes all images from the mob infected by this embryo
----------------------------------------*/
/obj/item/organ/body_egg/cuckoospawn_embryo/RemoveInfectionImages()
	for(var/mob/living/carbon/alien/alien in GLOB.player_list)
		for(var/image/I in alien.client.images)
			var/searchfor = "infected"
			if(I.loc == owner && findtext(I.icon_state, searchfor, 1, length(searchfor) + 1))
				qdel(I)
