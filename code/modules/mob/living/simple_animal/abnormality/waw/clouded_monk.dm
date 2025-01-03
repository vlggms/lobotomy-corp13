//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/clouded_monk
	name = "Clouded Monk"
	desc = "An abnormality in the form of a tall Buddhist monk wearing a kasa hat."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "cloudedmonk"
	icon_living = "cloudedmonk"
	var/icon_aggro = "pretamonk"
	icon_dead = "pretamonk"
	portrait = "clouded_monk"
	maxHealth = 2500
	health = 2500
	rapid_melee = 2
	ranged = TRUE
	damage_coeff = list(BRUTE = 1.0, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 30
	melee_damage_upper = 45
	obj_damage = 22 //otherwise his charge just destroys everything
	melee_damage_type = RED_DAMAGE
	see_in_dark = 10
	stat_attack = HARD_CRIT
	threat_level = WAW_LEVEL
	attack_sound = 'sound/abnormalities/clouded_monk/monk_attack.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	attack_verb_continuous = "swipes"
	attack_verb_simple = "swipe"
	can_breach = TRUE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(20, 20, 55, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 45, 45, 45, 45),
		ABNORMALITY_WORK_REPRESSION = list(40, 20, 40, 40, 40),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/amrita,
		/datum/ego_datum/armor/amrita,
	)
	gift_type =  /datum/ego_gifts/amrita
	gift_message = "But if you were to consume them, perhaps, you would display more sarira than Buddha himself..."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "Are you a monk?"
	observation_choices = list(
		"I am no longer a monk" = list(TRUE, "A demon shall never reach Heaven."),
	)

	var/datum/looping_sound/cloudedmonk_ambience/soundloop
	var/charging = FALSE
	var/revving_charge = FALSE
	var/charge_ready = FALSE
	var/monk_charge_cooldown = 0
	var/monk_charge_cooldown_time = 6 SECONDS
	var/deathcount
	var/heal_amount = 250
	var/charge_damage = 350
	var/eaten = FALSE
	var/damage_taken

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/toggle/monk_charge,
		/datum/action/innate/change_icon_monk,
	)

/datum/action/innate/abnormality_attack/toggle/monk_charge
	name = "Toggle Triple Charge"
	button_icon_state = "kog_charge" //placeholder, also recode toggle actions to not need this var
	chosen_attack_num = 0
	chosen_message = span_colossus("You won't charge anymore.")
	button_icon_toggle_activated = "kog_charge1"
	toggle_attack_num = 1 //Activate() and Deactivate() need to be flipped for this naming to make sense
	toggle_message = span_colossus("You will now triple charge at the target you click on if damaged enough.")
	button_icon_toggle_deactivated = "kog_charge"


/datum/action/innate/change_icon_monk
	name = "Toggle Icon"
	desc = "Toggle your icon between breached and contained. (Works only for Limbus Company Labratories)"

/datum/action/innate/change_icon_monk/Activate()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		owner.icon = 'ModularTegustation/Teguicons/32x48.dmi'
		owner.icon_state = "cloudedmonk"
		active = 1

/datum/action/innate/change_icon_monk/Deactivate()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		owner.icon = 'ModularTegustation/Teguicons/32x48.dmi'
		owner.icon_state = "pretamonk"
		active = 0

//init
/mob/living/simple_animal/hostile/abnormality/clouded_monk/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath)) // Hell
	if(SSmaptype.maptype != "limbus_labs")
		soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/clouded_monk/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/OnMobDeath(datum/source, mob/living/died, gibbed) //stolen from big bird
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	deathcount++
	if(deathcount >= 2)
		datum_reference.qliphoth_change(-1) // Two deaths reduces it compared to base 10
		deathcount = 0
	return TRUE

/* Eventually there needs to be code here that causes it to breach when Yin gets too close. Yin is not implemented at this time. */
//work code
/mob/living/simple_animal/hostile/abnormality/clouded_monk/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/clouded_monk/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/clouded_monk/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		user.adjustSanityLoss(-30) // It's healing
		to_chat(user, span_nicegreen("[src] guides you through a session of meditation."))
	return

/mob/living/simple_animal/hostile/abnormality/clouded_monk/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	soundloop.start()
	playsound(src, 'sound/abnormalities/clouded_monk/howl.ogg', 50, 1)
	playsound(src, 'sound/abnormalities/clouded_monk/transform.ogg', 50, 1)
	icon_state = icon_aggro
	desc = "A monk that has forgotten he has become a demon. It resembles a preta from legends."
	GiveTarget(user)

//breach code
/mob/living/simple_animal/hostile/abnormality/clouded_monk/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(revving_charge || charging) //ignore damage taken while charging, we reset it after a triple charge
		return
	if(. > 0)
		damage_taken += .
	if(damage_taken >= 200 && !charge_ready)
		charge_ready = TRUE

/mob/living/simple_animal/hostile/abnormality/clouded_monk/Goto(target, delay, minimum_distance)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/clouded_monk/MoveToTarget(list/possible_targets)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/clouded_monk/Move()
	if(revving_charge)
		return FALSE
	if(charging)
		new /obj/effect/temp_visual/decoy/fading(loc,src)
		DestroySurroundings() //to break tables ssin the way
	return ..()

/mob/living/simple_animal/hostile/abnormality/clouded_monk/AttackingTarget()
	if(revving_charge || charging)
		return
	if(monk_charge_cooldown <= world.time && prob(33) && !client && charge_ready)
		TripleCharge(target)
		return
	. = ..()

/mob/living/simple_animal/hostile/abnormality/clouded_monk/OpenFire()
	if(revving_charge || charging)
		return
	if(client && monk_charge_cooldown <= world.time && charge_ready)
		switch(chosen_attack)
			if(1)
				TripleCharge(target)
		return

	if(monk_charge_cooldown <= world.time && prob(33) && charge_ready)
		TripleCharge(target)

/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/TripleCharge(atom/target_atom)
	if(revving_charge || charging || monk_charge_cooldown > world.time)
		return
	for(var/i in 1 to 3)
		Charge(chargeat = target_atom, delay = (2 SECONDS/(2*i))) //1 second, 0.5 second, 0.25 second delays
	ResetCharge()

//charge code
/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/Charge(atom/chargeat = target, delay = 1 SECONDS, chargepast = 3)
	if(stat == DEAD)
		return
	if(monk_charge_cooldown > world.time || charging || revving_charge)
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
	icon_state = "pretarage"
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

/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/EndCharge()
	if(!charging)
		return
	charging = FALSE
	revving_charge = FALSE
	walk(src, 0) // cancel the movement
	icon_state = icon_aggro

/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/ResetCharge()
	monk_charge_cooldown = world.time + monk_charge_cooldown_time
	charge_ready = FALSE //redundancy is good
	damage_taken = 0

/mob/living/simple_animal/hostile/abnormality/clouded_monk/Bump(atom/A)
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
