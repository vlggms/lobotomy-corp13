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
	to_chat(user, span_notice("Current Status:"))
	to_chat(user, span_notice("Number of Abnormalities: [SSabnormality_queue.spawned_abnos]."))
	to_chat(user, span_notice("Next Abnormality: [initial(queued_abno.name)]."))
	if(SSabnormality_queue.rooms_start > SSabnormality_queue.spawned_abnos)
		if(time_to_abno <= INFINITY/20)
			to_chat(user, span_notice("Time to next Abnormality: [time_to_abno] seconds."))
		else
			to_chat(user, span_notice("Please wait for extraction to prepare the next abnormality."))

	//PE stuff. He doesn't really need to know this but information and all that
	if(SSlobotomy_corp.box_goal != 0)	//Make sure it's not infinity
		if(SSlobotomy_corp.goal_reached)
			to_chat(user, span_notice("PE Quota Reached!</span><br><span class='notice'>Current PE: [SSlobotomy_corp.available_box]"))
		else
			to_chat(user, span_notice("PE Goal: [SSlobotomy_corp.goal_boxes + SSlobotomy_corp.available_box] / [SSlobotomy_corp.box_goal]."))
	else
		to_chat(user, span_notice("PE Quota is still being calculated, please hold."))

	//Ordeal stuff
	to_chat(user, span_notice("Current qliphoth meter: [SSlobotomy_corp.qliphoth_meter] / [SSlobotomy_corp.qliphoth_max]."))
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
		to_chat(user, span_notice("[SSlobotomy_corp.next_ordeal.name] will trigger on the next meltdown."))

	//Call back are parrent, for now this is for code constanty. As it doesnt have a cooldown but later on this maybe important.
	..()
