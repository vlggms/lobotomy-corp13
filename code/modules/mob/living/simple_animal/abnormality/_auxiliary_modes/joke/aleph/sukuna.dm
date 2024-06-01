/mob/living/simple_animal/hostile/abnormality/sukuna
	name = "Sukuna"
	desc = "The Heian Era asspuller himself."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "sukunad"
	icon_living = "sukunad"
	portrait = "sukuna"
	del_on_death = TRUE
	maxHealth = 9000
	health = 9000
	var/can_act = TRUE
	var/list/survivors = list()
	var/cleave_cooldown
	var/cleave_cooldown_time = 6 SECONDS
	var/cleave_damage = 300
	var/shrine_cooldown
	var/shrine_cooldown_time = 60 SECONDS
	var/shrine_damage = 1000
	var/current_stage = 1
	ranged = TRUE
	//Attack speed modifier. 2 is twice the normal.
	rapid_melee = 2
	//If target is close enough start preparing to hit them if we have rapid_melee enabled. Originally was 4.
	melee_queue_distance = 2
	//How fast a creature is, lower is faster. Client controlled monsters instead use speed and are MUCH faster.
	move_to_delay = 2.4
	/**
	 * Red damage is applied to health.
	 * White damage is applied to sanity with only a few abnormalities using that to instantly kill the victim.
	 * Black damage is applied to both health and sanity 10 black damage would do 10 health damage and 10 sanity damage.
	 * Pale damage is a % of health. Weird i know.
	 */
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 1.6)
	//the lowest damage in regular attacks. Normal murderer is 2~4 so we double it.
	melee_damage_lower = 95
	/**
	 * Fragments Lobotomy Corp damage was 3~4 so im giving murderer a larger gap between his lower and upper damage.
	 * Unsure if i should be comparing Forsaken Murderer to Fragment of the Universe.
	 * Most HE level abnormalities do 20+ damange.
	 */
	melee_damage_upper = 150
	melee_damage_type = PALE_DAMAGE
	//Used chrome to listen to the sound effects. In the chrome link was the file name i could copy paste in.
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
	attack_verb_continuous = "cleaves"
	attack_verb_simple = "cleave"
	friendly_verb_continuous = "stares at"
	friendly_verb_simple = "stare at"

	/**
	 * Leaving the faction list blank only attributes them to one faction and thats its own unique mob number.
	 * With this forsaken murderer will even attack duplicates of themselves.
	 */
	faction = list()
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	// Work chance fluctuates based on level. left to right as level increase.
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 0, 60),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 0, 30),
		ABNORMALITY_WORK_ATTACHMENT = -1000, //lol, lmao
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 30, 55),
	)
	work_damage_amount = 25
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/violence
	death_message = "dies, probably."
	wander = TRUE
	ego_list = list(
		/datum/ego_datum/armor/sukuna,
		)
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

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
			flash_color(M, flash_color = COLOR_ALMOST_BLACK, flash_time = 80)
		if(M.stat != DEAD && ishuman(M) && M.ckey)
			survivors += M
	can_act = FALSE

/mob/living/simple_animal/hostile/abnormality/sukuna/proc/Cleave(target)
	if(cleave_cooldown > world.time)
		return
	cleave_cooldown = world.time + cleave_cooldown_time
	can_act = FALSE
	face_atom(target)
	icon_state = "nothing_blade"
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
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, cleave_damage, PALE_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/sukuna/proc/Shrine()
	if(shrine_cooldown > world.time)
		return
	shrine_cooldown = world.time + shrine_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/maloventkitchen.ogg', 75, 0, 5)
	icon_state = "nothing_blade"
	SLEEP_CHECK_DEATH(8)
	for(var/turf/T in view(8, src))
		new /obj/effect/temp_visual/nt_goodbye(T)
		for(var/mob/living/L in HurtInTurf(T, list(), shrine_damage, PALE_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE, hurt_structure = TRUE))
			if(L.health < 0)
				L.gib()
	SLEEP_CHECK_DEATH(3)
	icon_state = icon_living
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
	icon_state = icon_dead
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	desc = "A gross, pathetic looking thing that was once a terrible monster."
	pixel_x = 0
	base_pixel_x = 0
	pixel_y = 0
	base_pixel_y = 0
	density = FALSE
	playsound(src, 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 60, 1)
	animate(src, transform = matrix()*0.6,time = 0)
	for(var/mob/living/carbon/human/survivor in survivors)
		if(survivor.stat == DEAD || !survivor.ckey)
			continue
		survivor.Apply_Gift(new /datum/ego_gifts/fervor)
		survivor.playsound_local(get_turf(survivor), 'sound/weapons/black_silence/snap.ogg', 50)
		to_chat(survivor, span_userdanger("I'm gonna go punt Yuji now, bye."))
	animate(src, alpha = 0, time = 0 SECONDS)
	QDEL_IN(src, 0 SECONDS)
	new /obj/item/ego_weapon/sukuna(get_turf(src))
	..()


/mob/living/simple_animal/hostile/abnormality/sukuna/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(!client)
		if((shrine_cooldown <= world.time) && prob(35))
			return Shrine()
		if((cleave_cooldown <= world.time) && prob(35))
			var/turf/target_turf = get_turf(target)
			for(var/i = 1 to 3)
				target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
			return Cleave(target_turf)
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
		return



/mob/living/simple_animal/hostile/abnormality/sukuna/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return


/mob/living/simple_animal/hostile/abnormality/sukuna/examine(mob/user)
	. = ..()
	if(IsContained())
		. += "He'll use his anti-agent technique from the heian era if you mess with him."
	else
		. += "Your sorry ass is not beating this guy."



