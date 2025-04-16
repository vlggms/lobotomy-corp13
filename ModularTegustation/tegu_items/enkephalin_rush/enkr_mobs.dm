/mob/living/simple_animal/hostile/ordeal/dragonskull_corrosion
	name = "Dragon Wizard"
	desc = "A clerk of Lobotomy Corporation that has somehow been corrupted by an abnormality."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "dskull_corrosion"
	icon_living = "dskull_corrosion"
	icon_dead = "dskull_corrosion"
	faction = list("gold_ordeal")
	maxHealth = 200
	health = 200
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 7
	melee_damage_upper = 14
	attack_verb_continuous = "scratches"
	attack_verb_simple = "scratch"
	attack_sound = 'sound/abnormalities/doomsdaycalendar/Doomsday_Slash.ogg'
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/stack/sheet/mineral/wood = 5)

/mob/living/simple_animal/hostile/ordeal/dragonskull_corrosion/death()
	playsound(src, 'sound/abnormalities/faelantern/faelantern_breach.ogg', 100)
	color = rgb(145,116,60)
	desc = "A wooden statue of a clerk corroded by [p_their()] E.G.O gear."
	..()

/mob/living/simple_animal/hostile/ordeal/dragonskull_corrosion/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.sanity_lost)
		playsound(get_turf(H), 'sound/abnormalities/faelantern/faelantern_breach.ogg', 200, 1)
		H.petrify(480, list(rgb(145,116,60)), "A distorted and screaming wooden statue.")

/mob/living/simple_animal/hostile/ordeal/tsa_corrosion
	name = "Creek Transporation Agent"
	desc = "A level 2 agent of the central command team that has somehow been corrupted by an abnormality."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "tsa_corrosion"
	icon_living = "tsa_corrosion"
	del_on_death = TRUE
	faction = list("gold_ordeal")
	maxHealth = 600
	health = 600
	ranged = TRUE
	ranged_cooldown_time = 5 SECONDS
	rapid = 50
	rapid_fire_delay = 0.4
	projectilesound = 'sound/weapons/gun/smg/shot.ogg'
	casingtype = /obj/item/ammo_casing/caseless/bigspread
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "batters"
	attack_verb_simple = "batter"
	attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 0.6)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 1)

//Projectiles
/obj/item/ammo_casing/caseless/bigspread
	name = "assorted casing"
	desc = "a assorted casing"
	projectile_type = /obj/projectile/bigspread
	pellets = 2
	variance = 360
	randomspread = 1

/obj/projectile/bigspread
	name = "assorted bullet"
	desc = "a hodgepodge of live, confiscated rounds."
	damage_type = RED_DAMAGE
	damage = 2

/mob/living/simple_animal/hostile/ordeal/sin_envy/agent
	maxHealth = 150
	health = 150
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	attack_sound = "swing_hit"
	outfit = /datum/outfit/job/agent/envy
	var/trip_chance = 10
	var/say_lines = list(//these are censored out anyways
		"Huh?",
		"We've got company!",
		"Attack!",
		"Hostiles detected",
	)

/mob/living/simple_animal/hostile/ordeal/sin_envy/agent/Aggro()
	..()
	var/line = pick(say_lines)
	say(line)

/mob/living/simple_animal/hostile/ordeal/sin_envy/agent/AttackingTarget(atom/attacked_target)
	. = ..()
	if(prob(trip_chance))
		TripTarget(attacked_target)
		say("Down!")

/mob/living/simple_animal/hostile/ordeal/sin_envy/agent/proc/TripTarget(atom/attacked_target)
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/L = attacked_target
		L.Knockdown(20)
		var/obj/item/held = L.get_active_held_item()
		L.dropItemToGround(held) //Drop weapon

/datum/outfit/job/agent/envy//todo:improve envy code to make these no longer necessary
	r_hand = /obj/item/melee/classic_baton

/mob/living/simple_animal/hostile/ordeal/sin_envy/agent/captain
	maxHealth = 200
	health = 200
	outfit = /datum/outfit/job/agent/captain/envy
	trip_chance = 20
	var/command_cooldown = 0
	var/command_delay = 18 SECONDS
	var/last_command = 0

/mob/living/simple_animal/hostile/ordeal/sin_envy/agent/captain/handle_automated_action()
	. = ..()
	if(command_cooldown < world.time && target && stat != DEAD)
		switch(last_command)
			if(1)
				Command(2) //always buff defense at start of battle
			else
				Command(1)

/mob/living/simple_animal/hostile/ordeal/sin_envy/agent/captain/proc/Command(manager_order)
	switch(manager_order)
		if(1)
			say("HOLD THE LINE!")
			for(var/mob/living/simple_animal/hostile/ordeal/G in view(9, src))
				if(G.stat == DEAD)
					continue
				G.apply_status_effect(/datum/status_effect/all_armor_buff)
			last_command = 1
		if(2)
			say("KILL THEM ALL!!")
			for(var/mob/living/simple_animal/hostile/ordeal/G in view(9, src))
				if(G.stat == DEAD)
					continue
				G.apply_status_effect(/datum/status_effect/minor_damage_buff)
			last_command = 2
	command_cooldown = world.time + command_delay

/datum/outfit/job/agent/captain/envy
	r_hand = /obj/item/melee/classic_baton

