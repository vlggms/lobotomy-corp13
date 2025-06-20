
#define STATUS_EFFECT_TEMPOVITA /datum/status_effect/tempo_vita
// To do: Work rates. Records.
/mob/living/simple_animal/hostile/abnormality/branch12/tempo
	name = "Tempo Primo"
	desc = ""
	icon = 'ModularTegustation/Teguicons/branch12/64x96.dmi'
	icon_state = "passion"
	maxHealth = 400
	health = 400
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 40, 50),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 40, 50),
		ABNORMALITY_WORK_ATTACHMENT = 10,
		ABNORMALITY_WORK_REPRESSION = 80,
	)
	start_qliphoth = 3
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE
	ego_list = list(
	//	/datum/ego_datum/weapon/branch12/passion,
	//	/datum/ego_datum/armor/branch12/passion,
	)
	//gift_type =  /datum/ego_gifts/passion
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


/mob/living/simple_animal/hostile/abnormality/branch12/tempo/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(prob(80))
			datum_reference.qliphoth_change(-1)
	else
		datum_reference.qliphoth_change(1)
		user.apply_status_effect(STATUS_EFFECT_TEMPOVITA)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/tempo/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/branch12/tempo/ZeroQliphoth()
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!(H.mind.assigned_role in GLOB.security_positions))
			continue
		potential_targets+=H
	for(var/i = 1 to 3)
		if(!length(potential_targets))
			continue
		var/mob/living/debuff_target = pick_n_take(potential_targets)
		debuff_target.apply_status_effect(STATUS_EFFECT_TEMPOVITA)
	..()


/datum/status_effect/tempo_vita
	id = "tempo vita"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	var/turf/last_turf
	alert_type = /atom/movable/screen/alert/status_effect/tempo_vita

/atom/movable/screen/alert/status_effect/tempo_vita
	name = "Tempo Vita"
	desc = "You feel like you shouldn't sit still."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "rest"

/datum/status_effect/tempo_vita/tick()
	if(last_turf == get_turf(owner))
		owner.adjustSanityLoss(4)	//Rare damage type
	if(owner)
		last_turf = get_turf(owner)

#undef STATUS_EFFECT_TEMPOVITA
