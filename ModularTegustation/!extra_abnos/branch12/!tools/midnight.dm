/obj/structure/toolabnormality/midnight
	name = "10 seconds to midnight"
	desc = "Broken red glass over a small clock. The plate is scratched but you can barely make out roman numerals."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "midnight"
	var/uses_left = 2


/obj/structure/toolabnormality/midnight/attack_hand(mob/living/carbon/human/user)
	. = ..()

	if(uses_left <=0)
		to_chat(user, span_notice("You shouldn't wind it any more."))
		return

	if(!do_after(user, 10))
		return

/*	if(SSlobotomy_corp.qliphoth_state == SSlobotomy_corp.next_ordeal_time) // Gotta pick it when the ordeal is next
		to_chat(user, span_notice("Now is not the time."))
		return*/

	uses_left--
	switch(uses_left)
		if(2 to INFINITY)
			icon_state = "midnight"

		if(1)
			icon_state = "midnight_2"

		if(-INFINITY to 0)
			icon_state = "midnight_3"

	//Increase time between ordels.
	SSlobotomy_corp.next_ordeal_time += 1
	to_chat(user, span_notice("You wind the clock, and the sundial ticks closer to midnight."))
	LowerCounter()

	//Lower reward by 5 if we can't make it harder
	for(var/i = 1 to 4)
		for(var/datum/ordeal/C in SSlobotomy_corp.all_ordeals[i])
			say("[C.name]")
			C.reward_percent-=0.05

		//You also make ordeals stronger
		for(var/datum/ordeal/simplespawn/A in SSlobotomy_corp.all_ordeals[i])
			A.spawn_places++
			A.spawn_amount++
			A.reward_percent+=0.10	//Should be +5%

		for(var/datum/ordeal/simplecommander/B in SSlobotomy_corp.all_ordeals[i])
			B.boss_amount++
			B.grunt_amount++
			B.reward_percent+=0.10	//Should be +5%

/obj/structure/toolabnormality/midnight/proc/LowerCounter()
	//Decrease 3 random Qliphoth counters
	var/list/total_abnormalities

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if(A.datum_reference.qliphoth_meter > 0 && A.IsContained() && A.z == z)
			total_abnormalities += A

	if(!LAZYLEN(total_abnormalities))
		return

	for(var/i = 1 to 4)
		var/mob/living/simple_animal/hostile/abnormality/processing = pick(total_abnormalities)
		processing.datum_reference.qliphoth_change(-1)
