//Pepperspray Module

/obj/item/reagent_containers/spray/pepper/cyborg
	name = "Integrated Pepperspray"
	desc = "An integrated pepperspray synthesizer. Use for blinding criminal scum. Utilizes your power supply to synthesize capsaicin spray over time."
	reagent_flags = NONE
	volume = 50
	list_reagents = list(/datum/reagent/consumable/condensedcapsaicin = 50)
	var/charge_cost = 50
	var/generate_amount = 5
	var/generate_type = /datum/reagent/consumable/condensedcapsaicin
	var/last_generate = 0
	var/generate_delay = 50	//deciseconds
	var/upgraded = FALSE
	can_fill_from_container = FALSE

// Fix pepperspraying yourself
/obj/item/reagent_containers/spray/pepper/cyborg/afterattack(atom/A as mob|obj, mob/user)
	if (A.loc == user)
		return
	. = ..()

/obj/item/reagent_containers/spray/pepper/cyborg/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/item/reagent_containers/spray/pepper/cyborg/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/item/reagent_containers/spray/pepper/cyborg/process()
	if(world.time < last_generate + generate_delay)
		return
	last_generate = world.time
	generate_reagents()

/obj/item/reagent_containers/spray/pepper/cyborg/empty()
	to_chat(usr, span_warning("You can not empty this!"))
	return

/obj/item/reagent_containers/spray/pepper/cyborg/proc/generate_reagents()
	if(!issilicon(src.loc))
		return

	var/mob/living/silicon/robot/R = src.loc
	if(!R || !R.cell)
		return

	if(R.cell.charge < charge_cost) //Not enough energy to regenerate reagents.
		return

	if(reagents.total_volume >= volume) //If we have maximum reagents, we don't use energy to produce any.
		return

	R.cell.use(charge_cost)
	reagents.add_reagent(generate_type, generate_amount)


//*******************************************
//SEC HOLOBARRIER ITEM AND UPGRADE - BEGINS
//*******************************************

/obj/item/borg/upgrade/sec_holobarrier
	name = "cyborg security holobarrier projector"
	desc = "A module that permits creation of holographic security barriers."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker_sec"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/security)

/obj/item/borg/upgrade/sec_holobarrier/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/holosign_creator/security/cyborg/E = locate() in R.model.modules
		if(E)
			to_chat(user, span_warning("This unit already has a [E] installed!"))
			return FALSE

		E = new(R.model)
		R.model.basic_modules += E
		R.model.add_module(E, FALSE, TRUE)

/obj/item/borg/upgrade/sec_holobarrier/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/holosign_creator/security/cyborg/E = locate() in R.model.modules
		if (E)
			R.model.remove_module(E, TRUE)

/obj/item/holosign_creator/security/cyborg
	name = "Security Holobarrier Projector"
	desc = "A hard light projector that creates holographic security barriers."
	icon_state = "signmaker_sec"
	holosign_type = /obj/structure/holosign/barrier
	creation_time = 15
	max_signs = 9
	var/shock = 0

/obj/item/holosign_creator/security/cyborg/attack_self(mob/user)
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user

		if(shock)
			to_chat(user, span_notice("You clear all active holograms, and reset your projector to normal."))
			holosign_type = /obj/structure/holosign/barrier
			creation_time = 5
			if(signs.len)
				for(var/H in signs)
					qdel(H)
			shock = 0
			return
		else if(R.emagged&&!shock)
			to_chat(user, span_warning("You clear all active holograms, and overload your energy projector!"))
			holosign_type = /obj/structure/holosign/barrier/cyborg/hacked
			creation_time = 30
			if(signs.len)
				for(var/H in signs)
					qdel(H)
			shock = 1
			return
		else
			if(signs.len)
				for(var/H in signs)
					qdel(H)
				to_chat(user, span_notice("You clear all active holograms."))
	if(signs.len)
		for(var/H in signs)
			qdel(H)
		to_chat(user, span_notice("You clear all active holograms."))

//*******************************************
//SEC HOLOBARRIER ITEM AND UPGRADE - ENDS
//*******************************************

//*******************************************
//SEC INTEGRATED E-BOLA (lol) LAUNCHER ITEM AND UPGRADE - BEGINS
//*******************************************

