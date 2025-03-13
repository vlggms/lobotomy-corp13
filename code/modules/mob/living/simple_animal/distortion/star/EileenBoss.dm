/mob/living/simple_animal/hostile/distortion/Eileen
	name = "Saint of Gears"
	desc = "An angelic creature wearing white and golden armor with smoke coming out of her."
	icon = 'ModularTegustation/Teguicons/Ensemble64x64.dmi'
	icon_state = "Eileen"
	icon_living = "Eileen"
	icon_dead = "Eileen"
	faction = list("hostile", "crimsonOrdeal", "bongy")
	maxHealth = 10000
	health = 10000
	move_to_delay = 5
	pixel_x = -20
	ranged_ignores_vision = TRUE
	ranged = TRUE
	minimum_distance = 4
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	move_resist = MOVE_FORCE_OVERPOWERING
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	is_flying_animal = TRUE
	del_on_death = TRUE
	can_patrol = TRUE

//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/city/ensemble
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Eileen")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = FEMALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/clothing/suit/armor/ego_gear/city/ensembleweak)
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Black swan is the most strongly related to this guy, but I might make one for it later.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/bluestar //Nothing really fits her much, this is closest.
	egoist_attributes = 130
	can_spawn = 0


	var/can_act = TRUE
	var/unmanifesting
	/// She is never intended to pray unlike what I copied and pasted her from.
	var/damage_taken = 0
	var/damage_reflection = FALSE
	var/beam_cooldown
	var/beam_cooldown_time = 8 SECONDS
	/// White damage dealt on direct hit by beam
	var/beam_direct_damage = 250
	/// White damage dealt every 0.5 seconds to those standing in the beam's smoke
	var/beam_overtime_damage = 30
	var/list/been_hit = list()
	var/circle_cooldown
	var/circle_cooldown_time = 30 SECONDS
	var/circle_radius = 24
	var/circle_overtime_damage = 70
	var/brainwash_cooldown
	var/brainwash_cooldown_time = 600 SECONDS
	var/datum/reusable_visual_pool/RVP = new(1420)
	var/list/spawned_gears = list()
	var/summon_cooldown
	var/summon_cooldown_time = 60 SECONDS
	var/gear_spawn_limit = 4
	var/gear_spawn_number = 2
	var/holy_revival_cooldown
	var/holy_revival_cooldown_base = 750 SECONDS
	var/holy_revival_damage = 200 // White damage, scales with distance
	var/holy_revival_range = 80
	/// List of mobs that have been hit by the revival field to avoid double effect

	///I could not get this proc to auto-equip hat + gloves.
/mob/living/simple_animal/hostile/distortion/Eileen/PostUnmanifest()
	var/mob/living/carbon/human/D = target
	var/obj/item/clothing/head/ego_hat/ensemble/eileen/H = new(get_turf(D))
	D.equip_to_slot_if_possible(H, ITEM_SLOT_HEAD, FALSE, TRUE, TRUE)
	var/obj/item/clothing/gloves/color/white/G = new(get_turf(D))
	D.equip_to_slot_if_possible(G, ITEM_SLOT_HANDS, FALSE, TRUE, TRUE)
	return


/mob/living/simple_animal/hostile/distortion/Eileen/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/gears = 4,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE, TRUE)

/mob/living/simple_animal/hostile/distortion/Eileen/proc/GearSpawn() //stolen from titania
	playsound(get_turf(src), 'sound/distortions/Eileenattack.ogg', 50, 1)
	//How many we have spawned
	listclearnulls(spawned_gears)
	for(var/mob/living/L in spawned_gears)
		if(L.stat == DEAD)
			spawned_gears -= L
	if(length(spawned_gears) >= gear_spawn_limit)
		return

	//Actually spawning them
	for(var/i=gear_spawn_number, i>=0, i--)	//This counts down.
		var/mob/living/simple_animal/hostile/gears/B = new(get_turf(src))
		spawned_gears+=B
	addtimer(CALLBACK(src, PROC_REF(GearSpawn)), summon_cooldown_time)


/mob/living/simple_animal/hostile/ordeal/white_fixer/Initialize()
	. = ..()
	circle_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/distortion/Eileen/Destroy()
	QDEL_NULL(RVP)
	been_hit.Cut()
	return ..()

