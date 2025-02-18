/obj/item/bodypart/l_arm/robot/explosive
	name = "explosive left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. This arm explodes upon being disabled, blowing itself off and dealing massive damage to anyone nearby."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/explosivearm.dmi'
	icon_state = "explosive_l_arm"
	max_damage = 20
	brute_reduction = 0
	burn_reduction = 0


/obj/item/bodypart/l_arm/robot/explosive/on_disabled()
	explosion(owner,0,0,5,8)
	for(var/mob/living/H in view(5, get_turf(src)))
		H.adjustBruteLoss(H.maxHealth*0.8, TRUE, TRUE)


/obj/item/bodypart/r_arm/robot/explosive
	name = "explosive right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. This arm explodes upon being disabled, blowing itself off and dealing massive damage to anyone nearby."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/explosivearm.dmi'
	icon_state = "explosive_r_arm"
	max_damage = 20
	brute_reduction = 0
	burn_reduction = 0


/obj/item/bodypart/r_arm/robot/explosive/on_disabled()
	explosion(owner,0,0,5,8)
	for(var/mob/living/H in view(5, get_turf(src)))
		H.adjustBruteLoss(H.maxHealth*0.8, TRUE, TRUE)