/mob/living/simple_animal/hostile/humanoid/ncorp//TODO: give tinned memories as a drop- increases attributes
	name = "N Corp Kleinhammer"
	desc = "A member of Nagel Und Hammer."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "ncorp"
	icon_living = "ncorp"
	icon_dead = "dead_generic"
	maxHealth = 1000
	health = 1000
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 25
	ranged = TRUE
	ranged_cooldown_time = 10 SECONDS
	del_on_death = FALSE
	faction = list("ordeal_gold")
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = TRUE
	move_to_delay = 3
	stat_attack = HARD_CRIT
	attack_verb_continuous = "nails"
	attack_verb_simple = "nail"
	attack_sound = 'sound/weapons/fixer/generic/nail1.ogg'
	butcher_results = list(/obj/item/food/meat/slab = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 1)
	var/can_act = TRUE
	var/ranged_damage = 25
	var/nail_delay = 1 SECONDS
	var/hammer_aoe = 1
	var/say_lines = list(
		"Who goes there?",
		"Glory to the one who grips!",
		"Purify!",
		"PURIFY!!!",
		"Heretics shall be purged!",
	)

/mob/living/simple_animal/hostile/humanoid/ncorp/Aggro()
	..()
	var/line = pick(say_lines)
	say(line)

/mob/living/simple_animal/hostile/humanoid/ncorp/death()
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	..()

/mob/living/simple_animal/hostile/humanoid/ncorp/CanAttack(atom/the_target)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/ncorp/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/ncorp/Goto(target, delay, minimum_distance)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/ncorp/DestroySurroundings()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/ncorp/AttackingTarget(atom/attacked_target)
	if(prob(30))
		HammerAttack()
		return
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/TH = attacked_target
	if(TH.health < 0 || TH.sanity_lost)
		can_act = FALSE
		TH.Stun(4 SECONDS)
		TH.SetImmobilized(4 SECONDS)
		forceMove(get_turf(TH))
		for(var/i = 1 to 5)
			if(!targets_from.Adjacent(TH) || QDELETED(TH))
				can_act = TRUE
				return
			SLEEP_CHECK_DEATH(3)
			TH.attack_animal(src)
			for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
				H.deal_damage(15, WHITE_DAMAGE)
		if(!targets_from.Adjacent(TH) || QDELETED(TH))
			can_act = TRUE
			return
		playsound(get_turf(src), 'sound/weapons/fixer/generic/nail2.ogg', 100, 1)
		TH.death()
		can_act = TRUE
		return

/mob/living/simple_animal/hostile/humanoid/ncorp/proc/HammerAttack(atom/attacked_target)
	var/turf/target_turf = get_ranged_target_turf(src, dir, 1)
	var/list/been_hit = list()
	playsound(get_turf(src), 'sound/weapons/ego/shield1.ogg', 100, 0)
	do_attack_animation(target_turf)
	for(var/turf/T in range(hammer_aoe, target_turf))
		new /obj/effect/temp_visual/smash_effect(T)
		been_hit = HurtInTurf(T, been_hit, melee_damage_upper, WHITE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, mech_damage = 15)

/mob/living/simple_animal/hostile/humanoid/ncorp/OpenFire()
	..()
	if(!can_act)
		return
	can_act = FALSE
	playsound(get_turf(src), 'sound/weapons/fixer/generic/nail1.ogg', 75, FALSE, 5)
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			break
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(nail_delay)
	can_act = TRUE
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		new /obj/effect/temp_visual/smash_effect(T)
		been_hit = HurtInTurf(T, been_hit, ranged_damage, BLACK_DAMAGE, null, TRUE)
		//TODO: apply nails here
	playsound(get_turf(src), 'sound/weapons/fixer/generic/nail2.ogg', 100, 1)

/mob/living/simple_animal/hostile/humanoid/ncorp/mittel
	name = "N Corp Mittelhammer"
	icon_state = "ncorp_mittelhammer"
	maxHealth = 2250
	health = 2250
	melee_damage_lower = 20
	melee_damage_upper = 35
	move_to_delay = 5
	nail_delay = 0.75 SECONDS
	hammer_aoe = 2

/mob/living/simple_animal/hostile/humanoid/ncorp/grosshammer//TODO: revive 3 times and grant regeneration, counter stance
	name = "N Corp Grosshammer"
	icon_state = "ncorp_grosshammer"
	icon_living = "ncorp_grosshammer"
	icon_dead = "ncorp_grosshammer_dead"
	maxHealth = 4500//self-revives repeatedly
	health = 4500
	melee_damage_lower = 35
	melee_damage_upper = 50
	move_to_delay = 8
	nail_delay = 0.5 SECONDS
	hammer_aoe = 2
	var/rez_count = 0
	say_lines = list(
		"Glory to the one who grips.",
	)

/mob/living/simple_animal/hostile/humanoid/ncorp/grosshammer/death()//TODO: give him K-corp ampoules on revive
	..()
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'//the subtype changes it
	if(rez_count < 3)
		++rez_count
		manual_emote("kneels.")
		say("Blah.")
		addtimer(CALLBACK(src, PROC_REF(revive), TRUE, FALSE), 15 SECONDS)
		return

/mob/living/simple_animal/hostile/humanoid/ncorp/kromer
	name = "The One who Grips"
	icon_state = "ncorp_kromer"
	maxHealth = 6000//distort on "death"
	health = 6000
	melee_damage_lower = 35
	melee_damage_upper = 50
	nail_delay = 0.5 SECONDS
	hammer_aoe = 2
