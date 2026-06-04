// Records watch base item
/obj/item/records
	name = "uncaliberated watch"
	desc = "A watch that is not meant to exist. Talk to an admin and report how you got this!"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "watch_template"
	w_class = WEIGHT_CLASS_SMALL
	var/usable = TRUE
	var/watch_cooldown_time = 10 MINUTES
	var/next_use_time
	maptext = ""
	maptext_x = 8
	maptext_y = 0
	maptext_width = 24
	maptext_height = 12

/obj/item/records/attack_self(mob/user)
	if(WatchChecks(user))
		WatchAction(user)

/obj/item/records/examine(mob/user)
	. = ..()
	if(usable)
		. += "[src.name] is ready to be used."
	else
		. += "[src.name] can not currently be used."

//This item type should only be usable by the records officer.
/obj/item/records/proc/WatchChecks(mob/user)
	if(user?.mind?.assigned_role != "Records Officer")
		to_chat(user, span_warning("You cannot use this!"))
		return FALSE
	if(!usable)
		to_chat(user, span_warning("It hasn't recharged yet!"))
		return FALSE
	return TRUE

//Base proc for watch actions, this is also were we give these items a cooldown
/obj/item/records/proc/WatchAction(mob/user)
	if(watch_cooldown_time)
		usable = FALSE
		START_PROCESSING(SSfastprocess, src)
		addtimer(CALLBACK(src, PROC_REF(Reset)), watch_cooldown_time)
		next_use_time = watch_cooldown_time + world.time
		color = COLOR_GRAY
		alpha = 150

/obj/item/records/proc/Reset()
	usable = TRUE
	audible_message(span_notice("[src] is ready to use!"))
	playsound(get_turf(src), 'sound/creatures/lc13/clockhead/happy.ogg', 50, TRUE)
	color = null
	alpha = 255
	STOP_PROCESSING(SSfastprocess, src)
	maptext = ""

/obj/item/records/process()
	var/timeleft = max(next_use_time - world.time, 0)
	maptext = MAPTEXT("<b>[round(timeleft/10, 1)]</b>")
