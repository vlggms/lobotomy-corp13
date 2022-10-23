/mob/living/simple_animal/hostile/abnormality/red_buddy
	name = "Reddened Buddy"
	desc = "A small whimpering dog like creature."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "redbuddy"
	icon_living = "redbuddy"
	icon_dead = "redbuddy_dead"
	del_on_death = FALSE
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 2200 //Tanky but hurts itself every now and then to make up for it
	health = 2200
	speed = 4
	move_to_delay = 7
	rapid_melee = 1
	del_on_death = FALSE
	move_resist = MOVE_FORCE_NORMAL + 1 //Can't be pulled by humans, but can be pulled by shepherd this might have other unforeseen consequences
	threat_level = HE_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(0, 30, 35, 35, 35),
						ABNORMALITY_WORK_INSIGHT = list(0, 20, 40, 40, 40),
						ABNORMALITY_WORK_ATTACHMENT = list(20, 55, 60, 60, 60),
						ABNORMALITY_WORK_REPRESSION = list(20, 55, 60, 60, 60)
						)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.5)
	melee_damage_lower = 50
	melee_damage_upper = 60 //hits like a truck but is slow as shit
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 0 //his work damage now is entirely related to suffering
	work_damage_type = RED_DAMAGE
	attack_verb_continuous = "chomps"
	attack_verb_simple = "claws"
	faction = list("blueshep")
	attack_sound = 'sound/weapons/bite.ogg'
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3

	ego_list = list(
		/datum/ego_datum/weapon/totalitarianism,
		/datum/ego_datum/armor/totalitarianism
		)
	gift_type = /datum/ego_gifts/totalitarianism

	///The blue smocked shepherd linked to red buddy
	var/datum/abnormality/master
	//the living shepherd it is currently fighting with
	var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/awakened_master
	///How "hurt" buddy is, which affects his work damage
	var/suffering = 0
	///the timer id linked to shepherd's lie
	var/lying_timer = FALSE
	///if shepherd has lied in the past minute
	var/lying
	///if red buddy has seen shepherd or not
	var/awakened = FALSE
	///cooldown related to his howling
	var/awoo_cooldown = 0
	///the time between each howling
	var/awoo_cooldown_time = 30 SECONDS

/mob/living/simple_animal/hostile/abnormality/red_buddy/Initialize()
	. = ..()
	if(LAZYLEN(SSlobotomy_corp.all_abnormality_datums))
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			if(A.name == "Blue Smocked Shepherd")
				master = A
				return
	if(!master)
		RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN, .proc/OnAbnoSpawn) //if shepherd isn't here yet, buddy will wait for him like a good dog

/mob/living/simple_animal/hostile/abnormality/red_buddy/proc/OnAbnoSpawn(datum/source, datum/abnormality/abno)
	SIGNAL_HANDLER
	if(abno.name == "Blue Smocked Shepherd")
		master = abno
		UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN)

/mob/living/simple_animal/hostile/abnormality/red_buddy/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		return
	AdjustSuffering(3)
	return

/mob/living/simple_animal/hostile/abnormality/red_buddy/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		return
	datum_reference.qliphoth_change(-1)
	AdjustSuffering(10)
	return

/mob/living/simple_animal/hostile/abnormality/red_buddy/worktick_failure(mob/living/carbon/human/user)
	AdjustSuffering(1)
	work_damage_amount = suffering
	UpdateScars()
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_buddy/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			suffering = 0
		if(ABNORMALITY_WORK_REPRESSION)
			AdjustSuffering(10) //my brother in christ you are literally beating the dog up
	UpdateScars()
	if(suffering >= 20)
		datum_reference.qliphoth_change(-1)

	if(lying)
		user.Apply_Gift(new gift_type)
		lying = FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_buddy/work_chance(mob/living/carbon/human/user, chance)
	if(lying)
		chance += 15 //you get extra success chance for calling out a shepherd lie
	return chance

/mob/living/simple_animal/hostile/abnormality/red_buddy/attempt_work(mob/living/carbon/human/user, work_type)
	if(lying_timer)
		datum_reference.qliphoth_change(1)
		deltimer(lying_timer)
	return TRUE

//makes buddy scarred if his suffering is high enough
/mob/living/simple_animal/hostile/abnormality/red_buddy/proc/UpdateScars()
	if(!status_flags & GODMODE) //I don't know how you're working on the dog while he's breached but stop
		return
	if(suffering >= 20)
		icon_state = "redbuddy_scratched"
	else
		icon_state = "redbuddy"

/mob/living/simple_animal/hostile/abnormality/red_buddy/Life()
	..()
	if(status_flags & GODMODE)
		return
	if(awoo_cooldown <= world.time && !awakened)
		Awoo()
	var/mob/living/master_abno = master?.current
	if(!master_abno || awakened)
		return
	if(master_abno.status_flags & GODMODE) //no reason to look for shepherd if he's not out
		return
	if(can_see(src, master_abno, 10))
		awakened_master = master_abno
		awakened = TRUE
		damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
		adjustHealth(-maxHealth)
		melee_damage_lower = 60
		melee_damage_upper = 80
		move_to_delay = 4 //this doesn't matter as much as you'd think because he can't move before shepherd
		can_patrol = FALSE //just in case

/mob/living/simple_animal/hostile/abnormality/red_buddy/Move(atom/newloc)
	if(!awakened_master || AIStatus == AI_OFF)
		return . = ..()
	var/turf/orgin = get_turf(awakened_master)
	var/list/all_turfs = RANGE_TURFS(1, orgin)
	if(!LAZYFIND(all_turfs, newloc))
		return FALSE //he doesn't get to move outside of his master's range
	. = ..()

/mob/living/simple_animal/hostile/abnormality/red_buddy/breach_effect()
	..()
	deltimer(lying_timer)
	icon_state = "redbuddy_active"

///basically a stronger fragment song that hurts red buddy, it's slower hitting than fragment however
/mob/living/simple_animal/hostile/abnormality/red_buddy/proc/Awoo()
	awoo_cooldown = world.time + awoo_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/fragment/sing.ogg', 50, 0, 4)
	var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/shepherd = master?.current
	if(shepherd?.status_flags & GODMODE)
		shepherd.hired = TRUE //it's more likely for them to run into each other this way
		master.qliphoth_change(-1) //shepherd doesn't breach instantly but it's only a matter of time
	playsound(src, 'sound/abnormalities/redbuddy/redbuddy_howl.ogg', 100, FALSE, 8)
	for(var/i = 1 to 4)
		var/heard_awoo = FALSE //red buddy is only hurt by his howl if someone hears it
		for(var/mob/living/L in view(7, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(10, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			heard_awoo = TRUE
		if(health >= 75 && heard_awoo)
			adjustHealth(75)
		SLEEP_CHECK_DEATH(1 SECONDS)

/mob/living/simple_animal/hostile/abnormality/red_buddy/proc/AdjustSuffering(pain)
	suffering = clamp(pain + suffering, 0, 50)

///triggers 90 seconds after shepherd tells a lie
/mob/living/simple_animal/hostile/abnormality/red_buddy/proc/ShepherdLying()
	datum_reference.qliphoth_change(-1)
	AdjustSuffering(5)
	lying = FALSE

/mob/living/simple_animal/hostile/abnormality/red_buddy/death(gibbed)
	awakened_master = null
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN)
	..()
