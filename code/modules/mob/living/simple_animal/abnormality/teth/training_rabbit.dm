/mob/living/simple_animal/hostile/abnormality/training_rabbit
	name = "Standard Training-Dummy Rabbit"
	desc = "A rabbit-like training dummy. Should be completely harmless."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "training_rabbit"
	icon_living = "training_rabbit"
	portrait = "training_rabbit"
	maxHealth = 14 //hit with baton twice
	health = 14
	threat_level = TETH_LEVEL
	fear_level = 0 //rabbit not scary
	move_to_delay = 16
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 65,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 100,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_amount = 2
	work_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear
	//ego_list = list(datum/ego_datum/weapon/training, datum/ego_datum/armor/training)
	gift_type =  /datum/ego_gifts/standard
	can_patrol = FALSE
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

/mob/living/simple_animal/hostile/abnormality/training_rabbit/Initialize()	//1 in 100 chance for bunny girl waifu
	. = ..()
	if(prob(1))
		icon = 'ModularTegustation/Teguicons/64x64.dmi'
		icon_state = "Bungal"
		pixel_x = -16
		gift_type =  /datum/ego_gifts/bunny

/mob/living/simple_animal/hostile/abnormality/training_rabbit/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(kill_dummy)), 30 SECONDS)
	if(icon_state == "Bungal")
		icon = 'ModularTegustation/Teguicons/64x96.dmi'
		icon_state = "Bungal_breach"
		pixel_x = -16

/mob/living/simple_animal/hostile/abnormality/training_rabbit/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/training_rabbit/proc/kill_dummy()
	QDEL_NULL(src)
