// Written as a joke(or torture device) on March 27th in a certain Russian town.
// If you see any mistakes in the code - you don't. Everything is flawless.

/datum/abnormality/legacy
	var/current_mood = 0
	var/maximum_mood = 100
	var/mood_change_per_sec = -0.25

/datum/abnormality/legacy/New()
	. = ..()
	MoodProcess()

/datum/abnormality/legacy/RespawnAbno()
	. = ..()
	current_mood = current.start_mood

/datum/abnormality/legacy/work_complete(mob/living/carbon/human/user, work_type, pe, work_time, was_melting, canceled)
	. = ..()
	if(pe >= success_boxes)
		MoodChange(maximum_mood*0.6)
	else if(pe >= neutral_boxes)
		MoodChange(maximum_mood*0.3)
	else
		MoodChange(-maximum_mood*0.3)

/datum/abnormality/legacy/qliphoth_change(amount, user)
	var/num = maximum_mood * (amount / qliphoth_meter_max) // Ultra lazy, but hey, less code to write
	MoodChange(num, log = TRUE, user)

/datum/abnormality/legacy/ReturnQliphothText()
	if(current_mood >= maximum_mood)
		return "<span class='notice'>Maximum mood level achieved!</span>"
	return "<span class='notice'>Current mood level: [round(current_mood)]/[maximum_mood].</span>"

/datum/abnormality/legacy/proc/MoodChange(num, log = TRUE, mob/living/carbon/human/user)
	var/old_mood = current_mood
	current_mood = clamp(current_mood + num, 0, maximum_mood)
	if(current_mood <= 0)
		current?.ZeroQliphoth(user)
		work_logs += "\[[worldtime2text()]\]: Mood level dropped to zero!"
		SSlobotomy_corp.work_logs += "\[[worldtime2text()]\] [name]: Mood level dropped to zero!"
		return
	if(log)
		work_logs += "\[[worldtime2text()]\]: Mood level [current_mood > old_mood ? "increased" : "reduced"] to [round(current_mood)]."
		SSlobotomy_corp.work_logs += "\[[worldtime2text()]\] [name]: Mood level [current_mood > old_mood ? "increased" : "reduced"] to [round(current_mood)]."
	current.OnMoodChange(user)

/datum/abnormality/legacy/proc/MoodProcess()
	if(QDELETED(src))
		return

	if(current_mood >= maximum_mood) // Mood doesn't drop for a while
		addtimer(CALLBACK(src, .proc/MoodProcess), (10 SECONDS))
	else
		addtimer(CALLBACK(src, .proc/MoodProcess), (1 SECONDS))

	if(QDELETED(current))
		return
	if(!current.IsContained())
		return
	MoodChange(mood_change_per_sec, FALSE)
