/obj/item/ego_weapon/grinder
	name = "grinder MK4"
	desc = "The sharp sawtooth of the grinder makes a clean cut through its enemy. \
	Its operation is simple and straightforward, but that doesn't necessarily make it easy to wield."
	special = "This weapon pierces to hit everything on the target's tile."
	icon_state = "grinder"
	force = 30
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/grinder/attack(mob/living/target, mob/living/user)
	..()
	var/turf/T = get_turf(target)
	//damage calculations
	var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	force*=justicemod
	for(var/mob/living/L in T.contents)
		if(L == user || L == target)
			continue
		if(L.stat >= DEAD)
			continue
		L.apply_damage(force, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	force = 30

/obj/item/ego_weapon/harvest
	name = "harvest"
	desc = "The last legacy of the man who sought wisdom. The rake tilled the human brain instead of farmland."
	icon_state = "harvest"
	force = 30
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("attacks", "bashes", "tills")
	attack_verb_simple = list("attack", "bash", "till")
	hitsound = 'sound/weapons/ego/harvest.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 20		//It's 20 to keep clerks from using it
							)
	var/can_spin = TRUE

/obj/item/ego_weapon/harvest/attack(mob/living/target, mob/living/user)
	..()
	can_spin = FALSE
	addtimer(CALLBACK(src, .proc/spin_reset), 12)

/obj/item/ego_weapon/harvest/proc/spin_reset()
	can_spin = TRUE

/obj/item/ego_weapon/harvest/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!can_spin)
		to_chat(user,"<span class='warning'>You attacked too recently.</span>")
		return
	can_spin = FALSE
	if(do_after(user, 12))
		addtimer(CALLBACK(src, .proc/spin_reset), 12)
		playsound(src, 'sound/weapons/ego/harvest.ogg', 75, FALSE, 4)
		for(var/turf/T in orange(1, user))
			new /obj/effect/temp_visual/smash_effect(T)

		for(var/mob/living/L in livinginrange(1, user))
			var/aoe = 30
			var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust/100
			aoe*=justicemod
			if(L == user || ishuman(L))
				continue
			L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)



/obj/item/ego_weapon/fury
	name = "blind fury"
	desc = "A fancy black and white halberd with a sharp blade. Whose head will it cut off next?"
	special = "This weapon has a slower attack speed."
	icon_state = "fury"
	force = 45
	attack_speed = 1.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/ego/axe2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/paw
	name = "bear paw"
	desc = "The paws made form, and given life."
	special = "This weapon has a very fast attack speed."
	icon_state = "bear_paw"
	force = 12
	attack_speed = 0.3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("punches", "jabs", "slaps")
	attack_verb_simple = list("punches", "jabs", "slaps")
	hitsound = 'sound/weapons/punch1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

//ATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATAT
/obj/item/ego_weapon/paw/melee_attack_chain(mob/user, atom/target, params)
	..()
	hitsound = "sound/weapons/punch[pick(1,2,3,4)].ogg"


/obj/item/ego_weapon/wings
	name = "torn off wings"
	desc = "He stopped, gave a deep sigh, quickly tore from his shoulders the ribbon Marie had tied around him, \
		pressed it to his lips, put it on as a token, and, bravely brandishing his bare sword, \
		jumped as nimbly as a bird over the ledge of the cabinet to the floor."
	special = "This weapon has a very fast attack speed."
	icon_state = "wings"
	force = 12
	attack_speed = 0.3
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "claws")
	attack_verb_simple = list("slashes", "claws")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/daredevil
	name = "life for a daredevil"
	desc = "An ancient sword surrounded in death, yet it's having it in your grasp that makes you feel the most alive."
	special = "This weapon blocks ranged attacks while attacking and has a parry on command. \
				This weapon has a fast attack speed"
	icon_state = "daredevil"
	force = 12
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("decimates", "bisects")
	attack_verb_simple = list("decimate", "bisect")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)
	var/attacking = FALSE
	var/parry = 0
	var/parry_success
	var/naked_parry

