/mob/living/simple_animal/hostile/abnormality/skin_prophet
	name = "Skin Prophet"
	desc = "A little fleshy being reading a tiny book."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "skin_prophet"
	icon_dead = "prophet_egg"
	core_icon = "prophet_egg"
	portrait = "skin_prophet"
	del_on_death = FALSE
	maxHealth = 300
	health = 300
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_upper = 3
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE

	rapid_melee = 0.4//extremely slow
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 4
	melee_damage_upper = 5
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	attack_sound = 'sound/abnormalities/skinprophet/Skin_Counter.ogg'

	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	see_in_dark = 10
	can_breach = TRUE
	start_qliphoth = 2

	light_color = LIGHT_COLOR_FIRE
	light_range = 2
	light_power = 7

	ego_list = list(
		/datum/ego_datum/weapon/skinprophet,
		/datum/ego_datum/armor/skinprophet,
	)
	gift_type = /datum/ego_gifts/visions
	can_spawn = FALSE // Normally doesn't appear
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	chem_type = /datum/reagent/abnormality/sin/wrath

	observation_prompt = "Candles quietly burn away. <br>\
		Scribbling sounds are all that fill the air. <br>\
		A trio of eyes takes turns glaring into a grand tome, bound in skin. <br>\
		You can’t tell what it’s referencing, <br>\
		or if there is any deliberation in its writing; <br>\
		hands are busy nonetheless. <br>\
		Yearning for destruction and doom, it writes and writes and writes. <br>\
		You feel the passages it’s writing may be prophecies for someplace and sometime."
	observation_choices = list(
		"Snuff out the candles" = list(TRUE, "You hushed the candles, one by one. <br>\
			The space grew darker, but its hands won’t stop. <br>\
			The only light left was on the quill it held. <br>\
			Even that was snuffed by our breaths. <br>\
			Then, the whole place went dark. <br>\
			All that’s left is the pen in its hand."),
		"Peek at the book" = list(FALSE, "!@)(!@&)&*%(%@!@#*(#)*(%&!@#$ <br>\
			@$*@)$ ? <br> @#$!!@#* ! <br> @*()!%&$(^!!!!@&(@)"),
	)

	var/list/speak_list = list(
		"!@)(!@&)&*%(%@!@#*(#)*(%&!@#$",
		"@$*@)$?",
		"@#$!!@#*!",
		"@*()!%&$(^!!!!@&(@)",
	)
	var/list/candles = list()
	var/list/breach_candles = list()
	var/lit_candles = 0
	var/write_cooldown = 1
	var/write_cooldown_time = 3 SECONDS


/mob/living/simple_animal/hostile/abnormality/skin_prophet/OpenFire(atom/A)//spams too much
	WriteAttack(target)
	ranged_cooldown = world.time + (ranged_cooldown_time + (ranged_cooldown_time * length(breach_candles)))

/mob/living/simple_animal/hostile/abnormality/skin_prophet/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/skin_prophet/death(gibbed)
	SetLights(TRUE)
	playsound(src, 'sound/effects/limbus_death.ogg', 100, 1)
	icon = 'ModularTegustation/Teguicons/abno_cores/teth.dmi'
	pixel_x = -16
	density = FALSE
	for (var/mob/living/simple_animal/hostile/skin_candle/C in breach_candles)
		C.death()
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/skin_prophet/Destroy(force)
	candles = null
	for (var/mob/living/simple_animal/hostile/skin_candle/C in breach_candles)
		C.master = null
	breach_candles = null
	return ..()

/mob/living/simple_animal/hostile/abnormality/skin_prophet/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(!length(breach_candles))
		return ..()
	var/damage_penalty = length(breach_candles)
	amount -= amount * (0.3 * damage_penalty)
	return ..()

/mob/living/simple_animal/hostile/abnormality/skin_prophet/WorktickFailure(mob/living/carbon/human/user)
	if(prob(30))
		say(pick(speak_list))
	..()

/mob/living/simple_animal/hostile/abnormality/skin_prophet/AttemptWork(mob/living/carbon/human/user, work_type)
	..()
	HandleCandles()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/skin_prophet/WorkChance(mob/living/carbon/human/user, chance, work_type)//set the new work chances
	. = chance // Set default Return to chance
	switch(work_type)
		if(ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_INSTINCT)
			chance -= (3 ** lit_candles)//3 to the power of candles. Ranges from 3-81
		if(ABNORMALITY_WORK_REPRESSION)
			chance += (lit_candles * 16)
	return chance

/mob/living/simple_animal/hostile/abnormality/skin_prophet/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)
		return
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		HandleCandles(lighting = TRUE)

/mob/living/simple_animal/hostile/abnormality/skin_prophet/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/skin_prophet/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(canceled)
		return
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		ExtinguishCandles()
	else
		if(pe >= datum_reference.success_boxes)
			HandleCandles(lighting = TRUE)

/mob/living/simple_animal/hostile/abnormality/skin_prophet/PostSpawn()
	..()
	for(var/obj/machinery/light/L in range(3, src)) //blows out the lights
		L.on = 0
		L.break_light_tube()

