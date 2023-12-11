//Dream-Devouring Slitcurrent would be a breach that forces you to either try to kill it from it hitting the tubes or using the tubes to make you last longer.
//When out you're on a timer due to everyone on the floor it's on taking oxygen damage.

/mob/living/simple_animal/hostile/abnormality/slitcurrent
	name = "\proper Dream-Devouring Siltcurrent"
	desc = "An abnormality resembling a giant black and teal shark or fish. \
	There's teal light tubes embedded in its body,"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "slitcurrent"
	icon_living = "slitcurrent"
	pixel_x = -16
	base_pixel_x = -16
	move_to_delay = 3
	rapid_melee = 2
	melee_damage_lower = 25
	melee_damage_upper = 35
	melee_damage_type = RED_DAMAGE
	is_flying_animal = TRUE
	maxHealth = 2000
	health = 2000
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	stat_attack = HARD_CRIT
	deathsound = 'sound/abnormalities/dreamingcurrent/dead.ogg'
	attack_sound = 'sound/effects/ordeals/crimson/noon_bite.ogg'
	attack_verb_continuous = "chomps"
	attack_verb_simple = "chomps"
	light_color = COLOR_TEAL
	light_range = 4
	light_power = 5
	threat_level = WAW_LEVEL

	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(85, 65, 45, 50, 55),
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = -100,//you thought it would work like current eh?
						ABNORMALITY_WORK_REPRESSION = list(70, 65, 60, 55, 50)//Incase you reach waw with justice 1
						)
	work_damage_amount = 6//does constant oxygen damage during work
	work_damage_type = RED_DAMAGE
	ranged = 1
	can_breach = TRUE
	start_qliphoth = 2
	can_patrol = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/dream_devouring,
		/datum/ego_datum/weapon/blind_obsession,
		/datum/ego_datum/armor/blind_obsession
		)
	gift_type = /datum/ego_gifts/blind_obsession
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	var/stunned = FALSE
	//Stuff relating to the dive attack
	var/diving = FALSE
	var/dive_cooldown
	var/dive_cooldown_time = 15 SECONDS
	var/dive_damage = 100
	//The amount of flotsams that should spawn in the hallways when it breaches
	var/tube_spawn_amount = 6
	var/list/spawned_flotsams = list()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/Life()
	. = ..()
	if(!.) // Dead
		return FALSE

//Checks if it's stunned or doing the dive attack to prevent it from attacking or moving while in those 2 states since it would be silly.
/mob/living/simple_animal/hostile/abnormality/slitcurrent/Move()
	if(diving || stunned)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/Goto(target, delay, minimum_distance)
	if(diving || stunned)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/CanAttack(atom/the_target)
	if(diving || stunned)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/OpenFire()
	SlitDive(target)
	return

/mob/living/simple_animal/hostile/abnormality/slitcurrent/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(!IsContained())//Prevents you from just refilling your oxygen during work. Go heal dibshit.
		Refill(user)


/mob/living/simple_animal/hostile/abnormality/slitcurrent/bullet_act(obj/projectile/P)
	. = ..()
	if(!IsContained())
		Refill(P.firer)

//Less effective than attacking the flotsam but its another option in higher pop maps where flotsams are more farther away from each other.
/mob/living/simple_animal/hostile/abnormality/slitcurrent/proc/Refill(mob/living/attacker)
	attacker.adjustOxyLoss(-20, updating_health=TRUE, forced=TRUE)


/mob/living/simple_animal/hostile/abnormality/slitcurrent/proc/SlitDive(mob/living/target)
	if(!istype(target) || diving || stunned)
		return
	if(get_dist(target, src) > 1 && dive_cooldown < world.time)
		dive_cooldown = world.time + dive_cooldown_time
		diving = TRUE
		//icon_state = "current_prepare"
		SLEEP_CHECK_DEATH(0.4 SECONDS)
		animate(src, alpha = 1,pixel_x = -16, pixel_z = -16, time = 0.2 SECONDS)
		src.pixel_z = -16
		playsound(src, "sound/abnormalities/piscinemermaid/waterjump.ogg", 10, TRUE, 3)
		var/turf/target_turf = get_turf(target)
		SLEEP_CHECK_DEATH(0.75 SECONDS)
		forceMove(target_turf) //look out, someone is rushing you!
		playsound(src, 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 50, FALSE, 4)
		animate(src, alpha = 255,pixel_x = -16, pixel_z = 16, time = 0.1 SECONDS)
		src.pixel_z = 0
		SLEEP_CHECK_DEATH(0.1 SECONDS)
		for(var/turf/T in view(2, src))
			var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
			smonk.color = COLOR_TEAL
			for(var/mob/living/L in HurtInTurf(T, list(), dive_damage, RED_DAMAGE))
				playsound(L, "sound/abnormalities/dreamingcurrent/bite.ogg", 50, TRUE)
				if(istype(L, /mob/living/simple_animal/hostile/flotsam))
					if(L.stat != DEAD)
						//icon_state = icon_living
						Stunned()
						src.adjustBruteLoss(1000)
						L.adjustBruteLoss(750)
						visible_message(span_boldwarning("[src] mauls the Flotsam taking heavy damage!"))
				if (ishuman(L))
					visible_message(span_boldwarning("[src] mauls through [L]!"))
					to_chat(L, span_userdanger("[src] mauls you!"))
					if(L.health < 0 || L.stat == DEAD)
						L.gib()
		SLEEP_CHECK_DEATH(0.5 SECONDS)
		diving = FALSE

