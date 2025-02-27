#define JANGSAN_FEAR_COOLDOWN (8 SECONDS)

//Code by Coxswain, EGO sprites by Sky_ and abnormality sprites by Mel
/mob/living/simple_animal/hostile/abnormality/jangsan
	name = "Jangsan Tiger"
	desc = "A monster that eats children. Reforms its face for a friendly image"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "jangsan_idle"
	icon_living = "jangsan_idle"
	var/icon_aggro = "jangsan"
	portrait = "jangsan"
	speak_emote = list("growls")
	pixel_x = -16
	base_pixel_x = -16
	ranged = TRUE
	maxHealth = 1200
	health = 1200
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	see_in_dark = 10
	stat_attack = HARD_CRIT
	move_to_delay = 7
	threat_level = HE_LEVEL
	can_breach = TRUE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

//Only done to non-humans, objects, and strong(er) agents
	attack_sound = 'sound/abnormalities/jangsan/tigerbite.ogg'
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 40
	melee_damage_upper = 60

	ego_list = list(
		/datum/ego_datum/weapon/maneater,
		/datum/ego_datum/armor/maneater,
	)
	gift_type =  /datum/ego_gifts/maneater
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "I'm in a field of flowers, the flowers are my friends. <br>There are many kinds of friends but I wish to pluck them all. <br>\
		Some friends have thorns and hurt when I try to pick them. <br>Before me is a particularly juicy, thornless flower."
	observation_choices = list(
		"Smell it" = list(TRUE, "The flower shuffles away from me as I draw near, the scent is enticing but I do not pluck it. <br>\
			There's always time to stop and enjoy the flowers."),
		"Pluck the flower" = list(FALSE, "The flower lets out a scream as I pluck it with my teeth, its ichor stains my teeth and fur red - \
			the other thornless flowers scream in unison and flee in all directions whilst the thorniest ones scratch my fur and skin. <br>\
			Flowers are my friends and I shall pluck them all."),
	)

	var/bullet_threshold = 40
//breach related
	var/teleport_cooldown
	var/teleport_cooldown_time = 120 SECONDS
	var/strong_counter
	var/weak_counter
	pet_bonus = "meows" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)
//attack vars
	var/bite_cooldown
	var/bite_cooldown_time = 8 SECONDS
	var/chase_cooldown
	var/chase_cooldown_time = 8 SECONDS
	var/lure_cooldown
	var/lure_cooldown_time = 120 SECONDS

//speak_list + location + speak_list2
	var/list/speak_list = list(
		";Hey guys im at ",
		";Over here at ",
		";Im in ",
	)
	var/list/speak_list2 = list(
		", let's have a pizza party!",
		", i'll protect you!",
		", let's work together!",
	)

//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/cooldown/jangsan_fear)

/datum/action/cooldown/jangsan_fear
	name = "Fear"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "jangsan"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = JANGSAN_FEAR_COOLDOWN

/datum/action/cooldown/jangsan_fear/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/jangsan))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/jangsan/jangsan = owner
	if(jangsan.IsContained()) // No more using cooldowns while contained
		return FALSE
	StartCooldown()
	jangsan.TryFearStun()
	return TRUE

//Init
/mob/living/simple_animal/hostile/abnormality/jangsan/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(On_Mob_Death)) // Hell

/mob/living/simple_animal/hostile/abnormality/jangsan/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/jangsan/update_icon_state()
	if(status_flags & GODMODE)	// Not breaching
		icon_state = initial(icon)
	else
		icon_state = icon_aggro

/mob/living/simple_animal/hostile/abnormality/jangsan/Moved()
	. = ..()
	if(!(status_flags & GODMODE)) // Whitaker nerf
		playsound(get_turf(src), 'sound/abnormalities/bigbird/step.ogg', 50, 1)

//Responds better to work performed by weaker agents
/mob/living/simple_animal/hostile/abnormality/jangsan/WorkChance(mob/living/carbon/human/user, chance)
	var/chance_modifier = 1
	StatCheck(user)
	for(var/z in 0 to strong_counter)
		chance_modifier *= 0.85
	return chance * chance_modifier

/mob/living/simple_animal/hostile/abnormality/jangsan/proc/StatCheck(mob/living/carbon/human/user)
	strong_counter = 0 //Counts how many stats are at or above 60 AKA level 3 or higher
	weak_counter = 0 //Counts how many stats are below 40 AKA level 1
	if(SSmaptype.maptype == "rcorp") //Buff for Jangsan for the R-Corp mode
		for(var/attribute in stats)
			if(get_attribute_level(user, attribute)< 61)
				weak_counter += 1
			if(get_attribute_level(user, attribute)>= 60) //This doesnt matter for rca
				strong_counter += 1
		return
	else
		for(var/attribute in stats)
			if(get_attribute_level(user, attribute)< 40)
				weak_counter += 1
			if(get_attribute_level(user, attribute)>= 60)
				strong_counter += 1
		return

//Too weak and it kills you
/mob/living/simple_animal/hostile/abnormality/jangsan/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	KillCheck(user)
	if(user.stat == DEAD)
		datum_reference.qliphoth_change(-1)
		return

//Too strong and it fears you
	if(strong_counter > 0)
		datum_reference.qliphoth_change(strong_counter) //the stronger the better
		return

	else
		datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/jangsan/proc/On_Mob_Death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	if(died.z != z)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	return TRUE

