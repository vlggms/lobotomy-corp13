// this was a mistake.
// By yours truely, Mori.
#define STATUS_EFFECT_UMBRELLADEBUFF /datum/status_effect/display/falsekindness
/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A large shaggy fox with gleaming yellow eyes; And torn umbrellas lodged into its back."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "drifting_fox"
	icon_living = "drifting_fox"
	icon_dead = "fox_egg"
	deathmessage = "Collapses into a Glass Egg"
	deathsound = 'sound/abnormalities/driftingfox/fox_death_sound.ogg'
	pixel_x = -24
	pixel_y = -26
	base_pixel_x = -24
	base_pixel_y = -26
	del_on_death = FALSE
	maxHealth = 1000
	health = 1000
	rapid_melee = 3
	move_to_delay = 2
	damage_coeff = list( RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5 )
	melee_damage_lower = 5
	melee_damage_upper = 35 // Idea taken from the old PR, have a large damage range to immitate its fucked rolls and crit chance.
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/driftingfox/fox_melee_sound.ogg'
	attack_verb_simple = "thwacks"
	attack_verb_continuous = "thwacks"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = list(25,30,35,40,45),
		ABNORMALITY_WORK_REPRESSION	= 0,
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	ego_list = list(
		/datum/ego_datum/weapon/sunshower,
		/datum/ego_datum/armor/sunshower
		)

	var/list/pet = list()
	pet_bonus = "yips"
/mob/living/simple_animal/hostile/abnormality/drifting_fox/funpet(mob/petter)
	pet+=petter

/mob/living/simple_animal/hostile/abnormality/drifting_fox/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(user in pet)
		if(work_type == ABNORMALITY_WORK_ATTACHMENT)
			chance+=30
		return chance

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in pet)
		pet-=user

	gift_type = /datum/ego_gifts/sunshower // NEED TO ACTAULLY MAKE THE GIFT / EGOS
	gift_message = "The fox plucks an umbrella from its back and gives it to you, perhaphs in thanks?"

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) <= 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/drifting_fox/BreachEffect(mob/living/carbon/human/user)
	..()
	playsound(src, 'sound/abnormalities/porccubus/head_explode_laugh.ogg', 50, FALSE, 4) // has placeholder
	icon_living = "fox_breach"
	icon_state = icon_living
	pixel_y = -6

//mob/living/simple_animal/hostile/abnormality/drifting_fox/Life()
	//. = ..()
	//if(!.) // Dead
	//	return FALSE
	//if(health >= 900)
	//	var/X = pick(GLOB.department_centers)
	//	var/turf/T = get_turf(X)
	//	new /mob/living/simple_animal/hostile/umbrella(T)

/mob/living/simple_animal/hostile/umbrella
	name = "Umbrella"
	desc = "A tattered and worn umbrella; The fox seems to have many to spare."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "foxbrella" // Gotta Sprite this.
	icon_living = "foxbrella" // Gotta make Sprites.
	faction = list("hostile")
	maxHealth = 125
	health = 125
	damage_coeff = list (RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	move_to_delay = 5
	melee_damage_lower = 5
	melee_damage_upper = 15
	melee_damage_type = BLACK_DAMAGE
	attack_sound = 'sound/abnormalities/driftingfox/fox_aoe_sound.ogg'
	attack_verb_continuous = "slashes"
	attack_verb_simple = "cut"
	robust_searching = TRUE
	del_on_death = FALSE

/mob/living/simple_animal/hostile/umbrella/AttackingTarget(atom/attacked_target)
	. = ..()
	if(isliving(target) && !ishuman(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			return FALSE
	return ..()
	//umbrella debuff stuff
/datum/status_effect/umbrella_black_debuff
	id = "umbrella_black_debuff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/umbrella_black_debuff

/datum/status_effect/umbrella_black_debuff/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.black_mod /= 1.3
		return
	var/mob/living/simple_animal/M = owner
	if(M.damage_coeff[BLACK_DAMAGE] <= 0)
		qdel(src)
		return
	M.damage_coeff[BLACK_DAMAGE] += 0.3

/datum/status_effect/umbrella_black_debuff/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.black_mod *= 1.3
		return
	var/mob/living/simple_animal/M = owner
	M.damage_coeff[BLACK_DAMAGE] -= 0.3

/atom/movable/screen/alert/status_effect/umbrella_black_debuff
	name = "False Kindness"
	desc = "Your half hearted attempts at kindness have weakened you to BLACK attacks."
	icon = 'icons/mob/actions/actions_ability.dmi'

/mob/living/simple_animal/hostile/umbrella/death(gibbed)
	visible_message(span_notice("[src] falls to the ground with the umbrella closing on itself!"))
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/death(gibbed)
	visible_message(span_notice("[src] falls to the ground, umbrellas closing as he whines in his last breath!"))
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

#undef STATUS_EFFECT_UMBRELLADEBUFF
