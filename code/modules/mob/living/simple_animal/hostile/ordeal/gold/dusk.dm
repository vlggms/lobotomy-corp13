// Gold Dusk - Commander that buffs its minion's attacks and wandering white damage
/mob/living/simple_animal/hostile/ordeal/centipede_corrosion
	name = "High-Voltage Centipede"
	desc = "An agent of the information team, corrupted by an abnormality. But how?"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "centipede"
	icon_living = "centipede"
	icon_dead = "centipede_dead"
	faction = list("gold_ordeal", "thunder_variant")
	maxHealth = 1400
	health = 1400
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.7)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 2)
	move_to_delay = 3
	var/pulse_cooldown
	var/pulse_cooldown_time = 4 SECONDS
	var/charge_level = 0
	var/charge_level_cap = 20
	var/broken = FALSE
	var/can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/CanAttack(atom/the_target)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion = 4
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE)

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/Life()
	. = ..()
	if(!.) //dead
		return FALSE
	if(pulse_cooldown <= world.time)
		Pulse()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/Pulse()//Periodic weak AOE attack, gain charge constantly
	pulse_cooldown = world.time + pulse_cooldown_time
	AdjustCharge(1)
	if(charge_level < 5 || broken)
		return
	playsound(get_turf(src), 'sound/weapons/fixer/generic/energy2.ogg', 10, FALSE, 3)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(5, orgin)
	for(var/i = 0 to 2)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) != i)
				continue
			if(T.density)
				continue
			addtimer(CALLBACK(src, PROC_REF(PulseWarn), T), (3 * (i+1)) + 0.1 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(PulseHit), T), (3 * (i+1)) + 0.5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/PulseWarn(turf/T)
	new /obj/effect/temp_visual/cult/sparks(T)

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/PulseHit(turf/T)
	new /obj/effect/temp_visual/smash_effect(T)
	HurtInTurf(T, list(), 5, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	for(var/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/TB in T)
		if(TB.charge_level >= TB.charge_level_cap)
			continue
		TB.AdjustCharge(4)
		playsound(get_turf(TB), 'sound/weapons/fixer/generic/energy3.ogg', 75, FALSE, 3)
		TB.visible_message(span_warning("[TB] absorbs the arcing electricity!"))

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/AdjustCharge(addition)
	if(addition > 0 && charge_level < charge_level_cap)
		new /obj/effect/temp_visual/healing/charge(get_turf(src))
	charge_level = clamp(charge_level + addition, 0, charge_level_cap)
	update_icon()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/update_icon()
	if(stat >= DEAD)
		icon_state = icon_dead
		return
	if(!can_act) //We're recharging and want to stay in the recharging state
		return
	if(charge_level >= (charge_level_cap / 2))
		icon_state = "centipede_charged" + "[broken ? "_broken" : ""]"
		return
	icon_state = icon_living + "[broken ? "_broken" : ""]"

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/death(gibbed)
	if(!can_act) //Still recharging
		return FALSE
	if(charge_level)
		AdjustCharge(-20)
		Recharge()
		return FALSE
	..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/apply_damage(damage = 0,damagetype = RED_DAMAGE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	if(!can_act) //Prevents killing during recharge
		return FALSE
	..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/Recharge()
	can_act = FALSE
	var/foundbattery
	for(var/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/battery in view(8, src))
		if(battery.stat == DEAD)
			continue
		if(!battery.Recharge(src))
			continue
		AdjustCharge(5)
		foundbattery = TRUE
		playsound(get_turf(battery), 'sound/weapons/fixer/generic/energy2.ogg', 10, FALSE, 3)
		break
	if(foundbattery)
		playsound(get_turf(src), 'sound/weapons/fixer/generic/energy3.ogg', 100, FALSE, 3)
		visible_message(span_warning("[src] absorbs the arcing electricity!"))
	if(!broken && !foundbattery)
		broken = TRUE
		charge_level_cap = 10
		AdjustCharge(charge_level_cap)
		pulse_cooldown_time = 60 SECONDS
	bruteloss = 0 //Prevents overkilling
	adjustBruteLoss(-25 * charge_level)
	icon_state = "centipede_blocking"
	SLEEP_CHECK_DEATH(4 SECONDS)
	can_act = TRUE
	update_icon()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion
	name = "Thunder Warrior"
	desc = "An agent of the disciplinary team, corrupted by an abnormality. But how?"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "thunder_warrior"
	icon_living = "thunder_warrior"
	icon_dead = "thunder_warrior_dead"
	faction = list("gold_ordeal", "thunder_variant")
	maxHealth = 600
	health = 600
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_verb_continuous = "chops"
	attack_verb_simple = "chop"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_zombieattack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.7)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 2)
	move_to_delay = 3
	ranged = TRUE
	projectiletype = /obj/projectile/thunder_tomahawk
	projectilesound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	var/list/spawned_mobs = list()
	var/datum/beam/current_beam = null
	var/recharge_cooldown
	var/recharge_cooldown_time = 10 SECONDS
	var/charge_level = 0
	var/charge_level_cap = 20
	var/dash_cooldown = 0
	var/dash_cooldown_time = 4 SECONDS
	var/charge_progress = 0

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/Moved(atom/OldLoc, Dir, Forced = FALSE)
	. = ..()
	charge_progress += 1
	if(charge_progress >= 10)
		charge_progress = 0
		AdjustCharge(1)

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/OpenFire(atom/A)
	var/dist = get_dist(target, src)
	if(dist < 3)
		return ..()
	if(dash_cooldown <= world.time && !current_beam)
		var/chance_to_dash = 25
		if(dist <= (charge_level * 0.5))
			chance_to_dash = 100
		if(prob(chance_to_dash) && dash_cooldown <= world.time)
			dash_cooldown = world.time + dash_cooldown_time
			Dash(target, dist)
			return
	return ..()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/proc/Dash(atom/A, dist) // We move up to 10 tiles, using our charge as a battery.
	var/list/target_line = getline(A, src) // can we reach them in the first place?
	var/available_turf
	for(var/turf/line_turf in target_line)
		if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
			available_turf = FALSE
			break
		available_turf = TRUE
	if(!available_turf)
		return
	AdjustCharge(-dist)
	var/turf/oldturf = get_turf(src)
	for(var/i in 2 to dist)
		step_towards(src,A)
	if((get_dist(src, A) < 2))
		A.attack_animal(src)
	current_beam = Beam(oldturf, icon_state="lightning[rand(1,12)]", time = 0.5 SECONDS)
	playsound(get_turf(src), 'sound/weapons/fixer/generic/energyfinisher1.ogg', 75, 1)

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/proc/AdjustCharge(addition)
	if(addition > 0 && charge_level < charge_level_cap)
		new /obj/effect/temp_visual/healing/charge(get_turf(src))
	charge_level = clamp(charge_level + addition, 0, charge_level_cap)

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/proc/Recharge(atom/A) // Recharging the centipede
	if(recharge_cooldown >= world.time)
		return FALSE
	if(charge_level < 10)
		return FALSE
	AdjustCharge(-10)
	recharge_cooldown = world.time + recharge_cooldown_time
	current_beam = Beam(A, icon_state="lightning[rand(1,12)]", time = 3 SECONDS)

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!isliving(attacked_target))
		return
	AdjustCharge(1)
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		Convert(H)
		AdjustCharge(20) // full charge on a kill

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	playsound(src, 'sound/abnormalities/thunderbird/tbird_zombify.ogg', 45, FALSE, 5)
	var/mob/living/simple_animal/hostile/thunder_zombie/C = new(get_turf(src))
	if(!QDELETED(H))
		C.name = "[H.real_name]"//applies the target's name and adds the name to its description
		C.desc = "What appears to be [H.real_name], only charred and screaming incoherently..."
		C.gender = H.gender
		C.faction = src.faction
		C.master = src
		spawned_mobs += C
		H.gib()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/death(gibbed)
	for(var/mob/living/A in spawned_mobs)
		A.gib()
	..()

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion
	name = "680 Ham Actor"
	desc = "An agent of the control team, corrupted by an abnormality. But how?"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "680_ham_actor"
	icon_living = "680_ham_actor"
	icon_dead = "ham_actor_dead"
	faction = list("gold_ordeal", "thunder_variant")
	maxHealth = 1500
	health = 1500
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 10 //they're support, so they deal low damage
	melee_damage_upper = 15
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 2)
	move_to_delay = 4
	speak = list("Kilo India Lima Lima", "Delta India Echo", "Golf Echo Tango Oscar Uniform Tango", "Oscar Mike", "Charlie Mike")
	speak_emote = list("emits", "groans")
	ranged = TRUE
	var/can_act = TRUE
	var/effect_cooldown
	var/effect_cooldown_time = 4 SECONDS
	var/screech_cooldown
	var/screech_cooldown_time = 10 SECONDS
	var/list/radio_sounds = list(
		'sound/effects/radio/radio1.ogg',
		'sound/effects/radio/radio2.ogg',
		'sound/effects/radio/radio3.ogg'
		)
	var/list/damage_sounds = list(
		'sound/abnormalities/khz/Clip1.ogg',
		'sound/abnormalities/khz/Clip2.ogg',
		'sound/abnormalities/khz/Clip3.ogg',
		'sound/abnormalities/khz/Clip4.ogg',
		'sound/abnormalities/khz/Clip5.ogg',
		'sound/abnormalities/khz/Clip6.ogg',
		'sound/abnormalities/khz/Clip7.ogg'
	)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/Initialize()
	var/list/old_speaklist = speak.Copy()
	speak = list()
	for(var/phrase as anything in old_speaklist)
		for(var/vowel in list("A","E","I","O","U","R","S","T"))//All vowels, and the 3 most common consonants
			phrase = replacetextEx(phrase, vowel, pick("@","!","$","%","#"))
		speak.Add(phrase)

	return ..()

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/Life()
	. = ..()
	if(!.) // we're dead, lets not speak
		return
	if(effect_cooldown <= world.time)
		whisper("[pick(speak)]")
		playsound(get_turf(src), "[pick(damage_sounds)]", 25, FALSE)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	..()
	if(effect_cooldown >= world.time)
		return
	effect_cooldown = world.time + effect_cooldown_time
	var/radio_sound = pick(radio_sounds)
	var/found_radio
	for(var/mob/living/L in range(7, src))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			for(var/obj/item/radio/R in H.get_all_gear()) //less expensive than getallcontents
				R.emp_act(EMP_LIGHT)
				found_radio = TRUE
		if(!faction_check_mob(L))
			if(found_radio) //You can take off your radio to reduce the damage
				L.deal_damage(8, WHITE_DAMAGE)
				L.playsound_local(get_turf(L), "[radio_sound]",100)
				to_chat(L,span_danger("You hear unsettling sounds come out of your radio!"))
			L.deal_damage(4, WHITE_DAMAGE)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/proc/Screech()
	if(screech_cooldown > world.time)
		return
	can_act = FALSE
	visible_message(span_danger("[src] releases static!"))
	playsound(src, 'sound/effects/ordeals/gold/radiostatic.ogg', 100, TRUE, 8)
	var/icon/I = icon(icon, icon_state, dir)
	I = getStaticIcon(I)
	icon = I
	new /obj/effect/temp_visual/voidout(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	sleep(5) //Writing out the proc for sleep_check_death because we have to check if we died, actually
	if(QDELETED(src) || stat == DEAD)
		if(!QDELETED(src))
			icon = initial(icon)
			icon_state = icon_dead
		return
	var/list/been_hit = list()
	for(var/turf/T in view(7, src))
		HurtInTurf(T, been_hit, 25, WHITE_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE)
	sleep(3)
	if(QDELETED(src) || stat == DEAD)
		if(!QDELETED(src))
			icon = initial(icon)
			icon_state = icon_dead
		return
	can_act = TRUE
	screech_cooldown = world.time + screech_cooldown_time
	icon = initial(icon)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/OpenFire()
	if(!can_act)
		return
	if(screech_cooldown <= world.time)
		Screech()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss
	name = "Thunder Chieftain"
	desc = "A disciplinary officer, heavily corrupted by an abnormality."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "thunder_warrior"
	icon_living = "thunder_warrior"
	icon_dead = "thunder_warrior_dead"
	pixel_x = -16
	base_pixel_x = -16
	faction = list("gold_ordeal", "thunder_variant")
	maxHealth = 2500
	health = 2500
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.7)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 2)
	var/list/spawned_mobs = list()
	var/recharge_cooldown
	var/recharge_cooldown_time = 10 SECONDS
	/// List of mobs that have been hit by the revival field to avoid double effect
	var/list/been_hit = list()
	var/lightning_aoe_cooldown
	var/lightning_aoe_cooldown_base = 30 SECONDS
	var/lightning_aoe_damage = 80 // Black damage, scales with distance
	var/lightning_aoe_range = 80
	var/minimum_bolts = 3
	var/current_bolts = 3

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion = 4
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE)
	lightning_aoe_cooldown = (world.time + 10 SECONDS) // No instant charge, that would be bad.

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(lightning_aoe_cooldown < world.time)
		ThunderWave()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/bullet_act(obj/projectile/P)
	visible_message(span_warning("The [P] sizzles away as it strikes an invisible barrier!"))
	return FALSE

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/proc/ThunderWave(range_override = null)
	if(lightning_aoe_cooldown > world.time)
		return
	if(range_override == null)
		range_override = lightning_aoe_range
	lightning_aoe_cooldown = (world.time + lightning_aoe_cooldown_base)
	been_hit = list()
	playsound(src, "sound/effects/ordeals/gold/weather_thunder_[pick(0,3)].ogg", 100, FALSE, range_override)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	var/spawning_effects = FALSE
	for(var/i = 1 to range_override)
		turf_list = (target_c.y - i > 0 			? getline(locate(max(target_c.x - i, 1), target_c.y - i, target_c.z), locate(min(target_c.x + i - 1, world.maxx), target_c.y - i, target_c.z)) : list()) +\
					(target_c.x + i <= world.maxx ? getline(locate(target_c.x + i, max(target_c.y - i, 1), target_c.z), locate(target_c.x + i, min(target_c.y + i - 1, world.maxy), target_c.z)) : list()) +\
					(target_c.y + i <= world.maxy ? getline(locate(min(target_c.x + i, world.maxx), target_c.y + i, target_c.z), locate(max(target_c.x - i + 1, 1), target_c.y + i, target_c.z)) : list()) +\
					(target_c.x - i > 0 			? getline(locate(target_c.x - i, min(target_c.y + i, world.maxy), target_c.z), locate(target_c.x - i, max(target_c.y - i + 1, 1), target_c.z)) : list())
		if((i % 3) == 0)
			spawning_effects = TRUE
		else
			spawning_effects = FALSE
		for(var/turf/open/T in turf_list)
			CHECK_TICK
			if(spawning_effects)
				new /obj/effect/temp_visual/impact_effect/ion(T)
			for(var/mob/living/L in T)
				INVOKE_ASYNC(src, PROC_REF(ThunderStrike), L, i)
		SLEEP_CHECK_DEATH(1.5)
	current_bolts = minimum_bolts

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/proc/ThunderStrike(mob/living/L, attack_range = 1)
	if(L in been_hit)
		return
	been_hit += L
	if(L.status_flags & GODMODE)
		return
	if(!faction_check_mob(L, TRUE))
		if(ishuman(L))// Thunderbolts only damage humans
			FireShell(L)
		return
	if(istype(L, /mob/living/simple_animal/hostile/ordeal/centipede_corrosion) || istype(L, /mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion))
		var/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/targetmob = L // It might not always be this type, but we need to call their proc
		targetmob.AdjustCharge(20) // A full battery. Oh no.
	to_chat(L, span_notice("You feel energized!"))
	if(L.bruteloss > L.maxHealth)
		L.adjustBruteLoss(-(L.maxHealth * 0.2) - (L.bruteloss - L.maxHealth)) // recover 20% of hp on revive
		L.revive(full_heal = FALSE, admin_revive = TRUE)
	L.adjustBruteLoss(-100)
	playsound(get_turf(L), 'sound/abnormalities/thunderbird/tbird_charge.ogg', 15, 1, 4)
	L.add_overlay(icon('icons/effects/effects.dmi', "electricity"))
	addtimer(CALLBACK(L, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "electricity")), 55)

//thunderbolts
/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss/proc/FireShell(mob/living/L)
	if(!current_bolts && prob(75))
		return
	var/obj/effect/thunderbolt/big/E = new(get_turf(L.loc))
	E.master = src
	current_bolts -= 1

/obj/effect/thunderbolt/big
	icon = 'icons/effects/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	duration = 5 SECONDS
	range = 3
	boom_damage = 65

/obj/effect/thunderbolt/big/Explode() // random visual lightning
	var/bolts = 4
	for(var/turf/T in oview(3, src))
		if(prob(15) && bolts)
			new /obj/effect/temp_visual/tbirdlightning(get_turf(T))
			bolts -= 1
	..()
