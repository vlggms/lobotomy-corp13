/*
Little Red Riding Hooded Mercenary, coded by Nutterbutter as part of May 2023's Abno Jam
The fucker has arrived.
*/

/mob/living/simple_animal/hostile/abnormality/red_hood
	name = "Little Red Riding Hooded Mercenary"
	desc = "A tall humanoid in ragged red robes."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "red_hood"
	icon_living = "red_hood"
	attack_sound = 'sound/abnormalities/redhood/attack_1.ogg'
	del_on_death = TRUE
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 2400 // More health than standard
	health = 2400 // Since she was apparently too easy to suppress
	rapid_melee = 2
	speed = 0.5
	threat_level = WAW_LEVEL
	work_chances = list( // Red's counter is unaffected by work, so her rates matter less than usual. I've upped them from base LC to encourage working her more.
		ABNORMALITY_WORK_INSTINCT = list(50, 55, 60, 65, 70),
		ABNORMALITY_WORK_INSIGHT = list(40, 45, 50, 55, 60),
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 45,
		"Request" = 100
		)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5) // Fuck you, blue shepherd.
	ranged = TRUE
	melee_damage_lower = 30
	melee_damage_upper = 45
	attack_action_types = list(/datum/action/innate/abnormality_attack/find_target, /datum/action/innate/abnormality_attack/catch_breath, /datum/action/innate/abnormality_attack/hollowpoint_shell, /datum/action/innate/abnormality_attack/strike_without_hesitation)
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	patrol_cooldown_time = 10 SECONDS // She's restless
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cuts"
	faction = list("redhood") // I'LL FUCKIN FIGHT YOU TOO, MATE
	can_breach = TRUE
	start_qliphoth = 3

	ego_list = list(
		/datum/ego_datum/weapon/crimson,
		/datum/ego_datum/weapon/crimson/gun,
		/datum/ego_datum/armor/crimson
		)
	gift_type = /datum/ego_gifts/crimson
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	/*
	Red's targeting logic

	PRIORITIES

	Wolf
	---
	Buddy
	---
	Request target
	---
	Blue
	---
	Players				(on the		)
	Other abnormalities	(same level	)

	Her dynamic with each priority target is different.
	Against the wolf, she will instantly enrage, and continue enraged once he's dead if she didn't land the killing blow. Otherwise, de-enrage.
	Against a lone Buddy, she will enrage if brought to 50% HP, then de-enrage even if she doesn't land the killing blow, because she'll see through the ruse.
	If Blue Smocked Shepherd is within range of the above interaction, she will enrage against him, but de-enrage even if she doesn't get the kill.
	Against a requested target, once she lands the kill she returns to containment.
	If she encounters Blue normally, she will prioritize him, but not enrage.
	If lacking a priority target of any kind, and not enraged, she'll return to her cell after a few kills.
	*/

	var/red_rage = 0 // Goes up to 3; 1 for "weak rage" (against buddy and blue), 2 for "strong rage" (against wolf), 3 for "aimless rage" (denied wolf kill)
	var/target_priority = 0 // Goes up to 4; 1 for Blue Smocked Shepherd, 2 for the requested target, 3 for Buddy, 4 for Wolf.
	var/mob/living/simple_animal/hostile/priority_target // Stores current request target.
	var/fuzzy_tracking_cooldown = 10 SECONDS // How often red re-checks the closest landmark to the target.
	var/list/tiered_request_costs = list(
		ZAYIN_LEVEL = 100,
		TETH_LEVEL = 200,
		HE_LEVEL = 300,
		WAW_LEVEL = 400,
		ALEPH_LEVEL = 500
	) // PE cost to hunt abnos, one per tier.
	var/default_request_cost = 400 // PE cost to hunt anything not considered an abno, like an ordeal.
	var/out_on_request = FALSE // Is she hunting something on request, or...?
	var/found_target = FALSE
	var/kill_confirmed = TRUE
	var/retarget_lockout // Timer variable to keep red from instantly re-targeting something she reacts to the death of.

	var/hunt_track_timer = 0
	var/hunt_track_cooldown = 10 SECONDS

	var/special_attacking = FALSE // Are you currently performing a special attack
	var/special_windup = 8 // How many deciseconds between showing a tell for a special attack and using it

	var/evade_timer = 0
	var/evade_cooldown = 5 SECONDS // Doubled on failed evade
	var/evading_attack = FALSE // Are you currently EVADING damage

	var/gun_timer = 0
	var/gun_cooldown = 5 SECONDS
	var/gun_multishot_pause = 2.5 // How long to pause between shots in a volley
	var/bullet_additional = 0 // How many extra times to shoot
	var/bullet_damage = 30 // How much damage each hollowpoint shell does

	var/throw_timer = 0
	var/throw_cooldown = 11 SECONDS
	var/throw_amount = 3 // How many blades to throw at once
	var/throw_cone = 25 // Total firing angle of all red's projectiles.
	var/throw_damage = 40 // Damage of each thrown blade

	var/list/wolf_encounter_lines = list( // Encountering Big and Will Be Bad Wolf
		"Found you, you bastard!",
		"I'll have your head!",
		"You won't get away this time!"
	)
	var/list/denied_kill_lines = list( // After being denied the killing blow on Wolf. Randomly during rage level 3.
		"HE WAS MINE!!",
		"YOU BASTARDS!!",
		"I'LL KILL EVERY LAST ONE OF YOU!!"
	)

	var/list/buddy_encounter_lines = list( // Encountering Reddened Buddy by surprise (i.e. not requested).
		"A wolf?! But I didn't...",
		"Right now?! How did...",
		"No... I couldn't have..."
	)

	var/list/request_locate_lines = list( // Entering combat against a requested target without more specific lines.
		"Found you...",
		"The hunt is on.",
		"You can't run."
	)

	var/list/blue_evade_lines = list( // Evading blue's AOE while fighting something else.
		"Watch it!",
		"Idiot!",
		"What are you aiming at?!"
	)
	var/list/blue_evade_taunt_lines = list( // Evading blue's AOE while hostile to him.
		"You're slow!",
		"What's the matter, scared?",
		"Get your eye checked."
	)

	var/list/weapon_throw_lines = list( // Using the weapon throw attack.
		"No hesitation!",
		"You're dead!",
		"Eat this!"
	)

