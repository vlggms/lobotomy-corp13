//RO meltdown watch
//Gives by default 5 additional minutes before the next abnormality spawns
/obj/item/records/abnodelay
	name = "records bronze watch"
	desc = "A bronze watch the records officer can use to increase the time it takes for the next abnormality to arrive."
	icon_state = "watch_bronze"
	//Its cooldown is 30 minutes
	records_cooldown_timer = 30 MINUTES
	//How much time we offset the next abnormality spawn
	var/next_abno_spawn_offset = 5 MINUTES

/obj/item/records/abnodelay/watch_action(mob/user)
	//We succesfully used are watch, give the player feedback and some fluff
	to_chat(user, span_notice("You check your watch. It's not time for the next abnormality to arrive yet."))
	//We grab are SubSystem for abnormality spawning and go to the spawn timer, and add the offset time to it directly.
	SSabnormality_queue.next_abno_spawn += next_abno_spawn_offset
	//Next we move back to are parrent, so that we give are stopwatch cooldowns.
	..()

