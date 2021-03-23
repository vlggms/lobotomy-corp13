/obj/item/clothing/head/hardhat/nolight
	name = "sturdy hard hat"
	desc = "A standard hardhat with lights removed. Goes well with welding goggles."
	icon = 'ModularTegustation/Teguicons/head_item.dmi'
	icon_state = "hardhat_nolight"
	worn_icon = 'ModularTegustation/Teguicons/head_worn.dmi'
	actions_types = list()
	dog_fashion = null
	light_range = 0
	light_power = 0

/obj/item/clothing/head/hardhat/nolight/attack_self(mob/living/user)
	return

/obj/item/clothing/head/caphat/admiral
	name = "rear admiral's cap"
	desc = "Worn by the finest captains of the Nanotrasen. Inside the lining of the cap, lies two faint initials."
	icon_state = "centcom_cap"
	inhand_icon_state = "that"
	dog_fashion = null

/obj/item/clothing/head/susp_bowler
	name = "black bowler"
	desc = "A deep black bowler. Inside the hat, there is a sleek red S, with a smaller X insignia embroidered within. On closer inspection, the brim feels oddly weighted..."
	icon = 'ModularTegustation/Teguicons/head_item.dmi'
	icon_state = "bowlerhat"
	worn_icon = 'ModularTegustation/Teguicons/head_worn.dmi'
	dynamic_hair_suffix = ""
	force = 3
	throwforce = 45
	throw_speed = 5
	throw_range = 9
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("attacks", "slashes", "slices", "rips", "dices", "cuts", "flays", "eviscerates")
	attack_verb_simple = list("attack", "slash", "slice", "dice", "cut", "flay")
	armour_penetration = 30
	hitsound = "swing_hit"
	sharpness = SHARP_EDGED

