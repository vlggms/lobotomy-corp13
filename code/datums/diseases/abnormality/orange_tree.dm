/datum/disease/orange_tree
	name = "Orange Tree Infection"
	form = "Infection"
	max_stages = 5
	stage_prob = 33
	infectivity = 100
	spread_text = "Airborne"
	disease_flags = CAN_CARRY
	spread_flags = DISEASE_SPREAD_BLOOD|DISEASE_SPREAD_AIRBORNE
	cure_text = "Nothing"
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_HARMFUL

/datum/disease/orange_tree/after_add()
	affected_mob.playsound_local(get_turf(affected_mob), 'sound/abnormalities/orangetree/light3.ogg', 100, 0)
	RegisterSignal(affected_mob, COMSIG_MOB_APPLY_DAMGE, PROC_REF(DamageCheck))

/datum/disease/orange_tree/cure()
	UnregisterSignal(affected_mob, COMSIG_MOB_APPLY_DAMGE)
	if(!ishuman(affected_mob))
		return ..()
	var/mob/living/carbon/human/H = affected_mob
	affected_mob.visible_message("<span class='nicegreen'>[H] outwardly appears to have been cleansed of the floating lights.</span>")
	if(H.sanity_lost)
		SanityCheck(TRUE)
	return ..()

/datum/disease/orange_tree/spread() //no airborne spread from a dead person
	if(affected_mob.stat >= HARD_CRIT || affected_mob.health < 0)
		cure(FALSE)
		return
	..()

/datum/disease/orange_tree/stage_act()
	. = ..()
	if(!.)
		return

	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/H = affected_mob
	if(H.on_fire) //Fire cleanses all
		cure(FALSE)
		return

	H.apply_damage((H.maxSanity * 0.06), WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	if(prob(25))
		var/turf/T = get_turf(H)
		new /obj/effect/temp_visual/dancing_lights(T)

	if(!H.sanity_lost)
		if((stage >= max_stages) && (H.sanityhealth >= (H.maxSanity * 0.75)) && prob(H.sanityhealth * 0.25))
			cure(FALSE)
		return

	if(!HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/murder/orangetree))
		addtimer(CALLBACK(src, PROC_REF(SanityCheck), FALSE), 1) //Gives sanity time to update

/datum/disease/orange_tree/proc/DamageCheck(mob/living/carbon/human/affected_mob, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = affected_mob
	if(!istype(H))
		return
	if(damagetype != RED_DAMAGE)
		return
	if(prob(1))
		cure(FALSE) //VERY small chance for red damage to cure it

/datum/disease/orange_tree/proc/SanityCheck(cured)
	var/mob/living/carbon/human/H = affected_mob
	H.visible_message("<span class='danger'>[H] begins mumbling to themselves, seemingly unaware of the rest of the world.</span>")
	QDEL_NULL(H.ai_controller)
	if(cured)
		H.ai_controller = /datum/ai_controller/insane/suicide
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/suicide)
	else
		H.ai_controller = /datum/ai_controller/insane/murder/orangetree
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/orangetree)
