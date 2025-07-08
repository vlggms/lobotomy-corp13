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
	work_damage_amount = 4
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

	observation_prompt = "We're no strangers to love <br>\
		You know the rules and so do I <br>\
		A full commitment's what I'm thinkin' of <br>\
		You wouldn't get this from any other guy <br>\
		I just wanna tell you how I'm feeling <br>\
		Gotta make you understand <br>\
		Never gonna give you up, never gonna let you down <br>\
		Never gonna run around and desert you <br>\
		Never gonna make you cry, never gonna say goodbye <br>\
		Never gonna tell a lie and hurt you <br>\
		We've known each other for so long <br>\
		Your heart's been aching, but you're too shy to say it <br>\
		Inside, we both know what's been going on <br>\
		We know the game and we're gonna play it <br>\
		And if you ask me how I'm feeling <br>\
		Don't tell me you're too blind to see <br>\
		Never gonna give you up, never gonna let you down <br>\
		Never gonna run around and desert you <br>\
		Never gonna make you cry, never gonna say goodbye <br>\
		Never gonna tell a lie and hurt you <br>\
		Never gonna give you up, never gonna let you down <br>\
		Never gonna run around and desert you <br>\
		Never gonna make you cry, never gonna say goodbye <br>\
		Never gonna tell a lie and hurt you <br>\
		We've known each other for so long <br>\
		Your heart's been aching, but you're too shy to say it <br>\
		Inside, we both know what's been going on <br>\
		We know the game and we're gonna play it <br>\
		I just wanna tell you how I'm feeling <br>\
		Gotta make you understand <br>\
		Never gonna give you up, never gonna let you down <br>\
		Never gonna run around and desert you <br>\
		Never gonna make you cry, never gonna say goodbye <br>\
		Never gonna tell a lie and hurt you <br>\
		Never gonna give you up, never gonna let you down <br>\
		Never gonna run around and desert you <br>\
		Never gonna make you cry, never gonna say goodbye <br>\
		Never gonna tell a lie and hurt you <br>\
		Never gonna give you up, never gonna let you down <br>\
		Never gonna run around and desert you <br>\
		Never gonna make you cry, never gonna say goodbye <br>\
		Never gonna tell a lie and hurt you"

	observation_choices = list(
		"Give up" = list(TRUE, "You give up and embrace the jank. A gift materializes on you a few moments later."),
	)

/mob/living/simple_animal/hostile/abnormality/an_abnormality/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(25))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/an_abnormality/PostSpawn()
	. = ..()
	dir = SOUTH
