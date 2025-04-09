/obj/item/ego_weapon/city/devyat_trunk
	name = "devyat courier trunk"
	desc = "A devyat association-issued delivery trunks."
	special = ""
	icon = 'icons/obj/clothing/ego_gear/devyat_icon.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/devyat_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/devyat_right.dmi'
	icon_state = "s_polu"
	inhand_icon_state = "s_polu"
	force = 27
	damtype = BLACK_DAMAGE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	attack_verb_continuous = list("slices", "gashes", "stabs")
	attack_verb_simple = list("slice", "gash", "stab")
	hitsound = 'sound/weapons/ego/devyat_slice.ogg'
	var/component_type = /datum/component/storage/concrete
	var/combat_mode = FALSE

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

//Storage Stuff
/obj/item/ego_weapon/city/devyat_trunk/get_dumping_location(obj/item/storage/source,mob/user)
	return src

/obj/item/ego_weapon/city/devyat_trunk/Initialize()
	. = ..()
	PopulateContents()

/obj/item/ego_weapon/city/devyat_trunk/ComponentInitialize()
	AddComponent(component_type)

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
	if(HAS_TRAIT(src, TRAIT_NODROP))
		var/datum/component/storage/CP = GetComponent(/datum/component/storage)
		CP.do_quick_empty()
		return TRUE
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
	update_icon_state()
	if(combat_mode)
		to_chat(user, span_nicegreen("Activating Strategic R&R mode..."))
		if(do_after(user, 50, user))
			end_combat()
			to_chat(user, "<span class='spider'><b>Combat mode deactivated!</b></span>")
		else
			to_chat(user, "<span class='spider'><b>Strategic R&R mode interrupted!</b></span>")
	else
		start_combat(user)

/obj/item/ego_weapon/city/devyat_trunk/attack(mob/living/target, mob/living/user)
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
		user.apply_damage(courier_trunk * overclock_mult, BLACK_DAMAGE)
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