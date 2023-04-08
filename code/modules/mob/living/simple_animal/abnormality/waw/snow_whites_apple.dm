GLOBAL_LIST_EMPTY(vine_list)

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple
	name = "Snow White’s Apple"
	desc = "An abnormality taking the form of a tall humanoid with an apple for a head."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "snowwhitesapple_inert"
	icon_living = "snowwhitesapple_inert"
	icon_dead = "snowwhitesapple_dead"
	var/icon_aggro = "snowwhitesapple_active"
	maxHealth = 1600
	health = 1600
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.5)
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	projectilesound = 'sound/creatures/venus_trap_hit.ogg'
	ranged_message = null
	can_breach = TRUE
	threat_level = WAW_LEVEL
	wander = 0
	start_qliphoth = 1
	del_on_death = FALSE
	deathmessage = "collapses into a pile of plantmatter."
	vision_range = 15
	deathsound = 'sound/creatures/venus_trap_death.ogg'
	attacked_sound = 'sound/creatures/venus_trap_hurt.ogg'
	ranged_ignores_vision = TRUE //if it'll fire ranged attacks even if it lacks vision on its target, only works with environment smash
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 40, 40),
						ABNORMALITY_WORK_INSIGHT = list(10, 20, 45, 45, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 0, 0, 0),
						ABNORMALITY_WORK_REPRESSION = list(20, 30, 55, 55, 60)
						)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	initial_language_holder = /datum/language_holder/plant //mostly flavor
	var/togglemovement
	var/plants_off
	var/plant_cooldown = 30
	var/teleport_cooldown
	var/teleport_cooldown_delay = 60 SECONDS

	ego_list = list(
	/datum/ego_datum/weapon/stem,
	/datum/ego_datum/armor/stem
	)
	gift_type =  /datum/ego_gifts/stem
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/BreachEffect(mob/living/carbon/human/user)
	..()
	update_icon()
	GiveTarget(user)
	addtimer(CALLBACK(src, .proc/TryTeleport), 5)

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/update_icon_state()
	if(status_flags & GODMODE) // Not breaching
		icon_state = initial(icon)
	else if(health < 1)
		icon_state = icon_dead
	else // Breaching
		icon_state = icon_aggro
	icon_living = icon_state

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Move()
	if(!togglemovement)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Destroy()
	for(var/obj/structure/apple_vine/vine in GLOB.vine_list)
		vine.can_expand = FALSE
		var/del_time = rand(4,10) //all the vines dissapear at different interval so it looks more organic.
		animate(vine, alpha = 0, time = del_time SECONDS)
		QDEL_IN(vine, del_time SECONDS)
		GLOB.vine_list -= vine
	return ..()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>Snow Whites Apple uses her vines to attack all tresspassers at once.</b>")

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(togglemovement)
		if(plant_cooldown <= world.time)
			plant_cooldown = world.time + (60 SECONDS)
			if(!plants_off)
				SpreadPlants()
			oldGrowth()
	for(var/obj/structure/apple_vine/W in range(15, get_turf(src)))
		if(W.last_expand <= world.time)
			W.expand()
			W.last_expand = world.time + W.expand_cooldown
	if(teleport_cooldown <= world.time && !togglemovement && !client)
		TryTeleport()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/AttackingTarget(atom/attacked_target)
	target = attacked_target
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/OpenFire()
	if(client)
		togglemovement = TRUE
		switch(chosen_attack)
			if(1)
				if(ranged_cooldown <= world.time)
					vinespike()
		return

	if(ranged_cooldown <= world.time)
		vinespike()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/TryTeleport() //stolen from knight of despair
	dir = 2
	if(teleport_cooldown > world.time)
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_delay
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.xeno_spawn)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5) // TODO: Add some cool effects here
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)
	SpreadPlants()
	oldGrowth()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/SpreadPlants()
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/structure/apple_vine) in get_turf(src))
		return
	new /obj/structure/apple_vine(loc)

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/vinespike()
	for(var/mob/living/L in livinginview(vision_range, src))
		if(faction_check_mob(L))
			continue
		for(var/obj/structure/apple_vine/W in get_turf(L))
			W.vinespike()
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/oldGrowth()
	for(var/obj/structure/apple_vine/W in range(15, get_turf(src)))
		if(W.name != "bitter growth")
			W.name = "bitter growth"
			W.icon_state = "Hvy1"
			W.max_integrity = 45
			W.obj_integrity = 45
			W.expand_cooldown = 8 SECONDS



