/*
 ~ Coded by Mel Taculo

 !!!!!!!!!
Olha a sua agenda pra referencia de design de kd bixo
 !!!!!!!!!

--- TECHNOLOGY LIBERATION ALLIANCE ---
Enemies from Limbus company,
Represents a full set of enemies specialized in RED and BLACK damage and a few different gimmicks.
Robots have a binary system of staggering mechanics that complement eachother.
Human EGO enemies culminate into a boss enemy meant to be fought in end game city gear, this boss integrates all gimicks of all enemies here (teach them little by little).

Wrecking Bot - HE - Self Stun, AoE, faster.
Sawing Bot - HE - Constant Threat, Stunned by taking too many hits.

Sloshing - TETH - Increasing self barrier and typsiness (drunkess)
Red Sheet - TETH - Self accumulating stacks, Big damage attack on stacks, Takes damage by taking too many hits while stacked.
Red Sheet Elite - HE - Self accumulating stacks, Big damage RANGED attack on stacks, Takes damage by taking too many hits while stacked.
Sunshower - HE - Switches between agression and defense, High mobility dashes, Guard reflect stance.
Sunshower Elite - WAW - Switches between agression and defense, High mobility dashes, Guard reflect stance + minion summoning, Punishment for not killing minions.
Spicebush - ALEPH - Switches between agression and defense, High mobility dashes, Ranged + AoE focused defensive stance, Minion summoning, Punishment for not killing minions,
Self accumulating stacks, Payoff attacks that spend stacks, Takes damage by taking too many hits while stacked. (fuck you thats why)
*/

/mob/living/simple_animal/hostile/tech_liberation
	name = "tech liberation member"
	desc = "They forgot their EGO at home..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	faction = list("hostile")
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = TRUE
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	stat_attack = HARD_CRIT
	melee_damage_type = BLACK_DAMAGE
	butcher_results = list(/obj/item/food/meat/slab = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 1)
	blood_volume = BLOOD_VOLUME_NORMAL
	mob_size = MOB_SIZE_HUGE
	a_intent = INTENT_HARM

//TETH goon
/mob/living/simple_animal/hostile/tech_liberation/sloshing
	name = "liberation alliance Sloshing EGO user"
	desc = ""
	icon_state = "sloshing"
	icon_living = "sloshing"
	maxHealth = 300
	health = 300
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_sound = 'sound/weapons/fixer/generic/knife2.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"

	var/tipsy = 0 //Maximum of 5, the higher the tipsiness the less likely it is to sucesfully attack and walk correctly, but generates a bigger shield periodically.

	var/shield = 0
	var/shield_cooldown
	var/shield_cooldown_time = 30 SECONDS
	var/shield_amount = 50 //Multiplied by tipsy stacks, goes up to 300

/mob/living/simple_animal/hostile/tech_liberation/sloshing/proc/ShieldSelf()
	shield_cooldown = world.time + shield_cooldown_time

	shield = shield_amount * (tipsy + 1)
	tipsy = 0

/mob/living/simple_animal/hostile/tech_liberation/sloshing/AttackingTarget(target)
	if(shield_cooldown <= world.time)
		ShieldSelf()
		return

	if(prob (15 * tipsy)) //The drunker we are the higher probability to fail attacking
		to_chat(user, span_notice("[src] stumbles drunkly!"))
		return
	if(tipsy < 5) //Gets drunker on every hit
		tipsy ++
	. = ..()

/mob/living/simple_animal/hostile/tech_liberation/sloshing/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(shield)
		shield -= amount
		if(shield < 0) //If we dont have any more shield, deal the remaining damage to our health.
			amount = (shield *-1)
			shield = 0
		else //We still have shield, no damage is dealt.
			amount = 0
	. = ..()

//ADD AN OVERLAY/VISUAL INDICATOR OF THE SHIELD

/mob/living/simple_animal/hostile/tech_liberation/red_sheet
	name = "liberation alliance Red Sheet EGO user"
	desc = ""
	icon_state = "red_sheet"
	icon_living = "red_sheet"
	maxHealth = 300
	health = 300
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	melee_damage_lower = 20
	melee_damage_upper = 22
	attack_sound = 'sound/weapons/fixer/generic/knife2.ogg'
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"

	var/talisman = 0
	var/talisman_damage = 40 //BLACK
	var/talisman_self_damage = 150 //BRUTE

	var/hits_taken //Used when talismans are at maximum to explode whenever a certain amount is reached

/mob/living/simple_animal/hostile/tech_liberation/red_sheet/AttackingTarget(target)
	if(talisman < 6)
		talisman ++
		if (talisman = 6)
			//Animation stuff goes here
	else
		target.apply_damage(talisman_damage, BLACK_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		.= ..()

/mob/living/simple_animal/hostile/tech_liberation/sloshing/red_sheet/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(talisman = 6)
		hits_taken += 1
		amount += (maxHealth/2)
	. = ..()