/mob/living/simple_animal/hostile/distortion/Eileen/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((summon_cooldown > world.time))
		return
	summon_cooldown = world.time + summon_cooldown_time
	GearSpawn()

/mob/living/simple_animal/hostile/distortion/Eileen/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(can_act && circle_cooldown < world.time)
		CircleBeam()

/mob/living/simple_animal/hostile/distortion/Eileen/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/Eileen/AttackingTarget()
	return

/mob/living/simple_animal/hostile/distortion/Eileen/CanAttack(atom/the_target)
	if(ishuman(the_target))
		var/mob/living/carbon/human/H = the_target
		if(H.sanity_lost)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/Eileen/OpenFire()
	if(!can_act)
		return
	if((get_dist(src, target) < 12) && (beam_cooldown < world.time))
		LongBeam(target)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_fixer/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= 99999 && !damage_reflection)
		StartReflecting()

/mob/living/simple_animal/hostile/distortion/Eileen/proc/LongBeam(target)
	if(beam_cooldown > world.time)
		return
	beam_cooldown = world.time + beam_cooldown_time
	can_act = FALSE
	icon_state = "Eileen"
	visible_message(span_warning("[src] begins to fill with smoke while pointing at [target]!"))
	playsound(src, 'sound/effects/ordeals/white/white_beam_start.ogg', 75, FALSE, 10)
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, 24, rand(-20,20))
	var/list/turfs_to_hit = getline(src, target_turf)
	for(var/turf/T in turfs_to_hit)
		RVP.NewCultSparks(T) // Prepare yourselves
	SLEEP_CHECK_DEATH(13)
	playsound(src, 'sound/distortions/Eileenattack.ogg', 75, FALSE, 32)
	been_hit = list()
	var/i = 1
	for(var/turf/T in turfs_to_hit)
		addtimer(CALLBACK(src, PROC_REF(LongBeamTurf), T), i*0.3)
		i++
	SLEEP_CHECK_DEATH(5)
	icon_state = icon_living
	if(!damage_reflection)
		can_act = TRUE

/mob/living/simple_animal/hostile/distortion/Eileen/proc/LongBeamTurf(turf/T)
	var/list/affected_turfs = list()
	for(var/turf/TT in RANGE_TURFS(2, T))
		var/skip = FALSE
		for(var/obj/effect/reusable_visual/RV in TT)
			if(RV.name == "mental smoke") // Already affected by smoke
				skip = TRUE
				break
		if(skip)
			continue
		affected_turfs += TT
		var/obj/effect/reusable_visual/RV = RVP.NewSmoke(TT, 5 SECONDS)
		RV.name = "mental smoke"
		been_hit = HurtInTurf(TT, been_hit, beam_direct_damage, WHITE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)

	for(var/turf/TT in affected_turfs) // Remaining damage effect
		BeamTurfEffect(TT, beam_overtime_damage)

/mob/living/simple_animal/hostile/distortion/Eileen/proc/BeamTurfEffect(turf/T, damage = 10)
	set waitfor = FALSE
	for(var/i = 1 to 5)
		HurtInTurf(T, list(), damage, WHITE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
		sleep(5)

/mob/living/simple_animal/hostile/distortion/Eileen/proc/CircleBeam()
	if(circle_cooldown > world.time)
		return
	can_act = FALSE
	icon_state = "Eileen"
	playsound(src, 'sound/distortions/BlueGear_StrongAtk.ogg', 100, FALSE, 48)
	SLEEP_CHECK_DEATH(21)
	var/turf/target_c = get_turf(src)
	var/remainder = pick(TRUE, FALSE) // Responsible for different circle pattern
	for(var/i = 1 to circle_radius)
		if(remainder) // Skip one segment so it's not difficult to dodge
			if(i % 2 != 1)
				continue
		else
			if(i % 2 == 1)
				continue
		var/list/turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/T in turf_list)
			RVP.NewSmoke(T, 5 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(BeamTurfEffect), T, circle_overtime_damage))
		SLEEP_CHECK_DEATH(0.5)
	SLEEP_CHECK_DEATH(5)
	icon_state = icon_living
	circle_cooldown = world.time + circle_cooldown_time
	if(!damage_reflection)
		can_act = TRUE

