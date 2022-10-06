#define STATUS_EFFECT_MARKEDFORDEATH /datum/status_effect/markedfordeath
/mob/living/simple_animal/hostile/abnormality/cherry_blossoms
	name = "Grave of Cherry Blossoms"
	desc = "A beautiful cherry tree."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "graveofcherryblossoms_3"
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
		ABNORMALITY_WORK_REPRESSION = 20
			)
	start_qliphoth = 3
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/blossom,
		/datum/ego_datum/armor/blossom
		)
//	gift_type = /datum/ego_gifts/blossom

	pinkable = FALSE
	var/numbermarked = 5


/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	if(datum_reference.qliphoth_meter !=3)
		icon_state = "graveofcherryblossoms_[datum_reference.qliphoth_meter]"

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/zero_qliphoth(mob/living/carbon/human/user)
	mark_for_death()
	icon_state = "graveofcherryblossoms_0"
	datum_reference.qliphoth_change(3)
	return

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/proc/mark_for_death()
	var/list/potentialmarked = list()
	var/list/marked = list()

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
		to_chat(L, "<span class='danger'>It's cherry blossom season.</span>")

	SLEEP_CHECK_DEATH(10 SECONDS)
	for(var/i=numbermarked, i>=1, i--)
		var/mob/living/Y = pick(potentialmarked)
		if(faction_check_mob(Y, FALSE) || Y.z != z || Y.stat == DEAD)
			continue
		if(Y in marked)
			continue
		marked+=Y
		new /obj/effect/temp_visual/markedfordeath(get_turf(Y))
		to_chat(Y, "<span class='userdanger'>You feel like you're going to die!</span>")
		Y.apply_status_effect(STATUS_EFFECT_MARKEDFORDEATH)



//Mark for Death
//A very quick, frantic 10 seconds of instadeath.
/datum/status_effect/markedfordeath
	id = "markedfordeath"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 100		//Lasts 10 seconds
	alert_type = /atom/movable/screen/alert/status_effect/marked

/atom/movable/screen/alert/status_effect/marked
	name = "Marked For Death"
	desc = "You are marked for death. You will die when struck."

/datum/status_effect/markedfordeath/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 4
		L.physiology.white_mod *= 4
		L.physiology.black_mod *= 4
		L.physiology.pale_mod *= 4

/datum/status_effect/markedfordeath/tick()
	var/mob/living/carbon/human/Y = owner
	if(Y.sanity_lost)
		Y.death()
	if(owner.stat == DEAD)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.stat != DEAD)
				H.adjustBruteLoss(-500) // It heals everyone to full
				H.adjustSanityLoss(500) // It heals everyone to full
				H.remove_status_effect(STATUS_EFFECT_MARKEDFORDEATH)

/datum/status_effect/markedfordeath/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 4
		L.physiology.white_mod /= 4
		L.physiology.black_mod /= 4
		L.physiology.pale_mod /= 4

#undef STATUS_EFFECT_MARKEDFORDEATH
