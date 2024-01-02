// Dawn
// Once again, amber dawn works for everything
/datum/ordeal/simplespawn/green_dawn
	name = "The Dawn of Green"
	flavor_name = "Doubt"
	announce_text = "One day, a question crossed through my mind. Where do we come from? \
	We were given life and left in this world against our own volition."
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	spawn_places = 6
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/green_bot
	spawn_player_multiplicator = 0.05
	level = 1
	color = COLOR_DARK_LIME
	reward_percent = 0.1

// Noon
/datum/ordeal/simplespawn/green_noon
	name = "The Noon of Green"
	flavor_name = "Process of Understanding"
	announce_text = "In the end, they were bound to life. We existed only to express despair and ire."
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	level = 2
	reward_percent = 0.15
	spawn_places = 6
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/green_bot_big
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = COLOR_DARK_LIME

// Dusk
/datum/ordeal/simplespawn/green_dusk
	name = "The Dusk of Green"
	flavor_name = "Where We Must Reach"
	announce_text = "We constructed a looming tower to return whence we came."
	level = 3
	reward_percent = 0.2
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	color = COLOR_DARK_LIME
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/green_dusk
	place_player_multiplicator = 0
	spawn_player_multiplicator = 0

// Midnight
/datum/ordeal/boss/green_midnight
	name = "The Midnight of Green"
	flavor_name = "Last Helix"
	announce_text = "The tower is touched by the sky, and it will leave nothing on the earth."
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	color = COLOR_DARK_LIME
	bosstype = /mob/living/simple_animal/hostile/ordeal/green_midnight
	bossspawnloc = /area/department_main/command
