//A tribute to, and Designed mostly by InsightfulParasite, our lovely spriter. Coded by Kirie Saito.
/mob/living/simple_animal/hostile/abnormality/shrimp_exec
	name = "Shrimp Association Executive"
	desc = "A shrimp in a snazzy suit."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "executive"
	icon_living = "executive"
	core_icon = "shrimpexec_egg"
	portrait = "shrimp_executive"
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
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE	//He insults you
	chem_type = /datum/reagent/abnormality/sin/pride

	ego_list = list(
		/datum/ego_datum/armor/executive,
		/datum/ego_datum/executive_gun,
	)
	gift_type =  /datum/ego_gifts/executive

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/wellcheers = 1.5, // I... if you ever get a zayin this far in, good luck.
	)

	observation_prompt = "You sit in an office decorated with shrimp-related memorabilia. <br>\
		Various trophies and medals and other trinkets with shrimp on them. <br>A PHD in shrimpology printed on printer paper is displayed prominantly on the wall. <br>\
		\"Enjoying my collection? <br>I played college ball in Shrimp-Corp's nest, you know.\" <br>\
		A delicious looking shrimp in a snazzy suit sits before you in an immaculate office chair. <br>\
		\"But where are my manners... <br>Why don't you enjoy some of our finest locally produced champagne?\" <br>\
		The shrimp offers you a champagne glass full of... Something. <br>\
		It looks and smells like wellcheers grape soda. It's soda. <br>\
		You can even see the can's label torn off and stuck on the side. <br>Will you drink it?"
	observation_choices = list(
		"Drink the soda" = list(TRUE, "Before you can make a choice, two gigantic and heavily armed shrimp guards bust in through the door. <br>\
			They hold you down and force you to drink the soda, and you fall asleep... <br>... <br>Somewhere in the distance, you hear seagulls."),
		"Refuse" = list(TRUE, "Before you can make a choice, two gigantic and heavily armed shrimp guards bust in through the door. <br>\
			They hold you down and force you to drink the soda, and you fall asleep... <br>... <br>Somewhere in the distance, you hear seagulls."),
	)

	var/liked
	var/happy = TRUE
	var/happy_works = 0
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
		"Fetch me a bowl of shrimp fried rice? I'm looking to try this delicacy made by your finest shrimp chefs.",
		"Ah, I forgot to take my daily medication, could you bring it to me?",
	)

	var/list/insight = list(
		"Get me my phonograph, I would like to listen to Moonlight Sonata, 1st Movement.",
		"The plants in my office are dying, could you water them please?",
		"It is rather dull, with all the negotiations that we have been doing. Could you get me the morning crossword?",
		"I've noticed some dust collecting on the bookshelves, could you get someone to dust it?",
		"Ah, I seem to have spilt my wine, could you get it cleaned up?",
		"I think my suit needs to be dry-cleaned. Take it and go.",

	)

	var/list/attachment = list(
		"You know, I had this brand new deal that I am setting up. Care to listen sometime?",
		"I was wondering if YOU had any good business offers. It would be nice to hear from a fellow intellectual. Stop by and tell me sometime.",
		"Come, pull up a glass, old friend. Let's drink to a good deal!",
		"I'm thinking about buying stocks for my portfolio, what do you recommend I invest in?",
		"Got a moment to chat about something important? Let's catch up over a cup of coffee and discuss some potential business moves. Your insights are always valuable to me.",
		"I was wondering if you might be available to join me for a brief tête-à-tête over a cup of tea. Come on by when you are available.",
	)
	var/list/shrimps = list()
	var/shrimp_cap = 24

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/WorkChance(mob/living/carbon/human/user, chance)
	if(happy)
		chance+=30
	return chance

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(happy_works >= 3)
		happy_works = 0
		var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
		var/obj/structure/closet/supplypod/extractionpod/shrimppod/pod = new()
		pod.explosionSize = list(0,0,0,0)
		new/obj/structure/lootcrate/s_corp(pod)
		new /obj/effect/pod_landingzone(dispense_turf, pod)
		say("Here you are, my dear friend. High-quality items courtesy of shrimpcorp.")
		return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/ZeroQliphoth(mob/living/carbon/human/user)
	pissed()
	happy_works = 0
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		pissed()
		addtimer(CALLBACK(src, PROC_REF(pissed)), 20 SECONDS)

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == liked || !liked)
		happy = TRUE
		happy_works++
	else
		happy_works = 0
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
	set waitfor = FALSE
	if(length(shrimps) >= shrimp_cap)
		return
	var/turf/Start = pick(GLOB.department_centers)
	var/list/turfs = list()
	for(var/turf/T in circlerange(center = Start, radius = 3))
		turfs += T
	var/amount = rand(4,8)
	for(var/i = 1 to amount)
		var/turf/W = pick(turfs)
		var/obj/structure/shrimp_rope/R = new(W)
		R.exec = src
		R.pixel_x = rand(-4,4)
		addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/structure/shrimp_rope, SpawnShrimp)), rand(0,20)) //A bit of randomness
		turfs -= W

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

