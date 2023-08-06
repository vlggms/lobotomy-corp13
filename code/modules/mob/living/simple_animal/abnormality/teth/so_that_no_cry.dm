#define STATUS_EFFECT_TALISMAN /datum/status_effect/stacking/talisman
#define STATUS_EFFECT_CURSETALISMAN /datum/status_effect/stacking/curse_talisman
/mob/living/simple_animal/hostile/abnormality/so_that_no_cry
	name = "So That No One Will Cry"
	desc = "An abnormality taking the form of a wooden doll, various talismans are attached to it's body."
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
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/red_sheet,
		/datum/ego_datum/armor/red_sheet
		)
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/Apply_Talisman(mob/living/carbon/human/user)
	var/datum/status_effect/stacking/talisman/G = user.has_status_effect(/datum/status_effect/stacking/talisman)
	playsound(src, 'sound/abnormalities/goldenapple/Gold_Sparkle.ogg', 100, 1)
	if(!G)//applying the buff for the first time (it lasts for four minutes)
		user.apply_status_effect(STATUS_EFFECT_TALISMAN)
		to_chat(user, "<span class='nicegreen'>A talisman quietly dettaches from the abnormality and sticks to you.</span>")
	else//if the employee already has the buff
		to_chat(user, "<span class='nicegreen'>Another talisman sticks to you.</span>")
		G.add_stacks(1)
		G.refresh()
	return

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		Apply_Talisman(user)
	return

//**   STATUS EFFECTS  **//
/datum/status_effect/stacking/talisman //Justice increasing talismans
	id = "talisman"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 10 SECONDS //SHOULD last 10 seconds
	stack_decay = 0
	max_stacks = 6 //actual max is 5 for +20 justice, 6 instantly curses you
	stacks = 1
	stack_threshold = 6
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/talisman
	consumed_on_threshold = TRUE

/datum/status_effect/stacking/talisman/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 4 * stacks)

/datum/status_effect/stacking/talisman/add_stacks(stacks_added)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 4 * stacks_added)

/datum/status_effect/stacking/talisman/on_threshold_cross()
	. = ..()

/datum/status_effect/stacking/talisman/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -4 * stacks)

/atom/movable/screen/alert/status_effect/talisman
	name = "Talisman"
	desc = "TDescription."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "talisman"

/datum/status_effect/stacking/curse_talisman //Justice DECREASING talismans
	id = "curse_talisman"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 10 SECONDS //SHOULD last 10 seconds
	stack_decay = 0
	max_stacks = 6 //actual max is 5 for +20 justice, 6 instantly curses you
	stacks = 1
	stack_threshold = 6
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/curse_talisman
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/curse_talisman
	name = "Curse Talisman"
	desc = "CTDescription."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "talisman"

#undef STATUS_EFFECT_TALISMAN
#undef STATUS_EFFECT_CURSETALISMAN

