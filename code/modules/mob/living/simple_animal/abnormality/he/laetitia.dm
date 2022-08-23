#define STATUS_EFFECT_TRICKED /datum/status_effect/tricked
/mob/living/simple_animal/hostile/abnormality/laetitia
	name = "Laetitia"
	desc = "A wee witch."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "laetitia"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 45, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 60, 65, 65),
		ABNORMALITY_WORK_REPRESSION = 0
			)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/prank,
		/datum/ego_datum/armor/prank
		)

/mob/living/simple_animal/hostile/abnormality/laetitia/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(70))	//Not 100% of the time to be funny
		user.apply_status_effect(STATUS_EFFECT_TRICKED)

//Her friend
/mob/living/simple_animal/hostile/gift
	name = "Little Witch's Friend"
	desc = "It's a horrifying amalgamation of flesh and eyes"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "witchfriend"
	icon_living = "witchfriend"
	icon_dead = "witchfriend_dead"
	maxHealth = 700
	health = 700
	pixel_x = -16
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "pokes"
	attack_verb_simple = "pokes"
	attack_sound = 'sound/abnormalities/fragment/attack.ogg'

/mob/living/simple_animal/hostile/gift/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//Tricked
//Explodes after 5 minutes
/datum/status_effect/tricked
	id = "tricked"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000		//blows up after 5 minutes
	alert_type = null

/datum/status_effect/tricked/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(L, "<span class='userdanger'>You feel something deep in your body explode!</span>")
		var/location = get_turf(L)
		new /mob/living/simple_animal/hostile/gift(location)
		var/rand_dir = pick(NORTH, SOUTH, EAST, WEST)
		var/atom/throw_target = get_edge_target_turf(L, rand_dir)
		if(!L.anchored)
			L.throw_at(throw_target, rand(1, 3), 7, L)
		L.apply_damage(200, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)//Usually a kill, you can block it if you're good

#undef STATUS_EFFECT_TRICKED