/* Rope */
/obj/structure/shrimp_rope
	name = "rope"
	desc = "A long piece of rope connected to a new found hole in the celling."
	icon = 'icons/effects/32x96.dmi'
	icon_state = "rope"
	layer = MOB_LAYER
	anchored = TRUE
	density = FALSE
	max_integrity = 1
	resistance_flags = INDESTRUCTIBLE
	alpha = 0
	var/mob/living/simple_animal/hostile/abnormality/shrimp_exec/exec = null

/obj/structure/shrimp_rope/proc/SpawnShrimp()
	set waitfor = FALSE
	pixel_z = 96
	animate(src, pixel_z = 0, alpha = 255, time = 20,  easing = SINE_EASING | EASE_IN)
	sleep(3 SECONDS)
	var/list/turfs = list()
	var/should_spawn = TRUE
	for(var/turf/T in orange(1, get_turf(src)))
		turfs += T
	if(exec)
		if(length(exec.shrimps) >= exec.shrimp_cap)
			should_spawn = FALSE
	if(should_spawn)
		var/mob/living/simple_animal/hostile/aminion/shrimp/S
		if(prob(30))
			S = new/mob/living/simple_animal/hostile/aminion/shrimp/soldier(pick(turfs))
		else
			S = new(pick(turfs))
		if(exec)
			S.exec = exec
			exec.shrimps += S
		S.dir = get_dir(S, src)
		S.SpawnAnimation()
		sleep(3 SECONDS)
	resistance_flags &= ~INDESTRUCTIBLE

/obj/structure/shrimp_rope/Destroy()
	if(exec)
		exec = null
	. = ..()

/* Shrimpo boys */
/mob/living/simple_animal/hostile/aminion/shrimp
	name = "wellcheers corp liquidation intern"
	desc = "A shrimp that is extremely hostile to you."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers"
	icon_living = "wellcheers"
	icon_dead = "wellcheers_dead"
	faction = list("shrimp")
	health = 220
	maxHealth = 220
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 8
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("burbles")
	butcher_results = list(/obj/item/stack/spacecash/c50 = 1)
	guaranteed_butcher_results = list(/obj/item/stack/spacecash/c10 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 4)
	threat_level = TETH_LEVEL
	score_divider = 2
	var/mob/living/simple_animal/hostile/abnormality/shrimp_exec/exec = null
	var/can_act = TRUE
	var/can_be_hit = TRUE

/mob/living/simple_animal/hostile/aminion/shrimp/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		can_affect_emergency = FALSE
		del_on_death = FALSE

/mob/living/simple_animal/hostile/aminion/shrimp/proc/SpawnAnimation()
	set waitfor = FALSE
	can_act = FALSE
	docile_confinement = TRUE
	status_flags |= GODMODE
	pixel_z = 96
	alpha = 0
	density = FALSE
	can_be_hit = FALSE
	animate(src, pixel_z = 0, alpha = 255, time = 30,  easing = CUBIC_EASING | EASE_IN)
	SLEEP_CHECK_DEATH(2.9 SECONDS)
	can_be_hit = TRUE
	status_flags &= ~GODMODE
	density = TRUE
	SLEEP_CHECK_DEATH(0.1 SECONDS)
	can_act = TRUE
	docile_confinement = TRUE

/mob/living/simple_animal/hostile/aminion/shrimp/Destroy()
	if(exec)
		exec.shrimps -= src
		exec = null
	. = ..()

/mob/living/simple_animal/hostile/aminion/shrimp/OpenFire()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/Move()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/PickTarget(list/Targets)
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/attack_hand(mob/living/carbon/human/M)
	if(!can_be_hit)
		return
	. = ..()

/mob/living/simple_animal/hostile/aminion/shrimp/attack_paw(mob/living/carbon/human/M)
	if(!can_be_hit)
		return
	. = ..()

/mob/living/simple_animal/hostile/aminion/shrimp/attack_animal(mob/living/simple_animal/M)
	if(!can_be_hit)
		return
	. = ..()

/mob/living/simple_animal/hostile/aminion/shrimp/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	if(!can_be_hit)
		return
	. = ..()

/mob/living/simple_animal/hostile/aminion/shrimp/attackby(obj/item/I, mob/living/user, params)
	if(!can_be_hit)
		return
	. = ..()

