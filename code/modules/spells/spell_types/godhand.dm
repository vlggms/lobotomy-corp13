/obj/item/melee/touch_attack
	name = "\improper outstretched hand"
	desc = "High Five?"
	var/catchphrase = "High Five!"
	var/on_use_sound = null
	var/obj/effect/proc_holder/spell/targeted/touch/attached_spell
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	icon_state = "latexballon"
	inhand_icon_state = null
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/charges = 1

/obj/item/melee/touch_attack/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/melee/touch_attack/attack(mob/target, mob/living/carbon/user)
	if(!iscarbon(user)) //Look ma, no hands
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, span_warning("You can't reach out!"))
		return
	..()

/obj/item/melee/touch_attack/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(catchphrase)
		user.say(catchphrase, forced = "spell")
	playsound(get_turf(user), on_use_sound,50,TRUE)
	charges--
	if(charges <= 0)
		qdel(src)

/obj/item/melee/touch_attack/Destroy()
	if(attached_spell)
		attached_spell.on_hand_destroy(src)
	return ..()

/obj/item/melee/touch_attack/disintegrate
	name = "\improper smiting touch"
	desc = "This hand of mine glows with an awesome power!"
	catchphrase = "EI NATH!!"
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "disintegrate"
	inhand_icon_state = "disintegrate"

/obj/item/melee/touch_attack/disintegrate/afterattack(mob/living/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !istype(target) || !iscarbon(user) || !(user.mobility_flags & MOBILITY_USE)) //exploding after touching yourself would be bad
		return
	if(!user.can_speak_vocal())
		to_chat(user, span_warning("You can't get the words out!"))
		return
	do_sparks(4, FALSE, target.loc)
	for(var/mob/living/L in view(src, 7))
		if(L != user)
			L.flash_act(affect_silicon = FALSE)
	var/atom/A = target.anti_magic_check()
	if(A)
		if(isitem(A))
			target.visible_message(span_warning("[target]'s [A] glows brightly as it wards off the spell!"))
		user.visible_message(span_warning("The feedback blows [user]'s arm off!"),span_userdanger("The spell bounces from [target]'s skin back into your arm!"))
		user.flash_act()
		var/obj/item/bodypart/part = user.get_holding_bodypart_of_item(src)
		if(part)
			part.dismember()
		return ..()
	var/obj/item/clothing/suit/hooded/bloated_human/suit = target.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(suit))
		target.visible_message(span_danger("[target]'s [suit] explodes off of them into a puddle of gore!"))
		target.dropItemToGround(suit)
		qdel(suit)
		new /obj/effect/gibspawner(target.loc)
		return ..()
	target.gib()
	return ..()

/obj/item/melee/touch_attack/fleshtostone
	name = "\improper petrifying touch"
	desc = "That's the bottom line, because flesh to stone said so!"
	catchphrase = "STAUN EI!!"
	on_use_sound = 'sound/magic/fleshtostone.ogg'
	icon_state = "fleshtostone"
	inhand_icon_state = "fleshtostone"

/obj/item/melee/touch_attack/fleshtostone/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user)) //getting hard after touching yourself would also be bad
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, span_warning("You can't reach out!"))
		return
	if(!user.can_speak_vocal())
		to_chat(user, span_warning("You can't get the words out!"))
		return
	var/mob/living/M = target
	if(M.anti_magic_check())
		to_chat(user, span_warning("The spell can't seem to affect [M]!"))
		to_chat(M, span_warning("You feel your flesh turn to stone for a moment, then revert back!"))
		..()
		return
	M.Stun(40)
	M.petrify()
	return ..()


/obj/item/melee/touch_attack/duffelbag
	name = "\improper burdening touch"
	desc = "Where is the bar from here?"
	catchphrase = "HU'SWCH H'ANS!!"
	on_use_sound = 'sound/magic/mm_hit.ogg'
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"

/obj/item/melee/touch_attack/duffelbag/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user)) //Roleplay involving touching is equally as bad
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, span_warning("You can't reach out!"))
		return
	if(!user.can_speak_vocal())
		to_chat(user, span_warning("You can't get the words out!"))
		return
	var/mob/living/carbon/duffelvictim = target
	var/elaborate_backstory = pick("spacewar origin story", "military background", "corporate connections", "life in the colonies", "anti-government activities", "upbringing on the space farm", "fond memories with your buddy Keith")
	if(duffelvictim.anti_magic_check())
		to_chat(user, span_warning("The spell can't seem to affect [duffelvictim]!"))
		to_chat(duffelvictim, span_warning("You really don't feel like talking about your [elaborate_backstory] with complete strangers today."))
		..()
		return

	duffelvictim.flash_act()
	duffelvictim.Immobilize(5 SECONDS)
	duffelvictim.deal_damage(80, STAMINA, source = user, attack_type = (ATTACK_TYPE_MELEE))
	duffelvictim.Knockdown(5 SECONDS)

	if(HAS_TRAIT(target, TRAIT_DUFFEL_CURSED))
		to_chat(user, span_warning("The burden of [duffelvictim]'s duffel bag becomes too much, shoving them to the floor!"))
		to_chat(duffelvictim, span_warning("The weight of this bag becomes overburdening!"))
		return ..()

	var/obj/item/storage/backpack/duffelbag/cursed/conjuredduffel= new get_turf(target)

	duffelvictim.visible_message(span_danger("A growling duffel bag appears on [duffelvictim]!"), \
						   span_danger("You feel something attaching itself to you, and a strong desire to discuss your [elaborate_backstory] at length!"))

	if(duffelvictim.dropItemToGround(duffelvictim.back))
		duffelvictim.equip_to_slot_if_possible(conjuredduffel, ITEM_SLOT_BACK, TRUE, TRUE)
	else
		if(!duffelvictim.put_in_hands(conjuredduffel))
			duffelvictim.dropItemToGround(duffelvictim.get_inactive_held_item())
			if(!duffelvictim.put_in_hands(conjuredduffel))
				duffelvictim.dropItemToGround(duffelvictim.get_active_held_item())
				duffelvictim.put_in_hands(conjuredduffel)
			else
				return ..()
	return ..()