/obj/item/ego_weapon/daredevil/melee_attack_chain(mob/user, atom/target, params)
	..()
	if (!istype(user,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/myman = user
	if (isnull(myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)))
		user.changeNext_move(CLICK_CD_MELEE * 0.33)
		attacking = TRUE
		addtimer(CALLBACK(src, .proc/drop_stance), 0.33 SECONDS)
		return
	user.changeNext_move(CLICK_CD_MELEE * 0.5)
	attacking = TRUE
	addtimer(CALLBACK(src, .proc/drop_stance), 0.5 SECONDS)

/obj/item/ego_weapon/daredevil/proc/drop_stance()
	attacking = FALSE

/obj/item/ego_weapon/daredevil/attack_self(mob/user)
	if (!ishuman(user))
		return
	if (parry == 0)
		var/mob/living/carbon/human/cooler_user = user
		parry = 1
		parry_success = FALSE
		cooler_user.physiology.red_mod *= 0.01 // Which this could be better, but alas, this must do.
		cooler_user.physiology.white_mod *= 0.01
		cooler_user.physiology.black_mod *= 0.01
		cooler_user.physiology.pale_mod *= 0.01
		if (isnull(cooler_user.get_item_by_slot(ITEM_SLOT_OCLOTHING)))
			naked_parry = TRUE
		else
			naked_parry = FALSE
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, .proc/Announce_Parry)
		addtimer(CALLBACK(src, .proc/disable_parry, cooler_user), 0.6 SECONDS) // Set to 3 for test,ing base is 0.6
		to_chat(user,"<span class='userdanger'>You attempt to parry the attack!</span>")

/obj/item/ego_weapon/daredevil/proc/disable_parry(mob/living/carbon/human/user)
	user.physiology.red_mod /= 0.01
	user.physiology.white_mod /= 0.01
	user.physiology.black_mod /= 0.01
	user.physiology.pale_mod /= 0.01
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	if (naked_parry)
		addtimer(CALLBACK(src, .proc/parry_cooldown, user), 2 SECONDS)
	else
		addtimer(CALLBACK(src, .proc/parry_cooldown, user), 3 SECONDS) // Set to 1 for testing, base 3
	if (!parry_success)
		Parry_Fail(user)

/obj/item/ego_weapon/daredevil/proc/parry_cooldown(mob/living/carbon/human/user)
	parry = 0
	to_chat(user,"<span class='nicegreen'>You rearm your blade</span>")

/obj/item/ego_weapon/daredevil/proc/Parry_Fail(mob/living/carbon/human/user)
	to_chat(user,"<span class='warning'>Your stance is widened.</span>")
	user.physiology.red_mod *= 1.2
	user.physiology.white_mod *= 1.2
	user.physiology.black_mod *= 1.2
	user.physiology.pale_mod *= 1.2
	if (naked_parry)
		addtimer(CALLBACK(src, .proc/Remove_Debuff, user), 2 SECONDS)
	else
		addtimer(CALLBACK(src, .proc/Remove_Debuff, user), 3 SECONDS)

/obj/item/ego_weapon/daredevil/proc/Remove_Debuff(mob/living/carbon/human/user)
	to_chat(user,"<span class='nicegreen'>You recollect your stance</span>")
	user.physiology.red_mod /= 1.2
	user.physiology.white_mod /= 1.2
	user.physiology.black_mod /= 1.2
	user.physiology.pale_mod /= 1.2

/obj/item/ego_weapon/daredevil/proc/Announce_Parry(mob/living/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	parry_success = TRUE
	playsound(get_turf(src), 'sound/weapons/ego/crumbling_parry.ogg', 75, 0, 7)
	for(var/mob/living/carbon/human/person in view(7, source))
		to_chat(person,"<span class='userdanger'>[source.real_name] parries the attack!</span>")

/obj/item/ego_weapon/daredevil/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK && attacking)
		final_block_chance = 100 //Anime Katana time
		to_chat(owner,"<span class='userdanger'>A God does not fear death!</span>")
		var/mob/living/carbon/human/other = list()
		other += oview(7, owner)
		other -= owner
		for(var/mob/living/carbon/human/person in other)
			to_chat(person,"<span class='nicegreen'>[owner.real_name] deflects the projectile!</span>")
		return ..()
	return ..()

/obj/item/ego_weapon/christmas
	name = "christmas"
	desc = "With my infinite hatred, I give you this gift."
	special = "This weapon has a slower attack speed. \
	This weapon has knockback."
	icon_state = "christmas"
	force = 54	//Still lower DPS
	attack_speed = 2
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/christmas/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/logging
	name = "logging"
	desc = "A versatile equipment made to cut down trees and people alike."
	special = "This weapon builds up attack speed as you attack before releasing it in a large burst."
	icon_state = "logging"
	force = 33
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = "chops"
	attack_verb_simple = "chop"
	hitsound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/ramping = 1.5
	var/smashing = FALSE
	var/flurry_width = 1
	var/flurry_length = 2

/obj/item/ego_weapon/logging/melee_attack_chain(mob/user, atom/target, params)
	..()
	if (isliving(target))
		user.changeNext_move(CLICK_CD_MELEE * ramping) // Starts slow, but....
		if (ramping <= 0.5)
			ramping = 1.5
			if(!smashing)
				to_chat(user, MESSAGE_TYPE_WARNING, "You smash the axe down repeatedly!")
				Smash(user, target)
		else
			ramping -= 0.1
	else
		user.changeNext_move(CLICK_CD_MELEE * 1.1)


