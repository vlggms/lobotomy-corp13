/mob/living/simple_animal/hostile/abnormality/tangle
	name = "Tangle"
	desc = "What seems to be a severed head laying in a tangle of hair."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "tangle"
	portrait = "tangle"
	maxHealth = 400
	health = 400
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
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	work_damage_upper = 3
	work_damage_lower = 2
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


/mob/living/simple_animal/hostile/abnormality/tangle/Life()
	if(IsContained)
		var/list/turfs = list()
	var/turf/self_turf = src.loc
	var/turf/inside = locate(self_turf.x+1, self_turf.y, self_turf.z)
	if(inside)
		for(var/turf/T in range(inside, 2))
			if(!T || isclosedturf(T))
				continue
			if(locate(/obj/structure/window) in T.contents)
				continue
			if(locate(/obj/structure/table) in T.contents)
				continue
			if(locate(/obj/structure/railing) in T.contents)
				continue
			turfs += T
	return ..()

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/tangle/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(user.gender == MALE)
		if(work_type == ABNORMALITY_WORK_ATTACHMENT)
			return chance + 20
	else if (user.gender == FEMALE)
		if(work_type == ABNORMALITY_WORK_INSIGHT)
			return chance + 20
	else
		if(work_type == ABNORMALITY_WORK_INSIGHT || work_type == ABNORMALITY_WORK_ATTACHMENT)
			return chance + 10
	return chance

/mob/living/simple_animal/hostile/abnormality/tangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	. = ..()
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 40)
		if(prob(20))
			datum_reference.qliphoth_change(-2)
			Teleport()
		return
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		if(user == last_worker)
			if(prob(instinct_count * 10))
				datum_reference.qliphoth_change(-1)
				var/obj/structure/strangling_hair/N = new(get_turf(user))
				N.buckle_mob(user)
			instinct_count++
			return
		instinct_count = 0
		last_worker = user

//Meltdown Stuff
/mob/living/simple_animal/hostile/abnormality/tangle/MeltdownEnd()
	Teleport()
	return ..()

/mob/living/simple_animal/hostile/abnormality/tangle/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	var/obj/structure/strangling_hair/N = new(get_turf(user))
	N.buckle_mob(user)
	return

/mob/living/simple_animal/hostile/abnormality/tangle/BreachEffect()
	..()
	new /obj/structure/spreading/tangle_hair (src)

/mob/living/simple_animal/hostile/abnormality/tangle/proc/Teleport()

/mob/living/simple_animal/hostile/abnormality/tangle/death()
	for(var/V in hair_list)
		qdel(V)
		hair_list-=V
	..()

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
		var/obj/structure/spreading/tangle_hair/Hair = new(T)
		Hair.expand(TRUE)
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
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	max_integrity = 10
	base_icon_state = "tanglehair"
	var/safe = FALSE
	var/mob/living/simple_animal/hostile/abnormality/tangle/connected_abno
	var/damage_check_time = 2 SECONDS
	var/damaging = FALSE

/obj/structure/spreading/tangle_hair/Initialize()
	. = ..()

	//Stolen from Snow White's. Thanks Para!
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/tangle) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.hair_list += src
	expand()


/obj/structure/spreading/tangle_hair/expand()
	addtimer(CALLBACK(src, PROC_REF(expand)), 5 SECONDS)
//	if(connected_abno.hair_list.len>=150)
// 		return
	if(!safe)
		return ..()

/obj/structure/spreading/tangle_hair/Crossed(atom/movable/AM)
	. = ..()
	if(!can_expand || !ishuman(AM))
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
	if(prob(10))
		H.deal_damage(2, WHITE_DAMAGE, attack_type = (ATTACK_TYPE_ENVIRONMENT))
		H.Immobilize(5)
		to_chat(H, span_warning("You get caught in the hair!"))
	else
		H.deal_damage(1, WHITE_DAMAGE, attack_type = (ATTACK_TYPE_ENVIRONMENT))

//The strangling hair.
/obj/structure/strangling_hair
	name = "blonde hair"
	desc = "A mass of hair that constricts someone."
	icon = 'icons/effects/effects.dmi'
	icon_state = "dingle_roots_person"
	max_integrity = 35
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	layer = ABOVE_MOB_LAYER
	pixel_y = -6
	var/damage = 2
	var/damage_cooldown
	var/damage_cooldown_time = 3 SECONDS

/obj/structure/strangling_hair/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/swarming_roots/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return

/obj/structure/strangling_hair/buckle_mob(mob/living/M, force, check_loc, buckle_mob_flags)
	if(M.buckled)
		return
	ADD_TRAIT(M, TRAIT_INCAPACITATED, type)
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, type)
	return ..()

/obj/structure/strangling_hair/sleeping/post_buckle_mob(mob/living/M)
	..()
	animate(M, pixel_y = -6, time = 3)

/obj/structure/swarming_roots/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
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
				playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', 60, TRUE)

/obj/structure/strangling_hair/proc/release_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x
	unbuckle_mob(M,force=1)
	src.visible_message(text("<span class='danger'>[M] is free from [src]!</span>"))
	REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, type)
	M.update_icon()

/obj/structure/strangling_hair/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()