#define STATUS_EFFECT_CHANGE /datum/status_effect/we_can_change_anything
/mob/living/simple_animal/hostile/abnormality/we_can_change_anything
	name = "We Can Change Anything"
	desc = "A human sized container with spikes inside it. You shouldn't enter it"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "wecanchange"
	maxHealth = 1000
	health = 1000
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(80, 85, 90, 95, 100),
		ABNORMALITY_WORK_INSIGHT = list(80, 85, 90, 95, 100),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 50, 55, 60, 60),
		ABNORMALITY_WORK_REPRESSION = list(55, 60, 65, 70, 75)
		)
	work_damage_amount = 0
	work_damage_type = RED_DAMAGE
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/change,
		/datum/ego_datum/armor/change
		)

	gift_type =  /datum/ego_gifts/change
	gift_message = "Your heart beats with new vigor."


/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/Worktick(mob/living/carbon/human/user)
	user.apply_damage(5, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE)) // say goodbye to your kneecaps chucklenuts!

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	user.apply_status_effect(STATUS_EFFECT_CHANGE)
	return

/datum/status_effect/we_can_change_anything
	id = "change"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000 //Lasts 5 mins
	alert_type = /atom/movable/screen/alert/status_effect/we_can_change_anything

/atom/movable/screen/alert/status_effect/we_can_change_anything
	name = "The desire to change"
	desc = "Your painful experience has made you more resilient to RED damage."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "change"

/datum/status_effect/we_can_change_anything/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 0.9

/datum/status_effect/we_can_change_anything/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 0.9

#undef STATUS_EFFECT_CHANGE
