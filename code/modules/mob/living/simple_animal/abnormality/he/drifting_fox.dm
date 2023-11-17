// Code for the drifting fox abnormality
// By yours truely, MoriBox! (I have no fucking clue what im doing.)
/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A large shaggy fox with gleaming yellow eyes; And torn umbrellas lodged into its back."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "fox_sleeping"
	icon_living = "fox_sleeping"
	icon_dead = "fox_egg"
	deathmessage = "collapses into a puddle of water"
	deathsound = "sound/abnormalities/drifting_fox/foxdeath.ogg"
	del_on_death = FALSE
	pixel_x = 0
	base_pixel_x = 0 // Need to figure out what base pixel and pixel X do.
	maxHealth = 1000
	health = 1000
	rapid_melee = 3
	move_to_delay = 2
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5 )
	melee_damage_lower = 5
	melee_damage_upper = 35 // Idea taken from the old PR, have a large damage range so it feels like the fox "crit" sometimes.
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = "sound/abnormalities/drifting_fox/foxhit.ogg"
	attack_verb_simple = "thwacks"
	attack_verb_continuous = "thwacks"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = list(25,30,35,40,45),
		ABNORMALITY_WORK_REPRESSION	= 30,
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	// If I understood this correctly, this SHOULD check if you have pet the fox.
	var/list/pet = list()

	pet_bonus = "yips"
/mob/living/simple_animal/hostile/abnormality/drifting_fox/funpet(mob/petter)
	pet+=petter

/mob/living/simple_animal/hostile/abnormality/drifting_fox/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(user in pet)
		if(work_type == ABNORMALITY_WORK_ATTACHMENT)
			chance+=30
		return chance

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in pet)
		pet-=user

	ego_list = list(
		/datum/ego_datum/weapon/sunshower,
		/datum/ego_datum/armor/sunshower
		)

	gift_type = /datum/ego_gifts/sunshower // NEED TO ACTAULLY MAKE THE GIFT / EGOS
	gift_message = "The fox plucks an umbrella from its back and gives it to you, perhaphs in thanks?"

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) <= 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/drifting_fox/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/BreachEffect(mob/living/carbon/human/user)
	..()
	icon_state = "fox_breached"

