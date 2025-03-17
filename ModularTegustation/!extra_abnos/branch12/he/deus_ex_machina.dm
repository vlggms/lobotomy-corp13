/mob/living/simple_animal/hostile/abnormality/branch12/deus_ex_machina
	name = "Deus Ex Machina"
	desc = "A skull in the ground, covered in wires."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "deus"

	threat_level = HE_LEVEL
	start_qliphoth = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_amount = 6
	work_damage_type = PALE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/medea,
		/datum/ego_datum/armor/branch12/medea,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/recently_departed

/mob/living/simple_animal/hostile/abnormality/branch12/deus_ex_machina/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

/mob/living/simple_animal/hostile/abnormality/branch12/deus_ex_machina/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/deus_ex_machina/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!istype(died, /mob/living/simple_animal/hostile/abnormality))
		return FALSE
	if(died.z != z)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	recently_departed = died.type
	return TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/deus_ex_machina/ZeroQliphoth()
	datum_reference.qliphoth_change(3)
	if(!recently_departed)
		return
	var/mob/living/simple_animal/hostile/abnormality/spawned = new recently_departed(get_turf(src))
	spawned.core_enabled = FALSE
	spawned.BreachEffect()
