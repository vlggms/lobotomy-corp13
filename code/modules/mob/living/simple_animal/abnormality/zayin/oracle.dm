/mob/living/simple_animal/hostile/abnormality/oracle
	name = "Oracle of No Future"
	desc = "An ancient cryopod with the name 'Maria' etched into the side. \
		You look inside expecting to see the body of the person named, \
		but all you see is a gooey substance at the bottom."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "oracle"
	icon_living = "oracle"
	portrait = "oracle"
	maxHealth = 1500
	health = 1500
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 80,
		"Fall Asleep" = 100,
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/dead_dream,
		/datum/ego_datum/armor/dead_dream
	)
//	gift_type =  /datum/ego_gifts/oracle
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "In a vivid dream you see her, as she was. \
		<br>She was told that it would feel like no time at all. \
		<br>Silently sleeping she dreams of the future, a future she was promised. \
		<br>Before your eyes untold time passes until one day."
	observation_choices = list(
		"The pod broke" = list(TRUE, "You look into the window as you see her stir in her slumber before falling still. \
			<br>Holding your breath in silence, \
			<br>You remember Maria, \
			<br>Forever dreaming of a future she will never see."),
		"She woke up" = list(FALSE, "The pod opens with a hiss as you watch her step out. \
			<br>The joy on her face is immesurable, for she left behind so much to be here. \
			<br>Then she melts away, for this was your dream."),
	)

	var/list/sleeplines = list(
		"Hello...",
		"I am reaching you from beyond the veil...",
		"I cannot move, I cannot speak...",
		"But for you, I have some information to part...",
		"Please wait a moment while I retrieve it for you....",
		"Ah, I have information on the next ordeal.... as you call it...",
		"The next ordeal is...",
	)
	var/list/fakeordeals = list(
		//Some Based off the 7 trumpets
		"Hail of fire and blood..... Thrown to the earth.... burning up nature...",
		"A great mountain..... plunging into the sea..... oceans of blood..... killing sea life....",
		"A star.... falling to earth.... poisoning the fresh water....",
		"The sky goes dark..... all the stars, the moon and even the sun.....",
		"Woe...... Woe to those who dwell on earth....",
		"A star falls to earth.... opening the abyss...",
		"Locusts.... with scorpion tails.... man's face... and lion's teeth.....",
		"Two hundred million troops.... fire and smoke.... and their plague will kill man...",
		"The kingdom of the world has become the kingdom of His Messiah.... reigning forever and ever...",
		//And some I made
		"Cold.... Endless Cold.....",
		"A man with many arms......",
		"A woman without a face.... and many children screaming....",
		// -IP additions
		"In a ruined hallway... scavengers feed on a worker...",
		"Hundred eyes... a endless maw... long legs... im scared...",
		"I hear it around the corner... but i cant look... i dont want to see whats there...",
		"The corner of a room... someone is smiling... their skin isnt on right...",
		"A plume of light erupts from a city...",
		"Monsters... monsters everywhere... they are eating people in the streets...",
		"A woman with a dog head... she is smoking silently...",
		"A person in a blue coat... they fold into a book...",
		)

/mob/living/simple_animal/hostile/abnormality/oracle/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/oracle/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/oracle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		user.drowsyness += 30
		user.Sleeping(30 SECONDS) //Sleep with her, so that you can get some information
		for(var/line in sleeplines)
			to_chat(user, span_notice(line))
			SLEEP_CHECK_DEATH(40)
			if(!user.IsSleeping())
				return
		if(prob(50))
			var/chosenfake = pick(fakeordeals)
			to_chat(user, span_notice("[chosenfake]"))
			return
		if(!SSlobotomy_corp.next_ordeal)
			to_chat(user, span_notice("All ordeals.... are completed..."))
			return
		to_chat(user, span_notice("[SSlobotomy_corp.next_ordeal.name]"))
	..()

/mob/living/simple_animal/hostile/abnormality/oracle/Initialize(mob/living/carbon/human/user)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/mob/living/simple_animal/hostile/abnormality/oracle/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return ..()


/mob/living/simple_animal/hostile/abnormality/oracle/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "Fall Asleep")
		user.drowsyness += 30
		user.Sleeping(30 SECONDS) // Won't get any info, but you can listen for any breaches for 30 seconds
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/oracle/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(z != abno.z)
		return
	addtimer(CALLBACK(src, PROC_REF(NotifyEscape), loc, abno), rand(1 SECONDS, 3 SECONDS))

/mob/living/simple_animal/hostile/abnormality/oracle/proc/NotifyEscape(mob/living/carbon/human/user, mob/living/simple_animal/hostile/abnormality/abno)
	if(QDELETED(abno) || abno.stat == DEAD)
		return
	for(var/mob/living/carbon/human/H in GLOB.clients)
		if(H.IsSleeping())
			continue //You need to be sleeping to get notified
		to_chat(H, "<span class='notice'>Oh.... [abno]... It has breached containment...</span>")

//ER stuff
/mob/living/simple_animal/hostile/abnormality/oracle/BreachEffect(mob/living/carbon/human/user, breach_type)//finish this shit
	if(breach_type == BREACH_MINING)
		var/chosenfake = pick(fakeordeals)
		for(var/mob/living/L in livinginrange(48, src))
			if(L.z != z)
				continue
			if(faction_check_mob(L))
				continue
			to_chat(L, span_userdanger("[chosenfake]"))
		addtimer(CALLBACK(src, PROC_REF(NukeAttack)), 30 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/abnormality/oracle/proc/NukeAttack()
	if(stat == DEAD)
		return
	playsound(src, 'sound/magic/wandodeath.ogg', 100, FALSE, 40, falloff_distance = 10)
	for(var/mob/living/L in livinginrange(48, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		to_chat(L, span_userdanger("Visions of a horrible future flash before your eyes!"))
		L.deal_damage((150 - get_dist(src, L)), WHITE_DAMAGE)
	qdel(src)
