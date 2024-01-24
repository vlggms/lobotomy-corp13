//She tells stories, and does sanity damage. What can I say?
/mob/living/simple_animal/hostile/abnormality/drownedsisters
	name = "Drowned Sisters"
	desc = "A pair of girls with masks covering their faces."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "sisters"
	portrait = "drowned_sisters"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	start_qliphoth = 3
	work_damage_amount = 5		//Calculated later
	work_damage_type = WHITE_DAMAGE
	pixel_x = -32
	base_pixel_x = -32

	ego_list = list(
		/datum/ego_datum/weapon/sorority,
		/datum/ego_datum/armor/sorority,
	)
	gift_type =  /datum/ego_gifts/sorority
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/breaching = FALSE

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/drownedsisters/AttemptWork(mob/living/carbon/human/user, work_type)	//Deals scaling work damage based off your stats.
	if(breaching)
		return FALSE
	work_damage_amount = (get_attribute_level(user, PRUDENCE_ATTRIBUTE) -60) * -0.5
	work_damage_amount = max(5, work_damage_amount)	//So you don't get healing
	return ..()

/mob/living/simple_animal/hostile/abnormality/drownedsisters/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
// okay so according to the lore you're not really supposed to remember the stories she says so we're going to make it so your sanity goes back up
	if(!user.sanity_lost && pe != 0)
		user.adjustSanityLoss(-get_attribute_level(user, PRUDENCE_ATTRIBUTE))
	..()
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			datum_reference.qliphoth_change(-1)
		if(ABNORMALITY_WORK_ATTACHMENT)
			if(datum_reference.qliphoth_meter == 3)
				FloodRoom()
			else
				datum_reference.qliphoth_change(1)
	return

//Breaches
/mob/living/simple_animal/hostile/abnormality/drownedsisters/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(3)
	if(!user)
		return
	to_chat(user, span_userdanger("You are attacked by an invisible assailant!"))
	playsound(get_turf(src), 'sound/abnormalities/jangsan/tigerbite.ogg', 75, 0)
	user.apply_damage(200, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE))
	if(user.health < 0 || user.stat == DEAD)
		user.gib()
	return

/mob/living/simple_animal/hostile/abnormality/drownedsisters/proc/FloodRoom() //Qliphoth Went over max
	breaching = TRUE
	for(var/turf/open/T in view(7, src))
		new /obj/effect/temp_visual/water_waves(T)
	playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 75, 0)
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return
	for(var/mob/living/carbon/human/H in view(7, src))
		if(!H.sanity_lost)
			var/turf/teleport_target = pick(teleport_potential)
			TeleportPerson(H, teleport_target)
		else
			QDEL_NULL(H.ai_controller) //If they panicked, they just drown
			H.adjustOxyLoss(200)
	sleep(5 SECONDS)
	datum_reference.qliphoth_change(3)
	breaching = FALSE

/mob/living/simple_animal/hostile/abnormality/drownedsisters/proc/TeleportPerson(mob/living/carbon/human/H, turf/teleport_target)
	set waitfor = FALSE
	to_chat(H, span_userdanger("You can't breathe!"))
	H.AdjustSleeping(10 SECONDS)
	animate(H, alpha = 0, time = 2 SECONDS)
	sleep(2 SECONDS)
	H.forceMove(get_turf(teleport_target)) // See ya!
	animate(H, alpha = 255, time = 0 SECONDS)
