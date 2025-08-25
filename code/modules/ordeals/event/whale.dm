//Technically not an ordeal. Only occurs in U-corp maps.
//Future reference: give a sanity-reducing aura to the whale of the thousand strands.
//May include whales and other aquatic mechanics in the future.
/datum/ordeal/simplespawn/whale_attack
	name = "The First Wave"
	flavor_name = "Wave of Whirling Murk and Fish-Reek"
	announce_text = "Trust nothing but your own resolve to hold steadfast in the face of terror, in the face of calamity."
	end_announce_text = "Though the raging Lake may remain indifferent to the will of your meager existence."
	announce_sound = 'sound/effects/ordeals/whale_start.ogg'
	end_sound = 'sound/effects/ordeals/whale_end.ogg'
	spawn_type = /mob/living/simple_animal/hostile/ordeal/mermaid_porous
	color = "#B642F5"
	spawn_player_multiplicator = 0.05
	level = 1
	reward_percent = 0.1
	can_run = FALSE

/datum/ordeal/simplespawn/whale_attack/AbleToRun()
	if("whales" in SSmaptype.map_tags)
		can_run = TRUE
	return can_run
