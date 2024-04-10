/*
 ~ Coded by Mel Taculo
--- TECHNOLOGY LIBERATION ALLIANCE ---
Enemies from Limbus company,
Represents a full set of enemies specialized in RED and BLACK damage and a few different gimmicks.
Robots have a binary system of staggering mechanics that complement eachother.
Human EGO enemies culminate into a boss enemy meant to be fought in end game city gear, this boss integrates all gimicks of all enemies here (teach them little by little).

Wrecking Bot - HE - Self Stun, AoE, faster.
Sawing Bot - HE - Constant Threat, Stunned by taking too many hits.

Sloshing - Gets tipsy on hit, miss attacks based on how tipsy they are.
Heavy Sloshing - Gain shield every so often based on how tipsy they are.
Churning Sloshing - Get tipsy on hit, every so often hit with a special knockback attack that knocks you back and deals mroe damage the more tipsy they are.
Sloshing - TETH - Increasing self barrier and typsiness (drunkess)
Red Sheet - TETH - Self accumulating stacks, Big damage attack on stacks, Takes damage by taking too many hits while stacked.
Red Sheet Elite - HE - Self accumulating stacks, Big damage RANGED attack on stacks, Takes damage by taking too many hits while stacked.
Sunshower - HE - Switches between agression and defense, High mobility dashes, Guard reflect stance into Puddle Stomp.
Sunshower Elite - WAW - Switches between agression and defense, High mobility dashes, Guard reflect stance + minion summoning, Punishment for not killing minions with multi dashes and Puddle Stomp.
*/
/mob/living/simple_animal/hostile/humanoid/tech_liberation
	name = "tech liberation member"
	desc = "They forgot their EGO at home..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'

/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing
	name = "liberation alliance Sloshing EGO user"
	desc = ""
	icon_state = "sloshing"
	icon_living = "sloshing"
	maxHealth = 300
	health = 300
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	melee_damage_lower = 20
	melee_damage_upper = 25
	melee_damage_type = BLACK_DAMAGE
	attack_sound = 'sound/weapons/fixer/generic/knife2.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"

	var/tipsy = 0 //the higher the tipsiness the less likely it is to sucesfully attack and walk correctly, but generates a bigger shield periodically.
	var/tipsy_max = 5
	var/tipsy_fail_chance = 15

/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/AttackingTarget(atom/attacked_target)
	if(prob (tipsy_fail_chance * tipsy)) //The drunker we are the higher probability to fail attacking
		visible_message("[src] stumbles drunkly!")
		do_shaky_animation(0.5) //TODO: Change to a better animation.
		return
	if(tipsy < tipsy_max) //Gets drunker on every hit
		tipsy ++
	return ..()

//TETH goon
/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/heavy
	name = "liberation alliance heavy Sloshing EGO user"
	desc = ""
	icon_state = "sloshing"
	icon_living = "sloshing"
	melee_damage_lower = 20
	melee_damage_upper = 25

	var/shield = 0
	var/shield_cooldown
	var/shield_cooldown_time = 30 SECONDS
	var/shield_amount = 50 // Multiplied by tipsy stacks.

/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/heavy/AttackingTarget(atom/attacked_target)
	if(shield_cooldown <= world.time)
		ShieldSelf()
		return
	return ..()

/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/heavy/proc/ShieldSelf()
	shield_cooldown = world.time + shield_cooldown_time
	visible_message("[src] is covered by a slimy protective substance!")
	shield = shield_amount * (tipsy + 1)
	tipsy = 0

/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/heavy/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(shield)
		shield -= amount
		if(shield < 0) // If we dont have any more shield, deal the remaining damage to our health.
			amount = (shield * -1)
			shield = 0
		else // We still have shield, no damage is dealt.
			amount = 0
	. = ..()


/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/churning
	name = "liberation alliance churning Sloshing EGO user"
	desc = ""
	icon_state = "sloshing"
	icon_living = "sloshing"
	melee_damage_lower = 26
	melee_damage_upper = 32

	var/slime_cooldown
	var/slime_cooldown_time = 20 SECONDS
	var/slime_damage = 25
	var/slime_damage_multiplier = 5
	var/slime_knockback = 1


/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/churning/AttackingTarget(atom/attacked_target)
	if(slime_cooldown <= world.time)
		if(isliving(target))
			ChurningSlime(target)
		return
	return ..()

