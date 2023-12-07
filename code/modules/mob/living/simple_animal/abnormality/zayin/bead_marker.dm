#define STATUS_EFFECT_BLINDPOINT /datum/status_effect/blindpoint
/mob/living/simple_animal/hostile/abnormality/bead_marker
	name = "Bead Marker"
	desc = "An oversized laser pointer. Its button doesn't seem to work."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "pointer"
	icon_living = "pointer"
	maxHealth = 50
	health = 50
	threat_level = ZAYIN_LEVEL
	can_spawn = TRUE
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 65,
						ABNORMALITY_WORK_INSIGHT = 55,
						ABNORMALITY_WORK_ATTACHMENT = 20,
						ABNORMALITY_WORK_REPRESSION = 80
						)
	work_damage_amount = 4
	work_damage_type = RED_DAMAGE
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/pinpoint,
		/datum/ego_datum/armor/pinpoint
		)
	gift_type = /datum/ego_gifts/pinpoint
	gift_message = "You feel someone's aim trained on you."
	success_boxes = 8
	neutral_boxes = 4

/mob/living/simple_animal/hostile/abnormality/testabno/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	user.apply_status_effect(STATUS_EFFECT_BLINDPOINT)
	to_chat(user, span_notice("Ack! That pointer shined a laser into your eyes!"))
	..()



	//This is my first time creating a custom abno, please pardon the spaghetti code and shitty spritework.



/datum/status_effect/blindpoint
	id = "blinded"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 500
	alert_type = /atom/movable/screen/alert/status_effect/blindpoint

/datum/status_effect/blindpoint/on_apply()
	owner.become_nearsighted(TRAUMA_TRAIT)
	return ..()

/datum/status_effect/blindpoint/on_remove()
	owner.cure_nearsighted(TRAUMA_TRAIT)
	return ..()

/atom/movable/screen/alert/status_effect/blindpoint
	name = "Blinded"
	desc = "Ow! Your eyes sting after that laser shone in them."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"


#undef STATUS_EFFECT_BLINDPOINT
