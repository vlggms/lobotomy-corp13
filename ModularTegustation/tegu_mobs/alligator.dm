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
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'

/mob/living/simple_animal/hostile/retaliate/gator/steppy
	name = "Steppy"
	desc = "Cargo's pet gator. Is he being detained!?"
	gender = MALE
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/retaliate/gator/steppy/cool
	name = "Cool Steppy"
	desc = "Cargo's pet gator. Looks like nobody can detain him now."
	speak_emote = list("snaps menacingly")
	loot = list(/obj/item/clothing/glasses/hud/security/sunglasses)
	icon_state = "gator_cool"
	icon_living = "gator_cool"
	speed = 7
	melee_damage_lower = 25
	melee_damage_upper = 30
	health = 150
	maxHealth = 150

/mob/living/simple_animal/sloth/paperwork/Initialize(mapload) // Shitty way of replacing sloth pets, without editing maps.
	. = ..()
	var/turf/T = get_turf(src)
	if(prob(5))
		new /mob/living/simple_animal/hostile/retaliate/gator/steppy/cool(T)
	else
		new /mob/living/simple_animal/hostile/retaliate/gator/steppy(T)
	return INITIALIZE_HINT_QDEL

/mob/living/simple_animal/sloth/citrus/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(prob(5))
		new /mob/living/simple_animal/hostile/retaliate/gator/steppy/cool(T)
	else
		new /mob/living/simple_animal/hostile/retaliate/gator/steppy(T)
	return INITIALIZE_HINT_QDEL
