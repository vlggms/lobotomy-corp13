GLOBAL_VAR_INIT(emergency_level, TRUMPET_0)

SUBSYSTEM_DEF(lobotomy_emergency)
	name = "Lobotomy Emergency System"
	flags = SS_KEEP_TIMING | SS_BACKGROUND | SS_NO_FIRE

	//We Really REALLY don't want it to calc the score in modes where it wouldn't make sense or would cause issues with how the rounds work.
	var/should_calc_score = TRUE
	var/current_score = 0
	var/score_cap = 100
	var/score_min = 0
	//The amount of score that decreases over time
	var/score_decay = -5

	//Used for Abnormalities and Agents. We don't want to go to nearly trumpet 3 instantly if an aleph breaches while everyone has aleph gear.
	var/score_divider = 1
	//Used as the maxium amount it can divide by
	var/divide_cap = 4

	var/ordeal_amount = 20

	var/agent_panic = 10
	var/agent_death = 20

	var/list/threat_to_score = list(5,20,40,60,75)

	//The score needed to reach the first trumpet
	var/trumpet_1 = 10
	//The score needed to reach the second trumpet
	var/trumpet_2 = 50
	//The score needed to reach the third trumpet
	var/trumpet_3 = 80

	var/score_timer = null
	var/short_timer = 5 SECONDS
	var/long_timer = 30 SECONDS

/datum/controller/subsystem/lobotomy_emergency/Initialize(timeofday)
	if((SSmaptype.maptype in SSmaptype.combatmaps) || SSmaptype.maptype == "enkephalin_rush") // sleep
		flags |= SS_NO_FIRE
		should_calc_score = FALSE
		return ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath))
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE, PROC_REF(OnHumanInsane))
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))
	return ..()

/datum/controller/subsystem/lobotomy_emergency/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!is_station_level(died.z))
		return
	if(istype(died, /mob/living/simple_animal/hostile/abnormality) || istype(died, /mob/living/simple_animal/hostile/aminion))
		UpdateMin()
	if(!ishuman(died))
		return
	var/mob/living/carbon/human/H = died
	var/agent_count = 1 + (length(AllLivingAgents(TRUE)) - 1)/4 //More agents means each one's death means less
	if(!H.mind)
		return
	if((H.mind.assigned_role in GLOB.security_positions))
		UpdateScore((agent_death * get_user_level(H))/agent_count)//If a higher level agent dies it should probably matter more

/datum/controller/subsystem/lobotomy_emergency/proc/OnHumanInsane(datum/source, mob/living/carbon/human/H, attribute)
	SIGNAL_HANDLER
	if(!is_station_level(H.z))
		return
	var/agent_count = 1 + (length(AllLivingAgents(TRUE)) - 1)/4 //More agents means each one's panic means less
	if(!H.mind)
		return
	if((H.mind.assigned_role in GLOB.security_positions))
		UpdateScore((agent_death * get_user_level(H))/agent_count)//If a higher level agent panics it should probably matter more


/datum/controller/subsystem/lobotomy_emergency/proc/OnAbnoMinionSpawn(mob/living/simple_animal/hostile/M)
	if(!is_station_level(M.z))
		return
	if(!M?:can_affect_emergency)
		return
	if(M?:set_score)
		UpdateScore(M?:set_score, FALSE)
		return
	UpdateScore(threat_to_score[M.threat_level]/M?:score_divider)

/datum/controller/subsystem/lobotomy_emergency/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(!is_station_level(abno.z))
		return
	if(!abno.can_affect_emergency)
		return
	if(abno.set_score)
		UpdateScore(abno.set_score, FALSE)
		return
	var/addedscore = threat_to_score[abno.threat_level]/abno.score_divider
	UpdateScore(addedscore)

/datum/controller/subsystem/lobotomy_emergency/proc/UpdateMin()
	if(!should_calc_score)
		return
	var/min = 0
	for(var/mob/living/simple_animal/hostile/A in GLOB.abnormality_minion_list)
		if(!A?:can_affect_emergency || !A?:can_affect_min)
			continue
		if(A.stat == DEAD)//The dead shouldn't count
			continue
		var/added_min = threat_to_score[A.threat_level]/(A?:score_divider * score_divider * 2)
		if(A?:set_score)
			min += A?:set_score
		else
			min += added_min

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if(!A.can_affect_emergency || !A.can_affect_min)
			continue
		if(A.IsContained())
			continue
		if(A.stat == DEAD)//The dead shouldn't count
			continue
		var/added_min = threat_to_score[A.threat_level]/(A.score_divider * score_divider * 2)
		if(A.set_score)
			min += A.set_score
		else
			min += added_min

	if(LAZYLEN(SSlobotomy_corp.current_ordeals))
		min += SSlobotomy_corp.current_ordeals.len * (ordeal_amount/2)
	if(SSlobotomy_corp.shuttle) //A pretty half assed fix to make sure it doesn't lower when the shuttle is comming
		min += 1
	score_min = min(score_cap, min)
	SSlobotomy_corp.DoRestartCheck()

