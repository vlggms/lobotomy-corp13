//Coded by Lance/REDACTED. Started on 8/2/2022. First time lets do this.
// This is my last attempt at coding this. If this doesn't get merged or even tested in the first place I'm not gonna continue wasting my time.

// GUESS WHO, THAT'S RIGHT, IT'S ME! Lance/REDACTED! Back at it 3 months later! Refactor this bitch!

// HEYYY IT'S MEEEEEE, REDACTEDDDD. Im back to rework this again. Less lethal, more pain.

#define STATUS_EFFECT_SG_GUILTY /datum/status_effect/sg_guilty

/mob/living/simple_animal/hostile/abnormality/silent_girl
	name = "Silent Girl"
	desc = "A purple haired girl in a sundress. You see a metalic glint from behind her back..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "silent_girl"
	portrait = "silent_girl"
	maxHealth = 650
	health = 650
	gender = FEMALE // Is this used basically anywhere? Not that I know of. But seeing "Gender: Male" on Silent Girl doesn't seem right.
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = list(-50, -50, 60, 60, 60),
		ABNORMALITY_WORK_ATTACHMENT = -50,
		ABNORMALITY_WORK_REPRESSION = list(50, 55, 55, 60, 60),
	)
	work_damage_amount = 0
	work_damage_type = WHITE_DAMAGE
	start_qliphoth = 3

	ego_list = list(
		/datum/ego_datum/weapon/remorse,
		/datum/ego_datum/armor/remorse,
	)
	gift_type = /datum/ego_gifts/remorse
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/GuiltEffect(mob/living/carbon/human/user, enable_qliphoth = TRUE, stack_count = 1)
	if (user.stat == DEAD)
		return
	if(enable_qliphoth)
		datum_reference.qliphoth_change(-1, user)
		user.apply_status_effect(STATUS_EFFECT_SG_GUILTY, datum_reference, stack_count)
	else
		user.apply_status_effect(STATUS_EFFECT_SG_GUILTY, null, stack_count)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 60)
		GuiltEffect(user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/AttemptWork(mob/living/carbon/human/user, work_type)
	if (user.has_status_effect(STATUS_EFFECT_SG_GUILTY))
		user.adjustSanityLoss(user.getMaxSanity()) // Suffer.
		user.remove_status_effect(STATUS_EFFECT_SG_GUILTY) // but Cleanse!
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/silent_girl/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40) && work_type == ABNORMALITY_WORK_INSIGHT)
		datum_reference.qliphoth_change(1, user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		GuiltEffect(user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	GuiltEffect(user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/ZeroQliphoth(mob/living/carbon/human/user)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat == DEAD)
			continue
		if(!(H.mind?.assigned_role in GLOB.security_positions)) // CLERKS AND MANAGERS ARE FREE!
			continue
		GuiltEffect(H, FALSE, 2)
	manual_emote("giggles.")
	sound_to_playing_players_on_level('sound/voice/human/womanlaugh.ogg', 50, zlevel = z)
	datum_reference.qliphoth_change(3, user)
	return

/datum/status_effect/sg_guilty
	id = "sg_guilt"
	status_type = STATUS_EFFECT_REFRESH
	// Duration left at default -1
	alert_type = /atom/movable/screen/alert/status_effect/sg_guilty
	var/mutable_appearance/guilt_icon
	var/datum/abnormality/datum_reference = null
	var/works_required = 1

/atom/movable/screen/alert/status_effect/sg_guilty
	name = "Guilty"
	desc = "A heavy weight lays upon you. What have you done?\nYour work success rate is reduced drastically."

/datum/status_effect/sg_guilty/on_creation(mob/living/new_owner, ...)
	datum_reference = args[2]
	if(!isnull(args[3]))
		works_required = args[3]
	guilt_icon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER)
	. = ..()
	linked_alert.desc = initial(linked_alert.desc)+" Complete [works_required] more Attachment works to attone."
	return

/datum/status_effect/sg_guilty/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_userdanger("You feel a heavy weight upon your shoulders."))
	playsound(get_turf(status_holder), 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 50, 0, 2)
	status_holder.add_overlay(guilt_icon)
	status_holder.physiology.work_success_mod *= 0.70
	RegisterSignal(status_holder, COMSIG_WORK_COMPLETED, PROC_REF(OnWorkComplete))

/datum/status_effect/sg_guilty/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("You feel a weight lift from your shoulders."))
	playsound(get_turf(status_holder), 'sound/abnormalities/silentgirl/Guilt_Remove.ogg', 50, 0, 2)
	status_holder.cut_overlay(guilt_icon)
	status_holder.physiology.work_success_mod /= 0.70
	UnregisterSignal(status_holder, COMSIG_WORK_COMPLETED)
	if(!isnull(datum_reference))
		INVOKE_ASYNC(datum_reference, TYPE_PROC_REF(/datum/abnormality, qliphoth_change), 1, owner)

/datum/status_effect/sg_guilty/refresh()
	playsound(get_turf(owner), 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 50, 0, 2)
	works_required++
	linked_alert.desc = initial(linked_alert.desc)+" Complete [works_required] more Attachment works to attone."

/datum/status_effect/sg_guilty/proc/OnWorkComplete(datum/source, datum/abnormality/abno_reference, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(work_type != ABNORMALITY_WORK_ATTACHMENT)
		return FALSE
	works_required--
	if(works_required > 0)
		linked_alert.desc = initial(linked_alert.desc)+" Complete [works_required] more Attachment works attone."
		return
	user.remove_status_effect(src)

#undef STATUS_EFFECT_SG_GUILTY
