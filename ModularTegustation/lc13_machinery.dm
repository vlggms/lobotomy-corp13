/obj/machinery/vending/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(!.)
		return FAILED_UNFASTEN

	// Mechanics are in pain right now, as this is the most real thing ever
	to_chat(user, span_warning("Aw dangit, your wrench is for 20 size bolts, but this vendor has size 17 bolts, your wrench keeps slipping!"))
	return FAILED_UNFASTEN

//Links to abnormality consoles when the console spawns
/obj/machinery/containment_panel
	name = "containment panel"
	desc = "A device that logs the location of a abnormality cell when it spawns."
	icon = 'ModularTegustation/Teguicons/lc13doorpanels.dmi'
	icon_state = "control"
	density = FALSE
	use_power = 0
	var/obj/machinery/computer/abnormality/linked_console
	var/work
	var/relative_location

/obj/machinery/containment_panel/Initialize()
	. = ..()
	var/turf/closest_department
	for(var/turf/T in GLOB.department_centers)
		if(T.z != z)
			continue
		if(!istype(T.loc, /area/department_main))
			continue
		if(!closest_department)
			closest_department = T
			continue
		if(get_dist(T, src) > get_dist(closest_department, src))
			continue
		closest_department = T
	var/direction = "in an unknown direction"
	var/xdif = closest_department.x - src.x
	var/ydif = closest_department.y - src.y
	if(abs(xdif) > abs(ydif))
		if(xdif < 0)
			direction = "East"
		else
			direction = "West"
	else
		if(ydif < 0)
			direction = "North"
		else
			direction = "South"
	relative_location = "[get_dist(closest_department, src)] meters [direction] from [closest_department.loc.name]."
	icon_state = replacetext("[closest_department.loc.type]", "/area/department_main/", "")

/obj/machinery/containment_panel/proc/console_status(obj/machinery/computer/abnormality/linked_console)
	cut_overlays()
	if(linked_console)
		add_overlay("glow_[icon_state]")
		desc = null

/obj/machinery/containment_panel/proc/console_working()
	cut_overlays()
	desc = "It says that work is in progress."
	if(icon_state == "command")
		add_overlay("glow_[icon_state]_work_in_progress")
		return
	add_overlay("glow_work_in_progress")
	return

/obj/machinery/containment_panel/proc/AbnormalityInfo()
	if(!linked_console)
		return "ERROR"
	return linked_console.datum_reference.name

/obj/machinery/containment_panel/discipline
	icon_state = "discipline"

/obj/machinery/containment_panel/extraction
	icon_state = "extraction"

/obj/machinery/containment_panel/records
	icon_state = "records"

/obj/machinery/containment_panel/welfare
	icon_state = "welfare"

/obj/machinery/containment_panel/training
	icon_state = "training"

/obj/machinery/containment_panel/information
	icon_state = "information"

/obj/machinery/containment_panel/safety
	icon_state = "safety"

/obj/machinery/containment_panel/command
	icon_state = "command"

/obj/machinery/abnormality_monitor
	name = "facility abnormality list"
	desc = "A screen that shows a list of all currently housed abnormalities and their departments."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "monitor1"
	density = FALSE
	use_power = 0
	var/list/abnormalities = list()

/obj/machinery/abnormality_monitor/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN, PROC_REF(UpdateNetwork)) //return a list of the abnormalities

/obj/machinery/abnormality_monitor/examine(mob/user)
	. = ..()
	ui_interact(user)

/obj/machinery/abnormality_monitor/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += "<b>FACILITY INFO:</b><br>"
	for(var/i = 1 to abnormalities.len)
		if(!LAZYLEN(abnormalities))
			dat += "[abnormalities[i]]"
		else
			dat += "[abnormalities[i]]"
		dat += "<br>"
	var/datum/browser/popup = new(user, "containment_diagnostics", "Current Containment", 500, 550)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/abnormality_monitor/proc/UpdateNetwork()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(PingFacilityNetwork))

