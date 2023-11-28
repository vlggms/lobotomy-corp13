// Ordeal armor for midnight. There's not really a stat total besides 250 unless you're doing some silly stuff then it probably should be lower unless you want pre 19Kirie4 repentance situation. Just follow what Kirie did with realized armor.

/obj/item/clothing/suit/armor/ego_gear/ordeal
	icon = 'icons/obj/clothing/ego_gear/ordeal.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/ordeal.dmi'

/obj/item/clothing/suit/armor/ego_gear/ordeal/eternal_feast //well rounded and provides good resistances to all but pale. No ability or passive since amber midnight was the first midnight to be added so it not having one feels fair(Also I had no ideas for it).
	name = "Endless feast"
	desc = "Made out of tough scales and flesh of a powerful ordeal. Wearing it makes you feel hungry as well."
	icon_state = "eternal_feast"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 60, BLACK_DAMAGE = 70, PALE_DAMAGE = 40) // 250
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/painful_purpose //very high stats at the cost of slowing you down. Not as extreme as grosshammmer though but has less black.
	name = "Painful purpose"
	desc = "A heavy armor made as solace of the end of all.\n\
		Provides excellent protection at the cost of speed."
	slowdown = 0.75
	icon_state = "painful_purpose"
	hat = /obj/item/clothing/head/ego_hat/painful_purpose
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 70, BLACK_DAMAGE = 60, PALE_DAMAGE = 80) // 300
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/head/ego_hat/painful_purpose
	name = "Final helix"
	desc = "Todo: put something funny here."
	icon_state = "painful_purpose"
	flags_inv = HIDEHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH

/obj/item/clothing/suit/armor/ego_gear/ordeal/meaningless_march //provides a sanity healing aura simular to chuckles. Also stat wise being great red and white and poor black and pale means that this is a realized version of Dark carnival technically.
	name = "Meaningless march"
	desc = "Want to know how I got these scares? \n\
		Causes the wearer to make themself and others around them laugh healing their sp."
	icon_state = "meaningless_march"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 70, BLACK_DAMAGE = 50, PALE_DAMAGE = 30) // 220
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

	var/CanHeal = FALSE

/obj/item/clothing/suit/armor/ego_gear/ordeal/meaningless_march/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		CanHeal = TRUE
		addtimer(CALLBACK(src, .proc/Heal,user), 15 SECONDS)

/obj/item/clothing/suit/armor/ego_gear/ordeal/meaningless_march/dropped(mob/user)
	CanHeal = FALSE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/ordeal/meaningless_march/proc/Reset(mob/user)
	if(!CanHeal)
		return
	Heal(user)

/obj/item/clothing/suit/armor/ego_gear/ordeal/meaningless_march/proc/Heal(mob/user)
	if(!CanHeal)
		return
	addtimer(CALLBACK(src, .proc/Reset,user), 15 SECONDS)
	for(var/mob/living/carbon/human/L in view(3, user))
		if(L.stat != DEAD)
			L.emote("laugh")
			L.adjustSanityLoss(-5)//0.33 sp per second. probably could be buffed but knowing Kirie she's probaby going to want me to change this to 190 total even if the healing isn't that good even.

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion//200 total can shift between 4 armor modes with a 30 second cooldown. A sidegrade to season greeting with both having 4 forms and an 8 in one damage type per form but delusionist's end has much worse total armor but has the ability to freely switch with its ability.
	name = "Delusionist's end"
	desc = "This is a placeholder."
	icon_state = "delusion_red"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 50) // 200
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/mob/current_holder
	var/current_damage = "red"
	var/list/damage_list = list(
		"red" = list("A runic armor with a red glow."),
		"white" = list("A runic armor with a white glow."),
		"black" = list("A runic armor with a black glow."),
		"pale" = list("A runic armor with a pale glow.")
		)

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	Transform()
	var/obj/effect/proc_holder/ability/AS = new /obj/effect/proc_holder/ability/god_delusion
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/proc/Transform()
	icon_state = "delusion_[current_damage]"
	update_icon_state()
	if(current_holder)
		current_holder.update_inv_wear_suit()
		to_chat(current_holder,"<span class='notice'>[src] suddenly shifts color!</span>")
	desc = damage_list[current_damage][1]
	switch(current_damage)
		if("red")
			src.armor = new(red = 80, white = 60, black = 10, pale = 50)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_red_attack.ogg', 50, FALSE, 32)
		if("white")
			src.armor = new(red = 50, white = 80, black = 60, pale = 10)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_white_attack.ogg', 50, FALSE, 32)
		if("black")
			src.armor = new(red = 10, white = 50, black = 80, pale = 60)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_black_attack1.ogg', 50, FALSE, 32)
		if("pale")
			src.armor = new(red = 60, white = 10, black = 50, pale = 80)
			playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_pale_attack.ogg', 50, FALSE, 32)

// Radial menu
/obj/effect/proc_holder/ability/god_delusion
	name = "Color Shift"
	desc = "Lets the user change the current form and damage resistances of the armor."
	action_icon_state = null
	base_icon_state = null
	cooldown_time = 30 SECONDS
	var/selection_icons = 'icons/mob/clothing/ego_gear/ordeal.dmi'

/obj/effect/proc_holder/ability/god_delusion/Perform(target, mob/user)
	var/list/armament_icons = list(
		"red" = image(icon = selection_icons, icon_state = "delusion_red"),
		"white"  = image(icon = selection_icons, icon_state = "delusion_white"),
		"black"  = image(icon = selection_icons, icon_state = "delusion_black"),
		"pale"  = image(icon = selection_icons, icon_state = "delusion_pale")
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, user , armament_icons, custom_check = CALLBACK(src, .proc/CheckMenu, user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	var/obj/item/clothing/suit/armor/ego_gear/ordeal/god_delusion/T = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
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

/obj/item/clothing/suit/armor/ego_gear/ordeal/familial_strength //Basic armor with a major weakness to white. Don't give this haulers or else Kirie will tell you that you burned down the kitchen.
	name = "Familial Strength"
	desc = "A heavy armor from the mother of all sweepers."
	icon_state = "familial_strength"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 30, BLACK_DAMAGE = 80, PALE_DAMAGE = 70) // 250
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/wonderland //fuck pink midnight
	name = "Wonderland"
	desc = "Catt Wonderlab"
	icon_state = "wonderland"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 80) // 250
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
