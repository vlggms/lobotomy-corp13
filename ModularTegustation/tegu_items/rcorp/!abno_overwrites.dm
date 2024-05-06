//This file is for overwrites for initializes for the RCA gamemode.

//Scarecrow heals less but can infinitely suck bodies.
//For MOST of RCA, Scarecrow could heal infinitely. This allowed him to function.
//With that removed he no longer fulfills his role of a tank.
/mob/living/simple_animal/hostile/abnormality/scarecrow/Initialize()
	..()
	if(IsCombatMap())
		braineating = FALSE
		healthmodifier = 0.02

//Jangsen is slow, and blocks bullets fully now to let them function as a tank
/mob/living/simple_animal/hostile/abnormality/jangsan/Initialize()
	..()
	if(IsCombatMap())
		bullet_threshold = 150


//R-Corp cannot eat 180 white damage
/mob/living/simple_animal/hostile/abnormality/alriune/Initialize()
	. = ..()
	if(IsCombatMap())
		pulse_damage = 70

//Helper can't be stunned for a million fuckin years
/mob/living/simple_animal/hostile/abnormality/helper/Initialize()
	. = ..()
	if(IsCombatMap())
		stuntime = 2 SECONDS

//Frag needs a little damage buff
/mob/living/simple_animal/hostile/abnormality/fragment/Initialize()
	..()
	if(IsCombatMap())
		melee_damage_lower = 22
		melee_damage_upper = 25
		song_damage = 8

//Clown could be a bit faster, and a bit more damage
/mob/living/simple_animal/hostile/abnormality/clown/Initialize()
	if(IsCombatMap())
		move_to_delay = 2.3
		melee_damage_lower = 20
		melee_damage_upper = 20
	..()


/mob/living/simple_animal/hostile/abnormality/voiddream/Transform()
	if(IsCombatMap())
		return
	..()

//Porccubus gets a much shorter dash cooldown to better maneuver itself with how big of a commitment dashing is.
/mob/living/simple_animal/hostile/abnormality/porccubus/Initialize()
	. = ..()
	if(IsCombatMap())
		ranged_cooldown_time = 3 SECONDS

// Fairy gentleman gets a bump to his survival, damage, and a bigger ass.
// This is to account for being a fully melee fighter with TETH resists.
/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/Initialize()
	if(IsCombatMap())
		maxHealth = 1400
		health = 1400
		move_to_delay = 2.3
		melee_damage_lower = 20
		melee_damage_upper = 25
		jump_damage = 100
		jump_aoe = 2
	..()
