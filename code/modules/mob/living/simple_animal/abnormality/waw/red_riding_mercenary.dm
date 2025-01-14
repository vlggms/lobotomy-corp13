/*
Little Red Riding Hooded Mercenary, coded by Nutterbutter as part of May 2023's Abno Jam
The fucker has arrived.

It has now been over four months. Now we get her for real. -Coxswain
*/

/mob/living/simple_animal/hostile/abnormality/red_hood
	name = "Little Red Riding Hooded Mercenary"
	desc = "A tall humanoid in ragged red robes."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "red_hood"
	icon_living = "red_hood"
	portrait = "little_red"
	attack_sound = 'sound/abnormalities/redhood/attack_1.ogg'
	del_on_death = TRUE
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 2400 // More health than standard
	health = 2400 // Since she was apparently too easy to suppress
	rapid_melee = 2
	speed = 0.5
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 45, 45, 50),
		ABNORMALITY_WORK_INSIGHT = list(45, 50, 50, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 30,
		"Request" = 100
		)
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5) // Fuck you, blue shepherd.
	ranged = TRUE
	melee_damage_lower = 30
	melee_damage_upper = 45
	attack_action_types = list(/datum/action/innate/abnormality_attack/find_target, /datum/action/innate/abnormality_attack/catch_breath, /datum/action/innate/abnormality_attack/hollowpoint_shell, /datum/action/innate/abnormality_attack/strike_without_hesitation)
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	patrol_cooldown_time = 10 SECONDS // She's restless
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cuts"
	faction = list("redhood") // I'LL FUCKIN FIGHT YOU TOO, MATE
	can_breach = TRUE
	start_qliphoth = 3
	density = FALSE // Prevents red from getting stuck unable to reach her target
	status_flags = MUST_HIT_PROJECTILE // Allows projectiles to hit even though she's not dense.
	ego_list = list(
		/datum/ego_datum/weapon/crimson,
		/datum/ego_datum/weapon/crimson/gun,
		/datum/ego_datum/armor/crimson
		)
	gift_type = /datum/ego_gifts/crimson
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "(The chamber is empty, except the Little Red Riding Hooded Mercenary, and her axe and gun. She seems exhausted) <br>\
		Am I really alive? <br>What if I'm a ghost that doesn't even know it's dead? <br>\
		The only thing I love in my life is the death of the wolf."
	observation_choices = list(
		"Mourn for her memories" = list(TRUE, "I will swing my axe again tomorrow, still driven by hatred like I have been forever. <br>\
			But tonight, I think I can sleep peacefully."),
		"Exit the room" = list(FALSE, "Knock on my door whenever you need my service. <br>\
			This is my struggle."),
	)

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
	var/mob/living/priority_target // Stores current request target.
	var/fuzzy_tracking_cooldown = 10 SECONDS // How often red re-checks the closest landmark to the target.
	var/list/tiered_request_costs = list(
		ZAYIN_LEVEL = 100,
		TETH_LEVEL = 200,
		HE_LEVEL = 300,
		WAW_LEVEL = 400,
		ALEPH_LEVEL = 500
	) // PE cost to hunt abnos, one per tier.
	var/default_request_cost = 100 // PE cost to hunt anything not considered an abno, like an ordeal. Scales up with ordeals.
	var/out_on_request = FALSE // Is she hunting something on request, or...?
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
	var/leaving = FALSE

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
	chosen_message = span_danger("You try to suss out where your target is...")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/find_target/Activate()
	addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality/red_hood, PlayerTargetFind)), 1)
	to_chat(A, chosen_message)

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/PlayerTargetFind()
	HunterTracking(priority_target) // basically a redirect, ability code is weird

