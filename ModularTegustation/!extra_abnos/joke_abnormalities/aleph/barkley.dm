/mob/living/simple_animal/hostile/abnormality/barkley
	name = "Charles Barkley Shut Up And Jam Gaiden: Part 1 of the Hoopz Barkley Saga"
	desc = "A large man wearing a basketball jersey."
	health = 4000
	maxHealth = 4000
	pixel_x = -12
	base_pixel_x = -12
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "barkley"
	icon_living = "barkley"
	portrait = "barkley"
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	is_flying_animal = TRUE
	del_on_death = FALSE
	can_breach = FALSE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	work_damage_amount = 16
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/chaosdunk,
		/datum/ego_datum/armor/chaosdunk,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

	var/explosion_amt = 3

/mob/living/simple_animal/hostile/abnormality/barkley/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/barkley/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/barkley/ZeroQliphoth(mob/living/carbon/human/user)
	. = ..()
	ChaosDunk(user)

/mob/living/simple_animal/hostile/abnormality/barkley/OnQliphothChange(mob/living/carbon/human/user)
	. = ..()
	if(datum_reference.qliphoth_meter == 1)
		icon_state = "barkley_angry"
	else
		icon_state = icon_living

/mob/living/simple_animal/hostile/abnormality/barkley/proc/ChaosDunk()
	show_global_blurb(10 SECONDS, "CHAOS DUNK ADVISORY", text_align = "center", screen_location = "Center-6,Center+3")
	priority_announce("FACILITY CHAOS DUNK ADVISORY WARNING! A MEASURED 19.7 MEGAJOULE OF NEGATIVE B-BALL PROTONS HAS BEEN DETECTED.\
	A CHAOS DUNK IS IMMINENET. FIND SHELTER IMMEDIATELY. THIS IS NOT A DRILL.", "Chaos Dunk Advisory", sound='sound/effects/combat_suppression_start.ogg')
	explosion(src, 20, 20)
	sleep(10 SECONDS)
	Explode()
	Cinematic(CINEMATIC_CHAOS_DUNK, world)

/mob/living/simple_animal/hostile/abnormality/barkley/proc/Explode()
	set waitfor = FALSE
	sleep(5 SECONDS)
	var/list/spawns = GLOB.xeno_spawn.Copy()
	var/list/depts = GLOB.department_centers.Copy()
	for(var/i = 1 to explosion_amt)
		if(prob(70))
			for(var/turf/T in depts)
				explosion(T, 20, 20)
				sleep(10)
			continue
		for(var/turf/T in spawns)
			explosion(T, 20, 20)//this is in EVERY xenospawn
	qdel(src)
