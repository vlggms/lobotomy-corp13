#define STATUS_EFFECT_FRIENDSHIP /datum/status_effect/display/friendship
#define GALAXY_COOLDOWN (60 SECONDS)
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

	observation_prompt = "You entered the containment chamber. <br>\
		A child is standing there. <br>\"I know who you are.\" <br>\
		\"Of course. <br>We were born from each other.\" <br>You decided to......."
	observation_choices = list(
		"Exit the chamber" = list(TRUE, "You turned your back to the child and walked out. <br>\
			The pebble in your hands sparkles sways, and tickles. <br>It becomes the universe. <br>\
			\"Goodbye. <br>I hope you never come back.\" <br>As the child bid the cold farewell, he was smiling."),
		"Stay" = list(FALSE, "\"Will you stay here with me?\" <br>\"If you won't, I don't need you.\""),
	)

	var/heal_cooldown_time = 2 SECONDS
	var/heal_cooldown
	var/list/galaxy_friend = list()
	var/heal_mod = 0.5 //0.25 heal/sec
	var/damage_mod = 60
	var/heal_amount
	var/damage_amount
	var/depressed = FALSE
	var/chance_modifier = 1

	var/galaxy_cooldown
	var/galaxy_cooldown_time = 5 SECONDS

	attack_action_types = list(/datum/action/cooldown/friend_gift, /datum/action/cooldown/galaxygiftbreak)

/datum/action/cooldown/friend_gift
	name = "Gift Pebble"
	icon_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	button_icon_state = "friendship"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = GALAXY_COOLDOWN //5 seconds

/datum/action/cooldown/friend_gift/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/galaxy_child))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/galaxy_child/galaxy_child = owner
	StartCooldown()
	galaxy_child.manualgift()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/manualgift()
	var/list/nearby = viewers(7, src) // first call viewers to get all mobs that see us
	if((SSmaptype.maptype == "limbus_labs"))
		for(var/mob in nearby) // then sanitize the list
			if(mob == src) // cut ourselfes from the list
				nearby -= mob
			if(!ishuman(mob)) // cut all the non-humans from the list
				nearby -= mob
			//if(mob.stat == DEAD)
				//nearby -= mob
			if(mob in galaxy_friend) //cut who is already a friend
				nearby -= mob
		var/mob/living/carbon/human/new_friend = input(src, "Choose who you want to gift a pebble to", "Select your new friend") as null|anything in nearby // pick someone from the list
		var/giftask = alert(new_friend, "Do you wish to receive the child's gift?", "Recieve Gift", "Yes", "No")
		if(giftask == "Yes")
			new_friend.apply_status_effect(STATUS_EFFECT_FRIENDSHIP)
			galaxy_friend |= new_friend
			heal_amount += heal_mod
			damage_amount += damage_mod
			RegisterSignal(new_friend, COMSIG_LIVING_DEATH, PROC_REF(FriendDeath))
			icon_state = "galaxy"
			depressed = FALSE

/datum/action/cooldown/galaxygiftbreak
	name = "Break Gifts"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = GALAXY_COOLDOWN //5 seconds

/datum/action/cooldown/galaxygiftbreak/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/galaxy_child))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/galaxy_child/galaxy_child = owner
	StartCooldown()
	galaxy_child.break_gifts()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/break_gifts(mob/living/carbon/human/user)
	if((SSmaptype.maptype == "limbus_labs"))
		if(LAZYLEN(galaxy_friend))
			for(var/mob/living/carbon/human/L in galaxy_friend)
				if(QDELETED(L))
					continue
				L.deal_damage(damage_amount, BLACK_DAMAGE)
				L.remove_status_effect(STATUS_EFFECT_FRIENDSHIP)
				UnregisterSignal(L, COMSIG_LIVING_DEATH)
				new /obj/effect/temp_visual/pebblecrack(get_turf(L))
				playsound(get_turf(L), "shatter", 50, TRUE)
				to_chat(L, span_userdanger("Your pebble violently shatters as Child of the Galaxy begins to weep!"))
		//reset everything
		heal_amount = 0
		damage_amount = 0
		depressed = TRUE
		LAZYCLEARLIST(galaxy_friend)
		icon_state = "galaxy_weep"


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
			L.deal_damage(damage_amount, BLACK_DAMAGE)
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
	to_chat(src, span_userdanger("You sense that one of your friends has perished...."))
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

#undef GALAXY_COOLDOWN
