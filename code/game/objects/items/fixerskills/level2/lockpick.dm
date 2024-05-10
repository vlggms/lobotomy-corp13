//Lockpick
/obj/item/book/granter/action/skill/lockpick
	granted_action = /datum/action/cooldown/lockpick
	actionname = "Lockpick"
	name = "Level 2 Skill: Lockpick"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/lockpick
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "lockpick"
	name = "Lockpick"
	cooldown_time = 600

/datum/action/cooldown/lockpick/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Just open the door
	for(var/obj/machinery/door/door in view(1, get_turf(src)))
		if(istype(door, /obj/machinery/door/poddoor))
			continue
		if(istype(door, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/A = door
			A.locked = FALSE
		door.open()

	StartCooldown()

