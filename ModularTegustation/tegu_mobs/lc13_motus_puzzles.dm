GLOBAL_LIST_EMPTY(dagger_puzzle)
GLOBAL_LIST_EMPTY(heretic_puzzle)
/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle
	mark_once_attacked = FALSE
	return_to_origin = TRUE
	var/obj/item/crown_dagger_puzzle/wanted_item = null
	var/has_item = FALSE
	var/puzzle_fail = FALSE
	loot = list(/obj/item/keycard/motus_storage)
	attacked_line = "PROCEEDING WITH EXTERMINATION..."
	starting_looting_line = "WARNING, AUTHORIZED LOOTING DETECTED. DROP THE CROWBAR"
	ending_looting_line = "THEIR DETECTED, PROCEEDING WITH EXTERMINATION..."

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/Initialize()
	. = ..()
	glob_faction = GLOB.dagger_puzzle
	faction = list("neutral", "hostile")

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/examine(mob/user)
	. = ..()
	for(var/atom/movable/i in contents)
		if(istype(i, wanted_item))
			. += span_nicegreen("[src] is holding [i.name].")

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/attackby(obj/item/I, mob/living/user, params)
	if(I.force <= 0)
		if(istype(I, wanted_item))
			visible_message(span_nicegreen("\The [src] accepts the [I.name] from [user.name]!"))
			I.forceMove(src)
			has_item = TRUE
			finished_puzzle(user)
			return
		else
			visible_message(span_warning("\The [src] doesn't accept the [I.name] from [user.name]"))
			playsound(get_turf(src), 'sound/vox_fem/error.ogg', 50, FALSE, 5)
			if(!check_assassination())
				drop_items()
			return
	..()

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(istype(M, /mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle))
		var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/assassin_attacker = M
		if(assassin_attacker.puzzle_fail)
			visible_message(span_warning("\The [src] is assassinated by [assassin_attacker.name], and now their people are furious!"))
			sleep(20)
			for(var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/S in urange(10, get_turf(src)))
				S.faction = list("hostile")
				S.icon_state = "stone_guard"
				S.name = "stone guard"
			assassin_attacker.dust()
			dust()

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/proc/finished_puzzle(mob/living/smart_pal)
	var/correct_statue = 0
	for(var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/S in urange(10, get_turf(src)))
		if(S.has_item)
			correct_statue++
	if(correct_statue >= 6)
		visible_message(span_nicegreen("\The [src] suddenly produces a key and drops it on the groud, looks like you passed it's trial."))
		new /obj/item/keycard/motus_storage (get_turf(smart_pal))

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/proc/check_assassination()
	var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/king = null
	var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/assassin = null
	for(var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/S in urange(10, get_turf(src)))
		if(S.has_item && S.wanted_item == /obj/item/crown_dagger_puzzle/dagger)
			assassin = S
			continue
		if(S.has_item && S.wanted_item == /obj/item/crown_dagger_puzzle/crown)
			king = S
			continue
	if(king && assassin)
		visible_message(span_warning("[assassin.name] springs to life, planning to assassinate [king.name]!"))
		assassin.attack_same = TRUE
		assassin.puzzle_fail = TRUE
		assassin.GiveTarget(king)
		assassin.AttackingTarget(king)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/proc/drop_items()
	for(var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/S in urange(10, get_turf(src)))
		if(S.has_item)
			S.has_item = FALSE
			for(var/atom/movable/i in S.contents)
				if(istype(i, S.wanted_item))
					S.manual_emote("drops [i.name] to the ground")
					i.forceMove(get_turf(S))

/obj/item/crown_dagger_puzzle
	name = "puzzle item"
	desc = "A strange item... You could offer it to one of the statues around here..."
	w_class = WEIGHT_CLASS_SMALL

/obj/item/crown_dagger_puzzle/book
	name = "weathered book"
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	worn_icon_state = "book"

/obj/item/crown_dagger_puzzle/scythe
	name = "weathered scythe"
	icon_state = "scythe0"
	inhand_icon_state = "scythe0"
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'

/obj/item/crown_dagger_puzzle/dagger
	name = "weathered dagger"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	inhand_icon_state = "cultdagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32

/obj/item/crown_dagger_puzzle/spear
	name = "weathered spear"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bone_spear0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'

/obj/item/crown_dagger_puzzle/hammer
	name = "weathered hammer"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "hammer"