//You can put these guys about to guard an area.
/mob/living/simple_animal/hostile/aminion/shrimp/soldier
	name = "wellcheers corp hired liquidation officer"
	desc = "A shrimp that is there to guard an area."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	icon_dead = "wellcheers_bad_dead"
	health = 300 //They're here to help
	maxHealth = 300
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 3
	melee_damage_upper = 5
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimpsoldier
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	guaranteed_butcher_results = list(/obj/item/stack/spacecash/c20 = 1, /obj/item/stack/spacecash/c1 = 5)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 8, /obj/item/stack/sheet/silk/shrimple_advanced = 4)
	threat_level = HE_LEVEL
	/// When at 0 - it will start "reloading"
	var/ammo = 6

/mob/living/simple_animal/hostile/aminion/shrimp/soldier/Life()
	. = ..()
	if(!.)
		return
	if(ammo <= 0)
		retreat_distance = 4
		minimum_distance = 6
	else
		retreat_distance = 2
		minimum_distance = 3

/mob/living/simple_animal/hostile/aminion/shrimp/soldier/OpenFire(atom/A)
	if(!can_act)
		return FALSE
	if(ammo <= 0)
		StartReloading()
		return FALSE
	ammo -= 1
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/soldier/proc/StartReloading()
	can_act = FALSE
	playsound(get_turf(src), 'sound/weapons/gun/general/slide_lock_1.ogg', 50, FALSE)
	for(var/i = 1 to 6)
		SLEEP_CHECK_DEATH(4)
		playsound(get_turf(src), 'sound/weapons/gun/general/bolt_rack.ogg', 50, FALSE)
	ammo = 6
	can_act = TRUE


/mob/living/simple_animal/hostile/aminion/shrimp/soldier/friendly
	name = "wellcheers corp assault officer"
	icon_state = "wellcheers_soldier"
	icon_living = "wellcheers_soldier"
	icon_dead = "wellcheers_soldier_dead"
	faction = list("neutral", "shrimp")
	can_affect_emergency = FALSE
	trigger_lights = FALSE
	fear_level = 0

/obj/item/grenade/spawnergrenade/shrimp
	name = "instant shrimp task force grenade"
	desc = "A grenade used to call for a shrimp task force."
	icon_state = "shrimpnade"
	spawner_type = /mob/living/simple_animal/hostile/aminion/shrimp/soldier/friendly
	deliveryamt = 3

/obj/item/grenade/spawnergrenade/shrimp/super
	deliveryamt = 7	//Just randomly get double money.

/obj/item/grenade/spawnergrenade/shrimp/hostile
	spawner_type = list(/mob/living/simple_animal/hostile/aminion/shrimp, /mob/living/simple_animal/hostile/aminion/shrimp/soldier) //Gacha Only, just put it here with the other shrimp grenades.

//Crates
//S Corporation
/obj/structure/lootcrate/s_corp
	name = "Shrimp-Corp Loot Crate"
	desc = "A crate containing some knickknacks from the mysterious Shrimp-Corp. Open with a Crowbar."
	icon_state = "crate_shrimp"
	veryrarechance = 10
	cosmeticchance = 10
	lootlist =	list(
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple,
		/obj/item/grenade/spawnergrenade/shrimp,
	)

	rareloot = list(
		/obj/item/grenade/spawnergrenade/shrimp/super,
		/obj/item/trait_injector/shrimp_injector,
		/obj/item/fishing_rod/wellcheers,
		/obj/item/clothing/suit/armor/ego_gear/zayin/soda,
		/obj/item/ego_weapon/ranged/pistol/soda
	)

	veryrareloot = list(
		/obj/item/grenade/spawnergrenade/shrimp/super,
		/obj/item/grenade/spawnergrenade/shrimp/hostile,
		/obj/item/ego_weapon/ranged/sodarifle,
		/obj/item/reagent_containers/pill/shrimptoxin,
	)

	cosmeticloot = list(
		/mob/living/simple_animal/hostile/aminion/shrimp,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
	)

/obj/structure/lootcrate/s_corp_gun
	name = "Shrimp-Corp Gun Crate"
	desc = "A crate containing a gun from the mysterious Shrimp-Corp. Open with a Crowbar."
	icon_state = "crate_weapon_shrimp"
	rarechance = 80
	veryrarechance = 15
	lootlist =	list(
		/obj/item/ego_weapon/ranged/sodarifle,
	)

	rareloot =	list(
		/obj/item/ego_weapon/ranged/sodaminigun,
		/obj/item/ego_weapon/ranged/sodasmg,
		/obj/item/ego_weapon/ranged/sodashotty,
		/obj/item/ego_weapon/ranged/sodaassault,
	)

	veryrareloot = list(
		/obj/item/ego_weapon/ranged/pistol/executive
	)

/obj/structure/closet/supplypod/extractionpod/shrimppod
	name = "shrimp-borp drop pod"
	desc = "A purple pod."
	style = STYLE_SHRIMP
