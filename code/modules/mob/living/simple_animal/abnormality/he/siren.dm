//Code by Coxswain sprites by Sky
/mob/living/simple_animal/hostile/abnormality/siren
	name = "Siren"
	desc = "The siren that sings the past."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "siren"
	maxHealth = 1000
	health = 1000
	threat_level = HE_LEVEL
	start_qliphoth = 5
	minimum_distance = 3 //runs away during pink midnight
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 15, //you can't spam insight so 0 is a bit much
		ABNORMALITY_WORK_INSIGHT = 80,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 50
		)
	work_damage_amount = 11
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/song,
		/datum/ego_datum/weapon/songmini,
		/datum/ego_datum/armor/song
		)
	gift_type = /datum/ego_gifts/song
	abnormality_origin = "Original"

//meltdown effects
	var/meltdown_cooldown_time = 144 SECONDS
	var/meltdown_cooldown
	var/song_cooldown_time = 60 SECONDS
	var/song_cooldown
	var/meltdown_imminent = FALSE
	pet_bonus = "beeps" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/meltdown = FALSE
//Post-work effect
	var/list/unsafe = list()
//SFX
	var/datum/looping_sound/siren_musictime/musictime
	var/playstatus = FALSE
	var/playrange = 40

/mob/living/simple_animal/hostile/abnormality/siren/Initialize()
	. = ..()
	musictime = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/siren/Life()
	. = ..()
	if(meltdown_cooldown < world.time && !datum_reference.working && !playstatus) // Doesn't decrease while working but will afterwards
		meltdown_cooldown = world.time + meltdown_cooldown_time
		datum_reference.qliphoth_change(-1)
		meltdown_imminent = FALSE

	if(datum_reference.qliphoth_meter == 1 && !meltdown_imminent)
		meltdown_imminent = TRUE
		playsound(src, 'sound/abnormalities/siren/burningmemory.ogg', 100, FALSE, 40, falloff_distance = 20)
		playstatus = TRUE
		addtimer(CALLBACK(src, .proc/stopPlaying), 52 SECONDS)
		icon_state = "siren_breach"
		warning()

	if(song_cooldown < world.time && !datum_reference.qliphoth_meter)
		musictime.start()
		SSlobotomy_corp.InitiateMeltdown(round(SSlobotomy_corp.qliphoth_meltdown_amount/3)+1, TRUE)
		song_cooldown = world.time + song_cooldown_time
		playstatus = TRUE
	if(playstatus && !datum_reference.qliphoth_meter)
		warning()

//All it takes is someone to turn it off, either manually
/mob/living/simple_animal/hostile/abnormality/siren/funpet()
	if(playstatus && !datum_reference.qliphoth_meter)
		stopPlaying()
		datum_reference.qliphoth_change(3)
		return

//Or by working
/mob/living/simple_animal/hostile/abnormality/siren/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(!datum_reference.qliphoth_meter)
		stopPlaying()
	datum_reference.qliphoth_change(5)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		turnBackTime(user)
		return
	stopPlaying()
	return

/mob/living/simple_animal/hostile/abnormality/siren/proc/turnBackTime(mob/living/carbon/human/user)
	var/mob/living/carbon/human/H = user
	var/currentage = H.age
	var/message
	if((user in unsafe) && prob(50)) //first work is a freebie, subsequent works are risky.
		to_chat(user, "<span class='danger'>The last thing you remember is your heart stopping.</span>")
		playsound(loc, 'sound/magic/clockwork/ratvar_attack.ogg', 50, TRUE)
		user.dust()
		return
	H.age = rand(17 , 85) //minimum age is 17, max is 85
	if (H.age > currentage)
		message += "You feel older and lucid."
		user.adjustSanityLoss(-user.maxSanity * 0.8) // It's healing
	else if (H.age < currentage)
		message += "You feel younger and vigorous."
		user.adjustBruteLoss(-user.maxHealth * 0.8)
	else
		to_chat(H, "<span class='warning'>Doesn't seem like it did anything this time.</span>")
		return

	to_chat(H, "<span class='warning'>[message]</span>")
	unsafe += user

	if(!playstatus)
		playsound(loc, 'sound/abnormalities/siren/backtherebenjamin.ogg', 50, FALSE)
		playstatus = TRUE //prevents song overlap
		addtimer(CALLBACK(src, .proc/stopPlaying), 59 SECONDS)
		icon_state = "siren_breach"

/mob/living/simple_animal/hostile/abnormality/siren/proc/stopPlaying()
	if(!datum_reference.qliphoth_meter)
		musictime.stop()
		for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
			to_chat(H, "<span class='warning'>The music begins to trail off.</span>")
	playstatus = 0
	icon_state = "siren"


//Stolen from singing machine
/mob/living/simple_animal/hostile/abnormality/siren/proc/warning()
	if(datum_reference.qliphoth_meter > 0)
		for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
			to_chat(H, "<span class='warning'>The abnormalities seem restless...</span>")
		return

	for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
		to_chat(H, "<span class='warning'>The abnormalities stir as the music plays...</span>")
	icon_state = "siren_breach"
