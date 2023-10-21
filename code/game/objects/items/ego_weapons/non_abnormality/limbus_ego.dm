//Sinner EGO - WAW
/obj/item/ego_weapon/lance/sangre
	name = "le sangre de sancho"
	desc = "Ride on, Rocinante!"
	icon_state = "sangre"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 45
	reach = 2 //Has 2 Square Reach.
	attack_speed = 3 // really slow
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/fixer/generic/spear3.ogg'
	couch_cooldown_time = 4 SECONDS
	force_cap = 90
	force_per_tile = 5
	speed_per_tile = 0.3
	pierce_threshold = 0.8
	pierce_speed_cost = 1.0
	pierce_force_cost = 15
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/lance/sangre/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.10
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] > 0)
				heal_amt *= S.damage_coeff[damtype]
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)
		..()
