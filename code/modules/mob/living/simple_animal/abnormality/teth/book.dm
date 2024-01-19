/mob/living/simple_animal/hostile/abnormality/book
	name = "Book Without Pictures or Dialogue"
	desc = "An old, dusty tome. There is a pen within the folded pages."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "book_0"
	portrait = "book"
	maxHealth = 600
	health = 600
	start_qliphoth = 2
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 45, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(60, 55, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 30,
	)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/page,
		/datum/ego_datum/armor/page,
	)
	gift_type = /datum/ego_gifts/page
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	var/wordcount = 0
	var/list/oddities = list() //List gets populated with friendly animals
	var/list/nasties = list( //Todo: Eventually make a list of custom threats possibly
		/mob/living/simple_animal/hostile/ordeal/green_bot,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
		/mob/living/simple_animal/hostile/ordeal/violet_fruit,
	)
	var/meltdown_cooldown //no spamming the meltdown effect
	var/meltdown_cooldown_time = 30 SECONDS

/mob/living/simple_animal/hostile/abnormality/book/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(wordcount)
			if(Approach(user))
				visible_message(span_warning("[user] starts ripping pages out of [src]!"))
				playsound(get_turf(src), 'sound/items/poster_ripped.ogg', 50, 1, FALSE)
				RipPages()
				wordcount = 0
				icon_state = "book_[wordcount]"
	else
		if(wordcount < 3)
			if(Approach(user))
				visible_message(span_warning("[user] begins writing in [src]!"))
				playsound(get_turf(src), 'sound/abnormalities/book/scribble.ogg', 90, 1, FALSE)
				SLEEP_CHECK_DEATH(3 SECONDS)
				if(wordcount < 3)
					wordcount ++
				icon_state = "book_[wordcount]"

/mob/living/simple_animal/hostile/abnormality/book/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_amount = 6 + (wordcount * 2)
	return ..()

/mob/living/simple_animal/hostile/abnormality/book/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		chance = chance * wordcount
	return chance

/mob/living/simple_animal/hostile/abnormality/book/proc/Approach(mob/living/carbon/human/user)
	if(user.sanity_lost || user.stat >= SOFT_CRIT)
		return FALSE
	icon_state = "book_[wordcount]"
	user.Stun(5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	return TRUE

//Special breach-related stuff, pretty much copied off a contract signed
/mob/living/simple_animal/hostile/abnormality/book/Initialize()
	. = ..()
	//We'll use the global_friendly_animal_types list. It's empty by default, so we need to populate it.
	if(!GLOB.friendly_animal_types.len)
		for(var/T in typesof(/mob/living/simple_animal))
			var/mob/living/simple_animal/SA = T
			if(initial(SA.gold_core_spawnable) == FRIENDLY_SPAWN)
				GLOB.friendly_animal_types += SA
	oddities += GLOB.friendly_animal_types

	//We need a list of all abnormalities that are TETH and can breach
	var/list/queue = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in queue)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(!(initial(abno.can_spawn)) || !(initial(abno.can_breach)))
			continue
		if((initial(abno.threat_level)) <= TETH_LEVEL)
			nasties += abno

/mob/living/simple_animal/hostile/abnormality/book/proc/RipPages()
	var/mob/living/simple_animal/newspawn
	if(wordcount >= 3)
		newspawn = pick(oddities)
		SpawnMob(newspawn)
		return
	else
		datum_reference.qliphoth_change(-wordcount)

/mob/living/simple_animal/hostile/abnormality/book/proc/SpawnMob(mob/living/simple_animal/newspawn)
	var/mob/living/simple_animal/spawnedmob = new newspawn(get_turf(src))
	if(isabnormalitymob(spawnedmob))
		var/mob/living/simple_animal/hostile/abnormality/abno = spawnedmob
		abno.BreachEffect()
	if(spawnedmob.butcher_results)
		spawnedmob.butcher_results = list(/obj/item/paper = 1)
	spawnedmob.loot = list(/obj/item/paper = 1)
	var/inverted_icon
	var/icon/papericon = icon("[spawnedmob.icon]", spawnedmob.icon_state) //create inverted colors icon
	papericon.MapColors(0.8,0.8,0.8, 0.2,0.2,0.2, 0.8,0.8,0.8, 0,0,0)
	inverted_icon = papericon
	spawnedmob.icon = inverted_icon
	spawnedmob.desc = "It looks like a [spawnedmob.name] but made of paper."
	spawnedmob.name = "Paper [initial(spawnedmob.name)]"
	spawnedmob.faction = list("hostile")
	spawnedmob.maxHealth = (spawnedmob.maxHealth / 10)
	spawnedmob.health = spawnedmob.maxHealth
	spawnedmob.death_message = "collapses into a bunch of writing material."
	spawnedmob.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=0, color=rgb(0, 0, 0))
	src.visible_message(span_warning("Pages of [src] fold into [spawnedmob]!"))
	playsound(get_turf(src), 'sound/items/handling/paper_pickup.ogg', 90, 1, FALSE)

/mob/living/simple_animal/hostile/abnormality/book/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(start_qliphoth) //no need for qliphoth to be stuck at 0
	if(meltdown_cooldown > world.time)
		return
	meltdown_cooldown = world.time + meltdown_cooldown_time
	MeltdownEffect()
	return

/mob/living/simple_animal/hostile/abnormality/book/proc/MeltdownEffect(mob/living/carbon/human/user)
	var/mob/living/simple_animal/newspawn
	var/spawn_num = rand(3,5)
	for(var/i=1, i<=spawn_num, i++)
		sleep(0.5 SECONDS)
		newspawn = pick(nasties)
		SpawnMob(newspawn)
