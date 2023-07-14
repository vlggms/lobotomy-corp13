/******************************/
/* Maroon ordeal, Infestation */
/* Straight from Tegu Station */
/******************************/
/mob/living/simple_animal/hostile/ordeal/infestation
	name = "infestation mob master"
	desc = "I will kill whoever spawned this. You goofed up. You are not meant to see this, even."
	faction = list("abominable_infestation")
	a_intent = INTENT_HARM
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	blood_volume = BLOOD_VOLUME_NORMAL

// The general theme is... evolution?
// All of them are primarily weak to PALE and WHITE damage.
// The RED damage is rather inefficient against them.
// Most of them attack with RED damage, with some abilities here and there.

// Broodlings are the main tier 1 caste of the abominations;
// They are fast and weak, but make up for it due to their numbers.
// Used starting from Dawn.
/mob/living/simple_animal/hostile/ordeal/infestation/broodling
	name = "broodling"
	desc = "A small abominable creature, fast and vicious, tends to hunt in packs. Weak on its own, but should not be underestimated."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "broodling"
	icon_living = "broodling"
	icon_dead = "broodling_dead"
	pass_flags = PASSTABLE | PASSMOB
	maxHealth = 120
	health = 120
	move_to_delay = 1.5
	rapid_melee = 3
	melee_damage_lower = 3
	melee_damage_upper = 4
	turns_per_move = 4
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slashmiss.ogg'
	attack_sound_volume = 25
	deathsound = 'sound/effects/ordeals/maroon/broodling_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/abomination = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/abomination = 2)

/mob/living/simple_animal/hostile/ordeal/infestation/broodling/Initialize()
	. = ..()
	AddComponent(/datum/component/swarming)

// Floatflies are a tier 1 caste specializing in dodging all your attacks while up in the sky(air(tiles));
// They are not as fast and not as weak as broodling, avoid fighting up close, and try not to miss your bullets.
// Used starting from Noon.
/mob/living/simple_animal/hostile/ordeal/infestation/floatfly
	name = "floatfly"
	desc = "A flesh creature resembling a big fly. It is moving rapidly from one spot to another, seemingly avoiding all attacks when given a chance."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "fly"
	icon_living = "fly"
	icon_dead = "fly_dead"
	pass_flags = PASSTABLE
	maxHealth = 250
	health = 250
	move_to_delay = 2
	rapid_melee = 2
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/alien_claw_flesh1.ogg'
	deathsound = 'sound/effects/ordeals/maroon/floatfly_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/abomination = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/abomination = 3)

	var/fly_cooldown
	var/fly_cooldown_time = 5 SECONDS
	var/fly_duration = 5 SECONDS

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/Initialize()
	. = ..()
	AddComponent(/datum/component/swarming)

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/death()
	animate(src, pixel_z = 0, time = 3)
	return ..()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	. = ..()
	if(prob(amount * 5)) // Dodge everything like a pro
		animate(src, pixel_x = base_pixel_x + rand(-10, 10), pixel_y = base_pixel_y + rand(-10, 10), time = 2)
		if(ishuman(target) && world.time > fly_cooldown && prob(amount * 2))
			StartFlight()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/Aggro()
	. = ..()
	if(!ishuman(target))
		return .
	if(world.time > fly_cooldown && prob(50))
		StartFlight()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/AttackingTarget()
	. = ..()
	if(. && world.time > fly_cooldown && prob(25))
		StartFlight()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/proc/StartFlight()
	if(QDELETED(src) || stat == DEAD)
		return FALSE
	if(!density || fly_cooldown >= world.time)
		return FALSE
	density = FALSE
	playsound(src, 'sound/effects/ordeals/maroon/floatfly_fly.ogg', 75, TRUE)
	visible_message("<span class='danger'>\The [src] flies upwards!</span>")
	alpha = 200
	var/new_pixel_y = rand(18, 24)
	animate(src, pixel_y = new_pixel_y, time = 5)
	base_pixel_y = new_pixel_y
	addtimer(CALLBACK(src, .proc/EndFlight), fly_duration)

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/proc/EndFlight()
	if(QDELETED(src) || stat == DEAD)
		return FALSE
	fly_cooldown = world.time + fly_cooldown_time
	density = TRUE
	visible_message("<span class='warning'>\The [src] stops its flight.</span>")
	alpha = 255
	animate(src, pixel_y = 0, time = 5)
	base_pixel_y = 0

