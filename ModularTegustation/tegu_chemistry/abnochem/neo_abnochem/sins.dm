
/datum/reagent/abnormality/sin
	name = "Raw Sinchem"
	description = "A toxic chemical that will hurt you bad."
	health_restore = -1 // Should hurt you to avoid you drinking raw Sin chems
	sanity_restore = -1

/datum/reagent/abnormality/sin/wrath
	name = "Liquid Wrath"
	color = "#821c15"

/datum/reagent/abnormality/sin/lust
	name = "Liquid Lust"
	color = "#d67c0d"

/datum/reagent/abnormality/sin/sloth
	name = "Liquid Sloth"
	color = "#ad8d23"

/datum/reagent/abnormality/sin/gluttony
	name = "Liquid Gluttony"
	color = "#59b53f"

/datum/reagent/abnormality/sin/gloom
	name = "Liquid Gloom"
	color = "#509799"

/datum/reagent/abnormality/sin/pride
	name = "Liquid Pride"
	color = "#1f2278"

/datum/reagent/abnormality/sin/envy
	name = "Liquid Envy"
	color = "#703794"


//This is a debug chem and should be replaced when found.
/datum/reagent/abnormality/sin/emptiness
	name = "Liquid Emptiness"
	color = "#EEEEEE"
	health_restore = 0.2 // Heals you slightly to avoid a debug feature being negative. It's my fault, it should just do this.
	sanity_restore = 0.2
