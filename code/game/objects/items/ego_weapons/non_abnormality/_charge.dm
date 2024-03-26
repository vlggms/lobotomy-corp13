/obj/item/ego_weapon/city/charge
	var/release_message = "You release your charge!"
	var/charge_effect = "spend charge."
	var/charge_cost = 1
	var/charge
	var/activated

/obj/item/ego_weapon/city/charge/examine(mob/user)
	. = ..()
	. += "Spend [charge]/[charge_cost] charge to [charge_effect]"

/obj/item/ego_weapon/city/charge/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if((target.stat == DEAD) || target.status_flags & GODMODE)
		return FALSE
	if(charge<20)
		charge+=1

/obj/item/ego_weapon/city/charge/proc/release_charge(mob/living/target, mob/living/user)
	charge -= charge_cost
	charge = round(max(charge, 0), 1)
	to_chat(user, span_notice("[release_message]."))
