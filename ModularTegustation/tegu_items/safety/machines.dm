/// LC13 versions of various medical devices.
/obj/machinery/sleeper/facility
	icon_state = "sleeper_s"
	controls_inside = TRUE
	possible_chems = list(
		list(/datum/reagent/medicine/helapoeisis, /datum/reagent/medicine/enkephalin, /datum/reagent/medicine/bolus,  /datum/reagent/medicine/epinephrine),
		list(),
		list(),
		list()
	)

/obj/machinery/hatchery
	name = "prototype hatchery"
	desc = "A high-tech machine that can bring dead agents back to life."
	icon = 'icons/obj/machines/body_preservation.dmi'
	icon_state = "bpu"
	var/icon_state_animation = "bpu_animation"
	var/icon_failure = "bpu_failure"
	var/clone_delay_seconds = 90
	density = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	var/revival_attribute_penalty = -6
	var/static/list/stored_bodies = list() // Static vars are the same across all objects. This saves on performance vs making a datum or global
	var/signal_registered = FALSE // Allows a new hatchery to recieve a signal if one is somehow deleted.
	var/flick_cooldown_time = 2 SECONDS
	var/flick_cooldown
	resistance_flags = INDESTRUCTIBLE
	max_integrity = 1000000

/obj/machinery/hatchery/Initialize()
	. = ..()
	if(!length(GLOB.hatcheries))
		RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(TryPreserveBody)) // only the first hatchery starts storing information on bodies
		signal_registered = TRUE
	GLOB.hatcheries += src

/obj/machinery/hatchery/Destroy()
	GLOB.hatcheries -= src
	if(signal_registered)
		var/obj/machinery/hatchery/newhatchery = pick(GLOB.hatcheries)
		if(newhatchery) // If we have no other hatcheries, Initialize() will handle this for us.
			newhatchery.RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(TryPreserveBody))
	..()

/obj/machinery/hatchery/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/bodypart/head))
		return ..()
	var/obj/item/bodypart/head/newmob = I
	if(!newmob.brainmob)
		FailureResponse("ERROR: No brain waves detected.")
		return
	if(newmob.brainmob.mind)
		revive_body(newmob.brainmob.real_name, newmob.brainmob.ckey, TRUE)
		return
	else
		FailureResponse("ERROR: No brain waves detected.")
		return

/obj/machinery/hatchery/ui_interact(mob/user)
	. = ..()

	var/dat
	dat += "<b>Hatchery Ver. 1.3.161</b><br>"
	dat += "Patented by Company R<br>----------------------<br>"

	if(isobserver(user))
		dat += "<hr>"
		var/mob/dead/observer/O = user
		var/list/stored_data = stored_bodies[O.real_name]
		if(stored_data)
			if(stored_data["assigned_role"] in list("Agent", "Agent Intern", "Agent Captain"))
				dat += "<span>Warning: To revive in this manner without a body incurs a [revival_attribute_penalty] attribute penalty to all attributes.<br>"
				dat += "<span>Additionally EGO gifts will NOT be preserved unless a body or at least a severed head is used.<br>"
			var/tod = stored_data["time_of_death"]
			var/sec_since_death = (world.time - tod)/10
			if(sec_since_death < clone_delay_seconds)
				var/display_time = ceil(clone_delay_seconds - sec_since_death) // whole numbers only for display time
				dat += "<span>Seconds to cloning remaining: [display_time]<br>"
				dat += "<span>Revival using a body wih an intact brain has no delay.<br>"
			else
				dat += "<a href='byond://?src=[REF(src)];revive=[O.real_name]'>Revive Stored Body</a><br>"
		else
			dat += "No data found.<br>"
	else
		dat += "<hr>"
		dat += "Insert subject head or body to initiate incubation sequence.<br>"

	var/datum/browser/popup = new(user, "body_preservation", "Hatchery Interface", 300, 300)
	popup.set_content(dat)
	popup.open()

/obj/machinery/hatchery/Topic(href, href_list)
	if(..() && !isobserver(usr))
		return

	if(href_list["revive"])
		if (icon_state == icon_state_animation)
			to_chat(usr, "<span class='notice'>BPU busy.</span>")
			return

		var/mob_name = href_list["revive"]
		revive_body(mob_name, usr.ckey)

	updateUsrDialog()

