//Coded by me, Kirie Saito!
/mob/living/simple_animal/hostile/abnormality/silence
	name = "The Price of Silence"
	desc = "A scythe with a clock attached, quietly ticking."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "silence"
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 50, 45, 45)
			)
	start_qliphoth = 1
	work_damage_amount = 10
	work_damage_type = PALE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/thirteen,
		/datum/ego_datum/armor/thirteen,
		)
//	gift_type = /datum/ego_gifts/thirteen

	var/meltdown_cooldown_time = 13 MINUTES
	var/meltdown_cooldown
	var/worldwide_damage = 70	//If you're unarmored, it obliterates you
	var/safe = FALSE //work on it and you're safe for 13 minutes
	var/reset_time = 3 MINUTES //Don't hit everyone with the global pale if it was hit in a small period of time

/mob/living/simple_animal/hostile/abnormality/silence/Initialize()
	..()
	meltdown_cooldown = world.time + meltdown_cooldown_time

/mob/living/simple_animal/hostile/abnormality/silence/success_effect(mob/living/carbon/human/user, work_type, pe)
	safe = TRUE
	to_chat(user, "<span class='nicegreen'>The bells do not toll for thee. Not yet.</span>")
	return

/mob/living/simple_animal/hostile/abnormality/silence/Life()
	. = ..()
	if(meltdown_cooldown < world.time)
		meltdown_cooldown = world.time + meltdown_cooldown_time
		sound_to_playing_players('sound/abnormalities/silence/bong.ogg')	//Church bells ringing, whether it happens or not.
		if(!safe)
			datum_reference.qliphoth_change(-1)
		safe = FALSE
	return

//Meltdown
/mob/living/simple_animal/hostile/abnormality/silence/zero_qliphoth(mob/living/carbon/human/user)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.z != z || L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/thirteen(get_turf(L))	//A visual effect if it hits
		L.apply_damage(worldwide_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	addtimer(CALLBACK(src, .proc/Reset), reset_time)
	return

/mob/living/simple_animal/hostile/abnormality/silence/proc/Reset()
	datum_reference.qliphoth_change(1)
