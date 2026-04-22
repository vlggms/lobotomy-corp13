/obj/item/ego_weapon/city/devyat_trunk
	name = "devyat courier trunk"
	desc = "A devyat association-issued delivery trunks."
	special = "This weapon also functions as a backpack. \
	When you attack, you enter combat mode; and attacking in combat mode will deal increasing damage to both the user and the target. \
	It cannot be dropped while in combat mode. Combat mode can be turned off by using it in hand.\
	Alt click the trunk to lock or unlock it."
	worn_icon = 'icons/obj/clothing/ego_gear/devyat_armor.dmi'
	worn_icon_state = "s_polu"
	icon = 'icons/obj/clothing/ego_gear/devyat_icon.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/devyat_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/devyat_right.dmi'
	icon_state = "s_polu"
	inhand_icon_state = "s_polu"
	force = 14
	slot_flags = ITEM_SLOT_BACK
	damtype = BLACK_DAMAGE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	attack_verb_continuous = list("slices", "gashes", "stabs")
	attack_verb_simple = list("slice", "gash", "stab")
	hitsound = 'sound/weapons/ego/devyat_slice.ogg'
	var/component_type = /datum/component/storage/concrete
	var/combat_mode = FALSE
	var/can_attack = TRUE
	var/owner = null
	var/theif_damage = 20

	var/courier_trunk = 0
	var/passive_courier_trunk_add = 3
	var/attacking_courier_trunk_add = 2
	var/attack_courier_trunk_cooldown
	var/attack_courier_trunk_cooldown_time = 4 SECONDS

	var/tier0_icon = "s_polu"
	var/tier1_threshold = 10
	var/tier1_icon = "s_polu_knife"
	var/tier2_threshold = 20
	var/tier2_icon = "s_polu_gadget"
	var/tier3_threshold = 30

	var/tier1_damage_multiplier = 1.3
	var/tier2_damage_multiplier = 1.6
	var/tier3_damage_multiplier = 2

	var/tier1_vc_trigger = FALSE
	var/tier2_vc_trigger = FALSE
	var/tier3_vc_trigger = FALSE

	var/overclock = FALSE
	var/overclock_mult = 1
	var/RR_armor = 0.5

/obj/item/devyat_unlocker
	name = "devyat trunk unlocker"
	desc = "A small tool which is able to unlock DNA locked devyat trunks."
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "green"

/obj/item/devyat_unlocker/attack(mob/living/target, mob/living/user)
	. = ..()
	if(do_after(user, 50, user))
		if(ishuman(target))
			var/mob/living/carbon/human/possible_target = target
			for(var/obj/item/I in possible_target.get_all_gear())
				if(istype(I, /obj/item/ego_weapon/city/devyat_trunk))
					var/obj/item/ego_weapon/city/devyat_trunk/user_trunk = I
					user_trunk.owner = null
					to_chat(user, "<span class='spider'><b>You disable the DNA lock on [src].</b></span>")

//Storage Stuff
/obj/item/ego_weapon/city/devyat_trunk/equip_to_best_slot(mob/M, check_hand = TRUE)
	if(combat_mode)
		to_chat(M, span_warning("You are unable to equip the devyat bag during combat mode!"))
		return FALSE
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(combat_mode)
		to_chat(M, span_warning("You are unable to equip the devyat bag during combat mode!"))
		return FALSE
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/attack_hand(mob/user)
	if(owner && (user != owner))
		if(ishuman(user))
			var/mob/living/carbon/human/theif = user
			say("You are touching a devyat trunk without the correct access, please step away.")
			playsound(get_turf(src), 'sound/weapons/ego/devyat_overclock.ogg', 25, 0, 4)
			theif.deal_damage(theif_damage, BLACK_DAMAGE, flags = (DAMAGE_FORCED))
		return FALSE
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(owner && istype(I, /obj/item/devyat_unlocker))
		owner = null
		to_chat(user, "<span class='spider'><b>You disable the DNA lock on [src].</b></span>")

