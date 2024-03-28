//Overarching charge stuff
/obj/item/ego_weapon/charge
	var/release_message = "You release your charge!"
	var/charge_effect = "cause a debug error."
	var/charge_cost = 1
	var/charge

/obj/item/ego_weapon/charge/examine(mob/user)
	. = ..()
	. += "Spend [charge]/[charge_cost] charge to [charge_effect]"

/obj/item/ego_weapon/charge/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if((target.stat == DEAD) || target.status_flags & GODMODE)//if the target is dead or godmode
		return FALSE
	if(charge<20)
		charge+=1

//Default is to just play a sound effect and such
/obj/item/ego_weapon/charge/proc/release_charge(mob/living/target, mob/living/user)
	sleep(2)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/justitia_effect(T)



//On attack subtype
/obj/item/ego_weapon/charge/onattack
	var/activated

/obj/item/ego_weapon/charge/onattack/attack_self(mob/user)
	..()
	if(charge>=charge_cost)
		to_chat(user, span_notice("You prepare to release your charge."))
		activated = TRUE
	else
		to_chat(user, span_notice("You don't have enough charge."))

/obj/item/ego_weapon/charge/onattack/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(activated)
		charge -= charge_cost
		to_chat(user, span_notice("[release_message]."))
		release_charge(target, user)
		activated = FALSE


//On use Subtype
/obj/item/ego_weapon/charge/onuse/attack_self(mob/user)
	. = ..()
	if(!.)
		return FALSE
	if(charge>=charge_cost)
		charge -= charge_cost
		to_chat(user, span_notice("[release_message]."))
		release_charge(user)
	else
		to_chat(user, span_notice("You don't have enough charge."))
