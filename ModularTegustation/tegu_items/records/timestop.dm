//Golden Watch
//Casts Timestop for 10 seconds
//Making everything that passes into the area freeze in place untill the 10 seconds are up.
/obj/item/records/timestop
	name = "records golden watch"
	desc = "A golden watch the records officer can use to stop time temporarily."
	icon_state = "watch_gold"

/obj/item/records/timestop/watch_action(mob/user)
	//First we spawn a timestop affect, freezing the area around are user, for 10 seconds
	new /obj/effect/timestop(get_turf(user), 3, 110, list(user))
	//Next we move back to are parrent, so that we give are stopwatch cooldowns.
	..()

