/obj/item/ego_weapon/city/carnival_spear
	name = "Carnival Spear"
	desc = "A spear that the Carnival uses to hunt down their prey."
	icon_state = "carnival_spear"
	inhand_icon_state = "carnival_spear"
	special = "Deal double damage to mobs of the backstreets. This weapon also stuns target humans, if the user and the target human are alone."
	force = 35
	reach = 2
	attack_speed = 1
	stuntime = 5
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
		/mob/living/simple_animal/hostile/humanoid/blood,
	)

/obj/item/ego_weapon/city/carnival_spear/Initialize()
	. = ..()
	empowered_targets = typecacheof(empowered_targets)

/obj/item/ego_weapon/city/carnival_spear/attack(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		return
	var/initial_force = force
	if(is_type_in_typecache(target, empowered_targets))
		to_chat(user, span_nicegreen("Your attack against [target.name] is empowered!"))
		force *= 2
	..()
	force = initial_force
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/alone = TRUE
		for(var/mob/living/carbon/human/O in range(7, target))
			if(O == user || O == H)
				continue
			if(O.stat == DEAD || !O.client)
				continue
			else
				alone = FALSE
		if(alone)
			H.Knockdown(20)
			to_chat(user, span_nicegreen("You backstab [H.name], dropping them to the ground!"))
			to_chat(H, span_danger("You are backstabed by [user.name], dropping you to the ground!"))

/obj/item/ego_weapon/city/carnival_spear/weak
	name = "Worn-down Carnival Spear"
	force = 22
	attribute_requirements = list()