/datum/controller/subsystem/lobotomy_emergency/proc/UpdateScore(amount, divide_score = TRUE, long_cooldown = TRUE)
	if(divide_score)
		amount /= score_divider
	UpdateMin()
	current_score = clamp(current_score + amount, score_min, score_cap)
	CalculateEmergencyLevel(long_cooldown)

/datum/controller/subsystem/lobotomy_emergency/proc/SetScore(amount, long_cooldown = TRUE)
	UpdateMin()
	current_score = clamp(amount, score_min, score_cap)
	CalculateEmergencyLevel(long_cooldown)

/datum/controller/subsystem/lobotomy_emergency/proc/CalculateEmergencyLevel(long_cooldown = TRUE)
	var/level
	var/time = short_timer
	if(long_cooldown)
		time = long_timer
	if(current_score == 0)
		level = TRUMPET_0
	else if(current_score >= trumpet_1 && current_score < trumpet_2)
		level = TRUMPET_1
	else if(current_score >= trumpet_2 && current_score < trumpet_3)
		level = TRUMPET_2
	else if(current_score >= trumpet_3)
		level = TRUMPET_3
	if(score_timer)
		deltimer(score_timer)
	if(current_score > 0)//It probably shouldn't constantly check unless it has a reason to
		score_timer = addtimer(CALLBACK(src, PROC_REF(UpdateScore), score_decay, FALSE, FALSE), time, TIMER_STOPPABLE)
	if((level == TRUMPET_0 && GLOB.emergency_level != TRUMPET_0) || GLOB.emergency_level < level)//We don't want it to go off every time the score changes
		SetEmergencyLevel(num2emgcylevel(level))

/datum/controller/subsystem/lobotomy_emergency/proc/SetEmergencyLevel(level, forced = FALSE)
	switch(level)
		if("no emergency")
			level = TRUMPET_0
		if("first trumpet")
			level = TRUMPET_1
		if("second trumpet")
			level = TRUMPET_2
		if("third trumpet")
			level = TRUMPET_3

	if(forced)
		switch(level)
			if(TRUMPET_0)
				current_score = 0
			if(TRUMPET_1)
				current_score = trumpet_1
			if(TRUMPET_2)
				current_score = trumpet_2
			if(TRUMPET_3)
				current_score = trumpet_3

	switch(level)
		if(TRUMPET_0)
			custom_minor_announce(CONFIG_GET(string/alert_warning_reset), "Attention!")
			if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
				if(GLOB.emergency_level >= TRUMPET_2)
					SSshuttle.emergency.modTimer(4)
				else
					SSshuttle.emergency.modTimer(2)
			GLOB.emergency_level = TRUMPET_0
			for(var/obj/machinery/firealarm/FA in GLOB.machines)
				if(is_station_level(FA.z))
					FA.update_icon()
		if(TRUMPET_1)
			custom_minor_announce(CONFIG_GET(string/alert_first_trumpet), "Attention! First Trumpet!",'sound/misc/siren.ogg', newvolume = 10)
			if(GLOB.emergency_level < TRUMPET_1)
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					SSshuttle.emergency.modTimer(0.5)
			else
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					SSshuttle.emergency.modTimer(2)
			GLOB.emergency_level = TRUMPET_1
			for(var/obj/machinery/firealarm/FA in GLOB.machines)
				if(is_station_level(FA.z))
					FA.update_icon()
		if(TRUMPET_2)
			custom_minor_announce(CONFIG_GET(string/alert_second_trumpet), "Attention! Second Trumpet!",'sound/effects/alertbeep.ogg', newvolume = 10)
			if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
				if(GLOB.emergency_level == TRUMPET_1)
					SSshuttle.emergency.modTimer(0.25)
				else
					SSshuttle.emergency.modTimer(0.5)
			GLOB.emergency_level = TRUMPET_2
			for(var/obj/machinery/firealarm/FA in GLOB.machines)
				if(is_station_level(FA.z))
					FA.update_icon()
			for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
				pod.locked = FALSE
		if(TRUMPET_3)
			custom_minor_announce(CONFIG_GET(string/alert_third_trumpet), "Attention! Third Trumpet!",'sound/misc/notice1.ogg')
			if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
				if(GLOB.emergency_level == TRUMPET_0)
					SSshuttle.emergency.modTimer(0.25)
				else if(GLOB.emergency_level == TRUMPET_1)
					SSshuttle.emergency.modTimer(0.5)
			GLOB.emergency_level = TRUMPET_3
			current_score = trumpet_3
			for(var/obj/machinery/firealarm/FA in GLOB.machines)
				if(is_station_level(FA.z))
					FA.update_icon()
			for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
				pod.locked = FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_TRUMPET_CHANGED, level)
	if(current_score > 0)
		if(score_timer)
			deltimer(score_timer)
		score_timer = addtimer(CALLBACK(src, PROC_REF(UpdateScore), score_decay, FALSE, FALSE), long_timer, TIMER_STOPPABLE)
	for(var/area/facility_hallway/F in GLOB.sortedAreas)
		F.RefreshLights()
	for(var/area/department_main/D in GLOB.sortedAreas)
		D.RefreshLights()
	if(level >= TRUMPET_2)
		for(var/obj/machinery/door/D in GLOB.machines)
			if(D.red_alert_access)
				D.visible_message("<span class='notice'>[D] whirrs as it automatically lifts access requirements!</span>")
				playsound(D, 'sound/machines/boltsup.ogg', 50, TRUE)
	SSblackbox.record_feedback("tally", "security_level_changes", 1, get_emergency_level())
	RefreshTrumpetLevelEffects()

