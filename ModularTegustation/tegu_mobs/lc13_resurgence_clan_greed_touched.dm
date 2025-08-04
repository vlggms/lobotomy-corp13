// Greed Touched Clan Units - Corrupted by flesh and greed
// All units have been twisted by an unknown corruption, mixing their mechanical forms with pulsating flesh
// MELEE UNITS FROM lc13_resurgence_clan_mobs.dm

// Greed Touched Scout
/mob/living/simple_animal/hostile/clan/scout/greed
	name = "greed touched scout"
	desc = "Once a swift reconnaissance unit, now its legs have been replaced with grotesque flesh appendages that pulse with each movement. Veins of corruption spread across its sensors."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 330 // Slightly more health
	maxHealth = 330
	teleport_away = TRUE
	attack_sound = 'sound/effects/wounds/crackandbleed.ogg'
	footstep_type = FOOTSTEP_MOB_SLIME

// Leave blood trail when moving
/mob/living/simple_animal/hostile/clan/scout/greed/Move()
	. = ..()
	if(prob(20))
		new /obj/effect/decal/cleanable/blood/gibs(loc)
		playsound(src, 'sound/effects/footstep/slime1.ogg', 15, TRUE)

// Greed Touched Defender
/mob/living/simple_animal/hostile/clan/defender/greed
	name = "greed touched defender"
	desc = "Its protective plating has been consumed by flesh growths. Bone-like protrusions form a grotesque shield, while its joints leak a viscous fluid."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_48x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.7, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 880 // More health
	maxHealth = 880
	teleport_away = TRUE
	attack_sound = 'sound/weapons/bladeslice.ogg'

// When locking, create bone spikes
/mob/living/simple_animal/hostile/clan/defender/greed/Lock()
	. = ..()
	playsound(src, 'sound/effects/wounds/crack1.ogg', 50, TRUE)
	for(var/turf/T in range(1, src))
		if(prob(30))
			new /obj/effect/temp_visual/cult/sparks(T)

// Greed Touched Drone
/mob/living/simple_animal/hostile/clan/drone/greed
	name = "greed touched drone"
	desc = "The healing systems have been corrupted, now pulsing with unholy energy. Flesh tendrils extend from its frame, writhing as it seeks to 'heal' others with its corruption."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.9, RED_DAMAGE = 1.0, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0.9, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 440 // More health
	maxHealth = 440
	teleport_away = TRUE

// Corrupted healing effects
/mob/living/simple_animal/hostile/clan/drone/greed/on_beam_tick(mob/living/target)
	. = ..()
	if(prob(20))
		new /obj/effect/temp_visual/cult/sparks(get_turf(target))
		playsound(target, 'sound/effects/blobattack.ogg', 15, TRUE)

// DEMOLISHER FROM lc13_resurgence_clan_rce.dm

// Greed Touched Demolisher
/mob/living/simple_animal/hostile/clan/demolisher/greed
	name = "greed touched demolisher"
	desc = "A siege unit consumed by greed. Flesh has fused with its demolition equipment, creating organic battering rams. Each strike leaves behind traces of corruption."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_48x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.7, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 1650 // More health
	maxHealth = 1650
	teleport_away = TRUE

// Organic demolition sounds and corruption spreading
/mob/living/simple_animal/hostile/clan/demolisher/greed/demolish(atom/fool)
	. = ..()
	playsound(fool, 'sound/effects/splat.ogg', 75, TRUE)
	if(prob(25))
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(fool))

// ASSASSIN FROM lc13_resurgence_clan_assassin.dm

// Greed Touched Assassin
/mob/living/simple_animal/hostile/clan/assassin/greed
	name = "greed touched assassin"
	desc = "Stealth systems corrupted by flesh make it even more terrifying. Tendrils of meat allow it to move in impossible ways, while its blade drips with viscous corruption."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 550 // More health
	maxHealth = 550
	teleport_away = TRUE
	attack_sound = 'sound/weapons/bladeslice.ogg'
	backstab_damage = 175

