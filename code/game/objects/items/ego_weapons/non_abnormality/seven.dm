//Seven Association; the information gathering fixer office.
//They deal 25% less damage, on average.
//Hit something 7 times (3 with the cane) to store a target, and get its information stored
//You can examine the weapon to see the HP of the stored abno on last hit
//If a target is stored, deal 50% more damage to it

//Normal is grade 5, Vet is Grade 4, director equipment is grade 2.

/obj/item/ego_weapon/city/seven
	name = "Seven Association blade"
	desc = "A sheathed blade used by seven association ."
	special = "Deal 50% more damage to the stored target. \
				Use weapon in hand to see stored target, and its current health."
	icon_state = "sevenassociation"
	inhand_icon_state = "sevenassociation"
	force = 38
	damtype = BLACK_DAMAGE

	var/stored_target
	var/stored_target_hp
	var/hit_number
	var/hit_target = 7
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)


/obj/item/ego_weapon/city/seven/examine(mob/user)
	. = ..()
	. += span_notice("Attack an enemy [hit_target] times to store it.")

/obj/item/ego_weapon/city/seven/attack_self(mob/living/carbon/human/user)
	..()
	if(!stored_target)
		to_chat(user, span_notice("You have no information stored."))
		return

	//not enough info for vitals
	var/mob/living/Y = stored_target
	if(hit_number <= hit_target-1)
		to_chat(user, span_notice("Current target is [Y.name]. Not enough information for vitals."))
		return

	//Reset if they died, don't reset if you don't have info on them.
	if(Y.stat == DEAD)
		to_chat(user, span_notice("The target has expired. Clearing information."))
		stored_target = null
		return

	//Get a very accurate % of their HP
	var/printhealth = stored_target_hp/Y.maxHealth*100
	to_chat(user, span_notice("Current target is [Y.name]. Their last health gathered is [printhealth]%"))


/obj/item/ego_weapon/city/seven/attack(mob/living/target, mob/living/user)
	if(hit_number >= hit_target && target == stored_target)
		force*=1.5

	..()

	force = initial(force)
	if(target != stored_target)
		stored_target = target
		to_chat(user, span_notice("You pursue a new target."))
		hit_number = 0
		return
	else
		hit_number++
		stored_target_hp = target.health

	if(hit_number == hit_target-1)
		to_chat(user, span_danger("Target Analyzed. Combat effectiveness increased by 50%"))


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
				Use weapon in hand to see stored target, and its current health."
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

//Seven Fencing - Lack the Health gaining ability, and gain an ability similar to Capo, where they do bonus damage when attacking the same person.
/obj/item/ego_weapon/city/seven_fencing
	name = "seven association fencing foil"
	desc = "A fencing foil used by seven association to destroy singular targets."
	special = "This weapon does 35% more damage when attacking the same target more than once."
	icon_state = "sevenfencing"
	hitsound = 'sound/weapons/rapierhit.ogg'
	force = 38
	damtype = BLACK_DAMAGE

	var/fencing_target
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)


/obj/item/ego_weapon/city/seven_fencing/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(!fencing_target || fencing_target != M)
		fencing_target = M
		to_chat(user, span_notice("Target acquired."))
	else
		force *= 1.35
	..()
	force = initial(force)

/obj/item/ego_weapon/city/seven_fencing/vet
	name = "seven association veteran fencing foil"
	desc = "A fencing foil used by seven association veterans to destroy singular targets."
	icon_state = "sevenfencing_vet"
	force = 45
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/city/seven_fencing/dagger
	name = "seven association fencing dagger"
	desc = "A small, mailbreaking dagger used as a sidearm by specific seven association veterans."
	special = "This weapon does 35% more damage when attacking the same target more than once. This weapon fits in an EGO belt."
	icon_state = "sevenfencing_dagger"
	force = 32
	attack_speed = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 100
							)