/obj/machinery/abnormality_monitor/proc/PingFacilityNetwork()
	sleep(20) //2 seconds i think. Delay so that the most recently linked containment panel reads its console.
	LAZYCLEARLIST(abnormalities)
	for(var/obj/machinery/containment_panel/C in GLOB.machines)
		if(C.linked_console)
			LAZYADD(abnormalities, "[C.AbnormalityInfo()]: [C.relative_location]")
	sortList(abnormalities)

	/*---------------\
	|Torso Fabricator|
	\---------------*/
#define ANIMATE_FABRICATOR_ACTIVE flick("fab_robot_a", src)
/*
* When someone who has the time to convert tegu cloners
* into ours you can remove this code. -IP
*/
/obj/machinery/body_fabricator
	name = "torso fabricator"
	desc = "A fabricator for constructing humanoid bodies for the bodiless. Place a brain inside and activate! -NO REFUNDS-."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "fab_robot"
	density = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	var/active = FALSE
	var/stored_money = 0
	var/prosthetic_cost = 0
	var/organic_cost = 800
	var/obj/item/organ/brain/slotted_brain

/obj/machinery/body_fabricator/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		var/ahn_amount = H.get_item_credit_value()
		H.spend(ahn_amount)
		AdjustMoney(ahn_amount)
		return

	if(!slotted_brain)
		if(istype(I, /obj/item/bodypart/head))
			var/obj/item/bodypart/head/heed = I
			if(heed.brain)
				SlottedHead(heed)
				return
		if(istype(I, /obj/item/organ/brain))
			var/obj/item/organ/brain/B = I
			SlottedBrain(B)
			return
	..()

/obj/machinery/body_fabricator/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += "<b>FABRICATION_FUNDS: [stored_money]</b><br>----------------------<br>"
	if(slotted_brain)
		if(slotted_brain)
			dat += "BRAIN DETECTED|<br>--<br>"
		dat += " <A href='byond://?src=[REF(src)];PRINT_PROSTHETIC=[REF(src)]'>PRINT PROSTHETIC TORSO: [prosthetic_cost] AHN:</A><br>"
		dat += " Areas of the body have been replaced with scrap prosthetics. Clients have claimed to suffer a small attribute decrease.<br>"
		dat += " <A href='byond://?src=[REF(src)];PRINT_ORGANIC=[REF(src)]'>PRINT ORGANIC TORSO: [organic_cost] AHN</A><br>"
		dat += " Through undisclosed means we will print you a new torso with no attribute decay.<br>"
	else
		dat += "<b>NO BRAIN DETECTED|</b><br>--<br>"
	var/datum/browser/popup = new(user, "body_fab", "body fabricator", 500, 550)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/body_fabricator/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["PRINT_PROSTHETIC"])
			if(stored_money < prosthetic_cost)
				return
			ConstructTorso(2)
			AdjustMoney(-prosthetic_cost)
			updateUsrDialog()
			return TRUE
		if(href_list["PRINT_ORGANIC"])
			if(stored_money < organic_cost)
				return
			ConstructTorso(1)
			AdjustMoney(-organic_cost)
			updateUsrDialog()
			return TRUE

/obj/machinery/body_fabricator/proc/AdjustMoney(amount)
	stored_money += amount

/*
* In Library of Ruina there is a fixer that has their body
* damaged by clowns so their coworkers behead them and take
* them to get a new body cloned for them. That is the
* inspiration for the torso fabricator.
*/
/obj/machinery/body_fabricator/proc/SlottedBrain(obj/item/organ/brain/B)
	if(slotted_brain)
		return FALSE
	if(B.brainmob == null)
		return FALSE
	slotted_brain = B
	B.forceMove(src)
	return TRUE

/obj/machinery/body_fabricator/proc/SlottedHead(obj/item/bodypart/head/H)
	if(slotted_brain)
		return FALSE
	if(!H.brain)
		return FALSE
	if(H.brainmob == null)
		return FALSE
	slotted_brain = H.brain
	H.drop_organs()
	slotted_brain.forceMove(src)
	qdel(H)
	return TRUE

