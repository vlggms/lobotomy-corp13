GLOBAL_VAR_INIT(rcorp_factorymax, 70)

/obj/structure/resourcepoint
	name = "green resource point"
	desc = "A machine that when hit with a wrench, spits out green resources."
	icon = 'ModularTegustation/Teguicons/factory.dmi'
	icon_state = "resource_green"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/obj/item = /obj/item/factoryitem/green	//What item you spawn
	var/active = 0	//What level you have
	var/difficulty = 1	//Difficulty of enemies spawned


/obj/structure/resourcepoint/Initialize()
	..()
	addtimer(CALLBACK(src, PROC_REF(spawn_enemy)), 20 SECONDS)


/obj/structure/resourcepoint/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(active > 0)
		return
	if(I.tool_behaviour != TOOL_WRENCH)
		return
	if(!do_after(user, 7 SECONDS, src))
		return
	active = 1
	addtimer(CALLBACK(src, PROC_REF(spit_item)), 600/active)

/obj/structure/resourcepoint/proc/spit_item()
	if(!active)
		return
	if(prob(20) && active<=10)	//To do: make this less random.
		active+=1

	var/halt_active = TRUE		//We're going to stop shit by default
	for(var/mob/living/carbon/human/H in range(8, get_turf(src)))
		halt_active = FALSE
		break

	if(halt_active)
		active = 0
		return

	addtimer(CALLBACK(src, PROC_REF(spit_item)), 600/active)
	new item(src.loc)

/obj/structure/resourcepoint/proc/spawn_enemy()
	addtimer(CALLBACK(src, PROC_REF(spawn_enemy)), 20 SECONDS)
	for(var/mob/M in range(8, get_turf(src)))
		return
	var/mob_counter = 0
	for(var/mob/living/simple_animal/hostile/H in GLOB.mob_list)
		mob_counter++
	if(mob_counter > GLOB.rcorp_factorymax)
		return
	var/mob/living/simple_animal/hostile/to_spawn

	switch(difficulty)
		if(1 to 4)
			to_spawn = pick(
				/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
				/mob/living/simple_animal/hostile/ordeal/indigo_dawn/invis,
				/mob/living/simple_animal/hostile/ordeal/indigo_dawn/skirmisher,)
		if(5 to 8)
			to_spawn = /mob/living/simple_animal/hostile/ordeal/indigo_noon

		if(9 to INFINITY)
			if(prob(50))
				to_spawn = /mob/living/simple_animal/hostile/ordeal/indigo_noon

			else
				to_spawn = pick(
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red,
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white,
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black,
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale,)

	if(prob(10))
		difficulty++
	var/mob/living/simple_animal/hostile/spawned_enemy = new to_spawn(get_turf(src))
	spawned_enemy.can_patrol = TRUE
	spawned_enemy.del_on_death = TRUE

/obj/structure/resourcepoint/red
	name = "red resource point"
	desc = "A machine that when used, spits out red resources."
	icon_state = "resource_red"
	item = /obj/item/factoryitem/red	//What item you spawn

/obj/structure/resourcepoint/blue
	name = "blue resource point"
	desc = "A machine that when used, spits out blue resources."
	icon_state = "resource_blue"
	item = /obj/item/factoryitem/blue	//What item you spawn

/obj/structure/resourcepoint/purple
	name = "purple resource point"
	desc = "A machine that when used, spits out purple resources."
	icon_state = "resource_purple"
	item = /obj/item/factoryitem/purple	//What item you spawn

/obj/structure/resourcepoint/orange
	name = "orange resource point"
	desc = "A machine that when used, spits out orange resources."
	icon_state = "resource_orange"
	item = /obj/item/factoryitem/orange	//What item you spawn

/obj/structure/resourcepoint/silver
	name = "silver resource point"
	desc = "A machine that when used, spits out silver resources."
	icon_state = "resource_silver"
	item = /obj/item/factoryitem/silver	//What item you spawn
