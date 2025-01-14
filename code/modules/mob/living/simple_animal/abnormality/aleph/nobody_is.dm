//Like a pink, weird nothing there. - Coxswain
/mob/living/simple_animal/hostile/abnormality/nobody_is
	name = "Nobody Is"
	desc = "A mirror embedded in gross pink flesh."
	health = 3000
	maxHealth = 3000
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "nobody"
	icon_living = "nobody"
	icon_dead = "nobody_dead"
	portrait = "nobody_is"
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1.2)
	melee_damage_lower = 30
	melee_damage_upper = 50
	move_to_delay = 3
	melee_reach = 2
	ranged = TRUE
	stat_attack = DEAD
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 16
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/mockery,
		/datum/ego_datum/armor/mockery,
	)
	gift_type =  /datum/ego_gifts/mockery
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/nothing_there = 1.5,
		/mob/living/simple_animal/hostile/abnormality/kqe = 1.5,
	)

	observation_prompt = "No matter where you walk to in the cell, the mirror is always facing you. <br>You trace a path around it but all you ever see is your own reflection. <br>\
		\"It's not fair, why do you get to be you and not me?\" <br>Your reflection mutters, parroting your voice. <br>\"Why are you, you and not I? I could be you so much better than you can, just let me try.\" <br>\
		Your reflection is holding out its hand, waiting for a handshake."
	observation_choices = list(
		"Turn away and leave" = list(TRUE, "You make to exit the cell. \"Don't just leave me! I'm somebody, I'm real! I'm..! What's my name?! Just give me your name!\" <br>\
			You don't give your name to the imitation, the closer it starts to mirrors another, the more its mimicry becomes mockery."),
		"Shake their hand" = list(FALSE, "The you in the mirror smiles. <br>\"Just you wait, I'll show you what we can do.\""),
	)

	//Contained Variables
	var/reflect_timer
	var/mob/living/disguise = null
	var/shelled = FALSE
	var/mob/living/carbon/human/chosen = null
	var/can_act = TRUE
	var/current_stage = 1
	var/next_transform = null
	var/list/longhair = list( // EXTREMELY TEMPORARY but easier to do than figuring out complex image manipulation
		"Floorlength Bedhead",
		"Long Side Part",
		"Long Bedhead",
		"Drill Hair (Extended)",
		"Long Hair 2",
		"Silky",
	)
	var/list/longbeard = list("Beard (Very Long)")
	var/solo_punish = FALSE

	//Breach Variables
	var/whip_attack_cooldown
	var/whip_attack_cooldown_time = 6 SECONDS
	var/whip_damage = 25
	var/whip_count = 4
	var/grab_cooldown
	var/grab_cooldown_time = 20 SECONDS
	var/grab_windup_time = 16
	var/grab_damage = 200 //The amount dealt when grabbing someone, twice if they aren't grabbed for whatever reason
	var/strangle_damage = 50 //dealt over time to whoever is grabbed
	var/mob/living/carbon/human/grab_victim = null
	var/release_threshold = 500 //Total raw damage needed to break a player out of a grab (from any source)
	var/release_damage = 0
	var/last_heal_time = 0
	var/heal_percent_per_second = 0.0045

	//Visual effects
	var/obj/effect/reflection/headicon

	//Oberon shit
	var/oberon_mode = FALSE
	var/grab_damage_oberon = 140
	var/strangle_damage_oberon = 35
	var/melee_damage_oberon = 15
	var/mob/living/simple_animal/hostile/abnormality/titania/abno_host
	var/obj/effect/titania_aura/fairy_aura

	//PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/cooldown/nobody_attack,
		/datum/action/innate/abnormality_attack/toggle/nobody_attack_toggle,
	)

/datum/action/cooldown/nobody_attack
	name = "Attack1"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "nt_goodbye"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 20 SECONDS

