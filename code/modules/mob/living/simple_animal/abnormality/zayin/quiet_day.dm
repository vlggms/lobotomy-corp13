#define STATUS_EFFECT_WAR_STORY /datum/status_effect/quiet/warstory
#define STATUS_EFFECT_PARABLE /datum/status_effect/quiet/parable
#define STATUS_EFFECT_WIFE_STORY /datum/status_effect/quiet/wife
#define STATUS_EFFECT_DEMENTIA_RAMBLINGS /datum/status_effect/quiet/dementia
/mob/living/simple_animal/hostile/abnormality/quiet_day
	name = "A Quiet Day"
	desc = "An old weather damaged bench, it feels oddly nostalgic to you. Like a spring day at the side of a lake."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "quiet_day"
	maxHealth = 400
	health = 400
	threat_level = ZAYIN_LEVEL

	//Bad for stat gain, but the damage is negligable and there's a nice bonus at the end
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/nostalgia,
		/datum/ego_datum/armor/nostalgia
	)
	chem_type = /datum/reagent/abnormality/quiet_day
	harvest_phrase = "<span class='notice'>%ABNO looks curiously at %VESSEL for a moment. You blink, and suddenly, it seems to contain a shadowy substance.</span>"
	harvest_phrase_third = "%ABNO glances at %PERSON. Suddenly, %VESSEL seems to be more full."

	gift_type =  /datum/ego_gifts/nostalgia
	var/buff_given
	var/datum/looping_sound/quietday_ambience/soundloop

	var/list/war_story = list("Ah, I see you're interested in hearing about my experiences in the Smoke Wars. I'm happy to oblige.",
	"During my time in the war, I served as a medic for L Corp, It was a grueling and heartbreaking experience, seeing so many young men and women injured or killed in the line of duty.",
	"It was a foggy morning, and our unit was tasked with holding a hallway of the nest against the enemy's advance.",
	"The smoke from the gunfire and explosions made it difficult to see more than a few feet in front of us, but we knew the enemy was out there, somewhere.",
	"We took heavy losses. I remember patching up wounded soldiers as quickly as I could, trying to keep them alive long enough to get them to a field hospital.",
	"At one point, while pulling a wounded lady back to safety I found myself alone. I could hear the sound of footsteps approaching, and I readied myself for a fight.",
	"But as the figure emerged from around the corner, I saw that it was a young zwei fixer, barely more than a boy.",
	"He was clutching his side, blood seeping through his uniform. I could tell from the look on his face that he was terrified, and I did my best to calm him down as I worked on his wounds.",
	"As I finished up my work and prepared to help him to safety, he looked up at me with tears in his eyes and said, 'Thank you, sir. You're a true gentleman.'",
	"That was the last I heard of him. I was shot in the back before I could pull the wounded woman back to safety.")

	var/list/parable = list("Certainly, I would be happy to share a parable with you.",
	"Once upon a time, in a small village nestled in a valley, there lived a wise old man. One day, a young traveler came to the village and sought out the old man, hoping to learn from his wisdom.",
	"The young traveler asked the old man, 'What is the secret to a happy and fulfilled life?' The old man replied, 'I will show you.'",
	"He took the young traveler to a nearby river and led him into the water. As they waded into the shallows, the old man suddenly grabbed the young man's head and held it under the water.",
	"At first, the young traveler struggled and fought against the old man's grip, desperate for air. But as he began to lose consciousness, the old man released him and helped him back up to the surface.",
	"The young traveler gasped for air, coughing and sputtering, and demanded to know why the old man had done such a thing. The old man replied, 'When you were underwater, what did you want more than anything else in the world?'.",
	"The young traveler thought for a moment and then replied, 'Air. I wanted air more than anything.'",
	"The old man smiled and said, 'Exactly. The secret to a happy and fulfilled life is to want something as much as you wanted air when you were underwater. That kind of drive and determination will help you achieve anything you set your mind to.'")

	var/list/wife = list("Certainly, I would be happy to share a story about my dear wife",
	"My wife and I were both from L Corporation, and we worked together in the same office for many years. We had a special bond, not just as husband and wife, but also as coworkers who shared a passion for our profession.",
	"One day, she looked extremely stressed.",
	"I asked her if everything was okay, and she confided in me that she was worried about a mistake she had made in one of the reports.",
	"I am a very calm man, I reassured her that we would work together to fix the mistake and make sure that everything was correct. We spent the rest of the night poring over the reports, double-checking to make sure that everything was accurate.",
	"By the time we finished, it was already well past midnight. We were both exhausted, but also relieved and proud of the work we had done. We hugged each other and I told my wife how much I appreciated her dedication and hard work.",
	"She was quite the fiery woman, but I loved her so very much. I still miss her this very day, I hope she made it out of the nest.")

	var/list/dementia = list("I'm sorry, what was your name again? My memory isn't what it used to be.",
	"I remember a time when we used to... oh, wait, where was I going with this?",
	"Sometimes, I feel like my memory is slipping away. But I still have all these stories and experiences inside me that I want to share.",
	"I'm having trouble finding the right words to express myself. Please bear with me.",
	"I'm sorry, my mind isn't as sharp as it used to be. Could you please repeat what you said?",
	"Oh dear, where did I put my glasses? I can't seem to find them anywhere.",
	"Now, what was I going to say? It's right on the tip of my tongue...",
	"I think I've seen you somewhere before, haven't I? Or am I mistaken?",
	"Sometimes my mind feels like a jumbled mess. I wish I could straighten it all out."
	)

