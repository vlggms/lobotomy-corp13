/datum/design/borg_upgrade_medbeam
	name = "Cyborg Upgrade (Heal Beam)"
	id = "borg_upgrade_medbeam"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/medbeam
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 10000, /datum/material/plasma = 4000, /datum/material/uranium = 4000)
	construction_time = 80
	category = list("Cyborg Upgrade Modules")

/obj/item/borg/upgrade/medbeam
	name = "medical cyborg heal beam"
	desc = "An upgrade to the Medical module, installing a built-in healing beam."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = list(/obj/item/robot_model/medical)

/obj/item/borg/upgrade/medbeam/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/medbeam/cyborg/MB = new(R.model)
		R.model.basic_modules += MB
		R.model.add_module(MB, FALSE, TRUE)

/obj/item/borg/upgrade/medbeam/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/medbeam/cyborg/MB = locate() in R.model
		R.model.remove_module(MB, TRUE)

/obj/item/gun/medbeam/cyborg
	name = "Integrated Medical Beamgun"
	desc = "Advanced protonic nano-something or other miracle healing beam. Crossing its stream with another is ill-advised."
	var/power_cost = 75

/obj/item/gun/medbeam/cyborg/process_fire(atom/target, mob/living/silicon/robot/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.cell.charge < power_cost) //Check if we have enough power.
		to_chat(user, span_warning("Power inadequate to initiate beam projection."))
		LoseTarget()
		return

	playsound(target, 'sound/effects/magic.ogg', 10, TRUE, TRUE)
	. = ..()

/obj/item/gun/medbeam/cyborg/on_beam_tick(mob/living/target)
	if(!istype(loc,/mob/living/silicon/robot))
		return

	var/mob/living/silicon/robot/user = loc

	if(!user || !target) //Sanity
		LoseTarget()
		to_chat(user, span_warning("No target or user detected. Aborting."))
		return

	if(user.cell.charge < power_cost) //Check if we have enough power.
		to_chat(user, span_warning("Power inadequate to maintain beam projection."))
		LoseTarget()
		return

	user.cell.charge -= power_cost

	playsound(target, 'sound/effects/magic.ogg', 10, TRUE, TRUE)

	. = ..()

/obj/item/gun/medbeam/cyborg/attack_self(mob/living/silicon/robot/user)
	. = ..()
	LoseTarget()
	playsound(get_turf(src), 'sound/machines/chime.ogg', 30, TRUE)
	to_chat(user, span_warning("You deactivate the beam projector."))
	return


/obj/item/borg/apparatus/beaker/medical //Medborgs can now manipulate medicines and medicine containers
	name = "medicine storage apparatus"
	desc = "A special apparatus for carrying beakers, medicines and medicine containers without spilling the contents. Alt-Z or right-click to drop its contents."
	storable = list(/obj/item/reagent_containers/glass/beaker,
				/obj/item/reagent_containers/glass/bottle,
				/obj/item/reagent_containers/pill/patch,
				/obj/item/reagent_containers/medigel,
				/obj/item/reagent_containers/pill,
				/obj/item/reagent_containers/chem_pack,
				/obj/item/reagent_containers/hypospray/medipen,
				/obj/item/reagent_containers/blood)

/obj/item/borg/apparatus/beaker/medical/extra
	name = "secondary medicine storage apparatus"
	desc = "A special apparatus for carrying beakers, medicines and medicine containers without spilling the contents. Alt-Z or right-click to drop its contents."

/mob/living/silicon/robot/proc/tegu_borg_unbuckle(mob/living/M) //Allows borgs to unbuckle people via loading them.
	if(!M.buckled)
		return
	if(M.has_buckled_mobs())
		M.unbuckle_all_mobs(force = TRUE)
	M.buckled.unbuckle_mob(M, force = TRUE)

/mob/living/silicon/robot/put_in_hands(obj/item/I, del_on_fail = FALSE, merge_stacks = TRUE, forced = FALSE) //Qualify of life; puts beaker in manipulator
	. = ..()
	var/obj/item/borg/apparatus/E = locate() in model.modules // TEGUSTATION MEDBORG CHANGES -Surrealistik Feb 2020
	if(!E)
		return
	E.pre_attack(I, src)


/obj/item/organ_storage/proc/clear_organ()
	icon_state = initial(icon_state) //We need to properly update the icon and overlays by reverting to our initial state.
	desc = initial(desc)
	cut_overlays()
