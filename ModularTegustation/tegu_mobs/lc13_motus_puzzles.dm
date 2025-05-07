GLOBAL_LIST_EMPTY(dagger_puzzle)
GLOBAL_LIST_EMPTY(heretic_puzzle)
/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle
	mark_once_attacked = FALSE
	return_to_origin = TRUE
	var/obj/item/crown_dagger_puzzle/wanted_item = null
	var/has_item = FALSE
	var/puzzle_fail = FALSE
	attacked_line = "PROCEEDING WITH EXTERMINATION..."
	starting_looting_line = "WARNING, AUTHORIZED LOOTING DETECTED. DROP THE CROWBAR"
	ending_looting_line = "THEIR DETECTED, PROCEEDING WITH EXTERMINATION..."

/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/Initialize()
	. = ..()
	glob_faction = GLOB.dagger_puzzle
	faction = list("neutral")

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
		new /obj/item/keycard/loot_room (get_turf(smart_pal))

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
	desc = "You think you could give this to one of the status around here..."
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

/obj/item/keycard/loot_room
	name = "golden keycard"
	desc = "A golden keycard. How fantastic. Looks like it belongs to a high security door."
	color = "#ffca09"
	puzzle_id = "loot_room"