/mob/living/simple_animal/hostile/abnormality/slitcurrent/proc/Stunned()
	set waitfor = FALSE
	stunned = TRUE
	ChangeResistances(list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.5))//You did it nows your chance to beat the shit out of it!
	SLEEP_CHECK_DEATH(12 SECONDS)
	stunned = FALSE
	ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5))

/mob/living/simple_animal/hostile/abnormality/dreaming_current/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/slitcurrent/Worktick(mob/living/carbon/human/user)
	user.adjustOxyLoss(1.5, updating_health=TRUE, forced=TRUE)//haha drown.

/mob/living/simple_animal/hostile/abnormality/slitcurrent/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	if(user.oxyloss >= 50)//POWER GRINDER SPOTTED! MUST MAUL THE FUCK!
		datum_reference.qliphoth_change(-1)
		GiveTarget(user)
		SlitDive(user)
	return

/mob/living/simple_animal/hostile/abnormality/slitcurrent/BreachEffect(mob/living/carbon/human/user)
	. = ..()
	icon_living = "current_breach"
	//icon_state = icon_living
	addtimer(CALLBACK(src, .proc/OxygenLoss), 5 SECONDS, TIMER_LOOP)
	for(var/mob/living/L in GLOB.player_list)//Spawns Flotsams in the halls and notifies people that they'll be taking oygen damage.
		if(L.z != z || L.stat >= HARD_CRIT)
			continue
		to_chat(L, span_userdanger("You feel water enter into your lungs!"))
	var/list/spawn_turfs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to (tube_spawn_amount))
		if(!LAZYLEN(spawn_turfs)) //if list empty, recopy xeno spawns
			spawn_turfs = GLOB.xeno_spawn.Copy()
		var/X = pick_n_take(spawn_turfs)
		var/turf/T = get_turf(X)
		var/list/deployment_area = list()
		var/turf/deploy_spot = T //spot you are being deployed
		if(LAZYLEN(deployment_area)) //if deployment zone is empty just spawn at xeno spawn
			deploy_spot = pick_n_take(deployment_area)
		var/mob/living/simple_animal/hostile/flotsam/F = new get_turf(deploy_spot)
		spawned_flotsams += F

/mob/living/simple_animal/hostile/abnormality/slitcurrent/proc/OxygenLoss()//While its alive all humans on its z level will lose oxygen
	for(var/mob/living/L in GLOB.player_list)
		if(L.z != z || L.stat >= HARD_CRIT)//Prevent slit from sniping manager with water in their lungs and dead people as well
			continue
		playsound(L, "sound/effects/bubbles.ogg", 50, TRUE, 7)
		new /obj/effect/temp_visual/mermaid_drowning(get_turf(L))
		L.adjustOxyLoss(3, updating_health=TRUE, forced=TRUE)

/mob/living/simple_animal/hostile/abnormality/slitcurrent/death()
	for(var/mob/living/simple_animal/hostile/flotsam/F in spawned_flotsams)
		QDEL_IN(F, rand(5) SECONDS)
		spawned_flotsams -= F
	..()

/mob/living/simple_animal/hostile/flotsam
	name = "Flotsam"
	desc = "A pile of teal light tubes embedded into the floor."
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "flotsam"
	icon_living = "flotsam"
	icon_dead = "flotsam_dead"
	/*Stats*/
	health = 750
	maxHealth = 750
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	density = TRUE
	light_color = COLOR_TEAL
	light_range = 4
	light_power = 5

/mob/living/simple_animal/hostile/flotsam/Move()
	return FALSE

/mob/living/simple_animal/hostile/flotsam/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/flotsam/attackby(obj/item/W, mob/user, params)
	. = ..()
	Refill(user)


/mob/living/simple_animal/hostile/flotsam/bullet_act(obj/projectile/P)
	. = ..()
	Refill(P.firer)


/mob/living/simple_animal/hostile/flotsam/proc/Refill(mob/living/attacker)
	attacker.adjustOxyLoss(-100, updating_health=TRUE, forced=TRUE)

/mob/living/simple_animal/hostile/flotsam/gib()
	return FALSE
