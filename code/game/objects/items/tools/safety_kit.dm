/obj/item/safety_kit
	name = "Safety Department Regenerator Augmentation Kit"
	desc = "R.A.K. for short, it's utilized to enhance and modify regenerators for short periods of time."
	icon = 'icons/obj/tools.dmi'
	icon_state = "sdrak"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/crowbar.ogg'
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("attacks", "bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("attack", "bash", "batter", "bludgeon", "whack")
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	var/mode = 1

/obj/item/safety_kit/attack_self(mob/user)
	if(!clerk_check(user))
		to_chat(user,"<span class='warning'>You don't know how to use this.</span>")
		return
	switch(mode)
		if(1)
			mode = 2
			to_chat(user, "<span class='notice'>You will now improve the SP Regeneration of the Regenerator at the cost of the HP Regeneration.</span>")
		if(2)
			mode = 3
			to_chat(user, "<span class='notice'>You will now slightly improve the overall performance of the Regenerator.</span>")
		if(3)
			mode = 4
			to_chat(user, "<span class='notice'>You will now enable the Regenerator to heal those in critical conditions at the cost of overall performance.</span>")
		if(4)
			mode = 5
			to_chat(user, "<span class='notice'>You will now cause the Regenerator to heal a large burst of HP and SP.</span>")
			to_chat(user, "<span class='warning'>This will cause the Regenerator to go on a cooldown period afterwards.</span>")
		if(5)
			mode = 1
			to_chat(user, "<span class='notice'>You will now improve the HP Regeneration of the Regenerator at the cost of the SP Regeneration.</span>")
	return

/obj/item/safety_kit/examine(mob/user)
	. = ..()
	switch(mode)
		if(1)
			. += "Currently set to sacrifice SP Regeneration for HP Regeneration."
		if(2)
			. += "Currently set to sacrifice HP Regeneration for SP Regeneration."
		if(3)
			. += "Currently set to improve overall Regenerator functions."
		if(4)
			. += "Currently set to allow healing of those in Critical Condition."
		if(5)
			. += "Currently set to cause the Regenerator to burst recovery."
			. += "<span class='warning'>This will cause the Regenerator to go on a cooldown period afterwards.</span>"

/obj/item/safety_kit/proc/clerk_check(mob/living/carbon/human/H)
	if(istype(H) && (H?.mind?.assigned_role == "Clerk"))
		return TRUE
	return FALSE