/*
* Okay so when your gibbed your head contains your brainmob
* but when your brain is cut out of the head the brain now
* contains the brainmob. The brainmob is the one who has
* the previous owners dna stored in it.
*/
/obj/machinery/body_fabricator/proc/ConstructTorso(biotype = 1)
	playsound(get_turf(src), 'sound/machines/click.ogg', 10, TRUE)
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)
	//YOU DIDNT PAY FOR LIMBS
	RemoveAllLimbs(H)

	//DNA TRANSFER GO!!!
	if(slotted_brain)
		var/mob/living/brain/B = locate(/mob/living/brain) in slotted_brain
		var/datum/dna/gibbed_dna = B.stored_dna
		if(gibbed_dna)
			H.real_name = gibbed_dna.real_name
			H.set_species(gibbed_dna.species)
			gibbed_dna.transfer_identity(H)

	//BRAIN INSERTION
	if(slotted_brain)
		slotted_brain.Insert(H)

	//REVIVE
	H.revive(full_heal = FALSE, admin_revive = FALSE)
	H.emote("gasp")
	H.Jitter(100)

	var/list/job_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE, TRAIT_ATTRIBUTES_VISION, TRAIT_SANITYIMMUNE)
	for(var/trait in slotted_brain.initial_traits)
		if(trait in job_traits)
			ADD_TRAIT(H, trait, JOB_TRAIT)
	H.adjust_attribute_level(FORTITUDE_ATTRIBUTE, slotted_brain.stored_fortitude)
	H.adjust_attribute_level(PRUDENCE_ATTRIBUTE, slotted_brain.stored_prudence)
	H.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, slotted_brain.stored_temperance)
	H.adjust_attribute_level(JUSTICE_ATTRIBUTE, slotted_brain.stored_justice)

	//YOU DIDNT PAY FOR PREMIUM SO WE ARE MAKING YOUR BODY WORSE
	if(biotype == 2)
		RoboticizeBody(H)
		H.adjust_all_attribute_levels(-5)
	H.updateappearance()
	DumpBody(H)

/obj/machinery/body_fabricator/proc/RoboticizeBody(mob/living/carbon/human/H)
	var/obj/item/bodypart/head/robot/robohead = new /obj/item/bodypart/head/robot(src)
	var/old_head = H.get_bodypart(BODY_ZONE_HEAD)
	robohead.replace_limb(H)
	qdel(old_head)

	var/obj/item/bodypart/chest/robot/robobody = new /obj/item/bodypart/chest/robot(src)
	var/refuse = H.get_bodypart(BODY_ZONE_CHEST)
	robobody.replace_limb(H)
	qdel(refuse)

/obj/machinery/body_fabricator/proc/RemoveAllLimbs(mob/living/carbon/human/H)
	var/static/list/zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	for(var/zone in zones)
		var/obj/item/bodypart/BP = H.get_bodypart(zone)
		if(BP)
			BP.drop_limb()
			qdel(BP)

/obj/machinery/body_fabricator/proc/DumpBody(mob/living/carbon/human/dude)
	slotted_brain = null
	ANIMATE_FABRICATOR_ACTIVE
	playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
	sleep(32)
	playsound(get_turf(src), 'sound/effects/bin_close.ogg', 35, 3, 3)
	playsound(get_turf(src), 'sound/misc/splort.ogg', 35, 3, 3)
	dude.forceMove(get_turf(src))

#undef ANIMATE_FABRICATOR_ACTIVE

// here we add some vars to the brain to hold the attributes/traits of a mob
/obj/item/organ/brain
	var/list/initial_traits = list()
	var/stored_fortitude = 0
	var/stored_prudence = 0
	var/stored_temperance = 0
	var/stored_justice = 0

