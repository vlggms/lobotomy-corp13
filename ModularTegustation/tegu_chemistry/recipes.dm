/datum/chemical_reaction/bananium_essence
	results = list(/datum/reagent/drug/bananium_essence = 1)
	required_reagents = list(/datum/reagent/bananium = 2, /datum/reagent/drug/happiness = 3, \
	/datum/reagent/medicine/omnizine = 2, /datum/reagent/medicine/c2/synthflesh = 3) //10u of all this shit = 1u of essence.
	mix_message = "The mixture laughs at you mockingly."
	required_temp = 420
	mix_sound = 'sound/items/SitcomLaugh1.ogg'

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

/datum/chemical_reaction/mental_stabilizator
	results = list(/datum/reagent/medicine/mental_stabilizator = 2)
	required_reagents = list(/datum/reagent/drug/enkephalin = 1, /datum/reagent/toxin/mindbreaker = 1)
