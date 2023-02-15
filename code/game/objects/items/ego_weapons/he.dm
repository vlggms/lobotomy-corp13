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

/obj/item/ego_weapon/grinder/get_clamped_volume()
	return 40

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
	var/spinning = FALSE

/obj/item/ego_weapon/harvest/attack(mob/living/target, mob/living/user)
	if(spinning)
		return FALSE
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
	spinning = TRUE
	if(do_after(user, 12))
		can_spin = TRUE
		addtimer(CALLBACK(src, .proc/spin_reset), 12)
		playsound(src, 'sound/weapons/ego/harvest.ogg', 75, FALSE, 4)
		for(var/turf/T in orange(1, user))
			new /obj/effect/temp_visual/smash_effect(T)

		for(var/mob/living/L in range(1, user))
			var/aoe = 30
			var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust/100
			aoe*=justicemod
			if(L == user || ishuman(L))
				continue
			L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	spinning = FALSE


/obj/item/ego_weapon/fury
	name = "blind fury"
	desc = "A fancy black and white halberd with a sharp blade. Whose head will it cut off next?"
	special = "This weapon has a slower attack speed.	\
			On kill, deal massive damage on next attack."
	icon_state = "fury"
	force = 41
	attack_speed = 1.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/ego/axe2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)
	var/rage = FALSE

/obj/item/ego_weapon/fury/attack(mob/living/target, mob/living/carbon/human/user)
	var/living = FALSE
	if(!CanUseEgo(user))
		return
	if(target.stat != DEAD)
		living = TRUE
	..()
	if(force != initial(force))
		force = initial(force)

	if(target.stat == DEAD && living)
		if(!rage)
			to_chat(user, "<span class='userdanger'>LONG LIVE THE QUEEN!</span>")
			rage = FALSE
		force *= 3
		rage = TRUE
		living = FALSE

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

/obj/item/ego_weapon/shield/daredevil
	name = "life for a daredevil"
	desc = "An ancient sword surrounded in death, yet it's having it in your grasp that makes you feel the most alive."
	special = "This weapon has a fast attack speed"
	icon_state = "daredevil"
	force = 12
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("decimates", "bisects")
	attack_verb_simple = list("decimate", "bisect")
	hitsound = 'sound/weapons/bladeslice.ogg'
	reductions = list(90, 90, 90, 30, 1)
	recovery_time = 0.5 SECONDS
	block_time = 0.5 SECONDS
	block_recovery = 3 SECONDS
	block_sound = 'sound/weapons/ego/crumbling_parry.ogg'
	projectile_block ="A God does not fear death!"
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	reposition_message = "You rearm your blade."
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)
	var/naked_parry

