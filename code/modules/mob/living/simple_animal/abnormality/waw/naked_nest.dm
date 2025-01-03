#define INHOSPITABLE_FOR_NESTING 280
#define NAKED_NESTED getorgan(/obj/item/organ/naked_nest)

/mob/living/simple_animal/hostile/abnormality/naked_nest
	name = "Naked Nest"
	desc = "A pulsating round object covered with glistening scales. Tan sludge drips from numerous holes, and something appears to be moving beneath the surface."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "nakednest_inert"
	icon_living = "nakednest_inert"
	portrait = "naked_nest"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 800
	health = 800
	threat_level = WAW_LEVEL //If Naked Nest escaped from the facility it would result in a mass infestation of several civilians. That is bad.
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 45, 50, 50, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 45, 45, 50),
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 40, 40),
	)
	work_damage_amount = 14
	work_damage_type = RED_DAMAGE
	max_boxes = 22
	start_qliphoth = 1
	fear_level = 1

	ego_list = list(
		/datum/ego_datum/weapon/exuviae,
		/datum/ego_datum/armor/exuviae,
		/datum/ego_datum/exuviae,
	)
	gift_type =  /datum/ego_gifts/exuviae
	gift_message = "You manage to shave off a patch of scales."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	can_patrol = FALSE
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5) //same stats as original armor
	stat_attack = HARD_CRIT
	ranged = TRUE
	ranged_cooldown_time = 1
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	death_message = "collapses as its residents flee."
	death_sound = 'sound/effects/dismember.ogg'

	observation_prompt = "In the beginning, a serpent tempted Eve with a bite of the forbidden fruit an act which cast Man out of the Garden of Eden. <br>\
		Now all that remains of that fruit is a rotten, decayed mass squirming with more evil serpents."
	observation_choices = list(
		"Take a bite" = list(TRUE, "Mankind's sin began long ago but it was never the serpent that was evil, it only followed its nature as did Man. <br>\
			The serpents within the fruit paused and entered into your mouth with the bite, and evil took root - \
			it's hard to blame them for mistaking you for being the same as the fruit that has long been their home."),
		"Cover your mouth" = list(FALSE, "They could infect you at any time through any orifice, you best leave in a hurry."),
	)

	var/serpentsnested = 4
	var/origin_cooldown = 0

/mob/living/simple_animal/hostile/abnormality/naked_nest/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30 + PERCENT((user.maxHealth - user.health)/ user.maxHealth)) && !user.NAKED_NESTED)
		new /obj/item/organ/naked_nest(user)
	return

/mob/living/simple_animal/hostile/abnormality/naked_nest/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(60 + PERCENT((user.maxHealth - user.health)/ user.maxHealth)) && !user.NAKED_NESTED)
		new /obj/item/organ/naked_nest(user)
	return

/mob/living/simple_animal/hostile/abnormality/naked_nest/ZeroQliphoth(mob/living/carbon/human/user)
	if(status_flags & GODMODE)
		if(origin_cooldown <= world.time) //To prevent serpent flood there is a delay on how many serpents are brave enough to leave the safety of their nest.
			var/turf/T = pick(GLOB.department_centers)
			var/mob/living/simple_animal/hostile/naked_nest_serpent/serpent = new(get_turf(T))
			serpent.Hide()
			datum_reference.qliphoth_change(1)
			origin_cooldown = world.time + (5 SECONDS)
		return
	if(serpentsnested <= 2)
		serpentsnested = serpentsnested + 1
	return ..()

/mob/living/simple_animal/hostile/abnormality/naked_nest/death(gibbed)
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	if(serpentsnested > 0)
		var/mob/living/simple_animal/hostile/naked_nest_serpent/S = new(get_turf(src))
		S.Hide()
	return ..()

/mob/living/simple_animal/hostile/abnormality/naked_nest/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/naked_nest/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/naked_nest/CanAttack(atom/the_target)
	if(isturf(the_target) || !the_target || the_target.type == /atom/movable/lighting_object) // bail out on invalids
		return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE

	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE

	if(ishuman(the_target))
		var/mob/living/carbon/host = the_target
		if(!host.NAKED_NESTED && host.stat != DEAD) //ONLY EVER TARGET VIABLE HOSTS.
			return TRUE

	return FALSE

/mob/living/simple_animal/hostile/abnormality/naked_nest/Crossed(atom/movable/AM)
	. = ..()
	if(!target && istype(AM, /mob/living/simple_animal/hostile/naked_nest_serpent))
		var/mob/living/simple_animal/hostile/naked_nest_serpent/S = AM
		if(!S.target && !client)
			S.Nest(src)

