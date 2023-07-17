//Silver Watch
//Checks the infomation of the current facility.
/obj/item/records/information
	name = "records silver watch"
	desc = "A silver watch the records officer can use to check various information around the facility."
	icon_state = "watch_silver"
	//Unlike other watches silver one has no cooldown
	records_cooldown_timer = 0

/obj/item/records/information/watch_action(mob/user)
	//Convert to seconds
	var/time_to_abno = (SSabnormality_queue.next_abno_spawn - world.time)/10
	var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality

	//Abno stuff. Just in case the manager is being a bit quiet.
	to_chat(user, "<span class='notice'>Current Status:</span>")
	to_chat(user, "<span class='notice'>Number of Abnormalities: [SSabnormality_queue.spawned_abnos].</span>")
	to_chat(user, "<span class='notice'>Next Abnormality: [initial(queued_abno.name)].</span>")
	if(SSabnormality_queue.rooms_start > SSabnormality_queue.spawned_abnos)
		if(time_to_abno <= INFINITY/20)
			to_chat(user, "<span class='notice'>Time to next Abnormality: [time_to_abno] seconds.</span>")
		else
			to_chat(user, "<span class='notice'>Please wait for extraction to prepare the next abnormality.</span>")

	//PE stuff. He doesn't really need to know this but information and all that
	if(SSlobotomy_corp.box_goal != INFINITY)	//Make sure it's not infinity
		to_chat(user, "<span class='notice'>PE Goal: [SSlobotomy_corp.current_box] / [SSlobotomy_corp.box_goal].</span>")

	//Ordeal stuff
	to_chat(user, "<span class='notice'>Current qliphoth meter: [SSlobotomy_corp.qliphoth_meter] / [SSlobotomy_corp.qliphoth_max].</span>")
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
		to_chat(user, "<span class='notice'>[SSlobotomy_corp.next_ordeal.name] will trigger on the next meltdown.</span>")

	//Call back are parrent, for now this is for code constanty. As it doesnt have a cooldown but later on this maybe important.
	..()
