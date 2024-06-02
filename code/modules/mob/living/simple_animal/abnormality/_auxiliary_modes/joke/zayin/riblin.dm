/mob/living/simple_animal/hostile/abnormality/riblin
	name = "Rise Of the Riblin"
	desc = "A humanoid wearing an odd mask."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "mcrib"
	icon_living = "mcrib"
	portrait = "mcrib"
	threat_level = ZAYIN_LEVEL
	maxHealth = 600
	health = 600
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 70, 60, 60, 60),
		ABNORMALITY_WORK_REPRESSION = list(70, 70, 60, 60, 60),
	)
	work_damage_amount = 1
	work_damage_type = RED_DAMAGE
	max_boxes = 10

	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/mcrib,
		/datum/ego_datum/armor/mcrib,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

/mob/living/simple_animal/hostile/abnormality/riblin/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	playsound(src, 'sound/abnormalities/mcrib/enjoy.ogg', 50, FALSE)
	var/turf/dispense_turf = get_step(src, pick(NORTH, SOUTH, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
	var/obj/item/food/mcrib/R = new(dispense_turf)
	visible_message(span_notice("[src] offers a [R]."))

// Death!
/mob/living/simple_animal/hostile/abnormality/riblin/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	playsound(src, 'sound/abnormalities/mcrib/evillaugh.ogg', 50, FALSE)
	user.gib()