/mob/living/simple_animal/hostile/abnormality/skin_prophet/HandleStructures()
	. = ..()
	if(!.)
		return
	if(!locate(/obj/structure/skin_candle) in datum_reference.connected_structures)
		candles += SpawnConnectedStructure(/obj/structure/skin_candle, 1, 0)
		candles += SpawnConnectedStructure(/obj/structure/skin_candle, -1, 0)
		candles += SpawnConnectedStructure(/obj/structure/skin_candle, 0, 1)
		candles += SpawnConnectedStructure(/obj/structure/skin_candle, 0, -1)

//***Breach Procs***//
/mob/living/simple_animal/hostile/abnormality/skin_prophet/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	ExtinguishCandles()
	if(breach_type != BREACH_MINING)
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)
	for(var/i in 1 to 4)
		var/turf/T = get_ranged_target_turf(src, (angle2dir(-45 + (i * 90))), rand(2,4))//angle2dir fetches diagonal dirs, starting at 45 degrees.
		var/mob/living/simple_animal/hostile/skin_candle/C = new(T)
		breach_candles += C
		C.master = src
	SetLights(FALSE)

/mob/living/simple_animal/hostile/abnormality/skin_prophet/proc/HandleCandles(lighting = FALSE)
	if(length(candles) == 0)
		for(var/obj/structure/skin_candle/thing in datum_reference.connected_structures)
			candles += thing
	if(lighting)
		if(lit_candles > 4)
			BreachEffect()
			return
		var/obj/structure/skin_candle/C = candles[lit_candles + 1]
		C.LightUp()
		++lit_candles

/mob/living/simple_animal/hostile/abnormality/skin_prophet/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	if(!length(breach_candles))
		return ..()
	if(istype(Proj, /obj/projectile/skin_fire))
		return
	..()
	if(Proj.firer)
		WriteAttack(Proj.firer)

/mob/living/simple_animal/hostile/abnormality/skin_prophet/attackby(obj/item/I, mob/living/user, params)
	if(!length(breach_candles))
		return ..()
	..()
	if(user)
		Counter(user)

//***Work-related procs***
/mob/living/simple_animal/hostile/abnormality/skin_prophet/proc/ExtinguishCandles()
	for(var/obj/structure/skin_candle/C in candles)
		C.LightOff()
	lit_candles = 0

/mob/living/simple_animal/hostile/abnormality/skin_prophet/proc/SetLights(power = TRUE)
	var/area/A = get_area(src)
	A.lightswitch = power
	A.update_icon()
	A.power_change()

/mob/living/simple_animal/hostile/abnormality/skin_prophet/proc/Counter(atom/target)
	if(isliving(target))
		var/mob/living/L = target
		L.throw_at(get_step(src, get_dir(src, target)), 2)
	if(prob(50))
		playsound(src, attack_sound, 75, 0, 3)
	else
		playsound(src, 'sound/abnormalities/skinprophet/Skin_Hit.ogg', 75, 0, 3)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), melee_damage_upper, RED_DAMAGE, check_faction = FALSE, hurt_mechs = TRUE, hurt_structure = TRUE)

/mob/living/simple_animal/hostile/abnormality/skin_prophet/proc/WriteAttack(atom/target)
	playsound(src, 'sound/abnormalities/skinprophet/Skin_Write.ogg', 75, 0, 3)
	var/target_turf = get_turf(target)
	for (var/turf/T in range(target_turf, 1))
		new /obj/effect/temp_visual/cult/sparks(T)
		spawn(15)
			HurtInTurf(T, list(), melee_damage_lower, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE)
			new /obj/effect/temp_visual/smash_effect(T)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(target_turf, 'sound/abnormalities/skinprophet/Skin_Hit.ogg', 75, 0, 3)

//***Containment Structure***
/obj/structure/skin_candle
	name = "candle"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "candle"
	var/lit_icon = "candle_lit"
	anchored = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE
	light_color = LIGHT_COLOR_FIRE
	light_range = 0
	light_power = 0

/obj/structure/skin_candle/proc/LightUp()
	icon_state = lit_icon
	light_range = 2
	light_power = 7
	set_light_on(TRUE)
	update_light()

/obj/structure/skin_candle/proc/LightOff()
	icon_state = initial(icon_state)
	set_light_on(FALSE)

//***Breaching minion***
/mob/living/simple_animal/hostile/skin_candle
	name = "candle"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "candle_lit"
	icon_dead = "candle"
	maxHealth = 15
	health = 15
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.5)
	ranged = TRUE
	check_friendly_fire = TRUE
	gender = NEUTER
	density = FALSE
	projectiletype = /obj/projectile/skin_fire
	projectilesound = 'sound/abnormalities/skinprophet/Skin_Candle.ogg'
	del_on_death = FALSE
	light_color = LIGHT_COLOR_FIRE
	light_range = 2
	light_power = 7
	var/mob/living/simple_animal/hostile/abnormality/skin_prophet/master

/mob/living/simple_animal/hostile/skin_candle/Move()
	return FALSE

/mob/living/simple_animal/hostile/skin_candle/death()
	..()
	light_range = 0
	update_light()
	QDEL_IN(src, 15 SECONDS)

/mob/living/simple_animal/hostile/skin_candle/Destroy(force)
	if(master)
		master.breach_candles -= src
	master = null
	return ..()

/mob/living/simple_animal/hostile/skin_candle/AttackingTarget(atom/attacked_target)
	OpenFire(attacked_target)
