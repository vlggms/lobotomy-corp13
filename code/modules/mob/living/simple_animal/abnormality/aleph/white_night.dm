GLOBAL_LIST_EMPTY(apostles)

/mob/living/simple_animal/hostile/abnormality/white_night
	name = "White night"
	desc = "The heavens' wrath. Say your prayers, heretic, the day has come."
	health = 4000
	maxHealth = 4000
	attack_verb_continuous = "purges"
	attack_verb_simple = "purge"
	attack_sound = 'sound/magic/mm_hit.ogg'
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "white_night"
	icon_living = "white_night"
	health_doll_icon = "white_night"
	faction = list("apostle")
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("proclaims")
	melee_damage_type = PALE_DAMAGE
	armortype = PALE_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = -2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.2)
	melee_damage_lower = 35
	melee_damage_upper = 40
	obj_damage = 600
	environment_smash = ENVIRONMENT_SMASH_WALLS
	is_flying_animal = TRUE
	speed = 2
	move_to_delay = 5
	ranged = TRUE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	loot = list(/obj/item/ego_weapon/paradise)
	deathmessage = "evaporates in a moment, leaving heavenly light and feathers behind."
	deathsound = 'ModularTegustation/Tegusounds/apostle/mob/apostle_death.ogg'
	attack_action_types = list(/datum/action/innate/abnormality_attack/holy_revival,
							   /datum/action/innate/abnormality_attack/fire_field,
							   /datum/action/innate/abnormality_attack/deafening_scream,
							   /datum/action/innate/abnormality_attack/holy_blink)
	small_sprite_type = /datum/action/small_sprite/megafauna/tegu/angel
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL + 1
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = list(0, 0, 30, 30, 40),
						ABNORMALITY_WORK_ATTACHMENT = list(30, 30, 35, 40, 45),
						ABNORMALITY_WORK_REPRESSION = list(30, 30, 35, 40, 45)
						)
	work_damage_amount = 14
	work_damage_type = PALE_DAMAGE

	light_system = MOVABLE_LIGHT
	light_color = COLOR_VERY_SOFT_YELLOW
	light_range = 7
	light_power = 3

	ego_list = list(
		/datum/ego_datum/armor/paradise
		)

	var/holy_revival_cooldown = 30 SECONDS
	var/holy_revival_cooldown_base = 30 SECONDS
	var/holy_revival_damage = 28 // Pale damage, scales with distance
	var/holy_revival_range = 4
	var/last_revival_time // To prevent multiple conversions per one action
	var/fire_field_cooldown = 15 SECONDS
	var/fire_field_cooldown_base = 15 SECONDS
	var/field_range = 4
	var/scream_cooldown = 18 SECONDS
	var/scream_cooldown_base = 18 SECONDS
	var/scream_power = 20
	var/blink_cooldown = 6 SECONDS
	var/blink_cooldown_base = 6 SECONDS
	var/apostle_num = 1 //Number of apostles. Used for revival and finale.
	var/apostle_line
	var/apostle_prev //Used for previous apostle's name, to reference in next line.
	var/datum/action/innate/abnormality_attack/rapture/rapture_skill = new /datum/action/innate/abnormality_attack/rapture

/mob/living/simple_animal/hostile/abnormality/white_night/ex_act(severity, target)
	return //Resistant to explosions

/datum/action/small_sprite/megafauna/tegu
	small_icon = 'ModularTegustation/Teguicons/megafauna.dmi'

/datum/action/small_sprite/megafauna/tegu/angel
	small_icon_state = "angel_small"

/datum/action/innate/abnormality_attack/holy_revival
	name = "Holy Revival"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You are now reviving the dead to join your cause.</span>"
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/fire_field
	name = "Fire Field"
	icon_icon = 'icons/effects/fire.dmi'
	button_icon_state = "fire"
	chosen_message = "<span class='colossus'>You are now setting the area on explosive fire.</span>"
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/deafening_scream
	name = "Deafening Scream"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "shield"
	chosen_message = "<span class='colossus'>You will now shout with all your might to shatter enemy's will.</span>"
	chosen_attack_num = 3

