#define STATUS_EFFECT_COWARDICE /datum/status_effect/cowardice
/mob/living/simple_animal/hostile/abnormality/crumbling_armor
	name = "Crumbling Armor"
	desc = "A thoroughly aged suit of samurai style armor with a V shaped crest on the helmet. It appears desuetude."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "crumbling"
	portrait = "crumbling_armor"
	maxHealth = 600
	health = 600
	start_qliphoth = 3
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 65, 65, 70),
	)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/daredevil,
		/datum/ego_datum/armor/daredevil,
	)
	gift_type = null
	gift_chance = 100
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	var/buff_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	var/user_armored
	var/numbermarked
	var/meltdown_cooldown //no spamming the meltdown effect
	var/meltdown_cooldown_time = 30 SECONDS

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/Initialize(mapload)
	. = ..()
	// Megalovania?
	if (prob(1))
		icon_state = "megalovania"

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/proc/Cut_Head(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4))
		if (work_type != ABNORMALITY_WORK_ATTACHMENT)
			return
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return FALSE
		if(!isnull(user.ego_gift_list[HAT]) && istype(user.ego_gift_list[HAT], /datum/ego_gifts))
			var/datum/ego_gifts/removed_gift = user.ego_gift_list[HAT]
			removed_gift.Remove(user)
			//user.ego_gift_list[HAT].Remove(user)
		head.dismember()
		user.adjustBruteLoss(500)
		datum_reference.qliphoth_change(-1)
		return TRUE
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if (get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return
		head.dismember()
		user.adjustBruteLoss(500)
		datum_reference.qliphoth_change(-1)
		return
	if(user.stat != DEAD && work_type == ABNORMALITY_WORK_REPRESSION)
		if (src.icon_state == "megalovania")
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase2/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("How much more will it take?"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase3/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("You need more strength!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase4/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("DETERMINATION."))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
			var/datum/ego_gifts/phase1/CAEG = new
			CAEG.datum_reference = datum_reference
			user.Apply_Gift(CAEG)
			RegisterSignal(user, COMSIG_WORK_STARTED, PROC_REF(Cut_Head))
			to_chat(user, span_userdanger("Just a drop of blood is what it takes..."))
		else
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/recklessCourage/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("Your muscles flex with strength!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/recklessFoolish/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("You feel like you could take on the world!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/foolish/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("You are a God among men!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
			var/datum/ego_gifts/courage/CAEG = new
			CAEG.datum_reference = datum_reference
			user.Apply_Gift(CAEG)
			RegisterSignal(user, COMSIG_WORK_STARTED, PROC_REF(Cut_Head))
			to_chat(user, span_userdanger("A strange power flows through you!"))
	return

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(3) //no need for qliphoth to be stuck at 0
	if(meltdown_cooldown > world.time)
		return
	meltdown_cooldown = world.time + meltdown_cooldown_time
	MeltdownEffect()
	return

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/proc/MeltdownEffect(mob/living/carbon/human/user)
	var/list/potentialmarked = list()
	var/list/marked = list()
	sound_to_playing_players_on_level('sound/abnormalities/crumbling/globalwarning.ogg', 25, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
		to_chat(L, span_userdanger("You feel an overwhelming sense of dread."))

	numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
	SLEEP_CHECK_DEATH(10 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/crumbling/warning.ogg', 50, zlevel = z)
	var/mob/living/Y
	for(var/i = numbermarked, i>=1, i--)
		if(potentialmarked.len <= 0)
			break
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(Y.stat == DEAD) //they chose to die instead of facing the fear
			continue
		marked+=Y
		playsound(get_turf(Y), 'sound/abnormalities/crumbling/warning.ogg', 50, FALSE, -1)

	SLEEP_CHECK_DEATH(1 SECONDS)
	for(Y in marked)
		to_chat(Y, span_userdanger("Show me that you can stand your ground!"))
		new /obj/effect/temp_visual/markedfordeath(get_turf(Y))
		Y.apply_status_effect(STATUS_EFFECT_COWARDICE)

//status
/datum/status_effect/cowardice
	id = "cowardice"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/cowardice
	var/punishment_damage = 25

/atom/movable/screen/alert/status_effect/cowardice
	name = "Cowardice"
	desc = "Show me that you can stand your ground!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "crumbling"

/datum/status_effect/cowardice/on_apply()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(Punishment))
	return..()

/datum/status_effect/cowardice/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	return..()

/datum/status_effect/cowardice/proc/Punishment()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/status_holder = owner
	if(!istype(status_holder))
		return
	var/obj/item/bodypart/head/holders_head = owner.get_bodypart("head")
	if(!istype(holders_head))
		return FALSE
	playsound(get_turf(status_holder), 'sound/abnormalities/crumbling/attack.ogg', 50, FALSE)
	status_holder.apply_damage(punishment_damage, PALE_DAMAGE, null, status_holder.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	if(status_holder.health < 0)
		holders_head.dismember()
	new /obj/effect/temp_visual/slice(get_turf(status_holder))
	qdel(src)


//gifts
/datum/ego_gifts/courage
	name = "Inspired Courage"
	icon_state = "courage"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessCourage
	name = "Reckless Courage"
	icon_state = "recklessFirst"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessFoolish
	name = "Reckless Foolishness"
	icon_state = "recklessSecond"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/foolish
	name = "Reckless Foolishness"
	icon_state = "foolish"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT
/datum/ego_gifts/phase1
	name = "Lv 4"
	icon_state = "phase1"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase2
	name = "Lv 10"
	icon_state = "phase2"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase3
	name = "Lv 15"
	icon_state = "phase3"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/phase4
	name = "Lv 19"
	icon_state = "phase4"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT

#undef STATUS_EFFECT_COWARDICE
