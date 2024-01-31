//A tribute to, and Designed mostly by InsightfulParasite, our lovely spriter. Coded by Kirie Saito.
/mob/living/simple_animal/hostile/abnormality/shrimp_exec
	name = "Shrimp Association Executive"
	desc = "A shrimp in a snazzy suit."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "executive"
	icon_living = "executive"
	faction = list("neutral")
	speak_emote = list("burbles")
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = -100,	//He's a snobby shrimp dude.
	)
	work_damage_amount = 11
	work_damage_type = WHITE_DAMAGE	//He insults you.

	ego_list = list(
		/datum/ego_datum/weapon/executive,
		/datum/ego_datum/armor/executive,
	)
	gift_type =  /datum/ego_gifts/executive

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/wellcheers = 1.5, // I... if you ever get a zayin this far in, good luck.
	)

	var/liked
	var/happy = TRUE
	pet_bonus = "blurbles" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/hint_cooldown
	var/hint_cooldown_time = 30 SECONDS
	var/list/cooldown = list(
		"Stop meandering around and get to work!",
		"I can be quite patient at times, but you are beginning to test me!",
		"The service here can be dreadful at times. Why don't you just make yourself useful?",
	)

	var/list/instinct = list(
		"I am getting quite old, and my back is hurting me. Could you send a chiropractor to my office immediately?",
		"I am quite peckish, could you send me a charcuterie board?",
		"Could you get me a glass of pinot noir, please?",
	)

	var/list/insight = list(
		"Get me my phonograph, I would like to listen to Moonlight Sonata, 1st Movement.",
		"The plants in my office are dying, could you water them please?",
		"It is rather dull, with all the negotiations that we have been doing. Could you get me the morning crossword?",
	)

	var/list/attachment = list(
		"You know, I had this brand new deal that I am setting up. Care to listen sometime?",
		"I was wondering if YOU had any good business offers. It would be nice to hear from a fellow intellectual. Stop by and tell me sometime.",
		"Come, pull up a glass, old friend. Let's drink to a good deal!",
	)

	//A list of shit that it can create. Yes, it includes ego. How did a shrimp get ego? IDFK. I guess his company makes it.
	//Could diversify clerks I guess.
	var/list/dispenseitem= list(
		/obj/item/grenade/spawnergrenade/shrimp,
		/obj/item/grenade/spawnergrenade/shrimp/super,
		/obj/item/gun/ego_gun/pistol/soda,
		/obj/item/gun/ego_gun/sodasmg,
		/obj/item/gun/ego_gun/sodashotty,
		/obj/item/gun/ego_gun/sodarifle,
		/obj/item/clothing/suit/armor/ego_gear/zayin/soda,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
	)

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/WorkChance(mob/living/carbon/human/user, chance)
	if(happy)
		chance+=30
	return chance

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
	var/gift = pick(dispenseitem)
	new gift(dispense_turf)
	say("Here you are, my dear friend. High-quality firepower courtesy of shrimpcorp.")
	return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/ZeroQliphoth(mob/living/carbon/human/user)
	pissed()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == liked || !liked)
		happy = TRUE
	else
		happy = FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	liked = pick(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT)
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/proc/pissed()
	var/turf/W = pick(GLOB.department_centers)
	for(var/turf/T in orange(1, W))
		var/obj/structure/closet/supplypod/extractionpod/pod = new()
		pod.explosionSize = list(0,0,0,0)
		if(prob(70))
			new /mob/living/simple_animal/hostile/shrimp(pod)
		else
			new /mob/living/simple_animal/hostile/shrimp_soldier(pod)

		new /obj/effect/pod_landingzone(T, pod)
		stoplag(2)

//repeat lines
/mob/living/simple_animal/hostile/abnormality/shrimp_exec/funpet()
	if(!liked)
		return
	if(hint_cooldown > world.time)
		say(pick(cooldown))
		return
	hint_cooldown = world.time + hint_cooldown_time
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))
	return

/* Shrimpo boys */
/mob/living/simple_animal/hostile/shrimp
	name = "wellcheers corp liquidation intern"
	desc = "A shrimp that is extremely hostile to you."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers"
	icon_living = "wellcheers"
	faction = list("shrimp")
	health = 400
	maxHealth = 400
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 24
	melee_damage_upper = 27
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("burbles")

//You can put these guys about to guard an area.
/mob/living/simple_animal/hostile/shrimp_soldier
	name = "wellcheers corp hired liquidation officer"
	desc = "A shrimp that is there to guard an area."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	faction = list("shrimp")
	health = 500	//They're here to help
	maxHealth = 500
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 14
	melee_damage_upper = 18
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("burbles")
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimpsoldier
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'

/mob/living/simple_animal/hostile/shrimp_soldier/friendly
	name = "wellcheers corp assault officer"
	icon_state = "wellcheers_soldier"
	icon_living = "wellcheers_soldier"
	faction = list("neutral", "shrimp")

/obj/item/grenade/spawnergrenade/shrimp
	name = "instant shrimp task force grenade"
	desc = "A grenade used to call for a shrimp task force."
	icon_state = "shrimpnade"
	spawner_type = /mob/living/simple_animal/hostile/shrimp_soldier/friendly
	deliveryamt = 3

/obj/item/grenade/spawnergrenade/shrimp/super
	deliveryamt = 7	//Just randomly get double money.
