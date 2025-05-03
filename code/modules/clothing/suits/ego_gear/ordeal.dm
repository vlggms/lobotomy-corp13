/obj/item/clothing/suit/armor/ego_gear/adjustable/claw
	name = "claw armor"
	desc = "A simple suit and tie with several injectors attached. The fabric is near indestructable."
	icon_state = "claw"
	icon = 'icons/obj/clothing/ego_gear/lc13_armor.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lc13_armor.dmi'
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 100, BLACK_DAMAGE = 90, PALE_DAMAGE = 90) // The arbiter's henchman
	equip_slowdown = 0 // In accordance of arbiter armor
	hat = /obj/item/clothing/head/ego_hat/claw_head
	alternative_styles = list("claw", "claw_baral")

/obj/item/clothing/head/ego_hat/claw_head
	name = "mask of the claw"
	desc = "A faceless mask with an injector stuck on top of it."
	icon_state = "claw"
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT

// Ordeal armor for non post midnight midnights. There's not really a stat total besides 240

/obj/item/clothing/suit/armor/ego_gear/ordeal
	icon = 'icons/obj/clothing/ego_gear/ordeal.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/ordeal.dmi'

/obj/item/clothing/suit/armor/ego_gear/ordeal/eternal_feast
	name = "Endless feast"
	desc = "Made out of tough scales and flesh of a powerful ordeal. Wearing it makes you feel hungry as well."
	icon_state = "eternal_feast"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 70, BLACK_DAMAGE = 80, PALE_DAMAGE = 40) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/painful_purpose
	name = "Painful purpose"
	desc = "A heavy armor made as solace of the end of all."
	icon_state = "painful_purpose"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 50, BLACK_DAMAGE = 40, PALE_DAMAGE = 70) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/meaningless_march
	name = "Meaningless march"
	desc = "Want to know how I got these scars?"
	icon_state = "meaningless_march"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 70, BLACK_DAMAGE = 50, PALE_DAMAGE = 40) // 230
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion
	name = "Delusionist's end"
	desc = "An eerie glow emanates from it."
	icon_state = "delusion_black"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 60, BLACK_DAMAGE = 80, PALE_DAMAGE = 60) // 200
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
//unused version of it
/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/true_god//200 total can shift between 4 armor modes with a 120 second cooldown. A sidegrade to season greeting with both having 4 forms and an 8 in one damage type per form but delusionist's end has much worse total armor but has the ability to freely switch with its ability.
	name = "True Delusionist's end"
	desc = "This is a placeholder."
	icon_state = "delusion_red"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/mob/current_holder
	var/current_damage = "red"
	var/list/damage_list = list(
		"red" = list("A runic armor with an eerie red glow."),
		"white" = list("A runic armor with an eerie white glow."),
		"black" = list("A runic armor with an eerie black glow."),
		"pale" = list("A runic armor with an eerie pale glow.")
		)

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/true_god/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	Transform()
	var/obj/effect/proc_holder/ability/AS = new /obj/effect/proc_holder/ability/god_delusion
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/true_god/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/true_god/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/true_god/proc/Transform()
	icon_state = "delusion_[current_damage]"
	update_icon_state()
	if(current_holder)
		current_holder.update_inv_wear_suit()
		to_chat(current_holder, span_notice("[src] suddenly shifts color!"))
	desc = damage_list[current_damage][1]
	switch(current_damage)
		if("red")
			src.armor = getArmor(red = 80, white = 60, black = 0, pale = 60)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_red_attack.ogg', 50, FALSE, 32)
		if("white")
			src.armor = getArmor(red = 60, white = 80, black = 60, pale = 0)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_white_attack.ogg', 50, FALSE, 32)
		if("black")
			src.armor = getArmor(red = 0, white = 60, black = 80, pale = 60)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_black_attack1.ogg', 50, FALSE, 32)
		if("pale")
			src.armor = getArmor(red = 60, white = 0, black = 60, pale = 80)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_pale_attack.ogg', 50, FALSE, 32)

// Radial menu
/obj/effect/proc_holder/ability/god_delusion
	name = "Color Shift"
	desc = "Lets the user change the current form and damage resistances of the armor."
	action_icon_state = null
	base_icon_state = null
	cooldown_time = 120 SECONDS
	var/selection_icons = 'icons/mob/clothing/ego_gear/ordeal.dmi'

/obj/effect/proc_holder/ability/god_delusion/Perform(target, mob/user)
	var/list/armament_icons = list(
		"red" = image(icon = selection_icons, icon_state = "delusion_red"),
		"white"  = image(icon = selection_icons, icon_state = "delusion_white"),
		"black"  = image(icon = selection_icons, icon_state = "delusion_black"),
		"pale"  = image(icon = selection_icons, icon_state = "delusion_pale")
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, user , armament_icons, custom_check = CALLBACK(src, PROC_REF(CheckMenu), user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	var/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/true_god/T = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(T))
		T.current_damage = choice
		T.Transform()
	return ..()

/obj/effect/proc_holder/ability/god_delusion/proc/CheckMenu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/suit/armor/ego_gear/ordeal/familial_strength
	name = "Familial Strength"
	desc = "A heavy armor from the mother of all sweepers."
	icon_state = "familial_strength"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 30, BLACK_DAMAGE = 80, PALE_DAMAGE = 60) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/wonderland
	name = "Wonderland"
	desc = "It's hard to look at it right."
	icon_state = "wonderland"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 40, BLACK_DAMAGE = 70, PALE_DAMAGE = 80) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

