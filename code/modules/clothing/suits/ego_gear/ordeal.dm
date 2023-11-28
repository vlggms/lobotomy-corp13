// Ordeal armor for midnight. There's not really a stat total besides 240 unless you're doing some silly stuff then it probably should be lower unless you want pre 19Kirie4 repentance situation.

/obj/item/clothing/suit/armor/ego_gear/ordeal
	icon = 'icons/obj/clothing/ego_gear/ordeal.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/ordeal.dmi'

/obj/item/clothing/suit/armor/ego_gear/ordeal/eternal_feast //well rounded and provides good resistances to red and black. No ability or passive since I had no ideas for it
	name = "Endless feast"
	desc = "Hey you know with this stat spread it might not be that bad for the claw"
	icon_state = "eternal_feast"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 40) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/painful_purpose //very high stats at the cost of slowing you down. Not as extreme as grosshammmer though.
	name = "Painful purpose"
	desc = "A heavy armor made as solace of the end of all.\nProvides excellent protection at the cost of speed."
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

/obj/item/clothing/suit/armor/ego_gear/ordeal/meaningless_march //provides a sanity healing aura simular to chuckles. also realized clown smiling at me armor stat wise being great red and white and poor black and pale.
	name = "Meaningless march"
	desc = "Want to know how I got these scares?\nCauses the wearer to make themself and others around them laugh healing their sp."
	icon_state = "meaningless_march"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 40) // 220
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
			L.adjustSanityLoss(-5)//0.33 sp per second. probably could be buffed but knowing Kirie she's probaby going to want me to change this to a stat spread to waw tier.

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
		"red" = list("A runic armor with a red glow.."),
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
		if("white")
			src.armor = new(red = 50, white = 80, black = 60, pale = 10)
		if("black")
			src.armor = new(red = 10, white = 50, black = 80, pale = 60)
		if("pale")
			src.armor = new(red = 60, white = 10, black = 50, pale = 80)

// Radial menu
/obj/effect/proc_holder/ability/god_delusion
	name = "Color Shift"
	desc = "Lets the user change the current form and damage resistances of the armor"
	action_icon_state = null
	base_icon_state = null
	cooldown_time = 60 SECONDS
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

/obj/item/clothing/suit/armor/ego_gear/ordeal/familial_strength //trades speed and total armor for having heath and mind haulers for all melee ego weapons. Also slows you down due to how sweepers are slow. This turns the user into more of a tank trading speed for survivability with both life steal and good red and black.
	name = "Familial Strength"
	desc = "somether here. Causes all melee weapons to heal you 2% of the weapons force in hp and sp.\nSlows you down a small bit."//It's percent based to prevent fast attacking weapons from healing a shit ton while slower weapons not really healing at all.
	slowdown = 0.25
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 20, BLACK_DAMAGE = 80, PALE_DAMAGE = 50) // 220
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)