/obj/item/gun/energy/e_gun/e_bola/cyborg
	name = "\improper Integrated E-BOLA Launcher"
	desc = "An integrated e-bola launcher that draws from a cyborg's power cell."
	icon_state = "dragnet"
	can_charge = FALSE
	use_cyborg_cell = TRUE
	charge_delay = 8
	ammo_type = list(/obj/item/ammo_casing/energy/bola)

/obj/item/borg/upgrade/e_bola
	name = "cyborg energy bola launcher"
	desc = "A module that permits firing energy bolas."
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "dragnet"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/security)

/obj/item/borg/upgrade/e_bola/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/e_gun/e_bola/cyborg/E = locate() in R.model.modules
		if(E)
			to_chat(user, span_warning("This unit already has a [E] installed!"))
			return FALSE

		E = new(R.model)
		R.model.basic_modules += E
		R.model.add_module(E, FALSE, TRUE)

/obj/item/borg/upgrade/e_bola/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/e_gun/e_bola/cyborg/E = locate() in R.model.modules
		if (E)
			R.model.remove_module(E, TRUE)

/obj/item/ammo_casing/energy/bola
	projectile_type = /obj/projectile/energy/trap/cyborg
	select_name = "bola"
	e_cost = 400
	harmful = FALSE

//*******************************************
//SEC INTEGRATED E-BOLA (lol) LAUNCHER ITEM AND UPGRADE - ENDS
//*******************************************

//*******************************************
//SEC INTEGRATED ENERGY GUN ITEM AND UPGRADE - BEGINS
//*******************************************

/obj/item/gun/energy/e_gun/cyborg
	name = "\improper Integrated Energy Gun"
	desc = "An integrated energy gun that draws from a cyborg's power cell."
	can_charge = FALSE
	use_cyborg_cell = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/disabler)

//Where we check to see if station is on red alert and the lethal mode can be used.

/obj/item/gun/energy/e_gun/cyborg/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!check_alert_level())
		return
	return ..()

/obj/item/gun/energy/e_gun/cyborg/proc/check_alert_level()
	var/mob/living/silicon/robot/R = loc
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(!R || !iscyborg(R))
		return FALSE

	if((GLOB.security_level < SEC_LEVEL_RED && shot.harmful) && !R.emagged) //If we're emagged we don't care about alert level
		playsound(loc, 'sound/machines/buzz-two.ogg', get_clamped_volume(), TRUE, -1)
		to_chat(loc,span_warning("ERROR: Weapon cannot fire on lethal modes while the alert level is less than red."))
		return FALSE

	return TRUE

//Sec Egun Lethal Upgrade

/obj/item/borg/upgrade/e_gun_lethal
	name = "cyborg lethal mode unlock"
	desc = "A module that unlocks the lethal mode for a cyborg's integrated energy gun for use during red alert."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/security)

/obj/item/borg/upgrade/e_gun_lethal/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/e_gun/cyborg/T = locate() in R.model.modules
		if(!T)
			to_chat(user, span_warning("There's no [T] in this unit!"))
			return FALSE
		if(T.ammo_type.len > 1)
			to_chat(R, span_warning("Lethals are already unlocked for your [T]!"))
			to_chat(user, span_warning("Lethals are already unlocked for [R]'s [T]!"))
			return FALSE

		T.ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
		T.update_ammo_types()

/obj/item/borg/upgrade/e_gun_lethal/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/e_gun/cyborg/T = locate() in R.model.modules
		if(!T)
			return FALSE
		if(!R.emagged) //If we're emagged, don't revert.
			T.ammo_type = initial(T.ammo_type)

//Sec e-gun cooler upgrade

/obj/item/borg/upgrade/e_gun_cooler
	name = "cyborg energy gun cooling module"
	desc = "Used to cool an integrated energy gun, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = list(/obj/item/robot_model/security)

/obj/item/borg/upgrade/e_gun_cooler/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/e_gun/cyborg/T = locate() in R.model.modules
		if(!T)
			to_chat(user, span_warning("There's no [T] in this unit!"))
			return FALSE
		if(T.charge_delay <= 2)
			to_chat(R, span_warning("A cooling unit is already installed!"))
			to_chat(user, span_warning("There's no room for another cooling unit!"))
			return FALSE

		T.charge_delay = max(2 , T.charge_delay - 4)

/obj/item/borg/upgrade/e_gun_cooler/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/e_gun/cyborg/T = locate() in R.model.modules
		if(!T)
			return FALSE
		T.charge_delay = initial(T.charge_delay)


//*******************************************
//SEC INTEGRATED ENERGY GUN ITEM AND UPGRADE - ENDS
//*******************************************


