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
	maxHealth = 2000
	health = 2000
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
				/mob/living/simple_animal/hostile/abnormality/hatred_queen,
				/mob/living/simple_animal/hostile/abnormality/wrath_servant)


/mob/living/simple_animal/hostile/ordeal/pink_midnight/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/Breach_All), 5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/pink_midnight/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

//Funny drags everything to it
/mob/living/simple_animal/hostile/ordeal/pink_midnight/proc/Breach_All()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		//These two abnormalities kill everything else no matter what faction we set them to
		if(A.type in blacklist)
			continue

		if(A.IsContained() && A.z == z)
			if(!A.BreachEffect(null, BREACH_PINK)) // We try breaching them our way!
				continue // If they can't we just go home!
			if(A.status_flags & GODMODE)
				continue // Some special "breaches" don't stay breached!
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
	RegisterSignal(ordeal_reference, COMSIG_GLOB_MOB_DEATH, /datum/ordeal/.proc/OnMobDeath)

// Holidays - Christmas
// Shameless copy of mimics. Hopefully it works?
/mob/living/simple_animal/hostile/ordeal/present
	name = "christmas gift"
	desc = "It could be anything!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "giftdeliverypackage3"
	icon_living = "giftdeliverypackage3"
	maxHealth = 200
	health = 200
	gender = NEUTER
	mob_biotypes = NONE
	move_to_delay = 4
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_sound = 'sound/effects/ordeals/crimson/noon_bite.ogg'
	emote_taunt = list("growls")
	taunt_chance = 15
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	faction = list("christmas")
	del_on_death = 1
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	speak_emote = list("rustles")
	stop_automated_movement = 1
	wander = 0
	///A cap for items in the mimic. Prevents the mimic from eating enough stuff to cause lag when opened.
	var/storage_capacity = 50
	///A cap for mobs. Mobs count towards the item cap. Same purpose as above.
	var/mob_storage_capacity = 10
	var/attempt_open = FALSE
	var/icon/mouth_overlay = icon('ModularTegustation/Teguicons/tegumobs.dmi', icon_state = "mimic_mouth")

// Pickup loot
/mob/living/simple_animal/hostile/ordeal/present/Initialize(mapload)
	. = ..()
	if(mapload)	//eat shit
		for(var/obj/item/I in loc)
			I.forceMove(src)
	addtimer(CALLBACK(src, .proc/ReleaseDeathGas), rand(60 SECONDS, 65 SECONDS))

/mob/living/simple_animal/hostile/ordeal/present/ListTargets()
	if(attempt_open)
		return ..()
	return ..(1)

/mob/living/simple_animal/hostile/ordeal/present/FindTarget()
	. = ..()
	if(.)
		trigger()

/mob/living/simple_animal/hostile/ordeal/present/AttackingTarget()
	. = ..()

/mob/living/simple_animal/hostile/ordeal/present/proc/trigger()
	overlays += mouth_overlay
	if(!attempt_open)
		visible_message("<b>[src]</b> starts to move!")
		attempt_open = TRUE

/mob/living/simple_animal/hostile/ordeal/present/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	trigger()
	. = ..()

/mob/living/simple_animal/hostile/ordeal/present/LoseTarget()
	..()
	icon_state = initial(icon_state)
	overlays -= mouth_overlay

/mob/living/simple_animal/hostile/ordeal/present/death()
	var/obj/item/a_gift/anything/C = new(get_turf(src))
	// Put loot in present
	for(var/obj/O in src)
		O.forceMove(C)
	..()

//Copied from violet fruit, just prevents ignoring them as a solution
/mob/living/simple_animal/hostile/ordeal/present/proc/ReleaseDeathGas()
	if(stat == DEAD)
		return
	var/turf/target_c = get_turf(src)
	var/list/turf_list = spiral_range_turfs(15, target_c)
	visible_message("<span class='danger'>[src] releases a cloud of nauseating gas!</span>")
	playsound(target_c, 'sound/effects/ordeals/violet/fruit_suicide.ogg', 50, 1, 16)
	adjustWhiteLoss(maxHealth) // Die
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/L in livinginrange(15, target_c))
		if(faction_check_mob(L))
			continue
		L.apply_damage(33, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	for(var/obj/machinery/computer/abnormality/A in urange(15, target_c))
		if(A.can_meltdown && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-999))