/obj/item/ego_weapon/logging/proc/Smash(mob/user, atom/target)
	var/dir_to_target = get_cardinal_dir(get_turf(user), get_turf(target))
	var/turf/source_turf = get_turf(user)
	var/turf/area_of_effect = list()
	var/turf/middle_line
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step(source_turf, EAST), get_ranged_target_turf(source_turf, EAST, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step(source_turf, WEST), get_ranged_target_turf(source_turf, WEST, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step(source_turf, SOUTH), get_ranged_target_turf(source_turf, SOUTH, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step(source_turf, NORTH), get_ranged_target_turf(source_turf, NORTH, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
	smashing = TRUE
	playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 50, 0, 3)
	for (var/i = 0; i < 3; i++)
		var/list/been_hit = list()
		for(var/turf/T in area_of_effect)
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in T)
				if(L in been_hit)
					continue
				if (L == user)
					continue
				been_hit += L
				if (i > 2)
					L.apply_damage(40*(1+(get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				else
					L.apply_damage(10*(1+(get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if (i > 2)
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_strong.ogg', 75, 0, 5) // BAM
		else
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_attack.ogg', 50, 0, 2)
		sleep(0.25 SECONDS)
	smashing = FALSE
	return

/obj/item/ego_weapon/courage
	name = "courage"
	desc = "Can I follow you forever? So I can tear them apart..."
	special = "This weapon deals more damage the more allies you can see."
	icon_state = "courage"
	force = 10 //if 4 people are around, the weapon can deal up to 70 damage per strike, but alone it's a glorified baton.
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = "slash"
	attack_verb_simple = "slash"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/courage/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	var/friend_count = 0
	for(var/mob/living/carbon/human/friend in oview(user, 10))
		if(friend_count > 4) //the cap is 4 because thematically that's the rest of the oz crew (not including scaredy cat himself)
			break
		if(friend.ckey && friend.stat != DEAD && friend != user)
			force += 15
			friend_count++
	if(!friend_count && icon_state == "courage")
		to_chat(user, "<span class='warning'>Your weapon cowers and shatters in your hand!")
		icon_state = "courage_broken"
	else if(friend_count && icon_state == "courage_broken")
		to_chat(user, "<span class='nicegreen'>Your weapon puffs back up to impress your allies!")
		icon_state = "courage"
	user.update_icon_state()
	..()
	force = initial(force)

/obj/item/ego_weapon/pleasure
	name = "pleasure"
	desc = "If the goal of life is happiness, does it really matter how we get it?"
	special = "If you hit yourself with this weapon, it will deal additional damage proportional to your missing sanity for 20 seconds. this weapon deals armor piercing white damage to you."
	icon_state = "pleasure"
	force = 30
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = "slash"
	attack_verb_simple = "slash"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/happy = FALSE

/obj/item/ego_weapon/pleasure/attack(mob/living/M, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	var/missing_sanity = 0
	var/original_force = force
	if(M == user && !happy && istype(user))
		var/mob/living/carbon/human/H = user
		var/justice_mod = 1 + (get_attribute_level(H, JUSTICE_ATTRIBUTE)/100)
		H.adjustSanityLoss(-(force * justice_mod)) //we artificially inflict the justice + force damage so it bypass armor. the sanity damage should always feel like a gamble even with armor.
		missing_sanity = (1 - (H.sanityhealth / H.maxSanity)) * 40 //the weapon gets 40% of your missing % of sanity as force so 90% missing sanity means +36 force.
		force = 0
		happy = TRUE
		icon_state = "pleasure_active"
		to_chat(H, "<span class='notice'>The thorns start secreting some strange substance.</span>")
		playsound(H, 'sound/abnormalities/porccubus/porccu_giggle.ogg', 50, FALSE, 4)
		playsound(H, 'sound/weapons/bladeslice.ogg', 50, FALSE, 4)
		addtimer(CALLBACK(src, .proc/Withdrawal), 20 SECONDS)
	..()
	force = round(missing_sanity + original_force)

/obj/item/ego_weapon/pleasure/proc/Withdrawal(mob/living/M, mob/living/user)
	playsound(user, 'sound/abnormalities/porccubus/porccu_giggle.ogg', 50, FALSE, 4)
	to_chat(user, "<span class='notice'>The [src] is returning back to normal.</span>")
	icon_state = "pleasure"
	happy = FALSE
	force = 30
