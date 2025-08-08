//Section 4/5/6, 6-4
/obj/item/ego_weapon/city/dieci
	name = "dieci combat gloves"
	icon_state = "dieci_glove"
	inhand_icon_state = "yun_fist"
	desc = "A gauntlet used by Dieci Association. Requires martial arts training to make use of."
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


/obj/item/ego_weapon/city/dieci/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This weapon has light and heavy attacks. Use in hand to activate a heavy attack. Combos are as follows:</span>"
	. += "<span class='notice'>LLLLL - 5 hit finisher.</span>"
	. += "<span class='notice'>H 	 - Quick 5 hit Beatdown.</span>"
	. += "<span class='notice'>LH 	 - 5 hit and knockdown.</span>"
	. += "<span class='notice'>LLH 	 - Agressive grab and 5 hit.</span>"
	. += "<span class='notice'>LLLH  - Stun both you and the target, and deliver 20 rapid punches.</span>"
	. += "<span class='notice'>LLLLH - Issue a 3 stage combo.</span>"

/obj/item/ego_weapon/city/dieci/attack_self(mob/living/carbon/user)
	if(activated)
		activated = FALSE
		to_chat(user, "<span class='danger'>You revoke your preparation of a finisher.</span>")
	else
		activated = TRUE
		to_chat(user, "<span class='danger'>You prep a finisher!</span>")


/obj/item/ego_weapon/city/dieci/attack(mob/living/target, mob/living/user)
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
			if(activated) //H - 3 hit with immobilize
				force*=0.4
				activated = FALSE
				user.Immobilize(15)
				target.Immobilize(8)
				twohit(target, user)
				hitsound = 'sound/weapons/fixer/generic/finisher2.ogg'

		if(2)
			if(activated) //LH - beatdown with knockdown
				force*=0.4
				activated = FALSE
				user.Immobilize(7)
				smallbeatdown(target, user)
				target.Knockdown(10)

		if(3)
			if(activated) //LLH - beatdown with aggro grab
				target.grabbedby(user, 1)
				target.drop_all_held_items()
				user.setGrabState(GRAB_AGGRESSIVE) //Instant agressive grab if on grab intent
				user.Immobilize(7)
				noknockback(target, user)

		if(4)
			if(activated) //LLLH - major beatdown
				target.Immobilize(15)
				user.Immobilize(15)
				force*=0.1
				beatdown(target, user)

		if(5)
			if(!activated) // LLLLL		Standard kickdown
				target.Immobilize(10)
				user.Immobilize(10)
				force*=0.3
				smallbeatdown(target, user)
				hitsound = 'sound/weapons/fixer/generic/finisher2.ogg'

			else		// LLLLH		The gigafuck attack
				target.Immobilize(25)
				user.Immobilize(25)
				force*=0.1
				grabattack(target,user)
				hitsound = 'sound/weapons/fixer/generic/finisher2.ogg'

	//Special attacks are slower.
	if(attack_speed == initial(attack_speed) && activated)
		attack_speed = 2
	. = ..()

	//Reset Everything
	if(activated)
		chain=0
		to_chat(user, "<span class='danger'>Your chain is reset.</span>")
		activated = FALSE
	force = initial(force)
	hitsound = initial(hitsound)


/obj/item/ego_weapon/city/dieci/proc/beatdown(mob/living/target, mob/living/user)
	for(var/i = 1 to 20)
		chain = 0
		attack(target, user)
		sleep(0.5)


/obj/item/ego_weapon/city/dieci/proc/grabattack(mob/living/target, mob/living/user)
	//Punch 'em
	for(var/i = 1 to 5)
		chain = 0
		attack(target, user)
		sleep(1)
	//Grab 'em
	target.grabbedby(user, 1)
	sleep(3)
	for(var/i = 1 to 5)
		chain = 0
		attack(target, user)
		sleep(1)
	//Knock 'em down
	target.Knockdown(10)
	sleep(3)
	for(var/i = 1 to 5)
		chain = 0
		attack(target, user)
		sleep(1)
	//Knock 'em back
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(6, 9), whack_speed, user)


/obj/item/ego_weapon/city/dieci/proc/smallbeatdown(mob/living/target, mob/living/user)
	for(var/i = 1 to 5)
		chain = 0
		attack(target, user)
		sleep(1)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(3, 5), whack_speed, user)

/obj/item/ego_weapon/city/dieci/proc/noknockback(mob/living/target, mob/living/user)
	for(var/i = 1 to 5)
		chain = 0
		attack(target, user)
		sleep(1)

/obj/item/ego_weapon/city/dieci/proc/twohit(mob/living/target, mob/living/user)
	for(var/i = 1 to 2)
		chain = 0
		attack(target, user)
		sleep(2)
