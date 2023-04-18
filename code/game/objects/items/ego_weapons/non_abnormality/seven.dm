//Seven Association; the information gathering fixer office.
//They deal 25% less damage, on average.
//Hit something 7 times (3 with the cane) to store a target, and get it's information stored
//You can examine the weapon to see the HP of the stored abno on last hit
//If a target is stored, deal 50% more damage to it

//Normal is grade 5, Vet is Grade 4, director equipment is grade 2.

/obj/item/ego_weapon/city/seven
	name = "Seven Association blade"
	desc = "A sheathed blade used by seven association ."
	special = "Deal 50% more damage to the stored target. \
				Use weapon in hand to see stored target, and it's current health."
	icon_state = "sevenassociation"
	inhand_icon_state = "sevenassociation"
	force = 38
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	var/stored_target
	var/stored_target_hp
	var/hit_number
	var/hit_target = 7
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)


/obj/item/ego_weapon/city/seven/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Attack an enemy [hit_target] times to store it.</span>"

/obj/item/ego_weapon/city/seven/attack_self(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!stored_target)
		to_chat(user, "<span class='notice'>You have no information stored.</span>")
		return

	//not enough info for vitals
	var/mob/living/Y = stored_target
	if(hit_number <= hit_target-1)
		to_chat(user, "<span class='notice'>Current target is [Y.name]. Not enough information for vitals.</span>")
		return

	//Reset if they died, don't reset if you don't have info on them.
	if(Y.stat == DEAD)
		to_chat(user, "<span class='notice'>The target has expired. Clearing information.</span>")
		stored_target = null
		return

	//Get a very accurate % of their HP
	var/printhealth = stored_target_hp/Y.maxHealth*100
	to_chat(user, "<span class='notice'>Current target is [Y.name]. Their last health gathered is [printhealth]%</span>")


/obj/item/ego_weapon/city/seven/attack(mob/living/target, mob/living/user)
	if(hit_number >= hit_target && target == stored_target)
		force*=1.5

	..()

	force = initial(force)
	if(target != stored_target)
		stored_target = target
		to_chat(user, "<span class='notice'>You pursue a new target.</span>")
		hit_number = 0
		return
	else
		hit_number++
		stored_target_hp = target.health

	if(hit_number == hit_target-1)
		to_chat(user, "<span class='danger'>Target Analyzed. Combat effectiveness increased by 50%</span>")


/obj/item/ego_weapon/city/seven/vet
	name = "Seven Association veteran blade"
	desc = "A blade used by veteran seven association fixers."
	icon_state = "sevenassociation_vet"
	inhand_icon_state = "sevenassociation_vet"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	force = 45
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

//Director weapons. If you use both; you can actually get info on two targets at once, but it requires
/obj/item/ego_weapon/city/seven/director
	name = "Seven Association director's blade"
	desc = "A blade used by seven association branch directors."
	icon_state = "sevenassociation_director"
	inhand_icon_state = "sevenassociation_director"
	hitsound = 'sound/weapons/rapierhit.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	force = 63
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/city/seven/cane
	name = "Seven Association director's cane"
	desc = "A cane used by seven association branch directors, gathers information significantly faster."
	special = "Attack an enemy 3 times to store it. \
				Deal 50% more damage to the stored target. \
				Use weapon in hand to see stored target, and it's current health."
	icon_state = "sevenassociation_cane"
	inhand_icon_state = "sevenassociation_cane"
	force = 56	//Faster info gain,
	hit_target = 3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 100
							)

