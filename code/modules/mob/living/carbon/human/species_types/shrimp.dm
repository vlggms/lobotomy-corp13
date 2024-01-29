/datum/species/shrimp
	name = "Shrimp"
	id = "shrimp"
	mutant_bodyparts = list()
	say_mod = "burbles"
	sexes = 0

	nojumpsuit = TRUE
	species_traits = list(NO_UNDERWEAR,NOEYESPRITES)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_GENELESS)
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
	return shrimp_name//95% chance to pick a shrimp name, 5% to pick a human lastname. These guys only use one name

/mob/living/carbon/human/species/shrimp/attack_ghost(mob/dead/observer/O)
	if(!(src.key))
		if(O.can_reenter_corpse)
			var/response = alert(O,"Do you want to take it over?","This creature has no soul","Yes","No")
			if(response == "Yes")
				if(!(src.key))
					src.transfer_personality(O.client)
				else if(src.key)
					to_chat(src, span_notice("Somebody is already controlling this creature."))
		else if(!(O.can_reenter_corpse))
			to_chat(O,span_notice("You cannot control this creature."))

/mob/living/carbon/human/species/shrimp/proc/transfer_personality(client/candidate)
	if(!candidate)
		return
	src.ckey = candidate.ckey
	if(src.mind)
		src.mind.assigned_role = "Clerk"
		to_chat(src, span_info("You are a Clerk. You're the jack of all trades in LCorp. You are to assist with cleanup, cooking, medical and other miscellaneous tasks. You are fragile, but important."))
