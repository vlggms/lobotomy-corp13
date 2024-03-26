//Grade 4-5 Weapons, heal sanity on kill
/obj/item/ego_weapon/city/molar
	name = "molar chainsword"
	desc = "A chainsword used by the Molar Office. It's heavy, and well made."
	special = "On kill, heal 30 sanity."
	icon_state = "mika"
	force = 44
	damtype = RED_DAMAGE

	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/city/molar/attack(mob/living/target, mob/living/carbon/human/user)
	var/living = FALSE
	if(!CanUseEgo(user))
		return
	if(target.stat != DEAD)
		living = TRUE
	..()
	if(target.stat == DEAD && living)
		user.adjustSanityLoss(-30)
		living = FALSE

/obj/item/ego_weapon/city/molar/olga
	name = "molar chainknife"
	desc = "A short chainsword used by the Molar Office's leader. Its chain sings with the speed it moves at."
	icon_state = "olga"
	force = 38
	attack_speed = 0.7
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,	//She's got bad temperance, get it? Because temperance is another word for not drinking alcohol?
							JUSTICE_ATTRIBUTE = 80
							)