/mob/living/simple_animal/hostile/abnormality/naked_nest/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(serpentsnested <= 0) //A empty nest falls to ruin
		adjustHealth(5)

/mob/living/simple_animal/hostile/abnormality/naked_nest/OpenFire()
	if(bodytemperature <= INHOSPITABLE_FOR_NESTING || ranged_cooldown > world.time || serpentsnested <= 0 || status_flags & GODMODE) //Do we have serpents? Is it too cold to leave?
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(get_turf(src), 'sound/misc/moist_impact.ogg', 10, 1)
	var/mob/living/simple_animal/hostile/naked_nest_serpent/S = new(get_turf(src))
	S.GiveTarget(target)
	S.Goto(target, S.move_to_delay, 0) //slightly worried how hefty it is calling 2 procs one after another.
	serpentsnested = serpentsnested - 1

/mob/living/simple_animal/hostile/abnormality/naked_nest/proc/RecoverSerpent(mob/living/simple_animal/hostile/naked_nest_serpent/S) //destination of serpents nest proc
	if(serpentsnested <= 5)
		if(S.client)
			to_chat(src, span_nicegreen("You return to the safety of the nest."))
		playsound(get_turf(src), 'sound/misc/moist_impact.ogg', 10, 1)
		qdel(S)
		serpentsnested = serpentsnested + 1
	else if(S.client)
		to_chat(S, span_notice("This nest has no more room."))

/mob/living/simple_animal/hostile/abnormality/naked_nest/proc/Nest() //return to the nest
	for(var/mob/living/simple_animal/hostile/naked_nest_serpent/M in range(0, src))
		M.Nest(src)

/mob/living/simple_animal/hostile/naked_nest_serpent
	name = "naked serpent"
	desc = "A sickly looking green-colored worm."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "nakednest_serpent"
	icon_living = "nakednest_serpent"
	a_intent = "harm"
	melee_damage_lower = 1
	melee_damage_upper = 1
	maxHealth = 5
	health = 5 //STOMP THEM STOMP THEM NOW.
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	density = FALSE //they are worms.
	robust_searching = 1
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_SMALL
	pass_flags = PASSTABLE | PASSMOB
	layer = ABOVE_NORMAL_TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_OPAQUE //Clicking anywhere on the turf is good enough
	del_on_death = 1
	vision_range = 18 //two screens away
	minbodytemp = INHOSPITABLE_FOR_NESTING
	var/panic_timer = 0
	var/mob/living/simple_animal/hostile/abnormality/naked_nest/origin_nest

/mob/living/simple_animal/hostile/naked_nest_serpent/Initialize()
	. = ..()
	var/home_naked_nest = locate(/mob/living/simple_animal/hostile/abnormality/naked_nest) in loc
	if(home_naked_nest)
		origin_nest = home_naked_nest
	AddComponent(/datum/component/swarming)

/mob/living/simple_animal/hostile/naked_nest_serpent/AttackingTarget(atom/attacked_target)
	if(iscarbon(attacked_target))
		var/mob/living/carbon/human/C = attacked_target
		if(C.stat != DEAD && !C.NAKED_NESTED && a_intent == "harm")
			EnterHost(C)
			return
	if(istype(attacked_target, /mob/living/simple_animal/hostile/abnormality/naked_nest))
		var/mob/living/simple_animal/hostile/abnormality/naked_nest/nest = attacked_target
		nest.RecoverSerpent(src)
	return ..()

/mob/living/simple_animal/hostile/naked_nest_serpent/CanAttack(atom/the_target)
	if(panic_timer > world.time)
		return FALSE

	if(isturf(the_target) || !the_target || the_target.type == /atom/movable/lighting_object) // bail out on invalids
		return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE

	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE

	if(ishuman(the_target))
		var/mob/living/carbon/host = the_target
		if(!host.NAKED_NESTED && host.stat != DEAD)
			return TRUE

	return FALSE

/mob/living/simple_animal/hostile/naked_nest_serpent/LoseAggro() //its best to return home
	..()
	if(origin_nest)
		for(var/mob/living/simple_animal/hostile/abnormality/naked_nest/N in oview(vision_range, src))
			if(origin_nest == N.tag)
				Goto(N, 5, 0)
				return

/mob/living/simple_animal/hostile/naked_nest_serpent/proc/EnterHost(mob/living/carbon/host)
	if(prob(50 * (host.health / host.maxHealth)))
		to_chat(host, span_warning("You feel something cold touch the back of your leg!"))
	to_chat(src, span_nicegreen("You’ve found a new nest!"))
	new /obj/item/organ/naked_nest(host)
	QDEL_IN(src, 5)

