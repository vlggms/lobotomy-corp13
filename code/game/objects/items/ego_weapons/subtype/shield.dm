//EGO shield subtype code

/*
	So, since this wasn't written, I'm gonna try and do a preliminary Block value thing.
	RISK LEVEL	|  ARMOR TOTAL	|   ARMOR CAP	|	PALE ARMOR CAP	|
	ZAYIN		|		80		|		30		|		 10			|
	TETH		|		120		|		50		|		 20			|
	HE			|	 	160		|		70		|		 30			|
	WAW			|		200		|		80		|		 40			|
	ALEPH		| 		300		|		90		|		 50			|

	These can be adjusted based off time of the block. The longer the block, the worse the armor.
	Shields should also be typically worse weapons. Typically.
	Standard Block Time is 1 Second.
	Going below this to 0.5 SECONDS grants you +20 Armor total.
	Going above this reduces armor total by 10 per 0.5 SECONDS.

*/
/obj/item/ego_weapon/shield
	attack_speed = 3
	force = 40
	var/attacking = FALSE
	var/block = FALSE
	var/block_success
	var/list/resistances_list = list()
	// Change anything below this line for customization. Nothing above it.
	var/projectile_block_duration = 1 SECONDS
	var/block_cooldown = 3 SECONDS
	var/block_duration = 1 SECONDS
	var/debuff_duration = 3 SECONDS
	var/list/reductions = list(20, 20, 20, 20) //Red/White/Black/Pale defense
	var/block_message = "You attempt to block the attack!" //So you can change the text for parrying with swords
	var/hit_message = "blocks the attack!"
	var/block_cooldown_message = "You reposition your shield"
	var/projectile_block_message = "You block the projectile!"
	var/block_sound = 'sound/weapons/ego/shield1.ogg'
	var/parry_timer
	var/projectile_timer

/obj/item/ego_weapon/shield/Initialize()
	. = ..()
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
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, ./proc/SlotChange)

//Allows the user to deflect projectiles for however long recovery time is set to on a hit
/obj/item/ego_weapon/shield/melee_attack_chain(mob/user, atom/target, params)
	..()
	if (!istype(user,/mob/living/carbon/human))
		return
	attacking = TRUE
	projectile_timer = addtimer(CALLBACK(src, .proc/DropStance), projectile_block_duration)

/obj/item/ego_weapon/shield/proc/DropStance()
	attacking = FALSE
	projectile_timer = null

/obj/item/ego_weapon/shield/proc/SlotChange(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(!ishuman(equipper))
		return FALSE
	var/mob/living/carbon/human/H = equipper
	if(source != src)
		return FALSE
	if(slot == ITEM_SLOT_HANDS)
		RegisterSignal(src, COMSIG_ITEM_ATTACK_ZONE, ./proc/WeaponCheck)
		return FALSE
	if(!H.physiology.armor.bomb)
		return FALSE
	H.physiology.armor = H.physiology.armor.modifyRating(red = -reductions[1], white = -reductions[2], black = -reductions[3], pale = -reductions[4], bomb = -1)
	UnregisterSignal(src, COMSIG_ITEM_ATTACK_ZONE)

/obj/item/ego_weapon/shield/proc/WeaponCheck(datum/source, mob/living/human/hit_guy, mob/living/hitter, location)
	SIGNAL_HANDLER
	if(source != src)
		return FALSE
	DisableBlock(hit_guy)

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
		block = TRUE
		block_success = FALSE
		shield_user.physiology.armor = shield_user.physiology.armor.modifyRating(red = reductions[1], white = reductions[2], black = reductions[3], pale = reductions[4], bomb = 1) //bomb defense must be over 0
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, .proc/AnnounceBlock)
		parry_timer = addtimer(CALLBACK(src, .proc/DisableBlock, shield_user), block_duration)
		to_chat(user,"<span class='userdanger'>[block_message]</span>")
		return TRUE

//Ends the block, causes you to take more damage for as long as debuff_duration if you did not block any damage
/obj/item/ego_weapon/shield/proc/DisableBlock(mob/living/carbon/human/user)
	user.physiology.armor = user.physiology.armor.modifyRating(red = -reductions[1], white = -reductions[2], black = -reductions[3], pale = -reductions[4], bomb = -1)
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	deltimer(parry_timer)
	parry_timer = addtimer(CALLBACK(src, .proc/BlockCooldown, user), block_cooldown)
	if (!block_success)
		BlockFail(user)

//Allows the user to block again when called
/obj/item/ego_weapon/shield/proc/BlockCooldown(mob/living/carbon/human/user)
	block = FALSE
	to_chat(user,"<span class='nicegreen'>[block_cooldown_message]</span>")

/obj/item/ego_weapon/shield/proc/BlockFail(mob/living/carbon/human/user)
	to_chat(user,"<span class='warning'>Your stance is widened.</span>")
	user.physiology.red_mod *= 1.2
	user.physiology.white_mod *= 1.2
	user.physiology.black_mod *= 1.2
	user.physiology.pale_mod *= 1.2
	deltimer(parry_timer)
	parry_timer = addtimer(CALLBACK(src, .proc/RemoveDebuff, user), debuff_duration)

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

	playsound(get_turf(src), block_sound, 50, 0, 7)
	source.visible_message("<span class='userdanger'>[source.real_name] [hit_message]</span>")

//Adds projectile deflection on attack cooldown, you can override and return 0 to prevent this from happening.
/obj/item/ego_weapon/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK && attacking)
		final_block_chance = 100
		owner.visible_message("<span class='nicegreen'>[owner.real_name] deflects the projectile!</span>", "<span class='userdanger'>[projectile_block_message]</span>")
		return ..()
	return ..()

//Examine text
/obj/item/ego_weapon/shield/examine(mob/user)
	. = ..()
	if(projectile_block_duration)
		. += "<span class='notice'>This weapon blocks ranged attacks while attacking and can block on command.</span>"
	else
		. += "<span class='notice'>This weapon can block on command.</span>"

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
