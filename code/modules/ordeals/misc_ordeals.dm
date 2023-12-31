// A Party Everlasting
/datum/ordeal/boss/pink_midnight
	name = "The Midnight of Pink"
	flavor_name = "A Party Everlasting"
	announce_text = "Let's have one big jambouree, a party everlasting."
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/pink_start.ogg'
	end_sound = 'sound/effects/ordeals/pink_end.ogg'
	color = COLOR_PINK
	bosstype = /mob/living/simple_animal/hostile/ordeal/pink_midnight

// Holidays - Christmas
/datum/ordeal/simplespawn/christmas_dawn
	name = "The Dawn of Christmas"
	flavor_name = "The Miracle in District 12"
	announce_text = "Cute teddy bears, wonderous toy trains! Christmas gifts just for you!"
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/holiday/xmas_start.ogg'
	end_sound = 'sound/effects/ordeals/holiday/xmas_end.ogg'
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/present
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0.025
	color = "#FAA0A0"