/obj/item/organ/brain/Remove(mob/living/carbon/C, special = 0, no_id_transfer = FALSE)
	if(C)
		stored_fortitude = get_raw_level(C, FORTITUDE_ATTRIBUTE)
		stored_prudence = get_raw_level(C, PRUDENCE_ATTRIBUTE)
		stored_temperance = get_raw_level(C, TEMPERANCE_ATTRIBUTE)
		stored_justice = get_raw_level(C, JUSTICE_ATTRIBUTE)
	. = ..()

/datum/job/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	var/obj/item/organ/brain/B = H.getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		if(length(B.initial_traits) == 0)
			B.initial_traits = H.status_traits

/*---------------------\
|Body Preservation Unit|
\---------------------*/

/obj/machinery/body_preservation_unit
	name = "body preservation unit"
	desc = "A high-tech machine that can store a digital copy of your body and attributes for a fee. In case of death, it can revive you with a small attribute penalty."
	icon = 'icons/obj/machines/body_preservation.dmi'
	icon_state = "bpu"
	var/icon_state_animation = "bpu_animation"
	density = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	var/public_use = FALSE
	var/stored_money = 0
	//var/preservation_fee = 500
	var/revival_attribute_penalty = -6
	var/list/stored_bodies = list()
	var/clone_delay_seconds = 120
	var/cost_multiplier = 5
	resistance_flags = INDESTRUCTIBLE
	max_integrity = 1000000

/obj/machinery/body_preservation_unit/Initialize()
	. = ..()
	if(SSmaptype.maptype == "office")
		public_use = TRUE
		clone_delay_seconds = 60
		revival_attribute_penalty = -4
		cost_multiplier = 2

/obj/machinery/body_preservation_unit/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		var/ahn_amount = H.get_item_credit_value()
		H.spend(ahn_amount)
		AdjustMoney(ahn_amount)
		to_chat(user, "<span class='notice'>You insert [ahn_amount] AHN into the machine.</span>")
		return
	return ..()

/obj/machinery/body_preservation_unit/proc/AdjustMoney(amount)
	stored_money += amount

/obj/machinery/body_preservation_unit/proc/calculate_fee(mob/living/carbon/human/H)
	var/preservation_fee = 0

	for(var/atr_type in H.attributes)
		var/datum/attribute/atr = H.attributes[atr_type]
		preservation_fee += atr.level * cost_multiplier

	return preservation_fee


/obj/machinery/body_preservation_unit/ui_interact(mob/user)
	. = ..()

	var/dat
	dat += "<b>Body Preservation Unit</b><br>"
	dat += "<b>FUNDS: [stored_money]</b><br>----------------------<br>"

	if (!public_use && !(user?.mind?.assigned_role in list("Civilian")))
		dat += "<b>Only civilians can use this machine</b><br>"
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/preservation_fee = calculate_fee(H)

			dat += "Preservation Fee: [preservation_fee] AHN<br>"
			dat += "<hr>"


			if(stored_bodies[H.real_name])
				dat += "<a href='?src=[REF(src)];preserve=[REF(H)]'>Update body scan ([preservation_fee] AHN)</a><br>"
			else
				dat += "<a href='?src=[REF(src)];preserve=[REF(H)]'>Create body scan ([preservation_fee] AHN)</a><br>"

		if (isobserver(user))
			dat += "<hr>"

			var/mob/dead/observer/O = user
			var/list/stored_data = stored_bodies[O.real_name]
			if(stored_data)
				var/tod = stored_data["time_of_death"]
				var/sec_since_death = (world.time - tod)/10
				if (sec_since_death < clone_delay_seconds)
					dat += "<span>Seconds to cloning remaining: [clone_delay_seconds - sec_since_death]<br>"
				else
					dat += "<a href='?src=[REF(src)];revive=[O.real_name]'>Revive Stored Body</a><br>"

	var/datum/browser/popup = new(user, "body_preservation", "Body Preservation Unit", 300, 300)
	popup.set_content(dat)
	popup.open()

