/******************************/
/* Maroon ordeal, Infestation */
/* Straight from Tegu Station */
/******************************/
/mob/living/simple_animal/hostile/ordeal/infestation
	name = "infestation mob master"
	desc = "I will kill whoever spawned this. You goofed up. You are not meant to see this, even."
	faction = list("abominable_infestation")
	a_intent = INTENT_HARM
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	blood_volume = BLOOD_VOLUME_NORMAL

// The general theme is... evolution?
// All of them are primarily weak to PALE and WHITE damage.
// The RED damage is rather inefficient against them.
// Most of them attack with RED damage, with some abilities here and there.

// Broodlings are the main tier 1 caste of the abominations;
// They are fast and weak, but make up for it due to their numbers.
// Used starting from Dawn.
/mob/living/simple_animal/hostile/ordeal/infestation/broodling
	name = "broodling"
	desc = "A small abominable creature, fast and vicious, tends to hunt in packs. Weak on its own, but should not be underestimated."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "broodling"
	icon_living = "broodling"
	icon_dead = "broodling_dead"
	pass_flags = PASSTABLE | PASSMOB
	maxHealth = 120
	health = 120
	move_to_delay = 1.5
	rapid_melee = 3
	melee_damage_lower = 3
	melee_damage_upper = 4
	turns_per_move = 4
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slashmiss.ogg'
	deathsound = 'sound/effects/ordeals/maroon/broodling_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/abomination = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/abomination = 1)

/mob/living/simple_animal/hostile/ordeal/infestation/broodling/Initialize()
	. = ..()
	AddComponent(/datum/component/swarming)

// Floatflies are a tier 1 caste specializing in dodging all your attacks while up in the sky(air(tiles));
// They are not as fast and not as weak as broodling, avoid fighting up close, and try not to miss your bullets.
// Used starting from Noon.
/mob/living/simple_animal/hostile/ordeal/infestation/floatfly
	name = "floatfly"
	desc = "A flesh creature resembling a big fly. It is moving rapidly from one spot to another, seemingly avoiding all attacks when given a chance."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "fly"
	icon_living = "fly"
	icon_dead = "fly_dead"
	pass_flags = PASSTABLE
	maxHealth = 250
	health = 250
	move_to_delay = 2
	rapid_melee = 2
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/alien_claw_flesh1.ogg'
	deathsound = 'sound/effects/ordeals/maroon/floatfly_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/abomination = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/abomination = 3)

	var/fly_cooldown
	var/fly_cooldown_time = 5 SECONDS
	var/fly_duration = 5 SECONDS

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/Initialize()
	. = ..()
	AddComponent(/datum/component/swarming)

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/death()
	animate(src, pixel_z = 0, time = 3)
	return ..()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/adjustBruteLoss(amount)
	. = ..()
	if(prob(amount * 5)) // Dodge everything like a pro
		animate(src, pixel_x = base_pixel_x + rand(-10, 10), pixel_y = base_pixel_y + rand(-10, 10), time = 2)
		if(ishuman(target) && world.time > fly_cooldown && prob(amount * 2))
			StartFlight()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/Aggro()
	. = ..()
	if(!ishuman(target))
		return .
	if(world.time > fly_cooldown && prob(50))
		StartFlight()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/AttackingTarget()
	. = ..()
	if(. && world.time > fly_cooldown && prob(25))
		StartFlight()

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/proc/StartFlight()
	if(QDELETED(src) || stat == DEAD)
		return FALSE
	if(!density || fly_cooldown >= world.time)
		return FALSE
	density = FALSE
	playsound(src, 'sound/effects/ordeals/maroon/floatfly_fly.ogg', 75, TRUE)
	visible_message("<span class='danger'>\The [src] flies upwards!</span>")
	alpha = 200
	var/new_pixel_y = rand(18, 24)
	animate(src, pixel_y = new_pixel_y, time = 5)
	base_pixel_y = new_pixel_y
	addtimer(CALLBACK(src, .proc/EndFlight), fly_duration)

/mob/living/simple_animal/hostile/ordeal/infestation/floatfly/proc/EndFlight()
	if(QDELETED(src) || stat == DEAD)
		return FALSE
	fly_cooldown = world.time + fly_cooldown_time
	density = TRUE
	visible_message("<span class='warning'>\The [src] stops its flight.</span>")
	alpha = 255
	animate(src, pixel_y = 0, time = 5)
	base_pixel_y = 0