/datum/action/cooldown/nobody_attack/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/nobody_is))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/nobody_is/nobody_is = owner
	if(nobody_is.current_stage != 3)
		return FALSE
	StartCooldown()
	nobody_is.GrabAttack()
	return TRUE

/datum/action/innate/abnormality_attack/toggle/nobody_attack_toggle
	name = "Toggle Attack"
	button_icon_state = "nt_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't shoot anymore.")
	button_icon_toggle_activated = "nt_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now shoot out tendrils.")
	button_icon_toggle_deactivated = "nt_toggle0"

//Spawning
/mob/living/simple_animal/hostile/abnormality/nobody_is/PostSpawn()
	. = ..()
	if(IsCombatMap())
		current_stage = 2
		next_stage()
		return
	dir = SOUTH
	ChangeReflection()
	reflect_timer = addtimer(CALLBACK(src, PROC_REF(ReflectionCheck)), 3 MINUTES, TIMER_STOPPABLE)

//Work
/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/ReflectionCheck()
	if(datum_reference.working)
		reflect_timer = addtimer(CALLBACK(src, PROC_REF(ReflectionCheck)), 30 SECONDS, TIMER_STOPPABLE)
		return
	ChangeReflection()
	reflect_timer = addtimer(CALLBACK(src, PROC_REF(ReflectionCheck)), 3 MINUTES, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/ChangeReflection()
	var/list/potentialmarked = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(get_user_level(L) <= 4)	//We don't grab people who can barely even work on us
			continue
		potentialmarked += L
	if(LAZYLEN(potentialmarked)) //It's fine if no one got picked. Probably.
		solo_punish = FALSE
		if(LAZYLEN(potentialmarked) < 2)
			solo_punish = TRUE
		ReflectChosen(pick(potentialmarked))
		if(!IsContained())
			to_chat(chosen, span_warning("You feel the mirror's gaze upon you..."))
	else
		ReflectChosen(null)

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/ReflectChosen(mob/living/carbon/human/reflect_target)
	CheckMirrorIcon()
	chosen = reflect_target
	if(!chosen || !IsContained())
		return
	var/obj/item/bodypart/HD = chosen.get_bodypart("head")
	if (!istype(HD))
		return
	if((chosen.hairstyle in longhair) || (chosen.facial_hairstyle in longbeard))
		var/oldhair = chosen.hairstyle
		var/oldbeard = chosen.facial_hairstyle
		chosen.hairstyle = pick("Bedhead", "Bedhead 2", "Bedhead 3")
		chosen.facial_hairstyle = "shaved"
		HD.update_limb()
		chosen.hairstyle = oldhair
		chosen.facial_hairstyle = oldbeard
	HD.update_limb()
	headicon = new(get_turf(src))
	headicon.add_overlay(HD.get_limb_icon(TRUE,TRUE))
	headicon.pixel_y -= 5
	headicon.alpha = 150
	headicon.desc = "It looks like [chosen] is reflected in the mirror."
	//Handles connected structure part
	datum_reference.connected_structures = list(headicon = list(0,-5))

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/CheckMirrorIcon()
	if(headicon) //Grab their head. Literally, and grab the icons from it; discard our old icon if we have one.
		qdel(headicon)
		headicon = null
		datum_reference.connected_structures = list()

/mob/living/simple_animal/hostile/abnormality/nobody_is/WorkChance(mob/living/carbon/human/user, chance)
	var/adjusted_chance = chance
	var/brainpower = get_attribute_level(user, PRUDENCE_ATTRIBUTE)
	if(brainpower < 100)
		adjusted_chance -= (100 - brainpower) * 0.5
	return adjusted_chance

/mob/living/simple_animal/hostile/abnormality/nobody_is/AttemptWork(mob/living/carbon/human/user, work_type)
	if(solo_punish)
		work_damage_amount = 22
		return ..()
	work_damage_amount = initial(work_damage_amount)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nobody_is/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(!solo_punish)
		if(Finisher(user)) //Checks if they are the chosen, and disguises as them if they are.
			return
	else if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/nobody_is/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(user == chosen) //It makes more sense to just check for a disguise, but this is called before PostWorkEffect()
		return
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/nobody_is/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(!(status_flags & GODMODE)) // Already breaching
		return
	if(reflect_timer)
		deltimer(reflect_timer)
	. = ..()
	if(shelled)
		return
	CheckMirrorIcon() //Clear overlays
	next_stage()
	// Teleport us somewhere where nobody will see us at first
	var/list/priority_list = list()
	for(var/turf/T in GLOB.xeno_spawn)
		var/people_in_range = 0
		for(var/mob/living/L in view(9, T))
			if(L.client && L.stat < UNCONSCIOUS)
				people_in_range += 1
				break
		if(people_in_range > 0)
			continue
		priority_list += T
	var/turf/target_turf = pick(GLOB.xeno_spawn)
	if(LAZYLEN(priority_list))
		target_turf = pick(priority_list)
	for(var/turf/open/T in view(3, src))
		var/obj/effect/temp_visual/flesh/pinkflesh =  new(T)
		pinkflesh.color = COLOR_PINK
		pinkflesh.density = FALSE
	forceMove(target_turf)

//Breach
/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/next_stage()
	next_transform = null
	if(shelled) //We have a perfectly good shell already.
		return
	switch(current_stage)
		if(1)
			icon_state = "nobody_shell"
			icon = 'ModularTegustation/Teguicons/64x96.dmi'
			ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.2))
			can_act = FALSE
			pixel_x = -16
			base_pixel_x = -16
			offsets_pixel_x = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
			SetOccupiedTiles(up = 1)
			next_transform = world.time + rand(30 SECONDS, 45 SECONDS)
		if(2)
			breach_affected = list() // Too spooky
			FearEffect()
			icon_state = icon_living
			ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.2))
			can_act = TRUE
			ChangeMoveToDelayBy(1.5)
	current_stage = clamp(current_stage + 1, 1, 3)

