GLOBAL_VAR_INIT(combat_points, 0)
//Basic combat page
/obj/item/combat_page
	name = "combat page"
	desc = "A sort of storage that invites hostiles to the facility, and releases a few goodies and PE."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "darkbible"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/combat_level = 1
	var/reward_pe
	var/reward_items = list()		//Any additional information.
	var/spawn_enemies = list(/mob/living/simple_animal/hostile/ordeal/amber_bug)
	var/spawn_type = "all"			//All spawns all enemies, random spawns a random one.
	var/spawn_number = 1
	var/special						//Any special info to add as info
	var/being_used = FALSE

	//DO, RO and EO can all use these. and Training officer I guess
	var/list/allowedroles = list("Disciplinary Officer", "Extraction Officer", "Records Officer", "Training Officer", "Sephirah")

/obj/item/combat_page/attack_self(mob/living/user)
	..()
	if(!LAZYLEN(allowedroles))
		if(!istype(user) || !(user?.mind?.assigned_role in allowedroles))
			to_chat(user, span_notice("The page glows red. It is unable to be used by you. Only Departmental officers can use this page."))
			return

	if(being_used)
		to_chat(user, span_notice("You are already using this page."))
		return
	being_used = TRUE
	var/start_page = alert("Start this combat page?", "Combat Page", "Yes", "No")
	if(start_page == "No")
		being_used = FALSE
		return
	Spawn_Reward(user)
	Spawn_Combat(user)
	minor_announce("A combat page has been started by [user.name]." , "[name]")
	being_used = FALSE
	qdel(src)

/obj/item/combat_page/examine(mob/user)
	. = ..()
	if(special)
		. += span_notice("[special]")
	. += span_notice("This is a level [combat_level] combat page")

	if(LAZYLEN(reward_items))
		. += span_notice("You will recieve an item from this page")
	. += span_notice("You will recieve [reward_pe] PE from this page")

/obj/item/combat_page/proc/Spawn_Combat(mob/living/user)
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in a combat page!")
		return
	var/list/spawn_turfs = GLOB.xeno_spawn.Copy()
	var/current_spawn = pick(spawn_turfs)

	switch(spawn_type)
		if("all")
			for(var/mob/living/simple_animal/hostile/L in spawn_enemies)
				L = new L(current_spawn)
				L.can_patrol = TRUE
				L.faction += "hostile"
		if("random")
			var/mob/living/simple_animal/hostile/L = pick(spawn_enemies)
			L = new L(current_spawn)
			//L.can_patrol = TRUE
			L.faction += "hostile"
	spawn_number -= 1
	if(spawn_number > 0)
		Spawn_Combat(user)

/obj/item/combat_page/proc/Spawn_Reward(mob/living/user)
	if(LAZYLEN(reward_items))
		for(var/I in (reward_items))
			new I(get_turf(user))

	if(reward_pe)
		SSlobotomy_corp.AdjustAvailableBoxes(reward_pe)


/obj/effect/landmark/combat_page
	name = "combat page spawner"
	desc = "It spawns combat pages. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x3"