//Pet it as a clerk, die.
/mob/living/simple_animal/hostile/abnormality/jangsan/funpet(mob/petter)
	KillCheck(petter)

//Breach
/mob/living/simple_animal/hostile/abnormality/jangsan/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(!datum_reference.abno_radio)
		AbnoRadio()
	if(breach_type != BREACH_MINING)
		addtimer(CALLBACK(src, PROC_REF(TryTeleport)), 5)

/mob/living/simple_animal/hostile/abnormality/jangsan/proc/TryTeleport() //stolen from knight of despair
	dir = 2
	if(teleport_cooldown > world.time)
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5) // TODO: Add some cool effects here
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)
	bite_cooldown = world.time + bite_cooldown_time //Don't kill someone the moment you teleport
	chase_cooldown = world.time + chase_cooldown_time
	Lure()

/mob/living/simple_animal/hostile/abnormality/jangsan/proc/Lure()
	var/myarea
	if(lure_cooldown > world.time)
		return
	lure_cooldown = world.time + lure_cooldown_time
	var/list/Players = list()
	for (var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(H.stat == DEAD) // No dead people
			continue
		Players += H

	if(!Players.len)
		name = pick(
			"Unassuming Friendly Guy",
			"Zeta 123",
			"Bong Bong",
			"John Lobotomy",
		)
	else
		var/Sucker = pick(Players)
		name = "[Sucker]"
	playsound(get_turf(src), 'sound/abnormalities/scaredycat/catgrunt.ogg', 50, 1, 2)
	if (isturf(loc))
		myarea = get_area(src)
	say(pick(speak_list) + "[myarea]" + pick(speak_list2))
	name = "Jangsan Tiger"

//Combat
/mob/living/simple_animal/hostile/abnormality/jangsan/CanAttack(atom/the_target)
	if(!ishuman(the_target))
		return ..()

	var/mob/living/carbon/human/H = the_target
	var/obj/item/bodypart/head/head = H.get_bodypart("head")
	if(!istype(head)) // You, I'm afraid, are headless
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/jangsan/AttackingTarget(atom/attacked_target)
	if(bite_cooldown < world.time)
		KillCheck(attacked_target)
	icon_state = icon_aggro
	return ..()

/mob/living/simple_animal/hostile/abnormality/jangsan/proc/KillCheck(mob/living/target)
	if(!ishuman(target))
		return
	if(target.status_flags & GODMODE)
		return
	var/mob/living/carbon/human/H = target
	StatCheck(H)
	if(weak_counter >= 4)
		var/obj/item/bodypart/head/head = H.get_bodypart("head")
		if(QDELETED(head))
			return
		head.dismember()
		QDEL_NULL(head)
		H.regenerate_icons()
		visible_message(span_danger("\The [src] bites [H]'s head off!"))
		new /obj/effect/gibspawner/generic/silent(get_turf(H))
		new /obj/effect/halo(get_turf(H))
		playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
		return

/mob/living/simple_animal/hostile/abnormality/jangsan/proc/FearStun(mob/living/carbon/human/H)
	H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
	H.adjustSanityLoss(-50)
	H.Stun(5 SECONDS)
	to_chat(target, span_warning("Is that what it really looks like? It's over... I can’t even move my legs..."))
	return

/mob/living/simple_animal/hostile/abnormality/jangsan/proc/TryFearStun()
	playsound(get_turf(src), 'sound/abnormalities/scaredycat/catgrunt.ogg', 50, 1, 2)
	for(var/mob/living/carbon/human/H in view(3, src))
		StatCheck(H)
		if(faction_check_mob(H, FALSE))
			continue
		if(H.stat == DEAD)
			continue
		if(weak_counter >= 4)
			icon_state = "jangsan_bite"
			FearStun(H)
			chase_cooldown = world.time + chase_cooldown_time
			break

//targetting
/mob/living/simple_animal/hostile/abnormality/jangsan/PickTarget(list/Targets) //Stolen from MOSB
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			StatCheck(L)
			if(weak_counter >= 4)
				highest_priority += L
			else
				lower_priority += L
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/abnormality/jangsan/MoveToTarget(list/possible_targets)
	if(ishuman(target))
		if(chase_cooldown > world.time)
			return ..()
		var/mob/living/carbon/human/H = target
		StatCheck(H)
		if(weak_counter >= 4 && get_dist(src, target) < 4) //clerk got too close time to die
			icon_state = "jangsan_bite"
			FearStun(target)
			chase_cooldown = world.time + chase_cooldown_time
			return ..()
	icon_state = icon_aggro
	return ..()

/mob/living/simple_animal/hostile/abnormality/jangsan/bullet_act(obj/projectile/P)
	if(P.damage <= bullet_threshold)
		visible_message(span_userdanger("[P] is caught in [src]'s thick fur!"))
		P.Destroy()
		return
	return ..()

//on-kill effect
/obj/effect/halo
	name = "halo"
	desc = "Poor guy."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "jangsan_kill"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER	//High enough that you can see it if you look up.

/obj/effect/halo/Initialize()
	. = ..()
	animate(src, pixel_x = 0, pixel_z = 16, time = 3 SECONDS)
	QDEL_IN(src, 30 SECONDS)

#undef JANGSAN_FEAR_COOLDOWN
