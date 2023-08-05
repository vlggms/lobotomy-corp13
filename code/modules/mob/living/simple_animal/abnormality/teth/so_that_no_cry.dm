#define STATUS_EFFECT_TALISMANS /datum/status_effect/stacking/talismans
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

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/Apply_Talismans(mob/living/carbon/human/user)
	var/datum/status_effect/stacking/talismans/T = user.has_status_effect(/datum/status_effect/stacking/talismans)
	playsound(src, 'sound/abnormalities/goldenapple/Gold_Sparkle.ogg', 60, 1)
	if(!T)//applying the buff for the first time (it lasts for four minutes)
		user.apply_status_effect(STATUS_EFFECT_TALISMANS)
		to_chat(user, "<span class='nicegreen'>A talisman quietly dettaches from the abnormality and sticks to your clothes.</span>")
	else//if the employee already has the buff
		to_chat(user, "<span class='nicegreen'>Another talisman sticks to you.</span>")
		T.add_stacks(1)
		T.refresh()
	return

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		Apply_Talismans(user)

/datum/status_effect/stacking/talismans
	id = "talismans"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 60 SECONDS	//Lasts for four minute
	max_stacks = 6 //Actual maximum is 5 for a +20 justice bonus, 6 will instantly curse you.
	stacks = 1
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/talismans
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/talismans
	name = "Talismans"
	desc = "Talismans desc."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "golden_sheen"

/datum/status_effect/stacking/talismans/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE,stacks * 4)

/datum/status_effect/stacking/talismans/add_stacks()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE,(stacks * 4)-4)

/datum/status_effect/stacking/talismans/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE,stacks * -4)


#undef STATUS_EFFECT_TALISMANS