/datum/action/innate/abnormality_attack/find_target // AI-controlled Red technically doesn't use this one.
	name = "Locate target"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "red_target"
	chosen_message = "<span class='danger'>You try to suss out where your target is...</span>"
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/find_target/Activate()
	addtimer(CALLBACK(A, .mob/living/simple_animal/hostile/abnormality/red_hood/proc/PlayerTargetFind), 1)
	to_chat(A, chosen_message)

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/PlayerTargetFind()
	HunterTracking(priority_target) // basically a redirect, ability code is weird

/datum/action/innate/abnormality_attack/catch_breath // AI-controlled Red technically doesn't use this one EITHER.
	name = "Evade"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "ruina_evade"
	chosen_message = "<span class='danger'>You prepare to avoid an incoming attack.</span>"
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/catch_breath/Activate()
	addtimer(CALLBACK(A, .mob/living/simple_animal/hostile/abnormality/red_hood/proc/AttemptEvade), 1)
	to_chat(A, chosen_message)

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/AttemptEvade()
	if((world.time < evade_timer) || evading_attack)
		if(client)
			to_chat(src, "<span class='danger'> You can't do that now!</span>")
		return FALSE
	evading_attack = TRUE
	addtimer(CALLBACK(src, .proc/EndEvade), 20)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/apply_damage(damage = 0,damagetype = RED_DAMAGE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	if(evading_attack)
		evading_attack = FALSE
		EndEvade()
		return FALSE
	..()
	if(health > (maxHealth * 0.8) || !priority_target)
		return
	if(red_rage < 1 && target_priority > 2)
		RageUpdate(1)

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/WatchIt() // Evade Blue's indiscriminate attacks, just to fuck him even harder.
	if(red_rage < 2)
		if(target_priority != 1)
			say(pick(blue_evade_lines))
		else
			say(pick(blue_evade_taunt_lines))
	else
		if(!client)
			manual_emote("acrobatically spins out of the way.")
	SpinAnimation(7, 1)
	adjustBruteLoss(-50)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/RageUpdate(rage_change) // Always call this after changing red_rage manually, or call it to change red_rage
	if(rage_change)
		red_rage = rage_change
	if(red_rage > 0)
		damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1.5) // She takes... very little damage.
		speed = 0
		rapid_melee = 3
		gun_cooldown = 3 SECONDS
		bullet_additional = 2
		throw_cooldown = 8 SECONDS
		throw_amount = 5
		throw_cone = 35
		color = rgb(255, 64, 64)
		set_light(1, 8, COLOR_VIVID_RED)
		set_light_on(TRUE)
		update_light()
	else
		damage_coeff = initial(damage_coeff)
		speed = initial(speed)
		rapid_melee = initial(rapid_melee)
		gun_cooldown = initial(gun_cooldown)
		bullet_additional = initial(bullet_additional)
		throw_cooldown = initial(throw_cooldown)
		throw_amount = initial(throw_amount)
		throw_cone = initial(throw_cone)
		color = initial(color)
		set_light()
		set_light_on(FALSE)
		update_light()

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/EndEvade()
	if(evading_attack)
		evading_attack = FALSE
		visible_message("<span='notice'>[src] seems out of breath!</span>", "<span='warning'>You didn't dodge anything!</span>")
		evade_timer = world.time + evade_cooldown * 2
		return
	SpinAnimation(7, 1)
	visible_message("<span='notice'>[src] evades the attack!</span>", "<span='nicegreen'>You evade the attack!</span>")
	adjustBruteLoss(-50) // Recover a little HP for your dodge
	evade_timer = world.time + evade_cooldown
	return

