/obj/item/clothing/head/hardhat/nolight
	name = "sturdy hard hat"
	desc = "A standard hardhat with lights removed. Goes well with welding goggles."
	icon = 'ModularTegustation/Teguicons/head_item.dmi'
	icon_state = "hardhat_nolight"
	worn_icon = 'ModularTegustation/Teguicons/head_worn.dmi'
	actions_types = list()
	dog_fashion = null
	light_range = 0
	light_power = 0

/obj/item/clothing/head/hardhat/nolight/attack_self(mob/living/user)
	return

/obj/item/clothing/head/caphat/admiral
	name = "rear admiral's cap"
	desc = "Worn by the finest captains of the Nanotrasen. Inside the lining of the cap, lies two faint initials."
	icon_state = "centcom_cap"
	inhand_icon_state = "that"
	dog_fashion = null

/obj/item/clothing/head/susp_bowler
	name = "black bowler"
	desc = "A deep black bowler. Inside the hat, there is a sleek red S, with a smaller X insignia embroidered within. On closer inspection, the brim feels oddly weighted..."
	icon = 'ModularTegustation/Teguicons/head_item.dmi'
	icon_state = "bowlerhat"
	worn_icon = 'ModularTegustation/Teguicons/head_worn.dmi'
	dynamic_hair_suffix = ""
	force = 3
	throwforce = 45
	throw_speed = 5
	throw_range = 9
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("attacks", "slashes", "slices", "rips", "dices", "cuts", "flays", "eviscerates")
	attack_verb_simple = list("attack", "slash", "slice", "dice", "cut", "flay")
	armour_penetration = 30
	hitsound = "swing_hit"
	sharpness = SHARP_EDGED

/* Berets */

/obj/item/clothing/head/beret/tegu
	name = "epic beret"
	desc = "Wow! It's the epic beret of the TeguStation!"
	icon = 'ModularTegustation/Teguicons/head_item.dmi'
	worn_icon = 'ModularTegustation/Teguicons/head_worn.dmi'
	icon_state = "beret_tegu"

// Command
/obj/item/clothing/head/beret/tegu/captain
	name = "captain beret"
	desc = "A lovely blue Captain beret with a gold and white insignia. Truly fit for only the finest officers."
	icon_state = "beret_captain"
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 5)
	strip_delay = 90

/obj/item/clothing/head/beret/tegu/hop
	name = "head of personnel beret"
	desc = "A lovely blue Head of Personnel's beret with a silver and white insignia. It smells faintly of paper and dogs."
	icon_state = "beret_hop"
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	strip_delay = 90

/obj/item/clothing/head/beret/tegu/command
	name = "command beret"
	desc = "A modest blue command beret with a silver rank insignia. Smells of power and the sweat of assistants."
	icon_state = "beret_com"
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	strip_delay = 90

// Service
/obj/item/clothing/head/beret/tegu/grey
	name = "grey beret"
	desc =  "A standard grey beret. Why an assistant would need a beret is unknown."
	icon_state = "beret_grey"

/obj/item/clothing/head/beret/tegu/service
	name = "service beret"
	desc =  "A standard service beret. Held by those with the sanity to serve everyone else on the Nanotrasen stations."
	icon_state = "beret_serv"

/obj/item/clothing/head/beret/tegu/qm
	name = "quartermaster beret"
	desc =  "A cargo beret with a faded medal haphazardly stitched into it. Worn by a true cargonian, it commands respect from everyone."
	icon_state = "beret_qm"
	armor = list(MELEE = 5, BULLET = 5, LASER = 5, ENERGY = 5)

/obj/item/clothing/head/beret/tegu/cargo
	name = "cargo beret"
	desc =  "A slightly faded mustard yellow beret. Usually held by the members of cargonia."
	icon_state = "beret_cargo"

