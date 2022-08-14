// Bunch of code/outfits for minor factions unique to Tegu Station lore/code.

///* LIZARDS UNITED FRONT *///
  /* OUTFITS */
/datum/outfit/lufr
	name = "LUFR Soldier"
	var/jb_name = "Syndicate Operative"
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	uniform = /obj/item/clothing/under/mercenary/combat
	suit = /obj/item/clothing/suit/armor/vest/alt
	suit_store = /obj/item/gun/ballistic/automatic/pistol
	mask = /obj/item/clothing/mask/balaclava
	head = /obj/item/clothing/head/hos/beret/syndicate
	ears = /obj/item/radio/headset/syndicate/alt
	r_pocket = /obj/item/kitchen/knife/combat/survival
	back = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/ammo_box/magazine/m9mm = 3
		)
	id = /obj/item/card/id/syndicate_command

/datum/outfit/lufr/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	H.faction |= ROLE_SYNDICATE
	var/obj/item/card/id/W = H.wear_id
	W.access = list(ACCESS_SYNDICATE)
	W.assignment = jb_name
	W.registered_name = H.real_name
	W.update_label()
	..()

/datum/outfit/lufr/elite
	name = "LUFR Elite"
	jb_name = "Syndicate Assault Operative"
	uniform = /obj/item/clothing/under/mercenary/coldres
	suit_store = /obj/item/gun/ballistic/automatic/tommygun
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/hos/syndicate
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	belt = /obj/item/storage/belt/military/assault
	back = /obj/item/storage/backpack/duffelbag/syndie
	backpack_contents = list(
		/obj/item/ammo_box/magazine/tommygunm45 = 5
		)

/datum/outfit/lufr/ashen // For ashwalker lizards.
	name = "LUFR Ashen Warrior"
	digitifit = TRUE
	shoes = /obj/item/clothing/shoes/digicombat
	glasses = /obj/item/clothing/glasses/meson
	suit = null
	suit_store = null
	back = /obj/item/spear/bonespear
	backpack_contents = null

  /* SPAWNERS */
/obj/effect/mob_spawn/human/lufr
	name = "LUFR Soldier"
	desc = "A cryogenics pod, seemingly"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	mob_name = "a LUFR soldier"
	assignedrole = "LUFR Soldier"
	mob_species = /datum/species/lizard
	short_desc = "You are a LUFR soldier, fighting for lizardkind."
	outfit = /datum/outfit/lufr
	id_job = "Syndicate Operative"
	anchored = TRUE
	roundstart = FALSE
	random = TRUE
	death = FALSE
	var/prev_job_lufr
	var/syndi_job_lufr

/obj/effect/mob_spawn/human/lufr/special(mob/living/new_spawn)
	new_spawn.grant_language(/datum/language/codespeak, TRUE, TRUE, LANGUAGE_MIND)
	new_spawn.fully_replace_character_name(null,random_unique_lizard_name(gender))
	var/mob/living/carbon/human/H = new_spawn
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name

/obj/effect/mob_spawn/human/lufr/ashwalker
	mob_species = /datum/species/lizard/ashwalker
	outfit = /datum/outfit/lufr/ashen
	important_info = "Avoid needless confontations with humans, protect your kind and do not attempt to get onto the Station!"

/obj/effect/mob_spawn/human/lufr/ashwalker/Initialize(mapload) // Muh lore.
	. = ..()
	prev_job_lufr = pick("Captain", "Head of Security", "Head of Personnel", "Research Director", \
	"Corporate Representative", "Internal Affairs Agent", "ERT member")
	var/prev_station_lufr = pick("'Zeta'", "'Ion'", "'KS'", "11", "12")
	var/new_job_lufr = pick("a Janitor", "a Deputy", "a Cook", "an Assistant", "a Station Engineer", "Bartender")
	var/crime_lufr = pick("set off a large bomb", "started a hellish fire in the main hall", "sabotaged the engine", \
	"released a horde of angry slimes in the main hall", \
	"killed the new, human [prev_job_lufr]", "sent spam to CentCom via communications console", \
	"managed to fool CentCom into sending Death Squad to Space Station [prev_station_lufr]")
	switch(prev_job_lufr)
		if("Captain")
			syndi_job_lufr = pick("an Admiral", "a Captain on one of their combat ships")
		if("Head of Security")
			syndi_job_lufr = pick("Nuclear Squad Leader", "Field Commander")
		if("Head of Personnel")
			syndi_job_lufr = pick("Staff Officer", "a Second in Command on one of their combat ships")
		if("Research Director")
			syndi_job_lufr = pick("a Lead Researcher")
		else
			syndi_job_lufr = pick("Nuclear Operative", "Sabotage Specialist", "Assault Operative", "Intelligence Officer")
	flavour_text = "Since the humans arrived to your sector your kind was given a great opportunity to work with them, together. \
	Sadly, it didn't stay like this for too long, as TerraGov destroyed your dreams of racial equality and friendship. \
	Previously you worked as [prev_job_lufr] on Space Station [prev_station_lufr], but as the new law passed, you've been \
	forced to work as [new_job_lufr]! Outraged by this injustice, you [crime_lufr] and rushed to the last working escape pod \
	and ended up on Lavaland, where you've got in contact with the Syndicate, which promptly sent you supplies and offered \
	you to work as [syndi_job_lufr], once they arrive here to pick you up."

/obj/effect/mob_spawn/human/lufr/ashwalker/special(mob/living/new_spawn)
	. = ..()
	new_spawn.mind.store_memory("Your previous job was: [prev_job_lufr]")
	new_spawn.mind.store_memory("Syndicate offered you to work as: [syndi_job_lufr]")
