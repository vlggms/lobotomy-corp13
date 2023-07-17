//Increases if applicable the qliphoth by 1
/obj/item/records/qliphoth_repair
	name = "records platinum watch"
	desc = "A shiney platinum watch the records officer can use to restore an abnormality qliphoth counter if possable."
	icon_state = "watch_platinum"
	//By default we can only restore every 15 mins
	records_cooldown_timer = 15 MINUTES
	//By defeault we restore one Qliphoth Counter
	var/restore_qliphoth_counter_amount = 1

/obj/item/records/qliphoth_repair/attack_self()
	//We dont have any fancy action by areselfs as its handled in whatever we hit the watch
	//We have to return here without calling parrent or else we get a cooldown
	return

