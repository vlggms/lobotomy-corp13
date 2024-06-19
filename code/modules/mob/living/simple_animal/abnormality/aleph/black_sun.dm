/mob/living/simple_animal/hostile/abnormality/black_sun
	name = "Waxing of the Black Sun"
	desc = "A sundial. Inscribed on the side is the phrase ''Memento Mori''."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sundial"
	maxHealth = 1000
	health = 1000
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 20,
		ABNORMALITY_WORK_INSIGHT = 20,
		ABNORMALITY_WORK_ATTACHMENT = 20,
		ABNORMALITY_WORK_REPRESSION = 20
			)
	work_damage_amount = 16
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/arcadia,
		/datum/ego_datum/weapon/judge,
		/datum/ego_datum/armor/arcadia
		)
//	gift_type = /datum/ego_gifts/arcadia
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	//takes 20 minutes from the moment of getting it to breach everything
	var/stage
	var/nextstage = 1 MINUTES
	var/time_addition = 2 MINUTES //Goes down 5 seconds every time someone dies.

/mob/living/simple_animal/hostile/abnormality/black_sun/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death))
	nextstage = world.time + 1 MINUTES

/mob/living/simple_animal/hostile/abnormality/black_sun/Life()
	. = ..()
	if(nextstage < world.time)
		StageChange()

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/StageChange()
	stage+=1
	//Add 10 stats to everyone.
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)

	switch(stage)
		if(1)
			to_chat(GLOB.clients,span_notice("You see The Black Sun rise in the east."))
			nextstage = world.time + 2 MINUTES
		if(2)
			to_chat(GLOB.clients,span_danger("The Black Sun clears the horizon, filling you with it's warmth."))
			nextstage = world.time + 4 MINUTES
		if(3)
			to_chat(GLOB.clients,span_userdanger("The Black sun is halfway to it's zenith. Dread fills you. You must hurry."))
			nextstage = world.time + 4 MINUTES
		if(4)
			to_chat(GLOB.clients,span_danger("YOUR TIME IS LIMITED. THE SUN IS NEAR IT'S ZENITH."))
			SSweather.run_weather(/datum/weather/bloody_water)
			for(var/mob/living/carbon/human/L in GLOB.player_list)
				flash_color(L, flash_color = COLOR_RED, flash_time = 150)
			nextstage = world.time + 2 MINUTES
		if(5)
			BreachAll()

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/BreachAll()
	to_chat(GLOB.clients,"<span class='colossus'>THE BLACK SUN HAS RISEN.</span>")
	for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
		A.qliphoth_change(-A.qliphoth_meter) // Down to 0

	//Also remove your stats
	var/removestats = stage*10
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -removestats)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -removestats)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -removestats)
	stage = 0

/mob/living/simple_animal/hostile/abnormality/black_sun/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	nextstage += time_addition
	if(time_addition >=0 && stage!=4)
		time_addition =- 5 SECONDS
	to_chat(GLOB.clients, span_notice("The sun has stalled but a moment."))
	return TRUE

//Each work counts for 3 works
/mob/living/simple_animal/hostile/abnormality/black_sun/AttemptWork(mob/living/carbon/human/user, work_type, pe, work_time)
	SSlobotomy_corp.qliphoth_meter +=2
	return TRUE

/mob/living/simple_animal/hostile/abnormality/black_sun/WorkChance(mob/living/carbon/human/user, chance)
	var/chance_modifier = 1
	chance_modifier = stage*10

	return chance + chance_modifier



/mob/living/simple_animal/hostile/abnormality/black_sun/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	to_chat(GLOB.clients, span_warning("The Black Sun fades from the sky. You are safe for now."))
	var/removestats = stage*10
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -removestats)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -removestats)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -removestats)
	stage = 0

//Weather effect
/datum/weather/bloody_water
	name = "bloodwater"
	desc = "A visual water weather."

	telegraph_message = "<span class='warning'>Something feels off.</span>"
	telegraph_duration = 150

	weather_message = "<span class='danger'>The blood.... it sings to you</span>"
	weather_duration_lower = 3000
	weather_duration_upper = 3000
	weather_overlay = "bloodwater"

	end_message = "<span class='danger'>The blood subsides.</span>"
	end_duration = 0

	area_type = /area
	protected_areas = list(/area/space)
	target_trait = ZTRAIT_STATION

	overlay_layer = ABOVE_OPEN_TURF_LAYER //Covers floors only
	overlay_plane = FLOOR_PLANE

