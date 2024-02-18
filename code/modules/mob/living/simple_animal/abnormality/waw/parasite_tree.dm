#define THE_LIARS_BLESSING /datum/status_effect/display/parasite_tree_blessing
#define THE_TREE_CURSE /datum/status_effect/display/parasite_tree_curse

//Ive somehow created a system that connects several entities together by using locate. Im unsure if this fragile system
//is better than using global values. Evidence is leaning towards yes.

/mob/living/simple_animal/hostile/abnormality/parasite_tree
	name = "Parasite Tree"
	desc = "A green barked tree with a calm face nested in the center of its trunk. It exudes an aura of tranquility."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "parasitetreeshine"
	icon_living = "parasitetreeshine"
	portrait = "parasite_tree"
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -10
	base_pixel_y = -10
	start_qliphoth = 5
	wander = 0
	can_patrol = FALSE
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 45, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 50, 50, 55),
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/hypocrisy,
		/datum/ego_datum/armor/hypocrisy,
	)

	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	gift_type =  /datum/ego_gifts/hypocrisy
	gift_message = "Your ears seem to have grown longer. Weird."
	var/origin_cooldown = 0 //null when compared to numbers is a eldritch concept so world.time cannot be more or less.
	var/static/list/blessed = list() //keeps track of status effected individuals
	var/static/list/minions = list() //keeps track of minions if suppressed forcefully

/mob/living/simple_animal/hostile/abnormality/parasite_tree/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(dropLeaf))

/mob/living/simple_animal/hostile/abnormality/parasite_tree/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type != ABNORMALITY_WORK_REPRESSION && user.stat != DEAD)
		if(user.has_status_effect(THE_LIARS_BLESSING))
			var/mob/living/carbon/human/witness = locate(/mob/living/carbon/human) in livinginview(1, src) //included mostly for lore since you encourage people to use it.
			if(witness && !witness.has_status_effect(THE_LIARS_BLESSING))
				witness.apply_status_effect(THE_LIARS_BLESSING)
				to_chat(witness, span_notice("The air around [src] makes you feel at peace."))
		else if(datum_reference.qliphoth_meter <= 0)
			user.apply_status_effect(THE_TREE_CURSE)
		else
			user.apply_status_effect(THE_LIARS_BLESSING)
			if(prob(5))
				to_chat(user, span_notice("You hear a voice telling you to bring anyone who needs help here."))
		return
	if(datum_reference.qliphoth_meter <= 4)
		if(canceled || pe < datum_reference.neutral_boxes)
			to_chat(user, span_notice("You feel refreshed after being near [src]."))
			if(datum_reference.qliphoth_meter >= 1)
				user.apply_status_effect(THE_LIARS_BLESSING)
			else
				user.apply_status_effect(THE_TREE_CURSE)
			return ..()
		if(locate(THE_TREE_CURSE) in blessed)
			resetQliphoth()
			for(var/datum/status_effect/display/parasite_tree_curse/curse in blessed)
				qdel(curse)
			to_chat(user, span_nicegreen("The scarlet red eye closes as you smash apart [src]'s flowers."))
			return ..()
		to_chat(user, span_notice("[src] stands silently as you finish destroying the buds."))
		resetQliphoth()
	return ..()

/mob/living/simple_animal/hostile/abnormality/parasite_tree/ZeroQliphoth(mob/living/carbon/human/user)
	if(blessed.len > 0)
		cut_overlays()
		var/mutable_appearance/colored_overlay = mutable_appearance(icon, "parasitetreeeye", layer + 0.1)
		add_overlay(colored_overlay)
		for(var/datum/status_effect/display/parasite_tree_blessing/P in blessed)
			P.facadeFalls()
	else
		datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/parasite_tree/OnQliphothChange(mob/living/carbon/human/user)
	cut_overlays()
	var/budlayer = layer + 0.1
	var/budtype
	switch(datum_reference.qliphoth_meter)
		if(1)
			budtype = "buds4"
		if(2)
			budtype = "buds3"
		if(3)
			budtype = "buds2"
		if(4)
			budtype = "buds1"
		else
			return
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, budtype, budlayer)
	add_overlay(colored_overlay)

/mob/living/simple_animal/hostile/abnormality/parasite_tree/proc/resetQliphoth()
	datum_reference.qliphoth_change(6)

/mob/living/simple_animal/hostile/abnormality/parasite_tree/proc/endBreach()
	if(locate(THE_LIARS_BLESSING) in blessed)
		for(var/datum/status_effect/display/parasite_tree_blessing/P in blessed)
			P.facadeFalls()
		return FALSE
	if(!minions.len && !locate(THE_TREE_CURSE) in blessed) //no minions? no blessed?
		cut_overlays()
		resetQliphoth() //return to non breached sprite while still in containment.
		return TRUE