/datum/action/innate/abnormality_attack/holy_blink
	name = "Holy Blink"
	icon_icon = 'icons/effects/bubblegum.dmi'
	button_icon_state = "smack ya one"
	chosen_message = "<span class='colossus'>You will now blink to your target and throw away the heretics.</span>"
	chosen_attack_num = 4

/datum/action/innate/abnormality_attack/rapture
	name = "Rapture"
	icon_icon = 'icons/obj/storage.dmi'
	button_icon_state = "bible"
	chosen_message = "<span class='colossus'>Finale...</span>"
	chosen_attack_num = 5

/mob/living/simple_animal/hostile/abnormality/white_night/AttackingTarget()
	if(isliving(target))
		var/mob/living/L = target
		if("apostle" in L.faction)
			return
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(!client && ranged && ranged_cooldown <= world.time)
				OpenFire()

			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/abnormality/white_night/proc/devour(mob/living/L)
	if(apostle_num < 13)
		var/mob/dead/observer/ghost = L.get_ghost(TRUE, TRUE)
		if(ishuman(L))
			if(L.client || ghost?.can_reenter_corpse) // If ghost is able to reenter - we can't gib the body.
				revive_target(L)
				return
	L.gib()

/mob/living/simple_animal/hostile/abnormality/white_night/OpenFire()
	if(client)
		switch(chosen_attack)
			if(1)
				revive_humans()
			if(2)
				fire_field()
			if(3)
				deafening_scream()
			if(4)
				holy_blink(target)
			if(5)
				rapture()
		return

	if(get_dist(src, target) >= 3 && blink_cooldown <= world.time)
		holy_blink(target)
	if(get_dist(src, target) < 5)
		if(holy_revival_cooldown <= world.time)
			revive_humans()
		else if(fire_field_cooldown <= world.time)
			fire_field()
		else if(scream_cooldown <= world.time)
			deafening_scream()

/mob/living/simple_animal/hostile/abnormality/white_night/death(gibbed)
	for(var/datum/antagonist/apostle/A in GLOB.apostles)
		if(!A.owner || !ishuman(A.owner.current))
			continue
		A.prophet_death()
	return ..()

