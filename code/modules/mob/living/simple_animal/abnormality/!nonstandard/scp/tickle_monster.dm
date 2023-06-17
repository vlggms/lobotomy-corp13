/mob/living/simple_animal/hostile/abnormality/tickle_monster
	name = "The Tickle Monster"
	desc = "An orange blob that is always looking for a hug."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "999"
	icon_living = "999"
	is_flying_animal = TRUE
	maxHealth = 600	//It is helpful and therefore weak.
	health = 600
	//work stuff
	can_breach = TRUE
	start_qliphoth = 4
	threat_level = ZAYIN_LEVEL
	work_damage_amount = 4
	work_damage_type = WHITE_DAMAGE

	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	melee_damage_lower = 0
	melee_damage_upper = 0
	melee_damage_type = WHITE_DAMAGE
	faction = list("neutral", "hostile")	//Mostly Just vibes
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(90, 80, 75, 60, 60),
						ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 40, 40),
						ABNORMALITY_WORK_ATTACHMENT = list(90, 80, 75, 60, 60),
						ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 40, 40),
						"Release" = 0
						)
	ego_list = list(
//		/datum/ego_datum/weapon/hugs,
		/datum/ego_datum/armor/hugs
		)
//	gift_type = /datum/ego_gifts/hugs
	abnormality_origin = ABNORMALITY_ORIGIN_SCP

	//slowly heals sanity over time
	var/heal_cooldown
	var/heal_cooldown_time = 3 SECONDS
	var/heal_amount = 5


/mob/living/simple_animal/hostile/abnormality/tickle_monster/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((heal_cooldown < world.time) && !(status_flags & GODMODE))
		HealPulse()

/mob/living/simple_animal/hostile/abnormality/tickle_monster/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/on_mob_death) // Hell

/mob/living/simple_animal/hostile/abnormality/tickle_monster/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()


/mob/living/simple_animal/hostile/abnormality/tickle_monster/proc/HealPulse()
	heal_cooldown = world.time + heal_cooldown_time

	for(var/mob/living/carbon/human/H in livinginview(15, src))
		if(H.stat == DEAD)
			continue
		H.adjustSanityLoss(-heal_amount) // It's healing
		new /obj/effect/temp_visual/emp/pulse(get_turf(H))


/mob/living/simple_animal/hostile/abnormality/tickle_monster/BreachEffect(mob/living/carbon/human/user)
	..()
	icon_state = "999_breach"

/mob/living/simple_animal/hostile/abnormality/tickle_monster/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	return TRUE
