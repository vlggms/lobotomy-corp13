/obj/item/reagent_containers/hypospray/emais/combat
	name = "\improper Combat E.M.A.I.S"
	desc = "The Emergency Medical Aid Injector and Synthesiser is a medical device, modified to be used by the Disciplinary Officer on others."
	icon_state = "combat_hypo"
	reagent_flags = NONE
	reagent_ids = list(/datum/reagent/medicine/enkephalin,/datum/reagent/medicine/helapoeisis, /datum/reagent/medicine/bolus, /datum/reagent/medicine/atropine)
	chem_capacity = 10

/obj/item/reagent_containers/hypospray/emais/combat/clerk_check(mob/living/carbon/human/H)
	var/list/allowed_roles = list("Disciplinary Officer")
	var/datum/status_effect/chosen/C = H.has_status_effect(/datum/status_effect/chosen)
	if(C)
		to_chat(H, span_warning("A mysterious force prevents you from using this!"))
		return FALSE
	if(istype(H) && (H?.mind?.assigned_role in allowed_roles))
		return TRUE
	to_chat(H, span_warning("You don't know how to use this."))
	return FALSE

/obj/item/reagent_containers/hypospray/emais/combat/attack(mob/living/carbon/M, mob/user)
	if(!clerk_check(user))
		return
	if(M == user)
		to_chat(user, span_warning("You aren't permitted to use it on yourself!"))
		return
	if(GetCoreSuppression(/datum/suppression/safety))
		to_chat(user, span_warning("[src] seems to be remotely disabled."))
		return
	var/datum/reagents/R = reagent_list[mode]
	if(!R.total_volume)
		to_chat(user, span_warning("[src] is empty!"))
		return
	if(!istype(M))
		return
	if(R.total_volume && M.can_inject(user, 1, user.zone_selected,bypass_protection))
		to_chat(M, span_warning("You feel a tiny prick!"))
		to_chat(user, span_notice("You inject [M] with [src]."))
		if(M.reagents)
			var/trans = R.trans_to(M, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
			to_chat(user, span_notice("[trans] unit\s injected. [R.total_volume] unit\s remaining."))

	var/list/injected = list()
	for(var/datum/reagent/RG in R.reagent_list)
		injected += RG.name
	log_combat(user, M, "injected", src, "(CHEMICALS: [english_list(injected)])")

/obj/item/reagent_containers/hypospray/emais/combat/ChooseReagent(mob/user)
	var/list/temp_reag = list()
	/// These don't just use the name of the drug via a string in the case that we change their name at any point.
	var/datum/reagent/medicine/M = /datum/reagent/medicine/atropine
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "health6")
	M = /datum/reagent/medicine/helapoeisis
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "health5")
	M = /datum/reagent/medicine/enkephalin
	temp_reag[initial(M.name)] = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "sanity5")
	M = /datum/reagent/medicine/bolus
	temp_reag[initial(M.name)] = image(icon = 'ModularTegustation/Teguicons/status_sprites.dmi', icon_state = "burntox")

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

/obj/item/ego_weapon/ranged/bolalauncher
	name = "bola launcher"
	desc = "Fires bolas at incredibly high velocity."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "hookshotgun"
	inhand_icon_state = "shotgun"
	w_class = WEIGHT_CLASS_NORMAL
	force = 2
	max_shots = 3
	fire_delay = 10
	reloadtime = 3 SECONDS
	fire_sound = 'sound/weapons/bowfire.ogg'
	projectile_path = /obj/projectile/ego_bullet/bola

/obj/item/ego_weapon/ranged/bolalauncher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(user?.mind?.assigned_role != "Disciplinary Officer")
		to_chat(user, span_notice("You cannot use the [src]!"))
		return FALSE
	..()

/obj/projectile/ego_bullet/bola
	name = "bola"
	damage = 0
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bola"

/obj/projectile/ego_bullet/bola/on_hit(target)
	. = ..()
	if(!iscarbon(target))
		return BULLET_ACT_HIT
	var/obj/item/restraints/legcuffs/bola/disciplinary/mybolas = new(get_turf(src))
	mybolas.ensnare(target)
	return BULLET_ACT_HIT

/obj/item/restraints/legcuffs/bola/disciplinary
	breakouttime = 10 //easier to apply, easier to break out of

/obj/item/restraints/legcuffs/bola/disciplinary/dropped(mob/user, silent = FALSE)
	. = ..()
	qdel(src)

/obj/item/restraints/legcuffs/bola/disciplinary/ensnare(mob/living/carbon/C)
	if(!C.legcuffed && C.num_legs >= 2)
		visible_message("<span class='danger'>\The [src] ensnares [C]!</span>")
		C.legcuffed = src
		forceMove(C)
		C.update_equipment_speed_mods()
		C.update_inv_legcuffed()
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		to_chat(C, "<span class='userdanger'>\The [src] ensnares you!</span>")
		C.Knockdown(knockdown)
		playsound(src, 'sound/effects/snap.ogg', 50, TRUE)
		return
	qdel(src) // deleted if we dont restrain the target.

/obj/item/restraints/legcuffs/bola/disciplinary/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE, quickstart = TRUE)
	qdel(src)
	return FALSE // Should prevent runtimes if players somehow get one
