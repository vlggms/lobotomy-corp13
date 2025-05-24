//Yeah so this midnight is supposed to be weak as shit.
/mob/living/simple_animal/hostile/ordeal/pink_midnight
	name = "A Party Everlasting"
	desc = "An overturned teacup, a party everlasting."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "party"
	icon_living = "party"
	faction = list("pink_midnight")
	layer = LARGE_MOB_LAYER
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 20000
	health = 20000
	melee_damage_type = PALE_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 14
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

	var/list/blacklist = list(/mob/living/simple_animal/hostile/abnormality/melting_love,
				/mob/living/simple_animal/hostile/abnormality/distortedform,
				/mob/living/simple_animal/hostile/abnormality/white_night,
				/mob/living/simple_animal/hostile/abnormality/nihil,
				/mob/living/simple_animal/hostile/abnormality/hatred_queen,
				/mob/living/simple_animal/hostile/abnormality/wrath_servant)
	var/list/whitelist = list()
	var/playerscaling
	var/timescaling
	var/initial_breach = TRUE	//Linters scream at me for sleeping during initialize


/mob/living/simple_animal/hostile/ordeal/pink_midnight/Initialize()
	. = ..()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		//These abnormalities kill everything else no matter what faction we set them to
		if(A.type in blacklist)
			continue
		whitelist+=A
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		playerscaling++
	addtimer(CALLBACK(src, PROC_REF(Breach_Loop)), 2 SECONDS)

/mob/living/simple_animal/hostile/ordeal/pink_midnight/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/ordeal/pink_midnight/proc/Breach_Loop()
	if(!length(whitelist))
		return
	if(!src)
		return
	var/breachtime = min(0, 40-30*TOUGHER_TIMES(playerscaling*3)+timescaling)
	addtimer(CALLBACK(src, PROC_REF(Breach_Loop)), breachtime*10)
	timescaling++
	Breach_Abno()
	if(initial_breach)
		for(var/i = 1 to 3)
			Breach_Abno()
		initial_breach = FALSE
	if(prob(50))
		var/turf/T = pick(GLOB.department_centers)
		sound_to_playing_players_on_level('sound/voice/human/womanlaugh.ogg', 50, zlevel = z)
		SLEEP_CHECK_DEATH(20)
		forceMove(T)

//Funny drags everything to it
/mob/living/simple_animal/hostile/ordeal/pink_midnight/proc/Breach_Abno()
	if(!length(whitelist))
		return

	var/mob/living/simple_animal/hostile/abnormality/A = pick_n_take(whitelist)
	if(A.IsContained() && (A.z == z))
		if(!A.BreachEffect(null, BREACH_PINK)) // We try breaching them our way!
			Breach_Abno()// If they can't we just go home!
			return // If you don't succeed then try again

		if(A.status_flags & GODMODE)
			Breach_Abno()
			return // Some special "breaches" don't stay breached!

		A.faction += "pink_midnight"
		/// This does a significant bit of trolling and fucks with the facility on a much wider range.
		/// By making them walk there, certain ones like Blue Star are less centralized and can become a background threat,
		/// While others like NT immediately are in the hallways being an active threat. Also solves the issue of wall-abnos.
		var/turf/destination = pick(get_adjacent_open_turfs(src))
		if(!destination)
			destination = get_turf(src)
		if(!A.patrol_to(destination))
			A.forceMove(destination)
		ordeal_reference.ordeal_mobs |= A
