//EGO shield subtype code

/*
	Regular Shields
	RISK LEVEL    |    ARMOR TOTAL    |    ARMOR CAP     |    PALE ARMOR CAP     |
	ZAYIN         |        60         |        30        |         10            |
	TETH          |        90         |        50        |         20            |
	HE            |        120        |        70        |         30            |
	WAW           |        150        |        80        |         40            |
	ALEPH         |        240        |        90        |         60            |

	Hybrid-Shields
	RISK LEVEL    |    ARMOR TOTAL    |    ARMOR CAP     |    PALE ARMOR CAP     |
	ZAYIN         |        40         |        20        |         10            |
	TETH          |        60         |        30        |         20            |
	HE            |        80         |        40        |         30            |
	WAW           |        100        |        50        |         40            |
	ALEPH         |        150        |        60        |         60            |

	Hybrid Shields are weapons that can parry and typically have a 1 second duration and a projectile block duration matching their attack_speed.
	Regular Shields have very slow (3) attack speed and slow (speed 2) force. So for a teth, 3 speed and 40 force.

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
	var/block_sound_volume = 50
	var/projectile_timer
	var/parry_timer

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

//Allows the user to deflect projectiles for however long recovery time is set to on a hit
/obj/item/ego_weapon/shield/melee_attack_chain(mob/user, atom/target, params)
	..()
	if (!istype(user,/mob/living/carbon/human))
		return
	attacking = TRUE
	if(cleaning)
		DropStance()
	else
		projectile_timer = addtimer(CALLBACK(src, PROC_REF(DropStance)), projectile_block_duration, TIMER_OVERRIDE & TIMER_UNIQUE & TIMER_STOPPABLE)

/obj/item/ego_weapon/shield/proc/DropStance()
	attacking = FALSE
	projectile_timer = null

//This code is what allows the user to block
/obj/item/ego_weapon/shield/attack_self(mob/user)
	if (!ishuman(user))
		return FALSE

	if (block == 0)
		var/mob/living/carbon/human/shield_user = user
		if(!CanUseEgo(shield_user))
			return FALSE
		if(shield_user.physiology.armor.bomb) //"We have NOTHING that should be modifying this, so I'm using it as an existant parry checker." - Ancientcoders
			to_chat(shield_user,span_warning("You're still off-balance!"))
			return FALSE
		for(var/obj/machinery/computer/abnormality/AC in range(1, shield_user))
			if(AC.datum_reference.working) // No blocking during work.
				to_chat(shield_user,span_notice("You cannot defend yourself from responsibility!"))
				return FALSE
		block = TRUE
		block_success = FALSE
		shield_user.physiology.armor = shield_user.physiology.armor.modifyRating(bomb = 1) //bomb defense must be over 0
		shield_user.physiology.red_mod *= max(0.001, (1 - ((reductions[1]) / 100)))
		shield_user.physiology.white_mod *= max(0.001, (1 - ((reductions[2]) / 100)))
		shield_user.physiology.black_mod *= max(0.001, (1 - ((reductions[3]) / 100)))
		shield_user.physiology.pale_mod *= max(0.001, (1 - ((reductions[4]) / 100)))
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, PROC_REF(AnnounceBlock))
		if(cleaning)
			DisableBlock(shield_user)
		else
			parry_timer = addtimer(CALLBACK(src, PROC_REF(DisableBlock), shield_user), block_duration, TIMER_STOPPABLE)
		to_chat(user, span_userdanger("[block_message]"))
		return TRUE

//Ends the block, causes you to take more damage for as long as debuff_duration if you did not block any damage
/obj/item/ego_weapon/shield/proc/DisableBlock(mob/living/carbon/human/user)
	user.physiology.armor = user.physiology.armor.modifyRating(bomb = -1)
	user.physiology.red_mod /= max(0.001, (1 - ((reductions[1]) / 100)))
	user.physiology.white_mod /= max(0.001, (1 - ((reductions[2]) / 100)))
	user.physiology.black_mod /= max(0.001, (1 - ((reductions[3]) / 100)))
	user.physiology.pale_mod /= max(0.001, (1 - ((reductions[4]) / 100)))

	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	deltimer(parry_timer)
	if(cleaning)
		BlockCooldown(user)
	else
		parry_timer = addtimer(CALLBACK(src, PROC_REF(BlockCooldown), user), block_cooldown, TIMER_STOPPABLE)
	if (!block_success)
		BlockFail(user)

//Allows the user to block again when called
/obj/item/ego_weapon/shield/proc/BlockCooldown(mob/living/carbon/human/user)
	block = FALSE
	if(user.is_holding(src))
		to_chat(user,span_nicegreen("[block_cooldown_message]"))

/obj/item/ego_weapon/shield/proc/BlockFail(mob/living/carbon/human/user)
	to_chat(user,span_warning("Your stance is widened."))
	user.physiology.red_mod *= 1.2
	user.physiology.white_mod *= 1.2
	user.physiology.black_mod *= 1.2
	user.physiology.pale_mod *= 1.2
	if(cleaning)
		RemoveDebuff(user)
	else
		addtimer(CALLBACK(src, PROC_REF(RemoveDebuff), user), debuff_duration)

/obj/item/ego_weapon/shield/proc/RemoveDebuff(mob/living/carbon/human/user)
	to_chat(user,span_nicegreen("You recollect your stance."))
	user.physiology.red_mod /= 1.2
	user.physiology.white_mod /= 1.2
	user.physiology.black_mod /= 1.2
	user.physiology.pale_mod /= 1.2

//Handles block messages and sound effect
/obj/item/ego_weapon/shield/proc/AnnounceBlock(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(!ishuman(source))
		return FALSE
	var/mob/living/carbon/human/H = source
	if(!H.is_holding(src))
		DisableBlock(H)
		return
	block_success = TRUE

	playsound(get_turf(src), block_sound, block_sound_volume, 0, 7)
	H.visible_message(span_userdanger("[H.real_name] [hit_message]"))

//Adds projectile deflection on attack cooldown, you can override and return 0 to prevent this from happening.
/obj/item/ego_weapon/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK && attacking)
		final_block_chance = 100
		owner.visible_message(span_nicegreen("[owner.real_name] deflects the projectile!"), span_userdanger("[projectile_block_message]"))
		return ..()
	return ..()

/obj/item/ego_weapon/shield/CleanUp()
	. = ..()
	for(var/datum/timedevent/T in active_timers)
		var/datum/callback/TC = T.callBack
		TC.InvokeAsync()
		T.spent = world.time
		T.bucketEject()
		qdel(T)
	return

//Examine text
/obj/item/ego_weapon/shield/examine(mob/user)
	. = ..()
	if(projectile_block_duration)
		. += span_notice("This weapon blocks ranged attacks while attacking and can block on command.")
	else
		. += span_notice("This weapon can block on command.")

	if(LAZYLEN(resistances_list))
		. += span_notice("It has a <a href='?src=[REF(src)];list_resistances=1'>tag</a> listing its protection classes.")

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
