/mob/living/simple_animal/hostile/clan
	var/teleport_away = FALSE
	var/decay_weakness = 2

/mob/living/simple_animal/hostile/clan/apply_lc_mental_decay(stacks)
	var/datum/status_effect/stacking/lc_mental_decay/B = src.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
	if(!B)
		src.apply_status_effect(/datum/status_effect/stacking/lc_mental_decay, stacks + decay_weakness)
	else
		B.add_stacks(stacks + decay_weakness)

/mob/living/simple_animal/hostile/clan/death(gibbed)
	. = ..()
	if (teleport_away)
		playsound(src, 'sound/effects/ordeals/white/pale_teleport_out.ogg', 25, TRUE)
		new /obj/effect/temp_visual/beam_out(get_turf(src))
		qdel(src)

/mob/living/simple_animal/hostile/clan/demolisher
	name = "Demolisher"
	desc = "A humanoid looking machine with two drills... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_48x48.dmi'
	icon_state = "demolisher"
	icon_living = "demolisher"
	icon_dead = "demolisher_dead"
	pixel_x = -8
	base_pixel_x = -8
	attack_verb_continuous = "drills"
	attack_verb_simple = "drill"
	health = 1500
	maxHealth = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1.6)
	attack_sound = 'sound/weapons/drill.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 2,
						/obj/item/stack/sheet/silk/azure_advanced = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 3, /obj/item/food/meat/slab/sweeper = 2)
	melee_damage_lower = 5
	melee_damage_upper = 8
	charge = 10
	max_charge = 20
	clan_charge_cooldown = 1 SECONDS
	var/normal_attack_speed = 2
	var/max_attack_speed = 6
	var/demolish_damage = 30
	var/demolish_obj_damage = 600
	teleport_away = TRUE
	var/shield = FALSE
	var/shield_counter = 0
	var/shield_time = 0
	var/max_shield_counter = 15

/mob/living/simple_animal/hostile/clan/demolisher/ChargeUpdated()
	rapid_melee = normal_attack_speed + (max_attack_speed - normal_attack_speed) * charge / max_charge

/mob/living/simple_animal/hostile/clan/demolisher/AttackingTarget()
	if (charge >= max_charge && (isliving(target) || istype(target, /obj)))
		say("Co-mmen-cing Pr-otoco-l: De-emoli-ish")
		demolish(target)
	. = ..()
	if (!target)
		FindTarget()

/mob/living/simple_animal/hostile/clan/demolisher/Life()
	. = ..()
	if (shield && (shield_time < world.time - 5))
		shield = FALSE
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1.6))

/mob/living/simple_animal/hostile/clan/demolisher/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	..()
	if(amount > 0)
		if (shield)
			shield_counter += 1
			if (shield_counter > max_shield_counter && charge > 1)
				shield_counter = 0
				charge--

			var/obj/effect/temp_visual/shock_shield/AT = new /obj/effect/temp_visual/shock_shield(loc, src)
			var/random_x = rand(-16, 16)
			AT.pixel_x += random_x

			var/random_y = rand(5, 32)
			AT.pixel_y += random_y
		else
			if(charge >= 4)
				shield = TRUE
				ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5))
				shield_time = world.time

/mob/living/simple_animal/hostile/clan/demolisher/proc/demolish(atom/fool)
	playsound(fool, 'sound/effects/explosion2.ogg', 60, TRUE)
	new /obj/effect/temp_visual/explosion(get_turf(fool))
	if(isliving(fool))
		var/mob/living/T = fool
		T.deal_damage(demolish_damage, RED_DAMAGE)
	if(istype(fool, /obj))
		var/obj/O = fool
		if(IsSmashable(O))
			O.take_damage(demolish_obj_damage, RED_DAMAGE)
	for(var/turf/T in range(1, fool))
		HurtInTurf(T, list(), (demolish_damage), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE)
		for(var/obj/S in T)
			if(IsSmashable(S))
				S.take_damage(demolish_obj_damage*0.8, RED_DAMAGE)
	for(var/turf/T in range(3, fool))
		for(var/mob/living/L in T)
			L.Knockdown(20)
			shake_camera(L, 5, 5)
	charge = 0
	rapid_melee = normal_attack_speed

/mob/living/simple_animal/hostile/clan/demolisher/death(gibbed)
	var/obj/structure/demolisher_bomb/b = new /obj/structure/demolisher_bomb(loc)
	b.faction = faction
	. = ..()

/obj/structure/demolisher_bomb
	name = "Resurgence Clan Bomb"
	icon = 'ModularTegustation/Teguicons/resurgence_48x48.dmi'
	desc = "There is a sign that says, 'If you can read this, You are in range.'"
	icon_state = "demolisher_bomb"
	max_integrity = 1000
	pixel_x = -8
	base_pixel_x = -8
	density = FALSE
	layer = BELOW_OBJ_LAYER
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 100, BLACK_DAMAGE = 25, PALE_DAMAGE = 100)
	var/object_break = FALSE
	var/detonate_time = 120
	var/beep_time = 10
	var/beep_counter = 0
	var/detonate_max_damage = 4000
	var/detonate_min_damage = 15
	var/detonate_object_max_damage = 4000
	var/detonate_object_min_damage = 400
	var/list/faction = list("hostile")

/obj/structure/demolisher_bomb/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(detonate)), detonate_time)
	addtimer(CALLBACK(src, PROC_REF(beep)), beep_time)

/obj/structure/demolisher_bomb/proc/beep()
	playsound(loc, 'sound/items/timer.ogg', 40, 3, 3)
	if (beep_counter == 0)
		say("T-10 Seconds before detonation...")
	else if (beep_counter == 5)
		say("T-5 Seconds before detonation...")
	else if (beep_counter == 7)
		say("3...")
	else if (beep_counter == 8)
		say("2...")
	else if (beep_counter == 9)
		say("1...")
	else if (beep_counter == 10)
		say("Goodbye, ;)")

	beep_counter++
	addtimer(CALLBACK(src, PROC_REF(beep)), beep_time)

/obj/structure/demolisher_bomb/proc/detonate()
	var/mob/living/carbon/human/dummy/D = new /mob/living/carbon/human/dummy(get_turf(src))
	D.faction = faction
	new /obj/effect/temp_visual/explosion/fast(get_turf(src))
	playsound(src, 'sound/effects/explosion1.ogg', 75, TRUE)
	for(var/mob/living/L in view(8, src))
		if(D.faction_check_mob(L, FALSE))
			continue
		var/dist = get_dist(D, L)
		if(ishuman(L)) //Different damage formulae for humans vs mobs
			L.deal_damage(clamp((15 * (2 ** (8 - dist))), detonate_min_damage, detonate_max_damage), RED_DAMAGE) //15-3840 damage scaling exponentially with distance
		else
			L.deal_damage(600 - ((dist > 2 ? dist : 0 )* 75), RED_DAMAGE) //0-600 damage scaling on distance, we don't want it oneshotting mobs
		if(object_break)
			for(var/turf/T in view(8, src))
				for(var/obj/S in T)
					S.take_damage(clamp((15 * (2 ** (8 - dist))), detonate_object_min_damage, detonate_object_max_damage), RED_DAMAGE)
	explosion(loc, 0, 0, 1)
	qdel(D)
	qdel(src)

/obj/effect/temp_visual/beam_out
	name = "teleport beam"
	desc = "A beam of light"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "beamout"
	pixel_x = -32
	base_pixel_x = -32
	color = "#FF5050"
	randomdir = FALSE
	duration = 4.2
	layer = POINT_LAYER