/mob/living/simple_animal/hostile/abnormality/quiet_day/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(pe == 0)
		return
	buff_given = work_type
	TalkStart(user)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/TalkStart(mob/living/carbon/human/user)
	icon_state = "quiet_ghost"
	switch(buff_given)
		if(ABNORMALITY_WORK_INSTINCT)
			for(var/line in war_story)
				say(line)
				SLEEP_CHECK_DEATH(50)
				if(PlayerCheck(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_INSIGHT)
			for(var/line in parable)
				say(line)
				SLEEP_CHECK_DEATH(50)
				if(PlayerCheck(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_ATTACHMENT)
			for(var/line in wife)
				say(line)
				SLEEP_CHECK_DEATH(50)
				if(PlayerCheck(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_REPRESSION)
			for(var/i=7, i>=1, i--)
				var/current = pick(dementia)
				dementia -= current
				say(current)
				SLEEP_CHECK_DEATH(50)
				if(PlayerCheck(user))
					dementia = initial(dementia)
					ResetIcon()
					return
			dementia = initial(dementia)

	TalkEnd(user)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/TalkEnd(mob/living/carbon/human/user)
	ResetIcon()
	switch(buff_given)
		if(ABNORMALITY_WORK_INSTINCT)
			user.apply_status_effect(STATUS_EFFECT_WAR_STORY)

		if(ABNORMALITY_WORK_INSIGHT)
			user.apply_status_effect(STATUS_EFFECT_PARABLE)

		if(ABNORMALITY_WORK_ATTACHMENT)
			user.apply_status_effect(STATUS_EFFECT_WIFE_STORY)

		else
			user.apply_status_effect(STATUS_EFFECT_DEMENTIA_RAMBLINGS)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/ResetIcon()
	icon_state = "quiet_day"

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/PlayerCheck(mob/living/carbon/human/user)
	if(!(user in view(5, src)))
		say("Ah, I supposed we can continue this another time.")
		return TRUE
	else
		return FALSE

/atom/movable/screen/alert/status_effect/quiet
	name = "A Quiet Day"
	desc = "You listened to the old man's story."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "rest"	//Guh I suck at status sprites but I'm also broke

//A Quiet day
//A simple 5 minute stat buff
/datum/status_effect/quiet
	id = "quiet_day"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000		//Lasts 5 minutes
	alert_type = /atom/movable/screen/alert/status_effect/quiet
	var/attribute_buff = FORTITUDE_ATTRIBUTE

/datum/status_effect/quiet/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(attribute_buff, 15)

/datum/status_effect/quiet/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(attribute_buff, -15)


//Here so that the defines work
/datum/status_effect/quiet/warstory

//Parable
/datum/status_effect/quiet/parable
	attribute_buff = PRUDENCE_ATTRIBUTE

//Wife Story
/datum/status_effect/quiet/wife
	attribute_buff = TEMPERANCE_ATTRIBUTE

//Dementia
/datum/status_effect/quiet/dementia
	attribute_buff = JUSTICE_ATTRIBUTE


#undef STATUS_EFFECT_WAR_STORY
#undef STATUS_EFFECT_PARABLE
#undef STATUS_EFFECT_WIFE_STORY
#undef STATUS_EFFECT_DEMENTIA_RAMBLINGS

/datum/reagent/abnormality/quiet_day
	name = "Liquid Nostalgia"
	description = "A deep, dark-colored goo. Looking at it, you're almost convinced you see something more."
	color = "#110320"
	sanity_restore = -2
	stat_changes = list(2, 2, 2, 2) // Sort of reverse bottle. Stat gain for ongoing sanity loss. Not a huge stat gain since it's split into four, but something.

//Audiovisual stuff
/mob/living/simple_animal/hostile/abnormality/quiet_day/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/quiet_day/Destroy()
	QDEL_NULL(soundloop)
	..()
