/mob/living/simple_animal/hostile/retaliate/gator
	name = "alligator"
	desc = "Thats an alligator. Probably shouldn't wrestle it."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "gator"
	icon_living = "gator"
	icon_dead ="gator_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_emote = list("snaps")
	emote_hear = list("snaps.","hisses.")
	emote_see = list("waits apprehensively.", "shuffles.")
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "rolls over"
	response_disarm_simple = "roll over"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	melee_damage_lower = 20
	melee_damage_upper = 24
	health = 125
	maxHealth = 125
	speed = 8
	glide_size = 2
	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/hostile/retaliate/gator/atlas
	name = "Atlas"
	desc = "The captain's trustworthy alligator, although you are not sure if it should be one."
	gender = MALE
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/pet/fox/renault/Initialize(mapload) // Shitty way of replacing renault, without editing maps.
	. = ..()
	var/turf/T = get_turf(src)
	new /mob/living/simple_animal/hostile/retaliate/gator/atlas(T)
	return INITIALIZE_HINT_QDEL