/mob/living/simple_animal/hostile/abnormality/parasite_tree/proc/dropLeaf()
	SIGNAL_HANDLER

	if(origin_cooldown <= world.time && datum_reference.qliphoth_meter > 0) //cool it on the leaf dropping if your already breaching
		var/list/potentialFollowers = list()
		origin_cooldown = world.time + (10 SECONDS)
		for(var/mob/living/carbon/human/L in GLOB.player_list)
			if(!faction_check_mob(L) && L.stat != DEAD && L.z == z)
				potentialFollowers += L
				potentialFollowers[L] = 1
				if(L.health < (L.maxHealth * 0.6) || L.sanityhealth < (L.maxSanity * 0.6))
					potentialFollowers[L] += (L.health - 1) + (L.sanityhealth - 1)
		if(potentialFollowers.len)
			var/mob/living/carbon/human/chosen_agent = pickweight(potentialFollowers)
			to_chat(chosen_agent, span_nicegreen("A large leaf lands nearby."))
			var/list/possibleleafturf = list()
			for(var/turf/T in oview(3, chosen_agent))
				if(!T.density && !locate(/obj/structure/window || /obj/machinery/door) in T.contents)
					possibleleafturf += T
			if(possibleleafturf.len > 8) //if your in a area with less than 8 steps of space then theres no room for a leaf
				new /obj/structure/liars_leaf(pick(possibleleafturf))

	//SAPLING MINION
/mob/living/simple_animal/hostile/parasite_tree_sapling
	name = "toxic sapling"
	desc = "A humanoid tree, it spews thick noxious gas from its agonized face."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "sapling"
	icon_living = "sapling"
	maxHealth = 800
	health = 800
	can_patrol = FALSE
	wander = 0
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	obj_damage = 0
	del_on_death = TRUE
	environment_smash = ENVIRONMENT_SMASH_NONE
	death_message = "shatters into numerous spongy splinters."
	death_sound = 'sound/creatures/venus_trap_death.ogg'
	attacked_sound = 'sound/creatures/venus_trap_hurt.ogg'
	projectilesound = 'sound/machines/clockcult/steam_whoosh.ogg'
	var/mob/living/simple_animal/hostile/abnormality/parasite_tree/connected_abno

/mob/living/simple_animal/hostile/parasite_tree_sapling/Initialize()
	..()
	icon_living = "sapling[pick(1,2)]"
	icon_state = icon_living
	connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/parasite_tree) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.minions += src

/mob/living/simple_animal/hostile/parasite_tree_sapling/death()
	if(connected_abno)
		connected_abno.minions -= src
		connected_abno.endBreach()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	..()

/mob/living/simple_animal/hostile/parasite_tree_sapling/CanAttack(mob/living/carbon/human/the_target) //Your target has to be human and not have the tree curse.
	if(isturf(the_target) || !the_target || the_target.type == /atom/movable/lighting_object) // bail out on invalids
		return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE

	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE

	if(ishuman(the_target) && the_target.stat != DEAD && !the_target.has_status_effect(THE_TREE_CURSE))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/parasite_tree_sapling/Move()
	return FALSE

/mob/living/simple_animal/hostile/parasite_tree_sapling/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/parasite_tree_sapling/OpenFire()
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(get_turf(src), projectilesound, 10, 1)
	var/smoke_test = locate(/obj/effect/particle_effect/smoke) in view(1, src)
	if(!smoke_test)
		var/datum/effect_system/smoke_spread/parasite_tree/S = new(get_turf(src))
		S.set_up(5, get_turf(src))
		S.start()
		return TRUE
	ranged_cooldown += 1 SECONDS

//SMOKE EFFECT
/obj/effect/particle_effect/smoke/parasite_tree
	name = "thick noxious fumes"
	color = "#AAFF00"
	lifetime = 3
	opaque = TRUE

/obj/effect/particle_effect/smoke/parasite_tree/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return FALSE
	if(lifetime<1)
		return FALSE
	if(C.internal != null || C.has_smoke_protection())
		return FALSE
	if(C.smoke_delay)
		return FALSE
	if(!ishuman(C))
		return FALSE
	if(C.has_status_effect(THE_TREE_CURSE)) //If you have the status effect already dont mess with them.
		return FALSE
	C.smoke_delay++
	addtimer(CALLBACK(src, PROC_REF(remove_smoke_delay), C), 10)
	return smoke_mob_effect(C)


/obj/effect/particle_effect/smoke/parasite_tree/proc/smoke_mob_effect(mob/living/carbon/human/M)
	M.apply_damage(30, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = FALSE)
	if(prob(15))
		M.emote("cough")
	if(M.sanity_lost)
		M.apply_status_effect(THE_TREE_CURSE)
	return TRUE

