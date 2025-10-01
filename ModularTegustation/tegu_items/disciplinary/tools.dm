/obj/item/reagent_containers/hypospray/emais/combat
	name = "\improper Combat E.M.A.I.S"
	desc = "The Emergency Medical Aid Injector and Synthesiser is a medical device, modified to be used by the Disciplinary Officer on others."
	icon_state = "combat_hypo"
	reagent_flags = NONE
	reagent_ids = list(/datum/reagent/medicine/omnizine, /datum/reagent/medicine/atropine)
	chem_capacity = 10
	var/current_holder = null

/obj/item/reagent_containers/hypospray/emais/combat/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/reagent_containers/hypospray/emais/combat/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/reagent_containers/hypospray/emais/combat/clerk_check(mob/living/carbon/human/H)
	var/list/allowed_roles = list("Disciplinary Officer")
	var/datum/status_effect/chosen/C = H.has_status_effect(/datum/status_effect/chosen)
	if(H == current_holder)
		to_chat(H, span_warning("You aren't permitted to use it on yourself!"))
		return FALSE
	if(C)
		to_chat(H, span_warning("A mysterious force prevents you from using this!"))
		return FALSE
	if(istype(H) && (H?.mind?.assigned_role in allowed_roles))
		return TRUE
	to_chat(H, span_warning("You don't know how to use this."))
	return FALSE

/obj/item/reagent_containers/hypospray/emais/combat/ChooseReagent(mob/user)
	var/list/temp_reag = list()
	/// These don't just use the name of the drug via a string in the case that we change their name at any point.
	var/datum/reagent/medicine/M = /datum/reagent/medicine/atropine
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "health6")
	M = /datum/reagent/medicine/omnizine
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "health4")

	for(var/reag in reagent_names) // For any added via AddReagent proc
		if(reag in temp_reag)
			continue
		temp_reag[reag] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "x3")

	var/choice = show_radial_menu(user, src, temp_reag, radius = temp_reag.len * 14, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE)
	if(!choice || !check_menu(user))
		return FALSE

	mode = modes[reagent_names[choice]]
	playsound(loc, 'sound/effects/pop.ogg', 50, FALSE)
	var/datum/reagent/R = GLOB.chemical_reagents_list[reagent_ids[mode]]
	to_chat(user, span_notice("[src] is now dispensing '[R.name]'."))
	return TRUE