/mob/living/simple_animal/hostile/humanoid/tech_liberation/sloshing/churning/proc/ChurningSlime(mob/living/target)
	if(!isliving(target))
		return
	playsound(get_turf(src), 'sound/abnormalities/apocalypse/swing.ogg', 75, 0, 3) //TODO: SWAP THIS SOUND
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	if(!target.Adjacent(targets_from))
		return

	slime_cooldown = world.time + slime_cooldown_time
	visible_message(span_danger("[src] splashes into [target] with the corrosive slime!"))
	var/total_damage = slime_damage + (slime_damage_multiplier * tipsy)
	target.apply_damage(total_damage, BLACK_DAMAGE, null, target.run_armor_check(null, BLACK_DAMAGE))
	
	//Apply knockback to target.
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src,target))
	if(!target.anchored)
		target.safe_throw_at(throw_target, slime_knockback * tipsy, 20, src, gentle = TRUE)
	tipsy = 0

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet
	name = "liberation alliance Red Sheet EGO user"
	desc = ""
	icon_state = "red_sheet"
	icon_living = "red_sheet"
	maxHealth = 300
	health = 300
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	melee_damage_lower = 10
	melee_damage_upper = 11
	rapid_melee = 2
	attack_sound = 'sound/weapons/fixer/generic/knife2.ogg'
	attack_verb_continuous = "whacks"
	attack_verb_simple = "whack"

	var/can_act = TRUE
	var/talisman = 0
	var/talisman_max = 6
	var/talisman_damage = 10 //BLACK
	var/talisman_loss_on_taking_damage = 2
	var/talisman_self_damage = 150 //BRUTE
	var/dash_range = 5
	var/dash_initial_range = 3

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(can_act)
		return ..()
	if(talisman > 0)
		talisman -= talisman_loss_on_taking_damage
		return ..()
	talisman = 0
	can_act = TRUE
	amount += talisman_self_damage
	//TODO ADD SOUNDS AND VISUALS HERE
	return ..()	

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	if(talisman < talisman_max)
		talisman ++
		return ..()
	PrepareAttack(target);

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/proc/PrepareAttack(target)	
	can_act = FALSE
	var/dash_dir = REVERSE_DIR(get_dir(src, target))
	var/turf/dash_target = get_edge_target_turf(src, dash_dir)
	Dash(dash_target, initial = TRUE)
	addtimer(CALLBACK(src, PROC_REF(SpecialAttack), target), 2.5 SECONDS)

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/proc/SpecialAttack(mob/living/target)
	//TODO add visuals and feedback
	Dash(get_turf(target), initial = FALSE)
	can_act = TRUE
	var/total_damage = talisman * talisman_damage
	talisman = 0
	if(!isliving(target))
		return
	if(!target.Adjacent(targets_from))
		return
	target.apply_damage(total_damage, BLACK_DAMAGE, null, target.run_armor_check(null, BLACK_DAMAGE))

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/proc/Dash(turf/dash_target, initial = FALSE)
	//TODO ADD SOUNDS
	var/turf/dash_start = get_turf(src)
	var/dash_line = getline(dash_start, dash_target)
	var/current_dash_tile = 0
	var/dash_max_range = dash_range
	if(initial)
		dash_max_range = dash_initial_range
	for(var/turf/T in dash_line)
		current_dash_tile ++
		if(current_dash_tile >= dash_range)
			return
		if(T.density)
			return
		face_atom(target)
		forceMove(T)
		SLEEP_CHECK_DEATH(0.05 SECONDS)

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/hooded
	name = "liberation alliance hooded Red Sheet EGO user"
	desc = ""
	icon_state = "red_sheet_elite"
	icon_living = "red_sheet_elite"
	maxHealth = 900
	health = 900
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	melee_damage_lower = 20
	melee_damage_upper = 22
	rapid_melee = 2
	attack_sound = 'sound/weapons/fixer/generic/knife2.ogg'
	attack_verb_continuous = "whacks"
	attack_verb_simple = "whack"

	talisman_damage = 20
	talisman_loss_on_taking_damage = 1
	talisman_self_damage = 300
	dash_range = 7
	dash_initial_range = 4

/mob/living/simple_animal/hostile/humanoid/tech_liberation/red_sheet/hooded/SpecialAttack(atom/target)
	//TODO add visuals and feedback
	var/total_damage = talisman * talisman_damage
	talisman = 0
	if(!(target in view(dash_range, src)))
		var/turf/start_turf = get_turf(src)
		var/obj/projectile/talisman/P = new(start_turf)
		P.starting = start_turf
		P.firer = src
		P.fired_from = start_turf
		P.yo = target.y - start_turf.y
		P.xo = target.x - start_turf.x
		P.original = target
		P.preparePixelProjectile(target, start_turf)
		P.damage = total_damage * 1.5
		P.fire()
		can_act = TRUE
		return
	Dash(get_turf(target), initial = FALSE)
	can_act = TRUE
	for(var/turf/T in view(1, src))
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), total_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)

/obj/projectile/talisman //TODO Pretty this up
	name = "talisman"
	desc = ""
	icon_state = "despair"
	damage_type = BLACK_DAMAGE
	damage = 40
