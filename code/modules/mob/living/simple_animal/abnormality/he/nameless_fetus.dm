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
	observation_choices = list("Call its name.", "Didn't call its name.")
	correct_choices = list("Call its name.")
	observation_success_message = "No one else knows the name of the fetus. <br>\
		But you know. <br>You called its name. <br>\
		The unstoppable desire shut its mouth for a while. <br>Even only for a short time, the desire silenced."
	observation_fail_message = "The fetus is still crying. <br>\
		You plugged your ears silently. <br>No sound is heard."

	can_buckle = TRUE
	var/mob/living/carbon/human/calling = null
	var/satisfied = FALSE
	var/hunger = 0
	var/crying = FALSE
	var/cry_amount = 0

//Work-related
/mob/living/simple_animal/hostile/abnormality/fetus/WorkChance(mob/living/carbon/human/user, chance, work_type) //Insight work has a qliphoth-based success rate
	return chance + (satisfied * 30)

/mob/living/simple_animal/hostile/abnormality/fetus/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(satisfied)
		hunger--
		if(hunger <= 0)
			satisfied = FALSE
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				to_chat(H, span_userdanger("The creature grew hungry!"))

/mob/living/simple_animal/hostile/abnormality/fetus/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(crying || user == src || !ishuman(M) || (GODMODE in M.status_flags))
		to_chat(user, span_warning("[src] rejects your offering!"))
		return FALSE
	. = ..()
	to_chat(user, span_userdanger("The fetus opens its maw and...!"))
	SLEEP_CHECK_DEATH(2 SECONDS)
	if (M in view(1,src))
		M.gib()
		to_chat(user, span_nicegreen("[src] is satisfied by your offering!"))
		satisfied = TRUE
		hunger += 4
		playsound(get_turf(src),'sound/effects/limbus_death.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/fetus/ZeroQliphoth(mob/living/carbon/human/user)
	if(satisfied)
		satisfied = FALSE
		hunger = 0
		datum_reference.qliphoth_change(1)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_userdanger("The fetus grew hungry!"))
	else
		crying = TRUE
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
		satisfied = TRUE
		hunger += 12 //Ehh might as well triple the effects of it being fed if you have to die.
		crying = FALSE
		cry_amount = 0
		return

	addtimer(CALLBACK(src, PROC_REF(check_range)), 2 SECONDS)


/mob/living/simple_animal/hostile/abnormality/fetus/proc/check_players()
	if(datum_reference.qliphoth_meter == 1)
		return
	if(cry_amount >= 20)//Fetus really should stop crying after a while and Kirie said she wanted it to cry 20 times before stoping.
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_userdanger("The creature stoped crying."))
		notify_ghosts("The nameless fetus stop crying.", source = src, action = NOTIFY_ORBIT, header="Something Interesting!") // bless this mess
		datum_reference.qliphoth_change(1)
		cry_amount = 0
		crying = FALSE
		return
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
		//also adds 1 to the cry amount
		cry_amount += 1
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
	for(var/mob/living/L in range(10, src))
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
