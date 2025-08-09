/mob/living/simple_animal/hostile/megafauna/xcorp_heart
	name = "Heart of Greed"
	desc = "The nexus of unchecked desire."
	icon = 'ModularTegustation/Teguicons/rce96x96.dmi'
	icon_state = "heart"
	//stop_automated_movement = 1
	stop_automated_movement_when_pulled = 1
	wander = FALSE
	health = 5000
	maxHealth = 5000
	vision_range = 13
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -16
	base_pixel_y = -16
	del_on_death = TRUE
	gps_name = "Thumping Signal"
	movement_type = GROUND
	faction = list("enemy", "hostile")
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/megafauna/xcorp_heart/Initialize()
	. = ..()
	AddElement(/datum/element/point_of_interest)
	return INITIALIZE_HINT_LATELOAD

/mob/living/simple_animal/hostile/megafauna/xcorp_heart/LateInitialize()
	. = ..()
	SSgamedirector.RegisterHeart(src)

/mob/living/simple_animal/hostile/megafauna/xcorp_heart/can_be_pulled(user, grab_state, force)
	return FALSE
