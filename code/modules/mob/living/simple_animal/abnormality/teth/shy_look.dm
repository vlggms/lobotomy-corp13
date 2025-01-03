/mob/living/simple_animal/hostile/abnormality/shy_look
	name = "Today's Shy Look"
	desc = "A humanoid abnormality that's hiding behind what appears to be human skin that's etched with 5 different expressions.  \
	You have a strange urge to look behind the net of skin. But getting a bad feeling, you decide to stop."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "todayshylook_neutral"
	icon_living = "todayshylook_neutral"
	portrait = "shy_look"

	pixel_x = -16
	base_pixel_x = -16

	maxHealth = 666
	health = 666
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 45, 45, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(50, 45, 45, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 45, 45, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(50, 45, 45, 40, 40),
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/shy,
		/datum/ego_datum/armor/shy,
	)
	gift_type =  /datum/ego_gifts/shy
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "It's a good day! Are you still shy today?"
	observation_choices = list(
		"Yes" = list(TRUE, "\"That's no good, it's very important to have a smile on one's face! We need to be happy for our City!\""),
		"No" = list(FALSE, "\"That's great to hear! Let's see the biggest smile you can put on to make those in the Outskirts jealous!\""),
	)

	var/chance_modifier = 1
	var/previous_mood
	var/next_mood
	var/mood_cooldown

/mob/living/simple_animal/hostile/abnormality/shy_look/WorkChance(mob/living/carbon/human/user, chance)
	return chance * chance_modifier

/mob/living/simple_animal/hostile/abnormality/shy_look/Life()
	. = ..()
	if(mood_cooldown < world.time && !datum_reference.working)
		ChangeMood()

/mob/living/simple_animal/hostile/abnormality/shy_look/proc/ChangeMood()
	next_mood = rand(1, 5)
	switch(next_mood)
		if(1) //From Smiling to angry
			chance_modifier = 1.3
			work_damage_amount = initial(work_damage_amount)*0.5
		if(2)
			chance_modifier = 1.1
			work_damage_amount = initial(work_damage_amount)
		if(3)
			chance_modifier = 1
			work_damage_amount = initial(work_damage_amount)
		if(4)
			chance_modifier = 0.7
			work_damage_amount = initial(work_damage_amount)*1.5
		if(5)
			chance_modifier = 0.5
			work_damage_amount = initial(work_damage_amount)*2
	ChangeIcon()

/mob/living/simple_animal/hostile/abnormality/shy_look/proc/ChangeIcon()
	// This nonsense code is for animating within the game. Byond doesn't let you pick frames from an animated icon, so I had to make a loop with sleep in between
	var/p = previous_mood
	var/n = next_mood
	if(p < n)
		for(p, p<n, p++)
			icon_state = "todayshylook_[p]"
			sleep(2)
	if(p > n)
		n = (n-1)
		p = (p-1)
		for(p, n<p, p--)
			icon_state = "todayshylook_[p]"
			sleep(2)
	switch(next_mood)
		if(1)
			icon_state = "todayshylook_cheerful"
		if(2)
			icon_state = "todayshylook_happy"
		if(3)
			icon_state = "todayshylook_neutral"
		if(4)
			icon_state = "todayshylook_sad"
		if(5)
			icon_state = "todayshylook_angry"
	previous_mood = next_mood
	var/mood_cooldown_time = rand(2, 5) SECONDS
	mood_cooldown = world.time + mood_cooldown_time

/mob/living/simple_animal/hostile/abnormality/shy_look/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(previous_mood == 1 && pe > 0) // heals 20% hp&sp
		user.adjustSanityLoss(-0.2*user.maxSanity)
		user.adjustBruteLoss(-0.2*user.maxHealth)
	if(previous_mood == 2 && pe > 0)
		user.adjustSanityLoss(-0.2*user.maxSanity)
	ChangeMood() //Prevents spamming work on the same mood
	return
