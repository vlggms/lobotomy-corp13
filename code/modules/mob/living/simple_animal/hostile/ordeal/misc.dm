//If you see this, hush hush. - Kirie
/mob/living/simple_animal/hostile/ordeal/black_fixer
	name = "Black Fixer"
	desc = "A humanoid creature wrapped in bandages."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "fixer_b"
	icon_living = "fixer_b"
	faction = list("Head")
	maxHealth = 2700
	health = 2700
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 35
	melee_damage_upper = 35
	ranged = TRUE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.0, PALE_DAMAGE = 0.4)
	move_resist = MOVE_FORCE_OVERPOWERING
	projectiletype = /obj/projectile/black
	attack_sound = 'sound/weapons/resonator_blast.ogg'
	var/pulse_cooldown
	var/pulse_cooldown_time = 15 SECONDS
	var/pulse_damage = 30
	var/busy = FALSE

/mob/living/simple_animal/hostile/ordeal/black_fixer/Initialize()
	..()
	pulse_cooldown = world.time + pulse_cooldown_time

/mob/living/simple_animal/hostile/ordeal/black_fixer/Move()
	if(busy)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/black_fixer/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(pulse_cooldown < world.time)
		pulse()

/obj/projectile/black
	name = "kunai"
	icon_state = "blackfixer"
	damage = 30
	damage_type = BLACK_DAMAGE

/mob/living/simple_animal/hostile/ordeal/black_fixer/proc/pulse()
	icon_state = "fixer_b_attack"
	SLEEP_CHECK_DEATH(5)
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/weapons/resonator_blast.ogg', 100, FALSE, 40)
	for(var/mob/living/L in urange(40, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage(pulse_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	for(var/obj/machinery/computer/abnormality/A in urange(16, src))
		if(prob(66) && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-1, -2))
	SLEEP_CHECK_DEATH(5)
	icon_state = "fixer_b"

/mob/living/simple_animal/hostile/ordeal/black_fixer/AttackingTarget()
	//If he doesn't attack for about 15 seconds, pulse.
	pulse_cooldown = world.time + pulse_cooldown_time
	if(busy)
		return
	..()
	if(prob(25))
		combo()

/mob/living/simple_animal/hostile/ordeal/black_fixer/proc/combo()
	busy = TRUE
	for(var/i = 1 to 6)
		i++
		for(var/mob/living/L in range(1, src))
			var/turf/open/T = get_turf(L)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			playsound(get_turf(src), 'sound/weapons/ego/hammer.ogg', 75, 1)
			L.apply_damage(10, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			SLEEP_CHECK_DEATH(3)
	SLEEP_CHECK_DEATH(10)
	busy = FALSE

//Yeah so this midnight is supposed to be weak as shit.
/mob/living/simple_animal/hostile/ordeal/pink_midnight
	name = "A Party Everlasting"
	desc = "An overturned teacup, a party everlasting."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "party"
	icon_living = "party"
	faction = list("pink_midnight")
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 2000
	health = 2000
	melee_damage_type = PALE_DAMAGE
	armortype = PALE_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 14
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

/mob/living/simple_animal/hostile/ordeal/pink_midnight/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/Breach_All), 5 SECONDS)

	//Funny drags everything to it
/mob/living/simple_animal/hostile/ordeal/pink_midnight/proc/Breach_All()
	for(var/mob/living/simple_animal/hostile/abnormality/A)
		if(A.can_breach && (A.status_flags & GODMODE))
			A.breach_effect()
			var/turf/orgin = get_turf(src)
			var/list/all_turfs = RANGE_TURFS(4, orgin)
			var/turf/open/Y = pick(all_turfs - orgin)
			A.forceMove(Y)
			A.faction += "pink_midnight"