/mob/living/simple_animal/hostile/abnormality/nobody_is/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(damagetype == BLACK_DAMAGE || damage < 10)
		return
	if(grab_victim)
		release_damage = clamp(release_damage + damage, 0, release_threshold)
		if(release_damage >= release_threshold)
			ReleaseGrab()
	if(!oberon_mode)
		last_heal_time = world.time + 10 SECONDS // Heal delayed when taking damage; Doubled because it was a little too quick.
	else
		last_heal_time = world.time + 40 SECONDS // Heal delayed even more when taking damage; It was basically unkillable when it was 10 seconds.

/mob/living/simple_animal/hostile/abnormality/nobody_is/Life()
	. = ..()
	if(!.)
		return
	if(!oberon_mode)
		if((last_heal_time + 1 SECONDS) < world.time) // One Second between heals guaranteed
			var/heal_amount = ((world.time - last_heal_time)/10)*heal_percent_per_second*maxHealth
			if(oberon_mode)
				if(abno_host && abno_host.currentlaw == "armor")//prevents regen from happening when you can't smack it with the type it hurts it the most. Range and melee laws aren't affected due to with titania you have soulmate.
					last_heal_time = world.time + 40 SECONDS
			if(health <= maxHealth*0.3)
				heal_amount *= 2
			adjustBruteLoss(-heal_amount)
			last_heal_time = world.time

	if(next_transform && (world.time > next_transform))
		next_stage()
	if(current_stage == 2) // Egg
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.2, time = 7)
	if(shelled)
		var/mob/living/simple_animal/hostile/abnormality/titania/titania
		for(var/mob/living/L in view(2, src))
			if(istype(L, /mob/living/simple_animal/hostile/abnormality/titania))
				titania = L
		if(!titania)
			return
		if(titania.status_flags & GODMODE)
			return
		Oberon(titania)

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/Oberon(mob/living/simple_animal/hostile/abnormality/titania/T)
	if(!istype(T))
		return
	if(T.IsContained()) // prevents nobody is from just yoinking her while she's contained
		return
	if(stat == DEAD || T.stat == DEAD)
		return
	if(!oberon_mode)
		T.ChangeResistances(list(BRUIT = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))//fuck you no damaging while they erp
		ChangeResistances(list(BRUIT = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
		can_act = FALSE
		oberon_mode = TRUE
		T.fused = TRUE
		say("It's you,")
		SLEEP_CHECK_DEATH(2 SECONDS)
		T.say("My nemesis, my beloved devil,")
		SLEEP_CHECK_DEATH(1 SECONDS)
		T.say("The abhorrent name of the one who stole my child.")
		SLEEP_CHECK_DEATH(1 SECONDS)
		T.say("Oberon,")
		SLEEP_CHECK_DEATH(2 SECONDS)
		say("Is that who I am?")
		SLEEP_CHECK_DEATH(2 SECONDS)//theres more that I cut out but you know, people will be bored watching 2 alephs bonding before murder boning
		say("I was born mere moments ago.")
		SLEEP_CHECK_DEATH(1 SECONDS)
		say("Just now I was pondering what I should live as, and how I am to live.")
		SLEEP_CHECK_DEATH(2 SECONDS)
		T.say("Now answer me. Are you Oberon,")
		SLEEP_CHECK_DEATH(2 SECONDS)
		say("Regardless of my stuggles to live, those who remembered me and my memories of them would vaporize in the end...")
		SLEEP_CHECK_DEATH(0.5 SECONDS)
		say("Leaving no trace behind to each other.")
		SLEEP_CHECK_DEATH(1 SECONDS)
		say("...If I earned a name, will I get to receive love and hate from you? Will you remember me as that name, as someone whom you emotionally cared for?")
		SLEEP_CHECK_DEATH(1 SECONDS)
		name = "Oberon"
		say("Then yes, I am the Oberon you seek.")
		SLEEP_CHECK_DEATH(1 SECONDS)
		Oberon_Fusion(T)

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/Oberon_Fusion(mob/living/simple_animal/hostile/abnormality/titania/T)
		abno_host = T
		T.pass_flags = PASSTABLE | PASSMOB
		T.is_flying_animal = FALSE
		T.density = FALSE
		T.forceMove(src)
		T.fairy_spawn_time = 10 SECONDS
		T.melee_damage_lower = 0
		T.melee_damage_upper = 0
		can_act = TRUE
		fairy_aura = new/obj/effect/titania_aura(get_turf(src))
		cut_overlay(icon('icons/effects/effects.dmi', "nobody_overlay_face", GLASSES_LAYER))
		add_overlay(mutable_appearance('icons/effects/effects.dmi', "nobody_overlay_face_oberon", GLASSES_LAYER))
		ChangeResistances(list(BRUIT = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0, PALE_DAMAGE = 0.5))
		heal_percent_per_second = 0.00425//half of what it was when it had just 5k hp
		maxHealth = 10000
		adjustBruteLoss(-maxHealth, forced = TRUE) // It's not over yet!.
		melee_damage_lower = 45
		melee_damage_upper = 65
		grab_damage = 140
		strangle_damage = 35
		whip_damage = 15
		whip_count = 6
		loot = list(
		/obj/item/ego_weapon/oberon
		)

/mob/living/simple_animal/hostile/abnormality/nobody_is/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/nobody_is/Moved()
	if(current_stage == 3)
		playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3)
	. = ..()
	if(.)
		MoveVFX()

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/MoveVFX()
	set waitfor = FALSE
	if(fairy_aura)
		fairy_aura.forceMove(get_turf(src))
		fairy_aura.dir = dir

/mob/living/simple_animal/hostile/abnormality/nobody_is/death(gibbed)
	if(headicon) //Gets rid of the reflection if they died in containtment for any reason
		qdel(headicon)
		headicon = null
		datum_reference.connected_structures = list()
	if(oberon_mode)
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.stat != DEAD && M.client)
				M.Apply_Gift(new /datum/ego_gifts/oberon)
		if(fairy_aura)
			qdel(fairy_aura)
		if(abno_host)
			abno_host.death()
	if(grab_victim)
		ReleaseGrab()
	return ..()

