/mob/living/simple_animal/hostile/humanoid/blood
	faction = list("hostile")


/mob/living/simple_animal/hostile/humanoid/blood/fiend
	name = "Blood Fiend"
	desc = "Blood Fiend Desc"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "humanoid_hostile"
	icon_living = "humanoid_hostile"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 5
	melee_damage_upper = 6
	melee_damage_type = RED_DAMAGE
	maxHealth = 100
	health = 100
	ranged = TRUE
	var/leap_sound = 'sound/abnormalities/ichthys/hammer2.ogg'
	var/blood_feast = 100
	var/max_blood_feast = 100
	var/can_act = TRUE
	var/leap_damage = 10


/mob/living/simple_animal/hostile/humanoid/blood/fiend/proc/AdjustBloodFeast(amount)
	adjustBruteLoss(-amount/2)
	blood_feast += amount
	if (blood_feast > max_blood_feast)
		blood_feast = max_blood_feast

/mob/living/simple_animal/hostile/humanoid/blood/fiend/proc/Leap(mob/living/target)
	if(!isliving(target) && !ismecha(target) || !can_act)
		return
	var/dist = get_dist(target, src)
	if(dist > 1)
		blood_feast = 0
		can_act = FALSE
		//icon_state = enraged ? "headless_ichthys_charging_enraged" : "headless_ichthys_charging"
		SLEEP_CHECK_DEATH(0.25 SECONDS)
		animate(src, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		src.pixel_z = 16
		playsound(src, 'sound/abnormalities/ichthys/jump.ogg', 50, FALSE, 4)
		var/turf/target_turf = get_turf(target)
		SLEEP_CHECK_DEATH(1 SECONDS)
		if(target_turf)
			forceMove(target_turf) //look out, someone is rushing you!
		playsound(src, leap_sound, 50, FALSE, 4)
		animate(src, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		src.pixel_z = 0
		SLEEP_CHECK_DEATH(0.1 SECONDS)
		//icon_state = enraged ? "headless_ichthys_enraged" : "headless_ichthys"
		for(var/turf/T in view(1, src))
			var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
			FX.color = "#b52e19"
			for(var/mob/living/L in T)
				if(faction_check_mob(L))
					continue
				L.deal_damage(leap_damage, RED_DAMAGE)
			for(var/obj/vehicle/sealed/mecha/V in T)
				V.take_damage(leap_damage, RED_DAMAGE)
		SLEEP_CHECK_DEATH(1.5 SECONDS)

		target_turf = get_turf(target)
		var/list/hit_mob = list()
		do_shaky_animation(2)
		if(do_after(src, 1 SECONDS, target = src))
			var/turf/wallcheck = get_turf(src)
			var/enemy_direction = get_dir(src, target_turf)
			for(var/i = 0 to 7)
				if(get_turf(src) != wallcheck || stat == DEAD)
					break
				wallcheck = get_step(src, enemy_direction)
				if(!ClearSky(wallcheck))
					break
				//without this the attack happens instantly
				sleep(1)
				forceMove(wallcheck)
				playsound(wallcheck, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 20, 0, 4)
				for(var/turf/T in orange(get_turf(src), 1))
					if(isclosedturf(T))
						continue
					new /obj/effect/temp_visual/slice(T)
					hit_mob = HurtInTurf(T, hit_mob, 50, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)
		can_act = TRUE

/mob/living/simple_animal/hostile/humanoid/blood/fiend/ClearSky(turf/T)
	. = ..()
	if(.)
		if(locate(/obj/structure/table) in T.contents)
			return FALSE
		if(locate(/obj/structure/railing) in T.contents)
			return FALSE

/mob/living/simple_animal/hostile/humanoid/blood/fiend/AttackingTarget()
	if(!can_act)
		return
	if(blood_feast == max_blood_feast && !client)
		Leap(target)
		return
	return ..()

/mob/living/simple_animal/hostile/humanoid/blood/fiend/OpenFire()
	if(!can_act)
		return FALSE
	if(max_blood_feast == blood_feast)
		Leap(target)
		return



/mob/living/simple_animal/hostile/humanoid/blood/fiend/Move()
	if(!can_act)
		return FALSE
	var/turf/T = get_turf(src)
	if(!T)
		..()
		return
	if (health != maxHealth || blood_feast != max_blood_feast)
		for(var/obj/effect/decal/cleanable/blood/B in view(T, 2)) //will clean up any blood, but only heals from human blood
			if(B.blood_state == BLOOD_STATE_HUMAN)
				playsound(T, 'sound/abnormalities/nosferatu/bloodcollect.ogg', 25, 3)
				if(B.bloodiness == 100) //Bonus for "pristine" bloodpools, also to prevent footprint spam
					AdjustBloodFeast(30)
				else
					AdjustBloodFeast(max((B.bloodiness**2)/800,1))
			qdel(B)
	..()


/mob/living/simple_animal/hostile/humanoid/blood/bag
	name = "Blood Bag"
	desc = "Blood Bag Desc"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "humanoid_hostile"
	icon_living = "humanoid_hostile"
	icon_dead = "humanoid_hostile"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 5
	melee_damage_upper = 6
	melee_damage_type = RED_DAMAGE
	maxHealth = 100
	health = 100
	var/self_damage = 10
	var/self_damage_type = RED_DAMAGE

/mob/living/simple_animal/hostile/humanoid/blood/bag/AttackingTarget(atom/attacked_target)
	. = ..()
	deal_damage(self_damage, self_damage_type)

/mob/living/simple_animal/hostile/humanoid/blood/bag/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	var/turf/origin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(1, origin)
	for(var/turf/T in shuffle(all_turfs))
		if (T.is_blocked_turf(exclude_mobs = TRUE))
			continue;
		var/obj/effect/decal/cleanable/blood/B = locate() in T
		if(!B)
			B = new /obj/effect/decal/cleanable/blood(T)
			B.bloodiness = 100
			break;

/mob/living/simple_animal/hostile/humanoid/blood/bag/death(gibbed)
	walk_to(src, 0)
	say("FOR G CORP!!!")
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	QDEL_IN(src, 15)
	..()

/mob/living/simple_animal/hostile/humanoid/blood/bag/proc/DeathExplosion()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
	for(var/mob/living/L in view(3, src))
		L.deal_damage(60, RED_DAMAGE)
	var/turf/origin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(1, origin)
	for(var/turf/T in shuffle(all_turfs))
		if (T.is_blocked_turf(exclude_mobs = TRUE))
			continue;
		var/obj/effect/decal/cleanable/blood/B = locate() in T
		if(!B)
			B = new /obj/effect/decal/cleanable/blood(T)
			B.bloodiness = 100
