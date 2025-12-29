//Technically not an ordeal. Only occurs in U-corp maps.
//Future reference: give a sanity-reducing aura to the whale of the thousand strands.
//May include whales and other aquatic mechanics in the future.
//The "Gloomy Grey Lake of Wafting and Rumbling" is currently unmentioned- may be used for a porous hand alternative
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

/datum/ordeal/simplespawn/whale_attack/noon
	name = "The Second Wave"
	flavor_name = "Wave of an unknown lake"
	announce_text = "There is but one thing you can count on if you find yourself in an unfamiliar Lake whose Waves are alien to you."
	end_announce_text = "Many sailors fail to endure this trial and instead choose to become sacrifices to the depths of the Lake."
	spawn_type = /mob/living/simple_animal/hostile/ordeal/mermaid_strand
	level = 2
	reward_percent = 0.2

/datum/ordeal/simplespawn/whale_attack/dusk
	name = "The Third Wave"
	flavor_name = "Dregs of the Pallid Whale"
	announce_text = "They're people devoured by Whales that came with the Waves. There's no guarantee that we won't meet the same fate."
	end_announce_text = "This pale ruin is what that Whale leaves behind. The thing that leaves nothing unchanged in its wake."
	spawn_type = list(/mob/living/simple_animal/hostile/ordeal/lcb_pallid, /mob/living/simple_animal/hostile/ordeal/lcb_pallid/pistol)
	level = 3
	reward_percent = 0.2

/*
/datum/ordeal/simplespawn/whale_attack/midnight
	name = "The Five Calamities"
	flavor_name = "The All-Consuming Pallid Whale"
	announce_text = "Pallid as the pale death... Its hide, thick with scar tissue."
	end_announce_text = "It could swallow the world in the blink of an eye. But it also spews it back out just as quickly."
	spawn_type = /mob/living/simple_animal/hostile/ordeal/mermaid_porous
	level = 4
	reward_percent = 0.25
*/