/obj/item/clothing/head/beret/tegu/mining
	name = "mining beret"
	desc =  "A grey beret with a pickaxe insignia sewn into it. Seems to be padded and fireproofed to offer the wearer some protection."
	icon_state = "beret_mining"
	armor = list(MELEE = 15, BULLET = 10, LASER = 10, ENERGY = 15, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

// Science
/obj/item/clothing/head/beret/tegu/science
	name = "science beret"
	desc = "A purple beret with a silver science department insignia emblazoned on it. It has that authentic burning plasma smell."
	icon_state = "beret_sci"
	armor = list(RAD = 5, BIO = 5, FIRE = 5)
	strip_delay = 60

/obj/item/clothing/head/beret/tegu/rd
	name = "research director beret"
	desc = "A purple beret with a golden science insignia emblazoned on it. It has that authentic burning plasma smell, with a hint of tritium."
	icon_state = "beret_rd"
	armor = list(RAD = 10, BIO = 10, FIRE = 10)
	strip_delay = 60

// Engineering
/obj/item/clothing/head/beret/tegu/eng
	name = "engineering beret"
	desc = "A beret with the engineering insignia emblazoned on it. In parts a fashion statement and a hard hat."
	icon_state = "beret_engineering"
	armor = list(MELEE = 15, BULLET = 0, LASER = 0, ENERGY = 5, BOMB = 10, BIO = 0, RAD = 5, FIRE = 30, ACID = 5)
	strip_delay = 60

/obj/item/clothing/head/beret/tegu/eng/hazard
	name = "engineering hazardberet"
	desc = "A beret with the engineering insignia emblazoned on it. In parts a fashion statement and a hard hat. This one seems to be colored differently."
	icon_state = "beret_hazard_engineering"

/obj/item/clothing/head/beret/tegu/atmos
	name = "atmospherics beret"
	desc = "A beret for those who have shown immaculate proficienty in piping. Or plumbing. Mostly piping."
	icon_state = "beret_atmospherics"
	armor = list(RAD = 10, FIRE = 10)
	strip_delay = 60

/obj/item/clothing/head/beret/tegu/ce
	name = "chief engineer beret"
	desc = "A white beret with the engineering insignia emblazoned on it. Its owner knows what they're doing. Probably."
	icon_state = "beret_ce"
	armor = list(MELEE = 15, BULLET = 0, LASER = 0, ENERGY = 5, BOMB = 10, BIO = 0, RAD = 30, FIRE = 30, ACID = 5)
	strip_delay = 60

// Medical
/obj/item/clothing/head/beret/tegu/med
	name = "medical beret"
	desc = "A white beret with a blue cross finely threaded into it. It has that sterile smell about it."
	icon_state = "beret_med"
	armor = list(BIO = 20)
	strip_delay = 60

/obj/item/clothing/head/beret/tegu/chem
	name = "chemistry beret"
	desc = "A white beret with an orange insignia finely threaded into it. It smells of acid and ash."
	icon_state = "beret_chem"
	armor = list(ACID = 20)
	strip_delay = 60

/obj/item/clothing/head/beret/tegu/viro
	name = "virology beret"
	desc = "A white beret with a green insignia in the shape of a bacteria finely threaded into it. Smells unnaturally sterile..."
	icon_state = "beret_viro"
	armor = list(BIO = 30)
	strip_delay = 60

/obj/item/clothing/head/beret/tegu/cmo
	name = "chief medical officer beret"
	desc = "A baby blue beret with the insignia of Medistan. It smells very sterile."
	icon_state = "beret_cmo"
	armor = list(BIO = 30, ACID = 20)
	strip_delay = 60

	//LC13
/obj/item/clothing/head/beret/tegu/fishing_hat
	name = "unhinged fishing hat"
	desc = "On the white part of this hat is the words: <span class='boldwarning'>Women fear me, fish fear me, men turn their eyes away from me as i walk, no beast dare make a sound in my presence, i am alone on this barren earth...</span> at the end of this manifesto is the picture of a very silly salmon."
	icon_state = "fishing_hat"
	strip_delay = 60
