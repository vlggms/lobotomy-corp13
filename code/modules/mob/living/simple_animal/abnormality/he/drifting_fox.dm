// this was a mistake.
// By yours truely, Mori.
#define STATUS_EFFECT_FALSEKIND /datum/status_effect/false_kindness
/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A large shaggy fox with gleaming yellow eyes; And torn umbrellas lodged into its back."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "drifting_fox"
	icon_living = "drifting_fox"
	icon_dead = "fox_egg"
	deathmessage = "Collapses into a glass egg"
	deathsound = 'sound/abnormalities/drifting_fox/fox_death_sound.ogg'
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
	melee_damage_upper = 15 // Idea taken from the old PR, have a large damage range to immitate its fucked rolls and crit chance.
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/drifting_fox/fox_melee_sound.ogg'
	attack_verb_simple = "thwacks"
	attack_verb_continuous = "thwacks"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 45,
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
	gift_type = /datum/ego_gifts/sunshower
	gift_message = "The fox plucks an umbrella from its back and gives it to you, perhaphs as thanks?"

	var/list/pet = list()
	pet_bonus = "yips"

/mob/living/simple_animal/hostile/abnormality/drifting_fox/funpet(mob/petter)
	pet += petter

/mob/living/simple_animal/hostile/abnormality/drifting_fox/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(user in pet)
		if(work_type == ABNORMALITY_WORK_ATTACHMENT)
			chance += 30
		return chance

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in pet)
		pet -= user

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) <= 40)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/drifting_fox/BreachEffect(mob/living/carbon/human/user)
	..()
	icon_living = "fox_breach"
	icon_state = icon_living
	pixel_y = -6

/mob/living/simple_animal/hostile/abnormality/drifting_fox/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(target))
		return..()
	var/mob/living/carbon/human/L = target
	L.apply_status_effect(STATUS_EFFECT_FALSEKIND)
	return ..()

/datum/status_effect/false_kindness // MAYBE the black sunder shti works this time.
	id = "false_kindness"
	duration = 2 SECONDS //lasts 2 seconds becuase this is for an AI that attacks fast as shit, its not meant to fuck you up with other things.
	alert_type = /atom/movable/screen/alert/status_effect/false_kindness
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/false_kindness
	name = "False Kindness"
	desc = "You feel the weight of your mistakes."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "false_kindness" //Bit of a placeholder sprite, it works-ish so

/datum/status_effect/false_kindness/on_apply() //" Borrowed " from Ptear blade, courtesy of gong.
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner //Stolen from Ptear Blade, MAYBE works on people?
		to_chat(L, "<span class='userdanger'>You feel the foxes gaze upon you!</span>")
		L.physiology.black_mod *= 1.3
		return

/datum/status_effect/false_kindness/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(L, "<span class='userdanger'>You feel as though its gaze has lifted.</span>") //stolen from PT wep, but I asked so this 100% ok.
		L.physiology.black_mod /= 1.3
		return

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
	icon_state = "foxbrella"
	icon_living = "foxbrella"
	faction = list("hostile")
	maxHealth = 125
	health = 125
	damage_coeff = list (RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	move_to_delay = 5
	melee_damage_lower = 5
	melee_damage_upper = 15
	melee_damage_type = BLACK_DAMAGE
	attack_sound = 'sound/abnormalities/drifting_fox/fox_aoe_sound.ogg'
	attack_verb_continuous = "slashes"
	attack_verb_simple = "cut"
	robust_searching = TRUE
	del_on_death = FALSE

/mob/living/simple_animal/hostile/umbrella/death(gibbed)
	visible_message(span_notice("[src] falls to the ground as the umbrella closes in on itself!"))
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	return ..()

#undef STATUS_EFFECT_FALSEKIND
