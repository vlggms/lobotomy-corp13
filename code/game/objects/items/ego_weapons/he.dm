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
	var/spin_cooldown
	var/spin_cooldown_time = 5 SECONDS
	var/spin_delay = 1 SECONDS
	var/spin_checks_faction = TRUE
	/// Damage before justice buff
	var/spin_damage = 30

/obj/item/ego_weapon/harvest/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(spin_cooldown > world.time)
		to_chat(user,"<span class='warning'>You performed special attack too recently!</span>")
		return

	spin_cooldown = world.time + spin_delay // In case attack does not go through
	if(!do_after(user, spin_delay))
		return
	spin_cooldown = world.time + spin_cooldown_time
	playsound(src, 'sound/weapons/ego/harvest.ogg', 75, FALSE)
	for(var/turf/T in range(1, user))
		new /obj/effect/temp_visual/smash_effect(T)
	for(var/mob/living/L in range(1, user))
		if(L == user)
			continue
		if(spin_checks_faction && user.faction_check_mob(L))
			continue
		var/userjust = get_attribute_level(user, JUSTICE_ATTRIBUTE)
		var/spin_damage_final = spin_damage * (1 + userjust/100)
		L.apply_damage(spin_damage_final, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))

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
	var/list/reductions = list(90, 90, 90, 30, 1)

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
		return FALSE

	if (parry == 0)
		var/mob/living/carbon/human/cooler_user = user
		if(!CanUseEgo(cooler_user))
			return FALSE
		if(cooler_user.physiology.armor.bomb) // We have NOTHING that should be modifying this, so I'm using it as an existant parry checker.
			to_chat(cooler_user,"<span class='warning'>You're still off-balance!</span>")
			return FALSE
		for(var/obj/machinery/computer/abnormality/AC in range(1, cooler_user))
			if(AC.datum_reference.working) // No parrying during work.
				to_chat(cooler_user,"<span class='notice'>You attempt to parry the monotony of this job!</span>")
				return FALSE
		parry = 1
		parry_success = FALSE
		naked_parry = isnull(cooler_user.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		if(naked_parry)
			reductions = list(95, 95, 95, 100, 1)
		else
			reductions = list(90, 90, 90, 30, 1)
		cooler_user.physiology.armor = cooler_user.physiology.armor.modifyRating(red = reductions[1], white = reductions[2], black = reductions[3], pale = reductions[4], bomb = reductions[5])
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, .proc/Announce_Parry)
		addtimer(CALLBACK(src, .proc/disable_parry, cooler_user), 0.5 SECONDS) // Set to 3 for testing base is 0.5, was 0.6
		to_chat(user,"<span class='userdanger'>You attempt to parry the attack!</span>")
		return TRUE

/obj/item/ego_weapon/daredevil/proc/disable_parry(mob/living/carbon/human/user)
	user.physiology.armor = user.physiology.armor.modifyRating(red = -reductions[1], white = -reductions[2], black = -reductions[3], pale = -reductions[4], bomb = -reductions[5])
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	if (naked_parry)
		addtimer(CALLBACK(src, .proc/parry_cooldown, user), 2 SECONDS)
	else
		addtimer(CALLBACK(src, .proc/parry_cooldown, user), 3 SECONDS) // Set to 1 for testing, base 3
	if (!parry_success)
		Parry_Fail(user)

/obj/item/ego_weapon/daredevil/proc/parry_cooldown(mob/living/carbon/human/user)
	parry = 0
	force = 12
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

/obj/item/ego_weapon/daredevil/proc/Announce_Parry(mob/living/carbon/human/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	parry_success = TRUE
	var/src_message = "<span class='userdanger'>[source.real_name] parries the attack!</span>"
	var/other_message = src_message
	if(naked_parry)
		src_message = "<span class='userdanger'>[source.real_name] is untouchable!</span>"
		other_message = src_message
		force = 18 // bonus damage for like, 2 seconds.
	else if(damagetype == PALE_DAMAGE)
		src_message = "<span class='warning'>To attempt parry the aspect of death is to hide from inevitability. To hide is to fear. Show me that you do not fear death.</span>"

	playsound(get_turf(src), 'sound/weapons/ego/crumbling_parry.ogg', 75, 0, 7)
	for(var/mob/living/carbon/human/person in view(7, source))
		if(person == source)
			to_chat(person, src_message)
		else
			to_chat(person, other_message)

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