// Flesh tendrils instead of smoke when stealthing
/mob/living/simple_animal/hostile/clan/assassin/greed/EnterStealth()
	. = ..()
	playsound(src, 'sound/effects/blobattack.ogg', 30, TRUE)
	new /obj/effect/temp_visual/cult/sparks(get_turf(src))

// Dripping corruption when backstabbing
/mob/living/simple_animal/hostile/clan/assassin/greed/PerformBackstab(mob/living/L)
	. = ..()
	new /obj/effect/decal/cleanable/blood/drip(get_turf(L))
	L.visible_message(span_danger("Viscous fluid drips from [L]'s wounds!"))

// RANGED UNITS FROM lc13_resurgence_clan_ranged.dm

// Greed Touched Sniper
/mob/living/simple_animal/hostile/clan/ranged/sniper/greed
	name = "greed touched sniper"
	desc = "Its precision optics have been replaced by a grotesque eye of flesh. The weapon barrel is wrapped in pulsating meat that guides each shot with unnatural accuracy."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 440 // More health
	maxHealth = 440
	teleport_away = TRUE
	projectilesound = 'sound/weapons/lasercannonfire.ogg'

// Flesh eye pulsates when aiming
/mob/living/simple_animal/hostile/clan/ranged/sniper/greed/PrepareToFire(atom/A)
	. = ..()
	playsound(src, 'sound/abnormalities/nothingthere/disguise.ogg', 40, TRUE)
	visible_message(span_warning("[src]'s flesh eye pulsates grotesquely as it locks onto [A]!"))

// Greed Touched Gunner
/mob/living/simple_animal/hostile/clan/ranged/gunner/greed
	name = "greed touched gunner"
	desc = "Multiple flesh growths have sprouted additional weapon barrels. Each fires independently, creating a horrifying barrage of corrupted projectiles."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 660 // More health
	maxHealth = 660
	teleport_away = TRUE
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/projectile/clan_bullet/greed_gunner

// Greed corrupted projectile
/obj/projectile/clan_bullet/greed_gunner
	name = "corrupted bolt"
	icon_state = "toxin"
	damage = 7
	damage_type = RED_DAMAGE
	color = "#7CFC00"

// Greed Touched Rapid Drone
/mob/living/simple_animal/hostile/clan/ranged/rapid/greed
	name = "greed touched rapid drone"
	desc = "Flesh tendrils have merged with its weapon systems, creating a writhing mass of organic barrels that spray corrupted energy in all directions."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 385 // More health
	maxHealth = 385
	teleport_away = TRUE
	projectilesound = 'sound/weapons/pulse3.ogg'
	projectiletype = /obj/projectile/clan_bullet/greed_rapid

// Flesh tendrils writhe when firing
/mob/living/simple_animal/hostile/clan/ranged/rapid/greed/OpenFire(atom/A)
	. = ..()
	if(prob(30))
		visible_message(span_warning("[src]'s flesh barrels writhe and convulse!"))

/obj/projectile/clan_bullet/greed_rapid
	name = "flesh bolt"
	icon_state = "declone"
	damage = 5
	damage_type = RED_DAMAGE

// Greed Touched Bomber Spider
/mob/living/simple_animal/hostile/clan/bomber_spider/greed
	name = "greed touched bomber spider"
	desc = "Its explosive core has been infused with organic matter. The countdown is accompanied by the sound of a beating heart, growing faster until detonation."
	icon_state = "drone_repair_greed"
	icon_living = "drone_repair_greed"
	icon_dead = "drone_repair_greed"
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	teleport_away = TRUE

// Heartbeat sounds instead of beeping
/mob/living/simple_animal/hostile/clan/bomber_spider/greed/RapidBeep()
	playsound(src, 'sound/effects/heart_beat.ogg', 50, TRUE)
	visible_message(span_warning("[src] pulses with an organic heartbeat!"))