/obj/machinery/body_preservation_unit/Topic(href, href_list)
	if(..() && !isobserver(usr))
		return

	if(href_list["preserve"])
		var/mob/living/carbon/human/H = locate(href_list["preserve"])
		if(H && ishuman(H))
			var/preservation_fee = calculate_fee(H)
			if(try_payment(preservation_fee, H))
				preserve_body(H)
			else
				to_chat(H, "<span class='notice'>You don't have enough AHN.</span>")

	if(href_list["revive"])
		if (icon_state == icon_state_animation)
			to_chat(usr, "<span class='notice'>BPU busy.</span>")
			return

		var/mob_name = href_list["revive"]
		//var/mob/living/carbon/human/H = locate(stored_bodies[mob_name]["ref"])
		//if(H && ishuman(H))
		//	if(try_payment(revival_fee, H))
		revive_body(mob_name, usr.ckey)

	updateUsrDialog()

/obj/machinery/body_preservation_unit/proc/try_payment(amount, mob/living/carbon/human/H)
	if(stored_money < amount)
		return FALSE
	else
		playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
		stored_money -= amount
		return TRUE

/obj/machinery/body_preservation_unit/proc/store_attributes(mob/living/carbon/human/H, list/preserved_data)
	var/list/attributes = list()
	for(var/type in GLOB.attribute_types)
		if(ispath(type, /datum/attribute))
			var/datum/attribute/atr = new type
			attributes[atr.name] = atr
			var/datum/attribute/old_atr = H.attributes[atr.name]
			atr.level = old_atr.level
	preserved_data["attributes"] = attributes

/obj/machinery/body_preservation_unit/proc/store_actions(mob/living/carbon/human/H, list/preserved_data)
	var/list/action_types = list()
	for(var/datum/action/A in H.actions)
		if(ispath(A, /datum/action/item_action))
			continue
		if(ispath(A, /datum/action/spell_action))
			continue
		action_types += A.type
	preserved_data["action_types"] = action_types


