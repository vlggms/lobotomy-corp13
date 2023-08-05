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

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	user.apply_status_effect(STATUS_EFFECT_TALISMANS)
	to_chat(user, "<span class='nicegreen'>Talismaned</span>")

/datum/status_effect/stacking/talismans
	id = "taslimans"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 10 SECONDS	//Lasts for a minute
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


#undef STATUS_EFFECT_TALISMANS