//Attacks
/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/WhipAttack(target)
	if(whip_attack_cooldown > world.time)
		return
	whip_attack_cooldown = world.time + whip_attack_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/scarecrow/death.ogg', 75, 0, 3)
	if(shelled)
		add_overlay(icon('icons/effects/effects.dmi', "galaxy_aura"))
	else
		icon_state = "nobody_ranged"
	var/turf/target_loc = get_turf(target)
	var/turf/start_loc = get_turf(src)
	var/turf/MT = get_turf(src)
	var/list/turfs_to_hit = getline(start_loc, get_ranged_target_turf_direct(start_loc, target_loc, 14))
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		new /obj/effect/temp_visual/cult/sparks(T)
	var/whip_delay = (get_dist(src, target) <= 2) ? (0.75 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(whip_delay)
	for(var/i = 1 to whip_count)
		var/obj/projectile/P = new /obj/projectile/beam/nobody(start_loc)
		if(oberon_mode)
			P = new /obj/projectile/beam/oberon(start_loc)
		P.starting = start_loc
		P.firer = src
		P.fired_from = src
		P.yo = target_loc.y - start_loc.y
		P.xo = target_loc.x - start_loc.x
		P.original = target
		P.preparePixelProjectile(target_loc, src, spread = rand(0, 10))
		P.damage = whip_damage
		P.fire()
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		for(var/mob/living/L in T)
			if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT|| z != L.z) // Dead or in hard crit, insane, or on a different Z level.
				continue
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(MT, rand(1, 2), whack_speed, src)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/fairygentleman/ego_sloshing.ogg', 75, 0, 3)
	SLEEP_CHECK_DEATH(1 SECONDS)
	if(shelled)
		cut_overlay(icon('icons/effects/effects.dmi', "galaxy_aura"))
	else
		icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/GrabAttack()
	if(grab_cooldown > world.time)
		return
	grab_cooldown = world.time + grab_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 75, 0, 5)
	if(shelled)
		add_overlay(icon('icons/effects/effects.dmi', "lovetown_shapes"))
	else
		icon_state = "nobody_grab"
	SLEEP_CHECK_DEATH(grab_windup_time)
	for(var/turf/T in view(3, src))
		new /obj/effect/temp_visual/nobody_grab(T)
		for(var/mob/living/L in HurtInTurf(T, list(), grab_damage, BLACK_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE))
			if(oberon_mode)
				HurtInTurf(T, list(), grab_damage_oberon, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE)
			if(L.health < 0)
				if(ishuman(L))
					var/mob/living/carbon/H = L
					if(!Finisher(H))
						H.gib()
				else
					L.gib()
			else if(!grab_victim)
				for(var/mob/living/carbon/human/H in T.contents)
					if(faction_check_mob(H, FALSE) || H.z != z)
						continue
					if(!shelled) //If we don't have a shell, we can't grab just anyone. Only the chosen one.
						if(H != chosen)
							continue
					grab_victim = H
					Strangle()
			else //deal the damage twice if we already have someone grabbed
				L.deal_damage(grab_damage, BLACK_DAMAGE)

	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/attack.ogg', 75, 0, 3)
	SLEEP_CHECK_DEATH(3)
	if(shelled)
		cut_overlay(icon('icons/effects/effects.dmi', "lovetown_shapes"))
	else
		icon_state = icon_living
	if(!grab_victim)
		can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/Strangle()
	set waitfor = FALSE
	release_damage = 0
	grab_victim.Immobilize(10)
	if(grab_victim.sanity_lost)
		grab_victim.Stun(10) //Immobilize does not stop AI controllers from moving, for some reason.
	face_atom(grab_victim)
	var/turf/T = get_step(src, dir)
	if(!isopenturf(T))
		grab_victim.forceMove(get_turf(src))
	else
		grab_victim.forceMove(T)
	animate(grab_victim, pixel_y = 8, time = 5)
	SLEEP_CHECK_DEATH(5)
	to_chat(grab_victim, span_userdanger("[src] has grabbed you! Attack [src] to break free!"))
	StrangleHit(1)

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/StrangleHit(count)
	if(!grab_victim)
		ReleaseGrab()
		return
	if(grab_victim.health < 0)
		if(!Finisher(grab_victim))
			grab_victim.gib()
		ReleaseGrab()
		return
	grab_victim.deal_damage(strangle_damage, BLACK_DAMAGE)
	if(oberon_mode)
		grab_victim.deal_damage(strangle_damage_oberon, RED_DAMAGE)
	grab_victim.Immobilize(10)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 50, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nobodyis/strangle.ogg', 100, 0, 7)
	switch(count)
		if(0 to 2)
			playsound(get_turf(src), 'sound/effects/wounds/crack1.ogg', 200, 0, 7)
			to_chat(grab_victim, span_userdanger("You felt something snap!"))
		if(3)
			playsound(get_turf(src), 'sound/effects/wounds/crack2.ogg', 200, 0, 7)
			to_chat(grab_victim, span_userdanger("[src]'s grip on you is tightening!"))
		if(4)	//Apply double damage
			playsound(get_turf(src), 'sound/effects/wounds/crackandbleed.ogg', 200, 0, 7)
			to_chat(grab_victim, span_userdanger("It hurts so much!"))
			grab_victim.deal_damage(strangle_damage, BLACK_DAMAGE)
		else	//Apply ramping damage
			playsound(get_turf(src), 'sound/effects/wounds/crackandbleed.ogg', 200, 0, 7)
			grab_victim.deal_damage((strangle_damage * (3 - count)), BLACK_DAMAGE)
	count += 1
	if(grab_victim.sanity_lost) //This should prevent weird things like panics running away halfway through
		grab_victim.Stun(10) //Immobilize does not stop AI controllers from moving, for some reason.
	SLEEP_CHECK_DEATH(10)
	StrangleHit(count)

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/ReleaseGrab()
	if(grab_victim)
		animate(grab_victim, pixel_y = 0, time = 5)
		grab_victim.pixel_y = 0
	grab_victim = null
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nobody_is/OpenFire()
	if(!can_act)
		return
	if(current_stage == 3)
		if(client)
			switch(chosen_attack)
				if(1)
					WhipAttack(target)
			return
		if(whip_attack_cooldown <= world.time)
			WhipAttack(target)
		if((grab_cooldown <= world.time) && (get_dist(src, target) < 4))
			GrabAttack()

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/Finisher(mob/living/carbon/human/H) //return TRUE to prevent attacking, as attacking causes runtimes if the target is gibbed.
	if(shelled)
		return FALSE //We don't want it repeatedly turning into different people
	else if(H == chosen) // Uh oh
		disguise_as(H)
		return TRUE
	return FALSE