/datum/action/innate/abnormality_attack/catch_breath // AI-controlled Red technically doesn't use this one EITHER.
	name = "Evade"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "ruina_evade"
	chosen_message = span_danger("You prepare to avoid an incoming attack.")
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/catch_breath/Activate()
	addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality/red_hood, AttemptEvade)), 1)
	to_chat(A, chosen_message)

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/HunterTracking(mob/living/hunted_target, turf/last_closest, attempts = 3)
	if(!client || !hunted_target || !hunted_target.stat)
		to_chat(src, span_notice("You don't have a target..."))
		if(out_on_request && red_rage < 3)
			ContractComplete()
		return
	if(hunt_track_timer > world.time)
		to_chat(src, span_notice("You need another moment..."))
		return
	to_chat(src, span_notice("You can sense where [hunted_target] is."))
	hunt_track_timer = world.time + hunt_track_cooldown
	var/turf/start_turf = get_turf(src)
	var/turf/last_turf = get_ranged_target_turf_direct(start_turf, hunted_target, 5)
	var/list/navline = getline(start_turf, last_turf)
	for(var/turf/T in navline)
		new /obj/effect/temp_visual/cult/turf/floor(T)
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/AttemptEvade()
	if((world.time < evade_timer) || evading_attack)
		if(client)
			to_chat(src, span_danger(" You can't do that now!"))
		return FALSE
	evading_attack = TRUE
	addtimer(CALLBACK(src, PROC_REF(EndEvade)), 20)
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
	if(red_rage >= 3) //Never back down after enraging
		return
	if(rage_change)
		red_rage = rage_change
	if(red_rage > 0) //Normal rage
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
		if(red_rage == 3)
			ChangeResistances(list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1.5)) // She takes... very little damage.
		return

	ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5)) // She takes normal damage now
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
		visible_message(span_notice("[src] seems out of breath!"), span_warning("You didn't dodge anything!"))
		evade_timer = world.time + evade_cooldown * 2
		return
	SpinAnimation(7, 1)
	visible_message(span_notice("[src] evades the attack!"), span_nicegreen("You evade the attack!"))
	adjustBruteLoss(-50) // Recover a little HP for your dodge
	evade_timer = world.time + evade_cooldown
	return

/datum/action/innate/abnormality_attack/hollowpoint_shell
	name = "Hollowpoint Shell"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "hollowpoint_ability"
	chosen_message = span_danger("You will now fire at whatever you next click on.")
	chosen_attack_num = 3

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/Hollowpoint(atom/target) // Fire a round in the direction of the enemy. When enraged, shoot multiple times.
	if(world.time < gun_timer)
		if(client)
			to_chat(src, span_danger("You can't do that now!"))
		return FALSE
	special_attacking = TRUE
	gun_timer = world.time + gun_cooldown
	addtimer(CALLBACK(src, PROC_REF(SpecialReset)), 10 + bullet_additional * gun_multishot_pause)
	manual_emote("raises her gun.")
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "redhood_shoot"
	icon_living = "redhood_shoot"
	pixel_x = -32
	base_pixel_x = -32
	addtimer(CALLBACK(src, PROC_REF(HunterBullet), target, bullet_additional), special_windup * 0.75)
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
		addtimer(CALLBACK(src, PROC_REF(HunterBullet), target, shots_remaining - 1), gun_multishot_pause)
	return