/obj/item/ego_weapon/shield/daredevil/melee_attack_chain(mob/user, atom/target, params)
	if (!istype(user,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/myman = user
	if (isnull(myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)))
		attack_speed = 0.33
		recovery_time = 0.33 SECONDS
	else
		attack_speed = 0.5
		recovery_time = 0.5 SECONDS
	..()

/obj/item/ego_weapon/shield/daredevil/attack_self(mob/user)
	if (block == 0)
		var/mob/living/carbon/human/cooler_user = user
		naked_parry = isnull(cooler_user.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		if(naked_parry)
			reductions = list(95, 95, 95, 100, 1)
		else
			reductions = list(90, 90, 90, 30, 1)
	..()

/obj/item/ego_weapon/shield/daredevil/DisableBlock(mob/living/carbon/human/user)
	if (naked_parry)
		block_recovery = 2 SECONDS
	else
		block_recovery = 3 SECONDS
	..()

/obj/item/ego_weapon/shield/daredevil/BlockCooldown(mob/living/carbon/human/user)
	force = 12
	..()

/obj/item/ego_weapon/shield/daredevil/BlockFail(mob/living/carbon/human/user)
	if (naked_parry)
		stance_recovery = 2 SECONDS
	else
		stance_recovery = 3 SECONDS
	..()

/obj/item/ego_weapon/shield/daredevil/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	if(naked_parry)
		hit_message = "is untouchable!"
		force = 18 // bonus damage for like, 2 seconds.
	else if(damagetype == PALE_DAMAGE)
		to_chat(source,"<span class='warning'>To attempt parry the aspect of death is to hide from inevitability. To hide is to fear. Show me that you do not fear death.</span>")
	..()

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

/obj/item/ego_weapon/shield/bravery
	name = "bravery"
	desc = "Together we are unstoppable."
	special = "This weapon has a slow attack speed and deals atrocious damage.	\
			Block for longer when surrounded by allies."
	icon_state = "bravery"
	force = 20
	attack_speed = 3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/bite.ogg'
	reductions = list(60, 30, 30, 20, 1)
	recovery_time = 3 SECONDS
	block_time = 1 SECONDS //1 second of block time when alone like a buckler, up to 3 seconds with allies
	block_recovery = 5 SECONDS //always 6 seconds total before blocking again
	block_sound = 'sound/abnormalities/scaredycat/cateleport.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/shield/bravery/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	var/friend_count = 0
	for(var/mob/living/carbon/human/friend in oview(user, 10))
		if(friend_count > 4)
			break
		if(friend.ckey && friend.stat != DEAD && friend != user)
			block_time += 0.5 SECONDS
			block_recovery -= 0.5 SECONDS
			friend_count++
	if(!friend_count && icon_state == "bravery")
		to_chat(user, "<span class='warning'>Your weapon cowers in your hand!")
		icon_state = "bravery_broken"
		playsound(src, 'sound/abnormalities/scaredycat/catchange.ogg', 25, FALSE, 4)
	else if(friend_count && icon_state == "bravery_broken")
		to_chat(user, "<span class='nicegreen'>Your weapon puffs back up to impress your allies!")
		icon_state = "bravery"
		playsound(src, 'sound/abnormalities/scaredycat/catgrunt.ogg', 50, FALSE, 4)
	user.update_icon_state()
	..()
	block_time = initial(block_time)
	block_recovery = initial(block_recovery)

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
		H.adjustSanityLoss(force * justice_mod) //we artificially inflict the justice + force damage so it bypass armor. the sanity damage should always feel like a gamble even with armor.
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

/obj/item/ego_weapon/mini/metal
	name = "bare metal"
	desc = "Looks to be a fan blade with a handle welded to it."
	special = "This weapon attacks slower than usual."
	icon_state = "metal"
	force = 40
	attack_speed = 1.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "cleaves", "chops")
	attack_verb_simple = list("slice", "cleave", "chop")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/mini/alleyway
	name = "alleyway"
	desc = "It's a small knife forged of black metal."
	special = "This weapon attacks extremely fast."
	icon_state = "alleyway"
	force = 9
	attack_speed = 0.3
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slices", "cleaves", "chops")
	attack_verb_simple = list("slice", "cleave", "chop")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/shield/giant
	name = "giant"
	desc = "I'll grind your bones to make my bread!"
	special = "This weapon has a slow attack speed and deals atrocious damage."
	icon_state = "giant"
	force = 20
	attack_speed = 3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(40, 20, 40, 20, 1)
	recovery_time = 3 SECONDS
	block_time = 3 SECONDS
	block_recovery = 3 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

//gains 0.25 force for every step you take, up to 100 damage. However it deals 0 damage by default, making it more useful as a sidearm rather than a main weapon.
/obj/item/ego_weapon/homing_instinct
	name = "homing instinct"
	desc = "It's about the journey AND the destination!"
	special = "This weapon's damage scale with the number of steps you've taken before striking."
	icon_state = "homing_instinct"
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	force = 0 //Literally does no damage by default
	attack_speed = 3
	attack_verb_continuous = list("pierces", "stabs")
	attack_verb_simple = list("pierce", "stab")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)
	var/mob/current_holder

/obj/item/ego_weapon/homing_instinct/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/UserMoved)
	current_holder = user

/obj/item/ego_weapon/homing_instinct/Destroy(mob/user)
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	current_holder = null
	return ..()

/obj/item/ego_weapon/homing_instinct/dropped(mob/user)
	. = ..()
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	current_holder = null

/obj/item/ego_weapon/homing_instinct/attack(mob/living/M, mob/living/carbon/human/user)
	..()
	force = round(force/2) //It doesn't lose all its force in one go after each hit.

/obj/item/ego_weapon/homing_instinct/proc/UserMoved()
	SIGNAL_HANDLER
	if(force < 100)
		force += 0.25 //It charges pretty slowly, but people walk pretty fast thanks to justice.
