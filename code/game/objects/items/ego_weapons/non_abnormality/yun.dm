//Yun Office. This is all throwaway junk for the Allas workshop
/obj/item/ego_weapon/city/yun
	name = "yun office baton"
	desc = "A stern baton. It's easy to see how callous the previous user must have been."
	icon_state = "yun_fixer"
	force = 18
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")

/obj/item/ego_weapon/city/yun/shortsword
	name = "yun office shortsword"
	desc = "A shortsword of decent quality. Holding it fills you with the ambition of a pure-hearted newbie."
	icon_state = "yun_sword"
	force = 19
	attack_speed = 0.7
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/city/yun/chainsaw
	name = "yun office chainsword"
	desc = "A heavy chainsword. You'd need an augmentation to use it with only one hand. It looks pricey."
	icon_state = "yun_chainsword"
	force = 22
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
