/**
 * This file contains the variables and procs used in charge-type mechanics
 */
/obj/item/ego_weapon
	/// Does this weapon support charge mechanics?
	var/charge = FALSE
	/// Is this weapon's special attack on attacking a target or using the weapon itself?
	/// avaible flags: ABILITY_ON_ATTACK || ABILITY_ON_ACTIVATION || ABILITY_UNIQUE
	var/ability_type = ABILITY_ON_ATTACK

	/// do we gain charge from successfully hitting a non-dead/godmode enemy?
	var/attack_charge_gain = TRUE

	/// The current amount of charge we are storing.
	var/charge_amount = 0
	/// How much charge does our special charge ability cost?
	var/charge_cost = 1
	/// How much charge can we store at our maximum?
	var/charge_cap = 20

	/// Are we currently using our charge ability?
	var/currently_charging = FALSE
	/// Do we allow our charge ability to be cancelled
	var/allow_ability_cancel = TRUE
	/// What does this weapon do when using its special ability? Shows up on examine.
	var/charge_effect

	/// The message given if you successfully activate charge
	var/successfull_activation = "Your weapon starts resonating with power, now its the time to strike!"
	/// The message given upon cancelling your ability on an ATTACK type charge weapon
	var/cancel_activation = "You manage to cancel your unique attack."
	/// Message given to everyone around you upon a successfull charge activation, if set
	var/visible_activation
	/// The message given if you fail to activate charge
	var/failed_activation = "you try to charge your special attack... but your weapon does not respond!"

/obj/item/ego_weapon/Initialize(mapload)
	. = ..()
	if(charge_cap < charge_cost)
		charge_cap = charge_cost * 2 // lets not ruin the players experience, shall we fellow coders?
		CRASH("[src] charge ability has an ability that costs more than its default charge cap!")

/obj/item/ego_weapon/attack_self(mob/living/user)
	if(!charge || !CanUseEgo(user))
		return ..()

	if(currently_charging && allow_ability_cancel)
		CancelCharge(user)

	if(charge_amount >= charge_cost)
		charge_amount -= charge_cost
		to_chat(user, span_notice(successfull_activation))
		switch(ability_type)
			if(ABILITY_ON_ATTACK, ABILITY_UNIQUE)
				currently_charging = TRUE

			if(ABILITY_ON_ACTIVATION)
				ChargeAttack(user = user)

		if(visible_activation) // oh shit oh fuck
			visible_message(span_danger(visible_activation))

	else
		to_chat(user, span_warning(failed_activation))

	return ..()

/obj/item/ego_weapon/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	if(currently_charging && ability_type == ABILITY_ON_ATTACK)
		ChargeAttack(target, user)

/obj/item/ego_weapon/examine(mob/user)
	. = ..()
	if(charge)
		. += span_notice("This weapon has charge mechanics[attack_charge_gain ? " and gains a charge upon every hit" : ""].")
		. += span_notice("This weapon currently has [charge_amount] charge out of [charge_cap] maximum charge.")
		. += span_notice("You can activate this weapons special ability with [charge_cost] charge by clicking on it.")
		if(charge_effect)
			. += span_notice("ability: [charge_effect]")

/obj/item/ego_weapon/proc/HandleCharge(added_charge, mob/target)
	if(target)
		if((target.stat == DEAD) || target.status_flags & GODMODE) // lets not give them charge for beating up contained abnormalities
			return FALSE

	if(charge_amount < 0) // ???
		charge_amount = initial(charge_amount)
		CRASH("[src] has somehow aquired a negative charge amount, automatically reset it to the initial charge amount")

	if(charge_amount < charge_cap)
		charge_amount += added_charge
		new /obj/effect/temp_visual/healing/charge(get_turf(src))

/// Lets people refund their charge if the allow_ability_cancel var is set to TRUE
/obj/item/ego_weapon/proc/CancelCharge(mob/user)
	to_chat(user, span_notice(cancel_activation))
	currently_charging = FALSE
	if((charge_cost + charge_amount) <= charge_cap) // lets only refund them to their maximum
		charge_amount += charge_cost
	else
		charge_amount = charge_cap

/// An effect that triggers if you use the charge ability and the ability_type is ABILITY_ON_ACTIVATION
/// Default is to just play a sound effect and such
/obj/item/ego_weapon/proc/ChargeAttack(mob/living/target, mob/living/user)
	sleep(0.2 SECONDS)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	if(ability_type == ABILITY_ON_ATTACK)
		currently_charging = FALSE
		new /obj/effect/temp_visual/justitia_effect(get_turf(target))
	else
		new /obj/effect/temp_visual/justitia_effect(get_turf(src))
