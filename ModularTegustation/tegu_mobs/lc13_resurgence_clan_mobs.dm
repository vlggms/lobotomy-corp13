/mob/living/simple_animal/hostile/clan
	name = "Clan Member..."
	desc = "You should not bee seeing this!"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "clan_scout"
	icon_living = "clan_scout"
	icon_dead = "clan_scout_dead"
	faction = list("resurgence_clan", "hostile")
	mob_biotypes = MOB_ROBOTIC
	gender = NEUTER
	speech_span = SPAN_ROBOT
	emote_hear = list("creaks.", "emits the sound of grinding gears.")
	maxHealth = 500
	health = 500
	death_message = "falls to their knees as their lights slowly go out..."
	melee_damage_lower = 15
	melee_damage_upper = 19
	mob_size = MOB_SIZE_LARGE
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	var/charge = 0
	var/max_charge = 10


/mob/living/simple_animal/hostile/clan/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(GainCharge)), 2 SECONDS)

/mob/living/simple_animal/hostile/clan/proc/GainCharge()
	if (charge < max_charge)
		charge += 1
		ChargeUpdated()
	addtimer(CALLBACK(src, PROC_REF(GainCharge)), 2 SECONDS)

/mob/living/simple_animal/hostile/clan/proc/ChargeUpdated()


//Clan Member: Scout
/mob/living/simple_animal/hostile/clan/scout
	name = "Scout"
	desc = "A humanoid looking machine wielding a spear... It appears to have 'Resurgence Clan' etched on their back..."
	var/max_speed = 1.5
	var/normal_speed = 3
	var/max_attack_speed = 4
	var/normal_attack_speed = 1

/mob/living/simple_animal/hostile/clan/scout/ChargeUpdated()
	move_to_delay = normal_speed - (normal_speed - max_speed) * charge / max_charge
	rapid_melee = normal_attack_speed + (max_attack_speed - normal_attack_speed) * charge / max_charge
	UpdateSpeed()
	var/flamelayer = layer + 0.1
	var/flame
	if(charge > 7)
		cut_overlays()
		flame = "scout_blue"
	else if(charge > 3)
		cut_overlays()
		flame = "scout_red"
	else
		cut_overlays()
		return
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, flame, flamelayer)
	add_overlay(colored_overlay)

/mob/living/simple_animal/hostile/clan/scout/AttackingTarget()
	. = ..()
	if (charge > 0)
		charge -= 1

//Clan Member: Defender
/mob/living/simple_animal/hostile/clan/defender
	name = "Defender"
	desc = "A humanoid looking machine with 2 shields... It appears to have 'Resurgence Clan' etched on their back..."