/obj/item/ego_weapon/city/devyat_trunk/AltClick(mob/user)
	if(!CanUseEgo(user))
		return
	if(owner)
		if(user == owner)
			owner = null
			to_chat(user, "<span class='spider'><b>You disable the DNA lock on [src].</b></span>")
	else
		owner = user
		to_chat(user, "<span class='spider'><b>[src] gathers your DNA, it is now DNA locked.</b></span>")
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/get_dumping_location(obj/item/storage/source,mob/user)
	return src

/obj/item/ego_weapon/city/devyat_trunk/Initialize()
	. = ..()
	PopulateContents()

/obj/item/ego_weapon/city/devyat_trunk/ComponentInitialize()
	AddComponent(component_type)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 60
	STR.max_items = 14

/obj/item/ego_weapon/city/devyat_trunk/AllowDrop()
	return FALSE

/obj/item/ego_weapon/city/devyat_trunk/contents_explosion(severity, target)
	for(var/thing in contents)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += thing
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += thing
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += thing

/obj/item/ego_weapon/city/devyat_trunk/canStrip(mob/who)
	. = ..()
	if(!.)
		return TRUE

/obj/item/ego_weapon/city/devyat_trunk/doStrip(mob/who)
	if(owner && (who != owner))
		if(ishuman(who))
			var/mob/living/carbon/human/theif = who
			say("You are touching a devyat trunk without the correct access, please step away.")
			playsound(get_turf(src), 'sound/weapons/ego/devyat_overclock.ogg', 25, 0, 4)
			theif.deal_damage(theif_damage, BLACK_DAMAGE, flags = (DAMAGE_FORCED))
		return FALSE
	return ..()

/obj/item/ego_weapon/city/devyat_trunk/proc/PopulateContents()

/obj/item/ego_weapon/city/devyat_trunk/proc/emptyStorage()
	var/datum/component/storage/ST = GetComponent(/datum/component/storage)
	ST.do_quick_empty()

/obj/item/ego_weapon/city/devyat_trunk/Destroy()
	for(var/obj/important_thing in contents)
		if(!(important_thing.resistance_flags & INDESTRUCTIBLE))
			continue
		important_thing.forceMove(drop_location())
	return ..()

//Combat Stuff
/obj/item/ego_weapon/city/devyat_trunk/examine(mob/user)
	. = ..()
	. += span_notice("This weapon currently has [courier_trunk] stacks of courier trunk.")

/obj/item/ego_weapon/city/devyat_trunk/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return
	update_icon_state()
	if(combat_mode)
		to_chat(user, span_nicegreen("Activating Strategic R&R mode..."))
		can_attack = FALSE
		user.physiology.red_mod -= RR_armor
		user.physiology.white_mod -= RR_armor
		user.physiology.black_mod -= RR_armor
		user.physiology.pale_mod -= RR_armor
		if(do_after(user, 50, user))
			end_combat()
			to_chat(user, "<span class='spider'><b>Combat mode deactivated!</b></span>")
		else
			to_chat(user, "<span class='spider'><b>Strategic R&R mode interrupted!</b></span>")
		user.physiology.red_mod += RR_armor
		user.physiology.white_mod += RR_armor
		user.physiology.black_mod += RR_armor
		user.physiology.pale_mod += RR_armor
		can_attack = TRUE
	else
		start_combat(user)

/obj/item/ego_weapon/city/devyat_trunk/attack(mob/living/target, mob/living/user)
	if(!can_attack)
		return FALSE
	. = ..()
	update_icon_state()
	update_icon()
	if(!combat_mode)
		start_combat(user)
	else
		if(attack_courier_trunk_cooldown < world.time - attack_courier_trunk_cooldown_time)
			attack_courier_trunk_cooldown = world.time
			gain_courier_trunk(attacking_courier_trunk_add, user)

/obj/item/ego_weapon/city/devyat_trunk/proc/end_combat()
	combat_mode = FALSE
	overclock = FALSE
	tier1_vc_trigger = FALSE
	tier2_vc_trigger = FALSE
	tier3_vc_trigger = FALSE
	courier_trunk = 0
	force_multiplier = 1
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	icon_state = tier0_icon
	inhand_icon_state = tier0_icon
	update_icon_state()

