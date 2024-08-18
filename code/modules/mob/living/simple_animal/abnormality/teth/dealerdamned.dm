/mob/living/simple_animal/hostile/abnormality/dealerdamned
	name = "Dealer of the Damned"
	desc = "A floating playing card with what appears to be a cursor acting as its hand."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "dealerdamned"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = 25,
		"Gamble" = 100
	)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE
	speak_emote = list("states")
	pet_bonus = "waves"

	//Forsaken gift is just a placeholder so it doesn't bug tf out when I compile
	ego_list = list(
		/datum/ego_datum/weapon/luckdraw,
		/datum/ego_datum/armor/luckdraw,
	)
	gift_type =  /datum/ego_gifts/luckdraw
	pixel_x = -16
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL
	var/coin_status
	var/has_flipped
	var/static/gambled_prior = list()
	var/work_count = 0

//Coinflip V1; Expect Jank
/mob/living/simple_animal/hostile/abnormality/dealerdamned/funpet(mob/petter)
	..()
	if(!isliving(petter))
		return
	if(has_flipped)
		say("Woah there, hotshot. We've already had a game recently!")
		return

	has_flipped = TRUE
	var/mob/living/user = petter
	user.deal_damage(user.maxHealth*0.2, RED_DAMAGE)
	icon_state = "dealerflip"
	manual_emote("flips a gold coin.")
	SLEEP_CHECK_DEATH(10)
	icon_state = "dealerdamned"
	if(prob(35))
		say("Heads, huh? Looks like you win this one.")
		coin_status = TRUE
		user.adjustBruteLoss(-user.maxHealth*0.2)
	else
		say("Tails. Sorry, high roller, but a deal's a deal.")
	return

/mob/living/simple_animal/hostile/abnormality/dealerdamned/AttemptWork(mob/living/carbon/human/user, work_type)
	..()
	if((work_type == "Gamble") && (user.ckey in gambled_prior))
		say("Hey, I know I'm all for high stakes, but you've already put your life on the line once. I've got standards.")
		return FALSE
	else
		return TRUE

//TODO: Add the revolver open sprite, replace gibbing with "death" sprite
/mob/living/simple_animal/hostile/abnormality/dealerdamned/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	if(work_type == "Gamble")
		say("Feelin' like putting your life on the line, huh? Sounds good to me!")
		user.Immobilize(15)
		SLEEP_CHECK_DEATH(10)
		playsound(user, "revolver_spin", 70, FALSE)
		gambled_prior |= user.ckey

		//We need to set if the game is going on, who's being shot, and then spent chambers
		var/russian_roulette = TRUE
		var/player_shot = TRUE
		var/spent_chambers = 0

		while(russian_roulette)
			user.Immobilize(spent_chambers*5)
			SLEEP_CHECK_DEATH(spent_chambers*5)
			spent_chambers+=1
			if(prob(16.666*spent_chambers))
				playsound(user, 'sound/weapons/gun/revolver/shot_alt.ogg', 100, FALSE)
				russian_roulette = FALSE
				if(player_shot)
					user.gib()
					say("Shame. Was quite fun havin' ya here, but you know how it is.")
				else
					new /obj/item/gun/ego_gun/pistol/deathdealer(get_turf(user))
					new /obj/effect/gibspawner/generic/silent(get_turf(src))
					gib()
			else
				playsound(user, 'sound/weapons/gun/revolver/dry_fire.ogg', 100, FALSE)
				if(player_shot)
					player_shot = FALSE
				else
					player_shot = TRUE

/mob/living/simple_animal/hostile/abnormality/dealerdamned/WorkChance(mob/living/carbon/human/user, chance)
	var/newchance
	if(coin_status)
		newchance = 20
	coin_status = FALSE
	has_flipped = FALSE
	return chance + newchance