/datum/action/innate/abnormality_attack/hollowpoint_shell
	name = "Hollowpoint Shell"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "hollowpoint_ability"
	chosen_message = "<span class='danger'>You will now fire at whatever you next click on.</span>"
	chosen_attack_num = 3

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/Hollowpoint(atom/target) // Fire a round in the direction of the enemy. When enraged, shoot multiple times.
	if(world.time < gun_timer)
		if(client)
			to_chat(src, "<span class='danger'> You can't do that now!</span>")
		return FALSE
	special_attacking = TRUE
	gun_timer = world.time + gun_cooldown
	addtimer(CALLBACK(src, .proc/SpecialReset), 10 + bullet_additional * gun_multishot_pause)
	manual_emote("raises her gun.")
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "redhood_shoot"
	icon_living = "redhood_shoot"
	pixel_x = -32
	base_pixel_x = -32
	addtimer(CALLBACK(src, .proc/HunterBullet, target, bullet_additional), special_windup * 0.75)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/HunterBullet(atom/target, shots_remaining = 0)
	var/turf/startloc = get_turf(src)
	var/angle_to_target = Get_Angle(src, target)
	var/obj/projectile/red_hollowpoint/P = new(get_turf(src))
	P.starting = startloc
	P.firer = src
	P.fired_from = src
	P.Angle = angle_to_target
	P.original = target
	P.preparePixelProjectile(target, src)
	P.damage = bullet_damage
	P.fire()
	playsound(src, 'sound/abnormalities/redhood/fire.ogg', 50, FALSE, 4)
	if(shots_remaining)
		addtimer(CALLBACK(src, .proc/HunterBullet, target, shots_remaining - 1), gun_multishot_pause)
	return

/datum/action/innate/abnormality_attack/strike_without_hesitation
	name = "Blade Throw"
	icon_icon = 'icons/obj/projectiles.dmi'
	button_icon_state = "hunter_blade"
	chosen_message = "<span class='danger'>You will throw a spread of blades at whatever you next click on.</span>"
	chosen_attack_num = 4

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/BladeThrow(atom/target) // Throw a barrage of piercing blades in the direction of the enemy.
	if(throw_timer > world.time)
		if(client)
			to_chat(src, "<span class='danger'> You can't do that now!</span>")
		return FALSE
	special_attacking = TRUE
	addtimer(CALLBACK(src, .proc/SpecialReset), 15)
	throw_timer = world.time + throw_cooldown
	say(pick(weapon_throw_lines))
	addtimer(CALLBACK(src, .proc/GetThrown, target), special_windup)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/GetThrown(atom/target)
	playsound(src, 'sound/abnormalities/redhood/throw.ogg', 50, FALSE, 4)
	var/turf/startloc = get_turf(src)
	var/angle_to_target = Get_Angle(src, target)
	var/projectile_angle_difference = (throw_cone / (throw_amount - 1))
	for(var/i = 0 to throw_amount - 1) // Create throw_amount projectiles evenly spaced across an arc of throw_cone degrees centered aiming at enemy, and fire them.
		var/obj/projectile/hunter_blade/P = new(get_turf(src))
		P.nondirectional_sprite = TRUE
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.original = target
		P.preparePixelProjectile(target, src)
		P.damage = throw_damage
		P.fire(angle_to_target - (throw_cone / 2) + projectile_angle_difference * i)

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/SpecialReset()
	special_attacking = FALSE
	icon = initial(icon)
	icon_state = initial(icon_state)
	icon_living = initial(icon_living)
	pixel_x = initial(pixel_x)
	base_pixel_x = initial(base_pixel_x)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/Initialize()
	..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, .proc/OnAbnoBreach)

