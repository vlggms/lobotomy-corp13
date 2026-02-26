// Coded by Coxswain. WIP.
/mob/living/simple_animal/hostile/abnormality/tumblebug
	name = "Gleaming Tumblebug"
	desc = "A ball of fire, radiating heat. Some sort of large beetle is constantly rolling it around."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "beetle"
	icon_living = "beetle"
	portrait = "beetle" // TODO: replace placeholder
	icon_dead = "beetle_dead"
	core_icon = "beetle_dead"
	del_on_death = FALSE
	maxHealth = 400
	health = 400
	attack_verb_continuous = "sears"
	attack_verb_simple = "sear"
	stat_attack = HARD_CRIT
	melee_damage_lower = 4
	melee_damage_upper = 6
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 2, FIRE = 0.3)
	speak_emote = list("chitters")
	melee_damage_type = RED_DAMAGE
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = -50,
		ABNORMALITY_WORK_ATTACHMENT = list(60, 55, 50, 55, 60),
		ABNORMALITY_WORK_REPRESSION = 45
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust

	ego_list = list(
		/datum/ego_datum/weapon/gleaming,
		/datum/ego_datum/armor/gleaming,
	)
	gift_type =  /datum/ego_gifts/gleaming
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "Chittering bugs, the smell of death, a dry lake bed. <br>\
	Little balls pitter-pat as they roll across the sand. <br>\
	The insects take no notice of you as they toil. <br>\
	Occasional sparkles suggest that something else could be in the balls of refuse."
	observation_choices = list(
		"Break one open" = list(FALSE, "You grab hold of a ball, the dung sticking to your fingers. <br>\
			Greedily breaking it apart, your hands are suddenly engulfed in a flame.<br>\
			There is nothing inside but a burning, molten core."),
		"Leave them alone" = list(TRUE, "Some things are best alone, <br>\
			that sort of dirty work is beneath you anyways. <br>\
			What sort of valuable thing could be found inside dung?"),
	)

	light_color = COLOR_ORANGE
	light_range = 3
	light_power = 4
	light_on = TRUE
	can_spawn = FALSE

/mob/living/simple_animal/hostile/abnormality/tumblebug/death(gibbed)
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()
