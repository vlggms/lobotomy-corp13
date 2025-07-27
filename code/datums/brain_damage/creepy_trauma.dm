/datum/brain_trauma/special/obsessed
	name = "Psychotic Schizophrenia"
	desc = "Patient has a subtype of delusional disorder, becoming irrationally attached to someone."
	scan_desc = "psychotic schizophrenic delusions"
	gain_text = "If you see this message, make a github issue report. The trauma initialized wrong."
	lose_text = "<span class='warning'>The voices in your head fall silent.</span>"
	can_gain = TRUE
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_SURGERY
	var/mob/living/obsession
	var/datum/objective/spendtime/attachedobsessedobj
	var/datum/antagonist/obsessed/antagonist
	var/viewing = FALSE //it's a lot better to store if the owner is watching the obsession than checking it twice between two procs

	var/total_time_creeping = 0 //just for roundend fun
	var/time_spent_away = 0
	var/obsession_hug_count = 0

/datum/brain_trauma/special/obsessed/on_gain()

	//setup, linking, etc//
	if(!obsession)//admins didn't set one
		obsession = find_obsession()
		if(!obsession)//we didn't find one
			lose_text = ""
			qdel(src)
			return
	gain_text = "<span class='warning'>You hear a sickening, raspy voice in your head. It wants one small task of you...</span>"
	owner.mind.add_antag_datum(/datum/antagonist/obsessed)
	antagonist = owner.mind.has_antag_datum(/datum/antagonist/obsessed)
	antagonist.trauma = src
	RegisterSignal(obsession, COMSIG_MOB_EYECONTACT, PROC_REF(stare))
	..()
	//antag stuff//
	antagonist.forge_objectives(obsession.mind)
	antagonist.greet()
	RegisterSignal(owner, COMSIG_CARBON_HUG, PROC_REF(on_hug))

/datum/brain_trauma/special/obsessed/on_life()
	if(!obsession || obsession.stat == DEAD)
		viewing = FALSE//important, makes sure you no longer stutter when happy if you murdered them while viewing
		return
	if(get_dist(get_turf(owner), get_turf(obsession)) > 7)
		viewing = FALSE //they are further than our viewrange they are not viewing us
		out_of_view()
		return//so we're not searching everything in view every tick
	if(obsession in view(7, owner))
		viewing = TRUE
	else
		viewing = FALSE
	if(viewing)
		total_time_creeping += 20
		time_spent_away = 0
		if(attachedobsessedobj)//if an objective needs to tick down, we can do that since traumas coexist with the antagonist datum
			attachedobsessedobj.timer -= 20 //mob subsystem ticks every 2 seconds(?), remove 20 deciseconds from the timer. sure, that makes sense.
	else
		out_of_view()

/datum/brain_trauma/special/obsessed/proc/out_of_view()
	time_spent_away += 20

/datum/brain_trauma/special/obsessed/on_lose()
	..()
	owner.mind.remove_antag_datum(/datum/antagonist/obsessed)
	if(obsession)
		UnregisterSignal(obsession, COMSIG_MOB_EYECONTACT)

/datum/brain_trauma/special/obsessed/handle_speech(datum/source, list/speech_args)
	if(!viewing)
		return
	if(owner.getSanityLoss() >= owner.getMaxSanity() && social_interaction())
		speech_args[SPEECH_MESSAGE] = ""

/datum/brain_trauma/special/obsessed/proc/on_hug(mob/living/hugger, mob/living/hugged)
	if(hugged == obsession)
		obsession_hug_count++

/datum/brain_trauma/special/obsessed/proc/social_interaction()
	var/fail = FALSE //whether you can finish a sentence while doing it
	owner.stuttering = max(3, owner.stuttering)
	owner.blur_eyes(10)
	switch(rand(1,4))
		if(1)
			shake_camera(owner, 15, 1)
			owner.vomit()
			fail = TRUE
		if(2)
			INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "cough")
			owner.dizziness += 10
			fail = TRUE
		if(3)
			to_chat(owner, span_userdanger("You feel your heart lurching in your chest..."))
			owner.Stun(20)
			shake_camera(owner, 15, 1)
		if(4)
			to_chat(owner, span_warning("You faint."))
			owner.Unconscious(80)
			fail = TRUE
	return fail

// if the creep examines first, then the obsession examines them, have a 50% chance to possibly blow their cover. wearing a mask avoids this risk
/datum/brain_trauma/special/obsessed/proc/stare(datum/source, mob/living/examining_mob, triggering_examiner)
	SIGNAL_HANDLER

	if(examining_mob != owner || !triggering_examiner || prob(50))
		return

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), obsession, span_warning("You catch [examining_mob] staring at you..."), 3))
	return COMSIG_BLOCK_EYECONTACT

/datum/brain_trauma/special/obsessed/proc/find_obsession()
	var/list/viable_minds = list() //The first list, which excludes hijinks
	var/list/possible_targets = list() //The second list, which filters out silicons and simplemobs
	var/static/list/trait_obsessions = list("Mime" = TRAIT_FAN_MIME, "Clown" = TRAIT_FAN_CLOWN, "Chaplain" = TRAIT_SPIRITUAL) //Jobs and their corresponding quirks
	var/list/special_pool = list() //The special list, for quirk-based
	var/chosen_victim  //The obsession target

	for(var/mob/Player in GLOB.player_list)//prevents crewmembers falling in love with nuke ops they never met, and other annoying hijinks
		if(Player.mind && Player.stat != DEAD && !isnewplayer(Player) && !isbrain(Player) && Player.client && Player != owner && SSjob.GetJob(Player.mind.assigned_role))
			viable_minds += Player.mind
	for(var/datum/mind/possible_target in viable_minds)
		if(possible_target != owner && ishuman(possible_target.current))
			var/job = possible_target.assigned_role
			if (trait_obsessions[job] != null && HAS_TRAIT(owner, trait_obsessions[job]))
				special_pool += possible_target.current
			possible_targets += possible_target.current

	//Do we have any special target?
	if(length(special_pool))
		chosen_victim = pick(special_pool)
		return chosen_victim

	//If not, pick any other ordinary target
	if(possible_targets.len > 0)
		chosen_victim = pick(possible_targets)
	return chosen_victim
