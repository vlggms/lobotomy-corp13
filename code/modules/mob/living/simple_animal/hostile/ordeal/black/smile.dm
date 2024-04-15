//Smile
/mob/living/simple_animal/hostile/ordeal/echo/smile
	icon_state = "smile_echo"
	icon_living = "smile_echo"
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 160
	melee_damage_upper = 160
	rapid_melee = 1
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.4)
	ranged = TRUE

	attack_verb_continuous = list("bashes")
	attack_verb_simple = list("bash")
	attack_sound = 'sound/weapons/ego/hammer.ogg'
	var/spit_amount = 5
	var/scream_damage = 50	//Does rend black

/mob/living/simple_animal/hostile/ordeal/echo/smile/AttackingTarget()
	. = ..()
	if(ishuman(target))
		var/mob/living/B = target
		if((B.health<=B.maxHealth *0.1 || B.stat == DEAD) && !(GODMODE in B.status_flags))	//Kills you under 10% HP
			B.gib()
			adjustBruteLoss(-(maxHealth/2))

/mob/living/simple_animal/hostile/ordeal/echo/smile/OpenFire()
	var/special = rand(1,2)

	switch(special)
		if(3)
			Spit()
		if(4)
			Scream()
		else	//You have 2 attacks, but generally prefer to not use them
			return

/mob/living/simple_animal/hostile/ordeal/echo/smile/proc/Spit()
	SLEEP_CHECK_DEATH(1 SECOND)
	playsound(get_turf(src), 'sound/abnormalities/mountain/spit.ogg', 75, 1, 3)
	for(var/k = 1 to 3)
		var/turf/startloc = get_turf(targets_from)
		for(var/i = 1 to spit_amount)
			var/obj/projectile/mountain_spit/P = new(get_turf(src))
			P.starting = startloc
			P.firer = src
			P.fired_from = src
			P.yo = target.y - startloc.y
			P.xo = target.x - startloc.x
			P.original = target
			P.preparePixelProjectile(target, src)
			P.fire()
		SLEEP_CHECK_DEATH(2)

/mob/living/simple_animal/hostile/ordeal/echo/smile/proc/Scream()
	visible_message(span_danger("[src] screams wildly!"))
	new /obj/effect/temp_visual/voidout(get_turf(src))
	playsound(get_turf(src), 'sound/abnormalities/mountain/scream.ogg', 75, 1, 5)
	var/list/been_hit = list()
	for(var/turf/T in view(7, src))
		HurtInTurf(T, been_hit, scream_damage, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE)
		for(var/living/mob/carbon/human/H in T)
			if(!M.has_status_effect(/datum/status_effect/rend_black))
				new /obj/effect/temp_visual/cult/sparks(get_turf(M))
				M.apply_status_effect(/datum/status_effect/rend_black)

