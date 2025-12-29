/mob/living/simple_animal/hostile/ordeal/mermaid_strand
	name = "mermaid of the thousand strands"
	desc = "A creature from the depths of an unknown lake with grey waters"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "scarymerm"
	icon_living = "scarymerm"
	icon_dead = "scarymerm_dead"
	faction = list("whale")
	pixel_x = -16
	maxHealth = 250
	health = 250
	melee_damage_type = BLACK_DAMAGE//Todo: deal white damage and apply a special panic. Either one that makes you jump overboard, or die to the whale.
	damage_coeff = list(RED_DAMAGE = 1.1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.1, PALE_DAMAGE = 1.8)
	melee_damage_lower = 3
	melee_damage_upper = 5
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/creatures/lc13/lake_entity/strand_attack_1.ogg'
	speak_emote = list("burbles")
	ranged = 1
	ranged_cooldown_time = 300
	butcher_results = list(/obj/item/food/meat/slab/mermaid = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/mermaid = 1)
	var/list/breach_affected = list()
	var/aiming
	var/pulse_damage = 20

/mob/living/simple_animal/hostile/ordeal/mermaid_strand/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	FearEffect()

/mob/living/simple_animal/hostile/ordeal/mermaid_strand/OpenFire()
	if(aiming)
		return
	TakeAim(target)
	if(aiming)
		aiming = FALSE

/mob/living/simple_animal/hostile/ordeal/mermaid_strand/CanAttack(atom/the_target)
	if(aiming)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/mermaid_strand/Move()
	if(aiming)
		return FALSE
	return ..()

// Applies fear damage to everyone in range, copied from abnormalities
/mob/living/simple_animal/hostile/ordeal/mermaid_strand/proc/FearEffect()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in breach_affected)
			continue
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			continue
		breach_affected += H
		H.adjustSanityLoss(H.getMaxSanity() * 0.05)
		H.stuttering = 20
		if(H.sanity_lost)
			H.SanityLossEffect(PRUDENCE_ATTRIBUTE)
			continue
		to_chat(H, span_warning("Damn, it's scary."))

/mob/living/simple_animal/hostile/ordeal/mermaid_strand/proc/TakeAim(target)
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(src, 'sound/creatures/lc13/lake_entity/shot_1.ogg', 100)
	aiming = TRUE
	flick("scarymerm_open", src)
	sleep(3 SECONDS)
	PulseAttack()

/mob/living/simple_animal/hostile/ordeal/mermaid_strand/proc/PulseAttack()
	playsound(src, 'sound/creatures/lc13/lake_entity/strand_scream_1.ogg', 100)
	for(var/mob/living/carbon/human/H in view(8, src))
		if(H.z != z)
			continue
		H.deal_damage(pulse_damage, WHITE_DAMAGE)
		H.stuttering = 20
		if(H.sanity_lost)
			H.SanityLossEffect(PRUDENCE_ATTRIBUTE)