// Eviscerators are tier 1 caste with relatively high damage and slower movement speed;
// Due to their somewhat slow speed, they can be kited, but be careful to not get cornered.
// Used starting from Noon.
/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator
	name = "eviscerator"
	desc = "A large monster with very sharp spear-like limbs. While it is dangerous, it is still considered to be the lower caste."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "eviscerator"
	icon_living = "eviscerator"
	icon_dead = "eviscerator_dead"
	maxHealth = 700
	health = 700
	move_to_delay = 3
	melee_damage_lower = 35
	melee_damage_upper = 40
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/maroon/eviscerator_attack.ogg'
	deathsound = 'sound/effects/ordeals/maroon/eviscerator_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/abomination = 5)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/abomination = 5)
	// So as to not spam it on accident
	var/aggro_sound_cooldown
	var/list/aggro_sounds = list(
		'sound/effects/ordeals/maroon/eviscerator_aggro_1.ogg',
		'sound/effects/ordeals/maroon/eviscerator_aggro_2.ogg',
		'sound/effects/ordeals/maroon/eviscerator_aggro_3.ogg',
		)

/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	. = ..()
	if(prob(amount * 5) && world.time > aggro_sound_cooldown)
		aggro_sound_cooldown = world.time + 2 SECONDS
		playsound(src, pick(aggro_sounds), rand(35,75), TRUE)

/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator/Aggro()
	. = ..()
	if(ishuman(target) && world.time > aggro_sound_cooldown)
		aggro_sound_cooldown = world.time + 2 SECONDS
		playsound(src, pick(aggro_sounds), rand(35,75), TRUE)

/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator/Moved()
	. = ..()
	if(!(status_flags & GODMODE))
		playsound(get_turf(src), 'sound/effects/ordeals/maroon/eviscerator_step.ogg', 25, 1)

// Assemblers are, believe it or not, tier 1 caste;
// They are overall mediocre in everything, but they are responsible for creating larvas, so don't let one remain alive.
// Used starting from Dusk.
/mob/living/simple_animal/hostile/ordeal/infestation/assembler
	name = "assembler"
	desc = "A large monstrosity with many appendages that it uses to 'assemble' things."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "assembler"
	icon_living = "assembler"
	icon_dead = "assembler_dead"
	maxHealth = 900
	health = 900
	move_to_delay = 3.5
	melee_damage_lower = 25
	melee_damage_upper = 30
	attack_verb_continuous = "pierces"
	attack_verb_simple = "pierce"
	attack_sound = 'sound/weapons/rapidslice.ogg'
	deathsound = 'sound/effects/ordeals/maroon/assembler_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/abomination = 7)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/abomination = 7)
	stat_attack = DEAD
	// Humans add 5; Non-human mobs add 1.
	var/nutrient_stored = 0
	/// Assoc list Type = Nutrient Required; This is responsible for forcing larva's evolution target type
	var/larva_types = list(
		/mob/living/simple_animal/hostile/ordeal/infestation/broodling = 2,
		/mob/living/simple_animal/hostile/ordeal/infestation/floatfly = 4,
		/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator = 6,
		/mob/living/simple_animal/hostile/ordeal/infestation/assembler = 8,
		)
	/// Not actually the limit, but the point where it will forcefully spawn larva without waiting for time
	var/nutrient_max = 10
	/// World time by which we will spawn a larva if we have no target
	var/larva_time

/mob/living/simple_animal/hostile/ordeal/infestation/assembler/Initialize()
	. = ..()
	larva_time = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/infestation/assembler/Life()
	. = ..()
	if(!.)
		return
	if(nutrient_stored >= nutrient_max || world.time >= larva_time)
		AttemptLarva()
		return

