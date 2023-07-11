/datum/suppression/control
	name = "Control Core Suppression"
	desc = "Assignments on the abnormality work consoles will be scrambled each meltdown/ordeal."
	reward_text = "All employees, including those that may join later in the shift will receive a +30 justice attribute buff."
	run_text = "The core suppression of Control department has begun. The work assignments will be scrambled each meltdown."

/datum/suppression/control/Run(run_white = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/OnMeltdown)
	OnMeltdown()

/datum/suppression/control/End()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/obj/machinery/computer/abnormality/C in GLOB.abnormality_consoles)
		C.scramble_list = list()
	// Reward!
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 30)
		to_chat(H, "<span class='notice'>You feel much better than ever before!</span>")
	new /datum/control_reward_tracker() // Gives the reward to late-joiners after it ends
	return ..()

// On lobotomy_corp meltdown event
/datum/suppression/control/proc/OnMeltdown(datum/source, ordeal = FALSE)
	var/list/normal_works = shuffle(list(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION))
	var/list/application_scramble_list = list()
	var/list/choose_from = normal_works.Copy()
	for(var/work in normal_works)
		application_scramble_list[work] = pick(choose_from - work)
		choose_from -= application_scramble_list[work]
	for(var/obj/machinery/computer/abnormality/C in GLOB.abnormality_consoles)
		C.scramble_list = application_scramble_list

// Created when control suppression ends; Used to track new spawns to apply the reward

/datum/control_reward_tracker/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, .proc/OnJoin)

/datum/control_reward_tracker/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	return ..()

// When a new employee spawns in
/datum/control_reward_tracker/proc/OnJoin(datum/source, mob/living/carbon/human/H, rank)
	SIGNAL_HANDLER
	if(!ishuman(H))
		return FALSE
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 30)
	to_chat(H, "<span class='notice'>Control core effects improved your coordination!</span>")
	return TRUE
