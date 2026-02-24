//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/falada
	name = "Spirit of Falada"
	desc = "A horse's severed head."
	pixel_y = 64
	base_pixel_y = 64
	density = FALSE
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "falada"
	icon_living = "falada"
	portrait = "falada"
	faction = list("neutral")
	speak_emote = list("neighs")
	threat_level = TETH_LEVEL
	maxHealth = 55
	health = 55
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2) //goose stats
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 30,
	)
	work_damage_upper = 3
	work_damage_lower = 2
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride

	ego_list = list(
		/datum/ego_datum/weapon/zauberhorn,
		/datum/ego_datum/armor/zauberhorn,
	)
	gift_type =  /datum/ego_gifts/zauberhorn

	observation_prompt = "A severed horse-like creature's head hangs high on the wall, sobbing. <br>\
		You can't help but feel some pity for the thing."
	observation_choices = list(
		"What happened to you?" = list(TRUE, "The horse head begins speaking. <br>\
			\"Oh, woe is me. If only it could be - the powers that be, would see fit to have me die in her stead.\" <br>\
			It speaks in rhymes, but it clearly lost someone important to it. <br>\
			Even if there is nothing you can do, at least you are there to listen."),
		"Why the long face?" = list(FALSE, "The horse head continues sobbing, despite your cheesy joke. <br>Maybe that wasn't the best approach."),
	)

	var/liked
	var/happy = TRUE
	pet_bonus = "neighs" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/hint_cooldown
	var/hint_cooldown_time = 30 SECONDS
	var/list/cooldown = list("It is not the time now, not yet.")

	var/list/instinct = list("I should have trusted my instincts, I should have stopped that vile maidservant before it was too late. Look at what happened to me!")

	var/list/insight = list("The late princess was a woman of incredible insight, it may do you well to do the same.")

	var/list/attachment = list("Poor Anidori, her attachment to that woman was too great. She could not see the jealousy harbored within her.")

	var/list/repression = list("The things that they did to me, the things they did to her, all for the want of justice in the world.")

// Work Mechanics
/mob/living/simple_animal/hostile/abnormality/falada/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/falada/ZeroQliphoth(mob/living/carbon/human/user)
	pissed()
	if(user)
		say("O, Anidori, if only your mother knew the fate to befall you, how her heart would break in two.")
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/falada/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		pissed()
		qdel(src)

/mob/living/simple_animal/hostile/abnormality/falada/WorkChance(mob/living/carbon/human/user, chance)
	if(happy)
		chance+=30
	return chance

/mob/living/simple_animal/hostile/abnormality/falada/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == liked || !liked)
		happy = TRUE
	else
		happy = FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/falada/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	liked = pick(
		ABNORMALITY_WORK_INSTINCT,
		ABNORMALITY_WORK_INSIGHT,
		ABNORMALITY_WORK_ATTACHMENT,
		ABNORMALITY_WORK_REPRESSION,
	)
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))
		if(ABNORMALITY_WORK_REPRESSION)
			say(pick(repression))

// Breach
/mob/living/simple_animal/hostile/abnormality/falada/proc/pissed()
	var/turf/W = pick(GLOB.department_centers)
	for(var/turf/T in orange(1, W))
		new /obj/effect/temp_visual/dir_setting/cult/phase
		new /mob/living/simple_animal/hostile/aminion/falada_goose(T)

// Repeat lines
/mob/living/simple_animal/hostile/abnormality/falada/funpet()
	if(!liked)
		return
	if(hint_cooldown > world.time)
		say(pick(cooldown))
		return
	hint_cooldown = world.time + hint_cooldown_time
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))
		if(ABNORMALITY_WORK_REPRESSION)
			say(pick(attachment))
	return

