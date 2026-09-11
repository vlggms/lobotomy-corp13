/mob/living/simple_animal/hostile/abnormality/tangle
	name = "Tangle"
	desc = "What seems to be a severed head laying in a tangle of hair."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "tangle"
	portrait = "tangle"
	maxHealth = 400
	health = 400
	pixel_y = -8
	base_pixel_y = -8
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2)
	melee_damage_lower = 0		//Doesn't attack
	melee_damage_upper = 0
	rapid_melee = 2
	melee_damage_type = WHITE_DAMAGE
	stat_attack = HARD_CRIT
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = -50,
	)
	work_damage_upper = 3
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	ego_list = list(
		/datum/ego_datum/weapon/rapunzel,
		/datum/ego_datum/armor/rapunzel,
	)
	gift_type =  /datum/ego_gifts/rapunzel
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "Four thousand nine-hundred fifty-one... <br>\
	Four thousand nine-hundred fifty-two... <br>\
	The time between you and me... <br>\
	You've put down that much hair, you love me that much... <br>\
	Let the hair down. So I can escape this hell. <br>\
	The hair, let it down. <br>\
	Let the hair down."
	observation_choices = list(
		"Repress the abnormality" = list(FALSE, "We shouldn't get close to the abnormalities. <br>\
			But the abnormality isn't happy with your reply. <br>\
			The hair surrounding you starts sneaking towards you to attack! <br>\
			The cell of tangled hair becomes a mess of blood."),
		"Go along with it" = list(TRUE, "Four thousand nine-hundred ninety-seven... <br>\
			Four thousand nine-hundred ninety-eight... <br>\
			Four thousand nine-hundred ninety-nine..."),
	)

	work_start_lines = list("%PERSON grabs a cute looking pink brush and begins to comb %ABNO's golden locks of hair.")
	middle_work_lines = list("Four thousand eight hundred ninety-nine... Four thousand eight hundred ninety-nine", "Let the hair down. So I can escape from this hell.")
	late_work_lines = list("Four thousand nine hundred fifty-two. Four thousand nine hundred fifty two...", "The hair, let it down. Let the hair down.")


	///If the same person does instinct work on Tangle multiple times in a row, she'll breach.
	var/last_worker = null
	var/instinct_count = 0

	///When she takes 200 damage, she'll trap people with her hair
	var/damage_taken = 0
	var/list/hair_list = list()

/mob/living/simple_animal/hostile/abnormality/tangle/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/tangle/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/tangle/Initialize()
	. = ..()
	var/obj/structure/spreading/tangle_hair/hair = new(src)
	hair.RegisterMob(src)
	hair.safe = TRUE

/mob/living/simple_animal/hostile/abnormality/tangle/Destroy()
	hair_list.Cut()
	return ..()

/mob/living/simple_animal/hostile/abnormality/tangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	. = ..()
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 40)
		if(prob(30))
			datum_reference.qliphoth_change(-2)
			Teleport()
		return
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		if(user.tag == last_worker)
			if(prob(instinct_count * 15))
				update_icon_state()
				datum_reference.qliphoth_change(-1)
				Entangle(user)
				update_icon_state()
			instinct_count++
			return
		instinct_count = 0
		last_worker = user.tag

//Meltdown Stuff
/mob/living/simple_animal/hostile/abnormality/tangle/MeltdownEnd()
	Teleport()
	return ..()

/mob/living/simple_animal/hostile/abnormality/tangle/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	Entangle(user)
	update_icon_state()
	return

/mob/living/simple_animal/hostile/abnormality/tangle/BreachEffect()
	. = ..()
	pixel_y = 0
	base_pixel_y = 0
	update_icon_state()
	for(var/obj/structure/spreading/tangle_hair/H in view(6, src))
		H.safe = FALSE
		H.can_expand = TRUE
		H.rapid_growth_charges = 4
	for(var/obj/structure/spreading/tangle_hair/H in src)
		H.safe = FALSE
		H.can_expand = TRUE
		H.rapid_growth_charges = 4

/mob/living/simple_animal/hostile/abnormality/tangle/proc/Teleport()
	//Keeping the hair while moving tangle would look strange
	for(var/obj/structure/spreading/tangle_hair/H in view(6, src))
		qdel(H)

	var/obj/structure/spreading/tangle_hair/hair = new(src)
	hair.RegisterMob(src)
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.xeno_spawn)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/tangle/PostDamageReaction(damage_amount, damage_type, source, attack_type)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(health < 0 || stat >= DEAD)
		return
	if(damage_taken >= maxHealth * 0.5)
		damage_taken = 0
		INVOKE_ASYNC(src, PROC_REF(Mass_Entanglement))

/mob/living/simple_animal/hostile/abnormality/tangle/proc/Mass_Entanglement()
	playsound(get_turf(src), 'sound/spookoween/girlscream.ogg', 100)
	for(var/mob/living/carbon/human/H in view(5, src))
		if(H.stat == DEAD)
			continue
		Entangle(H)

/mob/living/simple_animal/hostile/abnormality/tangle/proc/Entangle(mob/living/carbon/human/user)
	var/turf/T = get_turf(user)
	to_chat(user, span_danger("[src] entangles you with its hair!"))
	if(!locate(/obj/structure/spreading/tangle_hair in T))
		var/obj/structure/spreading/tangle_hair/hair = new(src)
		hair.RegisterMob(src)
		hair.expand(TRUE)
		hair.safe = IsContained()
	var/obj/structure/strangling_hair/N = new(T)
	N.buckle_mob(user)

