/mob/living/simple_animal/hostile/abnormality/black_sun
	name = "Waxing of the Black Sun"
	desc = "A sundial. Inscribed on the side is the phrase ''Memento Mori''."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sundial"
	maxHealth = 1000
	health = 1000
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40
			)
	work_damage_amount = 16
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/arcadia,
//		/datum/ego_datum/weapon/judge,
		/datum/ego_datum/armor/arcadia
		)
//	gift_type = /datum/ego_gifts/arcadia
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	//takes 20 minutes from the moment of getting it to kill everyone
	var/stage
	var/nextstage = 1 MINUTES
	var/time_addition = 2 MINUTES //Goes down 5 seconds every time someone dies.
	var/modifier = 1

/mob/living/simple_animal/hostile/abnormality/black_sun/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/on_mob_death)
	nextstage = world.time + 1 MINUTES
	if(length(GLOB.player_list)<=7)
		modifier = 1.5

/mob/living/simple_animal/hostile/abnormality/black_sun/Life()
	. = ..()
	if(nextstage < world.time)
		StageChange()
	if(stage >= 4)
		for(var/mob/living/carbon/human/L in GLOB.player_list)
			if(L.stat != DEAD && L.z == z)
				return
			SSticker.force_ending = 1
			to_chat(GLOB.clients,"<span class='userdanger'>All agents are dead or off ZLevel. Automatically ending round.</span>")

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/StageChange()
	stage+=1
	switch(stage)
		if(1)
			Stage1()
			nextstage = world.time + 2 MINUTES * modifier
		if(2)
			Stage2()
			nextstage = world.time + 4 MINUTES * modifier
		if(3)
			Stage3()
			nextstage = world.time + 4 MINUTES * modifier
		if(4)
			Stage4()
			nextstage = world.time + 2 MINUTES * modifier
		if(5)
			RoundEnd()

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/Stage1()
	to_chat(GLOB.clients,"<span class='notice'>You see The Black Sun rise in the east.</span>")
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)


/mob/living/simple_animal/hostile/abnormality/black_sun/proc/Stage2()
	to_chat(GLOB.clients,"<span class='danger'>The Black Sun clears the horizon, filling you with it's warmth.</span>")

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/Stage3()
	to_chat(GLOB.clients,"<span class='userdanger'>The Black sun is halfway to it's zenith. Dread fills you. You must hurry.</span>")
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 15)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 15)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 15)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/Stage4()
	if(SSlobotomy_corp.next_ordeal_level > 4)	//Past Midnight
		for(var/mob/living/carbon/human/L in GLOB.player_list)
			L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -25)
			L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -25)
			L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -25)
			L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -30)
		to_chat(GLOB.clients,"<span class='colossus'>The Black Sun has stalled permanently. You are safe.</span>")
		stage = -5	//Will never run again.
		return

	to_chat(GLOB.clients,"<span class='colossus'>YOUR TIME IS LIMITED. THE SUN IS NEAR IT'S ZENITH.</span>")
	to_chat(world, "<B>The OOC channel has been globally disabled.</B>")
	to_chat(world, "<B>Respawn has been turned off.</B>")
	to_chat(world, "<B>PVP is turned on.</B>")
	GLOB.ooc_allowed = FALSE
	CONFIG_SET(flag/norespawn, 1)
	world.update_status()
	SSweather.run_weather(/datum/weather/bloody_water)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		flash_color(L, flash_color = COLOR_RED, flash_time = 150)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 30)

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/RoundEnd()
	if(SSlobotomy_corp.next_ordeal_level > 4)	//Past Midnight
		for(var/mob/living/carbon/human/L in GLOB.player_list)
			L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -25)
			L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -25)
			L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -25)
			L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -60)
		to_chat(GLOB.clients,"<span class='colossus'>The Black Sun has stalled permanently. You are safe.</span>")
		stage = -5	//Will never run again.
		return

	to_chat(GLOB.clients,"<span class='colossus'>THE BLACK SUN HAS RISEN.</span>")
	for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
		A.qliphoth_change(-A.qliphoth_meter) // Down to 0

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	nextstage += time_addition
	if(time_addition >=0 && stage!=4)
		time_addition =- 5 SECONDS
	to_chat(GLOB.clients,"<span class='notice'>The sun has stalled but a moment.</span>")
	return TRUE

/mob/living/simple_animal/hostile/abnormality/black_sun/AttemptWork(mob/living/carbon/human/user, work_type, pe, work_time)
	SSlobotomy_corp.qliphoth_meter = SSlobotomy_corp.qliphoth_max
	return TRUE

/datum/weather/bloody_water
	name = "bloodwater"
	desc = "A visual water weather."

	telegraph_message = "<span class='warning'>Something feels off.</span>"
	telegraph_duration = 150

	weather_message = "<span class='danger'>The blood.... it sings to you</span>"
	weather_duration_lower = 900000000
	weather_duration_upper = 900000000
	weather_overlay = "bloodwater"

	end_message = "<span class='danger'>The blood subsides.</span>"
	end_duration = 0

	area_type = /area
	protected_areas = list(/area/space)
	target_trait = ZTRAIT_STATION

	overlay_layer = ABOVE_OPEN_TURF_LAYER //Covers floors only
	overlay_plane = FLOOR_PLANE

