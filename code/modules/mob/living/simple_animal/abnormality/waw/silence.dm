//Coded by me, Kirie Saito!
/mob/living/simple_animal/hostile/abnormality/silence
	name = "The Price of Silence"
	desc = "A scythe with a clock attached, quietly ticking."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "silence"
	portrait = "silence"
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 50, 45, 45),
	)
	start_qliphoth = 1
	work_damage_amount = 10
	work_damage_type = PALE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/thirteen,
		/datum/ego_datum/armor/thirteen,
	)
	gift_type = /datum/ego_gifts/thirteen
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	var/meltdown_cooldown_time = 13 MINUTES
	var/meltdown_cooldown
	var/worldwide_damage = 70	//If you're unarmored, it obliterates you
	var/safe = FALSE //work on it and you're safe for 13 minutes
	var/reset_time = 3 MINUTES //Don't hit everyone with the global pale if it was hit in a small period of time
	var/datum/looping_sound/silence/soundloop // Tick-tock, tick-tock

/mob/living/simple_animal/hostile/abnormality/silence/Initialize()
	. = ..()
	meltdown_cooldown = world.time + meltdown_cooldown_time
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/silence/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/abnormality/silence/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	safe = TRUE
	to_chat(user, span_nicegreen("The bells do not toll for thee. Not yet."))
	return

/mob/living/simple_animal/hostile/abnormality/silence/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		safe = TRUE
		to_chat(user, span_nicegreen("The bells do not toll for thee. Not yet."))
	return

/mob/living/simple_animal/hostile/abnormality/silence/Life()
	. = ..()
	if(meltdown_cooldown < world.time)
		meltdown_cooldown = world.time + meltdown_cooldown_time
		sound_to_playing_players_on_level('sound/abnormalities/silence/ambience.ogg', 50, zlevel = z)
		if(!safe)
			datum_reference.qliphoth_change(-1)
		safe = FALSE
	return

//Meltdown
/mob/living/simple_animal/hostile/abnormality/silence/ZeroQliphoth(mob/living/carbon/human/user)
	// You have mere seconds to live
	SLEEP_CHECK_DEATH(5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/silence/price.ogg', 50, zlevel = z)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(faction_check_mob(H, FALSE) || H.z != z || H.stat == DEAD)
			continue

		new /obj/effect/temp_visual/thirteen(get_turf(H))	//A visual effect if it hits
		H.apply_damage(worldwide_damage, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	addtimer(CALLBACK(src, PROC_REF(Reset)), reset_time)
	return

/mob/living/simple_animal/hostile/abnormality/silence/proc/Reset()
	datum_reference.qliphoth_change(1)
