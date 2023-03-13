/obj/item/ego_weapon
	name = "ego weapon"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/ego_weapons.dmi'
	worn_icon_state = "nothing" //I HATE PURPLE SPRITES, I HATE PURPLE SPRITES
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY			//No more stupid 10 egos in bag
	slot_flags = ITEM_SLOT_BELT
	drag_slowdown = 1
	var/list/attribute_requirements = list()
	var/attack_speed
	var/special

/obj/item/ego_weapon/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return FALSE
	. = ..()
	if(attack_speed)
		user.changeNext_move(CLICK_CD_MELEE * attack_speed)
	return

/obj/item/ego_weapon/examine(mob/user)
	. = ..()
	. += EgoAttackInfo(user)
	if(special)
		. += "<span class='notice'>[special]</span>"
	if(LAZYLEN(attribute_requirements))
		. += "<span class='notice'>It has <a href='?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.</span>"

	if(reach>1)
		. += "<span class='notice'>This weapon has a reach of [reach].</span>"

	if(throwforce>force)
		. += "<span class='notice'>This weapon deals [throwforce] [damtype] damage when thrown.</span>"

	if(!attack_speed)
		return
	//Can't switch for less than for some reason
	if(attack_speed<0.4)
		. += "<span class='notice'>This weapon has a very fast attack speed.</span>"
	else if(attack_speed<0.7)
		. += "<span class='notice'>This weapon has a fast attack speed.</span>"
	else if(attack_speed<1)
		. += "<span class='notice'>This weapon attacks slightly faster than normal.</span>"
	else if(attack_speed<1.5)
		. += "<span class='notice'>This weapon attacks slightly slower than normal.</span>"
	else if(attack_speed<2)
		. += "<span class='notice'>This weapon has a slow attack speed.</span>"
	else if(attack_speed>=2)
		. += "<span class='notice'>This weapon attacks extremely slow.</span>"


/obj/item/ego_weapon/Topic(href, href_list)
	. = ..()
	if(href_list["list_attributes"])
		var/display_text = "<span class='warning'><b>It requires the following attributes:</b></span>"
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 0)
				display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
		display_text += SpecialGearRequirements()
		to_chat(usr, display_text)

/obj/item/ego_weapon/proc/CanUseEgo(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE

	if(user.mind)
		if(user.mind.assigned_role == "Sephirah") //This is an RP role
			return FALSE

	var/mob/living/carbon/human/H = user
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > get_attribute_level(H, atr))
			to_chat(H, "<span class='notice'>You cannot use [src]!</span>")
			return FALSE
	if(!SpecialEgoCheck(H))
		return FALSE
	return TRUE

/obj/item/ego_weapon/proc/SpecialEgoCheck(mob/living/carbon/human/H)
	return TRUE

/obj/item/ego_weapon/proc/SpecialGearRequirements()
	return

/obj/item/ego_weapon/proc/EgoAttackInfo(mob/user)
	return "<span class='notice'>It deals [force] [damtype] damage.</span>"

//Examine text for mini weapons.
/obj/item/ego_weapon/mini/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This weapon fits in an ego weapon belt.</span>"

//EGO shield subtype code
/obj/item/ego_weapon/shield
	var/attacking = FALSE
	var/recovery_time = 1 SECONDS
	var/block = 0
	var/block_success
	var/block_recovery = 3 SECONDS	//Recovery time, block recovery, time, and stance recovery are important shield stats; change them around when making new EGO
	var/block_time = 1 SECONDS
	var/stance_recovery = 3 SECONDS
	var/list/reductions = list(50, 50, 50, 50) //Red/White/Black/Pale defense
	var/block_message = "You attempt to block the attack!" //So you can change the text for parrying with swords
	var/hit_message = "blocks the attack!"
	var/reposition_message = "You reposition your shield"
	var/projectile_block = "You block the projectile!"
	var/block_sound = 'sound/weapons/ego/shield1.ogg'
	var/list/resistances_list = list()

//Allows the user to deflect projectiles for however long recovery time is set to on a hit
/obj/item/ego_weapon/shield/melee_attack_chain(mob/user, atom/target, params)
	..()
	if (!istype(user,/mob/living/carbon/human))
		return
	attacking = TRUE
	addtimer(CALLBACK(src, .proc/DropStance), recovery_time)

/obj/item/ego_weapon/shield/proc/DropStance()
	attacking = FALSE

//This code is what allows the user to block
/obj/item/ego_weapon/shield/attack_self(mob/user)
	if (!ishuman(user))
		return FALSE

	if (block == 0)
		var/mob/living/carbon/human/shield_user = user
		if(!CanUseEgo(shield_user))
			return FALSE
		if(shield_user.physiology.armor.bomb) //"We have NOTHING that should be modifying this, so I'm using it as an existant parry checker." - Ancientcoders
			to_chat(shield_user,"<span class='warning'>You're still off-balance!</span>")
			return FALSE
		for(var/obj/machinery/computer/abnormality/AC in range(1, shield_user))
			if(AC.datum_reference.working) // No blocking during work.
				to_chat(shield_user,"<span class='notice'>You cannot defend yourself from responsibility!</span>")
				return FALSE
		block = 1
		block_success = FALSE
		shield_user.physiology.armor = shield_user.physiology.armor.modifyRating(red = reductions[1], white = reductions[2], black = reductions[3], pale = reductions[4], bomb = 1) //bomb defense must be over 0
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, .proc/AnnounceBlock)
		addtimer(CALLBACK(src, .proc/DisableBlock, shield_user), block_time)
		to_chat(user,"<span class='userdanger'>[block_message]</span>")
		return TRUE

