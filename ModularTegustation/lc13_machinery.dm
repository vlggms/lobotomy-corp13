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
	var/prosthetic_cost = 300
	var/organic_cost = 1200
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
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

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

/*---------------\
|Body Preservation Unit|
\---------------*/

/obj/machinery/body_preservation_unit
	name = "body preservation unit"
	desc = "A high-tech machine that can store a digital copy of your body and attributes for a fee. In case of death, it can revive you with a small attribute penalty."
	icon = 'icons/obj/machines/body_preservation.dmi'
	icon_state = "bpu"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 50
	active_power_usage = 300
	var/preservation_fee = 500
	var/revival_fee = 1000
	var/revival_attribute_penalty = 2
	var/list/stored_bodies = list()

/obj/machinery/body_preservation_unit/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Preservation Fee: [preservation_fee] AHN</span>"
	. += "<span class='notice'>Revival Fee: [revival_fee] AHN</span>"

/obj/machinery/body_preservation_unit/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		var/ahn_amount = H.get_item_credit_value()
		H.spend(ahn_amount)
		to_chat(user, "<span class='notice'>You insert [ahn_amount] AHN into the machine.</span>")
		return
	return ..()

/obj/machinery/body_preservation_unit/ui_interact(mob/user)
	. = ..()
	var/dat
	dat += "<b>Body Preservation Unit</b><br>"
	dat += "Preservation Fee: [preservation_fee] AHN<br>"
	dat += "Revival Fee: [revival_fee] AHN<br>"
	dat += "<hr>"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(stored_bodies[H.real_name])
			dat += "<a href='?src=[REF(src)];revive=[H.real_name]'>Revive Stored Body ([revival_fee] AHN)</a><br>"
		else
			dat += "<a href='?src=[REF(src)];preserve=[REF(H)]'>Preserve Current Body ([preservation_fee] AHN)</a><br>"

	if (isobserver(user))
		var/mob/dead/observer/O = user
		if(stored_bodies[O.real_name])
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
			if(try_payment(preservation_fee, H))
				preserve_body(H)

	if(href_list["revive"])
		var/mob_name = href_list["revive"]
		//var/mob/living/carbon/human/H = locate(stored_bodies[mob_name]["ref"])
		//if(H && ishuman(H))
		//	if(try_payment(revival_fee, H))
		revive_body(mob_name)

	updateUsrDialog()

/obj/machinery/body_preservation_unit/proc/try_payment(amount, mob/living/carbon/human/H)
	// Implement payment logic here
	// For simplicity, we'll assume the payment is always successful
	return TRUE

/obj/machinery/body_preservation_unit/proc/preserve_body(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return
	var/datum/mind/M = H.mind
	var/list/preserved_data = list()
	preserved_data["ref"] = REF(H)
	preserved_data["ckey"] = M.key
	preserved_data["real_name"] = H.real_name
	preserved_data["species"] = H.dna.species.type
	var/datum/dna/D = new /datum/dna
	H.dna.copy_dna(D)
	preserved_data["dna"] = D
	var/list/attributes = list()
	for(var/type in GLOB.attribute_types)
		if(ispath(type, /datum/attribute))
			var/datum/attribute/atr = new type
			attributes[atr.name] = atr
			atr.level = get_raw_level(H, atr)
	preserved_data["attributes"] = attributes
	preserved_data["underwear"] = H.underwear
	preserved_data["underwear_color"] = H.underwear_color

	stored_bodies[H.real_name] = preserved_data
	to_chat(H, span_notice("Your body data has been preserved."))

	// Instead of implanting, add a component
	H.AddComponent(/datum/component/respawnable, respawn_time = 15 SECONDS)

	to_chat(H, span_notice("You've been granted the ability to respawn after death."))

/obj/machinery/body_preservation_unit/proc/revive_body(real_name, ckey)
	if(!stored_bodies[real_name])
		return

	var/list/stored_data = stored_bodies[real_name]

	// if (stored_data["ckey"] != usr.ckey)
	// 	log_game("Body Preservation Unit: Wrong ckey for [real_name]. Not respawning!")
	// 	return


	// Create a new body
	var/mob/living/carbon/human/new_body = new(get_turf(src))

	// Set up the new body with stored data
	new_body.real_name = stored_data["real_name"]

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

	new_body.AddComponent(/datum/component/respawnable, respawn_time = 15 SECONDS)

	// Revive the new body
	new_body.revive(full_heal = TRUE, admin_revive = FALSE)
	new_body.updateappearance()

	if (isnull(usr))
		new_body.ckey = ckey
	else
		new_body.ckey = usr.ckey

	to_chat(new_body, "<span class='warning'>You have been revived in a new body, but your attributes have decreased slightly.</span>")

	// Remove the stored body data after revival
	//stored_bodies -= H.real_name

	// Delete the old body if it exists
	//if(H && !QDELETED(H))
	//	qdel(H)

// New component for handling respawns
/datum/component/respawnable
	var/respawn_time = 15 SECONDS

/datum/component/respawnable/Initialize(respawn_time)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.respawn_time = respawn_time
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/respawnable/proc/on_death(mob/living/L, gibbed)
	SIGNAL_HANDLER
	if (ishuman(L))
		var/mob/living/carbon/human/H = L
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(offer_respawn_global), H.real_name), respawn_time)

// Define this as a global proc
/proc/offer_respawn_global(real_name)
	var/mob/dead/observer/ghost = find_dead_player(real_name)
	if(!ghost || !ghost.client)
		return
	var/response = alert(ghost, "Do you want to respawn?", "Respawn Offer", "Yes", "No")
	if(response == "Yes")
		var/obj/machinery/body_preservation_unit/BPU = locate() in GLOB.machines
		if(BPU && BPU.stored_bodies[real_name])
			BPU.revive_body(real_name, ghost.ckey)

/proc/find_dead_player(real_name)
	for(var/mob/dead/observer/O in GLOB.dead_mob_list)
		if(O.real_name == real_name)
			return O
	return null
