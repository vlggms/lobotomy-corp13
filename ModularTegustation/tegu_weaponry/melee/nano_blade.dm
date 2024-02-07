/obj/item/melee/nano_blade
	name = "nanoforged blade"
	desc = "Glorious nippon steel, folded 1000 times."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "weeb_blade"
	lefthand_file = 'ModularTegustation/Teguicons/teguitems_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguitems_hold_right.dmi'
	flags_1 = CONDUCT_1
	obj_flags = UNIQUE_RENAME
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	sharpness = SHARP_EDGED
	force = 45
	throw_speed = 4
	throw_range = 5
	throwforce = 15
	block_chance = 40
	armour_penetration = 50
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "dice", "cut")

/obj/item/melee/nano_blade/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 25, 90, 5) //Not made for scalping victims, but will work nonetheless

/obj/item/melee/nano_blade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = block_chance / 2 //Pretty good...
	return ..()

/obj/item/melee/nano_blade/on_exit_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/nano_blade/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/nano_blade/on_enter_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/nano_blade/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/nano_blade/suicide_act(mob/user)
	if(prob(50))
		user.visible_message(span_suicide("[user] carves deep into [user.p_their()] torso! It looks like [user.p_theyre()] trying to commit seppuku..."))
	else
		user.visible_message(span_suicide("[user] carves a grid into [user.p_their()] chest! It looks like [user.p_theyre()] trying to commit sudoku..."))
	return (BRUTELOSS)

/obj/item/storage/belt/nano_blade
	name = "nanoforged blade sheath"
	desc = "It yearns to bath in the blood of your enemies... but you hold it back!"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "weeb_sheath"
	worn_icon_state = "sheath"
	w_class = WEIGHT_CLASS_BULKY
	force = 3
	var/primed = FALSE //Prerequisite to anime bullshit
	// ##The anime bullshit## - Mostly stolen from action/innate/dash
	var/dash_sound = 'ModularTegustation/Tegusounds/weapons/unsheathed_blade.ogg'
	var/beam_effect = "blood_beam"
	var/phasein = /obj/effect/temp_visual/dir_setting/cult/phase
	var/phaseout = /obj/effect/temp_visual/dir_setting/cult/phase

/obj/item/storage/belt/nano_blade/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.rustle_sound = FALSE
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/melee/nano_blade
		))

/obj/item/storage/belt/nano_blade/examine(mob/user)
	. = ..()
	if(length(contents))
		. += "<span class='notice'>Use [src] in-hand to prime for an opening strike."
		. += span_info("Alt-click it to quickly draw the blade.")

/obj/item/storage/belt/nano_blade/AltClick(mob/user)
	if(!iscarbon(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)) || primed)
		return
	if(length(contents))
		var/obj/item/I = contents[1]
		playsound(user, dash_sound, 25, TRUE)
		user.visible_message(span_notice("[user] swiftly draws \the [I]."), span_notice("You draw \the [I]."))
		user.put_in_hands(I)
		update_icon()
	else
		to_chat(user, span_warning("[src] is empty!"))

/obj/item/storage/belt/nano_blade/attack_self(mob/user)
	if(!iscarbon(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(length(contents))
		var/datum/component/storage/CP = GetComponent(/datum/component/storage)
		if(primed)
			CP.locked = FALSE
			playsound(user, 'sound/items/sheath.ogg', 25, TRUE)
			to_chat(user, span_notice("You return your stance."))
			primed = FALSE
			update_icon()
		else
			CP.locked = TRUE //Prevents normal removal of the blade while primed
			playsound(user, 'sound/items/unsheath.ogg', 25, TRUE)
			user.visible_message(span_warning("[user] grips the blade within [src] and primes to attack."), span_warning("You take an opening stance..."), span_warning("You hear a weapon being drawn..."))
			primed = TRUE
			update_icon()
	else
		to_chat(user, span_warning("[src] is empty!"))

/obj/item/storage/belt/nano_blade/afterattack(atom/A, mob/living/user, proximity_flag, params)
	. = ..()
	if(primed && length(contents))
		var/obj/item/I = contents[1]
		if(!user.put_in_inactive_hand(I))
			to_chat(user, span_warning("You need a free hand!"))
			return
		if(!(A in view(user.client.view, user)))
			return
		var/datum/component/storage/CP = GetComponent(/datum/component/storage)
		CP.locked = FALSE
		primed = FALSE
		update_icon()
		primed_attack(A, user)
		if(CanReach(A, I))
			I.melee_attack_chain(user, A, params)
		user.swap_hand()

/obj/item/storage/belt/nano_blade/proc/primed_attack(atom/target, mob/living/user)
	var/turf/end = get_turf(user)
	var/turf/start = get_turf(user)
	var/obj/spot1 = new phaseout(start, user.dir)
	var/halt = FALSE
	// Stolen dash code
	for(var/T in getline(start, get_turf(target)))
		var/turf/tile = T
		for(var/mob/living/victim in tile)
			if(victim != user)
				playsound(victim, 'ModularTegustation/Tegusounds/weapons/anime_slash.ogg', 30, TRUE)
				victim.take_bodypart_damage(15)
		// Unlike actual ninjas, we stop noclip-dashing here.
		if(isclosedturf(T))
			halt = TRUE
		for(var/obj/O in tile)
			// We ignore mobs as we are cutting through them
			if(!O.CanPass(user, tile))
				halt = TRUE
		if(halt)
			break
		else
			end = T
	user.forceMove(end) // YEET
	playsound(start, dash_sound, 35, TRUE)
	var/obj/spot2 = new phasein(end, user.dir)
	spot1.Beam(spot2, beam_effect, time=20)
	user.visible_message(span_warning("In a flash of red, [user] draws [user.p_their()] blade!"), span_notice("You dash forward while drawing your weapon!"), span_warning("You hear a blade slice through the air at impossible speeds!"))

/obj/item/storage/belt/nano_blade/update_icon_state()
	icon_state = "weeb_sheath"
	worn_icon_state = "sheath"
	if(contents.len)
		if(primed)
			icon_state += "-primed"
		else
			icon_state += "-blade"
		worn_icon_state += "-sabre"
		inhand_icon_state = initial(inhand_icon_state)

/obj/item/storage/belt/nano_blade/PopulateContents()
	new /obj/item/melee/nano_blade(src)
	update_icon()
