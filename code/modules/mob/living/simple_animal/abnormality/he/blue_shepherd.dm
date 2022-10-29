//Oh boy, here I go doing a complex abnormality after staying up for too long!
//He's kinda strong for a HE, has to take out other HEs.
//His lore is that he's strong to Red buddy (who does red damage) but the trick is that they don't actually fight ;)
//He just uses Red buddy as a means to escape but in reality he loves the little guy for it.
//-Kirie Saito
/mob/living/simple_animal/hostile/abnormality/blue_shepherd
	name = "Blue Smocked Shepherd"
	desc = "A strange humanoid in blue robes."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "blueshep"
	icon_living = "blueshep"
	icon_dead = "blueshep_dead"
	del_on_death = FALSE
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 1200
	health = 1200
	rapid_melee = 2
	move_force = MOVE_FORCE_NORMAL + 1 //I couldn't make it the same as the normal move_force_strong without shepherd pushing tables which looked weird
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 30,
		"Release" = 100
		)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 22
	melee_damage_upper = 30
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cuts"
	faction = list("blueshep")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 4

	ego_list = list(
		/datum/ego_datum/weapon/oppression,
		/datum/ego_datum/armor/oppression
		)
	gift_type = /datum/ego_gifts/oppression

	var/death_counter //He won't go off a timer, he'll go off deaths. Takes 8 for him.
	var/slash_current = 4
	var/slash_cooldown = 4
	var/slash_damage = 40
	var/slashing = FALSE
	var/range = 2
	var/hired = FALSE
	var/lie_chance = 30 // % chance to lie
	var/datum/abnormality/buddy //the red buddy linked to this shepherd
	var/mob/living/simple_animal/hostile/abnormality/red_buddy/awakened_buddy //the red buddy shepherd is currently fighting with
	var/awakened = FALSE //if shepherd has seen red buddy or not
	var/list/people_list = list() //list of people shepperd can mention
	//lines said during combat
	var/list/combat_lines = list(
				"Have at you!",
				"Take this!",
				"I'll kill you!",
				"This is for locking me up!",
				"Die!"
				)
	//lines shepperd say when someone's dead
	var/list/people_dead_lines = list(
				" didn't last long huh?",
				" died, if only I was here to help...",
				"'s dead? what a shame, I kinda liked them.",
				)
	//lines shepperd say when someone is still alive
	var/list/people_alive_lines = list(
				" is still alive somehow, won't last long though.",
				" is doing much better than you, but I can take care of them if you want.",
				"'s abilities are quite phenomenal, and yet I'm stuck with you, tch.",
				"'s would have released me by now, why can't you do the same?",
				)
	//lines shepperd say when something has breached
	var/list/abno_breach_lines = list(
				" has breached, I could help you know?",
				" is out, are you sure you're strong enough to take care of it by yourself?",
				" is going on a rampage, you guys really can't do your job right huh?",
				" has breached and you're still wasting your time on me? I'm flattered.",
				)
	//lines shepperd say when an abno hasn't breached (yet)
	var/list/abno_safe_lines = list(
				" is still stuck in their cell like me, but freedom isn't something you can just take away so easily.",
				" hasn't breached yet, but I wouldn't count on it staying that way.",
				" hasn't escaped despite your terrible work ethic, I won't be as easy to handle.",
				"'s doing fine, don't you have a manager to check those things for you?",
				)
	//lines shepherd say about red buddy
	var/list/red_buddy_lines = list(
				"The wolf is coming down the hill...",
				"You'd think I lie when I foretell a wolf showing up and tearing this basement up too? ",
				"You know what? about that thing connected to me. It has no life, lifeless things always wait.",
				"That red thing? they miss the love, the cuddles, the happiness of that moment dearly.",
				"And when that 'buddy' fully realises the situation it's in, it becomes a wolf. That's when it can get my attention and care, what a dummy."
				)


