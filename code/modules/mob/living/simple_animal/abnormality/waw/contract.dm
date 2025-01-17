//Coded by me, Kirie Saito!

//Remind me to give it contract features later.....
/mob/living/simple_animal/hostile/abnormality/contract
	name = "A Contract, Signed"
	desc = "A man with a flaming head sitting behind a desk."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "firstfold"
	portrait = "contract"
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 35, 45, 55),
	)
	pixel_x = -16
	base_pixel_x = -16
	start_qliphoth = 2
	work_damage_amount = 8
	work_damage_type = PALE_DAMAGE	//Lawyers take your fucking soul

	ego_list = list(
		/datum/ego_datum/weapon/infinity,
		/datum/ego_datum/armor/infinity,
	)
	gift_type = /datum/ego_gifts/infinity

	observation_prompt = "Before you, sitting on a desk is a man with a flaming head. <br>\
		On the table sits a rather conspicuous piece of paper. <br>\
		\"As per our agreement, the signatory will recieve one E.G.O. gift.\" <br>\
		\"All you need to do is sign here.\" <br>\
		The paper is a jumbled mess of words, you can't make out anything on it. <br>\
		A pen appears in your hand. <br>\
		The seems to be running out of patience. <br>Will you sign?"
	observation_choices = list(
		"Do not sign" = list(TRUE, "You take a closer look at the contract <br>\
			There is a tiny clause in fine print <br>\
			\"Your soul becomes the property of a contract signed.\" <br>\
			At your refusal, the man sighs and hands you a new contract. <br>\
			This contract seems legitimate, so you sign."),
		"Sign the contract" = list(FALSE, "You sign the contract in haste. <br>\
			In a few moments, you feel as if a piece of you is missing. <br>\
			You walk out in a daze, unable to remember what the contract was about. <br>\
			Perhaps you should have read the fine print."),
	)

	var/list/total_havers = list()
	var/list/fort_havers = list()
	var/list/prud_havers = list()
	var/list/temp_havers = list()
	var/list/just_havers = list()
	var/list/spawnables = list()
	var/total_per_contract = 4

/mob/living/simple_animal/hostile/abnormality/contract/Initialize()
	. = ..()
	//We need a list of all abnormalities that are TETH to HE level and Can breach.
	var/list/queue = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in queue)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(!(initial(abno.can_spawn)) || !(initial(abno.can_breach)))
			continue

		if((initial(abno.threat_level)) <= WAW_LEVEL)
			spawnables += abno

/mob/living/simple_animal/hostile/abnormality/contract/WorkChance(mob/living/carbon/human/user, chance, work_type)
	. = chance
	if(!(user in total_havers))
		return

	if(ContractedUser(user, work_type))
		. /= 2

	return

/mob/living/simple_animal/hostile/abnormality/contract/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_amount = initial(work_damage_amount)
	if(ContractedUser(user, work_type) && .)
		work_damage_amount /= 3
	if(user in total_havers)
		work_damage_amount /= 1.2
		say("Yes, yes... I remember the contract.")

	. = ..()
	return

/mob/living/simple_animal/hostile/abnormality/contract/proc/ContractedUser(mob/living/carbon/human/user, work_type)
	. = FALSE
	if(!(user in total_havers))
		return

	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			if(user in fort_havers)
				return TRUE

		if(ABNORMALITY_WORK_INSIGHT)
			if(user in prud_havers)
				return TRUE

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(user in temp_havers)
				return TRUE

		if(ABNORMALITY_WORK_REPRESSION)
			if(user in just_havers)
				return TRUE

/mob/living/simple_animal/hostile/abnormality/contract/proc/NewContract(mob/living/carbon/human/user, work_type)
	if((user in total_havers))
		return
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			if(fort_havers.len < total_per_contract)
				user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, (fort_havers.len - 4)*-1 )
				fort_havers |= user
			else
				return

		if(ABNORMALITY_WORK_INSIGHT)
			if(prud_havers.len < total_per_contract)
				user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, (prud_havers.len - 4)*-1 )
				prud_havers |= user
			else
				return

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(temp_havers.len < total_per_contract)
				user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, (temp_havers.len - 4)*-1 )
				temp_havers |= user
			else
				return

		if(ABNORMALITY_WORK_REPRESSION)
			if(just_havers.len < total_per_contract)
				user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, (just_havers.len - 4)*-1 )
				just_havers |= user
			else
				return

	total_havers |= user
	say("Just sign here on the dotted line... and I'll take care of the rest.")
	return


//Meltdown
/mob/living/simple_animal/hostile/abnormality/contract/ZeroQliphoth(mob/living/carbon/human/user)
	// Don't need to lazylen this. If this is empty there is a SERIOUS PROBLEM.
	var/mob/living/simple_animal/hostile/abnormality/spawning =	pick(spawnables)
	var/mob/living/simple_animal/hostile/abnormality/spawned = new spawning(get_turf(src))
	spawned.BreachEffect()
	spawned.color = "#000000"	//Make it black to look cool
	spawned.name = "???"
	spawned.desc = "What is that thing?"
	spawned.faction = list("hostile")
	spawned.core_enabled = FALSE
	datum_reference.qliphoth_change(2)

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/contract/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	NewContract(user, work_type)

/mob/living/simple_animal/hostile/abnormality/contract/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	work_damage_amount = initial(work_damage_amount)
	return


/mob/living/simple_animal/hostile/abnormality/contract/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	NewContract(user, work_type)
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/contract/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return
