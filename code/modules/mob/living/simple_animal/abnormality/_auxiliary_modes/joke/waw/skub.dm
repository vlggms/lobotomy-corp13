/mob/living/simple_animal/hostile/abnormality/skub
	name = "Skub"
	desc = "It's skub."
	health = 500
	maxHealth = 500
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	icon_living = "skub"
	portrait = "skub"
	can_breach = FALSE
	threat_level = WAW_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = 25,
		ABNORMALITY_WORK_ATTACHMENT = 25,
		ABNORMALITY_WORK_REPRESSION = list(10, 40, 50, 55, 60),
	)

	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	can_patrol = FALSE
	wander = FALSE

	ego_list = list(
		//datum/ego_datum/weapon/pro-skub,
		//datum/ego_datum/weapon/anti-skub,
		//datum/ego_datum/armor/pro-skub,
		//datum/ego_datum/armor/anti-skub,
	)
	//gift_type =  /datum/ego_gifts/skub
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE
	var/list/currently_insane = list()
	var/insanity_counter
	var/riot_cooldown
	var/riot_cooldown_time = 60 SECONDS
	var/list/skub_list = list("PRO_SKUB" = list(), "ANTI_SKUB" = list())
	var/skub_type = "skub"
	var/riot_time = 30 SECONDS

/mob/living/simple_animal/hostile/abnormality/skub/PostSpawn()
	..()

/mob/living/simple_animal/hostile/abnormality/skub/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat == DEAD)
			continue
		UpdateSkub(H)

/mob/living/simple_animal/hostile/abnormality/skub/ZeroQliphoth(mob/living/carbon/human/user)
	..()
	riot_cooldown = world.time + riot_cooldown_time
	var/list/target_list = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat == DEAD)
			continue
		target_list += H
		UpdateSkub(H)
		if(IsProSkub(H))
			to_chat(H, span_boldwarning("Your dedication to [skub_type] reaches a fever pitch!"))
		else
			to_chat(H, span_boldwarning("You can't stop thinking about how much you hate [skub_type]!"))
	sleep(3 SECONDS)
	for(var/mob/living/carbon/human/H in target_list)
		H.adjustSanityLoss(500)
		QDEL_NULL(H.ai_controller)
		if(IsProSkub(H))
			H.ai_controller = /datum/ai_controller/insane/murder/skub
		else
			H.ai_controller = /datum/ai_controller/insane/murder/anti_skub
		H.InitializeAIController()
	addtimer(CALLBACK(src, PROC_REF(StopRiot)), riot_time)

/mob/living/simple_animal/hostile/abnormality/skub/proc/UpdateSkub(mob/living/skubber)
	if(!skubber)
		return
	if(LAZYLEN(skub_list["PRO_SKUB"]) >= LAZYLEN(skub_list["ANTI_SKUB"]))
		skub_list["PRO_SKUB"] |= skubber
		to_chat(skubber, span_boldwarning("You've become pro-[skub_type]!"))
	else
		skub_list["ANTI_SKUB"] |= skubber
		to_chat(skubber, span_boldwarning("You've become anti-[skub_type]!"))
		return

/mob/living/simple_animal/hostile/abnormality/skub/proc/IsProSkub(mob/living/skubber)
	if(!skubber in skub_list)
		UpdateSkub(skubber)
	if(skubber in skub_list["PRO_SKUB"])
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/skub/proc/StopRiot()
	say("stopping the riot!")
	for(var/mob/living/carbon/human/H in skub_list["PRO_SKUB"])
		H.adjustSanityLoss(-500)
	for(var/mob/living/carbon/human/H in skub_list["ANTI_SKUB"])
		H.adjustSanityLoss(-500)
	datum_reference.qliphoth_change(3)

/datum/ai_controller/insane/murder/skub
	lines_type = /datum/ai_behavior/say_line/skub

/datum/ai_behavior/say_line/skub
	lines = list(
		"I LOVE SKUB!",
		"THAT'S MY SKUB!!!",
		"I stand with skub!",
	)

/datum/ai_controller/insane/murder/anti_skub
	lines_type = /datum/ai_behavior/say_line/anti_skub

/datum/ai_behavior/say_line/anti_skub
	lines = list(
		"I HATE FUCKING SKUB!",
		"NO! THAT'S MY SKUB!!!",
		"I'll destroy that skub myself!",
	)

/*
/mob/living/simple_animal/hostile/abnormality/skub/Life()
	. = ..()
	if(!.) // Dead
		return FALSE

	//Count up insane people, add them to the insane list
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H in currently_insane)
			continue

		if(H.sanity_lost)
			insanity_counter++
			currently_insane|=H

	//Remove sane people from the insanity list so we can re-count them.
	for(var/mob/living/carbon/human/H in currently_insane)
		if(!H.sanity_lost)
			currently_insane -= H
*/
