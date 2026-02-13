/mob/living/simple_animal/hostile/abnormality/clayman
	name = "Generic Brand Modelling Clay"
	desc = "A small, rough humanoid figure made of clay."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bluro"
	icon_living = "bluro"
	icon_dead = "bluro"
	portrait = "clayman"
	del_on_death = TRUE
	maxHealth = 200
	health = 200
	ranged = TRUE
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 3
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_lower = 3
	melee_damage_upper = 4
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/effects/hit_kick.ogg'
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 50
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	death_message = "loses form."
	ego_list = list(
		/datum/ego_datum/weapon/clayman,
		/datum/ego_datum/armor/clayman,
	)
	var/reforming = FALSE
	gift_message = "The clay clings to you, a constant reminder."
	gift_type =  /datum/ego_gifts/clayman
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "A soft, clay-like substance. <br>\
		Rolled, moulded, sculpted, an art form of the highest order. <br>\
		It looks at you now, with expectation in its eyes. <br>This work, it's not complete. It..."
	observation_choices = list(
		"It should be destroyed" = list(FALSE, "It is a foul abomination. <br>Such a thing shouldn't exist. <br>It violates the laws of this world and the city."),
		"It still needs a soul" = list(TRUE, "The price to be paid cannot be measured in time or money. <br>The results speak for themselves."),
	)

	var/dashready = TRUE

/mob/living/simple_animal/hostile/abnormality/clayman/WorktickFailure(mob/living/carbon/human/user)
	var/dtype = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	work_damage_type = pick(dtype)
	..()

/mob/living/simple_animal/hostile/abnormality/clayman/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	var/og_reforming = reforming
	for(var/work in work_chances)
		if(work_chances[work] >= 100)
			reforming = TRUE
			work_chances[work] = 20 //For some reason setting it like this doesn't bug the work rate but setting the entire list at once does.
			continue
		else if(work_chances[work] >= 50)
			reforming = FALSE

		if(work != work_type)
			work_chances[work] -= 5
		else
			work_chances[work] += 10

	if(reforming != og_reforming)
		if(reforming)
			manual_emote("looks like a mess!")
		else
			manual_emote("is taking form once more.")

/mob/living/simple_animal/hostile/abnormality/clayman/examine(mob/user)
	. = ..()
	for(var/work in work_chances)
		if(work_chances[work] >= 90)
			. += "<span class='warning'>It's about to fall apart, you should avoid doing more [work] work on it.</span>"

/mob/living/simple_animal/hostile/abnormality/clayman/CanAttack(atom/the_target)
	melee_damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/clayman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(!reforming)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/clayman/proc/Skitter()
	visible_message(span_warning("[src] Skitters faster!"), span_notice("you hear the patter of hundreds of clay feet"))
	var/duration = 3 SECONDS
	TemporarySpeedChange(-2, duration)
	dashready = FALSE
	addtimer(CALLBACK(src, PROC_REF(dashreset)), 15 SECONDS)

/mob/living/simple_animal/hostile/abnormality/clayman/OpenFire(atom/A)
	if(get_dist(src, target) >= 3 && dashready)
		Skitter()

/mob/living/simple_animal/hostile/abnormality/clayman/proc/dashreset()
	dashready = TRUE