/mob/living/simple_animal/hostile/abnormality/white_night/proc/revive_humans(range_override = null, faction_check = "apostle")
	if(holy_revival_cooldown > world.time)
		return
	if(range_override == null)
		range_override = holy_revival_range
	holy_revival_cooldown = (world.time + holy_revival_cooldown_base)
	playsound(src, 'ModularTegustation/Tegusounds/apostle/mob/apostle_spell.ogg', 75, 1, range_override)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	for(var/i = 1 to range_override)
		turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/open/T in turf_list)
			var/obj/effect/temp_visual/cult/sparks/S = new(T)
			if(faction_check != "apostle")
				S.color = "#AAFFAA" // Indicating that it's a good thing
			for(var/mob/living/L in T.contents)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					new /obj/effect/temp_visual/dir_setting/cult/phase(T, H.dir)
					addtimer(CALLBACK(src, .proc/revive_target, H, i, faction_check))
					continue
				// Not a human and an enemy
				if(!(faction_check in L.faction))
					playsound(L.loc, 'sound/machines/clockcult/ark_damage.ogg', 35, TRUE, -1)
					L.adjustPaleLoss(holy_revival_damage)
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/abnormality/white_night/proc/revive_target(mob/living/carbon/human/H, attack_range = 1, faction_check = "apostle")
	if(!(faction_check in H.faction))
		if(apostle_num < 13 && H.stat == DEAD && H.mind && world.time > last_revival_time + 5 SECONDS)
			if(!H.client)
				var/mob/dead/observer/ghost = H.get_ghost(TRUE, TRUE)
				if(!ghost?.can_reenter_corpse) // If there is nobody able to control it - skip.
					return
				else // If it can reenter - do it.
					H.grab_ghost(force = TRUE)
			H.regenerate_limbs()
			H.regenerate_organs()
			H.dna.species.GiveSpeciesFlight(H)
			H.revive(full_heal = TRUE, admin_revive = FALSE)
			// Giving the fancy stuff to new apostle
			H.faction |= "apostle"
			ADD_TRAIT(H, TRAIT_BOMBIMMUNE, "White Night Apostle")
			ADD_TRAIT(H, TRAIT_NOFIRE, "White Night Apostle")
			ADD_TRAIT(H, TRAIT_NOBREATH, "White Night Apostle")
			ADD_TRAIT(H, TRAIT_RESISTLOWPRESSURE, "White Night Apostle")
			ADD_TRAIT(H, TRAIT_RESISTCOLD, "White Night Apostle")
			ADD_TRAIT(H, TRAIT_NODISMEMBER, "White Night Apostle")
			ADD_TRAIT(H, TRAIT_SANITYIMMUNE, "White Night Apostle")
			to_chat(H, "<span class='notice'>You are protected by the holy light!</span>")
			if(apostle_num < 12)
				H.set_light_color(COLOR_VERY_SOFT_YELLOW)
				H.set_light(4)
				H.add_overlay(mutable_appearance('icons/effects/genetics.dmi', "servitude", -MUTATIONS_LAYER))
				var/mutable_appearance/apostle_halo = mutable_appearance('ModularTegustation/Teguicons/32x64.dmi', "halo", -HALO_LAYER)
				H.overlays_standing[HALO_LAYER] = apostle_halo
				H.apply_overlay(HALO_LAYER)
			last_revival_time = world.time
			SLEEP_CHECK_DEATH(10)
			// Executing rapture scenario
			switch(apostle_num)
				if(1)
					apostle_line = "And I tell you, you are [H.real_name] the apostle, and on this rock I will build my church, and the gates of hell shall not prevail against it."
				if(2)
					apostle_line = "Tell us, when will this happen, and what will be the sign of your coming and of the end of the age?"
				if(3)
					apostle_line = "Do you want us to call fire down from heaven to destroy them?"
					apostle_prev = H.real_name
				if(4)
					apostle_line = "[apostle_prev] the apostle and [H.real_name] the apostle, to them he gave the name Boanerges, which means \"sons of thunder\""
				if(5)
					apostle_line = "[H.real_name] the apostle said, \"Show us the Father and that will be enough for us.\""
				if(6)
					apostle_line = "He saw a human named [H.real_name] the apostle. \"Follow me.\" he told him, and [H.real_name] got up and followed him."
				if(7)
					apostle_line = "Now for some time [H.real_name] the apostle had practiced sorcery and amazed all the people."
				if(8)
					apostle_line = "Then [H.real_name] the apostle said to the rest of disciples, \"Let us also go, that we may die with him.\""
				if(9)
					apostle_line = "Then [H.real_name] the apostle declared, \"You are the son of him, you are the king.\""
				if(10)
					apostle_line = "Then [H.real_name] the apostle said, \"But why do you intend to show yourself to us and not to the world?\""
				if(11)
					apostle_line = "From now on, let no one cause me trouble, for I bear on my body the marks of him."
				if(12) //Here we go sicko mode
					apostle_line = "Have I not chosen you, the Twelve? Yet one of you is a devil."
					H.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_ABSOLUTE)
					H.status_flags |= GODMODE // Immortality...
					rapture_skill.Grant(src)
					if(!client) // AI in control
						addtimer(CALLBACK(src, .proc/rapture), 10 SECONDS)
			for(var/mob/M in GLOB.player_list)
				if(M.z == z && M.client)
					to_chat(M, "<span class='userdanger'>[apostle_line]</span>")
					SEND_SOUND(M, 'ModularTegustation/Tegusounds/apostle/mob/apostle_bell.ogg')
					flash_color(M, flash_color = "#FF4400", flash_time = 50)
			var/datum/antagonist/apostle/new_apostle = new /datum/antagonist/apostle
			new_apostle.number = apostle_num
			H.mind.add_antag_datum(new_apostle)
			apostle_num += 1
			maxHealth += 50
			health = maxHealth
			holy_revival_damage += 1 // More damage and healing from AOE spell.
		else
			playsound(H.loc, 'sound/machines/clockcult/ark_damage.ogg', 50 - attack_range, TRUE, -1)
			// The farther you are from white night - the less damage it deals
			var/dealt_damage = max(1, holy_revival_damage - attack_range)
			H.apply_damage(dealt_damage, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if((holy_revival_damage - attack_range) > 5)
				H.emote("scream")
			to_chat(H, "<span class='userdanger'>The holy light... IT BURNS!!</span>")
	else
		if(H.stat == DEAD && H.mind && faction_check == "apostle") // No gaming
			H.regenerate_limbs()
			H.regenerate_organs()
			H.dna.species.GiveSpeciesFlight(H)
			H.revive(full_heal = TRUE, admin_revive = FALSE)
			H.grab_ghost(force = TRUE)
			to_chat(H, "<span class='notice'>The holy light compels you to live!</span>")
		else
			H.adjustStaminaLoss(-200)
			H.adjustBruteLoss(-holy_revival_damage*5)
			H.adjustFireLoss(-holy_revival_damage*5)
			H.adjustSanityLoss(holy_revival_damage*5) // It actually heals, don't worry
			H.regenerate_limbs()
			H.regenerate_organs()
			to_chat(H, "<span class='notice'>The holy light heals you!</span>")

/mob/living/simple_animal/hostile/abnormality/white_night/proc/fire_field()
	if(fire_field_cooldown > world.time)
		return
	var/turf/target_c = get_turf(src)
	var/list/fire_zone = list()
	fire_field_cooldown = (world.time + fire_field_cooldown_base)
	for(var/i = 1 to field_range)
		playsound(target_c, 'sound/machines/clockcult/stargazer_activate.ogg', 50, 1)
		fire_zone = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/open/T in fire_zone)
			new /obj/effect/temp_visual/cult/turf/floor(T)
		SLEEP_CHECK_DEATH(1.5)
	SLEEP_CHECK_DEATH(3)
	for(var/i = 1 to field_range)
		fire_zone = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		playsound(target_c, "explosion", 25, TRUE)
		for(var/turf/open/T in fire_zone)
			new /obj/effect/temp_visual/fire/fast(T)
			for(var/mob/living/L in T.contents)
				if("apostle" in L.faction)
					continue
				L.apply_damage(20, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
				to_chat(L, "<span class='userdanger'>You're hit by [src]'s fire field!</span>")
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/abnormality/white_night/proc/deafening_scream()
	if(scream_cooldown > world.time)
		return
	scream_cooldown = (world.time + scream_cooldown_base)
	playsound(src, 'ModularTegustation/Tegusounds/apostle/mob/apostle_shout.ogg', 30, 1)
	for(var/mob/living/carbon/C in get_hearers_in_view(7, src))
		to_chat(C, "<span class='danger'>[src] shouts incredibly loud!</span>")
		if("apostle" in C.faction)
			continue
		shake_camera(C, 1, 2)
		C.soundbang_act(1, scream_power, 4)
		C.jitteriness += (scream_power * 0.5)
		C.do_jitter_animation(C.jitteriness)
		C.blur_eyes(scream_power * 0.3, 0.6)
		C.stuttering += (scream_power)

/mob/living/simple_animal/hostile/abnormality/white_night/proc/holy_blink(blink_target)
	if(blink_cooldown > world.time)
		return
	if(!blink_target)
		blink_target = target
	blink_cooldown = (world.time + blink_cooldown_base)
	var/turf/T = get_turf(blink_target)
	var/turf/S = get_turf(src)
	for(var/turf/a in range(1, S))
		new /obj/effect/temp_visual/cult/sparks(a)
	SLEEP_CHECK_DEATH(2.5)
	for(var/turf/b in range(1, T))
		new /obj/effect/temp_visual/cult/sparks(b)
	SLEEP_CHECK_DEATH(5)
	src.visible_message("<span class='danger'>[src] blinks away!</span>")
	for(var/turf/b in range(1, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(b)
		for(var/mob/living/H in b)
			if(!("apostle" in H.faction))
				to_chat(H, "<span class='userdanger'>A sudden wave of wind sends you flying!</span>")
				var/turf/thrownat = get_ranged_target_turf_direct(src, H, 8, rand(-10, 10))
				H.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
				H.apply_damage(10, BRUTE)
				shake_camera(H, 2, 1)
	playsound(T, 'sound/effects/bamf.ogg', 100, 1)
	forceMove(T)

/mob/living/simple_animal/hostile/abnormality/white_night/proc/rapture()
	rapture_skill.Remove(src)
	chosen_attack = 1 // To avoid rapture spam
	to_chat(src, "<span class='userdanger'>You begin the final ritual...</span>")
	sound_to_playing_players('ModularTegustation/Tegusounds/apostle/antagonist/rapture.ogg')
	SLEEP_CHECK_DEATH(30)
	for(var/datum/antagonist/apostle/A in GLOB.apostles)
		if(!A.owner || !ishuman(A.owner.current))
			continue
		var/mob/living/carbon/H = A.owner.current
		if(!H.client)
			var/mob/dead/observer/ghost = H.get_ghost(TRUE, TRUE)
			if(!ghost?.can_reenter_corpse) // If there is nobody able to control it - offer to ghosts.
				addtimer(CALLBACK(GLOBAL_PROC, /proc/offer_control, H))
			else
				H.grab_ghost(force = TRUE)
		H.revive(full_heal = TRUE, admin_revive = FALSE)
		A.rapture()
		shake_camera(H, 1, 1)
		if(A.number < 12)
			var/turf/main_loc = get_step(src, pick(0,1,2,4,5,6,8,9,10))
			SLEEP_CHECK_DEATH(3)
			new /obj/effect/temp_visual/cult/blood(get_turf(H))
			SLEEP_CHECK_DEATH(20)
			new /obj/effect/temp_visual/cult/blood/out(get_turf(H))
			new /obj/effect/temp_visual/cult/blood(main_loc)
			SLEEP_CHECK_DEATH(3)
			H.forceMove(main_loc)
		if(A.number == 12)
			SLEEP_CHECK_DEATH(26)
		for(var/mob/M in GLOB.player_list)
			if(M.z == z && M.client)
				var/mod = "st"
				switch(A.number)
					if(1)
						mod = "st"
					if(2)
						mod = "nd"
					if(3)
						mod = "rd"
					else
						mod = "th"
				to_chat(M, "<span class='userdanger'>[H.real_name], the [A.number][mod]...</span>")
				flash_color(M, flash_color = "#FF4400", flash_time = 50)
		sound_to_playing_players('ModularTegustation/Tegusounds/apostle/mob/apostle_bell.ogg')
		SLEEP_CHECK_DEATH(6 SECONDS)
	SLEEP_CHECK_DEATH(30 SECONDS)
	to_chat(src, "<span class='userdanger'>You feel stronger than ever...</span>")
	holy_revival_range = 20 // Get fucked
	fire_field_cooldown_base = 16 SECONDS
	field_range += 1 // Powercrepe
	add_filter("apostle", 1, rays_filter(size = 64, color = "#FFFF00", offset = 6, density = 16, threshold = 0.05))
	sound_to_playing_players('ModularTegustation/Tegusounds/apostle/antagonist/rapture2.ogg', 50)
	SLEEP_CHECK_DEATH(60 SECONDS)
	apostle_num = 666

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/white_night/success_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(66))
		datum_reference.qliphoth_change(1)
		if(prob(66)) // Rare effect, mmmm
			revive_humans(32, "neutral") // Big heal
	return

/mob/living/simple_animal/hostile/abnormality/white_night/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/white_night/breach_effect(mob/living/carbon/human/user)
	..()
	GiveTarget(user)
	return
