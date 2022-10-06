#define STATUS_EFFECT_TRICKED /datum/status_effect/tricked
/mob/living/simple_animal/hostile/abnormality/laetitia
	name = "Laetitia"
	desc = "A wee witch."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "laetitia"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.9)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 45, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 60, 65, 65),
		ABNORMALITY_WORK_REPRESSION = 0
			)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	max_boxes = 16 // Accurate to base game

	ranged = TRUE
	ranged_cooldown = 30 SECONDS

	ego_list = list(
		/datum/ego_datum/weapon/prank,
		/datum/ego_datum/armor/prank
		)
	gift_type = /datum/ego_gifts/prank

	var/list/hugged = list()
	var/remove_hugged_cooldown = 4 MINUTES
	COOLDOWN_DECLARE(less_hugged)

/mob/living/simple_animal/hostile/abnormality/laetitia/Initialize(mapload)
	. = ..()
	COOLDOWN_START(src, less_hugged, remove_hugged_cooldown)

/mob/living/simple_animal/hostile/abnormality/laetitia/Life()
	. = ..()
	if(!.)
		return
	if(status_flags & GODMODE)
		return
	if(LAZYLEN(hugged) && COOLDOWN_FINISHED(src, less_hugged)) // People the hugged list?
		hugged -= hugged[0] // Remove the first
		COOLDOWN_START(src, less_hugged, remove_hugged_cooldown)

/mob/living/simple_animal/hostile/abnormality/laetitia/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	GiveGift(user, 70)	//Not 100% of the time to be funny

/mob/living/simple_animal/hostile/abnormality/laetitia/OpenFire(atom/A)
	ToggleDash()
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/abnormality/laetitia/breach_effect(mob/living/carbon/human/user)
	. = ..()
	fear_level--

/mob/living/simple_animal/hostile/abnormality/laetitia/proc/ToggleDash()
	if(move_to_delay != initial(move_to_delay))
		move_to_delay = initial(move_to_delay)
		return
	move_to_delay = 1.5 // She sprints up to you to hug you.
	addtimer(CALLBACK(src, .proc/ToggleDash), 5 SECONDS)

/mob/living/simple_animal/hostile/abnormality/laetitia/AttackingTarget(atom/attacked_target)
	GiveGift(target, 40) // She goes around hugging people. That's it.
	hugged += target

/mob/living/simple_animal/hostile/abnormality/laetitia/ListTargets()
	. = ..()
	for(var/mob/living/L in .)
		if(ishuman(L))
			if(L in hugged)
				. -= L
		else
			. -= L

/mob/living/simple_animal/hostile/abnormality/laetitia/proc/GiveGift(mob/living/carbon/human/H = null, chance = 0)
	if(isnull(H))
		return FALSE
	manual_emote("hugs [H]!")
	playsound(src, "sound/effects/rustle[pick(1,2,3,4,5)].ogg", 80)
	if(prob(chance))
		H.apply_status_effect(STATUS_EFFECT_TRICKED)
		if(get_attribute_level(H, PRUDENCE_ATTRIBUTE) >= 80)
			to_chat(H, "<span class='warning'>You feel something pulsing in your pocket...</span>")

//Her friend
/mob/living/simple_animal/hostile/gift
	name = "Little Witch's Friend"
	desc = "It's a horrifying amalgamation of flesh and eyes"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "witchfriend"
	icon_living = "witchfriend"
	icon_dead = "witchfriend_dead"
	maxHealth = 800
	health = 800
	pixel_x = -16
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	stat_attack = HARD_CRIT
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/abnormalities/laetitia/spider_attack.ogg'
	deathsound = 'sound/abnormalities/laetitia/spider_dead.ogg'

/mob/living/simple_animal/hostile/gift/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/laetitia/spider_born.ogg', 50, 1)

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
	alert_type = null

/datum/status_effect/tricked/on_creation(mob/living/new_owner, ...)
	duration = rand(2 MINUTES, 5 MINUTES) //blows up after 2-5 minutes
	..()

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
		L.apply_damage(150, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		// Usually a kill, you can block it if you're good
		// Lowering it because it's a bit randomized now.

#undef STATUS_EFFECT_TRICKED