/proc/get_emergency_level()
	switch(GLOB.emergency_level)
		if(TRUMPET_0)
			return "no emergency"
		if(TRUMPET_1)
			return "first trumpet"
		if(TRUMPET_2)
			return "second trumpet"
		if(TRUMPET_3)
			return "third trumpet"
		if(TRUMPET_4)
			return "fourth trumpet"

/proc/num2emgcylevel(num)
	switch(num)
		if(TRUMPET_0)
			return "no emergency"
		if(TRUMPET_1)
			return "first trumpet"
		if(TRUMPET_2)
			return "second trumpet"
		if(TRUMPET_3)
			return "third trumpet"
		if(TRUMPET_4)
			return "fourth trumpet"

/proc/emgcylevel2num(trumpetlevel)
	switch( lowertext(trumpetlevel) )
		if("no emergency")
			return TRUMPET_0
		if("first trumpet")
			return TRUMPET_1
		if("second trumpet")
			return TRUMPET_2
		if("third trumpet")
			return TRUMPET_3
		if("fourth trumpet")
			return TRUMPET_4

/proc/RefreshTrumpetLevelEffects()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		ApplyTrumpetLevelEffect(H)

/proc/ApplyTrumpetLevelEffect(mob/living/carbon/human/H)
	H.remove_status_effect(/datum/status_effect/trumpetlevel)
	switch(GLOB.emergency_level)
		if(TRUMPET_1)
			H.apply_status_effect(/datum/status_effect/trumpetlevel/level1)
		if(TRUMPET_2)
			H.apply_status_effect(/datum/status_effect/trumpetlevel/level2)
		if(TRUMPET_3)
			H.apply_status_effect(/datum/status_effect/trumpetlevel/level3)
		if(TRUMPET_4)
			H.apply_status_effect(/datum/status_effect/trumpetlevel/level4)

/datum/status_effect/trumpetlevel
	id = "trumpet level buff"
	tick_interval = -1
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/trumpetlevel
	var/justice = 0
	var/work_speed = 0
	var/fortitude = 0
	var/prudence = 0

/atom/movable/screen/alert/status_effect/trumpetlevel
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	name = "Security Alert"
	desc = "Something's wrong; Justice is increased and Work speed is reduced."

/datum/status_effect/trumpetlevel/on_apply()
	. = ..()
	if(!ishuman(owner))
		qdel(src)
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, justice)
	H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, fortitude)
	H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, prudence)
	H.physiology.work_speed_mod *= work_speed

/datum/status_effect/trumpetlevel/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -justice)
	H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -fortitude)
	H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -prudence)
	H.physiology.work_speed_mod /= work_speed
	. = ..()

/datum/status_effect/trumpetlevel/level1
	justice = 10
	work_speed = 0.9
	alert_type = /atom/movable/screen/alert/status_effect/trumpetlevel/level1

/atom/movable/screen/alert/status_effect/trumpetlevel/level1
	icon_state = "level1"
	name = "First Trumpet"

/datum/status_effect/trumpetlevel/level2
	justice = 15
	work_speed = 0.8
	alert_type = /atom/movable/screen/alert/status_effect/trumpetlevel/level2

/atom/movable/screen/alert/status_effect/trumpetlevel/level2
	icon_state = "level2"
	name = "Second Trumpet"

/datum/status_effect/trumpetlevel/level3
	justice = 25
	work_speed = 0.6
	alert_type = /atom/movable/screen/alert/status_effect/trumpetlevel/level3

/atom/movable/screen/alert/status_effect/trumpetlevel/level3
	icon_state = "level3"
	name = "Third Trumpet"

/datum/status_effect/trumpetlevel/level4
	justice = 20
	fortitude = 20
	prudence = 20
	work_speed = 1
	alert_type = /atom/movable/screen/alert/status_effect/trumpetlevel/level4

/atom/movable/screen/alert/status_effect/trumpetlevel/level4
	icon_state = "level4"
	name = "Fourth Trumpet"
	desc = "Shit's fucked; Fortitude, Prudence and Justice are increased."
