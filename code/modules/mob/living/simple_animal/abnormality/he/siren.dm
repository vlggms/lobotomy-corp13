//Code by Coxswain sprites by Sky
/mob/living/simple_animal/hostile/abnormality/siren
	name = "Siren"
	desc = "The siren that sings the past."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "siren"
	portrait = "siren"
	maxHealth = 1000
	health = 1000
	threat_level = HE_LEVEL
	start_qliphoth = 5
	minimum_distance = 3 //runs away during pink midnight
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = 80,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 11
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/song,
		/datum/ego_datum/weapon/songmini,
		/datum/ego_datum/armor/song,
	)
	gift_type = /datum/ego_gifts/song


//meltdown effects
	var/meltdown_cooldown_time = 144 SECONDS
	var/meltdown_cooldown
	var/song_cooldown_time = 60 SECONDS
	var/song_cooldown
	var/meltdown_imminent = FALSE
	pet_bonus = "beeps" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/meltdown = FALSE
//Post-work effect
	var/musictimer
//SFX
	var/datum/looping_sound/siren_musictime/musictime
	var/playstatus = FALSE
	var/playrange = 40

//Spawn/music stuff
/mob/living/simple_animal/hostile/abnormality/siren/Initialize()
	. = ..()
	musictime = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/siren/Life() //todo : rewrite this is a more concise way
	. = ..()
	if(meltdown_cooldown < world.time && !datum_reference.working && !playstatus) // Doesn't decrease while working or playing music but will afterwards
		meltdown_cooldown = world.time + meltdown_cooldown_time
		datum_reference.qliphoth_change(-1)
		meltdown_imminent = FALSE

	if(datum_reference.qliphoth_meter == 1 && !meltdown_imminent) // Is qliphoth 1? Have we not run this yet? If true, play warning sound
		meltdown_imminent = TRUE
		playsound(src, 'sound/abnormalities/siren/burningmemory.ogg', 100, FALSE, 40, falloff_distance = 20, channel = CHANNEL_SIREN)
		playstatus = TRUE
		musictimer = addtimer(CALLBACK(src, PROC_REF(stopPlaying)), 55 SECONDS, TIMER_STOPPABLE)
		icon_state = "siren_breach"
		warning()

	if(song_cooldown < world.time && !datum_reference.qliphoth_meter) // 0 Qliphoth, time to start waking up the abnormalities
		musictime.start()
		SSlobotomy_corp.InitiateMeltdown(round(SSlobotomy_corp.qliphoth_meltdown_amount/3)+1, TRUE)
		song_cooldown = world.time + song_cooldown_time
		playstatus = TRUE

	if(playstatus && !datum_reference.qliphoth_meter) // Abnormality wake-up on cooldown? Play a warning instead.
		warning()

	else if(playstatus && datum_reference.qliphoth_meter >= 2) //O h, we're at a high qliphoth and still playing music for some reason? let's heal people instead
		blessing()

/mob/living/simple_animal/hostile/abnormality/siren/proc/stopPlaying() // This does exactly what it says on the tin.
	for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
		H.stop_sound_channel(CHANNEL_SIREN)
	if(!datum_reference.qliphoth_meter)
		musictime.stop()
		for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
			to_chat(H, span_warning("The music begins to trail off.")) // This is specifically to let players know that abnormalities are no longer breaching
	playstatus = 0
	icon_state = "siren"

//Work-related
/mob/living/simple_animal/hostile/abnormality/siren/WorkChance(mob/living/carbon/human/user, chance, work_type) //Insight work has a qliphoth-based success rate
	if(work_type != ABNORMALITY_WORK_INSIGHT)
		return chance
	var/chance_modifier = (datum_reference.qliphoth_meter * 20)
	return chance - chance_modifier

/mob/living/simple_animal/hostile/abnormality/siren/proc/turnBackTime(mob/living/carbon/human/user) //Insight work does a bunch of whacky stuff
	var/mob/living/carbon/human/H = user
	var/currentage = H.age
	var/message
	if(datum_reference.qliphoth_meter >= 5) //If we're at max qliphoth, die!
		to_chat(user, span_danger("The last thing you remember is your heart stopping."))
		playsound(loc, 'sound/magic/clockwork/ratvar_attack.ogg', 50, TRUE, channel = CHANNEL_SIREN)
		user.dust()
		return
	H.age = rand(17 , 85) //minimum age is 17, max is 85. We do a funny and change the user's age to something random.
	if (H.age > currentage)
		message += "You feel older and lucid."
		user.adjustSanityLoss(-user.maxSanity * 0.3) // It's healing
	else if (H.age < currentage)
		message += "You feel younger and vigorous."
		user.adjustBruteLoss(-user.maxHealth * 0.3)
	else
		message += "Doesn't seem like it did anything this time."

	to_chat(H, span_warning("[message]"))

	if(!playstatus && datum_reference.qliphoth_meter <= 1) //Qlihphoth is at or below 1 and insight work was performed? play the healing song!
		playsound(loc, 'sound/abnormalities/siren/backtherebenjamin.ogg', 50, FALSE,40, falloff_distance = 20, channel = CHANNEL_SIREN)
		playstatus = TRUE //prevents song overlap
		if(musictimer)
			deltimer(musictimer)
		musictimer = addtimer(CALLBACK(src, PROC_REF(stopPlaying)), 60 SECONDS, TIMER_STOPPABLE)
		icon_state = "siren_breach"

//Breach
/mob/living/simple_animal/hostile/abnormality/siren/funpet() //All it takes is someone to turn it off, either manually
	if(playstatus && !datum_reference.qliphoth_meter)
		stopPlaying()
		datum_reference.qliphoth_change(3)
		return

/mob/living/simple_animal/hostile/abnormality/siren/PostWorkEffect(mob/living/carbon/human/user, work_type, pe) //Or by working
	if(datum_reference.qliphoth_meter <= 1)
		stopPlaying()
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		turnBackTime(user)
	datum_reference.qliphoth_change(5)
	return

/mob/living/simple_animal/hostile/abnormality/siren/proc/warning() //A bunch of messages for various occasions
	if(datum_reference.qliphoth_meter > 0)
		for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
			to_chat(H, span_warning("The abnormalities seem restless..."))
		return

	for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
		to_chat(H, span_warning("The abnormalities stir as the music plays..."))
	icon_state = "siren_breach"

/mob/living/simple_animal/hostile/abnormality/siren/proc/blessing()
	for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
		to_chat(H, span_nicegreen("The music calms your nerves."))
		H.adjustSanityLoss(-3) // It's healing
	return
