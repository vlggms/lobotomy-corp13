//Dong-hwan's weapon. He's got a grade 2 weapon, he's a Grade 1 fixer.
//His weapon has 3 different attacks that you can perform, Shoving stab, Critical Moment, and Toughness.
//Which one is available depends on how close you are to an enemy.
/obj/item/ego_weapon/city/donghwan
	name = "Carver of Scars"
	desc = "A polished, well-kept longsword with a cruel but effective edge, belonging to Dong-hwan. The serrations are to catch the wound and push out."
	icon_state = "donghwan"
	force = 60
	attack_speed = 0.8
	damtype = RED_DAMAGE

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)
	var/active
	var/attackchoice

/obj/item/ego_weapon/city/donghwan/examine(mob/user)
	. = ..()
	. += "This weapon has 3 separate functions."
	. += "After being ready, attack a target to activate a shove."
	. += "After being ready, use in hand to activate a critical strike on your next attack."
	. += "Attack yourself at any time to lower your sanity if it is high, and heal it slightly if it is low."
	. += "Critical Strike scales inverse to your current % of sanity."

/obj/item/ego_weapon/city/donghwan/attack_self(mob/living/carbon/human/user)
	active = TRUE
	if(attackchoice == 1)
		to_chat(user, span_notice("Now's my chance."))
		attackchoice = 2

/obj/item/ego_weapon/city/donghwan/attack(mob/living/target, mob/living/carbon/human/user)
	force = initial(force)
	if(!CanUseEgo(user))
		return

	if(active)
		if(user == target)
			force = force*=0.3
			attackchoice = 3

	switch(attackchoice)
		if(1)
			Shove(target, user)
		if(2)
			CriticalMoment(target, user)
		if(3)
			Toughness(target, user)

	..()
	switch(attackchoice)
		if(5)
			attackchoice = 4
		if(4)
			attackchoice = 0
		else
			attackchoice = 1
			to_chat(user, span_notice("Ready to shove."))

/obj/item/ego_weapon/city/donghwan/proc/Shove(mob/living/target, mob/living/carbon/human/user)
	to_chat(user, span_notice("Fuck off."))

	playsound(src, 'sound/weapons/fixer/generic/nail2.ogg', 100, FALSE, 4)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(2, 5), whack_speed, user)
	attackchoice = 5

/obj/item/ego_weapon/city/donghwan/proc/CriticalMoment(mob/living/target, mob/living/carbon/human/user)
	to_chat(user, span_notice("Gotcha."))
	playsound(src, 'sound/weapons/fixer/generic/nail1.ogg', 100, FALSE, 4)
	//Deals half of % of your sanity, inverted.
	force += force*((user.sanityhealth/user.maxSanity)-1)*-0.5
	attackchoice = 5

/obj/item/ego_weapon/city/donghwan/proc/Toughness(mob/living/target, mob/living/carbon/human/user)
	if(user.sanityhealth>= user.maxSanity*0.3)
		user.adjustSanityLoss(user.sanityhealth*0.71)
		to_chat(user, span_notice("Feels good."))
	else
		to_chat(user, span_notice("Shouldn't push it."))
		user.adjustSanityLoss(-user.sanityhealth*0.2)
	attackchoice = 0

