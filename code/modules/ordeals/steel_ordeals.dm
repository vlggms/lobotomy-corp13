/datum/ordeal/simplespawn/steel_dawn
	name = "The Dawn of Steel"
	flavor_name = "Metamorphosis"
	announce_text = "The augmentation... I don’t regret it. One downside, though, is that I won’t ever be able to return to civilian life."
	end_announce_text = "This... This is what a war is. I was wholly unqualified."
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 1
	reward_percent = 0.1
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/steel_dawn
	//For every 30 players there is one additional group and one additional grunt for every 20 players.
	//So 40 players would make 5 groups of 4 troops which is 20 grunts, and for 10 players it would be 4 groups of 3 which is 12.
	place_player_multiplicator = 0.03
	spawn_player_multiplicator = 0.05
	color = "#71797E"


/datum/ordeal/simplecommander/steel_noon
	name = "The Noon of Steel"
	flavor_name = "War Machine"
	announce_text = "I’ll fight my enemies without hesitation. I’d made up my mind the day I was honored with an opportunity to get the modification procedure."
	end_announce_text = "Why are you running? You should raise G Corp’s banner and take the lead on the frontlines!"
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 2
	reward_percent = 0.2
	color = "#71797E"
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon)
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn)
	boss_amount = 3
	grunt_amount = 2
	boss_player_multiplicator = 0.03
	grunt_player_multiplicator = 0.05


/datum/ordeal/simplecommander/steel_dusk
	name = "The Dusk of Steel"
	flavor_name = "The Dogs of War"
	announce_text = "If we lose this war we would would be cast to the streets, seen as less than human by even the rats."
	end_announce_text = "In the end... We've become nothing but disgusting pests."
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 3
	reward_percent = 0.2
	color = "#71797E"
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dusk, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying)
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn)
	boss_amount = 3
	grunt_amount = 4
	//Setting player multiplier to 0 since this is already a army of 7.
	//Fourth Group appears if there is 23 players.
	boss_player_multiplicator = 0.045
	grunt_player_multiplicator = 0
