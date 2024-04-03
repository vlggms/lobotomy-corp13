// Various Copies of aleph agents
/mob/living/simple_animal/hostile/ordeal/echo
	name = "Echoes of an Agent"
	desc = "Is that.... you?"
	icon = 'ModularTegustation/Teguicons/echoes.dmi'
	icon_state = "blank_shade"
	icon_living = "blank_shade"
	faction = list("hostile")
	maxHealth = 500		//They are a copy of you, with double the HP
	health = 500
	melee_damage_type = BLACK_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	move_to_delay = 1.6
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.0, PALE_DAMAGE = 0.5)
	move_resist = MOVE_FORCE_OVERPOWERING
	projectiletype = /obj/projectile/black
	attack_sound = 'sound/weapons/ego/hammer.ogg'
	del_on_death = TRUE
	can_patrol = TRUE

//Mimicry
/mob/living/simple_animal/hostile/ordeal/echo/mimicry
	icon_state = "mimicry_echo"
	icon_living = "mimicry_echo"
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 161
	melee_damage_upper = 161
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.4)

	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	attack_sound =  'sound/abnormalities/nothingthere/attack.ogg'

/mob/living/simple_animal/hostile/ordeal/echo/mimicry/AttackingTarget()
	. = ..()
	if(isliving(target))
		adjustBruteLoss(-(maxHealth/5))


//Flowering night
/mob/living/simple_animal/hostile/ordeal/echo/flowering
	icon_state = "flowering_echo"
	icon_living = "flowering_echo"
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 184
	melee_damage_upper = 184
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.1)

	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	attack_sound = 'sound/weapons/ego/rapier2.ogg'

/mob/living/simple_animal/hostile/ordeal/echo/flowering/AttackingTarget()
	melee_damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, PALE_DAMAGE)
	switch(melee_damage_type)
		if(RED_DAMAGE)
			melee_damage_lower = 184
			melee_damage_upper = 184
		if(WHITE_DAMAGE)
			melee_damage_lower = 161
			melee_damage_upper = 161
		if(PALE_DAMAGE)
			melee_damage_lower = 115
			melee_damage_upper = 115

	. = ..()

//Da Capo
/mob/living/simple_animal/hostile/ordeal/echo/capo
	icon_state = "capo_echo"
	icon_living = "capo_echo"
	rapid_melee = 4
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 92
	melee_damage_upper = 92
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.0, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)

	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	attack_sound = 'sound/weapons/ego/da_capo1.ogg'

	var/combo
	var/combo_time
	var/combo_wait = 14
	var/partner

/mob/living/simple_animal/hostile/ordeal/echo/capo/AttackingTarget()
	//Combo Time stuff
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait

	//Similar to Capo, take a fuckload of damage if you keep attacking the same guy
	if(partner != target)
		partner = target
		combo = 0

	//Reset these to normal
	melee_damage_lower = 92
	melee_damage_upper = 92

	combo+=1
	switch(combo)
		if(2)
			attack_sound = 'sound/weapons/ego/da_capo2.ogg'
		if(3)
			attack_sound = 'sound/weapons/ego/da_capo3.ogg'
			melee_damage_lower = 138
			melee_damage_upper = 138
			combo = 0

	. = ..()

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.sanity_lost)
			H.death()


//Justitia
/mob/living/simple_animal/hostile/ordeal/echo/justitia
	icon_state = "justitia_echo"
	icon_living = "justitia_echo"
	rapid_melee = 4
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 57.7
	melee_damage_upper = 57.7
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.0, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)

	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	attack_sound = 'sound/weapons/ego/justitia3.ogg'

	var/combo
	var/combo_time
	var/combo_wait = 10

/mob/living/simple_animal/hostile/ordeal/echo/justitia/AttackingTarget()
	//Combo Time stuff
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait

	//Combo increase
	combo+=1
	melee_damage_lower = 57.7
	melee_damage_upper = 57.7

	switch(combo)
		if(5)
			attack_sound = 'sound/weapons/ego/justitia2.ogg'
			melee_damage_lower = 86.25
			melee_damage_upper =  86.25
		if(6)
			attack_sound = 'sound/weapons/ego/justitia4.ogg'
			melee_damage_lower = 86.25
			melee_damage_upper =  86.25
			combo = 0

			var/turf/T = get_turf(target)
			new /obj/effect/temp_visual/justitia_effect(T)
			HurtInTurf(T, list(), 50, PALE_DAMAGE)

	. = ..()


//Smile
/mob/living/simple_animal/hostile/ordeal/echo/smile
	icon_state = "smile_echo"
	icon_living = "smile_echo"
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 253
	melee_damage_upper = 253
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.4)

	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'

/mob/living/simple_animal/hostile/ordeal/echo/smile/AttackingTarget()
	. = ..()
	if(ishuman(target))
		var/mob/living/B = target
		if((B.health<=B.maxHealth *0.1 || B.stat == DEAD) && !(GODMODE in B.status_flags))	//Kills you under 10% HP
			B.gib()
			adjustBruteLoss(-(maxHealth/2))

//Sound of a Star
/mob/living/simple_animal/hostile/ordeal/echo/star
	icon_state = "star_echo"
	icon_living = "star_echo"
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 80
	melee_damage_upper = 80
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.6)

	rapid = 5
	rapid_fire_delay = 2
	ranged_cooldown_time = 5
	retreat_distance = 1
	minimum_distance = 5
	ranged = TRUE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	projectiletype = /obj/projectile/ego_bullet/ego_star
	projectilesound = 'sound/weapons/ego/star.ogg'
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