/mob/living/simple_animal/hostile/abnormality/tangle/update_icon_state()
	if(IsContained()) // Not breached
		icon_state = initial(icon_state)
		if(datum_reference.qliphoth_meter == 1)
			icon_state = "tangleawake"
		return
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = initial(icon_state)

// Hair turf
/obj/structure/spreading/tangle_hair
	gender = PLURAL
	name = "blonde hair"
	desc = "a patch of blonde hair."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tanglehair"
	anchored = TRUE
	density = FALSE
	max_integrity = 10
	base_icon_state = "tanglehair"
	var/rapid_growth_charges = 4
	var/mob/living/simple_animal/hostile/abnormality/tangle/connected_abno
	var/damage_check_time = 1 SECONDS
	var/damaging = FALSE
	var/safe = FALSE

/obj/structure/spreading/tangle_hair/Destroy()
	UnregisterMob()
	return ..()

/obj/structure/spreading/tangle_hair/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(expand)), 5 SECONDS)

/obj/structure/spreading/tangle_hair/expand()
	//It gets really fast for a few moments before slowing down
	var/spread_offset = (5 SECONDS) + rand(1,10) - ((1 SECONDS) * rapid_growth_charges)
	rapid_growth_charges--
	addtimer(CALLBACK(src, PROC_REF(expand)), spread_offset)
	return ..()

/obj/structure/spreading/tangle_hair/Crossed(atom/movable/AM)
	. = ..()
	if(safe || !ishuman(AM))
		return
	if(!damaging)
		damaging = TRUE
		Check()

/obj/structure/spreading/tangle_hair/proc/Check()
	var/dealt_damage = FALSE
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(!H)
			continue
		if(H.stat != DEAD)
			DoDamage(H)
			dealt_damage = TRUE
	if(!dealt_damage)
		damaging = FALSE
		return
	addtimer(CALLBACK(src, PROC_REF(Check)), damage_check_time)

//The Damage Proc
/obj/structure/spreading/tangle_hair/proc/DoDamage(mob/living/carbon/human/H)
	if(prob(20))
		H.deal_damage(2, RED_DAMAGE, attack_type = (ATTACK_TYPE_ENVIRONMENT))
		H.Immobilize(3)
		to_chat(H, span_warning("You get caught in the hair!"))

/obj/structure/spreading/tangle_hair/PlaceStructure(turf/T)
	if(safe && connected_abno)
		if(T.y < connected_abno.y - 1)
			can_expand = FALSE
			return
	. = ..()
	if(!. || !istype(. , type))
		return
	var/obj/structure/spreading/tangle_hair/A = .
	A.safe = safe
	if(connected_abno)
		A.RegisterMob(connected_abno)

/obj/structure/spreading/tangle_hair/play_attack_sound(damage_amount, damage_type = BRUTE)
	playsound(loc, 'sound/creatures/venus_trap_hit.ogg', 60, TRUE)

//Signal Stuff
/obj/structure/spreading/tangle_hair/proc/RegisterMob(mob/living/L)
	if(!L)
		return
	if(!istype(L, /mob/living/simple_animal/hostile/abnormality/tangle))
		return
	connected_abno = L
	RegisterSignal(connected_abno, list(COMSIG_PARENT_QDELETING), PROC_REF(UnregisterMob))

/obj/structure/spreading/tangle_hair/proc/UnregisterMob()
	if(!connected_abno)
		return
	UnregisterSignal(connected_abno, list(COMSIG_PARENT_QDELETING))
	connected_abno = null
	SelfDestruct()

//The strangling hair.
/obj/structure/strangling_hair
	name = "blonde hair"
	desc = "A mass of blond hair that constricts someone."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tanglehair2"
	max_integrity = 30
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	layer = ABOVE_MOB_LAYER
	var/damage = 2
	var/damage_cooldown
	var/damage_cooldown_time = 4 SECONDS

/obj/structure/strangling_hair/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/swarming_roots/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return

/obj/structure/strangling_hair/buckle_mob(mob/living/M, force, check_loc, buckle_mob_flags)
	if(M.buckled)
		return
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, type)
	return ..()

/obj/structure/strangling_hair/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	return

/obj/structure/strangling_hair/process(delta_time)
	if(damage_cooldown < world.time)
		damage_cooldown = world.time + damage_cooldown_time

		if(has_buckled_mobs())
			var/dealt_damage = FALSE
			for(var/mob/living/carbon/human/H in buckled_mobs)
				if(H.stat == DEAD)
					continue
				H.deal_damage(damage, RED_DAMAGE, attack_type = (ATTACK_TYPE_ENVIRONMENT))
				dealt_damage = TRUE
			if(dealt_damage)
				playsound(loc, 'sound/effects/wounds/crack1.ogg', 60, TRUE)
			return
		qdel(src)

/obj/structure/strangling_hair/proc/release_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x
	unbuckle_mob(M,force=1)
	src.visible_message(text("<span class='danger'>[M] is free from [src]!</span>"), ignored_mobs = M)
	to_chat(M, span_danger("You're free from [src]!"))
	REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, type)
	M.update_icon()

/obj/structure/strangling_hair/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()