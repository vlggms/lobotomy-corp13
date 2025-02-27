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
	faction = list("gold_ordeal")
	maxHealth = 1800
	health = 1800
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
	faction = list("gold_ordeal")
	maxHealth = 900
	health = 900
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 25
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
	var/mob/living/L = attacked_target
	if(charge_level) // We deal up to 20 more damage, 1 for every point of charge.
		L.deal_damage(charge_level, BLACK_DAMAGE)
		playsound(get_turf(src), 'sound/weapons/fixer/generic/energyfinisher1.ogg', 75, 1)
		to_chat(L,span_danger("The [src] unleashes its charge!"))
		AdjustCharge(-charge_level)
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		Convert(H)

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
	faction = list("gold_ordeal")
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
