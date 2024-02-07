/obj/effect/proc_holder/spell/aoe_turf/knock
	name = "Knock"
	desc = "This spell opens nearby doors and closets."

	school = SCHOOL_TRANSMUTATION
	charge_max = 100
	clothes_req = FALSE
	invocation = "AULIE OXIN FIERA"
	invocation_type = INVOCATION_WHISPER
	range = 3
	cooldown_min = 20 //20 deciseconds reduction per rank

	action_icon_state = "knock"
	var/open_sound = 'sound/magic/knock.ogg'

/obj/effect/proc_holder/spell/aoe_turf/knock/cast(list/targets,mob/user = usr)
	if(open_sound)
		SEND_SOUND(user, sound('sound/magic/knock.ogg'))
	for(var/turf/T in targets)
		for(var/obj/machinery/door/door in T.contents)
			INVOKE_ASYNC(src, PROC_REF(open_door), door)
		for(var/obj/structure/closet/C in T.contents)
			INVOKE_ASYNC(src, PROC_REF(open_closet), C)

/obj/effect/proc_holder/spell/aoe_turf/knock/proc/open_door(obj/machinery/door/door)
	if(istype(door, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = door
		A.locked = FALSE
	door.open()

/obj/effect/proc_holder/spell/aoe_turf/knock/proc/open_closet(obj/structure/closet/C)
	C.locked = FALSE
	C.open()

/obj/effect/proc_holder/spell/aoe_turf/knock/arbiter
	invocation_type = "none"
	charge_max = 50
	sound = 'sound/magic/arbiter/knock.ogg'
	open_sound = null