/obj/item/crown_dagger_puzzle/crown
	name = "weathered crown"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "fancycrown"

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/book
	name = "ink statue"
	desc = "A stone statue with inky hands, It appears to be waiting for something..."
	icon_state = "stone_ink"
	wanted_item = /obj/item/crown_dagger_puzzle/book

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/scythe
	name = "muddy statue"
	icon_state = "stone_muddy"
	desc = "A stone statue with muddy hands, It appears to be waiting for something..."
	wanted_item = /obj/item/crown_dagger_puzzle/scythe

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/dagger
	name = "bloody statue"
	desc = "A stone statue with bloody hands, It appears to be waiting for something..."
	icon_state = "stone_bloody"
	wanted_item = /obj/item/crown_dagger_puzzle/dagger

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/spear
	name = "wet statue"
	desc = "A stone statue with wet hands, It appears to be waiting for something..."
	icon_state = "stone_wet"
	wanted_item = /obj/item/crown_dagger_puzzle/spear

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/hammer
	name = "ash statue"
	desc = "A stone statue with ashy hands, It appears to be waiting for something..."
	icon_state = "stone_ash"
	wanted_item = /obj/item/crown_dagger_puzzle/hammer

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/crown
	name = "clean statue"
	desc = "A stone statue with clean hands, It appears to be waiting for something..."
	icon_state = "stone_clean"
	wanted_item = /obj/item/crown_dagger_puzzle/crown

/obj/item/keycard/motus_medbay
	name = "medbay keycard"
	desc = "A medbay keycard. How fantastic. Looks like it belongs to a high security door."
	color = "#0988ff"
	puzzle_id = "motus_medbay"

/obj/item/keycard/motus_storage
	name = "storage keycard"
	desc = "A storage keycard. How fantastic. Looks like it belongs to a high security door."
	color = "#b622db"
	puzzle_id = "motus_storage"

/obj/structure/puzzle_key_case
	name = "strange keycase"
	desc = "A case holding a key, however something feels off about it. If only you could test some items on it..."
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "key_case"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/key_type = "real"

/obj/structure/puzzle_key_case/Initialize()
	. = ..()
	shuffle_keys()

/obj/structure/puzzle_key_case/interact(mob/user, special_state)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/looter = user
		to_chat(user, span_notice("You slowly start reaching out for the key..."))
		if(do_after(user, 50, user))
			switch(key_type)
				if("real")
					to_chat(user, span_nicegreen("You collect the real key!"))
					new /obj/item/keycard/motus_library (get_turf(user))
					icon_state = "key_case_nokey"
					return

				if("illusion")
					visible_message(span_danger("The key was an illusion! Causing a cold chill to go down your spine!"))
					looter.deal_damage(80, WHITE_DAMAGE)
					playsound(get_turf(src), 'sound/hallucinations/veryfar_noise.ogg', 50, FALSE, 5)

				if("monster")
					visible_message(span_danger("The key was a mimic! Causing it to bite you!"))
					playsound(get_turf(src), 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg', 50, FALSE, 5)
					looter.deal_damage(80, BLACK_DAMAGE)

				if("explosive")
					visible_message(span_danger("The key was an explosive! Causing it to explode!"))
					new /obj/effect/temp_visual/explosion(get_turf(src))
					playsound(get_turf(src), 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
					for(var/mob/living/L in view(2, src))
						L.apply_damage(80, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))

		else
			to_chat(user, span_nicegreen("You change your mind at the last second."))
		shuffle_keys()
		say("Keys shuffled, please try again.")

/obj/structure/puzzle_key_case/proc/shuffle_keys()
	var/list/nearby_cases = list()
	for(var/obj/structure/puzzle_key_case/C in range(5, src))
		nearby_cases += C
	shuffle_inplace(nearby_cases)
	if(nearby_cases.len >= 4)
		case_shuffle(nearby_cases[1], "real")
		case_shuffle(nearby_cases[2], "illusion")
		case_shuffle(nearby_cases[3], "monster")
		case_shuffle(nearby_cases[4], "explosive")

/obj/structure/puzzle_key_case/proc/case_shuffle(obj/structure/case, newkey)
	if(istype(case, /obj/structure/puzzle_key_case))
		var/obj/structure/puzzle_key_case/shuffle_target = case
		shuffle_target.key_type = newkey
		shuffle_target.icon_state = "key_case"

/obj/structure/puzzle_key_case/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/flashlight))
		to_chat(user, span_notice("You start shining your [I.name] on the [src]"))
		if(do_after(user, 30, user))
			if(key_type == "illusion")
				to_chat(user, span_warning("You don't see a shadow bellow the key!"))
			else
				to_chat(user, span_notice("You see a shadow bellow the key"))

	if(istype(I, /obj/item/food))
		to_chat(user, span_notice("You start hovering your [I.name] around [src]"))
		if(do_after(user, 30, user))
			if(key_type == "monster")
				to_chat(user, span_warning("Notice the key slightly twitching!"))
			else
				to_chat(user, span_notice("Nothing happens"))

	if(istype(I, /obj/item/lighter))
		to_chat(user, span_notice("You start hovering your [I.name] around [src]"))
		if(do_after(user, 30, user))
			if(key_type == "explosive")
				to_chat(user, span_warning("You hear a small sizzle bellow the key!"))
			else
				to_chat(user, span_notice("Nothing happens"))

