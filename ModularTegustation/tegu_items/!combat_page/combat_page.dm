//Basic combat page
/obj/item/combat_page
	name = "combat page"
	desc = "A sort of storage that invites hostiles to the facility, and releases a few goodies and PE."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "darkbible"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/combat_level = 1
	var/reward_type = "PE"
	var/reward_specification		//Any additional information.
	var/spawn_enemies = list(/mob/living/simple_animal/hostile/ordeal/amber_bug)
	var/spawn_type = "all"			//All spawns all enemies, random spawns a random one.
	var/spawn_number = 1
	var/special						//Any special info to add as info

/obj/item/combat_page/attack_self(mob/living/user)
	..()
	Spawn_Reward()
	Spawn_Combat()
	minor_announce("A combat page has been started by [user.name]. Reward type: [reward_type]" , "[name]")

/obj/item/combat_page/examine(mob/user)
	. = ..()
	if(special)
		. += span_notice("[special]")
	. += span_notice("This is a level [combat_level] combat page")

	switch(reward_type)
		if("Item")
			. += span_notice("You will recieve an item from this page")
		if("PE")
			. += span_notice("You will recieve PE from this page")

/obj/item/combat_page/proc/Spawn_Combat(mob/living/user)
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in a combat page!")
		return
	var/list/spawn_turfs = GLOB.xeno_spawn.Copy()
	var/current_spawn = pick(spawn_turfs)

	switch(spawn_type)
		if("all")
			for(var/mob/living/L in spawn_enemies)
				new L(current_spawn)
		if("random")
			var/mob/living/L = pick(spawn_enemies)
			new L(current_spawn)
	spawn_number -= 1
	if(spawn_number > 0)
		Spawn_Combat(user)

/obj/item/combat_page/proc/Spawn_Reward(mob/living/user)
	switch(reward_type)
		if("Item")
			new reward_specification (get_turf(user))	//Item uses the reward specification as an itempath
		if("PE")
			SSlobotomy_corp.AdjustAvailableBoxes(-1 * reward_specification)	//PE uses the reward specification as a number
