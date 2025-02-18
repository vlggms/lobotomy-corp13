/mob/living/simple_animal/hostile/abnormality/fetus
	name = "Nameless Fetus"
	desc = "A giant, pus-filled baby."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "fetus"
	portrait = "nameless_fetus"
	maxHealth = 400
	health = 400
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 50, 60, 60, 60),
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(20, 30, 30, 30, 30),
	)
	start_qliphoth = 1
	pixel_x = -8
	base_pixel_x = -8

	max_boxes = 16
	work_damage_amount = 7
	work_damage_type = RED_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/syrinx,
		/datum/ego_datum/weapon/trachea,
		/datum/ego_datum/armor/syrinx,
	)
	gift_type =  /datum/ego_gifts/syrinx
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "The baby never cries. <br>It kept that way forever. <br>\
		As a lack of words doesn't necessarily mean a lack of emotions, a lack of crying doesn't mean lack of desire. <br>\
		Since time unknown, the baby has had a mouth. <br>The baby who does not understand cries, expresses hunger, and causes pain for the others. <br>You..."
	observation_choices = list(
		"Call its name" = list(TRUE, "No one else knows the name of the fetus. <br>\
			But you know. <br>You called its name. <br>\
			The unstoppable desire shut its mouth for a while. <br>Even only for a short time, the desire silenced."),
		"Didn't call its name" = list(FALSE, "The fetus is still crying. <br>\
			You plugged your ears silently. <br>No sound is heard."),
	)

	var/mob/living/carbon/human/calling = null
	var/criesleft

/mob/living/simple_animal/hostile/abnormality/fetus/ZeroQliphoth(mob/living/carbon/human/user)
	for(var/mob/living/carbon/human/H in GLOB.player_list)	//Way harder to get a list of living humans.
		if(H.stat != DEAD)
			criesleft+=3		//Get a max of 3 cries per person.
	check_players()
	check_range()

	//Are they nearby?
/mob/living/simple_animal/hostile/abnormality/fetus/proc/check_range()
	if(calling && Adjacent(calling))
		calling.gib()
		calling = null

		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_userdanger("The creature is satisfied."))

		notify_ghosts("The nameless fetus is satisfied.", source = src, action = NOTIFY_ORBIT, header="Something Interesting!") // bless this mess
		datum_reference.qliphoth_change(1)
		return

	addtimer(CALLBACK(src, PROC_REF(check_range)), 2 SECONDS)


/mob/living/simple_animal/hostile/abnormality/fetus/proc/check_players()
	if(datum_reference.qliphoth_meter == 1)
		return
	if(criesleft<=0)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_warning("The crying stops. Finally, silence."))
		return


	criesleft--

	//Find a living player, they're the new target.
	var/list/checking = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z == z && H.stat != DEAD)
			checking +=H
	if(LAZYLEN(checking))
		calling = pick(checking)

		//and make a global announce
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_userdanger("The fetus calls out for [calling.real_name]."))

		notify_ghosts("The fetus calls out for [calling.real_name].", source = src, action = NOTIFY_ORBIT, header="Something Interesting!") // bless this mess

	var/list/qliphoth_abnos = list()
	for(var/mob/living/simple_animal/hostile/abnormality/V in GLOB.abnormality_mob_list)
		if(V.IsContained())
			qliphoth_abnos += V

	if(LAZYLEN(qliphoth_abnos))
		var/mob/living/simple_animal/hostile/abnormality/meltem = pick(qliphoth_abnos)
		meltem.datum_reference.qliphoth_change(-1)

	//Babies crying hurts your head
	SLEEP_CHECK_DEATH(3)
	for(var/mob/living/L in urange(10, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		to_chat(L, span_warning("The crying hurts your head..."))
		L.deal_damage(20, WHITE_DAMAGE)
		L.playsound_local(get_turf(L), 'sound/abnormalities/fetus/crying.ogg', 50, FALSE)

	addtimer(CALLBACK(src, PROC_REF(check_players)), 30 SECONDS)


/* Work effects */
/mob/living/simple_animal/hostile/abnormality/fetus/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fetus/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return