//Ends the block, causes you to take more damage for as long as stance_recovery if you did not block any damage
/obj/item/ego_weapon/shield/proc/DisableBlock(mob/living/carbon/human/user)
	user.physiology.armor = user.physiology.armor.modifyRating(red = -reductions[1], white = -reductions[2], black = -reductions[3], pale = -reductions[4], bomb = -1)
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	addtimer(CALLBACK(src, .proc/BlockCooldown, user), block_recovery)
	if (!block_success)
		BlockFail(user)

//Allows the user to block again when called
/obj/item/ego_weapon/shield/proc/BlockCooldown(mob/living/carbon/human/user)
	block = 0
	to_chat(user,"<span class='nicegreen'>[reposition_message]</span>")

/obj/item/ego_weapon/shield/proc/BlockFail(mob/living/carbon/human/user)
	to_chat(user,"<span class='warning'>Your stance is widened.</span>")
	user.physiology.red_mod *= 1.2
	user.physiology.white_mod *= 1.2
	user.physiology.black_mod *= 1.2
	user.physiology.pale_mod *= 1.2
	addtimer(CALLBACK(src, .proc/RemoveDebuff, user), stance_recovery)

/obj/item/ego_weapon/shield/proc/RemoveDebuff(mob/living/carbon/human/user)
	to_chat(user,"<span class='nicegreen'>You recollect your stance.</span>")
	user.physiology.red_mod /= 1.2
	user.physiology.white_mod /= 1.2
	user.physiology.black_mod /= 1.2
	user.physiology.pale_mod /= 1.2

//Handles block messages and sound effect
/obj/item/ego_weapon/shield/proc/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	block_success = TRUE
	var/src_message = "<span class='userdanger'>[source.real_name] [hit_message]</span>"

	playsound(get_turf(src), block_sound, 50, 0, 7)
	for(var/mob/living/carbon/human/person in view(7, source))
		to_chat(person, src_message)

//Adds projectile deflection on attack cooldown, you can override and return 0 to prevent this from happening.
/obj/item/ego_weapon/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK && attacking)
		final_block_chance = 100
		to_chat(owner, "<span class='userdanger'>[projectile_block]</span>")
		var/mob/living/carbon/human/other = list()
		other += oview(7, owner)
		other -= owner
		for(var/mob/living/carbon/human/person in other)
			to_chat(person,"<span class='nicegreen'>[owner.real_name] deflects the projectile!</span>")
		return ..()
	return ..()

//Examine text
/obj/item/ego_weapon/shield/examine(mob/user)
	. = ..()
	if(recovery_time)
		. += "<span class='notice'>This weapon blocks ranged attacks while attacking and can block on command.</span>"
	else
		. += "<span class='notice'>This weapon can block on command.</span>"

	if(LAZYLEN(resistances_list)) //armor tags code
		resistances_list.Cut()
	if(reductions[1] != 0)
		resistances_list += list("RED" = reductions[1])
	if(reductions[2] != 0)
		resistances_list += list("WHITE" = reductions[2])
	if(reductions[3] != 0)
		resistances_list += list("BLACK" = reductions[3])
	if(reductions[4] != 0)
		resistances_list += list("PALE" = reductions[4])

	if(LAZYLEN(resistances_list))
		. += "<span class='notice'>It has a <a href='?src=[REF(src)];list_resistances=1'>tag</a> listing its protection classes.</span>"

//Code for armor tags
/obj/item/ego_weapon/shield/Topic(href, href_list)
	. = ..()

	if(href_list["list_resistances"])
		var/list/readout = list("<span class='notice'><u><b>DEFENSE RATING (I-X)</u></b>")
		if(LAZYLEN(resistances_list))
			readout += "\n<b>DEFLECT</b>"
			for(var/dam_type in resistances_list)
				var/armor_amount = resistances_list[dam_type]
				readout += "\n[dam_type] [armor_to_protection_class(armor_amount)]" //e.g. BOMB IV
		readout += "</span>"

		to_chat(usr, "[readout.Join()]")

/obj/item/ego_weapon/shield/proc/armor_to_protection_class(armor_value)
	armor_value = round(armor_value,10) / 10
	switch (armor_value)
		if (-INFINITY to -10)
			. = "-X"
		if (-9)
			. = "-IX"
		if (-8)
			. = "-VIII"
		if (-7)
			. = "-VII"
		if (-6)
			. = "-VI"
		if (-5)
			. = "-V"
		if (-4)
			. = "-IV"
		if (-3)
			. = "-III"
		if (-2)
			. = "-II"
		if (-1)
			. = "-I"
		if (1)
			. = "I"
		if (2)
			. = "II"
		if (3)
			. = "III"
		if (4)
			. = "IV"
		if (5)
			. = "V"
		if (6)
			. = "VI"
		if (7)
			. = "VII"
		if (8)
			. = "VIII"
		if (9)
			. = "IX"
		if (10 to INFINITY)
			. = "X"
	return .