// Flesh explosion
/mob/living/simple_animal/hostile/clan/bomber_spider/greed/Detonate()
	. = ..()
	for(var/turf/T in range(2, src))
		if(prob(50))
			new /obj/effect/decal/cleanable/blood/gibs(T)


// Greed Touched Warper
/mob/living/simple_animal/hostile/clan/ranged/warper/greed
	name = "greed touched warper"
	desc = "Space-warping technology has been corrupted by flesh. Its teleportation circles now drip with viscous fluids, and those transported report feeling... changed."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 550 // More health
	maxHealth = 550
	teleport_away = TRUE

// Corrupted teleportation effects with chanting
/mob/living/simple_animal/hostile/clan/ranged/warper/greed/SpecialAttack(atom/target)
	if(charge < special_attack_cost || world.time < special_attack_cooldown || casting || !isliving(target))
		return

	// Check if there are any ally mobs in range to teleport
	var/found_allies = FALSE
	for(var/mob/living/L in range(1, src))
		if(L == src)
			continue
		if(faction_check_mob(L))
			found_allies = TRUE
			break

	if(!found_allies)
		return // Don't waste charge if no allies to teleport

	charge -= special_attack_cost
	special_attack_cooldown = world.time + special_attack_cooldown_time

	// Place mark at target
	var/turf/target_turf = get_turf(target)
	visible_message(span_danger("[src] marks [target] for spatial displacement!"))
	playsound(src, 'sound/magic/blind.ogg', 75, TRUE)

	// Create the destination mark
	if(current_mark)
		qdel(current_mark)
	current_mark = new /obj/effect/warper_mark(target_turf)

	// Start casting
	casting = TRUE

	// Begin the corrupted oath
	INVOKE_ASYNC(src, PROC_REF(ChantCorruptedOath))

	// Create magic circle visual effect
	magic_circle = new /obj/effect/clan_magic_circle(get_turf(src))
	magic_circle.icon_state = "fellcircle"

	// Adjust circle position and orientation similar to dragonskull
	var/matrix/M = matrix(magic_circle.transform)
	M.Translate(0, 16)
	var/rot_angle = Get_Angle(get_turf(src), target_turf)
	M.Turn(rot_angle)
	switch(dir)
		if(EAST)
			M.Scale(0.5, 1)
		if(WEST)
			M.Scale(0.5, 1)
		if(NORTH)
			magic_circle.layer -= 0.2
	magic_circle.transform = M

	// Create area markers in 5x5 around us
	var/turf/center = get_turf(src)
	for(var/turf/T in range(2, center))
		var/obj/effect/temp_visual/warper_area/W = new(T)
		area_markers += W

	visible_message(span_userdanger("[src] begins channeling a mass teleportation!"))
	playsound(src, 'sound/magic/charge.ogg', 100, TRUE)

	// Channel for 10 seconds
	addtimer(CALLBACK(src, PROC_REF(CompleteTeleport), center), 10 SECONDS)

// Corrupted oath chanting
/mob/living/simple_animal/hostile/clan/ranged/warper/greed/proc/ChantCorruptedOath()
	var/list/corrupted_chant = list(
		"Flesh of my flesh, hear my call...",
		"By the pact of twisted steel and sinew...",
		"Through dimensions torn and reality bent...",
		"I command thee to the realm beyond!"
	)

	var/list/curse_sounds = list(
		'sound/effects/curse1.ogg',
		'sound/effects/curse2.ogg',
		'sound/effects/curse3.ogg',
		'sound/effects/curse4.ogg',
		'sound/effects/curse5.ogg'
	)

	for(var/i = 1 to 4)
		if(stat == DEAD || !casting)
			return
		say(corrupted_chant[i])
		var/chosen_sound = pick(curse_sounds)
		playsound(src, chosen_sound, 50, TRUE)
		sleep(20) // 2 seconds between each line