/mob/living/simple_animal/hostile/distortion/Eileen/proc/StartReflecting()
	can_act = FALSE
	damage_reflection = TRUE
	damage_taken = 0
	playsound(src, 'sound/effects/ordeals/white/white_reflect.ogg', 50, TRUE, 7)
	visible_message("<span class='warning>[src] starts praying!</span>")
	icon_state = "fixer_w_pray"
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	SLEEP_CHECK_DEATH(10 SECONDS)
	icon_state = icon_living
	ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1))
	damage_reflection = FALSE
	can_act = TRUE

// All damage reflection stuff is down here
/mob/living/simple_animal/hostile/distortion/Eileen/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(QDELETED(src) || stat == DEAD)
		return
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	for(var/turf/T in RANGE_TURFS(1, src))
		RVP.NewSparkles(T)
	playsound(src, 'sound/effects/ordeals/white/white_reflect.ogg', min(15 + damage, 100), TRUE, 4)
	attacker.apply_damage(damage, attack_type, null, attacker.getarmor(null, attack_type))
	RVP.NewSparkles(get_turf(attacker), color = COLOR_VIOLET)

/mob/living/simple_animal/hostile/ordeal/white_fixer/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(!.)
		return
	if(damage_reflection && M.a_intent == INTENT_HARM)
		ReflectDamage(M, M?.dna?.species?.attack_type, M?.dna?.species?.punchdamagehigh)

/mob/living/simple_animal/hostile/ordeal/white_fixer/attack_paw(mob/living/carbon/human/M)
	. = ..()
	if(damage_reflection && M.a_intent != INTENT_HELP)
		ReflectDamage(M, M?.dna?.species?.attack_type, 5)

/mob/living/simple_animal/hostile/ordeal/white_fixer/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!damage_reflection)
		return
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			ReflectDamage(M, M.melee_damage_type, damage)

/mob/living/simple_animal/hostile/ordeal/white_fixer/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	. = ..()
	if(damage_reflection && Proj.firer)
		ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/ordeal/white_fixer/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!damage_reflection)
		return
	var/damage = I.force
	if(ishuman(user))
		damage *= 1 + (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE) / 100)
	ReflectDamage(user, I.damtype, damage)

	//Mass brainwash goes here.
/mob/living/simple_animal/hostile/distortion/Eileen/proc/revive_humans(range_override = null, faction_check = "hostile")
	if(holy_revival_cooldown > world.time)
		return
	if(range_override == null)
		range_override = holy_revival_range
	holy_revival_cooldown = (world.time + holy_revival_cooldown_base)
	been_hit = list()
	playsound(src, 'sound/distortions/Eileenbrainwash.ogg', 75, 1, range_override)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	for(var/i = 1 to range_override)
		turf_list = (target_c.y - i > 0 			? getline(locate(max(target_c.x - i, 1), target_c.y - i, target_c.z), locate(min(target_c.x + i - 1, world.maxx), target_c.y - i, target_c.z)) : list()) +\
					(target_c.x + i <= world.maxx ? getline(locate(target_c.x + i, max(target_c.y - i, 1), target_c.z), locate(target_c.x + i, min(target_c.y + i - 1, world.maxy), target_c.z)) : list()) +\
					(target_c.y + i <= world.maxy ? getline(locate(min(target_c.x + i, world.maxx), target_c.y + i, target_c.z), locate(max(target_c.x - i + 1, 1), target_c.y + i, target_c.z)) : list()) +\
					(target_c.x - i > 0 			? getline(locate(target_c.x - i, min(target_c.y + i, world.maxy), target_c.z), locate(target_c.x - i, max(target_c.y - i + 1, 1), target_c.z)) : list())
		for(var/turf/open/T in turf_list)
			CHECK_TICK
			if(faction_check != "hostile")
				RVP.NewSparkles(T, 10, "#AAFFAA") // Indicating that it's a good thing
			else
				RVP.NewCultSparks(T, 10)
			for(var/mob/living/L in T)
				RVP.NewCultIn(T, L.dir)
				INVOKE_ASYNC(src, PROC_REF(revive_target), L, i, faction_check)
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/distortion/Eileen/proc/revive_target(mob/living/L, attack_range = 1, faction_check = "hostile")
	if(L in been_hit)
		return
	been_hit += L
	if(!(faction_check in L.faction))
		playsound(L.loc, 'sound/machines/clockcult/ark_damage.ogg', 50 - attack_range, TRUE, -1)
		// The farther you are from white night - the less damage it deals
		var/dealt_damage = max(5, holy_revival_damage - attack_range)
		L.deal_damage(dealt_damage, WHITE_DAMAGE)
		if(ishuman(L) && dealt_damage > 25)
			L.emote("scream")
		to_chat(L, span_userdanger("The light... IT BURNS!!"))
	else
		if(istype(L, /mob/living/simple_animal/hostile/apostle) && L.stat == DEAD)
			L.revive(full_heal = TRUE, admin_revive = FALSE)
			L.grab_ghost(force = TRUE)
			to_chat(L, span_notice("The holy light compels you to live!"))
		else if(L.stat != DEAD)
			L.adjustBruteLoss(-(holy_revival_damage * 0.75) * (L.maxHealth/100))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.adjustSanityLoss(-(holy_revival_damage * 0.75) * (H.maxSanity/100))
			L.regenerate_limbs()
			L.regenerate_organs()
			to_chat(L, span_notice("The holy light heals you!"))
