
/**
 *
 * Modular file containing: fishing hooks
 * fishing hooks can be put on a rod to enhance its fishing value
 *
 */

/obj/item/fishing_component/hook
	name = "simple fishing hook"
	desc = "A simple fishing hook."
	icon = 'ModularTegustation/fishing/icons/fishing_hooks.dmi'
	icon_state = "hook"
	/// icon state added to main rod icon when this hook is equipped
	var/rod_overlay_icon_state = "hook_overlay"

/obj/item/fishing_component/hook/bone
	name = "bone hook"
	desc = "a simple hook carved from sharpened bone"
	icon_state = "bone"
	fishing_value = 0.3

/datum/crafting_recipe/bone_hook
	name = "Bone Hook"
	result = /obj/item/fishing_component/hook/bone
	reqs = list(/obj/item/stack/sheet/bone = 1)
	time = 2 SECONDS
	category = CAT_MISC

/obj/item/fishing_component/hook/weighted
	name = "weighted hook"
	icon_state = "weighted"
	fishing_value = 0.4
	rod_overlay_icon_state = "hook_weighted_overlay"

/obj/item/fishing_component/hook/shiny
	name = "shiny lure hook"
	icon_state = "shiny"
	rod_overlay_icon_state = "hook_shiny_overlay"
	fishing_value = 0.6