/obj/machinery/body_preservation_unit/proc/preserve_body(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return
	var/datum/mind/M = H.mind
	var/list/preserved_data = list()
	preserved_data["ref"] = REF(H)
	preserved_data["ckey"] = M.key
	preserved_data["real_name"] = H.real_name
	preserved_data["species"] = H.dna.species.type
	preserved_data["gender"] = H.gender
	var/datum/dna/D = new /datum/dna
	H.dna.copy_dna(D)
	preserved_data["dna"] = D
	preserved_data["assigned_role"] = H.mind.assigned_role
	preserved_data["underwear"] = H.underwear
	preserved_data["underwear_color"] = H.underwear_color

	store_attributes(H, preserved_data)
	store_actions(H, preserved_data)

	stored_bodies[H.real_name] = preserved_data


	var/datum/component/respawnable/R = H.GetComponent(/datum/component/respawnable)
	if (R)
		R.RemoveComponent()
		R.UnregisterDeathSignal()

	// Instead of implanting, add a component
	R = H.AddComponent(/datum/component/respawnable, respawn_time = clone_delay_seconds * 10)
	R.BPU = src
	to_chat(H, span_notice("Your body data has been preserved."))

/obj/machinery/body_preservation_unit/proc/revive_body(real_name, ckey)
	if(!stored_bodies[real_name])
		return

	var/list/stored_data = stored_bodies[real_name]

	// if (stored_data["ckey"] != usr.ckey)
	// 	log_game("Body Preservation Unit: Wrong ckey for [real_name]. Not respawning!")
	// 	return
	var/temp_icon_state = icon_state
	icon_state = icon_state_animation
	sleep(10)
	icon_state = temp_icon_state

	// Create a new body
	var/mob/living/carbon/human/new_body = new(get_turf(src))

	// Set up the new body with stored data
	new_body.real_name = stored_data["real_name"]
	new_body.gender = stored_data["gender"]

	// Check if the stored DNA is valid
	if(istype(stored_data["dna"], /datum/dna))
		var/datum/dna/stored_dna = stored_data["dna"]
		stored_dna.transfer_identity(new_body)
	else
		log_game("Body Preservation Unit: Stored DNA for [real_name] was invalid.")
		qdel(new_body)
		return

	// Check if the species type is valid
	var/species_type = stored_data["species"]
	if(ispath(species_type, /datum/species))
		new_body.set_species(species_type)
	else
		log_game("Body Preservation Unit: Stored species type for [real_name] was invalid.")
		qdel(new_body)
		return

	// Apply attribute penalty and set attributes
	var/list/stored_attributes = stored_data["attributes"]
	if(islist(stored_attributes))
		// TODO Punishment
		new_body.attributes = stored_attributes
		new_body.adjust_all_attribute_levels(revival_attribute_penalty)
		store_attributes(new_body, stored_data)
	else
		log_game("Body Preservation Unit: Stored attributes for [real_name] were invalid.")
		qdel(new_body)
		return

	var/underwear = stored_data["underwear"]
	if (underwear)
		new_body.underwear = underwear

	var/underwear_color = stored_data["underwear_color"]
	if (underwear_color)
		new_body.underwear_color = underwear_color

	var/datum/component/respawnable/R = new_body.AddComponent(/datum/component/respawnable, respawn_time = clone_delay_seconds * 10)
	R.BPU = src

	// Revive the new body
	new_body.revive(full_heal = TRUE, admin_revive = FALSE)
	new_body.updateappearance()

	// if (isnull(usr))
	// 	new_body.ckey = ckey
	// else
	new_body.ckey = ckey

	var/list/stored_action_types = stored_data["action_types"]
	if (islist(stored_action_types))
		for (var/T in stored_action_types)
			var/datum/action/G = new T()
			G.Grant(new_body)


	if (!new_body.ckey)
		log_game("Body Preservation Unit: Created a new body for [real_name] without a ckey.")
		qdel(new_body)
		return

	var/assigned_role = stored_data["assigned_role"]
	if (assigned_role)
		new_body.mind.assigned_role = assigned_role


	playsound(get_turf(src), 'sound/effects/bin_close.ogg', 35, 3, 3)
	playsound(get_turf(src), 'sound/misc/splort.ogg', 35, 3, 3)
	to_chat(new_body, "<span class='warning'>You have been revived in a new body, but your attributes have decreased slightly.</span>")


// New component for handling respawns
/datum/component/respawnable
	var/respawn_time = 10 SECONDS
	var/obj/machinery/body_preservation_unit/BPU

/datum/component/respawnable/Initialize(respawn_time)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.respawn_time = respawn_time
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/respawnable/proc/UnregisterDeathSignal()
	UnregisterSignal(parent, COMSIG_LIVING_DEATH)

/datum/component/respawnable/proc/on_death(mob/living/L, gibbed)
	SIGNAL_HANDLER
	if (ishuman(L))
		var/mob/living/carbon/human/H = L
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(offer_respawn_global), H.real_name, BPU), respawn_time)
		var/list/stored_data = BPU.stored_bodies[H.real_name]
		stored_data["time_of_death"] = world.time


// Define this as a global proc
/proc/offer_respawn_global(real_name, obj/machinery/body_preservation_unit/BPU)
	var/mob/dead/observer/ghost = find_dead_player(real_name)
	to_chat(ghost, "<span class='notice'>BPU is now ready to rebuild your body, click on the BPU as a ghost to re-build yourself or accept this offer.</span>")
	if(!ghost || !ghost.client)
		return
	if (!istype(BPU) || !BPU.loc)
		return

	var/response = alert(ghost, "Do you want to be cloned at the BPU?", "Respawn Offer", "Yes", "No")
	if(response == "Yes")
//		var/obj/machinery/body_preservation_unit/BPU = locate() in GLOB.machines
		if(BPU.stored_bodies[real_name])
			BPU.revive_body(real_name, ghost.ckey)

/proc/find_dead_player(real_name)
	for(var/mob/dead/observer/O in GLOB.dead_mob_list)
		if(O.real_name == real_name)
			return O
	return null
