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
	chem_type = /datum/reagent/blood
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear
	//ego_list = list(datum/ego_datum/weapon/training, datum/ego_datum/armor/training)
	gift_type =  /datum/ego_gifts/standard
	can_patrol = FALSE
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	secret_chance = TRUE // people NEEDED a bunny girl waifu
	secret_icon_file = 'ModularTegustation/Teguicons/64x64.dmi'
	secret_icon_state = "Bungal"
	secret_horizontal_offset = -16
	secret_gift = /datum/ego_gifts/bunny

	observation_prompt = "This is the training dummy that Lobotomy Corporation uses for training new agents. <br>\
		But is that really all there is to it? <br>\
		Looking closely, you find..."
	observation_choices = list(
		"A dead body?" = list(TRUE, "The facial structure, the torso, arms and legs, not to mention the stench... <br>\
			There's no doubt that this is just a dead body in a body bag, flipped upside-down. <br>\
			In spite of all this, it provides a gift to you. It continues moving around as if it were alive. <br>\
			So this is what they call an abnormality. <br>\
			Are all abnormalities at Lobotomy Corporation this strange?"),
		"Nothing" = list(FALSE, "Your imagination must be going haywire due to the stress. <br>There's no way such an out-of-place thing could be there!"),
	)

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