/obj/item/ego_weapon/city/devyat_trunk/proc/start_combat(mob/living/user)
	combat_mode = TRUE
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	addtimer(CALLBACK(src, PROC_REF(passive_courier_trunk), user), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(entering_combat), user), 1)
	icon_state = tier1_icon
	inhand_icon_state = tier1_icon
	to_chat(user, "<span class='spider'><b>Combat mode activated!</b></span>")
	update_icon_state()

/obj/item/ego_weapon/city/devyat_trunk/proc/passive_courier_trunk(mob/living/user)
	if(combat_mode)
		gain_courier_trunk(passive_courier_trunk_add, user)
		if(overclock)
			playsound(get_turf(user), 'sound/weapons/ego/devyat_alarm.ogg', 25, 0, 4)
		addtimer(CALLBACK(src, PROC_REF(passive_courier_trunk), user), 5 SECONDS)

/obj/item/ego_weapon/city/devyat_trunk/proc/gain_courier_trunk(amount, mob/living/user)
	if(overclock)
		user.deal_damage(courier_trunk * overclock_mult, BLACK_DAMAGE, flags = (DAMAGE_FORCED))
		if(user.stat == DEAD)
			playsound(get_turf(user), 'sound/weapons/ego/devyat_overclock_death.ogg', 50, 0, 4)
			end_combat()
			return
		else
			playsound(get_turf(user), 'sound/weapons/ego/devyat_overclock.ogg', 25, 0, 4)

	courier_trunk += amount
	to_chat(user, span_nicegreen("[src] gains [amount] stacks of courier trunk!"))
	if(courier_trunk >= tier3_threshold)
		force_multiplier = tier3_damage_multiplier
		if(!tier3_vc_trigger)
			tier3_vc_trigger = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_up.ogg', 25, 0, 4)
			addtimer(CALLBACK(src, PROC_REF(entering_stage_3), user), 1)

		if(!overclock)
			overclock = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_alarm.ogg', 25, 0, 4)

	else if(courier_trunk >= tier2_threshold)
		force_multiplier = tier2_damage_multiplier
		icon_state = tier2_icon
		inhand_icon_state = tier2_icon
		update_icon_state()
		if(!tier2_vc_trigger)
			tier2_vc_trigger = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_up.ogg', 25, 0, 4)
			addtimer(CALLBACK(src, PROC_REF(entering_stage_2), user), 1)

	else if(courier_trunk >= tier1_threshold)
		force_multiplier = tier1_damage_multiplier
		if(!tier1_vc_trigger)
			tier1_vc_trigger = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_up.ogg', 25, 0, 4)
			addtimer(CALLBACK(src, PROC_REF(entering_stage_1), user), 1)

	else
		force_multiplier = 1
		icon_state = tier1_icon
		inhand_icon_state = tier1_icon
		update_icon_state()

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_combat(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_combat_start.ogg', 50, 0, 4)
	say("Hostile forces detected.")
	sleep(20)
	say("Activating Poludnitsa high-power delivery mode maneuvers.")

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_stage_1(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_1.ogg', 50, 0, 4)
	say("Phase 1. Delivery assistant and control sequence initiated.")
	sleep(30)
	say("Calmly forge a path.")

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_stage_2(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_2.ogg', 50, 0, 4)
	say("Phase 2. Delivery carrier output increased.")
	sleep(30)
	say("Quick pioneering is recommended.")

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_stage_3(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_3.ogg', 50, 0, 4)
	say("Phase 3, Warning. Time-over delivery acceleration entering final phase.")
	sleep(30)
	say("Futher delays do not guarantee personal safety.")

/obj/item/ego_weapon/city/devyat_trunk/demo
	name = "heavy devyat courier trunk"
	desc = "A heavier devyat association-issued delivery trunks."
	worn_icon_state = "b_polu"
	icon_state = "b_polu"
	inhand_icon_state = "b_polu"
	force = 21
	slot_flags = ITEM_SLOT_BACK
	attack_speed = 1.5
	attack_verb_continuous = list("bludgeons", "smacks")
	attack_verb_simple = list("bludgeon", "smack")
	hitsound = 'sound/weapons/ego/devyat_slam.ogg'
	tier0_icon = "b_polu"
	tier1_icon = "b_polu_demo"
	tier2_icon = "b_polu_hammer"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
