
//EGO Lance Subtype Code
/obj/item/ego_weapon/lance
// Immutable vars - You will never need to modify these.
	var/initial_dir
	var/mob/current_holder
	var/couch_cooldown = 0
	var/charge_speed = 0
	var/raised = TRUE
	var/required_movement_time = 2 SECONDS
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

/obj/item/ego_weapon/lance/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!raised)
		RaiseLance(user)
	else
		if(world.time > couch_cooldown + couch_cooldown_time)
			LowerLance(user)
		else
			to_chat(user, "<span class='warning'>You are not ready to couch the [src] yet!</span>")

/obj/item/ego_weapon/lance/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user
	RaiseLance(user)
	RegisterSignal(current_holder, COMSIG_MOVABLE_BUMP, .proc/UserBump)
	RegisterSignal(current_holder, COMSIG_MOVABLE_MOVED, .proc/UserMoved)
	if(!force_cap)
		force_cap = (initial(force) * 2)

/obj/item/ego_weapon/lance/Destroy(mob/user)
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(current_holder, COMSIG_MOVABLE_BUMP)
	RaiseLance(user)
	current_holder = null
	return ..()

/obj/item/ego_weapon/lance/dropped(mob/user)
	. = ..()
	RaiseLance(user)
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(current_holder, COMSIG_MOVABLE_BUMP)
	current_holder = null

/obj/item/ego_weapon/lance/attack(mob/living/M, mob/living/carbon/human/user) //reset force when attacking outside of a charge
	if(!CanUseEgo(user))
		return
	if(!charge_speed || force < initial(force))
		force = initial(force)
	..()

/obj/item/ego_weapon/lance/proc/UserMoved(mob/user)
	SIGNAL_HANDLER
	if(raised)
		return
	if(user.dir != initial_dir || src != user.get_active_held_item())
		RaiseLance(user)
		to_chat(user, "<span class='warning'>You lose control of [src]!</span>")
		return
	if(force < force_cap)
		force += force_per_tile
	if(charge_speed > -(charge_speed_cap))
		charge_speed -= speed_per_tile
		user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/charge, multiplicative_slowdown = charge_speed)
	if(user.pulling)
		RaiseLance(user) //no stupid super speed dragging
		to_chat(user, "<span class='warning'>You can't maintain your momentum while pulling something!</span>")
	addtimer(CALLBACK(src, .proc/MoveCheck, user, user.loc), required_movement_time)

/obj/item/ego_weapon/lance/proc/LowerLance(mob/user) //CHARGE!
	initial_dir = user.dir
	raised = FALSE
	attack_verb_continuous = couch_attack_verbs
	attack_verb_simple = couch_attack_verbs
	update_icon_state()
	user.update_inv_hands()
	couch_cooldown = world.time + couch_cooldown_time
	user.add_movespeed_modifier(/datum/movespeed_modifier/charge)

/obj/item/ego_weapon/lance/proc/RaiseLance(mob/user)
	raised = TRUE
	charge_speed = 0
	force = initial(force)
	attack_verb_continuous = default_attack_verbs
	attack_verb_simple = default_attack_verbs
	update_icon_state()
	user.update_inv_hands()
	user.remove_movespeed_modifier(/datum/movespeed_modifier/charge)

/obj/item/ego_weapon/lance/update_icon_state()
	icon_state = inhand_icon_state = "[initial(icon_state)]" + "[raised ? "" : "_lowered"]"

/obj/item/ego_weapon/lance/proc/UserBump(mob/living/carbon/human/user, atom/A)
	SIGNAL_HANDLER
	if(charge_speed > -(bump_threshold))
		RaiseLance(user)
		return
	if (isliving(A))
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			H.Knockdown(4 SECONDS) //we dont want humans getting skewerd for a million damage
		A.attackby(src,user)
		to_chat(user, "<span class='warning'>You successfully impale [A]!</span>")
		if(charge_speed < -(pierce_threshold)) //you can keep going!
			charge_speed += pierce_speed_cost
			force -= pierce_force_cost
			return
	else
		to_chat(user, "<span class='warning'>You lose control of [src]!</span>")
		user.Knockdown(4 SECONDS) //crash if you bump into a wall too fast
		playsound(loc, 'sound/weapons/genhit1.ogg', 50, TRUE, -1)
	RaiseLance(user)

/obj/item/ego_weapon/lance/proc/MoveCheck(mob/user, location)
	if(raised)
		return
	if(!user.loc.AllowClick() || user.loc == location)
		to_chat(user, "<span class='warning'>Your momentum runs out.</span>")
		RaiseLance(user)
		return

/datum/movespeed_modifier/charge
	multiplicative_slowdown = 0
	variable = TRUE