/datum/action/innate/abnormality_attack/strike_without_hesitation
	name = "Blade Throw"
	icon_icon = 'icons/obj/projectiles.dmi'
	button_icon_state = "hunter_blade"
	chosen_message = span_danger("You will throw a spread of blades at whatever you next click on.")
	chosen_attack_num = 4

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/BladeThrow(atom/target) // Throw a barrage of piercing blades in the direction of the enemy.
	if(throw_timer > world.time)
		if(client)
			to_chat(src, span_danger("You can't do that now!"))
		return FALSE
	special_attacking = TRUE
	addtimer(CALLBACK(src, PROC_REF(SpecialReset)), 15)
	throw_timer = world.time + throw_cooldown
	say(pick(weapon_throw_lines))
	addtimer(CALLBACK(src, PROC_REF(GetThrown), target), special_windup)
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
	. = ..()
	if(IsCombatMap())
		faction |= "hostile"
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/mob/living/simple_animal/hostile/abnormality/red_hood/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type != "Request")
		return ..()
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
			to_chat(user, span_notice("There's nothing for [src] to hunt."))
		else
			say("Nothing to hunt right now...")
		return FALSE

	var/mob/living/simple_animal/hunted = input(user, "What's the target?", "Select hunt target", null) as null|anything in sortNames(huntable)
	if(!hunted)
		if(client)
			to_chat(user, span_notice("You decided not to make a request after all."))
		else
			say("Changed your mind? Tch. Call me when you need me.")
		return FALSE

	priority_target = hunted
	out_on_request = TRUE
	fear_level = TETH_LEVEL
	var/current_cost = default_request_cost //We start out at 100 and then start adding additional fees

	if(istype(hunted, /mob/living/simple_animal/hostile/abnormality)) //If its an abnormality we add 100 PE for every risk level
		var/mob/living/simple_animal/hostile/abnormality/abno = hunted
		current_cost = tiered_request_costs[abno.threat_level]
	else //If its not an abnormality we just grab the current ordeal level and use that as a cost. Red costs more to use later in the round. We can change this if one day every simple mob gets a risk level.
		if(SSlobotomy_corp.next_ordeal_level > 2) //next_ordeal_level is 2 at roundstart
			current_cost = (clamp(100 + 100 * (SSlobotomy_corp.next_ordeal_level - 2), 100, 500)) //The math is weird on this - next_ordeal_level is the ordeal AFTER the one about to spawn, so 2 higher.

	if(SSlobotomy_corp.available_box < current_cost)
		if(client)
			to_chat(user, span_notice("Not enough personal PE to make a request."))
		else
			say("Tch. You can't afford my services.")
		return FALSE
	SSlobotomy_corp.available_box -= current_cost //Subtract the total from station PE

	if(client)
		to_chat(src, span_notice("You've been contracted to hunt [priority_target.name]."))
	else
		if(istype(priority_target, /mob/living/simple_animal/hostile/abnormality/big_wolf))
			manual_emote("'s grip on her weapon tightens.")
			SLEEP_CHECK_DEATH(10)
			say("Is he really here? You don't know how long I have been waiting for this.")
			SLEEP_CHECK_DEATH(20)
			say("Leave me to handle that dreadful, cunning bastard.")
			SLEEP_CHECK_DEATH(20)
			say("I'll hang his head over my bed.")
			SLEEP_CHECK_DEATH(20)
			say("Only then can I get up in the morning without having a nightmare.")
			SLEEP_CHECK_DEATH(20)
			target_priority = 4
			BreachEffect()
			RageUpdate(2) //She enrages instantly to go wolf hunting
			return
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
			manual_emote(" shrugs.")
			SLEEP_CHECK_DEATH(10)
			say("Alright, looks like you're good for it.")
			SLEEP_CHECK_DEATH(40)
			manual_emote("chuckles.")
			SLEEP_CHECK_DEATH(6)
			say("A deal's a deal.")
			SLEEP_CHECK_DEATH(34)
			target_priority = 2
			BreachEffect()

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER

	if(!IsContained())
		return
	if(istype(abno, /mob/living/simple_animal/hostile/abnormality/punishing_bird))
		if(client)
			to_chat(src, span_notice("You hear an annoying fluttering, and immediately disregard it."))
		else
			manual_emote("perks up for a moment, then settles back down, looking annoyed.")
		return
	if(istype(abno, /mob/living/simple_animal/hostile/abnormality/training_rabbit))
		return
	if(datum_reference.qliphoth_meter > 1)
		if(client)
			to_chat(src, span_notice("You hear something..."))
		else
			manual_emote("perks up slightly, as though she hears something.")
	datum_reference.qliphoth_change(-1) // This is literally the only way her counter goes down.

/mob/living/simple_animal/hostile/abnormality/red_hood/BreachEffect(mob/living/carbon/human/user)
	..()
	if(target_priority)
		if(client)
			to_chat(src, span_notice("You have a target to hunt."))
		else
			manual_emote("adopts a fighting stance, eye gleaming with intent.")
	else
		if(client)
			to_chat(src, span_warning("You've gotta get out of here!"))
		else
			manual_emote("grips her weapons, looking around wildly.")