/mob/living/simple_animal/hostile/abnormality/red_hood/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type != "Request")
		return TRUE
	if(SSlobotomy_corp.current_box < tiered_request_costs[ALEPH_LEVEL])
		if(client)
			to_chat(user,"<span class='notice'>Not enough personal PE to make a request.</span>")
		else
			say("You can't afford my services.")
		return FALSE
	RequestTarget(user)
	return

/*
	Requestable conditions:
	- Abnormality or hostile mob
	- Reachable without a hassle (same Z level, in bounds, etc.)
	- Must be breached (if applicable), mortal, and capable of taking red damage
*/

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/RequestTarget(mob/living/carbon/human/user) // Code initially jacked from the Possess! verb
	var/list/huntable = list()
	for(var/mob/living/simple_animal/hostile/H in GLOB.alive_mob_list)
		if(H.z != src.z || !get_turf(H) || H == src)
			continue
		if(istype(H,/mob/living/simple_animal/hostile/abnormality)) // Since I'm checking containment status
			var/mob/living/simple_animal/hostile/abnormality/potential_target = H
			if(potential_target.IsContained())
				continue
		huntable |= H
	if(!LAZYLEN(huntable))
		if(client)
			to_chat(user,"<span class='notice'>There's nothing for [src] to hunt.</span>")
		else
			say("Nothing to hunt right now...")
		return FALSE

	var/mob/living/simple_animal/hunted = input(user, "What's the target?", "Select hunt target", null) as null|anything in sortNames(huntable)
	if(!hunted)
		if(client)
			to_chat(user,"<span class='notice'>You decided not to make a request after all.</span>")
		else
			say("Changed your mind? Tch. Call me when you need me.")
		return FALSE

	priority_target = hunted
	out_on_request = TRUE

	if(istype(hunted, /mob/living/simple_animal/hostile/abnormality))
		var/mob/living/simple_animal/hostile/abnormality/abno = hunted
		SSlobotomy_corp.current_box -= tiered_request_costs[abno.threat_level]
	else
		SSlobotomy_corp.current_box -= default_request_cost

	if(client)
		to_chat(src, "<span class='notice'>You've been contracted to hunt [priority_target.name].</span>")
	else
		if(istype(priority_target, /mob/living/simple_animal/hostile/abnormality/red_buddy))
			manual_emote("'s eye widens slightly.")
			SLEEP_CHECK_DEATH(10)
			say("Hm. A wolf? Not MY wolf, but a wolf nonetheless...")
			SLEEP_CHECK_DEATH(40)
			say("Well, then. I guess it's time for a hunt.")
			SLEEP_CHECK_DEATH(40)
			target_priority = 3
			BreachEffect()
			return
		if(istype(priority_target, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
			manual_emote("'s eye narrows.")
			SLEEP_CHECK_DEATH(10)
			say("That idiot? You're sure?")
			SLEEP_CHECK_DEATH(40)
			manual_emote("chuckles darkly.")
			SLEEP_CHECK_DEATH(6)
			say("I've been waiting for a chance to teach him a lesson.")
			SLEEP_CHECK_DEATH(34)
			target_priority = 1
			BreachEffect()
			return
		else
			target_priority = 2

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(istype(abno, /mob/living/simple_animal/hostile/abnormality/punishing_bird))
		if(client)
			to_chat(src, "<span class='notice'>You hear an annoying fluttering, and immediately disregard it.</span>")
		else
			manual_emote("perks up for a moment, then settles back down, looking annoyed.")
		return
	if(datum_reference.qliphoth_meter > 1)
		if(client)
			to_chat(src, "<span class='notice'>You hear something...</span>")
		else
			manual_emote("perks up slightly, as though she hears something.")
	datum_reference.qliphoth_change(-1) // This is literally the only way her counter goes down.

/mob/living/simple_animal/hostile/abnormality/red_hood/BreachEffect(mob/living/carbon/human/user)
	..()
	if(target_priority)
		if(client)
			to_chat(src, "<span class='notice'>You have a target to hunt.</span>")
		else
			manual_emote("adopts a fighting stance, eye gleaming with intent.")
			HunterTracking(priority_target)
	else
		if(client)
			to_chat(src, "<span class='warning'>You've gotta get out of here!</span>")
		else
			manual_emote("grips her weapons, looking around wildly.")

/*
Red's ability to track a target at a distance. Should only be used for priority targets.
Runs about once every ten seconds if Red hasn't located the target.
Finds the nearest point of interest (xeno spawn or department center) and sets it as the patrol destination. Simple as that.
Also a toned down version
*/

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/HunterTracking(mob/living/simple_animal/hostile/hunted_target, turf/last_closest, attempts = 3)
	if(!hunted_target || hunted_target.health <= 0)
		if(client)
			to_chat(src, "<span class='notice'>You don't have a target...</span>")
		target_priority = 0
		priority_target = null
		out_on_request = FALSE
		return FALSE // Hunted target has disappeared, reset priority. What's that? You were out on request? Yeah, sorry.
	if(found_target)
		if(client)
			to_chat(src, "<span class='notice'>You've already found [hunted_target]!</span>")
		return FALSE // Found something
	if(client)
		if(hunt_track_timer > world.time)
			to_chat(src, "<span class='notice'>You need another moment...</span>")
			return FALSE
		to_chat(src, "<span class='notice'>You can sense where [hunted_target] is.</span>")
		hunt_track_timer = world.time + hunt_track_cooldown
		var/turf/start_turf = get_turf(src)
		var/turf/last_turf = get_ranged_target_turf_direct(start_turf, hunted_target, 5)
		var/list/navline = getline(start_turf, last_turf)
		for(var/turf/T in navline)
			new /obj/effect/temp_visual/cult/turf/floor(T)
		return FALSE
	if(attempts == 0)
		patrol_to(get_turf(hunted_target))
		addtimer(CALLBACK(src, .proc/HunterTracking, hunted_target, get_turf(hunted_target), attempts), fuzzy_tracking_cooldown)
		return TRUE
	var/list/points_of_interest = GLOB.department_centers + GLOB.xeno_spawn
	var/lowest_dist = 999
	var/turf/closest
	for(var/turf/T in points_of_interest)
		if(T == last_closest) // Don't patrol to the same spot twice.
			continue
		var/current_dist = get_dist(T, get_turf(hunted_target))
		if(current_dist < lowest_dist)
			lowest_dist = current_dist
			closest = T
	if(!closest)
		return FALSE // Where the fuck even ARE you?
	patrol_to(closest)
	attempts -= 1
	addtimer(CALLBACK(src, .proc/HunterTracking, hunted_target, closest, attempts), fuzzy_tracking_cooldown)
	return TRUE

// Only watch out for things at or above your current priority level
// No, this shouldn't be a case switch. They all need to run potentially sequentially in this order. It also can't be handled by Found().
/mob/living/simple_animal/hostile/abnormality/red_hood/FindTarget(list/possible_targets, HasTargetsList = 0)
	if(!HasTargetsList)
		possible_targets = ListTargets()
	// First, look for wolf. This is unconditional. If wolf is in sight, set priority to 4, GiveTarget him, and return him.
	// Wolf isn't in the game right now, so this comment serves as a note for later.
	if(retarget_lockout > world.time) // stop whining about buddy three times before he can fade out, please.
		return ..()
	if(target_priority <= 3)
		var/mob/living/simple_animal/hostile/abnormality/red_buddy/hunted_buddy = locate() in possible_targets
		if(hunted_buddy)
			target_priority = 3
			priority_target = hunted_buddy
			GiveTarget(priority_target)
			return priority_target
	if(target_priority <= 2 && priority_target)
		if(locate(priority_target) in possible_targets)
			target_priority = 2
			GiveTarget(priority_target)
			return priority_target
	if(target_priority <= 1)
		var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/hunted_blue = locate() in possible_targets
		if(hunted_blue)
			target_priority = 3
			priority_target = hunted_blue
			GiveTarget(priority_target)
			return priority_target
	if(target_priority < 1) // No specific target to hunt
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/red_hood/GiveTarget(new_target)
	found_target = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/AttackingTarget(atom/attacked_target)
	if(special_attacking)
		return FALSE
	var/living = FALSE
	if(!istype(attacked_target, /mob/living))
		return ..()
	var/mob/living/attacked_mob = attacked_target
	kill_confirmed = FALSE
	if(attacked_mob.stat != DEAD)
		living = TRUE
	..()
	if(attacked_mob.stat == DEAD && living)
		living = FALSE
		kill_confirmed = TRUE

/mob/living/simple_animal/hostile/abnormality/red_hood/LoseTarget()
	..()
	found_target = FALSE
	if(!target_priority)
		return
	if((priority_target.stat == DEAD || !priority_target)) // Logic for when you lose an enemy due to their death
		if(target_priority == 3) // Killed buddy...
			target_priority = 0
			retarget_lockout = world.time + 10 SECONDS
			if(client)
				to_chat(src, "<span class='notice'>That... wasn't a wolf...</span>")
			else
				say("What... the hell...?")
			for(var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/fuck_you_blue in GLOB.mob_living_list)
				if(fuck_you_blue.client)
					to_chat(fuck_you_blue, "<span class='warning'>You feel like someone just walked over your grave.</span>")
				else
					fuck_you_blue.manual_emote("shudders and straightens up, suddenly seeming nervous.")
				if(fuck_you_blue.IsContained())
					fuck_you_blue.datum_reference.qliphoth_change(4) // Yeah, that's right, you'd BETTER stay locked up. Fucker.
				else
					target_priority = 1
					priority_target = fuck_you_blue
					RageUpdate(1)
			if(istype(priority_target, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
				if(client)
					to_chat(src, "<span class='notice'>You're going to KILL him. That blue bastard...</span>")
				else
					say("That fucker!")
			else
				RageUpdate(0)
				priority_target = null
				if(out_on_request)
					addtimer(CALLBACK(src, .proc/ReturnToCell), 10 SECONDS)
			return
		if(!out_on_request)
			return
		if(kill_confirmed) // If you were within visible range of your target when they died, we have to actually check whether you killed them
			if(client)
				to_chat(src, "<span class='notice'>You successfully killed your target! Returning to cell in 10 seconds.</span>")
				addtimer(CALLBACK(src, .proc/ReturnToCell), 10 SECONDS)
			else
				say("The hunt is over...")
				special_attacking = TRUE
				QDEL_IN(src, 30) // Being lazy with a player-uncontrolled Red Riding Hood
			return
		out_on_request = FALSE
		if(client)
			to_chat(src, "<span class='notice'>You were denied your kill! They should suffer for their idiocy...</span>")
		else
			say("You idiots...")
	else
		HunterTracking(priority_target) // We lost them, time to find them again

/mob/living/simple_animal/hostile/abnormality/red_hood/Move()
	if(special_attacking)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/attacked_by(obj/item/I, mob/living/user)
	if(LAZYLEN(patrol_path) && CanAttack(user)) // Basically, it will retaliate while patrolling without stopping or chasing after them
		user.attack_animal(src)
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/OpenFire()
	if(special_attacking || evading_attack)
		return FALSE
	if(client)
		switch(chosen_attack)
			if(1, 2)
				return FALSE // this should never be the case, 1 isn't an attack, but for safety...
			if(3)
				Hollowpoint(target)
			if(4)
				BladeThrow(target)
		return
	if(world.time > gun_timer && prob(85)) // She usually goes for the gun first
		Hollowpoint(target)
		return
	if(world.time > throw_timer && prob(45)) // Then if she doesn't, chance to use blades
		BladeThrow(target)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/ConfirmRangedKill(length)
	kill_confirmed = TRUE
	LoseTarget()
	addtimer(CALLBACK(src, .proc/EndRangedConfirm), length)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/EndRangedConfirm()
	kill_confirmed = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/ReturnToCell(turf/return_point)
	if(!return_point)
		return_point = get_turf(datum_reference.landmark)
	out_on_request = FALSE
	animate(src, alpha = 0, time = 10)
	addtimer(CALLBACK(src, .proc/FinishReturn, return_point), 10)

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/FinishReturn(turf/return_point)
	forceMove(return_point)
	health = maxHealth
	RageUpdate(0)
	priority_target = null
	target_priority = 0 // resetting these here too just in case
	dir = EAST