//Patrol/Targetting
/mob/living/simple_animal/hostile/abnormality/nobody_is/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(oberon_mode)
		if(isliving(attacked_target))
			var/mob/living/L = attacked_target
			L.deal_damage(melee_damage_oberon, RED_DAMAGE)
	if(!client)
		if((current_stage == 3) && (grab_cooldown <= world.time) && prob(35))
			return GrabAttack()
		if((current_stage == 3) && (whip_attack_cooldown <= world.time) && prob(35))
			var/turf/target_turf = get_turf(target)
			for(var/i = 1 to 3)
				target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
			return WhipAttack(target_turf)
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(L.health <= 0)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.stat == DEAD)
					Finisher(H)
					LoseTarget(H)
					return
				return..()
			LoseTarget(L)
			return
	return ..()

/mob/living/simple_animal/hostile/abnormality/nobody_is/patrol_select() //Hunt down the chosen one
	if(chosen) //YOU'RE MINE
		SEND_SIGNAL(src, COMSIG_PATROL_START, src, get_turf(chosen)) //Overrides the usual proc to target a specific tile
		SEND_GLOBAL_SIGNAL(src, COMSIG_GLOB_PATROL_START, src, get_turf(chosen))
		patrol_path = get_path_to(src, get_turf(chosen), TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	else
		ChangeReflection()
	return ..()

/mob/living/simple_animal/hostile/abnormality/nobody_is/PickTarget(list/Targets)
	var/list/priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H == chosen)
				return H //YOU'RE MINE
		if(L.health <= 0) //ignore the dead
			continue
		priority += L
	if(LAZYLEN(priority))
		return pick(priority)

