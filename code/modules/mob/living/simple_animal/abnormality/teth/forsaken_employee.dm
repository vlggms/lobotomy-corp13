/mob/living/simple_animal/hostile/abnormality/forsaken_employee
	name = "Forsaken Employee"
	desc = "A person who seems to be wearing an L Corp Uniform and is covered in chains, as well as wearing a box with what looks like Enkephalin in it on their head."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "forsaken_employee"
	portrait = "forsaken_employee"

	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 20, 0, -80, -80),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 50, 50, 50),
	)
	work_damage_amount = 7
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/denial,
		/datum/ego_datum/armor/denial,
	)
	gift_type =  /datum/ego_gifts/denial
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	var/list/blackout_list = list()

	//Observation is mostly mirror dungeon but with some changed phrasing
	observation_prompt = "The sound of plastic crashing is accompanied by the sloshing of a liquid. <br>\
		It looks like something that used to be a fellow employee. <br>\
		Its identity is evidenced by the now-worn formal outfit and the employee card. <br>\
		The card is almost too battered and contaminated to recognize. <br>\
		Wearing a box filled with Enkephalin on their head, the employee rams it into what looks like the door to a containment unit. <br>\
		A rubber O-ring is worn around their neck. Could it be there to prevent Enkephalin from spilling?"
	observation_choices = list(
		"Cut the ring" = list(TRUE, "The blade kept bouncing off the slippery O-ring... <br>\
			\"Brgrrgh...\ <br>\
			And the submerged thing pushed you away and ran off. Did it prefer to stay like that? <br>\
			All it left was a small employee card."),
		"Don't cut the ring" = list(FALSE, "Tang- Tang- Tang- The ramming at the door and the sloshing continue. <br>\
			I keep watching and listening. A more attentive hearing reveals that the sounds have a rhythm. Perhaps there is delight to be found in it."),
	)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/ZeroQliphoth(mob/living/carbon/human/user)
	. = ..()
	datum_reference.qliphoth_change(1)
	visible_message("[src] lets out a muffled scream!")
	playsound(get_turf(src), 'sound/voice/human/malescream_6.ogg', 15, 3, 3)
	SSlobotomy_corp.AdjustGoalBoxes(-25)
	var/list/possible_areas = list()
	if(LAZYLEN(blackout_list) < 3)
		for(var/area/A in world)
			if(istype(A, /area/facility_hallway) || istype(A, /area/department_main))
				if(A.z == z && A.lightswitch == TRUE)
					possible_areas += A
		if(length(possible_areas) != 0)
			var/area/chosen_area = pick(possible_areas)
			blackout_list += chosen_area
			chosen_area.lightswitch = FALSE
			chosen_area.update_icon()
			chosen_area.power_change()
			addtimer(CALLBACK(src, PROC_REF(TurnOn), chosen_area), 10 MINUTES)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/proc/TurnOn(area/A)
	A.lightswitch = TRUE
	blackout_list -= A
	A.update_icon()
	A.power_change()
