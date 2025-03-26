//Regular chems. These all take syrups.
/datum/chemical_reaction/odisone
	results = list(/datum/reagent/abnormality/odisone = 1)
	required_reagents = list(/datum/reagent/abnormality/focussyrup = 1, /datum/reagent/abnormality/violence = 1)
	mix_message = "The mixture gives off a spicy odor."

/datum/chemical_reaction/gaspilleur
	results = list(/datum/reagent/abnormality/gaspilleur  = 1)
	required_reagents = list(/datum/reagent/abnormality/focussyrup = 1, /datum/reagent/abnormality/nutrition = 1)
	mix_message = "The mixture produces a rancid smell."

/datum/chemical_reaction/lesser_sange_rau
	results = list(/datum/reagent/abnormality/lesser_sange_rau  = 1)
	required_reagents = list(/datum/reagent/abnormality/tastesyrup = 1, /datum/reagent/abnormality/amusement = 1)
	mix_message = "The mixture produces fumes that smell like suffocating under a lovers kiss."

/datum/chemical_reaction/culpusumidus
	results = list(/datum/reagent/abnormality/culpusumidus = 1)
	required_reagents = list(/datum/reagent/abnormality/tastesyrup = 1, /datum/reagent/abnormality/woe = 1)
	required_catalysts = list(/datum/reagent/water = 1)
	mob_react = FALSE
	mix_message = "The mixture gives off a odor of soggy bread."

/datum/chemical_reaction/serelam
	results = list(/datum/reagent/abnormality/serelam  = 1)
	required_reagents = list(/datum/reagent/abnormality/heartysyrup = 1, /datum/reagent/abnormality/abno_oil = 1)
	mob_react = FALSE
	mix_message = "The mixture starts to swirl around."

/datum/chemical_reaction/nepenthe
	results = list(/datum/reagent/abnormality/nepenthe  = 1)
	required_reagents = list(/datum/reagent/abnormality/bittersyrup = 1, /datum/reagent/abnormality/consensus = 1)
	mix_message = "The mixture gives off a flowery odor."

/datum/chemical_reaction/piedrabital
	results = list(/datum/reagent/abnormality/piedrabital  = 1)
	required_reagents = list(/datum/reagent/abnormality/heartysyrup = 1, /datum/reagent/abnormality/cleanliness = 1)
	mix_message = "The mixture becomes chunky."

/datum/chemical_reaction/dyscrasone
	results = list(/datum/reagent/abnormality/dyscrasone  = 2)
	required_reagents = list(/datum/reagent/abnormality/bittersyrup = 1, /datum/reagent/abnormality/tastesyrup = 1)
	mob_react = FALSE
	mix_message = "The mixture starts sizzling."



//These are generic chems, and can be made with sins as well.
/datum/chemical_reaction/abno_nutrition
	results = list(/datum/reagent/abnormality/nutrition = 3)
	required_reagents = list(/datum/reagent/abnormality/sin/wrath = 1, /datum/reagent/abnormality/sin/lust = 1, /datum/reagent/abnormality/sin/pride = 1)

/datum/chemical_reaction/cleanliness
	results = list(/datum/reagent/abnormality/cleanliness = 3)
	required_reagents = list(/datum/reagent/abnormality/sin/sloth = 1, /datum/reagent/abnormality/sin/gluttony = 1, /datum/reagent/abnormality/sin/wrath = 1)

/datum/chemical_reaction/consensus
	results = list(/datum/reagent/abnormality/consensus = 3)
	required_reagents = list(/datum/reagent/abnormality/sin/gloom = 1, /datum/reagent/abnormality/sin/pride = 1, /datum/reagent/abnormality/sin/lust = 1)

/datum/chemical_reaction/amusement
	results = list(/datum/reagent/abnormality/amusement = 3)
	required_reagents = list(/datum/reagent/abnormality/sin/envy = 1, /datum/reagent/abnormality/sin/gluttony = 1, /datum/reagent/abnormality/sin/pride = 1)

/datum/chemical_reaction/violence
	results = list(/datum/reagent/abnormality/violence = 3)
	required_reagents = list(/datum/reagent/abnormality/sin/lust = 1, /datum/reagent/abnormality/sin/gloom = 1, /datum/reagent/abnormality/sin/sloth = 1)

/datum/chemical_reaction/abno_oil
	results = list(/datum/reagent/abnormality/abno_oil = 3)
	required_reagents = list(/datum/reagent/abnormality/sin/gluttony = 1, /datum/reagent/abnormality/sin/envy = 1, /datum/reagent/abnormality/sin/wrath = 1)

/datum/chemical_reaction/woe
	results = list(/datum/reagent/abnormality/woe = 3)
	required_reagents = list(/datum/reagent/abnormality/sin/gloom = 1, /datum/reagent/abnormality/sin/envy = 1, /datum/reagent/abnormality/sin/sloth = 1)


//Syrups. These are the most simple of chems.
/datum/chemical_reaction/heartysyrup
	results = list(/datum/reagent/abnormality/heartysyrup = 2)
	required_reagents = list(/datum/reagent/abnormality/sin/sloth = 1, /datum/reagent/abnormality/sin/envy = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/bittersyrup
	results = list(/datum/reagent/abnormality/bittersyrup = 2)
	required_reagents = list(/datum/reagent/abnormality/sin/envy = 1, /datum/reagent/abnormality/sin/lust = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/tastesyrup
	results = list(/datum/reagent/abnormality/tastesyrup = 2)
	required_reagents = list(/datum/reagent/abnormality/sin/pride = 1, /datum/reagent/abnormality/sin/wrath = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/focussyrup
	results = list(/datum/reagent/abnormality/focussyrup = 2)
	required_reagents = list(/datum/reagent/abnormality/sin/gloom = 1, /datum/reagent/abnormality/sin/gluttony = 1, /datum/reagent/water = 1)
