/mob/living/simple_animal/hostile/abnormality/an_abnormality
	name = "\"An Abnormality\""
	desc = "An entity lacking in description due to developer laziness."
	icon = 'icons/mob/actions/actions_abnormality.dmi'
	icon_state = "abnormality"
	icon_living = "abnormality"
	portrait = "bill"
	maxHealth = 700
	health = 700
	threat_level = TETH_LEVEL
	attack_sound = 'sound/weapons/bite.ogg'
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_upper = 4
	work_damage_lower = 3
	work_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_lower = 8
	melee_damage_upper = 12
	can_breach = TRUE
	start_qliphoth = 1

	ego_list = list(
		/datum/ego_datum/weapon/an_ego,
		/datum/ego_datum/armor/an_ego,
	)
	gift_type =  /datum/ego_gifts/standard // Way too lazy to make its own gift
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

	observation_prompt = "//TODO - Add Observation Prompt" // This is intentional.

	observation_choices = list(
		"What?" = list(TRUE, "A gift materializes on you a few moments later."),
	)

	work_start_lines = list("%ABNO's existance stretches the definition of \"An Abnormality.\"")
	early_work_lines = list("%ABNO looks exactly like one of the cutsey drawings in the manual.", "%ABNO doesn't resemble any sort of living creature that %PERSON knows about.")
	middle_work_lines = list("%PERSON hesitantly pokes %ABNO, no response.")
	late_work_lines = list("%ABNO flickers out of existance for a moment, surprising %PERSON.", "%PERSON hears muffled laughter in the distance.")
	work_end_lines = list("Is %ABNO really an abnormality?")

/mob/living/simple_animal/hostile/abnormality/an_abnormality/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(25))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/an_abnormality/PostSpawn()
	. = ..()
	dir = SOUTH