/mob/living/simple_animal/hostile/distortion/Eileen/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		if(holy_revival_cooldown < world.time)
			for(var/mob/living/simple_animal/hostile/distortion/Greta)
				continue
			revive_humans()

/mob/living/simple_animal/hostile/gears
	name = "Church of Gears worshipper"
	desc = "A humanoid with smoke coming out of their body, their brain is visible."
	icon = 'ModularTegustation/Teguicons/Ensemble32x32.dmi'
	icon_state = "churchgoon"
	icon_living = "churchgoon"
	del_on_death = TRUE
	maxHealth = 2500
	health = 2500
	blood_volume = 0
	faction = list("hostile", "crimsonOrdeal", "bongy")
	ranged = TRUE
	attack_sound = 'sound/distortions/BlueGear_Atk.ogg'
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	speak_emote = list("bellows")
	pixel_x = 0
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 3
	melee_damage_lower = 40
	melee_damage_upper = 45
	melee_damage_type = RED_DAMAGE

	var/steam_damage = 5
	var/steam_venting = FALSE
	var/can_act = TRUE
	var/guntimer

	ranged = TRUE
	rapid = 1
	rapid_fire_delay = 1
	ranged_cooldown_time = 50
	projectiletype = /obj/projectile/steam
	projectilesound = 'sound/distortions/BlueGear_StrongAtk.ogg'


/mob/living/simple_animal/hostile/gears/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(steam_venting)
		return
	if(health <= (maxHealth * 0.3))
		steam_venting = TRUE
		visible_message(span_warning("[src]'s gear explodes!"), span_boldwarning("Your smoke engine malfunctions!"))
		new /obj/effect/temp_visual/explosion(get_turf(src))
		playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/explosion.ogg', 50, FALSE, 8)
		playsound(get_turf(src), 'sound/distortions/BlueGear_StrongAtk.ogg', 125, FALSE)
		rapid = 3

/mob/living/simple_animal/hostile/gears/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(!steam_venting)
		return
	SpawnSteam()

/mob/living/simple_animal/hostile/gears/proc/SpawnSteam()
	playsound(get_turf(src), 'sound/abnormalities/steam/exhale.ogg', 75, 0, 8)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(2, target_turf))
		if(prob(30))
			continue
		new /obj/effect/temp_visual/palefog(T)
		for(var/mob/living/H in T)
			if(faction_check_mob(H))
				continue
			H.deal_damage(steam_damage, RED_DAMAGE)
	adjustBruteLoss(10)

/mob/living/simple_animal/hostile/gears/MeleeAction()
	if(ranged_cooldown <= world.time && prob(30))
		OpenFire()
		return
	return ..()

/mob/living/simple_animal/hostile/gears/proc/startMoving()
	can_act = TRUE
	deltimer(guntimer)

/obj/projectile/steam
	name = "steam"
	icon_state = "smoke"
	hitsound = 'sound/machines/clockcult/steam_whoosh.ogg'
	damage = 40
	speed = 0.4
	damage_type = RED_DAMAGE

