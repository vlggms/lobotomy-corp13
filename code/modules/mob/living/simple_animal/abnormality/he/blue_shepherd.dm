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
				"'s hasn't breached yet, but I wouldn't count on it staying that way.",
				" hasn't escaped despite your terrible work ethic, I won't be as easy to handle.",
				"'s doing fine, don't you have a manager to check those things for you?",
				)
	var/list/people_list = list() //list of people shepperd can mention
	var/list/abno_list = list() //list of abnormalities shepperd can mention

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Initialize()
	. = ..()
	//makes a list of people to shit talk
	if(LAZYLEN(GLOB.mob_living_list))
		for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
			if(H.stat != DEAD)
				people_list += H
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/on_mob_death) // Alright, here we go again
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, .proc/on_new_crew)//add stuff to the list when newbies arrive

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(LAZYLEN(SSlobotomy_corp.all_abnormality_datums)) //updates up the abno list every work
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			if(initial(A.abno_path.can_breach) && A.name != "Blue Smocked Shepherd")
				abno_list += A
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
		else
			lie = FALSE
		if(prob(50) && LAZYLEN(abno_list)) //decide which subject to pick
			var/abno_datum = pick(abno_list)
			if(!istype(abno_datum,/datum/abnormality))
				return ..()
			var/mob/living/simple_animal/hostile/abnormality/abno = abno_datum.current
			if(isnull(abno))//if the abno's been supressed or is missing for whatever reason, this one can't be a lie since it also acts as an anti-runtime
				say("No matter how many of them you supress, they will always come back")
			else if((!(abno.status_flags & GODMODE) && !lie) || ((abno.status_flags & GODMODE) && lie))
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
	if(livinginrange(4, src) && hired == FALSE)
		say("I've had it with you!")
		GiveTarget(user)
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
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Move()
	if(slashing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/CanAttack(atom/the_target)
	if(slashing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/slash()
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

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/on_mob_death(datum/source, mob/living/died, gibbed)
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

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/on_new_crew(datum_source,mob/living/H)
	SIGNAL_HANDLER
	if(ishuman(H))
		people_list += H