/datum/effect_system/smoke_spread/parasite_tree
	effect_type = /obj/effect/particle_effect/smoke/parasite_tree

// STATUS EFFECT
/datum/status_effect/display/parasite_tree_blessing
	id = "parasite_tree_blessing"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 50
	alert_type = null
	on_remove_on_mob_delete = TRUE
	display_name = "hypocrisy"
	var/mob/living/simple_animal/hostile/abnormality/parasite_tree/connected_abno

/datum/status_effect/display/parasite_tree_blessing/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
	connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/parasite_tree) in GLOB.abnormality_mob_list
	if(!connected_abno)
		return
	connected_abno.blessed += src
	connected_abno.datum_reference.qliphoth_change(-1)

/datum/status_effect/display/parasite_tree_blessing/tick()
	. = ..()
	if(!ishuman(owner))
		QDEL_IN(src, 5)
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjustSanityLoss(-3)
	if(status_holder.stat == DEAD)
		qdel(src)

/datum/status_effect/display/parasite_tree_blessing/on_remove()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -10)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10)
	if(!connected_abno)
		return ..()
	connected_abno.blessed -= src
	if(status_holder.stat == DEAD)
		connected_abno.datum_reference.qliphoth_change(1)
	return ..()

/datum/status_effect/display/parasite_tree_blessing/proc/facadeFalls()
	owner.apply_status_effect(THE_TREE_CURSE)
	qdel(src)

		//CURSE EFFECT
/datum/status_effect/display/parasite_tree_curse
	id = "parasite_tree_curse"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 50
	alert_type = null
	on_remove_on_mob_delete = TRUE //Alot of people get gibbed by abnormalities, so this ensures they are removed from the blessed list.
	display_name = "hypocrisy"
	var/mob/living/simple_animal/hostile/abnormality/parasite_tree/connected_abno

/datum/status_effect/display/parasite_tree_curse/on_apply()
	. = ..()
	connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/parasite_tree) in GLOB.abnormality_mob_list
	to_chat(owner, span_warning("You feel something sprouting under your skin! Its time to be reborn with the tree."))
	if(connected_abno)
		connected_abno.blessed += src

/datum/status_effect/display/parasite_tree_curse/tick()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost || status_holder.stat == DEAD)
		qdel(src)
	var/tree_toxin = status_holder.maxSanity * 0.20
	status_holder.apply_damage(tree_toxin, WHITE_DAMAGE, null, status_holder.run_armor_check(null, WHITE_DAMAGE), spread_damage = FALSE)

/datum/status_effect/display/parasite_tree_curse/on_remove()
	var/mob/living/carbon/human/status_holder = owner
	if(connected_abno)
		connected_abno.blessed -= src
		if(!owner || status_holder.stat == DEAD)
			connected_abno.endBreach()
	if(status_holder.sanity_lost && status_holder.stat != DEAD)
		var/mob/living/simple_animal/hostile/parasite_tree_sapling/new_mob = new(owner.loc)
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_SUITSTORE))
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_BELT))
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_BACK))
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		QDEL_IN(owner, 5) //rabbit sanity implant explodes at 5
	return ..()

/datum/status_effect/display/parasite_tree_curse/TweakDisplayIcon()
	..()
	icon_overlay.color = "#4B0076" //indigo

/datum/status_effect/display/parasite_tree_curse/proc/nested_items(mob/living/simple_animal/hostile/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

//Parasite Tree Ego Weapon Trap
/obj/structure/liars_leaf
	gender = PLURAL
	name = "strange tree leaf"
	desc = "A leaf from a large tree. Touching it will heal your wounds."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "liars_leaf"
	anchored = TRUE
	density = FALSE
	resistance_flags = FLAMMABLE
	max_integrity = 15
	color = "#AAFF00"
	var/windup = 0

/obj/structure/liars_leaf/Initialize()
	. = ..()
	for(var/obj/structure/liars_leaf/leaf in view(1, get_turf(src)))
		if(leaf != src)
			qdel(src)
	windup = world.time + (1 SECONDS)
	QDEL_IN(src, (15 SECONDS))

/obj/structure/liars_leaf/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM) && windup <= world.time)
		var/mob/living/carbon/human/L = AM
		var/heal_amount = -10
		if(!L.has_status_effect(THE_TREE_CURSE) && !L.has_status_effect(THE_LIARS_BLESSING))
			heal_amount = L.maxHealth * -0.25
			L.apply_status_effect(THE_LIARS_BLESSING)
		L.adjustBruteLoss(heal_amount)
		new /obj/effect/temp_visual/cloud_swirl(get_turf(L)) //placeholder
		to_chat(L, span_nicegreen("Your wounds quickly close after touching the [src]."))
		qdel(src)

#undef THE_LIARS_BLESSING
#undef THE_TREE_CURSE