/mob/living/simple_animal/hostile/abnormality/red_hood/FindTarget(list/possible_targets, HasTargetsList = 0) //How we aggro the wolf if there is one
	. = list()
	if(!HasTargetsList)
		possible_targets = ListTargets()
	// These are our priority targets. If any are within our actual targets list, we pick the highest priority one, update our priority level if necessary, and attack it.
	var/mob/living/simple_animal/hostile/abnormality/red_buddy/found_buddy = locate() in possible_targets
	var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/found_blue = locate() in possible_targets
	var/mob/living/simple_animal/hostile/abnormality/big_wolf/found_wolf = locate() in possible_targets
	if(found_wolf) //Top priority at all times
		UpdatePriority(4, found_wolf)
		RageUpdate(2) //She enrages instantly to go wolf hunting
	if(found_buddy && target_priority < 4)
		UpdatePriority(3, found_buddy)
	if(found_blue && target_priority < 2)
		GiveTarget(found_blue)
		UpdatePriority(1, found_blue)
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/ValueTarget(atom/target_thing) //Naturally value priority targets over others
	..()
	if(target_thing == priority_target)
		. += 60

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/UpdatePriority(target_id = 0, mob/living/new_priority)
	if(target_id > target_priority)
		if(client)
			to_chat(src, span_notice("You've found a higher priority target! Go after [new_priority]!"))
		priority_target = new_priority
		target_priority = target_id
	return

/mob/living/simple_animal/hostile/abnormality/red_hood/Move()
	if(special_attacking)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/attacked_by(obj/item/I, mob/living/user)
	if(LAZYLEN(patrol_path) && out_on_request ) // Basically, it will retaliate while patrolling without stopping or chasing after them
		say(pick(blue_evade_lines))
		user.attack_animal(src)
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/OpenFire()
	if(!CanAttack(target)) //Openfire doesn't actually check for this normally
		return FALSE
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

/mob/living/simple_animal/hostile/abnormality/red_hood/CanAttack(atom/the_target)
	if(out_on_request && red_rage < 3) //On patrol and not indiscriminately raging
		if(ishuman(the_target)) //We don't attack the people who hired us, duh.
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!out_on_request && target_priority != 4) //Didn't get hired and not fighting the wolf
		return
	if(!priority_target) //For some reason we never got one
		ContractComplete()
		return
	if(QDELETED(priority_target) || priority_target.stat == DEAD || priority_target.z != z) //Target is dead or vanished or off-z
		ContractComplete()
		return

/mob/living/simple_animal/hostile/abnormality/red_hood/patrol_select() //Path right to our target
	if(out_on_request || priority_target)
		if(!priority_target) //For some reason we never got one
			return ..()
		SEND_SIGNAL(src, COMSIG_PATROL_START, src, get_turf(priority_target))
		SEND_GLOBAL_SIGNAL(src, COMSIG_GLOB_PATROL_START, src, get_turf(priority_target))
		patrol_path = get_path_to(src, get_turf(priority_target), TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_hood/proc/ContractComplete()
	if(leaving)
		return
	leaving = TRUE
	if(target_priority == 4)
		var/kill_confirmed = FALSE
		for(var/mob/living/simple_animal/hostile/abnormality/big_wolf/the_target in view(src, 10))
			if(the_target.stat != DEAD)
				return
			kill_confirmed = TRUE //Wolf died in our view
		if(!kill_confirmed) //Somehow we completed the contract but the wolf was too far away. Likely died off-screen
			say(pick(denied_kill_lines))
			RageUpdate(3)
			fear_level = WAW_LEVEL
			return
	if(target_priority < 4)
		say("Work's done. Time to go home.")
	else
		say("Finally, the nightmare is over...")
		for(var/mob/living/carbon/human/survivor in urange(10, src))
			if(survivor.stat == DEAD || !survivor.ckey)
				continue
			survivor.Apply_Gift(new /datum/ego_gifts/sheep)
			survivor.playsound_local(get_turf(survivor), 'sound/weapons/black_silence/snap.ogg', 50)
			to_chat(survivor, span_userdanger("The hooded mercenary thanks you - you recieve a gift!"))
	ChangeResistances(list(BRUIT = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	AIStatus = AI_OFF
	animate(src, alpha = 0, time = 10)
	QDEL_IN(src,10)
