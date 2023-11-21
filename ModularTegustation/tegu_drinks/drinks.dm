/datum/reagent
	var/glass_tegu = FALSE

/datum/reagent/consumable/tegu
	name = "Tegu Drink"
	description = "Feels like civil war."
	color = "#FFFFF"
	quality = DRINK_GOOD
	taste_description = "civil war"
	glass_tegu = TRUE
	glass_icon_state = "tegu_drink"
	glass_name = "Tegu Drink"
	glass_desc = "Fulp? More like, gulp!"

/datum/reagent/consumable/tegu/shirley_temple
	name = "Shirley Temple"
	description = "Super-up, Grenadine, and Orange Juice."
	color = "#FFE48C" // rgb: 255, 228, 140
	quality = DRINK_GOOD
	taste_description = "Sweet tonic cherries"
	glass_icon_state = "shirley_temple"
	glass_name = "Shirley Temple"
	glass_desc = "Reminds you of the days restaurants served this to kids..."

/datum/reagent/consumable/tegu/milkshake
	name = "Milkshake"
	description = "Milkshake! Makes you crave a truck burger 'n' heap of fries."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "sweet and sugary milk"
	glass_icon_state = "milkshake"
	glass_name = "Milkshake"
	glass_desc = "Milkshake! makes you crave a truck burger 'n' heap of fries!"

/datum/chemical_reaction/milkshake
	results = list(/datum/reagent/consumable/tegu/milkshake = 15)
	required_reagents = list(/datum/reagent/consumable/milk = 5, /datum/reagent/consumable/ice = 5, /datum/reagent/consumable/cream = 5)

/datum/chemical_reaction/shirley_temple
	results = list(/datum/reagent/consumable/tegu/shirley_temple = 5)
	required_reagents = list(/datum/reagent/consumable/space_up = 2, /datum/reagent/consumable/orangejuice = 2, /datum/reagent/consumable/grenadine = 1)