/mob/living/simple_animal/hostile/naked_nest_serpent/proc/Nest(mob/living/simple_animal/hostile/abnormality/naked_nest/nest)
	for(var/mob/living/simple_animal/hostile/abnormality/naked_nest/N in range(1, src))
		if(nest.serpentsnested <= 5 && origin_nest == N.tag || !origin_nest)
			nest.RecoverSerpent(src)

/mob/living/simple_animal/hostile/naked_nest_serpent/proc/Hide(panic) //procs only on abno breach and organ escape.
	wander = FALSE
	var/list/possiblehidingspots = list()
	for(var/obj/structure/table/t in oview(get_turf(src), 9))
		possiblehidingspots += t

	if(panic)
		panic_timer = world.time + (5 SECONDS)
		vision_range = 4
		for(var/obj/structure/table/t in oview(get_turf(src), 2))
			possiblehidingspots -= t
	var/hidingspot = locate(/obj/structure/table) in possiblehidingspots
	if(hidingspot)
		throw_at(hidingspot, 5, 2, src, FALSE, force = 5, gentle = TRUE) //leap
		Goto((hidingspot), move_to_delay, 0)


/mob/living/simple_animal/hostile/naked_nested
	name = "naked nested"
	desc = "A humanoid form covered in slimy scales. It looks like it is protected by the host’s armor."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "nakednest_minion"
	icon_living = "nakednest_minion"
	icon_dead = "nakednest_miniondead"
	death_message = "collapses into a unrecognizable pile of scales, shredded clothing, and broken serpents."
	melee_damage_lower = 10
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	maxHealth = 300
	health = 300
	stat_attack = CONSCIOUS //When you are put into crit the nested will continue to transform into a nest. I thought about having the nested infest you if your in crit but that seemed a bit too cruel.
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	mob_size = MOB_SIZE_HUMAN
	minbodytemp = INHOSPITABLE_FOR_NESTING
	guaranteed_butcher_results = list(/obj/item/food/meatball/human = 1) //considered having it spawn a single worm on butcher but that seemed cruel.
	var/nesting_time = 40 SECONDS
	var/nestingtimer

/mob/living/simple_animal/hostile/naked_nested/Initialize()
	. = ..()
	nestingtimer = world.time + (nesting_time)
	UpdateArmor(damage_coeff) //in order to fix damage coefficents

/mob/living/simple_animal/hostile/naked_nested/Life()
	. = ..()
	if(stat == DEAD && buffed == 0)
		buffed = 1
		nestingtimer = world.time + (120 SECONDS)
	if(nestingtimer <= world.time && !target)
		Nest()

/mob/living/simple_animal/hostile/naked_nested/gib()
	for(var/atom/movable/AM in src) //morph code
		AM.forceMove(loc)
	return ..()

/mob/living/simple_animal/hostile/naked_nested/proc/Nest()
	var/mob/living/simple_animal/hostile/abnormality/naked_nest/N = new(get_turf(src))
	N.core_enabled = FALSE
	for(var/atom/movable/AM in src) //morph code
		AM.forceMove(N)
	N.ChangeResistances(damage_coeff)
	playsound(get_turf(src), 'sound/misc/moist_impact.ogg', 30, 1)
	qdel(src)

/mob/living/simple_animal/hostile/naked_nested/hour_nesting //for dungeon gamemodes
	name = "festering naked nested"
	maxHealth = 500
	health = 500
	wander = FALSE
	nesting_time = 1 HOURS

	//ORGAN
/obj/item/organ/naked_nest
	name = "writhing mass"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_PARASITE_EGG
	icon_state = "tonguetied"
	color = "gold"
	var/originalskintone
	var/physical_symptoms = FALSE
	var/grow_process = 0

/obj/item/organ/naked_nest/Initialize()
	. = ..()
	if(iscarbon(loc))
		grow_process = world.time + (4 MINUTES)
		Insert(loc)

/obj/item/organ/naked_nest/Insert(mob/living/carbon/M, special = FALSE)
	..()
	var/mob/living/carbon/human/H = M
	H.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	H.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/justice_attribute)
	originalskintone = H.skin_tone

/obj/item/organ/naked_nest/on_find(mob/living/finder)
	. = ..()
	to_chat(finder, span_warning("A portion of [owner]'s brain has been converted into a scaly green tumor."))

