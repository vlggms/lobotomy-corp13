//Wedge - Grade 4 with two range.
/obj/item/ego_weapon/city/wedge
	name = "wedge office spear"
	desc = "A black, ornate spear used by the wedge office."
	icon_state = "wedge"
	force = 52
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/city/fixerblade
	name = "fixer blade"
	desc = "A basic fixer blade found in the hands of many fixers."
	icon_state = "fixer_blade"
	force = 22
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

/obj/item/ego_weapon/city/fixergreatsword
	name = "fixer greatsword"
	desc = "A heafty fixer blade found in the hands of many fixers."
	icon_state = "fixer_greatsword"
	force = 32
	attack_speed = 1.4
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	hitsound = 'sound/weapons/genhit3.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
