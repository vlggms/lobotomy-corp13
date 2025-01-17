#define STATUS_EFFECT_WAR_STORY /datum/status_effect/quiet/warstory
#define STATUS_EFFECT_PARABLE /datum/status_effect/quiet/parable
#define STATUS_EFFECT_WIFE_STORY /datum/status_effect/quiet/wife
#define STATUS_EFFECT_DEMENTIA_RAMBLINGS /datum/status_effect/quiet/dementia

/mob/living/simple_animal/hostile/abnormality/quiet_day
	name = "A Quiet Day"
	desc = "An old weather damaged bench, it feels oddly nostalgic to you. Like a spring day at the side of a lake."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "quiet_day"
	core_icon = "quiet_day"
	maxHealth = 451
	health = 451
	blood_volume = 0
	threat_level = ZAYIN_LEVEL
	faction = list("hostile", "neutral")
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
		/datum/ego_datum/armor/nostalgia,
	)
	gift_type =  /datum/ego_gifts/nostalgia

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/mhz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/khz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/army = 1.5,
	)

	chem_type = /datum/reagent/abnormality/quiet_day
	harvest_phrase = span_notice("%ABNO looks curiously at %VESSEL for a moment. You blink, and suddenly, it seems to contain a shadowy substance.")
	harvest_phrase_third = "%ABNO glances at %PERSON. Suddenly, %VESSEL seems to be more full."

	observation_prompt = "The shadow of an old man seems to be contemplating about something. <br>\
		\"Don't you ever wish you could go back to those better times? To be able to enjoy life to the fullest? <br>\
		To relive the best moments of your life again? <br>\
		To remember her face? To remember that young man's name? <br>\
		Perhaps it's foolish of me to ask for this. I want to hear your opinion, young'in. <br>\
		Would it be worth chasing after those old, familiar memories?\""
	observation_choices = list(
		"Perhaps it's better to move on." = list(TRUE, "\"I suppose you're right after all.\" <br>\
			\"If I can't even remember their names and faces, what worth even are those memories?\" <br>\
			\"Go on. Leave before you forget too.\""),
		"It's not wrong." = list(FALSE, "\"Indeed. There's no harm, right?\" <br>\
			\"...Yet why can't I remember her face?\" <br>\
			As you're about to leave, you hear the old man croak out something. \"Who are you again?\""),
	)

	var/performed_work
	var/datum/looping_sound/quietday_ambience/soundloop

	var/list/war_story = list(
		"Ah, I see you're interested in hearing about my experiences in the Smoke Wars. I'm happy to oblige.",
		"During my time in the war, I served as a medic for L Corp, It was a grueling and heartbreaking experience, seeing so many young men and women injured or killed in the line of duty.",
		"It was a foggy morning, and our unit was tasked with holding a hallway of the nest against the enemy's advance.",
		"The smoke from the gunfire and explosions made it difficult to see more than a few feet in front of us, but we knew the enemy was out there, somewhere.",
		"We took heavy losses. I remember patching up wounded soldiers as quickly as I could, trying to keep them alive long enough to get them to a field hospital.",
		"At one point, while pulling a wounded lady back to safety I found myself alone. I could hear the sound of footsteps approaching, and I readied myself for a fight.",
		"But as the figure emerged from around the corner, I saw that it was a young zwei fixer, barely more than a boy.",
		"He was clutching his side, blood seeping through his uniform. I could tell from the look on his face that he was terrified, and I did my best to calm him down as I worked on his wounds.",
		"As I finished up my work and prepared to help him to safety, he looked up at me with tears in his eyes and said, \"Thank you, sir. You're a true gentleman.\"",
		"That was the last I heard of him. I was shot in the back before I could pull the wounded woman back to safety.",
	)

	var/list/parable = list(
		"Certainly, I would be happy to share a parable with you.",
		"Once upon a time, in a small village nestled in a valley, there lived a wise old man. One day, a young traveler came to the village and sought out the old man, hoping to learn from his wisdom.",
		"The young traveler asked the old man, \"What is the secret to a happy and fulfilled life?\" The old man replied, \"I will show you.\"",
		"He took the young traveler to a nearby river and led him into the water. As they waded into the shallows, the old man suddenly grabbed the young man's head and held it under the water.",
		"At first, the young traveler struggled and fought against the old man's grip, desperate for air. But as he began to lose consciousness, the old man released him and helped him back up to the surface.",
		"The young traveler gasped for air, coughing and sputtering, and demanded to know why the old man had done such a thing. The old man replied, \"When you were underwater, what did you want more than anything else in the world?\".",
		"The young traveler thought for a moment and then replied, \"Air. I wanted air more than anything.\"",
		"The old man smiled and said, \"Exactly. The secret to a happy and fulfilled life is to want something as much as you wanted air when you were underwater. That kind of drive and determination will help you achieve anything you set your mind to.\"",
	)

	var/list/wife = list(
		"Certainly, I would be happy to share a story about my dear wife",
		"My wife and I were both from L Corporation, and we worked together in the same office for many years. We had a special bond, not just as husband and wife, but also as coworkers who shared a passion for our profession.",
		"One day, she looked extremely stressed.",
		"I asked her if everything was okay, and she confided in me that she was worried about a mistake she had made in one of the reports.",
		"I am a very calm man, I reassured her that we would work together to fix the mistake and make sure that everything was correct. We spent the rest of the night poring over the reports, double-checking to make sure that everything was accurate.",
		"By the time we finished, it was already well past midnight. We were both exhausted, but also relieved and proud of the work we had done. We hugged each other and I told my wife how much I appreciated her dedication and hard work.",
		"She was quite the fiery woman, but I loved her so very much. I still miss her this very day, I hope she made it out of the nest.",
	)

	var/list/dementia = list(
		"I'm sorry, what was your name again? My memory isn't what it used to be.",
		"I remember a time when we used to... oh, wait, where was I going with this?",
		"Sometimes, I feel like my memory is slipping away. But I still have all these stories and experiences inside me that I want to share.",
		"I'm having trouble finding the right words to express myself. Please bear with me.",
		"I'm sorry, my mind isn't as sharp as it used to be. Could you please repeat what you said?",
		"Oh dear, where did I put my glasses? I can't seem to find them anywhere.",
		"Now, what was I going to say? It's right on the tip of my tongue...",
		"I think I've seen you somewhere before, haven't I? Or am I mistaken?",
		"Sometimes my mind feels like a jumbled mess. I wish I could straighten it all out.",
	)

	var/list/catt = list(
		"Once upon a time, there lived a small kitten and their pack of friends...",
		"The small kitten looked up to their friends, and in turn their friends lead them down the straight path.",
		"Then one day, the small kitten's friends got in trouble, and the small kitten, being small and only having followed their lead, could do nothing.",
		"So the kitten's friends died and left the little kitten alone. Heartbroken, the kitten swore they'd never care for another so long as they lived.",
		"Years passed, and the kitten, now grown, became a powerful lion. Powerful and uncaring, they tore down beast after beast, yet hardly feasted.",
		"One day, the powerful lion found two kittens. The lion dismissed them as it had many others, believing them to weak and fragile, and left them to fend for themselves.",
		"However, bit by bit, those kittens followed the lion, and the lion felt itself taking steps back so they could catch up.",
		"As time passed, the lion felt itself beginning to care for the kittens, and in thise care it felt it felt fear.",
		"The kittens assured the lion they'd never leave them, and for once in a long time, the lion believed in someone else.",
		"However, that was the lion's greatest mistake. Soon after, one of the kittens grew sick. The kitten was dying, and nothing could be done.",
		"So the lion, still a small kitten, ran. They ran to the ends of the earth trying to hide from the pain of losing a friend, the pain of being alone.",
		"But there, standing at the end of the earth, was the other kitten; And for once, the lion, still a little kitten, saw them for what they truly were. A lion looking for a friend.",
		"Yet in the end, the lion was still a small kitten and could not accept their friendship; So they ran.",
	)

	var/pink_speaktimer = null

	can_buckle = TRUE
	var/currently_talking = FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/examine()
	. = ..()
	if(currently_talking)
		. += span_notice("You could shove [src] to stop his talking... but that would be rude.")