/obj/item/organ/naked_nest/on_death()
	. = ..()
	if(!owner)
		if(useable)
			var/mob/living/simple_animal/hostile/naked_nest_serpent/escapee = new(get_turf(src))
			escapee.Hide(TRUE)
		qdel(src)
		return
	growProcess()

/obj/item/organ/naked_nest/Remove(mob/living/carbon/human/M, special = 0)
	if(M && M.stat != DEAD)
		SerpentsPoison(M, FALSE)
		visible_message(span_warning("A green worm leaps out of [M]'s [zone]!"))
	. = ..()

/obj/item/organ/naked_nest/on_life()
	. = ..()
	growProcess()

/obj/item/organ/naked_nest/proc/growProcess()
	var/green_skin_time = grow_process - (1 MINUTES)
	var/mob/living/carbon/human/H = owner
	H.adjustSanityLoss(0.1) //the serpents final destination is your frontal lobe
	H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.1)
	if((H.drunkenness >= 5 || H.bodytemperature <= INHOSPITABLE_FOR_NESTING) && H.stat != DEAD) //increases duration of infection.
		grow_process += (0.8 SECONDS)
		if(prob(30))
			to_chat(H, span_warning("You feel a gurgling noise inside of you..."))
		else if(physical_symptoms && prob(20))
			to_chat(H, span_warning("A sudden spasming headache overtakes you..."))
	if(world.time >= (green_skin_time))
		if(!physical_symptoms)
			physical_symptoms = TRUE
			H.skin_tone = "serpentgreen" //resulted in alteration to helpers.dm
			H.regenerate_icons()
		if(world.time >= grow_process)
			HatchNest(owner)
	return

/obj/item/organ/naked_nest/proc/HatchNest(mob/living/carbon/human/host)
	//If you have melting love and naked nest, melting loves blessing gets priority
	if(TransformOverride(host))
		return
	var/mob/living/simple_animal/hostile/naked_nested/N = new(host.loc) //there was a issue with several converted naked nests getting the same damage coeffs so convert proc had to be moved here.
	NestedItems(N, host.get_item_by_slot(ITEM_SLOT_SUITSTORE))
	NestedItems(N, host.get_item_by_slot(ITEM_SLOT_BELT))
	NestedItems(N, host.get_item_by_slot(ITEM_SLOT_BACK))
	if(host.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		NestedItems(N, host.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		N.UpdateArmor(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))
		//moved to creature proc since changing armor values in the status effect resulted in all naked nested having their armor values changed. Even admin spawned ones.
	playsound(get_turf(host), 'sound/misc/soggy.ogg', 20, 1)
	QDEL_IN(host, 2)

/obj/item/organ/naked_nest/proc/TransformOverride(mob/living/carbon/human/H)
	if(H && H.has_status_effect(/datum/status_effect/display/melting_love_blessing))
		to_chat(H, span_warning("Something in your head writhes as pink slime starts to pour out of your mouth."))
		H.deal_damage(800, BLACK_DAMAGE)
		H.remove_status_effect(/datum/status_effect/display/melting_love_blessing)
		if(!H || H.stat == DEAD)
			return TRUE

/obj/item/organ/naked_nest/proc/NestedItems(mob/living/simple_animal/hostile/naked_nested/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

/obj/item/organ/naked_nest/proc/SerpentsPoison(mob/living/carbon/human/H, perfect_cure)
	if(!H)
		return
	H.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	H.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/justice_attribute)
	if(ishuman(H) && physical_symptoms == 1)
		H.skin_tone = originalskintone
		H.regenerate_icons()
	if(perfect_cure)
		useable = FALSE

#undef INHOSPITABLE_FOR_NESTING

//Offical Cure
/obj/item/serpentspoison
	name = "serpent infestation cure"
	desc = "A formula that removes O-02-74-1 infestation."
	icon = 'icons/obj/chromosomes.dmi'
	icon_state = ""
	color = "gold"

/obj/item/serpentspoison/attack(mob/living/M, mob/user)
	user.visible_message(span_notice("[user] injects [M] with [src]."))
	Cure(M)
	qdel(src)

/obj/item/serpentspoison/attack_self(mob/living/carbon/user)
	user.visible_message(span_notice("[user] injects themselves with [src]."))
	Cure(user)
	qdel(src)

/obj/item/serpentspoison/proc/Cure(mob/living/carbon/target)
	if(target.NAKED_NESTED)
		var/obj/item/organ/naked_nest/C = target.NAKED_NESTED
		C.SerpentsPoison(target, TRUE)
		C.Remove(target)

#undef NAKED_NESTED