/obj/item/keycard/motus_library
	name = "library key"
	desc = "A library key. How fantastic. Looks like it belongs to a high security door."
	puzzle_id = "motus_library"
	icon_state = "golden_key"

/obj/machinery/door/keycard/puzzle_riddles
	desc = "This door appears to have a voice box attached to it, What could it be used for?"
	puzzle_id = "puzzle_door"
	color = "#fc7703"
	var/current_riddle = 1
	var/riddling = FALSE

/obj/machinery/door/keycard/puzzle_riddles/try_to_activate_door(mob/user)
	if(!riddling)
		riddling = TRUE
		if(current_riddle == 1)
			riddle_1(user)
			riddling = FALSE
			return
		if(current_riddle == 2)
			riddle_2(user)
			riddling = FALSE
			return
		if(current_riddle == 3)
			riddle_3(user)
			riddling = FALSE
			return
		if(current_riddle >= 4)
			open()
		riddling = FALSE
	. = ..()

/obj/machinery/door/keycard/puzzle_riddles/proc/riddle_1(mob/user)
	say("I don’t bite my nails, But I like to attack them. Headfirst and mouthless and clawing when required.")
	var/riddle_ask = input("I don’t bite my nails, But I like to attack them. Headfirst and mouthless and clawing when required.", "What is this?") as text
	if(riddle_ask == "Hammer" || riddle_ask == "hammer")
		current_riddle++
	else
		playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 40, TRUE)
		if(ishuman(user))
			var/mob/living/carbon/human/silly_person = user
			playsound(get_turf(silly_person), 'sound/weapons/sonic_jackhammer.ogg', 40, TRUE)
			silly_person.deal_damage(50, RED_DAMAGE)
			to_chat(silly_person, span_warning("The door extends some sort of tool and bonks you on the head!"))

/obj/machinery/door/keycard/puzzle_riddles/proc/riddle_2(mob/user)
	say("I can soar through the air with ease, But I’m not something you’ll want to seize.")
	sleep(20)
	say("My namesakes are scattered across the sky, If I catch your eye, it’s lights out - goodbye.")
	var/riddle_ask = input("I can soar through the air with ease, But I’m not something you’ll want to seize. My namesakes are scattered across the sky, If I catch your eye, it’s lights out - goodbye.", "What is this?") as text
	if(riddle_ask == "Throwing Star" || riddle_ask == "throwing star")
		current_riddle++
	else
		playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 40, TRUE)
		if(ishuman(user))
			var/mob/living/carbon/human/silly_person = user
			var/obj/item/throwing_star/stamina/ninja/ninja_star = new(get_turf(src))
			ninja_star.throw_at(silly_person, 10, 5)
			to_chat(silly_person, span_warning("The door fires something at you!"))

