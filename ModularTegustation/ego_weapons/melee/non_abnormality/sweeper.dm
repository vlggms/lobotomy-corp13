//Regular is Grade 7, rest are grade 5
/obj/item/ego_weapon/city/sweeper
	name = "sweeper hook"
	desc = "A hook cut off a sweeper. When night comes in the backstreets..."
	special = "Attack dead bodies to heal."
	icon_state = "sweeper_hook"
	force = 13
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("stabs")
	attack_verb_simple = list("stab")
	hitsound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 40,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 40,
		JUSTICE_ATTRIBUTE = 40,
	)

/obj/item/ego_weapon/city/sweeper/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	..()
	if((target.stat == DEAD) && !(target.status_flags & GODMODE))
		target.gib()
		user.adjustBruteLoss(-user.maxHealth * 0.1)	//Heal 10% HP

/obj/item/ego_weapon/city/sweeper/sickle
	name = "sweeper_sickle"
	desc = "A sickle cut off a sweeper captain. When night comes in the backstreets..."
	icon_state = "sweeper_sickle"
	force = 18
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/sweeper/hooksword
	name = "sweeper hooksword"
	desc = "A hooksword cut off a sweeper captain. When night comes in the backstreets..."
	icon_state = "sweeper_hooksword"
	force = 27
	attack_speed = 1.6
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/sweeper/claw
	name = "sweeper claw"
	desc = "A claw cut off a sweeper captain. When night comes in the backstreets..."
	icon_state = "sweeper_claw"
	force = 12
	attack_speed = 0.6
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
