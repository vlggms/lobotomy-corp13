#define STATUS_EFFECT_RUMOR /datum/status_effect/display/rumor

//Hand of Babel
/mob/living/simple_animal/hostile/abnormality/branch12/babel
	name = "Hand of Babel"
	desc = "They reached for the stars, only for them to be pulled beyond their reach."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "babel"
	icon_living = "babel"
	blood_volume = 0
	threat_level = WAW_LEVEL
	start_qliphoth = 0
	can_breach = FALSE
	max_boxes = 20
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 45, 45),
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 40, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 50, 50, 60, 60),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 25, 35, 35),
	)
	work_damage_amount = 7
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/rumor,
		/datum/ego_datum/armor/branch12/rumor,
	)
	//gift_type =  /datum/ego_gifts/rumor
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


	//Who is affected by rumor
	var/list/rumors = list()
	var/minrumors = 7

/mob/living/simple_animal/hostile/abnormality/branch12/babel/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	user.apply_status_effect(STATUS_EFFECT_RUMOR)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/babel/Life()
	. = ..()
	if(!length(rumors))
		return
	var/total_agents = 0
	for(var/mob/player in GLOB.player_list)
		if(isliving(player) && (player.mind?.assigned_role in GLOB.security_positions))
			total_agents += 1
	if(length(rumors) >= minrumors || length(rumors) >= total_agents)
		Create_Evil()

/mob/living/simple_animal/hostile/abnormality/branch12/babel/proc/Create_Evil()
	var/mob/living/M = pick(rumors)
	var/location = get_turf(M)
	var/mob/living/simple_animal/hostile/rumor/evil = new (location)
	var/obj/item/radio/headset/radio = M.get_item_by_slot(ITEM_SLOT_EARS)
	if(radio)
		radio.forceMove(get_turf(M))
	ADD_TRAIT(M, TRAIT_NOBREATH, type)
	ADD_TRAIT(M, TRAIT_INCAPACITATED, type)
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, type)
	ADD_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	M.forceMove(evil)
	for(var/mob/living/H in rumors)
		H.remove_status_effect(STATUS_EFFECT_RUMOR)


// Rumor Effect
/datum/status_effect/display/rumor
	id = "rumor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "rumor"
	var/heal_amount = 2
	var/mob/living/simple_animal/hostile/abnormality/branch12/babel/connected_abno

/datum/status_effect/display/rumor/on_apply()
	. = ..()
	if(ishuman(owner))
		to_chat(owner, span_nicegreen("You have heard the rumor, and it must be spread"))
		var/mob/living/carbon/human/H = owner
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/branch12/babel) in GLOB.abnormality_mob_list
		connected_abno.rumors |= H


/datum/status_effect/display/rumor/tick()
	. = ..()
	for(var/mob/living/carbon/human/H in view(4, src))
		if(H == owner)
			continue
		if(prob(5))
			owner.say("We must seek the great Tower of Babel...")
			H.apply_status_effect(STATUS_EFFECT_RUMOR)
			H.say("Where might it be?")
			to_chat(owner, span_nicegreen("You spread the word of the Tower of Babel."))

	var/mob/living/carbon/human/M = owner
	M.adjustBruteLoss(-heal_amount) // It heals everyone a bit every 2 seconds.
	M.adjustSanityLoss(-heal_amount) // It heals everyone a bit every 2 seconds.


/datum/status_effect/display/rumor/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		connected_abno.rumors -= H


//Her friend
/mob/living/simple_animal/hostile/rumor
	name = "A Rumor of the Stars"
	desc = "The sky once seemed nearly in our reach."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "rumor"
	icon_living = "rumor"
	maxHealth = 2600
	health = 2600
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	melee_damage_lower = 10
	melee_damage_upper = 20
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	del_on_death = FALSE

/mob/living/simple_animal/hostile/rumor/AttackingTarget(atom/attacked_target) //checking it's ideas and executing them
	..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target

	//apply a random debuff
	switch(rand(1,5))
		if(1) //from dangle
			H.hallucination += 10
		if(2) //kill their eyes
			H.adjust_blurriness(15)
		if(3) //kill their legs
			H.set_confusion(10)
		if(4) //bleed
			H.apply_lc_bleed(30)
		if(5) //knock them down, from smile without the weapon drop
			H.Knockdown(20)

/mob/living/simple_animal/hostile/rumor/death(gibbed)
	FreeCursed()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/rumor/proc/FreeCursed()
	var/spew_turf = pick(get_adjacent_open_turfs(src))
	for(var/atom/movable/i in contents)
		if(isliving(i))
			var/mob/living/L = i
			if(!L.client)
				dropHardClothing(L, spew_turf)
				qdel(L)
				continue
			L.Knockdown(10, FALSE)
			REMOVE_TRAIT(L, TRAIT_NOBREATH, type)
			REMOVE_TRAIT(L, TRAIT_INCAPACITATED, type)
			REMOVE_TRAIT(L, TRAIT_IMMOBILIZED, type)
			REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, type)
		i.forceMove(spew_turf)

#undef STATUS_EFFECT_RUMOR