//stolen alien weed code
/obj/structure/apple_vine
	gender = PLURAL
	name = "bitter flora"
	desc = "Branches that grow from wilting stems."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Med1"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = FLAMMABLE
	base_icon_state = "Med1"
	max_integrity = 15
	color = "#808000"
	var/last_expand = 0 //last world.time this weed expanded
	var/expand_cooldown = 1.5 SECONDS
	var/can_expand = TRUE
	var/list/static/ignore_typecache
	var/list/static/atom_remove_condition
	var/static/list/blacklisted_turfs

/obj/structure/apple_vine/Initialize()
	. = ..()

	GLOB.vine_list += src

	if(!atom_remove_condition)
		atom_remove_condition = typecacheof(list(
			/obj/projectile/ego_bullet/ego_match,
			/mob/living/simple_animal/hostile/abnormality/helper,))

	if(!blacklisted_turfs)
		blacklisted_turfs = typecacheof(list(
			/turf/open/space,
			/turf/open/chasm,
			/turf/open/lava,
			/turf/open/openspace))

	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/mob/dead,
			/mob/living/simple_animal/hostile/abnormality/snow_whites_apple))

/obj/structure/apple_vine/Crossed(atom/movable/AM)
	. = ..()
	if(is_type_in_typecache(AM, atom_remove_condition))
		take_damage(15, BRUTE, "melee", 1)
	if(is_type_in_typecache(AM, ignore_typecache))		// Don't want the traps triggered by sparks, ghosts or projectiles.
		return
	if(isliving(AM))
		vine_effect(AM)

/obj/structure/apple_vine/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', 60, TRUE)

/obj/structure/apple_vine/proc/expand() //called by snow white every life cycle
	if(!can_expand)
		return

	var/turf/U = get_turf(src)
	if(is_type_in_typecache(U, blacklisted_turfs))
		qdel(src)
		return FALSE

	for(var/turf/T in U.GetAtmosAdjacentTurfs())
		if(locate(/obj/structure/apple_vine) in T)
			continue

		if(is_type_in_typecache(T, blacklisted_turfs))
			continue

		new /obj/structure/apple_vine(T)
	return TRUE

/obj/structure/apple_vine/proc/vine_effect(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/lonely = L
		var/obj/item/trimming = lonely.get_active_held_item()
		var/brooch = lonely.ego_gift_list[BROOCH]
		if(istype(brooch, /datum/ego_gifts/stem))
			suiterReaction(lonely)
			return
		if(!isnull(trimming))
			if(istype(trimming, /obj/item/ego_weapon/stem))
				return
			var/weeding = trimming.get_sharpness()
			if(weeding == SHARP_EDGED && trimming.force >= 5)
				if(prob(10))
					to_chat(lonely, "<span class='warning'>You cut back the [name] as it reaches for you.</span>")
				else if(prob(10) || (prob(30) && name == "bitter growth"))
					to_chat(lonely, "<span class='warning'>The [name] stab your legs spitefully.</span>")
					lonely.adjustBlackLoss(5)
				lonely.adjustStaminaLoss(5)
				qdel(src)
				return
			return
	if(prob(10))
		to_chat(L, "<span class='warning'>The [name] tighten around you.</span>")
	L.adjustStaminaLoss(10, TRUE, TRUE)

/obj/structure/apple_vine/proc/suiterReaction(mob/living/carbon/human/lonely)
	var/lonelyhealth = (lonely.health / lonely.maxHealth) * 100
	if(prob(10))
		to_chat(lonely, "<span class='nicegreen'>The branches open a path.</span>") //it would be uncouth for the vines to hinder one gifted by the princess.
	if(lonelyhealth <= 30 && lonely.stat != DEAD)
		lonely.adjustBruteLoss(-1)
		if(prob(2))
			lonely.whisper(pick("First they had feasted upon my poisioned flesh, then i feasted upon them.",
				"Even after they left, my form would not decay.","She cast me aside and left with her prince. After many days i wondered why i continued to exist.",
				"How long has it been since the witch died... Where am i?"))

/obj/structure/apple_vine/proc/vinespike() //called by snow white when she attacks
	for(var/mob/living/L in get_turf(src)) //previously used inrange(0)
		var/mob/living/carbon/human/victim = L
		if(victim.stat != DEAD)
			L.apply_damage(30, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = FALSE)
			new /obj/effect/temp_visual/vinespike(get_turf(L))
			return
		if(victim.stat == DEAD && ishuman(victim))
			var/obj/item/organ/eyes/B = L.getorganslot(ORGAN_SLOT_BRAIN)
			if(B)
				new /obj/effect/temp_visual/vinespike(get_turf(L))
				victim.add_overlay(icon('ModularTegustation/Teguicons/tegu_effects.dmi', "f0442_victem"))
				B.Remove(victim)
	return

/obj/effect/temp_visual/vinespike
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "vinespike"
	duration = 10
