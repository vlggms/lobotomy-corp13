//I literally devised a whole new number system just for this abno - Kirie
/mob/living/simple_animal/hostile/abnormality/willyouplay
	name = "Will You Play?"
	desc = "A small girl holding a teddy bear."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "willyouplay"
	portrait = "will_you_play"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	work_chances = list(
		"Rock" = 60,
		"Paper" = 60,
		"Scissors" = 60,
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	max_boxes = 15

	ego_list = list(
		/datum/ego_datum/weapon/voodoo,
		/datum/ego_datum/armor/voodoo,
	)
	gift_type = /datum/ego_gifts/voodoo
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/janken = 0			//0 for scissors, 1 for Rock, 2 for paper
	var/player = 0			//0 for scissors, 1 for Rock, 2 for paper
	var/last_worked	//You get less if you just worked her.

//Randomizes work rate
/mob/living/simple_animal/hostile/abnormality/willyouplay/AttemptWork(mob/living/carbon/human/user, work_type)
	if(prob(70))
		janken = 0
	else
		janken = pick(1,2)
	if(user == last_worked)
		say("You again? Fine. We'll play again.")
	else
		say("I'll go fer scissors. How 'bout you?")
	return TRUE


//Losing is good, Lose means the player loses the game
//This uses a trinary number system that encodes two numbers as one. Janken is the first digit, and player is the second digit
//you're going to have to do a little decryption, but it goes like this. Take the first number (janken) and then add the second numberx3 (player)
//This gives you all 9 unique states
/mob/living/simple_animal/hostile/abnormality/willyouplay/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(pe == 0) //work fail
		Win(user, work_type)
		return

	switch(work_type)
		if("Scissors")
			player = 0
		if("Rock")
			player = 1
		if("Paper")
			player = 2

	player*=3
	player += janken

	//Goes through every use case.
	//Ties, When both digits are the same.
	//Lose, when the player loses
	//Win, when the player wins
	switch(player)
		if(0, 4, 8)
			Tie(user, work_type)
		if(2, 5, 6)
			Lose(user, work_type)
		if(1, 3, 7)
			Win(user, work_type)
	..()

/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Tie(mob/living/carbon/human/user, work_type)
	if(janken == 0)
		SLEEP_CHECK_DEATH(20)
		say("A draw. Did you think I wouldn't play scissors?")
		SLEEP_CHECK_DEATH(20)
		say("I don't play with folks who don't trust me.")
	else
		say("Hmph, a draw. You got lucky this time.")
	IncreaseStats(user, 1, FALSE)

//Player wins RPS, loses an arm tho
/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Win(mob/living/carbon/human/user, work_type)
	say("You lose.")
	user.deal_damage(80, RED_DAMAGE)
	IncreaseStats(user, 1, FALSE)

	//Less than 80 fort and you lose an arm
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <= 60)
		if(HAS_TRAIT(user, TRAIT_NODISMEMBER))
			return
		var/obj/item/bodypart/arm = pick(user.get_bodypart(BODY_ZONE_R_ARM), user.get_bodypart(BODY_ZONE_L_ARM))

		var/did_the_thing = (arm?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
		if(!did_the_thing)
			return

/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Lose(mob/living/carbon/human/user, work_type)
	var/statgain
	if(user == last_worked)
		statgain = -2

	if(janken == 0)
		statgain += 4
		SLEEP_CHECK_DEATH(20)
		say("You win. Scissors are only useful when cloth's around")
		IncreaseStats(user, statgain, TRUE)


	else	//Big Air bonus for picking the funny rare one
		statgain += 7
		say("You win, now get outta here.")
		IncreaseStats(user, statgain, TRUE)

/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/IncreaseStats(mob/living/carbon/human/user, statgain, check_melt = FALSE)
	var/list/attribute_list = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)
	for(var/A in attribute_list)
		var/processing = get_raw_level(user, A)
		if(processing > 80)
			if(check_melt == TRUE && datum_reference.console.meltdown)
				user.adjust_attribute_level(A, 1)
			continue
		user.adjust_attribute_level(A, statgain)
	last_worked = user