//Disguise
/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/disguise_as(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(!M || QDELETED(M))
		return //We screwed up or the player successfully committed self-delete. Try again next time!
	SetOccupiedTiles()
	offsets_pixel_x = list("south" = 0, "north" = 0, "west" = 0, "east" = 0)
	//UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	for(var/turf/open/T in view(2, src))
		var/obj/effect/temp_visual/flesh/pinkflesh =  new(T)
		pinkflesh.color = COLOR_PINK
		pinkflesh.density = FALSE
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/disguise.ogg', 75, 0, 5)
	new /obj/effect/gibspawner/generic(get_turf(M))
	to_chat(M, span_userdanger("Oh no..."))
	CheckMirrorIcon() //Clear overlays
	// The following code makes it so that even if a disguised mob is resting, the shell will still be standing up.
	if(M.hairstyle in longhair) //Sloppy fix since the layers don't work in the mutable appearances
		var/obj/item/bodypart/HD = M.get_bodypart("head")
		if (!istype(HD))
			return
		M.hairstyle = pick("Bedhead", "Bedhead 2", "Bedhead 3")
		M.update_hair()
	M.drop_all_held_items() //Drop items, backpacks, and oclothing so they don't show up in the shell's sprite under the overlay
	if(M.wear_suit)
		M.dropItemToGround(M.wear_suit)
		M.update_inv_wear_suit()
	if(M.back)
		M.dropItemToGround(M.back)
		M.update_inv_back()
	M.set_lying_angle(0)
	M.set_body_position(STANDING_UP)
	M.forceMove(src) // Hide them for examine message to work
	adjustBruteLoss(-maxHealth, forced = TRUE)
	Transform(M)

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/Transform(mob/living/carbon/human/M)
	set waitfor = FALSE
	SLEEP_CHECK_DEATH(5)
	if(!M || QDELETED(M))
		return //We screwed up or the player successfully committed self-delete. Try again next time!
	disguise = M
	shelled = TRUE
	add_overlay(mutable_appearance('icons/effects/effects.dmi', "nobody_overlay", SUIT_LAYER))
	add_overlay(mutable_appearance('icons/effects/effects.dmi', "nobody_overlay_face", GLASSES_LAYER))
	appearance = M.appearance
	if(target)
		LoseTarget(target)
	M.gib()
	attack_verb_continuous = "strikes"
	attack_verb_simple = "strike"
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
	ChangeResistances(list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0, PALE_DAMAGE = 0.8)) //Damage, resistances, and cooldowns all go to the roof
	maxHealth = 4000
	melee_damage_lower = 65
	melee_damage_upper = 75
	current_stage = 3
	melee_reach = 1
	whip_count = 8
	grab_damage = 250
	strangle_damage = 70
	grab_cooldown_time = 12 SECONDS
	grab_windup_time = 12
	whip_attack_cooldown_time = 5 SECONDS
	heal_percent_per_second = 0.0085
	if(status_flags & GODMODE) // Still contained
		addtimer(CALLBACK(src, PROC_REF(ZeroQliphoth)), rand(5 SECONDS, 10 SECONDS))

