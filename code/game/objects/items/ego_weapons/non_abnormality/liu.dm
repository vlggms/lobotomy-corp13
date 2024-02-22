//This is a massive file and all the liu weapons kill humans while insane
/obj/item/ego_weapon/city/liu
	name = "Liu template"
	damtype = WHITE_DAMAGE


/obj/item/ego_weapon/city/liu/examine(mob/user)
	. = ..()
	. += span_notice("This weapon kills insane people.")

/obj/item/ego_weapon/city/liu/attack(mob/living/target, mob/living/user)
	//Happens before the attack so you need to do another attack.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.sanity_lost)
			H.death()
	..()

//Section 1&2, 6-5-4-2 as the grades
/obj/item/ego_weapon/city/liu/fire
	name = "liu blade"
	desc = "A blade used by junior fixers of Liu Section 1 and Section 2."
	icon_state = "liublade"
	force = 28
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/city/liu/fire/examine(mob/user)
	. = ..()
	. +="This weapon gains +10% damage for each person in sight."

/obj/item/ego_weapon/city/liu/fire/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	for(var/mob/living/carbon/human/friend in oview(user, 10))
		//Minor bonus for having multiple people around you
		if(friend.ckey && friend.stat != DEAD && friend != user)
			force += force*0.1	//+10% for each person around you
	..()
	force = initial(force)


/obj/item/ego_weapon/city/liu/fire/fist
	name = "liu flaming glove"
	desc = "A fiery fist used by some veteran fixers of Liu Section 1 and Section 2."
	icon_state = "liuglove"
	force = 35
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/liu/fire/spear
	name = "liu spear"
	desc = "A spear used by veteran fixers of Liu Section 1 and Section 2, and is used by the director of Liu Section 2."
	icon_state = "liuspear"
	force = 45
	reach = 2
	attack_speed = 1.2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)


/obj/item/ego_weapon/city/liu/fire/sword
	name = "liu director sword"
	desc = "The personal sword found in the hands of the director of Liu Section 1."
	icon_state = "liusword"
	force = 67
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)



//Section 4/5/6, 6-4
/obj/item/ego_weapon/city/liu/fist
	name = "liu combat gloves"
	icon_state = "liufist"
	desc = "A gauntlet used by Liu Sections 4,5 and 6. Requires martial arts training to make use of."
	force = 20
	attack_speed = 0.7
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	var/chain = 0
	var/activated
	hitsound = 'sound/weapons/fixer/generic/fist1.ogg'

	var/combo_time
	var/combo_wait = 10


/obj/item/ego_weapon/city/liu/fist/examine(mob/user)
	. = ..()
	. += span_notice("This weapon has light and heavy attacks. Use in hand to activate a heavy attack. Combos are as follows:")
	. += span_notice("LLLLL - 5 Hit fast combo, ending in a knockback attack.")
	. += span_notice("H 	 - Windup fist attack for 1.5x damage and deals massive stamina damage to humans.")
	. += span_notice("LH 	 - AOE Fire fist attack. This does not kill insane people.")
	. += span_notice("LLH 	 - High Damage Combo, last attack has a windup and deals 2x damage.")
	. += span_notice("LLLH  - Deals good damage. Last hit backsteps you 2 tiles.")
	. += span_notice("LLLLH - High Damage combo, last hit ends in a 2x damage boost with no windup.")

/obj/item/ego_weapon/city/liu/fist/attack_self(mob/living/carbon/user)
	if(activated)
		activated = FALSE
		to_chat(user, span_danger("You revoke your preparation of a heavy attack."))
	else
		activated = TRUE
		to_chat(user, span_danger("You prep a heavy attack!"))


/obj/item/ego_weapon/city/liu/fist/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return

	if(world.time > combo_time)
		chain = 0
	combo_time = world.time + combo_wait

	var/during_windup //can't attack during windup
	if(during_windup)
		return

	//Setting chain and attack speed to 0
	chain+=1
	attack_speed = initial(attack_speed)

	//Teh Chain of attacks. See the examine for what each chain does.

	switch(chain)
		if(1)
			if(activated) //H - Solar Plexus attack
				to_chat(user, span_danger("You prepare to strike the solar plexus."))
				during_windup = TRUE
				if(do_after(user, 5, target))
					during_windup = FALSE
					force *= 1.5
					hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
					if(ishuman(target))
						target.Paralyze(20)
				else
					during_windup = FALSE
					return

		if(2)
			if(activated) //LH - Fire AOE
				to_chat(user, span_danger("You release a wave of fire."))
				hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
				aoe(target, user)

		if(3)
			if(activated) //LLH - Higher damage windup attack
				to_chat(user, span_danger("You prepare a strong punch."))
				during_windup = TRUE
				if(do_after(user, 5, target))
					during_windup = FALSE
					force *= 2
					hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
				else
					during_windup = FALSE
					return

		if(4)
			if(activated) //LLLH - Fast hit and jump back
				to_chat(user, span_danger("You hit them and hop back."))
				force *= 1.5
				hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
				hopback(user)

		if(5)
			if(!activated)
				knockback(target, user)
				hitsound = 'sound/weapons/fixer/generic/finisher2.ogg'
			else
				force*=2
				to_chat(user, span_danger("You hit them with all you got!."))
				hitsound = 'sound/weapons/fixer/generic/finisher2.ogg'
			chain=0

	//Special attacks are slower.
	if(attack_speed == initial(attack_speed) && activated)
		attack_speed = 2
	. = ..()

	//Reset Everything
	if(activated)
		chain=0
		to_chat(user, span_danger("Your chain is reset."))
		activated = FALSE
	force = initial(force)
	hitsound = initial(hitsound)


/obj/item/ego_weapon/city/liu/fist/proc/knockback(mob/living/target, mob/living/user)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 3), whack_speed, user)

/obj/item/ego_weapon/city/liu/fist/proc/aoe(mob/living/target, mob/living/user)
	for(var/turf/T in view(force/5, target))
		if(prob(30))
			new /obj/effect/temp_visual/fire/fast(T)
		for(var/mob/living/L in T)
			if(L == user)
				continue
			L.apply_damage(force*0.5, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)

/obj/item/ego_weapon/city/liu/fist/proc/hopback(mob/living/carbon/user)
	var/dodgelanding
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y - 2, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y + 2, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x - 2, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x + 2, user.y, user.z)
	user.throw_at(dodgelanding, 3, 2, spin = FALSE)


/obj/item/ego_weapon/city/liu/fist/vet
	name = "liu veteran combat gloves"
	icon_state = "liufist_vet"
	force = 32
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)
