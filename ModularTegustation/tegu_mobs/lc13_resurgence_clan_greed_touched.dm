//////////////
// GREED TOUCHED CLAN UNITS
//////////////
// Corrupted variants of standard clan units
// All units have been twisted by an unknown corruption, mixing their mechanical forms with pulsating flesh
// Stats are generally improved but units leave corruption behind

//////////////
// GREED TOUCHED MELEE UNITS
//////////////

// Scout variant - faster with flesh appendages
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
	footstep_type = FOOTSTEP_MOB_SLIME

// Blood trail effect
/mob/living/simple_animal/hostile/clan/scout/greed/Move()
	. = ..()
	if(prob(20))
		playsound(src, 'sound/effects/footstep/slime1.ogg', 15, TRUE)

// Defender variant - bone-like protrusions form shield
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

// Bone spike effect on lock
/mob/living/simple_animal/hostile/clan/defender/greed/Lock()
	. = ..()
	playsound(src, 'sound/effects/wounds/crack1.ogg', 50, TRUE)
	for(var/turf/T in range(1, src))
		if(prob(30))
			new /obj/effect/temp_visual/cult/sparks(T)

// Drone variant - corrupted healing systems
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

// Corruption particles on heal
/mob/living/simple_animal/hostile/clan/drone/greed/on_beam_tick(mob/living/target)
	. = ..()
	if(prob(5))
		new /obj/effect/temp_visual/cult/sparks(get_turf(target))
		playsound(src, 'sound/abnormalities/nothingthere/disguise.ogg', 5, TRUE)

// Demolisher variant - organic battering rams
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

// Spreads corruption on demolish
/mob/living/simple_animal/hostile/clan/demolisher/greed/demolish(atom/fool)
	. = ..()
	playsound(fool, 'sound/effects/splat.ogg', 75, TRUE)
	if(prob(25))
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(fool))

//////////////
// GREED TOUCHED SPECIAL UNITS
//////////////

// Assassin variant - flesh tendrils for impossible movement
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

// Flesh effects on stealth
/mob/living/simple_animal/hostile/clan/assassin/greed/EnterStealth()
	. = ..()
	playsound(src, 'sound/abnormalities/nothingthere/disguise.ogg', 40, TRUE)
	new /obj/effect/temp_visual/cult/sparks(get_turf(src))

// Corruption on backstab
/mob/living/simple_animal/hostile/clan/assassin/greed/PerformBackstab(mob/living/L)
	. = ..()
	new /obj/effect/decal/cleanable/blood/drip(get_turf(L))
	L.visible_message(span_danger("Viscous fluid drips from [L]'s wounds!"))

//////////////
// GREED TOUCHED RANGED UNITS
//////////////

// Sniper variant - grotesque flesh eye for targeting
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

// Pulsating eye effect
/mob/living/simple_animal/hostile/clan/ranged/sniper/greed/PrepareToFire(atom/A)
	. = ..()
	playsound(src, 'sound/abnormalities/nothingthere/disguise.ogg', 40, TRUE)
	visible_message(span_warning("[src]'s flesh eye pulsates grotesquely as it locks onto [A]!"))

// Gunner variant - multiple flesh weapon barrels
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

// Gunner corrupted projectile
/obj/projectile/clan_bullet/greed_gunner
	name = "corrupted bolt"
	icon_state = "toxin"
	damage = 7
	damage_type = RED_DAMAGE
	color = "#7CFC00"

// Rapid variant - writhing mass of organic barrels
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

// Writhing effect on fire
/mob/living/simple_animal/hostile/clan/ranged/rapid/greed/OpenFire(atom/A)
	. = ..()
	if(prob(30))
		visible_message(span_warning("[src]'s flesh barrels writhe and convulse!"))

/obj/projectile/clan_bullet/greed_rapid
	name = "flesh bolt"
	icon_state = "declone"
	damage = 5
	damage_type = RED_DAMAGE

// Bomber Spider variant - organic explosive core
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

