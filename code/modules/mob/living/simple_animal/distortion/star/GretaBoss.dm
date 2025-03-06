/mob/living/simple_animal/hostile/distortion/Greta
	name = "Greta"
	desc = "You should probably run instead of gawking."
	icon = 'ModularTegustation/Teguicons/Ensemble64x64.dmi'
	icon_state = "Greta"
	icon_living = "Greta"
	var/icon_aggro = "Greta"
	icon_dead = "Greta"
	maxHealth = 22000
	health = 22000
	rapid_melee = 1
	ranged = TRUE
	damage_coeff = list(BRUTE = 0.1, RED_DAMAGE = 0.1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1)
	melee_damage_lower = 220
	melee_damage_upper = 250
	pixel_x = -15
	obj_damage = 80 //Y e s
	melee_damage_type = RED_DAMAGE
	see_in_dark = 10
	stat_attack = HARD_CRIT
	move_to_delay = 4
	attack_sound = 'sound/effects/ordeals/brown/flower_attack.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	attack_verb_continuous = "bites"
	attack_verb_simple = "bit"
	faction = list("hostile", "crimsonOrdeal", "bongy")
//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/city/ensemblegreta,
		/obj/item/ego_weapon/city/ensemble/greta
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Greta")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = FEMALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/butcher
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/clothing/suit/armor/ego_gear/city/ensembleweak)
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Black swan is the most strongly related to this guy, but I might make one for it later.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/mountain //She is quite a big eater, slitcurrent and dreaming have too much of differences despite being sharks.
	egoist_attributes = 130
	can_spawn = 0
	var/unmanifesting
	var/charging = FALSE
	var/revving_charge = FALSE
	var/charge_ready = FALSE
	var/greta_charge_cooldown = 0
	var/greta_charge_cooldown_time = 1
	var/deathcount
	var/heal_amount = 2500
	var/charge_damage = 2500
	var/eaten = FALSE
	var/damage_taken
	var/can_act = TRUE
	var/smash_cooldown
	var/smash_cooldown_time = 15
	var/smash_damage = 300
	can_patrol = TRUE
	attack_action_types = list(
		/datum/action/innate/abnormality_attack/toggle/greta_charge,
	)

/datum/action/innate/abnormality_attack/toggle/greta_charge
	name = "Tacke Mount"
	button_icon_state = "kog_charge" //placeholder, also recode toggle actions to not need this var
	chosen_attack_num = 0
	chosen_message = span_colossus("You won't charge anymore.")
	button_icon_toggle_activated = "kog_charge1"
	toggle_attack_num = 1 //Activate() and Deactivate() need to be flipped for this naming to make sense
	toggle_message = span_colossus("You will now triple charge to try devour the target you click on if damaged enough.")
	button_icon_toggle_deactivated = "kog_charge"

/mob/living/simple_animal/hostile/distortion/Greta/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

//breach code
/mob/living/simple_animal/hostile/distortion/Greta/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(revving_charge || charging) //ignore damage taken while charging, we reset it after a triple charge
		return
	if(. > 0)
		damage_taken += .
	if(damage_taken >= 500 && !charge_ready)
		charge_ready = TRUE

/mob/living/simple_animal/hostile/distortion/Greta/Goto(target, delay, minimum_distance)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/Greta/MoveToTarget(list/possible_targets)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/Greta/Move()
	if(revving_charge)
		return FALSE
	if(charging)
		new /obj/effect/temp_visual/decoy/fading(loc,src)
		DestroySurroundings() //to break tables ssin the way
	return ..()

/mob/living/simple_animal/hostile/distortion/Greta/AttackingTarget()
	if(revving_charge || charging)
		return
	if(greta_charge_cooldown <= world.time && prob(33) && !client && charge_ready)
		TripleCharge(target)
		return
	. = ..()

/mob/living/simple_animal/hostile/distortion/Greta/OpenFire()
	if(revving_charge || charging)
		return
	if(client && greta_charge_cooldown <= world.time && charge_ready)
		switch(chosen_attack)
			if(1)
				TripleCharge(target)
		return

	if(greta_charge_cooldown <= world.time && prob(33) && charge_ready)
		TripleCharge(target)

