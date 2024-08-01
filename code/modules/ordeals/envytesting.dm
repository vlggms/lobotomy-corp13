/datum/ordeal/simplespawn/copper_dawn
	name = "The Dawn of Copper"
	flavor_name = "Envy Peccetulum - Zwei Association"
	announce_text = "A copy of something familiar to you has arrived."
	end_announce_text = "And you send them to dust."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 1
	reward_percent = 0.1
	spawn_places = 1
	spawn_amount = 5
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/ipar/zwei,
		/mob/living/simple_animal/hostile/ordeal/ipar/zweiriot,
		)
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = "#87b861"

/datum/ordeal/simplespawn/ipar_dawn
	name = "The Dawn of Ipar"
	flavor_name = "Envy Peccetulum - Lobotomy Corporation: Teth Agents"
	announce_text = "A copy of something familiar to you has arrived."
	end_announce_text = "And you send them to dust."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 1
	reward_percent = 0.1
	spawn_places = 3
	spawn_amount = 2
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/ipar/beak,
		/mob/living/simple_animal/hostile/ordeal/ipar/daredevil,
		/mob/living/simple_animal/hostile/ordeal/ipar/fragment
		)
	color = "#945f9c"
