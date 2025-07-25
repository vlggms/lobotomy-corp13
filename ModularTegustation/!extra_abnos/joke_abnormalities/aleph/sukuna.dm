#define MALEVOLENT_SHRINE_COOLDOWN (60 SECONDS)
/mob/living/simple_animal/hostile/abnormality/sukuna
	name = "Sukuna"
	desc = "The Heian Era asspuller himself."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "sukunad"
	icon_living = "sukunad"
	portrait = "sukuna"
	del_on_death = FALSE
	maxHealth = 12000
	health = 12000
	var/can_act = TRUE
	var/list/survivors = list()
	var/cleave_cooldown
	var/cleave_cooldown_time = 6 SECONDS
	var/cleave_damage = 250
	var/shrine_cooldown
	var/shrine_cooldown_time = 60 SECONDS
	var/worldslash_cooldown
	var/worldslash_cooldown_time = 120 SECONDS
	var/worldslash_damage = 6666
	var/current_stage = 1
	ranged = TRUE
	rapid_melee = 2
	melee_queue_distance = 2
	move_to_delay = 2.2
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.3, PALE_DAMAGE = -1) //funny
	melee_damage_lower = 75
	melee_damage_upper = 100
	melee_damage_type = PALE_DAMAGE
	attack_sound = 'sound/weapons/ego/da_capo2.ogg'
	attack_verb_continuous  = "dismantles"
	attack_verb_simple = "dismantle"
	friendly_verb_continuous = "stares at"
	friendly_verb_simple = "stare at"
	faction = list("Sukuna")
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	// Work chance fluctuates based on level. left to right as level increase.
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 0, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 0, 30),
		ABNORMALITY_WORK_ATTACHMENT = -1000, //lol, lmao
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 30, 55),
	)
	work_damage_amount = 25
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/violence
	death_message = "dies, probably."
	wander = TRUE
	can_spawn = FALSE
	ego_list = list(
		/datum/ego_datum/armor/sukuna,
		/datum/ego_datum/armor/sandals, //it's funny
		)
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE
	attack_action_types = list(
		/datum/action/cooldown/shrine,
		/datum/action/innate/abnormality_attack/toggle/nt_hello_toggle,
	)

/datum/action/cooldown/shrine
	name = "Malevolent Shrine"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "maleshrine"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = MALEVOLENT_SHRINE_COOLDOWN //20 seconds

/datum/action/cooldown/shrine/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/sukuna))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/sukuna/sukuna = owner
	if(sukuna.current_stage != 1)
		return FALSE
	StartCooldown()
	sukuna.Shrine()
	return TRUE

/datum/action/innate/abnormality_attack/toggle/worldslash
	name = "Toggle World Slash"
	button_icon_state = "worldslash"
	chosen_attack_num = 1
	chosen_message = span_colossus("You won't obliterate someone anymore.")
	button_icon_toggle_activated = "nt_goodbye"
	toggle_attack_num = 2
	toggle_message = span_colossus("You will now eviscerate someone.")
	button_icon_toggle_deactivated = "worldslash"

/mob/living/simple_animal/hostile/abnormality/sukuna/BreachEffect(mob/living/carbon/human/user, breach_type)
	sound_to_playing_players_on_level("sound/abnormalities/maloventkitchen.ogg", 85, zlevel = z)
	for(var/mob/M in GLOB.player_list)
		if(isnewplayer(M))
			continue
		var/check_z = M.z
		if(isatom(M.loc))
			check_z = M.loc.z // So it plays even when you are in a locker/sleeper
		if((check_z == z) && M.client)
			to_chat(M, span_userdanger("Yo it's me Ryomen Sukuna from Jujutsu Kaisen here to obliterate you."))
			flash_color(M, flash_color = COLOR_ALMOST_BLACK, flash_time = 60)
		if(M.stat != DEAD && ishuman(M) && M.ckey)
			survivors += M
	return ..()

/mob/living/simple_animal/hostile/abnormality/sukuna/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/sukuna/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods)
	. = ..()
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/talker = speaker
	if((findtext(message, "Nah, I'd win") || findtext(message, "Nah I'd win") || findtext(message, "Nah Id win") || findtext(message, "Nah, I'd win.")) && !isnull(talker) && talker.stat != DEAD)
		if(status_flags & GODMODE) //if contained
			BreachEffect()
		forceMove(get_turf(talker))
		can_act = TRUE
		return