/mob/living/simple_animal/hostile/abnormality/quiet_day/post_buckle_mob(mob/living/M)
	M.layer = layer + 0.1
	M.pixel_x += 14
	M.setDir(SOUTH)

/mob/living/simple_animal/hostile/abnormality/quiet_day/post_unbuckle_mob(mob/living/M)
	M.layer = initial(M.layer)
	M.pixel_x -= 14

/mob/living/simple_animal/hostile/abnormality/quiet_day/attack_hand(mob/living/carbon/human/M)
	if(M.a_intent == "help" || !currently_talking)
		return ..()

	visible_message(span_notice("[M] asks [src] to stop telling the story."), \
					span_notice("[M] asks you to stop telling the story."), null, null, M)
	to_chat(M, span_notice("You ask [src] to stop telling the story."))
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	currently_talking = FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(pe == 0)
		return
	performed_work = work_type
	TalkStart(user)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/TalkStart(mob/living/carbon/human/user)
	flick("quiet_fadein", src)
	icon_state = "quiet_ghost"
	currently_talking = TRUE
	switch(performed_work)
		if(ABNORMALITY_WORK_INSTINCT)
			for(var/line in war_story)
				say(line)
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_INSIGHT)
			for(var/line in parable)
				say(line)
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_ATTACHMENT)
			for(var/line in wife)
				say(line)
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_REPRESSION)
			var/list/dementia_clone = dementia.Copy()
			for(var/i in 1 to 7)
				say(length(dementia_clone) > 1 ? pick_n_take(dementia_clone) : pick(dementia_clone)) // if the list has 1 object, dont remove it
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

	TalkEnd(user)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/TalkEnd(mob/living/carbon/human/user)
	ResetIcon()
	var/given_status_effect = STATUS_EFFECT_DEMENTIA_RAMBLINGS
	var/list/affected_list = list()
	switch(performed_work)
		if(ABNORMALITY_WORK_INSTINCT)
			given_status_effect = STATUS_EFFECT_WAR_STORY

		if(ABNORMALITY_WORK_INSIGHT)
			given_status_effect = STATUS_EFFECT_PARABLE

		if(ABNORMALITY_WORK_ATTACHMENT)
			given_status_effect = STATUS_EFFECT_WIFE_STORY

	if(user) // In theory the user can be added twice to the list, thankfully that doesn't matter.
		affected_list += user
	for(var/mob/living/sitter in buckled_mobs)
		affected_list += sitter
	for(var/mob/living/carbon/human/person in affected_list) // Buff the worker and anyone sitting in the bench
		person.apply_status_effect(given_status_effect)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/ResetIcon()
	flick("quiet_fadeout", src)
	icon_state = "quiet_day"
	currently_talking = FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/PlayerInView(mob/living/carbon/human/user)
	if(currently_talking && (user in view(5, src)))
		return TRUE

	say("Ah, I suppose we can continue this another time.")
	return FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		AbnoRadio()
		Ramble()
		can_breach = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/quiet_day/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/Ramble(pink_story = TRUE)
	var/story_time = 1
	if(pink_story)
		for(var/line in catt)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), ";"+line), (2 SECONDS)*story_time)
			story_time++
		pink_speaktimer = addtimer(CALLBACK(src, PROC_REF(Ramble), FALSE), (3 SECONDS)*(story_time + 1))
		return
	var/list/gibberish = list()
	gibberish += dementia
	gibberish += war_story
	gibberish += parable
	gibberish += wife
	gibberish = shuffle(gibberish)
	while(gibberish.len > 0 && story_time < 10)
		var/line = pick(gibberish)
		gibberish -= line
		story_time++
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), ";"+line), (4 SECONDS)*story_time)
	pink_speaktimer = addtimer(CALLBACK(src, PROC_REF(Ramble), FALSE), (4 SECONDS)*story_time*2)

/mob/living/simple_animal/hostile/abnormality/quiet_day/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	if(stat == DEAD)
		return
	. = ..()

/atom/movable/screen/alert/status_effect/quiet
	name = "A Quiet Day"
	desc = "You listened to the old man's story."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "quiet"

//A Quiet day
//A simple 5 minute stat buff
/datum/status_effect/quiet
	id = "quiet_day"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/quiet
	var/attribute_buff = FORTITUDE_ATTRIBUTE

/datum/status_effect/quiet/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(attribute_buff, 15)

/datum/status_effect/quiet/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(attribute_buff, -15)


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
	return ..()
