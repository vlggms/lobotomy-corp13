//Rats weapons. This is all throwaway junk.
/obj/item/ego_weapon/city/rats
	name = "rat hammer"
	desc = "A hammer sometimes found in the hands of rats."
	icon_state = "rathammer"
	force = 18
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/city/rats/knife
	name = "rat combat knife"
	desc = "A combat knife sometimes found in the hands of rats."
	icon_state = "ratknife"
	force = 10
	attack_speed = 0.5
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/city/rats/scalpel
	name = "rat scalpel"
	desc = "A combat sometimes found in the hands of rats."
	icon_state = "ratscalpel"
	force = 20
	attack_speed = 1.2
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
