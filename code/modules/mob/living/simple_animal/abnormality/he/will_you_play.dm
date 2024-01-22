//I literally devised a whole new number system just for this abno - Kirie
/mob/living/simple_animal/hostile/abnormality/willyouplay
	name = "Will You Play?"
	desc = "A small girl holding a teddy bear."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "willyouplay"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	work_chances = list(
		"Rock" = 80,
		"Paper" = 80,
		"Scissors" = 80,
	)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	max_boxes = 15

	ego_list = list(
		/datum/ego_datum/weapon/voodoo,
		/datum/ego_datum/armor/voodoo,
	)
	gift_type = /datum/ego_gifts/voodoo
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/janken = 0			//0 for scissors, 1 for Rock, 2 for paper
	var/player = 0			//0 for scissors, 1 for Rock, 2 for paper

//Randomizes work rate
/mob/living/simple_animal/hostile/abnormality/willyouplay/AttemptWork(mob/living/carbon/human/user, work_type)
	if(prob(50))
		janken = 0
	else
		janken = pick(1,2)
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

//Player wins RPS, loses an arm tho
/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Win(mob/living/carbon/human/user, work_type)
	say("You lose.")
	user.apply_damage(80, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

	//Less than 80 fort and you lose an arm
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <= 60)
		if(HAS_TRAIT(user, TRAIT_NODISMEMBER))
			return
		var/obj/item/bodypart/arm = pick(user.get_bodypart(BODY_ZONE_R_ARM), user.get_bodypart(BODY_ZONE_L_ARM))

		var/did_the_thing = (arm?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
		if(!did_the_thing)
			return

/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Lose(mob/living/carbon/human/user, work_type)
	if(janken == 0)
		SLEEP_CHECK_DEATH(20)
		say("You win. Scissors are only useful when cloth's around")
		if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 80)
			return
		if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 80)
			return
		if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80)
			return
		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 80)
			return

		user.adjust_all_attribute_levels(2)

	else
		say("You win, now get outta here.")
		if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 80)
			return
		if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 80)
			return
		if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80)
			return
		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 80)
			return

		user.adjust_all_attribute_levels(3)