// Victims feel corrupted after teleport
/mob/living/simple_animal/hostile/clan/ranged/warper/greed/TeleportMob(mob/living/L, turf/destination)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.adjust_disgust(20)
		to_chat(H, span_warning("You feel... different after that teleportation."))

// Greed Touched Harpooner
/mob/living/simple_animal/hostile/clan/ranged/harpooner/greed
	name = "greed touched harpooner"
	desc = "Its harpoon launcher has become a grotesque orifice. The chains are now organic tendrils that burrow into victims, dragging them to their doom."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_32x48.dmi'
	faction = list("greed_clan", "hostile")
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 1)
	health = 660 // More health
	maxHealth = 660
	final_damage = 60 // More drop damage
	teleport_away = TRUE

/mob/living/simple_animal/hostile/clan/ranged/harpooner/greed/FireHarpoon(atom/target)
	if(chained_target || world.time < harpoon_cooldown)
		return

	visible_message(span_danger("[src] launches a writhing tentacle at [target]!"))
	playsound(src, 'sound/effects/blobattack.ogg', 75, TRUE)

	var/obj/projectile/clan_tentacle/T = new(get_turf(src))
	T.firer = src
	T.preparePixelProjectile(target, src)
	T.fire()

	harpoon_cooldown = world.time + harpoon_cooldown_time

// Organic tentacle projectile for greed touched harpooner
/obj/projectile/clan_tentacle
	name = "flesh tentacle"
	icon_state = "tentacle_end"
	damage = 25
	damage_type = RED_DAMAGE
	speed = 0.6
	projectile_piercing = PASSMOB
	var/chain

/obj/projectile/clan_tentacle/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle")
	..()

/obj/projectile/clan_tentacle/Destroy()
	qdel(chain)
	return ..()

/obj/projectile/clan_tentacle/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/mob/living/simple_animal/hostile/clan/ranged/harpooner/greed/harpooner = firer
		if(istype(harpooner) && get_dist(target, firer) < 15)
			H.visible_message(span_danger("The tentacle burrows into [H]!"), span_userdanger("You feel the tentacle burrow into your flesh!"))
			playsound(H, 'sound/effects/blobattack.ogg', 50, TRUE)
			harpooner.BeginChainPull(H)

/obj/projectile/clan_tentacle/prehit_pierce(atom/A)
	if(isliving(A) && isliving(firer))
		var/mob/living/L = A
		var/mob/living/shooter = firer
		if(shooter.faction_check_mob(L))
			return PROJECTILE_PIERCE_HIT
	return ..()

// Override the chain beam visual for greed touched
/mob/living/simple_animal/hostile/clan/ranged/harpooner/greed/UpdateChainVisuals()
	if(!chained_target)
		if(chain_beam)
			QDEL_NULL(chain_beam)
		return

	if(!chain_beam)
		chain_beam = Beam(chained_target, icon_state = "tentacle")