/mob/living/simple_animal/hostile/abnormality/nobody_is/examine(mob/user)
	if(disguise)
		return disguise.examine(user)
	. = ..()
	if(current_stage >= 1)
		. += (span_notice("It looks angry!"))


//Misc
/mob/living/simple_animal/hostile/abnormality/nobody_is/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods)
	. = ..()
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/talker = speaker
	if(talker != chosen) // Only copies the person it has chosen
		return
	if((findtext(message, "uwu") || findtext(message, "owo") || findtext(message, "daddy") || findtext(message, "what the dog doin")) && !isnull(talker) && talker.stat != DEAD)
		if(status_flags & GODMODE) //if contained
			BreachEffect()
			next_stage()
		forceMove(get_turf(talker))
		GiveTarget(talker)
		return
	var/new_message = Gibberish(raw_message, TRUE, 40)
	say(new_message)

//Objects
/obj/effect/reflection // Hopefully temporary or at least removed someday
	layer = ABOVE_ALL_MOB_LAYER

//Allow for titana's laws to exist for nobody is I think
/mob/living/simple_animal/hostile/abnormality/nobody_is/bullet_act(obj/projectile/Proj)
	if(oberon_mode)
		abno_host.bullet_act(Proj)
	..()

/mob/living/simple_animal/hostile/abnormality/nobody_is/attacked_by(obj/item/I, mob/living/user)
	if(oberon_mode)
		abno_host.attacked_by(I, user)
	..()

