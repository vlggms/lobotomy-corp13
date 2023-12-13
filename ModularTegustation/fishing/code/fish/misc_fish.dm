
/**
 *
 * Modular file containing: Fish that dont fit into any category, why?
 *
 */

/obj/item/food/fish/emulsijack
	name = "toxic emulsijack"
	desc = "Ah, the terrifying emulsijack. Created in a laboratory, this slimey, scaleless fish emits an invisible toxin that emulsifies other fish for it to feed on. Its only real use is for completely ruining a tank."
	habitat = "Invading Other Habitats"
	icon_state = "emulsijack"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	stable_population = 3

/obj/item/food/fish/emulsijack/process(seconds_per_tick)
	var/emulsified = FALSE
	var/obj/structure/aquarium/aquarium = loc
	if(istype(aquarium))
		for(var/obj/item/food/fish/victim in aquarium)
			if(istype(victim, /obj/item/food/fish/emulsijack))
				continue //no team killing
			victim.adjust_health((victim.health - 3) * seconds_per_tick) //the victim may heal a bit but this will quickly kill
			emulsified = TRUE
	if(emulsified)
		adjust_health((health + 3) * seconds_per_tick)
		last_feeding = world.time //emulsijack feeds on the emulsion!
	..()

/obj/item/food/fish/siltcurrent
	name = "dream-biting siltcurrent"
	desc = "A unique breed of fish that is themed around Dream-Devouring Siltcurrent. Flotsams not included."
	icon_state = "siltcurrent"
	random_case_rarity = FISH_RARITY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 60
	average_weight = 7003