// Gibs on explosion
/mob/living/simple_animal/hostile/clan/bomber_spider/greed/Detonate()
	. = ..()
	for(var/turf/T in range(2, src))
		if(prob(50))
			new /obj/effect/decal/cleanable/blood/gibs(T)


// Warper variant - corrupted space-warping
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

// Corrupted warper special attack with chanting
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
	playsound(src, 'sound/abnormalities/nothingthere/disguise.ogg', 75, TRUE)

	// Channel for 10 seconds
	addtimer(CALLBACK(src, PROC_REF(CompleteTeleport), center), 10 SECONDS)

// Chanting procedure
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

// Disgust effect on teleport
/mob/living/simple_animal/hostile/clan/ranged/warper/greed/TeleportMob(mob/living/L, turf/destination)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.adjust_disgust(20)
		to_chat(H, span_warning("You feel... different after that teleportation."))

// Harpooner variant - organic tentacle launcher
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

// Tentacle projectile
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

// Tentacle chain visual
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
// Drops from above, spawns minions, spreads corruption
// Creates meat structures and corrupted floor that damages enemies
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
	var/meat_pulse_cooldown_time = 15 SECONDS
	var/floor_pulse_cooldown = 0
	var/floor_pulse_cooldown_time = 25 SECONDS
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

// Corruption pulse management
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

// Meat pulse - creates expanding corruption
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

// Floor pulse - creates damaging floor effect
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
					expansion_turfs += adjacent

	// If no corruption exists, create initial area
	if(!corrupted_turfs.len)
		for(var/turf/open/T in range(corruption_range, src))
			if(locate(/obj/effect/corrupter_floor) in T || locate(/obj/structure/corrupter_meat) in T)
				continue
			new /obj/effect/corrupter_floor(T)
	else
		// Expand existing corruption
		for(var/turf/open/T in expansion_turfs)
			// Double-check no floor effect already exists
			if(locate(/obj/effect/corrupter_floor) in T)
				continue
			if(prob(40) && !locate(/obj/structure/corrupter_meat) in T) // 40% chance to expand to each valid tile, avoid meat structures
				new /obj/effect/corrupter_floor(T)

//////////////
// CORRUPTION EFFECTS
//////////////

// Meat structure - deals WHITE damage on contact
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

// Floor effect - visual corruption indicator
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

// Summon system - creates greed touched units
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

// Recall summons to corrupter
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

// Death cleanup - removes all corruption
/mob/living/simple_animal/hostile/clan/ranged/corrupter/greed/death()
	// Kill all summoned mobs
	for(var/mob/living/M in summoned_mobs)
		if(!QDELETED(M) && M.stat != DEAD)
			M.visible_message(span_warning("[M] collapses as its master falls!"))
			M.death()
	summoned_mobs.Cut()

	// Clean up all corruption effects
	visible_message(span_notice("As [src] falls, all traces of corruption begin to fade..."))

	// Remove all meat structures
	for(var/obj/structure/corrupter_meat/meat in range(15, src))
		qdel(meat)

	// Remove all floor effects
	for(var/obj/effect/corrupter_floor/floor in range(15, src))
		animate(floor, alpha = 0, time = 10)
		QDEL_IN(floor, 1 SECONDS)

	return ..()

// Warning indicator - 5 second red warning
/obj/effect/temp_visual/giantwarning/red
	duration = 5 SECONDS
	color = "#FF0000"