//*******************************************
//CYBORG PEPPERSPRAY IMPROVED SYNTHESIZER UPGRADE - BEGINS
//*******************************************

/obj/item/borg/upgrade/peppersprayupgrade
	name = "cyborg improved capsaicin synthesizer module"
	desc = "Enhances a security cyborg's integrated pepper spray synthesizer, improving capacity and synthesizing efficiency."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = list(/obj/item/robot_model/security)

/obj/item/borg/upgrade/peppersprayupgrade/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/reagent_containers/spray/pepper/cyborg/T = locate() in R.model.modules
		if(!T)
			to_chat(user, span_warning("There's no pepper spray synthesizer in this unit!"))
			return FALSE
		if(T.upgraded)
			to_chat(R, span_warning("A [T] unit is already installed!"))
			to_chat(user, span_warning("There's no room for another [T]!"))
			return FALSE

		T.generate_amount += initial(T.generate_amount)
		T.volume += initial(T.volume)
		T.upgraded = TRUE

/obj/item/borg/upgrade/peppersprayupgrade/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/reagent_containers/spray/pepper/cyborg/T = locate() in R.model.modules
		if(!T)
			return FALSE
		T.generate_amount = initial(T.generate_amount)
		T.volume = initial(T.volume)
		T.upgraded = FALSE

//*******************************************
//CYBORG PEPPERSPRAY IMPROVED SYNTHESIZER UPGRADE - ENDS
//*******************************************

//CYBORG DESIGN DATUMS

/datum/design/borg_upgrade_secprojector
	name = "Cyborg Upgrade (Sec Barrier Projector)"
	id = "borg_upgrade_secprojector"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/sec_holobarrier
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 5000, /datum/material/silver = 2000)
	construction_time = 120
	category = list("Cyborg Upgrade Modules")

/datum/design/borg_upgrade_ebola
	name = "Cyborg Upgrade (Integrated E-BOLA Launcher)"
	id = "borg_upgrade_e-bola"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/e_bola
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 10000, /datum/material/silver = 2000, /datum/material/gold = 2000)
	construction_time = 120
	category = list("Cyborg Upgrade Modules")

/datum/design/borg_upgrade_pepperupgrade
	name = "Cyborg Upgrade (Improved Capsaicin Synthesizer)"
	id = "borg_upgrade_pepperspray"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/peppersprayupgrade
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 5000, /datum/material/silver = 2000)
	construction_time = 120
	category = list("Cyborg Upgrade Modules")

/datum/design/borg_upgrade_e_gun_lethal
	name = "Cyborg Upgrade (Integrated Energy Gun Kill Capacitors)"
	id = "borg_upgrade_e_gun_kill"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/e_gun_lethal
	materials = list(/datum/material/iron = 20000 , /datum/material/glass = 6000, /datum/material/gold = 2000, /datum/material/uranium = 5000)
	construction_time = 120
	category = list("Cyborg Upgrade Modules")

/datum/design/borg_upgrade_e_gun_cooler
	name = "Cyborg Upgrade (Integrated Energy Gun Cooling Module)"
	id = "borg_upgrade_e_gun_cooler"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/e_gun_cooler
	materials = list(/datum/material/iron = 20000 , /datum/material/glass = 6000, /datum/material/gold = 2000, /datum/material/diamond = 2000)
	construction_time = 120
	category = list("Cyborg Upgrade Modules")

//TECHWEB ENTRIES

/datum/techweb_node/cyborg_upg_sec
	id = "cyborg_upg_sec"
	display_name = "Cyborg Upgrades: Security"
	description = "Security upgrades for cyborgs."
	prereq_ids = list("sec_basic")
	design_ids = list("borg_upgrade_secprojector", "borg_upgrade_e-bola", "borg_upgrade_pepperspray")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/cyborg_upg_combat
	id = "cyborg_upg_cmb"
	display_name = "Cyborg Upgrades: Combat"
	description = "Combat upgrades for cyborgs."
	prereq_ids = list("cyborg_upg_sec", "weaponry")
	design_ids = list("borg_upgrade_e_gun_cooler", "borg_upgrade_e_gun_kill")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/mob/proc/check_for_item(typepath)
	if(locate(typepath) in src)
		return (locate(typepath) in src)

	if(iscyborg(src))
		var/mob/living/silicon/robot/R = src
		return (locate(typepath) in R.model)

	return FALSE
