//Used to bundle up roundstart quirks
/datum/backstory
	var/name = "Test Backstory"
	var/desc = "This is a test backstory."
	var/list/quirk_list = list()

///////////
// Nests //
///////////

//K-Corp
/datum/backstory/kcorp_feather
	name = "K-Corp"
	desc = "You may have been an agent, a clerk, or even a student in the nest of K-Corp."
	quirk_list = list(
	/datum/quirk/resistant //Placeholder
	)

//L-Corp
/datum/backstory/lcorp_feather
	name = "Lobotomy Corporation"
	desc = "You were among the many who were chosen to work at Lobotomy Corporation, with no particular aspirations or past achievements."
	quirk_list = list(
	)

//R-Corp
/datum/backstory/rcorp_feather
	name = "R-Corp"
	desc = "You may have been part of a pack, a scientist, or even a student in the nest of R-Corp."
	quirk_list = list(
	)

//T-Corp
/datum/backstory/tcorp_feather
	name = "TimeTrack Corporation"
	desc = "You may have been a collector, an inventor, or even a student in the nest of T-Corp. Like all citizens of T-corp, you carry a timepiece on you at all times."
	quirk_list = list(
	)

/datum/backstory/tcorp_backstreets
	name = "The Streets of Hours"
	desc = "You may have been a fixer, part of a syndicate, or even a rat in the backstreets of T-Corp. Like all citizens of T-corp, you carry a timepiece on you at all times."
	quirk_list = list(
	)

//W-Corp
/datum/backstory/wcorp_feather
	name = "W-Corp"
	desc = "You may have been an agent, a clerk, or even a student in the nest of W-Corp."
	quirk_list = list(
	)

/datum/backstory/wcorp_backstreets
	name = "The Streets of Flavor"
	desc = "You may have been a fixer, a chef, or even a rat in the backstreets of W-Corp."
	quirk_list = list(
	)

///////////////
// City Misc //
///////////////

/datum/backstory/rat
	name = "Transient"
	desc = "You were a rat, travelling from place to place searching for sanctuary from the night in the backstreets. Somehow, you survived long enough to end up here."
	quirk_list = list(
	)

///////////////
// Outskirts //
///////////////

//Outskirts
/datum/backstory/outskirts
	name = "The Outskirts"
	desc = "For years, you lived in the extreme poverty of the outskirts. Through hard work and determination, and maybe even a bit of luck, you found your way here."
	quirk_list = list(
	)

/datum/backstory/outskirts_hunter
	name = "Outskirts Villages"
	desc = "You survived and thrived long enough in the outskirts that the people there called you a \"hunter\". Through chance, you ended up here."
	quirk_list = list(
	)