//////////////
// RESURGENCE TAPE - X-CORP CAVE EXPEDITION
//////////////
/obj/item/tape/resurgence/xcorp_caves
	name = "Tinkerer's Log: Cave Expedition"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'X-Corp Resource Acquisition' written on it's back. The tape is stained with something viscous..."
	icon_state = "tape_red"
	storedinfo = list(
		"Metallic footsteps echo through cave tunnels, accompanied by the sound of drilling equipment...",
		span_game_say(span_name("Scout") + span_message(" says,") + " &quot;Ti-inke-er, we ha-ave fo-ound X-Co-orp ma-arkings on the-e wa-alls...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Excellent. Their mining equipment should still be salvageable after that collapse.&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Send the defenders ahead to clear any debris. We need those industrial drills.&quot;"),
		"Sounds of heavy machinery moving deeper into the cave...",
		span_game_say(span_name("Defender") + span_message(" reports,") + " &quot;Path cle-ear. But... stran-ange growths on walls... They pu-ulse...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Just scrape them off with your shields. Clear a path for the others.&quot;"),
		"Sounds of metal scraping against wet organic matter...",
		span_game_say(span_name("Defender") + span_message(" alarmed,") + " &quot;It's sti-icking to my shie-eld! Spre-eading up my ar-arm!&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" irritated,") + " &quot;Then use the drones to burn it off. We don't have time for this.&quot;"),
		"Sounds of flames, followed by mechanical screaming...",
		span_game_say(span_name("Drone") + span_message(" panicking,") + " &quot;The fla-ames ma-ade it wor-orse! It's gro-owing fas-aster!&quot;"),
		span_game_say(span_name("Scout") + span_message(" reports,") + " &quot;De-ead X-Co-orp wor-orkers ahead... but they-ey have the sa-ame growths...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Perfect. Study the corpses. If X-Corp workers survived long enough to get this deep, there must be a way to resist it.&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" commands,") + " &quot;Scouts, examine the bodies closely. Find what protected them.&quot;"),
		"Multiple scouts moving toward the bodies...",
		span_game_say(span_name("Scout") + span_message(" horrified,") + " &quot;They-ey're not dea-ead! THE-EY'RE NOT DEA-EAD!&quot;"),
		"A sickening crunch as the 'corpses' grab the scouts...",
		span_game_say(span_name("Scout") + span_message(" screams,") + " &quot;IT'S IN-INSIDE ME! GET IT OU-OUT!&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" urgently,") + " &quot;Cut off the infected parts! Use your drills! Don't let it spread!&quot;"),
		span_game_say(span_name("Demolisher") + span_message(" says,") + " &quot;Dri-illing into Scou-out Seven... But the gro-owth is spre-eading to my dri-ills!&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" frustrated,") + " &quot;Then use explosives! Blast the infected units before—&quot;"),
		"A massive explosion echoes through the cave...",
		span_game_say(span_name("Defender") + span_message(" corrupted voice,") + " &quot;The explo-osion... spre-ead the spo-ores... every-yone is... cha-anging...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" realizing,") + " &quot;No... Every solution just made it worse... EVERYONE RETREAT!&quot;"),
		span_game_say(span_name("Corrupted Units") + span_message(" in unison,") + " &quot;Too... la-ate... Tin-nke-rer... Your ord-ders... led us... to perfe-ection...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" desperately,") + " &quot;Remaining units! Seal the tunnel! NOW!&quot;"),
		"Sound of The Tinkerer's mechanical legs rapidly retreating as the cave collapses...",
		span_game_say(span_name("The Tinkerer") + span_message(" says to recorder,") + " &quot;Lost forty-three units. Every order I gave... only accelerated the infection.&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" bitterly,") + " &quot;Scraping spread it. Fire made it grow. Drilling gave it new hosts. Explosives... scattered it everywhere.&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" coldly,") + " &quot;X-Corp set a trap. They knew someone would try to salvage their equipment.&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;But they underestimated me. I'll build new units. Better ones. Ones that won't fail me.&quot;"),
		"In the distance, corrupted mechanical voices echo from the sealed cave...",
		span_game_say(span_name("Greed Touched Defenders") + span_message(" distantly moaning,") + " &quot;We... fol-lowed... your... ord-ders... perfectly... Tin-nke-rer...&quot;"),
		"The tape cuts to static as wet, mechanical sounds grow closer to the surface..."
	)
	timestamp = list(2, 5, 9, 13, 16, 19, 23, 26, 29, 33, 36, 39, 43, 46, 49, 52, 55, 58, 61, 64, 67, 70, 73, 76, 79, 82, 85, 88, 91, 94, 97, 100, 103, 106, 109, 112, 115)
