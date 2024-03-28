#define STATUS_EFFECT_FRIENDSHIP /datum/status_effect/display/friendship
/mob/living/simple_animal/hostile/abnormality/galaxy_child
	name = "Child of the Galaxy"
	desc = "A young, lost child."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "galaxy"
	portrait = "galaxy_child"
	maxHealth = 650
	health = 650
	threat_level = HE_LEVEL
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 45,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	max_boxes = 16

	ego_list = list(
		/datum/ego_datum/weapon/galaxy,
		/datum/ego_datum/armor/galaxy,
	)
	gift_type = /datum/ego_gifts/galaxy
	gift_message = "A teardrop fell from the child’s dewy eyes, as stars showered from the sky."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	var/heal_cooldown_time = 2 SECONDS
	var/heal_cooldown
	var/list/galaxy_friend = list()
	var/heal_mod = 0.5 //0.25 heal/sec
	var/damage_mod = 60
	var/heal_amount
	var/damage_amount
	var/depressed = FALSE
	var/chance_modifier = 1

/mob/living/simple_animal/hostile/abnormality/galaxy_child/examine(mob/user)
	. = ..()
	if(depressed)
		. += span_info("He is sobbing inconsolably and has a forlorn demeanor.")

/mob/living/simple_animal/hostile/abnormality/galaxy_child/PostSpawn()
	. = ..()
	datum_reference.qliphoth_meter = 1

/mob/living/simple_animal/hostile/abnormality/galaxy_child/Life()
	. = ..()
	if(heal_cooldown < world.time)
		heal_cooldown = world.time + heal_cooldown_time
		heal()

/mob/living/simple_animal/hostile/abnormality/galaxy_child/WorkChance(mob/living/carbon/human/user, chance)
	return chance * chance_modifier

/mob/living/simple_animal/hostile/abnormality/galaxy_child/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(canceled)
		return
	if(!datum_reference.qliphoth_meter) //this sets galaxy_child to a state similar to just spawning in
		datum_reference.qliphoth_change(1)
	if(user in galaxy_friend)
		datum_reference.qliphoth_change(2)
	else //Does math, gives them the required stuff
		user.apply_status_effect(STATUS_EFFECT_FRIENDSHIP)
		galaxy_friend |= user
		heal_amount += heal_mod
		damage_amount += damage_mod
		RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(FriendDeath))
		src.say("I really, really like you! This pebble is super important to me! Please keep it with you forever.")

/mob/living/simple_animal/hostile/abnormality/galaxy_child/GiftUser(mob/living/carbon/human/user, pe, chance)
	if(pe <= 0) //work fail
		return
	if(depressed)
		chance = 100
		chance_modifier = 1
		depressed = FALSE
	return ..(user, pe, chance)

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/TurfTransform(turf/turf_type)
	for(var/turf/T in range(1,src))
		T.ChangeTurf(turf_type, flags = CHANGETURF_INHERIT_AIR)

/mob/living/simple_animal/hostile/abnormality/galaxy_child/OnQliphothChange(mob/living/carbon/human/user, amount, pre_qlip)
	if(!pre_qlip) //qliphoth increased from 0
		icon_state = "galaxy"
		TurfTransform(/turf/open/floor/facility/dark)

/mob/living/simple_animal/hostile/abnormality/galaxy_child/ZeroQliphoth(mob/living/carbon/human/user)
	if(LAZYLEN(galaxy_friend))
		for(var/mob/living/carbon/human/L in galaxy_friend)
			if(QDELETED(L))
				continue
			L.apply_damage(damage_amount, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			L.remove_status_effect(STATUS_EFFECT_FRIENDSHIP)
			UnregisterSignal(L, COMSIG_LIVING_DEATH)
			new /obj/effect/temp_visual/pebblecrack(get_turf(L))
			playsound(get_turf(L), "shatter", 50, TRUE)
			to_chat(L, span_userdanger("Your pebble violently shatters as Child of the Galaxy begins to weep!"))
	//reset everything
	heal_amount = 0
	damage_amount = 0
	if(galaxy_friend.len >= 2)
		depressed = TRUE
		chance_modifier = 1.25
	LAZYCLEARLIST(galaxy_friend)
	icon_state = "galaxy_weep"
	TurfTransform(/turf/open/floor/fakespace)

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/heal()
	if(LAZYLEN(galaxy_friend))
		for(var/mob/living/carbon/human/H in galaxy_friend)
			H.adjustBruteLoss(-heal_amount) // It heals everyone a bit every 2 seconds.
			H.adjustSanityLoss(-heal_amount)

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/FriendDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	datum_reference.qliphoth_change(-4)

//FRIEND
//For now, just a notification. If we ever want to do anything with it, it's here.
/datum/status_effect/display/friendship
	id = "friend"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1		//Lasts basically forever
	alert_type = /atom/movable/screen/alert/status_effect/friendship
	display_name = "galaxy"

/atom/movable/screen/alert/status_effect/friendship
	name = "Token of Friendship"
	desc = "With a sparking pebble in your possession, you recover HP and SP over time."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "friendship"

#undef STATUS_EFFECT_FRIENDSHIP

/obj/effect/temp_visual/pebblecrack
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "pebble_crack"
	alpha = 180
	duration = 3 SECONDS

/obj/effect/temp_visual/pebblecrack/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, alpha = 0, time = duration)