/mob/living/simple_animal/hostile/distortion/Greta/proc/TripleCharge(atom/target_atom)
	if(revving_charge || charging || greta_charge_cooldown > world.time)
		return
	for(var/i in 1 to 3)
		Charge(chargeat = target_atom, delay = (1 /(2*i))) //1 second, 0.5 second, 0.25 second delays
	ResetCharge()

//charge code
/mob/living/simple_animal/hostile/distortion/Greta/proc/Charge(atom/chargeat = target, delay = 1, chargepast = 3)
	if(stat == DEAD)
		return
	if(greta_charge_cooldown > world.time || charging || revving_charge)
		return
	if(!chargeat)
		return
	face_atom(chargeat)
	var/turf/T = get_ranged_target_turf(chargeat, dir, chargepast)
	if(!T)
		return
	var/turf/chargeturf = get_turf(chargeat)
	if(chargeturf) //for some reason this can end up being null
		new /obj/effect/temp_visual/cult/sparks(chargeturf) //in case the big effect is behind a wall
	new /obj/effect/temp_visual/dragon_swoop/bubblegum(T)
	icon_state = "Greta"
	revving_charge = TRUE
	charge_ready = FALSE
	walk(src, 0)
	if(!eaten) //different sfx before and after eating someone
		playsound(src, 'sound/abnormalities/clouded_monk/monk_cast.ogg', 100, 1)
	else
		playsound(src, 'sound/abnormalities/clouded_monk/monk_groggy.ogg', 150, 1)
	SLEEP_CHECK_DEATH(delay)
	if(!revving_charge) //to end charges prematurely
		return
	charging = TRUE
	revving_charge = FALSE
	var/movespeed = 0.8
	walk_towards(src, T, movespeed)
	SLEEP_CHECK_DEATH(get_dist(src, T) * movespeed)
	EndCharge()

/mob/living/simple_animal/hostile/distortion/Greta/proc/EndCharge()
	if(!charging)
		return
	charging = FALSE
	revving_charge = FALSE
	walk(src, 0) // cancel the movement
	icon_state = icon_aggro

/mob/living/simple_animal/hostile/distortion/Greta/proc/ResetCharge()
	greta_charge_cooldown = world.time + greta_charge_cooldown_time
	charge_ready = FALSE //redundancy is good
	damage_taken = 0

/mob/living/simple_animal/hostile/distortion/Greta/Bump(atom/A)
	if(charging)
		if(isliving(A))
			var/mob/living/L = A
			if(!faction_check_mob(L))
				visible_message(span_boldwarning("[src] bites [L]!"), span_boldwarning("You take a bite out of [L]!"), ignored_mobs = L)
				to_chat(L, span_userdanger("[src] takes a bite out of you!"))
				do_attack_animation(L, ATTACK_EFFECT_BITE)
				playsound(src, 'sound/abnormalities/clouded_monk/monk_bite.ogg', 75, 1)
				shake_camera(L, 4, 3)
				shake_camera(src, 2, 3)
				if(ishuman(L))
					var/mob/living/carbon/human/H = A
					H.deal_damage(charge_damage, RED_DAMAGE)
					if(H.health < 0)
						H.gib()
						adjustBruteLoss(-heal_amount)
						if(!eaten)
							playsound(src, 'sound/abnormalities/clouded_monk/eat.ogg', 75, 1)
							eaten = TRUE
						else
							playsound(src, 'sound/abnormalities/clouded_monk/eat_groggy.ogg', 75, 1)
				else
					L.adjustRedLoss(charge_damage/10)
				EndCharge()
				ResetCharge()
		else if(isvehicle(A))
			var/obj/vehicle/V = A
			V.take_damage(charge_damage/10, RED_DAMAGE)
			for(var/mob/living/occupant in V.occupants)
				to_chat(occupant, span_userdanger("Your [V.name] is bit by [src]!"))
	return ..()

	//AOE of golden apple would be down here, if I did not struggle too hard that is.

//The most dangerous base risk level. Even a color fixer is fucked honestly.