/mob/living/simple_animal/hostile/abnormality/sukuna/proc/Cleave(target)
	if(cleave_cooldown > world.time)
		return
	cleave_cooldown = world.time + cleave_cooldown_time
	can_act = FALSE
	say("Cleave.")
	playsound(get_turf(src), "sound/abnormalities/cleave.ogg", 75, 0, 3)
	face_atom(target)
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/cleave_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(cleave_delay)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/cleavesprite(TF)
			been_hit = HurtInTurf(TF, been_hit, cleave_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/sukuna/proc/Shrine()
	if(shrine_cooldown > world.time)
		return
	shrine_cooldown = world.time + shrine_cooldown_time
	say("Domain Expansion...")
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	say("Malevolent Kitchen.")
	playsound(get_turf(src), "sound/abnormalities/maloventkitchen.ogg", 75, 0, 3)
	can_act = FALSE
	new /obj/effect/malevolent_shrine(get_turf(src))
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/sukuna/proc/WorldSlash(target)
	if(worldslash_cooldown > world.time)
		return
	worldslash_cooldown = world.time + worldslash_cooldown_time
	can_act = FALSE
	say("World Slash.")
	playsound(get_turf(src), "sound/abnormalities/fastcleave.ogg", 75, 0, 3)
	face_atom(target)
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/worldslash_delay = (get_dist(src, target) <= 2) ? (2 SECONDS) : (1 SECONDS)
	SLEEP_CHECK_DEATH(worldslash_delay)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/goatjo(TF)
			been_hit = HurtInTurf(TF, been_hit, worldslash_damage, PALE_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(L))
			L.gib()
	can_act = TRUE


/datum/action/cooldown/shrine/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/sukuna))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/sukuna/sukuna = owner
	if(sukuna.current_stage != 1)
		return FALSE
	StartCooldown()
	sukuna.Shrine()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/sukuna/death(gibbed)
	can_act = FALSE
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	desc = "A gross, pathetic looking thing that was once a terrible monster."
	pixel_x = 0
	base_pixel_x = 0
	pixel_y = 0
	base_pixel_y = 0
	density = FALSE
	playsound(src, 'sound/effects/limbus_death.ogg', 100, 1)
	animate(src, transform = matrix()*0.6,time = 0)
	for(var/mob/living/carbon/human/survivor in survivors)
		if(survivor.stat == DEAD || !survivor.ckey)
			continue
		var/area_check = get_area(src)
		if(istype(area_check, /area/test_range))
			return ..()
		survivor.Apply_Gift(new /datum/ego_gifts/sukuna)
		survivor.playsound_local(get_turf(survivor), 'sound/weapons/black_silence/snap.ogg', 50)
		to_chat(survivor, span_userdanger("I'm gonna go punt Yuji now, bye."))
	animate(src, alpha = 10, time = 10 SECONDS)
	QDEL_IN(src, 0 SECONDS)
	new /obj/item/ego_weapon/sukuna(get_turf(src))
	new /obj/item/clothing/shoes/sandal/heian(get_turf(src))
	..()


/mob/living/simple_animal/hostile/abnormality/sukuna/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(!client)
		if((shrine_cooldown <= world.time) && prob(35))
			return Shrine()
		if((cleave_cooldown <= world.time) && prob(35))
			var/turf/target_turf = get_turf(attacked_target)
			for(var/i = 1 to 3)
				target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
			return Cleave(target_turf)
		if((worldslash_cooldown <= world.time) && prob(35))
			var/turf/target_turf = get_turf(attacked_target)
			for(var/i = 1 to 3)
				target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
			return WorldSlash(target_turf)
	return ..()

/mob/living/simple_animal/hostile/abnormality/sukuna/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				Cleave(target)
		return

	if(cleave_cooldown <= world.time)
		Cleave(target)
	if((shrine_cooldown <= world.time) && (get_dist(src, target) < 3))
		Shrine()
	if(worldslash_cooldown <= world.time)
		WorldSlash(target)

	return

/mob/living/simple_animal/hostile/abnormality/sukuna/examine(mob/user)
	. = ..()
	if(IsContained())
		. += "He'll use his anti-agent technique from the heian era if you mess with him."
	else
		. += "Your sorry ass is not beating this guy."

/obj/effect/malevolent_shrine
	name = "malevolent shrine"
	desc = "If you see this, it's already over for you."
	icon = 'icons/effects/effects.dmi'
	icon_state = "malevolent"
	anchored = TRUE
	density = FALSE
	layer = POINT_LAYER
	resistance_flags = INDESTRUCTIBLE
	var/explode_times = 20
	var/range = -1

/obj/effect/malevolent_shrine/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 0.5 SECONDS)

/obj/effect/malevolent_shrine/proc/explode() //repurposed code from artillary bees, a delayed attack
	playsound(get_turf(src), 'sound/abnormalities/strongcleave.mp3', 50, 0, 8)
	range = clamp(range + 1, 0, 10)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(range, target_turf))
		var/obj/effect/temp_visual/cleavesprite =  new(T)
		cleavesprite.color = "#df1919"
		for(var/mob/living/L in T)
			L.apply_damage(500, PALE_DAMAGE, null, spread_damage = TRUE)
			if(ishuman(L) && L.health < 0)
				var/mob/living/carbon/human/H = L
				new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
				H.gib()
	explode_times -= 1
	if(explode_times <= 0)
		qdel(src)
		return
	sleep(0.4 SECONDS)
	explode()
#undef MALEVOLENT_SHRINE_COOLDOWN

