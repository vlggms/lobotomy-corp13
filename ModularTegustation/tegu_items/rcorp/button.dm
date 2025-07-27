/obj/machinery/button/door/indestructible/rcorp
	name = "rcorp button"
	id = "inside"

/obj/machinery/button/door/indestructible/rcorp/setup_device()
	if(!device)
		var/obj/item/assembly/control/rcorp/A = new(src)
		device = A
	..()

/obj/machinery/button/door/indestructible/rcorp/Destroy()
	qdel(device)
	return ..()

/obj/item/assembly/control/rcorp
	name = "rcorp door controller"

/obj/item/assembly/control/rcorp/activate()
	if(cooldown)
		return
	// check abnos
	var/count = 0
	var/mob/living/simple_animal/hostile/better_memories_minion/B = locate()
	var/mob/living/carbon/human/species/pinocchio/P = locate()
	if (P)
		count++
	if (B)
		count++
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if (A.rcorp_team == "easy")
			count++
		if (count > 2)
			break
	if (count > 2)
		to_chat(usr, "<span class='notice'>There are still enemies around!</span>")
		return
	..()
