
//EGO Lance Subtype Code
/obj/item/ego_weapon/lance
// Immutable vars - You will never need to modify these.
	var/initial_dir
	var/mob/current_holder
	var/couch_cooldown = 0
	var/charge_speed = 0
	var/raised = TRUE
	var/required_movement_time = 2 SECONDS
	swingstyle = WEAPONSWING_THRUST
// Mutable vars - Play around with these for funky weapons
	var/list/default_attack_verbs = list("bludgeons", "whacks")
	var/list/couch_attack_verbs = list("impales", "stabs")
	var/couch_cooldown_time = 5 SECONDS //Cooldown between charges
	var/force_cap = 0 //highest damage a lance deals on charge; should be set manually.
	var/force_per_tile = 3
	var/charge_speed_cap = 4 //charge speed multiplier cap
	var/speed_per_tile = 0.2
	var/bump_threshold = 0.5
	var/pierce_threshold = 1 //minimum charge speed for multiple hits
	var/pierce_speed_cost = 0.8
	var/pierce_force_cost = 12

//This is the code that lets you press the button to charge.
/obj/item/ego_weapon/lance/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!raised)
		RaiseLance(user)
	else
		if(world.time > couch_cooldown + couch_cooldown_time)
			LowerLance(user)
		else
			to_chat(user, span_warning("You are not ready to couch the [src] yet!"))

//Equipped setup
/obj/item/ego_weapon/lance/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user
	RaiseLance(current_holder)
	RegisterSignal(current_holder, COMSIG_MOVABLE_BUMP, PROC_REF(UserBump), override = TRUE)
	RegisterSignal(current_holder, COMSIG_MOVABLE_MOVED, PROC_REF(UserMoved))
	if(!force_cap)
		force_cap = (initial(force) * 2)

//Destroy setup
/obj/item/ego_weapon/lance/Destroy(force)
	dropped(current_holder)
	return ..()

//Dropped setup
/obj/item/ego_weapon/lance/dropped(mob/user)
	. = ..()
	if(!current_holder)
		return
	RaiseLance(current_holder)
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(current_holder, COMSIG_MOVABLE_BUMP)
	current_holder = null

//Resets force when attacking outside of a charge
/obj/item/ego_weapon/lance/attack(mob/living/M, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!charge_speed || force < initial(force))
		force = initial(force)
	..()

//The player has moved, are they moving in a straight line? etc
/obj/item/ego_weapon/lance/proc/UserMoved(mob/user)
	SIGNAL_HANDLER
	if(raised)
		return
	if(user.dir != initial_dir || src != user.get_active_held_item())
		RaiseLance(user)
		to_chat(user, span_warning("You lose control of [src]!"))
		return
	if(force < force_cap)
		force += force_per_tile
	if(charge_speed > -(charge_speed_cap))
		charge_speed -= speed_per_tile
		user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/charge, multiplicative_slowdown = charge_speed)
	if(user.pulling)
		RaiseLance(user) //no stupid super speed dragging
		to_chat(user, span_warning("You can't maintain your momentum while pulling something!"))
	addtimer(CALLBACK(src, PROC_REF(MoveCheck), user, user.loc), required_movement_time)

//The player is readying a charge. CHARGE!!!
/obj/item/ego_weapon/lance/proc/LowerLance(mob/user)
	initial_dir = user.dir
	raised = FALSE
	attack_verb_continuous = couch_attack_verbs
	attack_verb_simple = couch_attack_verbs
	update_icon_state()
	user.update_inv_hands()
	couch_cooldown = world.time + couch_cooldown_time
	user.add_movespeed_modifier(/datum/movespeed_modifier/charge)

	//If you lower your lance, you lose your stun
	stuntime = 0

//The player has stopped a charge for some reason or another
/obj/item/ego_weapon/lance/proc/RaiseLance(mob/user)
	raised = TRUE
	charge_speed = 0
	force = initial(force)
	attack_verb_continuous = default_attack_verbs
	attack_verb_simple = default_attack_verbs
	update_icon_state()
	user.update_inv_hands()
	user.remove_movespeed_modifier(/datum/movespeed_modifier/charge)

	//Raise it to give stun again
	stuntime = initial(stuntime)

//Icon stuff
/obj/item/ego_weapon/lance/update_icon_state()
	icon_state = inhand_icon_state = "[initial(icon_state)]" + "[raised ? "" : "_lowered"]"

//We bumped into something, run some checks...
/obj/item/ego_weapon/lance/proc/UserBump(mob/living/carbon/human/user, atom/A)
	SIGNAL_HANDLER
	if(charge_speed > -(bump_threshold))
		RaiseLance(user)
		return
	if(istype(A, /mob/living/simple_animal/projectile_blocker_dummy))
		var/mob/living/simple_animal/projectile_blocker_dummy/pbd = A
		A = pbd.parent
	if(isliving(A))
		if(ishuman(A) && user.faction_check_mob(A))
			var/mob/living/carbon/human/H = A
			H.Knockdown(4 SECONDS) //we dont want humans getting skewered for a million damage
			to_chat(user, span_warning("You crash into [H]!"))
			playsound(loc, 'sound/weapons/genhit1.ogg', 50, TRUE, -1)
			if(charge_speed > -(pierce_threshold))
				user.Knockdown(2 SECONDS)
				return
		else
			A.attackby(src,user)
			to_chat(user, span_warning("You successfully impale [A]!"))

		if(charge_speed < -(pierce_threshold)) //you can keep going!
			charge_speed += pierce_speed_cost
			force -= pierce_force_cost
			return
	else
		to_chat(user, span_warning("You lose control of [src]!"))
		user.Knockdown(4 SECONDS) //crash if you bump into a wall too fast
		playsound(loc, 'sound/weapons/genhit1.ogg', 50, TRUE, -1)
	RaiseLance(user)

//Checks every few seconds, if you stand still too long it'll raise the lace.
/obj/item/ego_weapon/lance/proc/MoveCheck(mob/user, location)
	if(raised)
		return
	if(!user.loc.AllowClick() || user.loc == location)
		to_chat(user, span_warning("Your momentum runs out."))
		RaiseLance(user)
		return

//Examine text
/obj/item/ego_weapon/lance/examine(mob/user)
	. = ..()
	. += span_notice("This weapon can be used to perform a running charge by using it in hand. Charge into an enemy at high speeds for massive damage!")

/datum/movespeed_modifier/charge
	multiplicative_slowdown = 0
	variable = TRUE
