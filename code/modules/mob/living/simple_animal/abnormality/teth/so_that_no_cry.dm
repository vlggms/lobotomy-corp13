#define STATUS_EFFECT_TALISMAN /datum/status_effect/stacking/talisman
#define STATUS_EFFECT_CURSETALISMAN /datum/status_effect/stacking/curse_talisman
/mob/living/simple_animal/hostile/abnormality/so_that_no_cry
	name = "So That No One Will Cry"
	desc = "An abnormality taking the form of a wooden doll, various strange paper talismans are attached to it's body."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "so_that_no_cry"
	maxHealth = 800
	health = 800
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = list(45, 50, 55, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 60
				)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	base_pixel_x = -12
	pixel_x = -12

	ego_list = list(
		/datum/ego_datum/weapon/red_sheet,
		/datum/ego_datum/armor/red_sheet
		)
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/Apply_Talisman(mob/living/carbon/human/user)
	var/datum/status_effect/stacking/curse_talisman/C = user.has_status_effect(/datum/status_effect/stacking/curse_talisman)
	var/datum/status_effect/stacking/talisman/G = user.has_status_effect(/datum/status_effect/stacking/talisman)
	playsound(src, 'sound/abnormalities/so_that_no_cry/talisman.ogg', 100, 1)
	if (!C)//cant take talismans if cursed already
		if(!G)//applying the buff for the first time (it lasts for four minutes)
			user.apply_status_effect(STATUS_EFFECT_TALISMAN)
			to_chat(user, "<span class='nicegreen'>A talisman quietly dettaches from the abnormality and sticks to you.</span>")
		else//if the employee already has the buff, add a stack and refresh
			to_chat(user, "<span class='nicegreen'>Another talisman sticks to you.</span>")
			G.add_stacks(1)
			G.refresh()
	return

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/Remove_Talisman(mob/living/carbon/human/user)
	var/datum/status_effect/stacking/talisman/G = user.has_status_effect(/datum/status_effect/stacking/talisman)
	if(G)//remove the buff
		G.safe_removal = TRUE
		user.remove_status_effect(STATUS_EFFECT_TALISMAN)
		to_chat(user, "<span class='nicegreen'>You place all of your talismans back onto the abnormality.</span>")
	return

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		Remove_Talisman(user)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		Apply_Talisman(user)
	return

//**   STATUS EFFECTS  **//
//TALISMAN
/datum/status_effect/stacking/talisman //Justice increasing talismans
	id = "talisman"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 240 SECONDS //Lasts for 4 minutes
	stack_decay = 0 //Without this the stacks were decaying after 1 sec
	max_stacks = 6 //actual max is 5 for +25 Justice, 6 instantly curses you
	stacks = 1
	stack_threshold = 6 //instacurse
	alert_type = /atom/movable/screen/alert/status_effect/talisman
	consumed_on_threshold = TRUE
	var/safe_removal = FALSE

/datum/status_effect/stacking/talisman/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 5)
	return ..()

/datum/status_effect/stacking/talisman/add_stacks(stacks_added)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 5 * stacks_added)//max of 25
	return ..()

/datum/status_effect/stacking/talisman/threshold_cross_effect()
	var/mob/living/carbon/human/H = owner
	safe_removal = TRUE
	H.apply_status_effect(STATUS_EFFECT_CURSETALISMAN)
	var/datum/status_effect/stacking/curse_talisman/G = H.has_status_effect(/datum/status_effect/stacking/curse_talisman)
	G.add_stacks(5)
	return ..()

/datum/status_effect/stacking/talisman/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -5 * stacks)
		if(safe_removal == TRUE)
			safe_removal = FALSE
			return ..()
		if (stacks > 0)
			safe_removal = FALSE
			H.apply_status_effect(STATUS_EFFECT_CURSETALISMAN)
			var/datum/status_effect/stacking/curse_talisman/G = H.has_status_effect(/datum/status_effect/stacking/curse_talisman)
			G.add_stacks(stacks-1)
	return ..()

/atom/movable/screen/alert/status_effect/talisman
	name = "Talisman"
	desc = "These feel oddly soothing, as if they gave you strength."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "talisman"

//CURSE TALISMAN
/datum/status_effect/stacking/curse_talisman //Justice DECREASING talismans
	id = "curse_talisman"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 360 SECONDS //Lasts for 6 minutes
	stack_decay = 0 //Without this the stacks were decaying after 1 sec
	max_stacks = 6 // -7 per stack, up to -42 Justice
	stacks = 1
	alert_type = /atom/movable/screen/alert/status_effect/curse_talisman
	consumed_on_threshold = FALSE

/datum/status_effect/stacking/curse_talisman/on_apply()
	if(ishuman(owner))
		playsound(src, 'sound/abnormalities/so_that_no_cry/curse_talisman.ogg', 100, 1)
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -7 * stacks)
	return ..()

datum/status_effect/stacking/curse_talisman/add_stacks(stacks_added)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -7 * stacks_added)//max of -42
	return ..()

/datum/status_effect/stacking/curse_talisman/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 7 * stacks)
	return ..()

/atom/movable/screen/alert/status_effect/curse_talisman
	name = "Curse Talisman"
	desc = "You feel your strength being sapped away..."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "curse_talisman"

#undef STATUS_EFFECT_TALISMAN
#undef STATUS_EFFECT_CURSETALISMAN
