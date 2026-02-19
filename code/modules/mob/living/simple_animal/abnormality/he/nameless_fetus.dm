/mob/living/simple_animal/hostile/abnormality/fetus
	name = "Nameless Fetus"
	desc = "A giant, pus-filled baby."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "fetus"
	portrait = "nameless_fetus"
	maxHealth = 800
	health = 800
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 50, 60, 60, 60),
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(20, 30, 30, 30, 30),
	)
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 2)
	start_qliphoth = 1
	pixel_x = -8
	base_pixel_x = -8
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	max_boxes = 18
	melee_damage_type = RED_DAMAGE
	stat_attack = DEAD
	melee_damage_lower = 15
	melee_damage_upper = 30
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/abnormalities/mountain/bite.ogg'
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
	var/crying = FALSE

	can_buckle = TRUE
	var/satisfied = FALSE
	var/hunger = 0

	var/can_act = TRUE
	var/cry_cooldown
	var/cry_cooldown_time = 20 SECONDS
	var/obj/particle_emitter/fetus_cry/particle_cry
	var/bite_cooldown
	var/bite_cooldown_time = 5 SECONDS

/mob/living/simple_animal/hostile/abnormality/fetus/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/fetus/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(cry_cooldown <= world.time && !satisfied)
		cry_cooldown = world.time + cry_cooldown_time
		Cry()

/mob/living/simple_animal/hostile/abnormality/fetus/PickTarget(list/Targets) // We attack corpses first if there are any
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(L.health < 0 || L.stat == DEAD)
			if(ishuman(L))
				highest_priority += L
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/abnormality/fetus/CanAttack(atom/the_target)
	if(ishuman(the_target))
		if(bite_cooldown > world.time || satisfied)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fetus/AttackingTarget(atom/attacked_target)
	if(bite_cooldown > world.time || satisfied || !can_act)
		return FALSE
	. =  ..()
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		if((L.health < 0 || L.stat == DEAD))
			L.gib()
			if(ishuman(L))
				satisfied = TRUE
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					to_chat(H, span_userdanger("The creature is satisfied."))
		bite_cooldown = world.time + bite_cooldown_time

/mob/living/simple_animal/hostile/abnormality/fetus/Destroy()
	if(!particle_cry)
		return ..()
	particle_cry.fadeout()
	return ..()

//Work-related
/mob/living/simple_animal/hostile/abnormality/fetus/WorkChance(mob/living/carbon/human/user, chance, work_type)
	return chance + (satisfied * 20)

/mob/living/simple_animal/hostile/abnormality/fetus/ZeroQliphoth(mob/living/carbon/human/user)
	if(satisfied)
		satisfied = FALSE
		hunger = 0
		datum_reference.qliphoth_change(1)
		visible_message(span_userdanger("The fetus starts to wimper, but only for a moment..."))
	else
		criesleft = 5
		for(var/mob/living/carbon/human/H in GLOB.player_list)	//Way harder to get a list of living humans.
			if(H.stat != DEAD)
				criesleft+=1		//Get a max of 1 additional cry per person.
		crying = TRUE
		check_players()
		check_range()

/mob/living/simple_animal/hostile/abnormality/fetus/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(satisfied)
		hunger--
		if(hunger <= 0)
			satisfied = FALSE
			visible_message(span_userdanger("The fetus is starting to look famished!"))

/mob/living/simple_animal/hostile/abnormality/fetus/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(crying || user == src || !ishuman(M) || (GODMODE in M.status_flags) || M.stat != DEAD)
		to_chat(user, span_warning("[src] rejects your offering!"))
		return FALSE
	. = ..()
	to_chat(user, span_userdanger("The fetus opens its maw and..."))
	SLEEP_CHECK_DEATH(2 SECONDS)
	if(M in view(1,src))
		M.gib()
		to_chat(user, span_nicegreen("[src] is satisfied by your offering!"))
		satisfied = TRUE
		hunger += 4
		playsound(get_turf(src),'sound/effects/limbus_death.ogg', 50, 1)

//Are they nearby?
/mob/living/simple_animal/hostile/abnormality/fetus/proc/check_range()
	var/list/corpses = list()
	var/satisfied = FALSE
	for(var/mob/living/carbon/human/H in view(1,src))
		if(!Adjacent(H))
			continue
		if(H.stat == DEAD)
			corpses += H
	if(!LAZYLEN(corpses))
		addtimer(CALLBACK(src, PROC_REF(check_range)), 2 SECONDS)
		return
	var/mob/living/carbon/human/corpse = pick(corpses)
	if(corpse)
		calling = null
		corpse.gib()
		corpse = null
		hunger += 4 //Not as much compared to fresh meat
		satisfied = TRUE
	if(calling && Adjacent(calling))
		calling.gib()
		calling = null
		hunger += 12 //Ehh might as well triple the effectiveness of it being fed if you have to die.
		satisfied = TRUE
	if(satisfied)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_userdanger("The creature is satisfied."))

		notify_ghosts("The nameless fetus is satisfied.", source = src, action = NOTIFY_ORBIT, header="Something Interesting!") // bless this mess
		datum_reference.qliphoth_change(1)
		return

	addtimer(CALLBACK(src, PROC_REF(check_range)), 2 SECONDS)


/mob/living/simple_animal/hostile/abnormality/fetus/proc/check_players()
	crying = FALSE
	if(datum_reference.qliphoth_meter == 1)
		return
	if(!(status_flags & GODMODE))
		return
	if(criesleft<=0)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_warning("The crying stops. Finally, silence."))
			datum_reference.qliphoth_change(1)
		return

	crying = TRUE
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
	Cry()
	addtimer(CALLBACK(src, PROC_REF(check_players)), 10 SECONDS)

/mob/living/simple_animal/hostile/abnormality/fetus/proc/Cry()
	set waitfor = 0
	can_act = FALSE
	var/list/qliphoth_abnos = list()
	var/list/hearers = list()
	for(var/mob/living/simple_animal/hostile/abnormality/V in urange(15, src))
		if(V.IsContained())
			qliphoth_abnos += V
	if(src in qliphoth_abnos)
		qliphoth_abnos -= src
	if(LAZYLEN(qliphoth_abnos))
		var/mob/living/simple_animal/hostile/abnormality/meltem = pick(qliphoth_abnos)
		meltem.datum_reference.qliphoth_change(-1)
	particle_cry = new(get_turf(src))
	particle_cry.pixel_y = 4
	//Babies crying hurts your head
	playsound(src, 'sound/abnormalities/fetus/crying.ogg', 100, FALSE, 7, 5)
	SLEEP_CHECK_DEATH(3)
	for(var/i = 1 to 8)
		for(var/mob/living/L in urange(15, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			if(!(L in hearers))
				hearers += L
				to_chat(L, span_warning("The crying hurts your head..."))
			L.deal_damage(pick(1,1.5), WHITE_DAMAGE)
		SLEEP_CHECK_DEATH(4)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE
	if(!particle_cry)
		return
	particle_cry.fadeout()


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
