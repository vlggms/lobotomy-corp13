
//EGO Wield Subtype Code
/obj/item/ego_weapon/wield
// Immutable vars - You will never need to modify these
	var/wielded = FALSE
	//basic stat changes
	var/wielded_attack_speed = 1
	var/wielded_force = 1
	var/wielded_reach = 1
	//slow down stuff
	var/should_slow = FALSE
	var/wielded_slow_down = 1.5
	var/current_slow_down = 0
	var/wielded_anti_justice_multiplier = 1
	//holder stuff and unwield stuff
	var/mob/current_holder
	var/two_hands_required = FALSE
	var/should_unwield_cooldown = FALSE
	var/unwield_time = 3 SECONDS
	var/unwield_cooldown
	//text
	var/wield_stats = "This weapon can be two-handed."
	var/forced_wield_stats = "This weapon requires both hands to be wielded."
	var/wield_special = null

/obj/item/ego_weapon/wield/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(OnWield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/ego_weapon/wield/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=initial(force), force_wielded=wielded_force, require_twohands=two_hands_required)

/obj/item/ego_weapon/wield/examine(mob/user)
	. = ..()
	if(two_hands_required)
		. += span_notice(forced_wield_stats)
	else
		. += span_notice(wield_stats)
	if(wield_special)
		. += span_notice(wield_special)

//Equipped setup
/obj/item/ego_weapon/wield/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user
	RegisterSignal(current_holder, COMSIG_MOVABLE_MOVED, PROC_REF(UserMoved))

//Destroy setup
/obj/item/ego_weapon/wield/Destroy(force)
	dropped(current_holder)
	return ..()

//Dropped setup
/obj/item/ego_weapon/wield/dropped(mob/user)
	. = ..()
	if(!current_holder)
		return
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	current_slow_down = 0
	current_holder.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/wield, multiplicative_slowdown = 0)
	on_unwield(src,current_holder)
	current_holder = null

/obj/item/ego_weapon/wield/attack_self(mob/user)
	if(two_hands_required)
		return
	if(should_unwield_cooldown && unwield_cooldown > world.time)
		to_chat(user, span_userdanger("You wielded [src] too recently!"))
		return
	. = ..()

/obj/item/ego_weapon/wield/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	if(wielded)
		DualWieldAttack(target, user)

/obj/item/ego_weapon/wield/proc/DualWieldAttack(mob/living/target, mob/living/user)

/obj/item/ego_weapon/wield/proc/UserMoved(mob/user)
	SIGNAL_HANDLER
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/wield, multiplicative_slowdown = current_slow_down)

/obj/item/ego_weapon/wield/proc/OnWield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = TRUE
	attack_speed = wielded_attack_speed
	reach = wielded_reach
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	if(should_slow)
		current_slow_down = wielded_slow_down + (wielded_anti_justice_multiplier * userjust/JUSTICE_MOVESPEED_DIVISER)//cuts justice speed scaling also
	if(should_unwield_cooldown)
		unwield_cooldown = unwield_time + world.time

/obj/item/ego_weapon/wield/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = FALSE
	attack_speed = initial(attack_speed)
	reach = initial(reach)
	current_slow_down = 0

/datum/movespeed_modifier/wield

	multiplicative_slowdown = 0
	variable = TRUE