// Spawned Mob
//It pastes a lot of code from retaliate and goose due to how aminions work - Crabby
/mob/living/simple_animal/hostile/aminion/falada_goose
	maxHealth = 35
	health = 35
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	faction = list("goose") //geese are demons
	name = "goose"
	desc = "It's loose"
	icon_state = "goose" // sprites by cogwerks from goonstation, used with permission
	icon_living = "goose"
	icon_dead = "goose_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/food/meat/slab = 2)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	emote_taunt = list("hisses")
	taunt_chance = 30
	attack_same = FALSE
	melee_damage_lower = 1
	melee_damage_upper = 3
	can_patrol = TRUE
	var/list/enemies = list()
	attack_verb_continuous = "pecks"
	attack_verb_simple = "peck"
	attack_sound = "goose"
	attack_same = TRUE
	gold_core_spawnable = HOSTILE_SPAWN
	var/random_retaliate = TRUE
	var/icon_vomit_start = "vomit_start"
	var/icon_vomit = "vomit"
	var/icon_vomit_end = "vomit_end"
	var/message_cooldown = 0
	var/list/nummies = list()
	var/choking = FALSE
	move_resist = MOVE_RESIST_DEFAULT
	pull_force = PULL_FORCE_DEFAULT
	fear_level = 0
	score_divider = 9
	threat_level = TETH_LEVEL

/mob/living/simple_animal/hostile/aminion/falada_goose/falada/handle_automated_action()
	if(AIStatus == AI_OFF)
		return FALSE
	var/list/possible_targets = ListTargets() //we look around for potential targets and make it a list for later use.
	if(environment_smash)
		EscapeConfinement()
	if(AICanContinue(possible_targets))
		if(!QDELETED(target) && !targets_from.Adjacent(target))
			DestroyPathToTarget()
		if(!MoveToTarget(possible_targets))     //if we lose our target
			if(AIShouldSleep(possible_targets))	// we try to acquire a new one
				toggle_ai(AI_IDLE)			// otherwise we go idle
	return 1

/mob/living/simple_animal/hostile/retaliate/falada_goose/falada/Found(atom/A)//This is here as a potential override to pick a specific target if available
	return

/mob/living/simple_animal/hostile/aminion/falada_goose/ListTargets()
	if(!enemies.len)
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/aminion/falada_goose/proc/Retaliate()
	var/list/around = view(src, vision_range)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(faction_check_mob(M) && attack_same || !faction_check_mob(M))
				enemies |= M
		else if(ismecha(A))
			var/obj/vehicle/sealed/mecha/M = A
			if(LAZYLEN(M.occupants))
				enemies |= M
				enemies |= M.occupants

	for(var/mob/living/simple_animal/hostile/aminion/falada_goose/H in around)
		if(faction_check_mob(H) && !attack_same && !H.attack_same)
			H.enemies |= enemies

/mob/living/simple_animal/hostile/aminion/falada_goose/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS)
		Retaliate()

/mob/living/simple_animal/hostile/aminion/falada_goose/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(goosement))

/mob/living/simple_animal/hostile/aminion/falada_goose/proc/goosement(atom/movable/AM, OldLoc, Dir, Forced)
	if(stat == DEAD)
		return
	nummies.Cut()
	nummies += loc.contents
	if(prob(5) && random_retaliate)
		Retaliate()

/mob/living/simple_animal/hostile/aminion/falada_goose/handle_automated_action()
	if(length(nummies))
		var/obj/item/E = locate() in nummies
		if(E && E.loc == loc)
			feed(E)
		nummies -= E

/mob/living/simple_animal/hostile/aminion/falada_goose/proc/feed(obj/item/suffocator)
	if(stat == DEAD || choking) // plapatin I swear to god
		return FALSE
	if(suffocator.has_material_type(/datum/material/plastic)) // dumb goose'll swallow food or drink with plastic in it
		visible_message(span_danger("[src] hungrily gobbles up \the [suffocator]! "))
		visible_message(span_boldwarning("[src] is choking on \the [suffocator]! "))
		suffocator.forceMove(src)
		choke(suffocator)
		choking = TRUE
		return TRUE

/mob/living/simple_animal/hostile/aminion/falada_goose/attackby(obj/item/O, mob/user)
	. = ..()
	if(feed(O))
		return TRUE

/mob/living/simple_animal/hostile/aminion/falada_goose/proc/choke(obj/item/reagent_containers/food/plastic)
	if(stat == DEAD || choking)
		return
	addtimer(CALLBACK(src, PROC_REF(suffocate)), 300)

/mob/living/simple_animal/hostile/aminion/falada_goose/proc/suffocate()
	if(!choking)
		return
	death_message = "lets out one final oxygen-deprived honk before [p_they()] go[p_es()] limp and lifeless.."
	death()
