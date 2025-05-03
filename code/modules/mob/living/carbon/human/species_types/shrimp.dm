/datum/species/shrimp
	name = "Shrimp"
	id = "shrimp"
	mutant_bodyparts = list()
	say_mod = "burbles"
	sexes = 0 // shrimp are shrimp, nothing more nothing less

	mutanttongue = /obj/item/organ/tongue/shrimp
	nojumpsuit = TRUE
	species_traits = list(NO_UNDERWEAR, NOEYESPRITES)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_GENELESS)
	use_skintones = FALSE
	limbs_id = "shrimp"
	no_equip = list(ITEM_SLOT_EYES, ITEM_SLOT_MASK)
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	var/special_names = list("Cajun", "Leech", "Krill", "Prawn", "Oyster", "Gill", "Shrimp", "Shrimple", "Old Bay", "Lobster", "Crabby", "Finn", "Craw", "Crawdad", "Chowder", "Crusty", "Krillin", "Barney",\
	"Saeu", "Mantis", "Pistol", "Carieda", "Crangon", "Pop", "Shelldon", "Shelly", "Krabs", "Jumbo", "Caspian", "Little Buoy", "Brook", "River", "Bubbles")
	var/human_name_chance = 5

/datum/species/shrimp/random_name(gender,unique,lastname)
	var/shrimp_name = pick(special_names)
	if(prob(human_name_chance))
		shrimp_name = pick(GLOB.last_names)
	return shrimp_name // 95% chance to pick a shrimp name, 5% to pick a human lastname. These guys only use one name

/mob/living/carbon/human/species/shrimp/attack_ghost(mob/dead/observer/ghost)
	if(key)
		to_chat(ghost, span_notice("Somebody is already controlling this crustacean."))
		return

	var/response = alert(ghost, "Do you want to take it over?", "Soul transfer", "Yes", "No")
	if(response == "No")
		return

	if(key)
		to_chat(ghost, span_notice("Somebody has taken this crustacean whilst you were busy selecting!"))
		return

	ckey = ghost.client.ckey
	mind?.assigned_role = "Clerk"
	to_chat(src, span_info("You are a shrimp, your possibilities are endless. You can both choose a path of an agent or a path of a clerk. All gates are open to you."))

/obj/item/organ/tongue/shrimp
	name = "shrimp tongue"
	desc = "A fleshy muscle mostly used for making shrimp puns."
	say_mod = "hisses"
	taste_sensitivity = 5 // The most sensitive tongue that exists, the shrimp has fried rice so many times it can tell anything apart
	modifies_speech = TRUE

/obj/item/organ/tongue/shrimp/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] == "*") // They are emoting, no point in looking
		return

	message = replacetext(message, "simp", "shrimp") // We are not simps
	message = replacetext(message, "confusing", "conchfusing")
	message = replacetext(message, "complicated", "clampified")
	message = replacetext(message, "self", "shellf")
	message = replacetext(message, "about", "a-boat")
	message = replacetext(message, "cap", "carp")
	message = replacetext(message, "god", "cod")
	message = replacetext(message, "calamity", "clamity")
	message = replacetext(message, "help", "kelp")
	message = replacetext(message, "not", "naught")
	message = replacetext(message, "sophisticated", "sofishticated")
	message = replacetext(message, "kill", "%1") // Krill yourshellf... or skrill issue
	message = replacetext(message, "real", "reel")
	message = replacetext(message, "ill", "eel")
	message = replacetext(message, "%1", "krill") // earlier on we added a symbol so it dosen't get messed up by ill regex, we fix it here

	speech_args[SPEECH_MESSAGE] = message
