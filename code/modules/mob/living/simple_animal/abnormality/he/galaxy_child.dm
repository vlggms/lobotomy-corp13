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
	chem_type = /datum/reagent/abnormality/sin/gloom
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

	/// List of people who are our friends
	var/list/galaxy_friends = list()
	/// Used to calculate delta time for accurate healing no matter the lag
	var/last_healing_time

	/// How much healing per second do we add each time a new user takes the pebble
	var/heal_mod = 0.25
	/// The current amount of healing per second we do to pebble users
	var/healing_per_second = 0

	/// How much more damage we deal per a person that befriends us
	var/damage_mod = 60
	/// The current amount of damage we deal to pebble users when exploding
	var/damage_amount = 0

	/// Are we currently depressed after our friends perished?
	var/depressed = FALSE
	/// Multiplies work chance by itself, increases when depressed
	var/work_chance_modifier = 1

/mob/living/simple_animal/hostile/abnormality/galaxy_child/examine(mob/user)
	. = ..()
	if(depressed)
		. += span_info("He is sobbing inconsolably and has a forlorn demeanor.")

/mob/living/simple_animal/hostile/abnormality/galaxy_child/PostSpawn()
	. = ..()
	datum_reference.qliphoth_meter = 1
	if((SSmaptype.maptype == "limbus_labs"))
		var/datum/action/cooldown/friend_gift/gift = new()
		gift.Grant(src)
		var/datum/action/cooldown/galaxygiftbreak/antigift = new()
		antigift.Grant(src)

/mob/living/simple_animal/hostile/abnormality/galaxy_child/Destroy(force)
	break_gifts()
	return ..()

/mob/living/simple_animal/hostile/abnormality/galaxy_child/Life()
	. = ..()
	var/delta_time = (world.time - last_healing_time) / 10
	last_healing_time = world.time
	for(var/mob/living/carbon/human/friend as anything in galaxy_friends)
		friend.adjustBruteLoss(-(healing_per_second * delta_time))
		friend.adjustSanityLoss(-(healing_per_second * delta_time))

/mob/living/simple_animal/hostile/abnormality/galaxy_child/WorkChance(mob/living/carbon/human/user, chance)
	return chance * work_chance_modifier

/mob/living/simple_animal/hostile/abnormality/galaxy_child/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(canceled)
		return

	if(!datum_reference.qliphoth_meter) // This sets galaxy_child to a state similar to just spawning in
		datum_reference.qliphoth_change(1)

	if(user in galaxy_friends)
		datum_reference.qliphoth_change(2)
		return

	give_pebble(user)
	say("I really, really like you! This pebble is super important to me! Please keep it with you forever.")

/mob/living/simple_animal/hostile/abnormality/galaxy_child/GiftUser(mob/living/carbon/human/user, pe, chance)
	if(pe <= 0) // Work fail
		return
	if(depressed)
		chance = 100
		work_chance_modifier = initial(work_chance_modifier)
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
	break_gifts()
	TurfTransform(/turf/open/floor/fakespace)

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/give_pebble(mob/living/carbon/human/new_friend)
	if(!istype(new_friend))
		return

	new_friend.apply_status_effect(STATUS_EFFECT_FRIENDSHIP)
	galaxy_friends |= new_friend
	healing_per_second += heal_mod
	damage_amount += damage_mod
	RegisterSignal(new_friend, COMSIG_LIVING_DEATH, PROC_REF(on_friend_death))
	RegisterSignal(new_friend, COMSIG_PARENT_QDELETING, PROC_REF(on_friend_deletion))

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/break_gifts()
	for(var/mob/living/carbon/human/friend as anything in galaxy_friends)
		friend.deal_damage(damage_amount, BLACK_DAMAGE)
		friend.remove_status_effect(STATUS_EFFECT_FRIENDSHIP)
		UnregisterSignal(friend, COMSIG_LIVING_DEATH)
		UnregisterSignal(friend, COMSIG_PARENT_QDELETING)
		new /obj/effect/temp_visual/pebblecrack(get_turf(friend))
		playsound(get_turf(friend), "shatter", 50, TRUE)
		to_chat(friend, span_userdanger("Your pebble violently shatters as Child of the Galaxy begins to weep!"))

	healing_per_second = 0 // We reset our current bonuses
	damage_amount = 0
	if(length(galaxy_friends) > 1)
		depressed = TRUE
		work_chance_modifier *= 1.25
		galaxy_friends.Cut()

	else if(length(galaxy_friends))
		galaxy_friends.Cut()

	icon_state = "galaxy_weep"

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/on_friend_death(mob/living/dead_friend, gibbed)
	SIGNAL_HANDLER
	galaxy_friends -= dead_friend
	datum_reference.qliphoth_change(-4)
	dead_friend.remove_status_effect(STATUS_EFFECT_FRIENDSHIP)
	UnregisterSignal(dead_friend, COMSIG_LIVING_DEATH)
	UnregisterSignal(dead_friend, COMSIG_PARENT_QDELETING)
	new /obj/effect/temp_visual/pebblecrack(get_turf(dead_friend))
	playsound(dead_friend, "shatter", 50, TRUE)
	to_chat(src, span_userdanger("You sense that one of your friends has perished and feel your heart ache."))

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/on_friend_deletion(mob/deleted_friend)
	SIGNAL_HANDLER
	UnregisterSignal(deleted_friend, COMSIG_LIVING_DEATH)
	UnregisterSignal(deleted_friend, COMSIG_PARENT_QDELETING)
	galaxy_friends -= deleted_friend

