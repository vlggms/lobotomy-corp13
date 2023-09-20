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

	var/list/empowered_targets = list(
		/mob/living/simple_animal/hostile/ordeal/amber_bug,
		/mob/living/simple_animal/hostile/ordeal/green_bot,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn
		)
		
/obj/item/ego_weapon/city/carnival_spear/Initialize()
	. = ..()
	empowered_targets = typecacheof(empowered_targets)
	
/obj/item/ego_weapon/city/carnival_spear/attack(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		return
	var/initial_force = force
	if(is_type_in_typecache(target, empowered_targets))
		force *= 3
	..()
	force = initial_force
