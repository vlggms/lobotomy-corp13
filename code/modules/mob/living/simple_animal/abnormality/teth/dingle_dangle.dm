#define STATUS_EFFECT_DANGLE /datum/status_effect/dangle
/mob/living/simple_animal/hostile/abnormality/dingledangle
	name = "Dingle-Dangle"
	desc = "A cone that goes up to the ceiling with a ribbon tied around it. Bodies are strung up around it, seeming to be tied to the ceiling."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "dangle"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 60, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(30, 40, 70, 70, 70),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40
			)
	start_qliphoth = 3
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/lutemia,
		/datum/ego_datum/armor/lutemia
		)
	gift_type = /datum/ego_gifts/lutemis
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

//Introduction to our hallucinations. This is a global hallucination, but it's all it really does.
/mob/living/simple_animal/hostile/abnormality/dingledangle/ZeroQliphoth(mob/living/carbon/human/user)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		H.hallucination += 10
	datum_reference.qliphoth_change(3)

/mob/living/simple_animal/hostile/abnormality/dingledangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	//if your prudence is low, give a short hallucination, apply the buff, and lower counter.
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) > 60)
		user.hallucination += 20
		user.apply_status_effect(STATUS_EFFECT_DANGLE)
		datum_reference.qliphoth_change(-1)
		return ..()

	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <= 80)
		return ..()

	//I mean it does this in wonderlabs
	user.dust()

	//But here's the twist: You get a better ego.
	var/location = get_turf(user)
	new /obj/item/clothing/suit/armor/ego_gear/he/lutemis(location)

/mob/living/simple_animal/hostile/abnormality/dingledangle/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(50))
		//Yeah dust them too. No ego this time tho
		user.dust()

/atom/movable/screen/alert/status_effect/dangle
	name = "That Woozy Feeling"
	desc = "+15 to Combat bonus."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "rest"

//A simple 5 minute stat bonus increase
/datum/status_effect/dangle
	id = "dangle"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000		//Lasts 5 minutes
	alert_type = /atom/movable/screen/alert/status_effect/dangle

/datum/status_effect/dangle/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 15)

/datum/status_effect/dangle/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -15)
