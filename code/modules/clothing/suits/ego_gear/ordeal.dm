// Ordeal armor for midnight. There's not really a stat total besides 240-260 unless you're doing some silly stuff

/obj/item/clothing/suit/armor/ego_gear/ordeal
	icon = 'icons/obj/clothing/ego_gear/ordeal.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/ordeal.dmi'

/obj/item/clothing/suit/armor/ego_gear/ordeal/amber //well rounded and provides good resistances to red and black.
	name = "final meal"
	desc = ""
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 40) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/green //very high stats at the cost of slowing you down. Not as extreme as grosshammmer though.
	name = "helix of the end"
	desc = "A heavy armor made as solace of the end of all. \n Provides excellent protection at the cost of speed."
	slowdown = 0.75
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 70, BLACK_DAMAGE = 60, PALE_DAMAGE = 80) // 300
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/crimson //provides a sanity healing aura simular to chuckles. also realized clown smiling at me armor lol.
	name = "the circus"
	desc = "We live in a society."
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 80, BLACK_DAMAGE = 50, PALE_DAMAGE = 30) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

	var/CanHeal = FALSE

/obj/item/clothing/suit/armor/ego_gear/ordeal/crimson/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		CanHeal = TRUE
		addtimer(CALLBACK(src, .proc/Heal,user), 10 SECONDS)

/obj/item/clothing/suit/armor/ego_gear/ordeal/crimson/dropped(mob/user)
	CanHeal = FALSE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/ordeal/crimson/proc/Reset(mob/user)
	if(!CanHeal)
		return
	Heal(user)

/obj/item/clothing/suit/armor/ego_gear/ordeal/crimson/proc/Heal(mob/user)
	if(!CanHeal)
		return
	addtimer(CALLBACK(src, .proc/Reset,user), 10 SECONDS)
	for(var/mob/living/carbon/human/L in view(3, user))
		if(L.stat != DEAD)
			L.emote("laugh")
			L.adjustSanityLoss(-5)

/obj/item/clothing/suit/armor/ego_gear/ordeal/violet//220 total can shift between 4 armor modes.
	name = "pillar"
	desc = "This is a placeholder."
	icon_state = "spring"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 50) // 220
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/mob/current_holder
	var/current_damage = "red"
	var/list/damage_list = list(
		"red" = list("bloody pillar", "A runic armor with a red glow.."),
		"white" = list("maddness pillar","A runic armor with a white glow."),
		"black" = list("abyssal pillar","A runic armor with a black glow."),
		"pale" = list("soul pillar","A runic armor with a pale glow.")
		)

/obj/item/clothing/suit/armor/ego_gear/ordeal/violet/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	Transform()
	var/obj/effect/proc_holder/ability/AS = new /obj/effect/proc_holder/ability/violet
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/ordeal/violet/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/clothing/suit/armor/ego_gear/ordeal/violet/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/clothing/suit/armor/ego_gear/ordeal/violet/proc/Transform()
	icon_state = "[current_damage]"
	update_icon_state()
	if(current_holder)
		current_holder.update_inv_wear_suit()
		to_chat(current_holder,"<span class='notice'>[src] suddenly shifts color!</span>")
	name = damage_list[current_damage][1]
	desc = damage_list[current_damage][2]
	switch(current_damage)
		if("red")
			src.armor = new(red = 90, white = 60, black = 20, pale = 50)
		if("white")
			src.armor = new(red = 50, white = 90, black = 60, pale = 20)
		if("black")
			src.armor = new(red = 20, white = 50, black = 90, pale = 60)
		if("pale")
			src.armor = new(red = 60, white = 20, black = 50, pale = 90)

// Radial menu
/obj/effect/proc_holder/ability/violet
	name = "Damage Shift"
	desc = "Lets the user change the current form and damage resistances of the armor"
	action_icon_state = null
	base_icon_state = null
	cooldown_time = 30 SECONDS
	var/selection_icons = 'icons/mob/clothing/ego_gear/ordeal.dmi'

/obj/effect/proc_holder/ability/violet/Perform(target, mob/user)
	var/list/armament_icons = list(
		"red" = image(icon = selection_icons, icon_state = "red"),
		"white"  = image(icon = selection_icons, icon_state = "white"),
		"black"  = image(icon = selection_icons, icon_state = "black"),
		"pale"  = image(icon = selection_icons, icon_state = "pale")
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, user , armament_icons, custom_check = CALLBACK(src, .proc/CheckMenu, user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	var/obj/item/clothing/suit/armor/ego_gear/ordeal/violet/T = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(T))
		T.current_damage = choice
		T.Transform()
	return ..()

/obj/effect/proc_holder/ability/violet/proc/CheckMenu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/suit/armor/ego_gear/ordeal/indigo //health hauler
	name = "sweeper"
	desc = "89 111 117 39 114 101 32 97 32 110 101 114 100! \n Causes all melee weapons to heal you 2.5% of the weapons force in hp and sp."
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 80, PALE_DAMAGE = 50) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/indigo/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		RegisterSignal(parent, COMSIG_ITEM_ATTACK, .proc/corruption_attack)

/obj/item/clothing/suit/armor/ego_gear/ordeal/indigo/dropped(mob/user)
	var/obj/item/held = user.get_active_held_item()
	UnregisterSignal(held, COMSIG_HOSTILE_ATTACKINGTARGET)
	return ..()

/datum/component/corruption_balance/proc/corruption_attack(datum/source, mob/living/target, mob/living/user)

	ifisliving(heal_target)
	var/obj/item/held = user.get_active_held_item()
	var/heal_amt = held.force*0.025//a sixth of mimicry
	if(isanimal(target))
		var/mob/living/simple_animal/S = target
		if(S.damage_coeff.getCoeff(damtype) > 0)
			heal_amt *= S.damage_coeff.getCoeff(damtype)
		else
			heal_amt = 0
	new /obj/effect/temp_visual/dir_setting/speedbike_trail(get_turf(user))
	user.adjustBruteLoss(-heal_amt)
	user.adjustSanityLoss(-heal_amt)

/obj/item/clothing/suit/armor/ego_gear/ordeal/pink //text here.
	name = "wonderland"
	desc = ""
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 60) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/white_red //realize tier stats because why not.
	name = "red fixer"
	desc = "A mechanical suit of armor."
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 70, BLACK_DAMAGE = 30, PALE_DAMAGE = 70) // 260
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/white_white //realize tier stats because why not.
	name = "white fixer"
	desc = "Looks regal."
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 90, BLACK_DAMAGE = 70, PALE_DAMAGE = 30) // 260
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/white_black //realize tier stats because why not.
	name = "black fixer"
	desc = "Looks like a coat a man who would let a facility fall to ruin would wear."
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 70, BLACK_DAMAGE = 90, PALE_DAMAGE = 70) // 260
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/white_pale //realize tier stats because why not.
	name = "pale fixer"
	desc = "Reminds you of the tax man."
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 30, BLACK_DAMAGE = 70, PALE_DAMAGE = 90) // 260
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/suit/armor/ego_gear/ordeal/white_claw //todo add claw.
	name = "claw"
	desc = ""
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 80, BLACK_DAMAGE = 80, PALE_DAMAGE = 90) // 340
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 130,
							PRUDENCE_ATTRIBUTE = 130,
							TEMPERANCE_ATTRIBUTE = 130,
							JUSTICE_ATTRIBUTE = 130
							)
