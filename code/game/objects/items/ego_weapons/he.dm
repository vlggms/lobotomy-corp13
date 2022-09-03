/obj/item/ego_weapon/grinder
	name = "grinder MK4"
	desc = "The sharp sawtooth of the grinder makes a clean cut through its enemy. \
	Its operation is simple and straightforward, but that doesn't necessarily make it easy to wield."
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

/obj/item/ego_weapon/fury
	name = "blind fury"
	desc = "A fancy black and white halberd with a sharp blade. Whose head will it cut off next?"
	special = "This weapon has a slower attack speed."
	icon_state = "fury"
	force = 45
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/ego/axe2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/fury/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.5) // Slow

/obj/item/ego_weapon/paw
	name = "bear paw"
	desc = "The paws made form, and given life."
	special = "This weapon has a very fast attack speed."
	icon_state = "bear_paw"
	force = 12
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
	user.changeNext_move(CLICK_CD_MELEE * 0.30)
	hitsound = "sound/weapons/punch[pick(1,2,3,4)].ogg"


/obj/item/ego_weapon/wings
	name = "torn off wings"
	desc = "He stopped, gave a deep sigh, quickly tore from his shoulders the ribbon Marie had tied around him, \
		pressed it to his lips, put it on as a token, and, bravely brandishing his bare sword, \
		jumped as nimbly as a bird over the ledge of the cabinet to the floor."
	special = "This weapon has a very fast attack speed."
	icon_state = "wings"
	force = 12
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "claws")
	attack_verb_simple = list("slashes", "claws")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

//ATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATAT
/obj/item/ego_weapon/wings/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 0.30)

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
	force = 50
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/christmas/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 2) // Slow

/obj/item/ego_weapon/christmas/attack(mob/living/target, mob/living/user)
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
	var/dir_to_target = get_dir(get_turf(user), get_turf(target))
	var/turf/source_turf = get_turf(user)
	var/turf/area_of_effect = list()
	var/turf/upper_bound
	var/turf/lower_bound
	for(var/i = 0; i < 2; i++)
		switch(dir_to_target) // This doesn't need any "did this walk into a wall" checking because it doesn't go far enough to hit the other-side
			if(EAST)
				source_turf = get_step(source_turf, EAST)
				upper_bound = get_step(source_turf, NORTH)
				lower_bound = get_step(source_turf, SOUTH)
				for(var/turf/TF in getline(upper_bound, lower_bound))
					if(TF.density || (TF in area_of_effect))
						continue
					area_of_effect += TF
			if(WEST)
				source_turf = get_step(source_turf, WEST)
				upper_bound = get_step(source_turf, NORTH)
				lower_bound = get_step(source_turf, SOUTH)
				for(var/turf/TF in getline(upper_bound, lower_bound))
					if(TF.density || (TF in area_of_effect))
						continue
					area_of_effect += TF
			if(SOUTH)
				source_turf = get_step(source_turf, SOUTH)
				upper_bound = get_step(source_turf, WEST)
				lower_bound = get_step(source_turf, EAST)
				for(var/turf/TF in getline(upper_bound, lower_bound))
					if(TF.density || (TF in area_of_effect))
						continue
					area_of_effect += TF
			if(NORTH)
				source_turf = get_step(source_turf, NORTH)
				upper_bound = get_step(source_turf, WEST)
				lower_bound = get_step(source_turf, EAST)
				for(var/turf/TF in getline(upper_bound, lower_bound))
					if(TF.density || (TF in area_of_effect))
						continue
					area_of_effect += TF
			else
				return
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
