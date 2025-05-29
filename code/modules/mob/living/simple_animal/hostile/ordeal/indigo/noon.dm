/mob/living/simple_animal/hostile/ordeal/indigo_noon
	name = "sweeper"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "sweeper_1"
	icon_living = "sweeper_1"
	icon_dead = "sweeper_dead"
	faction = list("indigo_ordeal")
	maxHealth = 500
	health = 500
	move_to_delay = 4
	stat_attack = DEAD
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 24
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)
	blood_volume = BLOOD_VOLUME_NORMAL
	silk_results = list(/obj/item/stack/sheet/silk/indigo_advanced = 1,
						/obj/item/stack/sheet/silk/indigo_simple = 2)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/Initialize()
	. = ..()
	attack_sound = "sound/effects/ordeals/indigo/stab_[pick(1,2)].ogg"
	icon_living = "sweeper_[pick(1,2)]"
	icon_state = icon_living

/mob/living/simple_animal/hostile/ordeal/indigo_noon/Aggro()
	. = ..()
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	if(SSmaptype.maptype in SSmaptype.citymaps)
		return FALSE
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	if(istype(L, SWEEPER_TYPES))
		adjustBruteLoss(-20)
	else
		adjustBruteLoss(-(maxHealth/2))
	L.gib()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_noon/PickTarget(list/Targets)
	if(health <= maxHealth * 0.6) // If we're damaged enough
		for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/sweeper in ohearers(7, src)) // And there is no sweepers even more damaged than us
			if(sweeper.stat != DEAD && (health > sweeper.health))
				return ..()
		var/list/highest_priority = list()
		for(var/mob/living/L in Targets)
			if(!CanAttack(L))
				continue
			if(L.health < 0 || L.stat == DEAD)
				highest_priority += L
		if(LAZYLEN(highest_priority))
			return pick(highest_priority)
	var/list/lower_priority = list() // We aren't exactly damaged, but it'd be a good idea to finish the wounded first
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(L.health < L.maxHealth*0.5 && (L.stat < UNCONSCIOUS))
			lower_priority += L
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky
	health = 250
	maxHealth = 250
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "sweeper_limbus"
	icon_living = "sweeper_limbus"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands.\n This one seems to move with far more agility than its peers."
	move_to_delay = 3
	rapid_melee = 2
	melee_damage_lower = 11
	melee_damage_upper = 13

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Initialize()
	. = ..()
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_2.ogg'

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky
	health = 600
	maxHealth = 600
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sweeper_limbus"
	icon_living = "sweeper_limbus"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands.\n This one has more bulk than its peers - it wouldn't be difficult for it to pin you down."
	move_to_delay = 5
	rapid_melee = 0.8

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/Initialize()
	. = ..()
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