/obj/machinery/hatchery/proc/TryPreserveBody(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	var/mob/living/carbon/human/H = died
	PreserveBody(H)

/obj/machinery/hatchery/proc/store_attributes(mob/living/carbon/human/H, list/preserved_data)
	var/list/attributes = list()
	for(var/type in GLOB.attribute_types)
		if(ispath(type, /datum/attribute))
			var/datum/attribute/atr = new type
			attributes[atr.name] = atr
			var/datum/attribute/old_atr = H.attributes[atr.name]
			atr.level = old_atr.get_raw_level()
	preserved_data["attributes"] = attributes

/obj/machinery/hatchery/proc/PreserveBody(mob/living/carbon/human/H)
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
	preserved_data["bank_account"] = H.account_id
	preserved_data["ego_gifts"] = H.ego_gift_list
	preserved_data["time_of_death"] = world.time

	store_attributes(H, preserved_data)

	stored_bodies[H.real_name] = preserved_data

/obj/machinery/hatchery/proc/revive_body(real_name, ckey, nopenalty = FALSE)
	if(!stored_bodies[real_name])
		return

	var/list/stored_data = stored_bodies[real_name]

	icon_state = icon_state_animation
	flick(icon_state_animation, src)

	// Create a new body
	var/mob/living/carbon/human/new_body = new(get_turf(src))

	// Set up the new body with stored data
	new_body.real_name = stored_data["real_name"]
	new_body.gender = stored_data["gender"]
	var/job = stored_data["assigned_role"] // allows for preservation of ID cards.
	if(job)
		new_body.job = job


	// Check if the stored DNA is valid
	if(istype(stored_data["dna"], /datum/dna))
		var/datum/dna/stored_dna = stored_data["dna"]
		stored_dna.transfer_identity(new_body)
	else
		log_game("Body Preservation Unit: Stored DNA for [real_name] was invalid.")
		qdel(new_body)
		FailureResponse("ERROR: Stored DNA for [real_name] was invalid.", real_name)
		return

	// Check if the species type is valid
	var/species_type = stored_data["species"]
	if(ispath(species_type, /datum/species))
		new_body.set_species(species_type)
	else
		log_game("Body Preservation Unit: Stored species type for [real_name] was invalid.")
		qdel(new_body)
		FailureResponse("ERROR: Non-human detected.", real_name)
		return

	// Apply attribute penalty and set attributes
	var/list/stored_attributes = stored_data["attributes"]
	if(islist(stored_attributes))
		new_body.attributes = stored_attributes
		if(!(stored_data["assigned_role"] in list("Agent", "Agent Intern", "Agent Captain")))
			nopenalty = TRUE // non-agents never lose attributes
		if(!nopenalty)
			var/minimum
			for(var/datum/job/agent/J in SSjob.occupations)
				if(J.normal_attribute_level)
					minimum = J.normal_attribute_level
					break

			// Manually add penalty, in respect to minimum attribute levels.
			new_body.adjust_all_attribute_levels(revival_attribute_penalty)
			for(var/atr_type in new_body.attributes)
				var/datum/attribute/atr = new_body.attributes[atr_type]
				if(!istype(atr))
					continue
				atr.level = clamp((atr.level + revival_attribute_penalty), minimum, atr.level_limit)
	else
		log_game("Body Preservation Unit: Stored attributes for [real_name] were invalid.")
		FailureResponse("ERROR: Invalid attributes.")
		qdel(new_body)
		return

	var/underwear = stored_data["underwear"]
	if (underwear)
		new_body.underwear = underwear

	var/underwear_color = stored_data["underwear_color"]
	if (underwear_color)
		new_body.underwear_color = underwear_color

	// Revive the new body
	new_body.revive(full_heal = TRUE, admin_revive = FALSE)
	new_body.updateappearance()

	new_body.equipOutfit(/datum/outfit/job/patient)
	new_body.ckey = ckey

	if (!new_body.ckey)
		log_game("Hatchery: Created a new body for [real_name] without a ckey.")
		FailureResponse("ERROR: No prior brain activity detected.", real_name)
		qdel(new_body)
		return

	var/assigned_role = stored_data["assigned_role"]
	if (assigned_role)
		new_body.mind.assigned_role = assigned_role
	var/obj/item/card/id/I = new_body.get_idcard()
	var/bank_id = stored_data["bank_account"]
	new_body.account_id = bank_id
	var/datum/bank_account/B = SSeconomy.bank_accounts_by_id["[bank_id]"]
	if(B)
		I.registered_account = B
		B.bank_cards += I
	else
		to_chat(new_body, "<span class='warning'>ERROR - Could not find account information for ID preservation.</span>")

	var/list/ego_gift_list = list()
	ego_gift_list = stored_data["ego_gifts"]

	if(nopenalty)
		for(var/slot in ego_gift_list)
			var/datum/ego_gifts/the_gift = ego_gift_list[slot]
			new_body.Apply_Gift(the_gift)

	playsound(get_turf(src), 'sound/effects/bin_close.ogg', 35, 3, 3)
	playsound(get_turf(src), 'sound/misc/splort.ogg', 35, 3, 3)
	to_chat(new_body, "<span class='warning'>You have been revived in a new body, but your attributes have decreased slightly.</span>")
	stored_bodies = stored_bodies - new_body.real_name

/obj/machinery/hatchery/mouse_buckle_handling(mob/living/M, mob/living/user)
	if(!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("It doesn't look like I can't quite fit in."))
		return FALSE // Can only revive humans

	if(M == user)
		return FALSE

	if(M.stat != DEAD)
		to_chat(user, span_warning("[M] is still alive!"))
		return

	to_chat(user, span_warning("You start pulling [M] into the hatchery."))

	if(do_after(user, 2 SECONDS, target = M)) //If you're going to throw someone else, they have to be dead first.
		if(M.stat != DEAD)
			FailureResponse("ERROR: Subject not dead.")
			return
		var/mob/living/carbon/human/H = M
		if(!stored_bodies[H.real_name])
			FailureResponse("ERROR: No stored data for [H.real_name].", H.real_name)
			return
		revive_body(H.real_name, H.ckey, TRUE)

/obj/machinery/hatchery/proc/FailureResponse(reason, real_name)
	if(flick_cooldown >= world.time)
		return
	flick_cooldown = flick_cooldown_time + world.time
	flick(icon_failure, src)
	if(reason)
		say("[reason]")


/datum/outfit/job/patient
	name = "Patient"
	jobtype = /datum/job/civilian
	uniform = /obj/item/clothing/under/hospital
	suit = null
	belt = null
	ears = null
	shoes = /obj/item/clothing/shoes/sandal
	back = null
	backpack_contents = null
	box = null

/datum/outfit/job/patient/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	return

/obj/item/clothing/under/hospital
	name = "hospital gown"
	desc = "Lets you keep some mediocrum of dignity while the doctors put you back together."
	icon_state = "hospital"
	icon = 'icons/obj/clothing/ego_gear/suits.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/suit.dmi'