//////////////
// GREED TOUCHED CORRUPTER
//////////////
// A mob that spawns invisible with a warning indicator, then drops from above dealing area damage
// Corrupted version has flesh-like appearance and leaves corruption behind
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed
	name = "greed touched corrupter"
	desc = "A horrifying fusion of corrupted flesh and dark technology. Reality itself seems to reject its presence."
	icon = 'ModularTegustation/Teguicons/resurgence_greed_48x48.dmi'
	icon_state = "demolisher_bomb"
	icon_living = "demolisher_bomb"
	faction = list("greed_clan", "hostile")
	maxHealth = 2400 // More health
	health = 2400
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 30
	melee_damage_upper = 40
	melee_damage_type = RED_DAMAGE
	attack_verb_continuous = "corrupts"
	attack_verb_simple = "corrupt"
	attack_sound = 'sound/effects/curse2.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	ranged = TRUE
	ranged_cooldown_time = 10 SECONDS
	projectiletype = /obj/projectile/clan_bullet/greed_rapid
	projectilesound = 'sound/weapons/gun/pistol/shot_suppressed.ogg'
	teleport_away = TRUE

	// Corruption pulse variables
	var/meat_pulse_cooldown = 0
	var/meat_pulse_cooldown_time = 10 SECONDS
	var/floor_pulse_cooldown = 0
	var/floor_pulse_cooldown_time = 15 SECONDS
	var/corruption_range = 1 // Starting range for corruption spread

	// Summoning variables
	var/list/summoned_mobs = list()
	var/max_summons = 6
	var/recall_cooldown = 0
	var/recall_cooldown_time = 60 SECONDS
	var/summon_cooldown = 0
	var/summon_cooldown_time = 30 SECONDS
	var/list/spawn_weights = list(
		/mob/living/simple_animal/hostile/clan/scout/greed = 35,
		/mob/living/simple_animal/hostile/clan/drone/greed = 25,
		/mob/living/simple_animal/hostile/clan/ranged/rapid/greed = 20,
		/mob/living/simple_animal/hostile/clan/ranged/gunner/greed = 15,
		/mob/living/simple_animal/hostile/clan/defender/greed = 10,
		/mob/living/simple_animal/hostile/clan/ranged/sniper/greed = 8,
		/mob/living/simple_animal/hostile/clan/assassin/greed = 5,
		/mob/living/simple_animal/hostile/clan/demolisher/greed = 3
	)
	var/list/spawn_limits = list(
		/mob/living/simple_animal/hostile/clan/scout/greed = 3,
		/mob/living/simple_animal/hostile/clan/drone/greed = 1,
		/mob/living/simple_animal/hostile/clan/ranged/rapid/greed = 2,
		/mob/living/simple_animal/hostile/clan/ranged/gunner/greed = 2,
		/mob/living/simple_animal/hostile/clan/defender/greed = 1,
		/mob/living/simple_animal/hostile/clan/ranged/sniper/greed = 1,
		/mob/living/simple_animal/hostile/clan/assassin/greed = 1,
		/mob/living/simple_animal/hostile/clan/demolisher/greed = 1
	)

/mob/living/simple_animal/hostile/clan/ranged/corrupter
	name = "resurgence corrupter"
	desc = "A twisted amalgamation of corrupted technology and malevolent intent. It seems to phase in and out of reality."
	icon = 'ModularTegustation/Teguicons/resurgence_48x48.dmi'
	icon_state = "demolisher_bomb"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 25
	melee_damage_upper = 35
	melee_damage_type = RED_DAMAGE
	attack_verb_continuous = "corrupts"
	attack_verb_simple = "corrupt"
	attack_sound = 'sound/effects/curse2.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_advanced = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	ranged = TRUE
	ranged_cooldown_time = 10 SECONDS
	projectiletype = /obj/projectile/clan_bullet
	projectilesound = 'sound/weapons/gun/pistol/shot_suppressed.ogg'

	var/spawn_complete = FALSE
	var/is_spawning = FALSE

/mob/living/simple_animal/hostile/clan/ranged/corrupter/Initialize()
	. = ..()
	if(!is_spawning)
		StartSpawnSequence()

/mob/living/simple_animal/hostile/clan/ranged/corrupter/proc/StartSpawnSequence()
	is_spawning = TRUE
	// Make invisible
	alpha = 0
	density = FALSE
	status_flags |= GODMODE // Can't be hurt while spawning

	// Create warning indicator - using Baba Yaga's warning but red and 5 seconds
	new /obj/effect/temp_visual/giantwarning/red(get_turf(src))

	// Wait 5 seconds
	addtimer(CALLBACK(src, PROC_REF(PerformDropAttack)), 5 SECONDS)

