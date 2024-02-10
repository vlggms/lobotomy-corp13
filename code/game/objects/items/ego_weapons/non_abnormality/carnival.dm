/obj/item/ego_weapon/city/carnival_spear
	name = "Carnival Spear"
	desc = "A spear that the Carnival uses to hunt down their prey."
	icon_state = "carnival_spear"
	inhand_icon_state = "carnival_spear"
	special = "Deal double damage to mobs of the backstreets."
	force = 30
	reach = 2
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("whacks", "slashes")
	attack_verb_simple = list("whack", "slash")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

	var/list/empowered_targets = list(
		/mob/living/simple_animal/hostile/shrimp,
		/mob/living/simple_animal/hostile/shrimp_soldier,
		/mob/living/simple_animal/hostile/ordeal,
		/mob/living/simple_animal/hostile/kcorp/drone,
	)

/obj/item/ego_weapon/city/carnival_spear/Initialize()
	. = ..()
	empowered_targets = typecacheof(empowered_targets)

/obj/item/ego_weapon/city/carnival_spear/attack(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		return
	var/initial_force = force
	if(is_type_in_typecache(target, empowered_targets))
		force *= 2
	..()
	force = initial_force
