/obj/item/bodypart/l_arm/robot/timestop
	name = "timestop left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. This arm releases a timestop phial when damaged, allowing for the user to escape damage."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/timestoparm.dmi'
	icon_state = "timestop_l_arm"
	max_damage = 20
	brute_reduction = 0
	burn_reduction = 0


/obj/item/bodypart/l_arm/robot/timestop/on_disabled()
	new /obj/effect/timestop(get_turf(owner), 3, 5 SECONDS, list(owner))


/obj/item/bodypart/r_arm/robot/timestop
	name = "timestop right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. This arm releases a timestop phial when damaged, allowing for the user to escape damage."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/timestoparm.dmi'
	icon_state = "timestop_r_arm"
	max_damage = 20
	brute_reduction = 0
	burn_reduction = 0


/obj/item/bodypart/r_arm/robot/timestop/on_disabled()
	new /obj/effect/timestop(get_turf(owner), 3, 5 SECONDS, list(owner))

