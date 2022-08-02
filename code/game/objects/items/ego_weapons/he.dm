/obj/item/ego_weapon/grinder
	name = "grinder MK4"
	desc = "The sharp sawtooth of the grinder makes a clean cut through its enemy. \
	Its operation is simple and straightforward, but that doesn't necessarily make it easy to wield."
	icon_state = "grinder"
	force = 30
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/harvest
	name = "harvest"
	desc = "The last legacy of the man who sought wisdom. The rake tilled the human brain instead of farmland."
	icon_state = "harvest"
	force = 30
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("attacks", "bashes", "tills")
	attack_verb_simple = list("attack", "bash", "till")
	hitsound = 'sound/weapons/ego/harvest.ogg'

/obj/item/ego_weapon/fury
	name = "blind fury"
	desc = "A fancy black and white halberd with a sharp blade. Whose head will it cut off next?"
	icon_state = "fury"
	force = 45
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/ego/axe2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/fury/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.5) // Slow
