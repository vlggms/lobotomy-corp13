/datum/disease/bee_spawn
	name = "Bee Infection"
	form = "Infection"
	max_stages = 5
	stage_prob = 33
	spread_text = "Blood"
	disease_flags = CAN_CARRY
	spread_flags = DISEASE_SPREAD_BLOOD
	cure_text = "Nothing"
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_HARMFUL

/datum/disease/bee_spawn/after_add()
	affected_mob.playsound_local(get_turf(affected_mob), 'sound/abnormalities/bee/infect.ogg', 25, 0)

/datum/disease/bee_spawn/stage_act()
	. = ..()
	if(!.)
		return

	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/H = affected_mob
	H.apply_damage(stage*2, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

	if(H.health <= 0)
		var/turf/T = get_turf(H)
		H.visible_message("<span class='danger'>[H] explodes in a shower of gore, as a giant bee appears out of [H.p_them()]!</span>")
		H.emote("scream")
		H.gib()
		new /mob/living/simple_animal/hostile/worker_bee(T)
		return

	if((stage >= max_stages) && (H.health >= (H.maxHealth * 0.75)) && prob(H.health * 0.25))
		cure(FALSE)
