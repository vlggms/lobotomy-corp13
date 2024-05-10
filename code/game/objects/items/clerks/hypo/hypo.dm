/obj/item/reagent_containers/hypospray/emais
	name = "E.M.A.I.S"
	desc = "The Emergency Medical Aid Injector and Synthesiser is a lobotomy corp favored medical device, used by the safety department to keep all employe's healthy and happy in emergency cases."
	reagent_flags = DRAINABLE
	icon_state = "clerkhypo"
	var/list/reagent_ids = list(/datum/reagent/medicine/mental_stabilizator,/datum/reagent/medicine/sal_acid,/datum/reagent/medicine/epinephrine)
	var/list/reagent_names = list()
	var/chem_capacity = 30
	var/list/datum/reagents/reagent_list = list()
	var/list/datum/hypo_upgrade/upgrades = list()
	var/list/modes = list()
	var/mode = 1
	var/bypass_protection = FALSE
	var/recharge_time = 10
	var/charge_timer = 0
	var/locked = TRUE //clerks only

/obj/item/reagent_containers/hypospray/emais/Initialize()
	. = ..()

	for(var/R in reagent_ids)
		add_reagent(R)

	START_PROCESSING(SSobj, src)


/obj/item/reagent_containers/hypospray/emais/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/hypospray/emais/process(delta_time) //Every [recharge_time] seconds, recharge some reagents for the cyborg
	regenerate_reagents()
	return TRUE

/obj/item/reagent_containers/hypospray/emais/proc/add_reagent(datum/reagent/reagent)
	reagent_ids |= reagent
	var/datum/reagents/RG = new(chem_capacity)
	RG.my_atom = src
	reagent_list += RG

	var/datum/reagents/R = reagent_list[reagent_list.len]
	R.add_reagent(reagent, chem_capacity)

	modes[reagent] = modes.len + 1

	reagent_names[initial(reagent.name)] = reagent

/obj/item/reagent_containers/hypospray/emais/proc/del_reagent(datum/reagent/reagent)
	reagent_ids -= reagent
	reagent_names -= initial(reagent.name)
	var/datum/reagents/RG
	var/datum/reagents/TRG
	for(var/i in 1 to reagent_ids.len)
		TRG = reagent_list[i]
		if (TRG.has_reagent(reagent))
			RG = TRG
			break
	if (RG)
		reagent_list -= RG
		RG.del_reagent(reagent)

		modes[reagent] = modes.len - 1

/obj/item/reagent_containers/hypospray/emais/proc/regenerate_reagents()
	for(var/i in 1 to reagent_ids.len)
		var/datum/reagents/RG = reagent_list[i]
		if(RG.total_volume < RG.maximum_volume) 	//Don't recharge reagents and drain power if the storage is full.
			RG.add_reagent(reagent_ids[i], 5)		//And fill hypo with reagent.

/obj/item/reagent_containers/hypospray/emais/attack(mob/living/carbon/M, mob/user)
	if(!clerk_check(user))
		to_chat(user,"<span class='warning'>You don't know how to use this.</span>")
		return
	if(GetCoreSuppression(/datum/suppression/safety))
		to_chat(user,"<span class='warning'>[src] seems to be remotely disabled.</span>")
		return
	var/datum/reagents/R = reagent_list[mode]
	if(!R.total_volume)
		to_chat(user, "<span class='warning'>The injector is empty!</span>")
		return
	if(!istype(M))
		return
	if(R.total_volume && M.can_inject(user, 1, user.zone_selected,bypass_protection))
		to_chat(M, "<span class='warning'>You feel a tiny prick!</span>")
		to_chat(user, "<span class='notice'>You inject [M] with the injector.</span>")
		if(M.reagents)
			var/trans = R.trans_to(M, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
			to_chat(user, "<span class='notice'>[trans] unit\s injected. [R.total_volume] unit\s remaining.</span>")

	var/list/injected = list()
	for(var/datum/reagent/RG in R.reagent_list)
		injected += RG.name
	log_combat(user, M, "injected", src, "(CHEMICALS: [english_list(injected)])")


/obj/item/reagent_containers/hypospray/emais/attack_self(mob/user)
	ChooseReagent(user)

/obj/item/reagent_containers/hypospray/emais/proc/ChooseReagent(mob/user)
	var/list/temp_reag = list()
	/// These don't just use the name of the drug via a string in the case that we change their name at any point.
	var/datum/reagent/medicine/M = /datum/reagent/medicine/epinephrine
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "health6")
	M = /datum/reagent/medicine/sal_acid
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "health5")
	M = /datum/reagent/medicine/mental_stabilizator
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "sanity5")

	for(var/reag in reagent_names) // For any added via AddReagent proc
		if(reag in temp_reag)
			continue
		temp_reag[reag] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "x3")

	var/choice = show_radial_menu(user, src, temp_reag, radius = temp_reag.len * 14, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE)
	if(!choice || !check_menu(user))
		return FALSE

	mode = modes[reagent_names[choice]]
	playsound(loc, 'sound/effects/pop.ogg', 50, FALSE)
	var/datum/reagent/R = GLOB.chemical_reagents_list[reagent_ids[mode]]
	to_chat(user, "<span class='notice'>[src] is now dispensing '[R.name]'.</span>")
	return TRUE

/obj/item/reagent_containers/hypospray/emais/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/reagent_containers/hypospray/emais/examine(mob/user)
	. = ..()
	. += DescribeContents()	//Because using the standardized reagents datum was just too cool for whatever fuckwit wrote this
	var/datum/reagent/loaded = modes[mode]
	. += "Currently loaded: [initial(loaded.name)]. [initial(loaded.description)]"
	. += "<span class='notice'><i>Alt+Click</i> to change transfer amount. Currently set to [amount_per_transfer_from_this == 5 ? "dose normally (5u)" : "microdose (2u)"].</span>"

/obj/item/reagent_containers/hypospray/emais/proc/DescribeContents()
	. = list()
	var/empty = TRUE

	for(var/datum/reagents/RS in reagent_list)
		var/datum/reagent/R = locate() in RS.reagent_list
		if(R)
			. += "<span class='notice'>It currently has [R.volume] unit\s of [R.name] stored.</span>"
			empty = FALSE

	if(empty)
		. += "<span class='warning'>It is currently empty! Allow some time for the internal synthesizer to produce more.</span>"

/obj/item/reagent_containers/hypospray/emais/AltClick(mob/living/user)
	. = ..()
	if(user.stat == DEAD || user != loc)
		return //IF YOU CAN HEAR ME SET MY TRANSFER AMOUNT TO 1
	if(amount_per_transfer_from_this == 5)
		amount_per_transfer_from_this = 2
	else
		amount_per_transfer_from_this = 5
	to_chat(user,"<span class='notice'>[src] is now set to [amount_per_transfer_from_this == 5 ? "dose normally" : "microdose"].</span>")

/obj/item/reagent_containers/hypospray/emais/attackby(obj/item/I, mob/living/user, params)
	if(istype(I,/obj/item/hypo_upgrade))
		var/obj/item/hypo_upgrade/H = I
		H.add_upgrade(src,user)


/obj/item/reagent_containers/hypospray/emais/proc/clerk_check(mob/living/carbon/human/H)
	var/list/allowed_roles = list("Clerk", "Operations Officer")
	var/datum/status_effect/chosen/C = H.has_status_effect(/datum/status_effect/chosen)
	if(C)
		to_chat(H, "<span class='notice'>A mysterious force prevents you from using this!</span>")
		return FALSE
	if(istype(H) && (H?.mind?.assigned_role in allowed_roles))
		return TRUE
	return FALSE
