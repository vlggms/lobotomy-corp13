/mob/living/simple_animal/hostile/abnormality/old_lady
	name = "Old Lady"
	desc = "An old, decrepit lady sitting in a worn-out rocking chair"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "old_lady"
	portrait = "old_lady"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(65, 65, 60, 60, 60),
		ABNORMALITY_WORK_REPRESSION = 30,
		"Clear Solitude" = -100,
	)
	start_qliphoth = 4
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/woe
	ego_list = list(
		/datum/ego_datum/weapon/solitude,
		/datum/ego_datum/armor/solitude,
	)
	gift_type =  /datum/ego_gifts/solitude
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "There was some cracking along the floor. \
		Hair-raising screeching of wooden rocking chair filled the air. I did not want to enter this house. \
		Because I don't like to listen to stories. Bugs were buzzing around here and there. \
		Something slimy popped as I set my foot on it. I found her. Every hole on her face was swarming bugs. \
		I don't want to stay here. I want to get out. It's damp, nasty, and awful. I can't stand it anymore."
	observation_choices = list(
		"Stay" = list(TRUE, "I stayed, bearing the unpleasantness. \
			She was so talkative before. In the end, loneliness was the only listener. \
			She called me, with her finger. I am now ready to listen to her story."),
		"Get out" = list(FALSE, "I turned around to get out of this place. Once again, I bit lips in self-hatred while escaping."),
	)

	var/meltdown_cooldown_time = 120 SECONDS
	var/meltdown_cooldown
//for solitude effects
	var/solitude_cooldown_time = 1 SECONDS
	var/solitude_cooldown

/mob/living/simple_animal/hostile/abnormality/old_lady/Life()
	. = ..()
	if(meltdown_cooldown < world.time && !datum_reference.working) // Doesn't decrease while working but will afterwards
		meltdown_cooldown = world.time + meltdown_cooldown_time
		datum_reference.qliphoth_change(-1)

	if(solitude_cooldown < world.time && datum_reference.qliphoth_meter == 0)
		solitude_cooldown = world.time + solitude_cooldown_time
		for(var/turf/open/T in range(2 , src))
			if(prob(70))
				new /obj/effect/solitude (T)

/mob/living/simple_animal/hostile/abnormality/old_lady/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "Clear Solitude" && datum_reference.qliphoth_meter == 0)
		return TRUE
	else if(datum_reference.qliphoth_meter == 0 || work_type == "Clear Solitude")
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/old_lady/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "Clear Solitude")
		datum_reference.qliphoth_change(4)
		icon_state = "old_lady"
	return

//The Effect
/obj/effect/solitude
	name = "solitude gas"
	desc = "You can hardly see through this."
	icon = 'icons/effects/effects.dmi'
	icon_state = "solitude1"
	move_force = INFINITY
	pull_force = INFINITY
	layer = ABOVE_MOB_LAYER

/obj/effect/solitude/Initialize()
	. = ..()
	icon_state = "solitude[pick(1,2,3,4)]"
	animate(src, alpha = 0, time = 3 SECONDS)
	QDEL_IN(src, 3 SECONDS)
