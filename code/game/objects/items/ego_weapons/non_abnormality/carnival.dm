
/obj/item/ego_weapon/city/carnival_spear
	name = "Carnival Spear"
	desc = "A spear that the Carnival uses to hunt down their prey."
	icon_state = "carnival_spear"
	special = "If the target hit is a dawn foe, Deal triple damage to them."
	force = 44
	reach = 2
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("whacks", "slashes")
	attack_verb_simple = list("whack", "slash")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/carnival_spear/attack(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		return
	var/initial_force = force
	if(istype(target, /mob/living/simple_animal/hostile/ordeal))
		var/mob/living/simple_animal/hostile/ordeal/O = target
		if (O.dawn)
			force *= 3
	..()
	force = initial_force