/datum/action/cooldown/friend_gift
	name = "Gift Pebble"
	icon_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	button_icon_state = "friendship"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/friend_gift/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/abnormality/galaxy_child/galaxy_owner = owner
	if(!istype(galaxy_owner)) // Sorry, only the child can give pebbles
		return FALSE

	var/list/possible_friend_list = list()
	for(var/mob/living/carbon/human/possible_friend as anything in view(7, galaxy_owner)) // Get every valid human in range
		if(!istype(possible_friend))
			continue
		if(!possible_friend.client)
			continue
		if(possible_friend.stat == DEAD)
			continue
		if(possible_friend in galaxy_owner.galaxy_friends) // You can't have 2 pebbles batman
			continue

		possible_friend_list += possible_friend

	if(!length(possible_friend_list))
		to_chat(galaxy_owner, span_notice("There's nobody you can gift your pebble to."))
		return

	// pick someone to be your new best friend
	var/mob/living/carbon/human/new_friend = input(galaxy_owner, "Choose who you want to gift a pebble to", "Select your new friend") as null|anything in possible_friend_list
	if(!new_friend)
		return

	if(get_dist(galaxy_owner, new_friend) > 7) // User inputs can last a long time, make sure everything is still valid
		to_chat(galaxy_owner, span_warning("You can't reach [new_friend] from here!"))
		return

	if(new_friend.stat == DEAD)
		to_chat(galaxy_owner, span_warning("It's too late to save them..."))
		return

	var/giftask = alert(new_friend, "Do you wish to receive the child's gift?", "Recieve Gift", "Yes", "No")
	if(get_dist(galaxy_owner, new_friend) > 7) // I HATE USER INPUTS, JUST PRESS THE DAMN BUTTON IMMEDIATELLY
		to_chat(galaxy_owner, span_warning("You can't reach [galaxy_owner] from here!"))
		return

	if(giftask == "Yes")
		galaxy_owner.give_pebble(new_friend)
		galaxy_owner.icon_state = "galaxy"
		galaxy_owner.depressed = FALSE

	StartCooldown()
	return TRUE

/datum/action/cooldown/galaxygiftbreak
	name = "Break Gifts"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/galaxygiftbreak/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/abnormality/galaxy_child/galaxy_owner = owner
	if(!istype(galaxy_owner))
		return FALSE

	if(alert(galaxy_owner, "Are you sure you want to break all pebbles?", "Pebble toss", "Yes", "No") != "Yes")
		return FALSE

	var/friend_names = ""
	for(var/mob/past_friend as anything in galaxy_owner.galaxy_friends)
		friend_names = "[past_friend], [friend_names]"

	to_chat(galaxy_owner, span_userdanger("[friend_names].. They were never true friends..."))
	galaxy_owner.break_gifts()
	StartCooldown()
	return TRUE

//FRIEND
//For now, just a notification. If we ever want to do anything with it, it's here.
/datum/status_effect/display/friendship
	id = "friend"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1 // Lasts forever
	alert_type = /atom/movable/screen/alert/status_effect/friendship
	display_name = "galaxy"

/atom/movable/screen/alert/status_effect/friendship
	name = "Token of Friendship"
	desc = "With a sparking pebble in your possession, you recover HP and SP over time."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "friendship"

/obj/effect/temp_visual/pebblecrack
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "pebble_crack"
	alpha = 180
	duration = 3 SECONDS

/obj/effect/temp_visual/pebblecrack/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, alpha = 0, time = duration)

#undef STATUS_EFFECT_FRIENDSHIP
