//The most dangerous base risk level. These should be almost exclusively bosses meant for multiple grade 1 fixers or a color.

//Another horrible joke boss
/mob/living/simple_animal/hostile/distortion/papa_bongy/spicy
	name = "Spiced-up Papa Bongy"
	desc = "A particularly enraged human with the head of a chicken and deformed arms. It appears to be carrying a sack of raw chickens."
	maxHealth = 10000
	health = 10000
	fear_level = ALEPH_LEVEL
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	melee_damage_lower = 25
	melee_damage_upper = 40
	ranged_cooldown_time = 2 SECONDS
	ding_delay = 0.5 SECONDS
	throw_delay = 0.5 SECONDS
	units_max = 30
	can_spawn = 0

/mob/living/simple_animal/hostile/distortion/papa_bongy/spicy/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/food/fried_chicken))//no recursive transformations
		return
	if(istype(I, /obj/item/food/pizzaslice))
		return
	. = ..()
