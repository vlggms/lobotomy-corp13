/obj/item/ego_weapon/grinder
	name = "grinder MK4"
	desc = "The sharp sawtooth of the grinder makes a clean cut through its enemy. \
	Its operation is simple and straightforward, but that doesn't necessarily make it easy to wield."
	icon_state = "grinder"
	force = 30
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)
