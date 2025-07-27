//Left to do: Random events, Work chances, and the "breach" effect

/mob/living/simple_animal/hostile/abnormality/branch12/ss13
	name = "The 13th Space Station"
	desc = "A computer that links you with the L-Corp research space station above. The space station is the abno itself, being researched, but this is your link to it. \
		Use this console to see station stats."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "ss13"
	icon_living = "ss13"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_amount = 16
	work_damage_type = BLACK_DAMAGE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	pet_bonus = "pings"

	ego_list = list(
	//	/datum/ego_datum/weapon/branch12/captaincy,
	//	/datum/ego_datum/armor/branch12/captaincy,
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	//What's the current orders
	var/orders = "None"

	//How much food and ammo you have
	var/supplies = 100
	//How much fuel your station has
	var/fuel = 100
	//How much damage is taken by the station. Goes down very slowly.
	var/integrity = 100
	//How safe the station is. When this gets to 0, lower hull integrity quickly.
	var/security = 70
	//How much research capacity you have. Increases quota PE when above 20
	var/research = 0

/mob/living/simple_animal/hostile/abnormality/branch12/ss13/Initialize()
	..()
	var/turf/W = pick(GLOB.xeno_spawn)
	new /obj/structure/ss13/supplies_crate (get_turf(W))

	W = pick(GLOB.xeno_spawn)
	new /obj/structure/ss13/fuel_crate (get_turf(W))

/mob/living/simple_animal/hostile/abnormality/branch12/ss13/Life()
	..()
	if(integrity < 0 || fuel< 0 )
		datum_reference.qliphoth_change(-99)
		sound_to_playing_players_on_level('sound/misc/airraid.ogg', 50, zlevel = z)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "ERROR. ERROR. HULL INTEGRITY 0. STATION IS DEORBITING. SEEK SHELTER IMMEDIATELY.", 25))

	//If you have a supplies crate nearby, delete it, increase supplies and spawn a new one
	for(var/obj/structure/ss13/supplies_crate/Y in range(1, src))
		qdel(Y)
		supplies+=50
		if(supplies>=100)
			supplies = 100

		var/turf/W = pick(GLOB.xeno_spawn)
		new /obj/structure/ss13/supplies_crate (get_turf(W))

	//If you have a fuel crate nearby, delete it, increase fuel and spawn a new one
	for(var/obj/structure/ss13/fuel_crate/Y in range(1, src))
		qdel(Y)
		fuel+=50
		if(fuel>=100)
			fuel = 100

		var/turf/W = pick(GLOB.xeno_spawn)
		new /obj/structure/ss13/fuel_crate (get_turf(W))

	//I am too lazy to make this less common, and don't want to run a CALLBACK for it.
	//Insert that image of the one guy that wanted to optimize atmos by making it run 30% of the time.
	if(prob(50))
		return


	//Let's handle our item stats now.
	//Supplies go down slowly
	if(prob(30))
		supplies--
		if(orders == "rations")
			supplies --

	//Fuel goes down pretty fast
	if(prob(50))
		fuel--

	//Non-item stats
	//Hull goes down super slowly
	if(prob(10))
		integrity--

	//Security goes down kinda slowly, unless you're on double rations
	if(prob(25) && orders!= "rations")
		security--


	//Orders and increases below
	//Research goes up if sec is high
	if(security>=50)
		if(research>=100 && prob(40))
			research++
	else	//goes down if it's low, and integrity lowers as well
		if(prob(40))
			research--
		if(prob(40))
			integrity--

	if(research<0)
		research = 0
	if(security<0)
		research = 0

	//Give cargo PE if research is high
	if(research>=20)
		SSlobotomy_corp.AdjustAvailableBoxes(round(research*0.05))


	switch(orders)
		if("repair")
			if(integrity>=100)
				integrity+=2
			if(prob(40))
				supplies--

		if("research")		//Increases research, lowers integrity
			if(research>=100)
				research++
			if(prob(50))
				integrity--

		if("riot")			//Increases security, can lower supplies and integrity
			if(security>=100)
				security+=2
			if(prob(30))
				integrity--
			if(prob(30))
				supplies--


/mob/living/simple_animal/hostile/abnormality/branch12/ss13/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	..()
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			orders = "repair"
			say("Engineers and atmospheric technicians have been ordered to repair the station. Supplies will be consumed more quickly.")
		if(ABNORMALITY_WORK_INSIGHT)
			orders = "research"
			say("Extra funding has been allocated to Research. Research has been advised to work with less care, possibly causing hull damage.")
		if(ABNORMALITY_WORK_ATTACHMENT)
			orders = "rations"
			say("Extra rations have been allocated. Station staff will be more docile.")
		if(ABNORMALITY_WORK_REPRESSION)
			orders = "riot"
			say("Security officers have been advised to put down any dissent. Munititions will be expended and hull integrity may lower.")

/mob/living/simple_animal/hostile/abnormality/branch12/ss13/funpet(mob/living/carbon/human/current_petter)
	..()
	say("Current Station Statistics:")
	SLEEP_CHECK_DEATH(10)
	say("Munitions and Supplies: [supplies]%.")
	SLEEP_CHECK_DEATH(10)
	say("Station Fuel: [fuel]%.")
	SLEEP_CHECK_DEATH(10)
	say("Hull Integrity: [integrity]%.")
	SLEEP_CHECK_DEATH(10)
	say("Station Security: [security]%.")
	SLEEP_CHECK_DEATH(10)
	say("Research Capacity: [research]%.")
	SLEEP_CHECK_DEATH(10)
	say("Current orders given: [orders].")


//Equipment crates
/obj/structure/ss13/supplies_crate
	name = "SS13 Supplies Crate"
	desc = "A crate that can be given to the SS13 computer to send supplies to the station."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "ss13_supplies"
	anchored = FALSE
	density = TRUE

//Equipment crates
/obj/structure/ss13/fuel_crate
	name = "SS13 Fuel Crate"
	desc = "A crate that can be given to the SS13 computer to send fuel to the station."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "ss13_fuel"
	anchored = FALSE
	density = TRUE
