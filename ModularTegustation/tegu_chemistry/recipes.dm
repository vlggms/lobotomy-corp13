/datum/chemical_reaction/bananium_essence
	results = list(/datum/reagent/drug/bananium_essence = 1)
	required_reagents = list(/datum/reagent/bananium = 2, /datum/reagent/drug/happiness = 3, \
	/datum/reagent/medicine/omnizine = 2, /datum/reagent/medicine/c2/synthflesh = 3) //10u of all this shit = 1u of essence.
	mix_message = "The mixture laughs at you mockingly."
	required_temp = 420
	mix_sound = 'sound/items/SitcomLaugh1.ogg'

//LC13 Mixtures
/datum/chemical_reaction/odisone
	results = list(/datum/reagent/abnormality/odisone = 1)
	required_reagents = list(/datum/reagent/abnormality/focussyrup = 1, /datum/reagent/abnormality/violence = 1)
	mix_message = "The mixture gives off a spicy odor."

/datum/chemical_reaction/gaspilleur
	results = list(/datum/reagent/abnormality/gaspilleur  = 1)
	required_reagents = list(/datum/reagent/abnormality/focussyrup = 1, /datum/reagent/abnormality/nutrition = 1)
	mix_message = "The mixture produces a rancid smell."
/*
/datum/chemical_reaction/sange_rau
	results = list(/datum/reagent/abnormality/sange_rau  = 1)
	required_reagents = list(/datum/reagent/abnormality/tastesyrup = 1, /datum/reagent/abnormality/amusement = 1)
	mix_message = "The mixture produces fumes that smell like suffocating under a lovers kiss."
*/

/datum/chemical_reaction/culpusumidus
	results = list(/datum/reagent/abnormality/culpusumidus = 1)
	required_reagents = list(/datum/reagent/abnormality/tastesyrup = 1, /datum/reagent/abnormality/woe = 1)
	required_catalysts = list(/datum/reagent/water = 1)
	mix_message = "The mixture gives off a odor of soggy bread."

/datum/chemical_reaction/serelam
	results = list(/datum/reagent/abnormality/serelam  = 1)
	required_reagents = list(/datum/reagent/abnormality/bittersyrup = 1, /datum/reagent/abnormality/tastesyrup = 1)
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
	required_reagents = list(/datum/reagent/abnormality/heartysyrup = 1, /datum/reagent/abnormality/odisone = 1)
	mix_message = "The mixture starts sizzling."

/*
* Bad Reactions
* These reactions are for when two chemicals are a little too overpowered when mixed together
* and one of the ways to prevent people getting dosed up on 4 of the best chemicals is to make
* those chemicals mix into something gross. Think of depressents with stimulants or those weird
* internet challenges where they mix foods.
*/

/datum/chemical_reaction/serelam_bad_react1
	results = list(/datum/reagent/yuck = 1)
	required_reagents = list(/datum/reagent/abnormality/serelam = 5, /datum/reagent/abnormality/culpusumidus = 5)