/mob/living/simple_animal/hostile/ordeal/infestation/assembler/AttackingTarget()
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			return ..()
		playsound(src, 'sound/effects/ordeals/maroon/assembler_consume.ogg', 50, TRUE)
		visible_message("<span class='danger'>[src] starts to consume \the [L]!</span>")
		if(!do_after(src, 3 SECONDS, target = L))
			return
		for(var/turf/open/T in view(2, L))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, pick(GLOB.alldirs))
		L.gib()
		nutrient_stored += 5
		for(var/mob/living/LL in livinginview(8, src))
			LL.apply_damage(50, WHITE_DAMAGE, null, LL.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	return ..()

/mob/living/simple_animal/hostile/ordeal/infestation/assembler/proc/AttemptLarva(forced_type = null)
	var/mob/living/TL = target
	if(istype(TL) && TL?.stat != DEAD)
		return

	larva_time = world.time + 5 SECONDS
	var/target_type = forced_type
	if(isnull(target_type))
		for(var/thing_type in larva_types)
			if(nutrient_stored < larva_types[thing_type])
				break
			target_type = thing_type

	if(isnull(target_type))
		return

	var/mob/living/simple_animal/hostile/ordeal/infestation/larva/L = new(get_turf(src))
	L.transformation_target_type = target_type
	L.transformation_time = world.time + 15 SECONDS // Assembled larvas hatch faster
	L.color = color
	L.faction = faction
	playsound(L, 'sound/effects/ordeals/maroon/larva_spawn.ogg', rand(35, 50), TRUE)
	visible_message("<span class='warning'>[src] assembles a new [L.name]!</span>")
	nutrient_stored -= larva_types[target_type]

// Larvas, the begining and the end of infestation. Tier 0;
// Weak and run away from every enemy, but given time turn into one of the proper castes.
// Used starting from Dusk.
/mob/living/simple_animal/hostile/ordeal/infestation/larva
	name = "larva"
	desc = "A weird insect-like creature."
	icon_state = "larva"
	icon_living = "larva"
	icon_dead = "larva_dead"
	density = FALSE
	layer = LYING_MOB_LAYER
	speak_emote = list("gurgles")
	pass_flags = PASSTABLE | PASSMOB
	move_to_delay = 1

	health = 100
	maxHealth = 100
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_sound_volume = 10

	butcher_results = list(/obj/item/food/meat/slab/abomination = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/abomination = 1)

	deathsound = 'sound/effects/ordeals/maroon/larva_death_1.ogg'

	// Does not fight, only runs away
	retreat_distance = 7
	minimum_distance = 20

	var/icon_egg = "egg"
	var/icon_egg_dead = "egg_dead"
	/// World.time by which we will turn into egg or finish evolution from one.
	var/transformation_time = 0
	/// List of transformation and times it takes. Only used when not spawned by assembler.
	var/list/transformation_types = list(
		/mob/living/simple_animal/hostile/ordeal/infestation/broodling = 20 SECONDS,
		/mob/living/simple_animal/hostile/ordeal/infestation/floatfly = 30 SECONDS,
		/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator = 40 SECONDS,
		/mob/living/simple_animal/hostile/ordeal/infestation/assembler = 50 SECONDS,
		)
	/// Which mob we will be transformed into
	var/transformation_target_type = null

/mob/living/simple_animal/hostile/ordeal/infestation/larva/Initialize()
	. = ..()
	transformation_time = world.time + rand(60 SECONDS, 90 SECONDS)

/mob/living/simple_animal/hostile/ordeal/infestation/larva/Life()
	. = ..()
	if(!.)
		return
	if(isnull(transformation_time))
		return
	if(isnull(transformation_target_type) && !LAZYLEN(transformation_types))
		return
	if(world.time >= transformation_time)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			to_chat(H, "<span class='userdanger'>Something has wriggled out of your body!</span>")
			H.Knockdown(7) // Gives some time for larva to turn into egg
			H.Stun(3)
			H.apply_damage(100, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			forceMove(get_turf(H))
			playsound(src, 'sound/effects/splat.ogg', 50, TRUE)
			return
		if(icon_state != icon_egg) // Become egg
			BecomeEgg()
			return
		Evolve()

/mob/living/simple_animal/hostile/ordeal/infestation/larva/death()
	if(icon_state == icon_egg)
		animate(src, alpha = 0, time = (5 SECONDS))
		QDEL_IN(src, (5 SECONDS))
	return ..()

/mob/living/simple_animal/hostile/ordeal/infestation/larva/proc/BecomeEgg()
	name = "egg"
	desc = "A weird egg..?"
	icon_state = icon_egg
	icon_living = icon_egg
	icon_dead = icon_egg_dead
	anchored = TRUE
	toggle_ai(AI_OFF)
	deathsound = null
	maxHealth *= 2
	health = maxHealth
	if(isnull(transformation_target_type) && LAZYLEN(transformation_types))
		transformation_target_type = pick(transformation_types)
	if(transformation_target_type in transformation_types)
		transformation_time = world.time + transformation_types[transformation_target_type]
		return
	transformation_time = world.time + rand(45 SECONDS, 60 SECONDS)

/mob/living/simple_animal/hostile/ordeal/infestation/larva/proc/Evolve()
	var/mob/living/simple_animal/broodling = new transformation_target_type(get_turf(src))
	broodling.color = color
	broodling.faction = faction
	if(ckey) // We're player controlled
		broodling.ckey = ckey
	gib()

// Subtype that rushes to random human and "implants" itself, bursting out later.
// Very, VERY dangerous.
/mob/living/simple_animal/hostile/ordeal/infestation/larva/implanter
	icon_state = "larva_implanter"
	retreat_distance = null
	minimum_distance = 1
	deathsound = 'sound/effects/ordeals/maroon/larva_death_2.ogg'

/mob/living/simple_animal/hostile/ordeal/infestation/larva/implanter/Initialize()
	. = ..()
	transformation_time = null // We only evolve after implanting ourselves

/mob/living/simple_animal/hostile/ordeal/infestation/larva/implanter/BecomeEgg()
	. = ..()
	// Transforms really fast, as it only does so after bursting out.
	transformation_time = world.time + 5 SECONDS

/mob/living/simple_animal/hostile/ordeal/infestation/larva/implanter/AttackingTarget()
	if(ishuman(target) && transformation_time == null)
		var/mob/living/carbon/human/H = target
		visible_message("<span class='danger'>[src] bites through [H]'s clothes and skin and wriggles inside!</span>")
		playsound(src, 'sound/effects/ordeals/maroon/larva_implant.ogg', 50, TRUE)
		H.apply_damage(50, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		forceMove(H)
		transformation_time = world.time + rand(120 SECONDS, 240 SECONDS)
		return