//A simple test function to force oberon to happen without killing the reflected

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/Transform_No_Kill(mob/living/carbon/human/M)
	set waitfor = FALSE
	SLEEP_CHECK_DEATH(5)
	if(!M || QDELETED(M))
		return //We screwed up or the player successfully committed self-delete. Try again next time!
	disguise = M
	shelled = TRUE
	add_overlay(mutable_appearance('icons/effects/effects.dmi', "nobody_overlay", SUIT_LAYER))
	add_overlay(mutable_appearance('icons/effects/effects.dmi', "nobody_overlay_face", GLASSES_LAYER))
	appearance = M.appearance
	if(target)
		LoseTarget(target)
	attack_verb_continuous = "strikes"
	attack_verb_simple = "strike"
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
	ChangeResistances(list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0, PALE_DAMAGE = 0.8)) //Damage, resistances, and cooldowns all go to the roof
	maxHealth = 4000
	melee_damage_lower = 65
	melee_damage_upper = 75
	current_stage = 3
	melee_reach = 1
	whip_count = 8
	grab_damage = 250
	strangle_damage = 70
	grab_cooldown_time = 12 SECONDS
	grab_windup_time = 12
	whip_attack_cooldown_time = 5 SECONDS
	heal_percent_per_second = 0.0085
	if(status_flags & GODMODE) // Still contained
		ZeroQliphoth()

/mob/living/simple_animal/hostile/abnormality/nobody_is/proc/Quick_Oberon_Spawn()
	if(!chosen || oberon_mode)//makes sure it doesn't continue if its already oberon or if there's no chosen.)
		return
	Transform_No_Kill(chosen)
	oberon_mode = TRUE
	name = "Oberon"
	var/mob/living/simple_animal/hostile/abnormality/titania/T = new(get_turf(src))
	T.core_enabled = FALSE
	T.BreachEffect()
	T.fused = TRUE
	T.ChangeResistances(list(BRUIT = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))//fuck you no damaging while they erp
	Oberon_Fusion(T)