/mob/living/simple_animal/hostile/clan/ranged/corrupter/proc/PerformDropAttack()
	// Falling animation similar to Baba Yaga
	pixel_z = 128
	alpha = 255
	playsound(get_turf(src), 'sound/effects/curse3.ogg', 75, TRUE)

	// Animate falling
	animate(src, pixel_z = 0, time = 10)
	sleep(10)

	// Land with impact
	density = TRUE
	status_flags &= ~GODMODE
	spawn_complete = TRUE
	visible_message(span_danger("[src] crashes down from above!"))
	playsound(get_turf(src), 'sound/effects/explosion1.ogg', 100, FALSE, 10)

	// Create visual effects
	var/obj/effect/temp_visual/decoy/D = new(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)

	// Deal damage in 3x3 area
	for(var/turf/T in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		new /obj/effect/temp_visual/cult/sparks(T)

	for(var/mob/living/L in range(1, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(100, RED_DAMAGE)
		to_chat(L, span_userdanger("The impact sends you flying!"))
		var/throw_dir = get_dir(src, L)
		if(!throw_dir)
			throw_dir = pick(GLOB.alldirs)
		L.throw_at(get_edge_target_turf(L, throw_dir), 3, 2)

/mob/living/simple_animal/hostile/clan/ranged/corrupter/Move()
	return FALSE

/mob/living/simple_animal/hostile/clan/ranged/corrupter/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/clan/ranged/corrupter/OpenFire()
	return FALSE

// Greed touched version overrides
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/PerformDropAttack()
	// Falling animation with flesh corruption
	pixel_z = 128
	alpha = 255
	playsound(get_turf(src), 'sound/effects/curse5.ogg', 75, TRUE)
	playsound(get_turf(src), 'sound/effects/blobattack.ogg', 50, TRUE)

	// Animate falling
	animate(src, pixel_z = 0, time = 10)
	sleep(10)

	// Land with impact
	density = TRUE
	status_flags &= ~GODMODE
	spawn_complete = TRUE
	visible_message(span_danger("[src] crashes down from above in a shower of corrupted flesh!"))
	playsound(get_turf(src), 'sound/effects/splat.ogg', 100, FALSE, 10)
	playsound(get_turf(src), 'sound/effects/explosion1.ogg', 75, FALSE, 10)

	// Create visual effects
	var/obj/effect/temp_visual/decoy/D = new(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)

	// Deal damage in 3x3 area and leave corruption
	for(var/turf/T in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		new /obj/effect/temp_visual/cult/sparks(T)
		if(prob(50))
			new /obj/effect/decal/cleanable/blood/gibs(T)

	for(var/mob/living/L in range(1, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(120, RED_DAMAGE) // More damage than normal
		to_chat(L, span_userdanger("The corrupted impact sends you flying!"))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.adjust_disgust(30)
		var/throw_dir = get_dir(src, L)
		if(!throw_dir)
			throw_dir = pick(GLOB.alldirs)
		L.throw_at(get_edge_target_turf(L, throw_dir), 4, 2) // Throws further

	// Start pulse timers 5 seconds after landing
	meat_pulse_cooldown = world.time + 5 SECONDS
	floor_pulse_cooldown = world.time + 5 SECONDS
	recall_cooldown = world.time + recall_cooldown_time

	// Summon initial defenders and set cooldown
	SummonDefenders()
	summon_cooldown = world.time + summon_cooldown_time

// Override Life() to handle corruption pulses
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/Life()
	. = ..()
	if(!spawn_complete || stat == DEAD)
		return

	// Clean up dead summons
	for(var/mob/M in summoned_mobs)
		if(QDELETED(M) || M.stat == DEAD)
			summoned_mobs -= M

	// Meat structure pulse
	if(world.time >= meat_pulse_cooldown)
		MeatPulse()
		meat_pulse_cooldown = world.time + meat_pulse_cooldown_time

	// Floor corruption pulse
	if(world.time >= floor_pulse_cooldown)
		FloorPulse()
		floor_pulse_cooldown = world.time + floor_pulse_cooldown_time

	// Check separate summon cooldown
	if(world.time >= summon_cooldown)
		SummonDefenders()
		summon_cooldown = world.time + summon_cooldown_time

	// Recall summons periodically
	if(world.time >= recall_cooldown)
		RecallSummons()
		recall_cooldown = world.time + recall_cooldown_time

// Create or spread corrupted meat structures
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/proc/MeatPulse()
	visible_message(span_warning("[src] pulses with corrupted energy!"))
	playsound(src, 'sound/abnormalities/nothingthere/heartbeat.ogg', 75, TRUE)

	var/list/meat_turfs = list()
	var/list/expansion_turfs = list()

	// Find existing meat structures and potential expansion spots
	for(var/turf/T in range(7, src))
		if(locate(/obj/structure/corrupter_meat) in T)
			meat_turfs += T
			// Check adjacent turfs for expansion
			for(var/turf/adjacent in orange(1, T))
				if(!locate(/obj/structure/corrupter_meat) in adjacent && !adjacent.density)
					expansion_turfs += adjacent

	// If no meat exists, create initial ring
	if(!meat_turfs.len)
		for(var/turf/T in range(corruption_range, src))
			if(T.density || locate(/obj/structure/corrupter_meat) in T || locate(/obj/effect/corrupter_floor) in T)
				continue
			// Check for conveyors and barricades
			var/obj/machinery/conveyor/C = locate() in T
			var/obj/structure/barricade/B = locate() in T
			if(C)
				C.take_damage(200, RED_DAMAGE, "melee", 0)
				new /obj/effect/temp_visual/cult/sparks(T)
				continue
			if(B)
				B.take_damage(200, RED_DAMAGE, "melee", 0)
				new /obj/effect/temp_visual/cult/sparks(T)
				continue
			new /obj/structure/corrupter_meat(T)
	else
		// Expand existing meat
		for(var/turf/T in expansion_turfs)
			// Double-check no meat already exists here
			if(locate(/obj/structure/corrupter_meat) in T)
				continue
			if(prob(60) && !locate(/obj/effect/corrupter_floor) in T) // 60% chance to expand to each valid tile, avoid floor effects
				// Check for conveyors and barricades
				var/obj/machinery/conveyor/C = locate() in T
				var/obj/structure/barricade/B = locate() in T
				if(C)
					C.take_damage(200, RED_DAMAGE, "melee", 0)
					new /obj/effect/temp_visual/cult/sparks(T)
					continue
				if(B)
					B.take_damage(200, RED_DAMAGE, "melee", 0)
					new /obj/effect/temp_visual/cult/sparks(T)
					continue
				new /obj/structure/corrupter_meat(T)

// Create or spread necropolis floor effect
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/proc/FloorPulse()
	visible_message(span_danger("[src] releases a wave of deep corruption!"))
	playsound(src, 'sound/effects/curse6.ogg', 100, TRUE)

	var/list/corrupted_turfs = list()
	var/list/expansion_turfs = list()

	// Find existing corrupted floors and potential expansion spots
	for(var/turf/open/T in range(10, src))
		if(locate(/obj/effect/corrupter_floor) in T)
			corrupted_turfs += T
			// Check adjacent turfs for expansion
			for(var/turf/open/adjacent in orange(1, T))
				if(!locate(/obj/effect/corrupter_floor) in adjacent)
					expansion_turfs |= adjacent

	// If no corruption exists, create initial area
	if(!corrupted_turfs.len)
		for(var/turf/open/T in range(corruption_range, src))
			if(locate(/obj/effect/corrupter_floor) in T || locate(/obj/structure/corrupter_meat) in T)
				continue
			new /obj/effect/corrupter_floor(T)
	else
		// Expand existing corruption
		for(var/turf/open/T in expansion_turfs)
			if(prob(40) && !locate(/obj/structure/corrupter_meat) in T) // 40% chance to expand to each valid tile, avoid meat structures
				new /obj/effect/corrupter_floor(T)

// Corrupted meat structure that deals WHITE damage
/obj/structure/corrupter_meat
	name = "corrupted flesh"
	desc = "Pulsating corrupted meat that seems to hunger for life."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "meatvine"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE

/obj/structure/corrupter_meat/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(prob(25))
			H.deal_damage(5, WHITE_DAMAGE)
			to_chat(H, span_warning("The corrupted flesh burns your mind as you step on it!"))

// Visual effect for corrupted floor (cosmetic only)
/obj/effect/corrupter_floor
	name = "corrupted ground"
	desc = "The ground here has been deeply corrupted."
	icon = 'icons/turf/floors.dmi'
	icon_state = "necro1"
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/corrupter_floor/Initialize()
	. = ..()
	if(prob(30))
		icon_state = pick("necro1", "necro2", "necro3")
	// Add some visual flair
	alpha = 0
	animate(src, alpha = 255, time = 10)

// Summon defender mobs
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/proc/SummonDefenders()
	if(summoned_mobs.len >= max_summons)
		return

	var/summon_count = rand(2, 3)
	var/spawned = 0

	for(var/i = 1 to summon_count)
		if(summoned_mobs.len >= max_summons)
			break

		// Try to pick a valid mob type that hasn't reached its limit
		var/attempts = 0
		var/mob_type = null
		while(attempts < 10 && !mob_type)
			attempts++
			var/potential_type = pickweight(spawn_weights)

			// Count how many of this type we already have
			var/current_count = 0
			for(var/mob/living/M in summoned_mobs)
				if(istype(M, potential_type))
					current_count++

			// Check if we can spawn more of this type
			if(current_count < spawn_limits[potential_type])
				mob_type = potential_type

		if(!mob_type)
			continue // All available types are at their limit

		// Find a valid spawn location
		var/list/valid_turfs = list()
		for(var/turf/T in orange(2, src))
			if(!T.density && !locate(/mob/living) in T)
				valid_turfs += T

		if(!valid_turfs.len)
			continue

		var/turf/spawn_turf = pick(valid_turfs)

		// Spawn the mob with visual effects
		new /obj/effect/temp_visual/dir_setting/cult/phase(spawn_turf)
		playsound(spawn_turf, 'sound/effects/curse4.ogg', 50, TRUE)

		var/mob/living/simple_animal/hostile/clan/summoned = new mob_type(spawn_turf)
		summoned_mobs += summoned
		spawned++

		// Make the summon aware of its summoner
		summoned.faction = faction.Copy()
		summoned.visible_message(span_danger("[summoned] emerges from corrupted flesh!"))

	if(spawned > 0)
		visible_message(span_danger("[src] calls forth [spawned] corrupted defender\s!"))

// Recall all summons to the corrupter
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/proc/RecallSummons()
	var/recalled = 0
	for(var/mob/living/simple_animal/hostile/clan/M in summoned_mobs)
		if(QDELETED(M) || M.stat == DEAD)
			continue

		// Only recall if they don't have a target
		if(!M.target && get_dist(src, M) > 5)
			M.Goto(src, M.move_to_delay, 3)
			M.visible_message(span_notice("[M] is compelled to return to [src]."))
			recalled++

	if(recalled > 0)
		visible_message(span_warning("[src] releases a pulse, calling its minions back!"))
		playsound(src, 'sound/effects/curse1.ogg', 75, TRUE)

// Clean up summons on death
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/death()
	// Kill all summoned mobs
	for(var/mob/living/M in summoned_mobs)
		if(!QDELETED(M) && M.stat != DEAD)
			M.visible_message(span_warning("[M] collapses as its master falls!"))
			M.death()
	summoned_mobs.Cut()
	return ..()

// Red variant of Baba Yaga's warning for Corrupter
/obj/effect/temp_visual/giantwarning/red
	duration = 5 SECONDS
	color = "#FF0000"