/obj/item/melee/touch_attack/necrotic_revival
	name = "\improper Necromancer's touch"
	desc = "An overwhelmingly powerful energy that can revive dead creatures on touch."
	catchphrase = "Rise again!"
	on_use_sound = 'sound/magic/voidblink.ogg'
	icon_state = "necrotic_revival"
	inhand_icon_state = "necrotic_revival"

/obj/item/melee/touch_attack/necrotic_revival/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !ishuman(target) || !iscarbon(user))
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, span_warning("You can't reach out!"))
		return
	if(!user.can_speak_vocal())
		to_chat(user, span_warning("You can't get the words out!"))
		return
	var/mob/living/carbon/human/H = target
	if(H.anti_magic_check())
		to_chat(user, span_warning("The spell can't seem to affect [H]!"))
		..()
		return
	if(H.stat != DEAD)
		if(isskeleton(target) || isvampire(target) || iszombie(target))
			H.revive(full_heal = TRUE, admin_revive = TRUE)
			to_chat(H, span_userdanger("You have been healed by [user.real_name]!"))
			return ..()
		to_chat(user, span_warning("The spell can only affect the dead, or living dead!"))
		return
	var/mob/dead/observer/ghost = H.get_ghost(TRUE, TRUE)
	if(!H.client)
		if(ghost?.can_reenter_corpse)
			ghost.reenter_corpse()
		else
			to_chat(user, span_warning("[H] has no soul!"))
			return

	H.set_species(/datum/species/skeleton/necromancer, icon_update=0)
	H.revive(full_heal = TRUE, admin_revive = TRUE)
	to_chat(H, span_userdanger("You have been revived by [user.real_name]!"))

	return ..()

/obj/item/melee/touch_attack/arbiterpunch //Re-uses a bunch of assets, I know
	name = "\improper "
	desc = "That's the bottom line, because flesh to stone said so!"
	catchphrase = "Fall."
	on_use_sound = 'sound/magic/arbiter/pin.ogg'
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"

/obj/item/melee/touch_attack/arbiterpunch/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(target == user || !isliving(target) || !iscarbon(user)) //getting hard after touching yourself would also be bad
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, span_warning("You can't reach out!"))
		return
	if(!ishuman(target))
		return ..()
	var/mob/living/M = target
	if(!proximity)
		var/obj/effect/temp_visual/target_field/yellow/uhoh = new /obj/effect/temp_visual/target_field/yellow(M.loc)
		uhoh.orbit(M, 0)
		playsound(M, 'sound/magic/arbiter/pillar_hit.ogg', 100, 1)
		playsound(src, 'sound/magic/arbiter/knock.ogg', 1, 1)
		to_chat(target, span_danger("The [user] is getting ready to rush you!"))
		if(do_after(user, 30, src))
			if(!istype(M) || QDELETED(M) || !M.loc || QDELETED(user) || !can_see(user, M))
				qdel(uhoh)
				return
			for(var/i in 2 to get_dist(user, M))
				step_towards(user,M)
			if((get_dist(user, M) < 2))
				afterattack(M,user, TRUE)
			playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
			to_chat(user, span_warning("You dash to [M]!"))
		qdel(uhoh)
		return

	var/mob/living/carbon/human/H = M
	var/potential_target_list = list() //Grab all the limbs and see if one's worth taking
	var/actual_target_list = list()
	var/obj/item/bodypart/left_leg = H.get_bodypart(BODY_ZONE_L_LEG)
	potential_target_list += left_leg
	var/obj/item/bodypart/right_leg = H.get_bodypart(BODY_ZONE_R_LEG)
	potential_target_list += right_leg
	var/obj/item/bodypart/right_arm = H.get_bodypart(BODY_ZONE_R_ARM)
	potential_target_list += right_arm
	var/obj/item/bodypart/left_arm = H.get_bodypart(BODY_ZONE_L_ARM)
	potential_target_list += left_arm
	for(var/obj/item/bodypart/thepart in potential_target_list)
		if(thepart)
			actual_target_list += thepart
	if(!LAZYLEN(actual_target_list))
		var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
		if(!istype(head)) // You, I'm afraid, are headless
			return
		actual_target_list += head
	var/obj/item/bodypart/removingpart = pick(actual_target_list)
	var/did_the_thing = (removingpart?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
	if(!did_the_thing)
		return
	return ..()