/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/OnMobDeath) // Alright, here we go again
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, .proc/OnNewCrew)
	//makes a list of people and abno to shit talk
	if(LAZYLEN(GLOB.mob_living_list))
		for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
			if(H.stat != DEAD)
				people_list += H
	//check if red buddy is in the facility
	if(LAZYLEN(SSlobotomy_corp.all_abnormality_datums))
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			if(ispath(A.abno_path, /mob/living/simple_animal/hostile/abnormality/red_buddy))
				buddy = A
				return
	if(!buddy)
		RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN, .proc/OnAbnoSpawn) //if red buddy isn't in the facility, we wait for him

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN)
	LAZYCLEARLIST(people_list)
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/work_chance(mob/living/carbon/human/user, chance)
	var/mob/living/simple_animal/hostile/abnormality/red_buddy/buddy_abno = buddy?.current
	if(buddy_abno)
		chance += (buddy_abno.suffering * 0.5) //the more red buddy suffers, the higher your work chance on shepherd is
	return chance

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	var/mob/living/simple_animal/hostile/abnormality/red_buddy/buddy_abno = buddy?.current
	if(buddy_abno?.suffering >= 40)
		user.Apply_Gift(new gift_type) //you get a free gift if you somehow made the dog suffer that much
		datum_reference.qliphoth_change(-1)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(1)
	else if(work_type == "Release")
		hired = TRUE
		say("Finally, it was getting stuffy in there!")
		datum_reference.qliphoth_change(-4)
	else
		datum_reference.qliphoth_change(-1)
		SLEEP_CHECK_DEATH(10)
	if(status_flags & GODMODE)
		var/lie //if shepperd's lying or not
		if(prob(lie_chance))
			lie = TRUE
			if(buddy_abno)
				buddy_abno.lying_timer = addtimer(CALLBACK(buddy_abno, /mob/living/simple_animal/hostile/abnormality/red_buddy/proc/ShepherdLying), 90 SECONDS)
				buddy_abno.lying = TRUE
		else
			lie = FALSE
		if(lie && buddy.current && prob(25)) //pretty unlikely to mention red buddy overall, but it's a very easy to spot "lie"
			say(pick(red_buddy_lines))
			return ..()
		var/list/abno_list = AbnoListGen()
		if(prob(50) && LAZYLEN(abno_list)) //decide which subject to pick
			var/datum/abnormality/abno_datum = pick(abno_list)
			var/mob/living/simple_animal/hostile/abnormality/abno = abno_datum.current
			if((!(abno.status_flags & GODMODE) && !lie) || ((abno.status_flags & GODMODE) && lie))
				say(abno.name + pick(abno_breach_lines))
			else
				say(abno.name + pick(abno_safe_lines))
		else if(LAZYLEN(people_list))
			var/mob/living/carbon/human/subject = pick(people_list)
			if(isnull(subject))
				people_list -= subject
			else if(subject == user)
				say("It's only a matter of time until I get out, but you could have me as a friend rather than foe.")
			else if((subject.stat == DEAD && !lie) || (subject.stat != DEAD && lie))
				say(subject.name + pick(people_dead_lines))
			else
				say(subject.name + pick(people_alive_lines))
		else
			say("Trust me, you gotta let me out of here!") //if he has somehow nothing to lie about
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/breach_effect(mob/living/carbon/human/user)
	var/sighted = FALSE
	for(var/mob/living/carbon/human/L in view(4, src))
		sighted = TRUE
		break

	if(sighted && hired == FALSE)
		say("I've had it with you!")
	else
		var/turf/T = pick(GLOB.xeno_spawn)
		forceMove(T)
		hired = FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/AttackingTarget()
	slash_current-=1
	if(slash_current == 0)
		slash_current = slash_cooldown
		say(pick(combat_lines))
		SLEEP_CHECK_DEATH(10)
		slashing = TRUE
		slash()
	..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/death(gibbed)
	if(awakened_buddy)
		awakened_buddy.death()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Life()
	..()
	if(status_flags & GODMODE)
		return
	var/mob/living/buddy_abno = buddy?.current
	if(!isnull(buddy_abno) && !awakened && can_see(src, buddy_abno, 10))
		awakened_buddy = buddy_abno
		awakened = TRUE //ho god ho fuck
		slash_cooldown = 2
		slash_damage = 50
		melee_damage_lower = 30
		melee_damage_upper = 40
		move_to_delay = 2
		damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
		adjustHealth(-maxHealth)

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Move()
	if(!isnull(awakened_buddy) && pulling != awakened_buddy)
		var/turf/orgin = get_turf(src)
		var/list/all_turfs = RANGE_TURFS(1, orgin)
		var/turf/open/Y = pick(all_turfs - orgin)
		awakened_buddy.forceMove(Y) //the lazy solution that forces buddy to get pulled by shepherd, ideally this should only happen once.
		src.start_pulling(awakened_buddy)
	if(slashing)
		return FALSE
	if(awakened_buddy)
		awakened_buddy.AIStatus = AI_OFF //we stop buddy from moving while being dragged to avoid jank, player controlled buddy will probably fuck this up but eeeh
	. = ..()
	if(awakened_buddy)
		awakened_buddy.AIStatus = AI_ON //turning the AI status on and off isn't performance consuming as far as I can tell from mob code

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/stop_pulling()
	if(pulling == awakened_buddy) //it's tempting to make player controlled shepherd pull you forever but I'll hold off on it
		return FALSE
	..()

//stops shepherd pushing people or things he shouldn't because of his move force
/mob/living/simple_animal/hostile/abnormality/blue_shepherd/MobBump(mob/M)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/CanAttack(atom/the_target)
	if(slashing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/slash()
	if(buddy?.current?.status_flags & GODMODE)
		buddy.qliphoth_change(-1) //buddy can hear it fight
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(range, orgin)
	for(var/i = 0 to range)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			playsound(src, 'sound/weapons/guillotine.ogg', 75, FALSE, 4)
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in T)
				if(L == src)
					continue
				L.apply_damage(slash_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			all_turfs -= T
		SLEEP_CHECK_DEATH(3)
	slashing = FALSE

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	death_counter += 1
	if(death_counter >= 2)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE

///makes a list of abno datum that can breach and aren't dead/null
/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/AbnoListGen()
	var/list/abno_list = list()
	if(LAZYLEN(SSlobotomy_corp.all_abnormality_datums))
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			if(isnull(A.current))
				continue
			if(A.name == "Reddened Buddy") //this one is a special case
				continue
			if(A.current.can_breach && A.name != name)
				abno_list += A
	return abno_list

///add stuff to the list when newbies arrive and removes duplicates so the list isn't full of the same respawned guy(s)
/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/OnNewCrew(datum_source, mob/living/newbie)
	SIGNAL_HANDLER
	if(!ishuman(newbie)) //dogs stealing our job
		return
	if(LAZYLEN(people_list))
		for(var/mob/living/carbon/human/person in people_list)
			if(newbie.real_name == person.real_name)
				people_list -= person
	people_list += newbie

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/OnAbnoSpawn(datum/source, datum/abnormality/abno)
	SIGNAL_HANDLER
	if(abno.name == "Reddened Buddy")
		buddy = abno
		UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN)
