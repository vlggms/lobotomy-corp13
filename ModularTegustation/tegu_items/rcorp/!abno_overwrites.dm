//This file is for overwrites for initializes for the RCA gamemode.

//Scarecrow heals less but can infinitely suck bodies.
//For MOST of RCA, Scarecrow could heal infinitely. This allowed him to function.
//With that removed he no longer fulfills his role of a tank.
/mob/living/simple_animal/hostile/abnormality/scarecrow/Initialize()
	if(IsCombatMap())
		braineating = FALSE
		healthmodifier = 0.02
	return ..()

//Jangsen is slow, and blocks bullets fully now to let them function as a tank
/mob/living/simple_animal/hostile/abnormality/jangsan/Initialize()
	if(IsCombatMap())
		bullet_threshold = 150
	return ..()

//R-Corp cannot eat 180 white damage
/mob/living/simple_animal/hostile/abnormality/alriune/Initialize()
	if(IsCombatMap())
		pulse_damage = 100
	return ..()

//Helper can't be stunned for a million fuckin years
/mob/living/simple_animal/hostile/abnormality/helper/Initialize()
	if(IsCombatMap())
		stuntime = 2 SECONDS
	return ..()

//Frag needs a little damage buff
/mob/living/simple_animal/hostile/abnormality/fragment/Initialize()
	if(IsCombatMap())
		melee_damage_lower = 22
		melee_damage_upper = 25
		song_damage = 8
	return ..() // Doesn't change on Initialize so order doesn't matter here.

//Clown could be a bit faster, and a bit more damage
/mob/living/simple_animal/hostile/abnormality/clown/Initialize()
	if(IsCombatMap())
		move_to_delay = 2.3
		melee_damage_lower = 20
		melee_damage_upper = 20
	return ..()


/mob/living/simple_animal/hostile/abnormality/voiddream/Transform()
	if(IsCombatMap())
		return
	return ..()

//Porccubus gets a much shorter dash cooldown to better maneuver itself with how big of a commitment dashing is.
/mob/living/simple_animal/hostile/abnormality/porccubus/Initialize()
	if(IsCombatMap())
		maxHealth = 3000
		health = 3000
		ranged_cooldown_time = 0.5 SECONDS
	return ..()

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
	return ..()

//Der Freischutz gets 233% more damage
//This is to account for the fact his attack is highly choreographed and cannot pierce walls
/mob/living/simple_animal/hostile/abnormality/der_freischutz/Initialize()
	if(SSmaptype.maptype == "rcorp")
		bullet_damage = 200
	return ..()

//Due to Redblooded's very low damage and health, which is normaly fitting for a Teth. That causes them to underperform in R-Corp since they don't have any utility.
//For that reason his health is increased and let his ammo gimmick work by reducing his ranged cooldown.
/mob/living/simple_animal/hostile/abnormality/redblooded/Initialize()
	if(SSmaptype.maptype == "rcorp")
		ranged_cooldown_time = 0.5 SECONDS
		maxHealth = 1200
		health = 1200
		melee_damage_lower = 15
		melee_damage_upper = 20
		casingtype = /obj/item/ammo_casing/caseless/rcorp_true_patriot
	return ..()

/mob/living/simple_animal/hostile/abnormality/ppodae/Initialize()
	if(IsCombatMap())
		smash_damage_low = 32
		smash_damage_high = 40
	return ..()

//Warden deals even less damage then more bodies they eat, and they take more damage from all attacks.
//Warden currently slowballs far to quickly, so this nerf should give R-Corp a better chance at fighting back against them.
/mob/living/simple_animal/hostile/abnormality/warden/Initialize()
	if(IsCombatMap())
		damage_down = 10
	return ..()

//Censored no longer applies his statues effect passivly, Now he needs to hit his ranged attack to apply it.
//For that reason, I am reducing the cooldown for that ranged attack and lowering it's damage by around 50%, so they can at least try to apply it more often.
/mob/living/simple_animal/hostile/abnormality/censored/Initialize()
	if(SSmaptype.maptype == "rcorp")
		ability_damage = 120
		ability_cooldown_time = 6 SECONDS
	return ..()

//Nothing There passive healing will only start when they are under 50% health. But, I am increasing that healing by 50%.
/mob/living/simple_animal/hostile/abnormality/nothing_there/Initialize()
	if(SSmaptype.maptype == "rcorp")
		heal_percent_per_second = 0.01275
		r_corp_regen_start = 0.5
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/Initialize()
	if(IsCombatMap())
		initial_charge_damage = 200
		growing_charge_damage = 80
	return ..()