/obj/machinery/door/keycard/puzzle_riddles/proc/riddle_3(mob/user)
	say("I am the one that shifts between worlds, and hinders all who follow.")
	sleep(20)
	say("To name me is to speak of love, though what I block is hollow.")
	var/riddle_ask = input("I am the one that shifts between worlds, and hinders all who follow. To name me is to speak of love, though what I block is hollow.", "What is this?") as text
	if(riddle_ask == "Door" || riddle_ask == "door")
		current_riddle++
	else
		playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 40, TRUE)
		if(ishuman(user))
			var/mob/living/carbon/human/silly_person = user
			var/turf/starting_turf = get_turf(src)
			if(get_dist(src, silly_person) <= 2)
				visible_message("<span class='danger'>[src] tips over and falls on [silly_person]!</span>")
				silly_person.deal_damage(90, RED_DAMAGE)
				silly_person.Paralyze(60)
				silly_person.emote("scream")
				playsound(silly_person, 'sound/effects/blobattack.ogg', 40, TRUE)
				playsound(silly_person, 'sound/effects/splat.ogg', 50, TRUE)
				throw_at(get_turf(silly_person), 1, 1, spin=FALSE, quickstart=FALSE)
				sleep(20)
				visible_message("<span class='danger'>[src] teleports back!</span>")
				forceMove(starting_turf)

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle
	mark_once_attacked = TRUE
	return_to_origin = TRUE
	attacked_line = "PROCEEDING WITH EXTERMINATION..."
	starting_looting_line = "WARNING, AUTHORIZED LOOTING DETECTED. DROP THE CROWBAR"
	ending_looting_line = "THEIR DETECTED, PROCEEDING WITH EXTERMINATION..."
	loot = list(/obj/item/keycard/motus_medbay)
	var/heretic = FALSE
	var/talking = FALSE
	var/mutable_appearance/speech_bubble

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/Initialize()
	. = ..()
	speech_bubble = mutable_appearance('icons/mob/talk.dmi', "default2", ABOVE_MOB_LAYER)
	add_overlay(speech_bubble)
	glob_faction = GLOB.heretic_puzzle
	faction = list("neutral", "hostile")

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/attack_hand(mob/living/carbon/M)
	. = ..()
	if(!stat && M.a_intent == INTENT_HELP && !talking)
		puzzle_say()

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/proc/puzzle_say()
	speaking = TRUE
	say("Oh my de-ear students, You came at just the right ti-ime as it looks like we have an He-eretic here to hu-unt us down!")
	sleep(50)
	say("How-ever it a-appears that our Kni-ight is only able to tell lies...")
	sleep(30)
	say("Ou-ur Priest is only a-able to tell the truth...")
	sleep(30)
	say("and the He-eretic is a-able to say e-either!")
	sleep(30)
	say("Can you help me fi-igure out which one-e is the He-eretic?")
	sleep(30)
	say("Simply gi-ive them a good shake to ma-ake them give their alibi!")
	speaking = FALSE

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(heretic)
		clapping()
		visible_message(span_nicegreen("[src] drops a small keycard right before falling apart!"))
		new /obj/item/keycard/motus_medbay (get_turf(src))
		dust()
	else
		if(!(user in glob_faction))
			turn_hostile(user)

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/proc/clapping()
	for(var/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/S in urange(10, get_turf(src)))
		if(S != src)
			S.manual_emote("claps")
	sleep(20)
	for(var/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/S in urange(10, get_turf(src)))
		if(S != src)
			S.say("Thank you dear students, for slaying this heretic!")
	sleep(20)

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/proc/turn_hostile(mob/living/user)
	for(var/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/S in urange(10, get_turf(src)))
		S.heretic = FALSE
		S.say("You dare attack a civilian? We shall strike you down!")
	glob_faction += user

//The Statue that introduces the puzzle
/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/intro
	name = "royal statue"

//The Statue that is the target
/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/hood
	name = "hooded statue"
	heretic = TRUE
	mark_once_attacked = FALSE

/obj/structure/drone_maker
	name = "drone maker"
	desc = "A machine with controls implying that this machine could make drones."
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "drone_maker"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/active = FALSE

// /obj/structure/drone_maker/interact(mob/user, special_state)
// 	if(interaction_flags_machine & INTERACT_MACHINE_SET_MACHINE)
// 		user.set_machine(src)
// 	. = ..()

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/hood/puzzle_say()
	say("The one wearing robes is a Priest.")

//Other statues for the puzzle.
/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/robes
	name = "robed statue"

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/robes/puzzle_say()
	say("The one wearing armor is the Knight.")

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/armor
	name = "armored statue"

/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/armor/puzzle_say()
	say("I am the Heretic… Please stop me!")

/area/city/backstreets_room/temple_motus
	name = "Temple Reception"

/area/city/backstreets_room/temple_motus/factory
	name = "Temple Factory"

/area/city/backstreets_room/temple_motus/dorms
	name = "Temple Student Dorms"

/area/city/backstreets_room/temple_motus/study_a
	name = "Temple Study Room A"

/area/city/backstreets_room/temple_motus/study_b
	name = "Temple Study Room B"

/area/city/backstreets_room/temple_motus/main
	name = "Temple Main Hall"

/area/city/backstreets_room/temple_motus/library
	name = "Temple Library"

/area/city/backstreets_room/temple_motus/storage
	name = "Temple Storage"

/area/city/backstreets_room/temple_motus/treasure_hallway
	name = "Temple Treasure Hallway"

/area/city/backstreets_room/temple_motus/treasure_entrance
	name = "Temple Treasure Entrance"

/area/city/backstreets_room/temple_motus/treasure_room
	name = "Temple Treasure Room"

/area/city/backstreets_room/temple_motus/outskirts
	name = "Outskirts"

/area/city/backstreets_room/temple_motus/medbay
	name = "Temple Medbay"
