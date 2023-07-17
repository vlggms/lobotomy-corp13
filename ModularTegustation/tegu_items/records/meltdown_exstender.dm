//Meltdown Exstender Watch
//Unlike other watches this is used on an object directly thus its calls and procs are working differently
/obj/item/records/meltdown_exstender
	name = "records wood watch"
	desc = "A treaded wooden watch for restoring an abnormality qliphoth counter if possable."
	icon_state = "watch_wood"
	//Default cooldown is 5 Minutes
	records_cooldown_timer = 5 MINUTES
	/*
	Are fancy gimmic is that we when used on a work console will give in seconds,
	more time before a meltdown happens.
	For more documentationa and information see code/game/machinery/computer/abnormality_work.dm

	By default we add 30 seconds to a meltdown timer
	*/
	var/meltdowntimer_increase = 30

/obj/item/records/meltdown_exstender/attack_self()
	//We dont have any fancy action by areselfs as its handled in whatever we hit the watch
	//We have to return here without calling parrent or else we get a cooldown
	return
