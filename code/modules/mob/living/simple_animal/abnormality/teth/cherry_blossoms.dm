#define STATUS_EFFECT_MARKEDFORDEATH /datum/status_effect/markedfordeath
/mob/living/simple_animal/hostile/abnormality/cherry_blossoms
	name = "Grave of Cherry Blossoms"
	desc = "A beautiful cherry tree."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "graveofcherryblossoms_3"
	portrait = "cherry_blossoms"
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -16
	base_pixel_y = -16
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	start_qliphoth = 3
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/blossom,
		/datum/ego_datum/armor/blossom,
	)
	gift_type = /datum/ego_gifts/blossom
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	observation_prompt = "The tree is adorned with beautiful leaves growing here and there. <br>\
		The kind of sight you could never even hope to see in this dark and dreary place. <br>\
		You can take a moment to take in the beauty before you begin to work."
	observation_choices = list("Take in the beauty")
	correct_choices = list("Take in the beauty")
	observation_success_message = "You feel refreshed after just taking a moment to watch such a beautiful thing. <br>\
		This doesn't mean that you don't know that this is a dangerous abnormality. <br>\
		There is beauty even in great and terrible things. <br>\
		Even the bodies underneath this tree would agree with you."

	var/number_of_marks = 5


/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	if(datum_reference.qliphoth_meter !=3)
		icon_state = "graveofcherryblossoms_[datum_reference.qliphoth_meter]"

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/ZeroQliphoth(mob/living/carbon/human/user)
	INVOKE_ASYNC(src, PROC_REF(mark_for_death))
	icon_state = "graveofcherryblossoms_0"
	datum_reference.qliphoth_change(3)

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/proc/mark_for_death()
	var/list/potentialmarked = list()
	var/list/marked = list()

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
		to_chat(L, span_danger("It's cherry blossom season."))

	SLEEP_CHECK_DEATH(10 SECONDS)
	for(var/blossoming in 1 to number_of_marks)
		var/mob/living/Y = pick(potentialmarked)
		if(faction_check_mob(Y, FALSE) || Y.z != z || Y.stat == DEAD)
			continue
		if(Y in marked)
			continue
		marked += Y
		new /obj/effect/temp_visual/markedfordeath(get_turf(Y))
		to_chat(Y, span_userdanger("You feel like you're going to die!"))
		Y.apply_status_effect(STATUS_EFFECT_MARKEDFORDEATH)

//Mark for Death
//A very quick, frantic 10 seconds of instadeath.
/datum/status_effect/markedfordeath
	id = "markedfordeath"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/marked

/atom/movable/screen/alert/status_effect/marked
	name = "Marked For Death"
	desc = "You are marked for death. You will die when struck."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "marked_for_death"

/datum/status_effect/markedfordeath/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 4
	status_holder.physiology.white_mod *= 4
	status_holder.physiology.black_mod *= 4
	status_holder.physiology.pale_mod *= 4

/datum/status_effect/markedfordeath/tick()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		status_holder.death()
	if(owner.stat != DEAD)
		return
	for(var/mob/living/carbon/human/affected_human in GLOB.player_list)
		if(affected_human.stat == DEAD)
			continue
		affected_human.adjustBruteLoss(-500) // It heals everyone to full
		affected_human.adjustSanityLoss(-500) // It heals everyone to full
		affected_human.remove_status_effect(STATUS_EFFECT_MARKEDFORDEATH)

/datum/status_effect/markedfordeath/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 4
	status_holder.physiology.white_mod /= 4
	status_holder.physiology.black_mod /= 4
	status_holder.physiology.pale_mod /= 4

#undef STATUS_EFFECT_MARKEDFORDEATH
