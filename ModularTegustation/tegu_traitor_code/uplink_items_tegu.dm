/datum/uplink_item/role_restricted/bag_of_encounters
	name = "Bag of Encounters"
	desc = "An inconspicious bag of dice, recovered from a Space Wizard's dungeon. Each dice within will summon a challenge for the crew: 1d4 Bears, 1d6 Space Carp or 1d20 angry Bees!\
			Be sure to give the bag a shake before use, so that the creatures will recognise you as their true dungeon master, no matter who rolls the dice."
	item = /obj/item/storage/pill_bottle/encounter_dice
	cost = 8
	restricted_roles = list("Curator")
	limited_stock = 1 //for testing at least


/datum/uplink_item/badass/balloongold
	name = "Golden Syndicate Balloons"
	desc = "For showing that you and two other Syndies are true genuine 100% BAD ASS SYNDIES."
	item = /obj/item/storage/box/syndieballoons
	cost = 60
	cant_discount = TRUE
	illegal_tech = FALSE

/datum/uplink_item/role_restricted/susp_bowler
	name = "Suspicious Bowler"
	desc = "A strange, deep black bowler with an extremely sharp, weighted brim. The material used to make the brim of the bowler allows for it to pierce armor, often embeding within the designated target."
	item = /obj/item/clothing/head/susp_bowler
	cost = 5
	cant_discount = FALSE
	illegal_tech = TRUE
	restricted_roles = list("Bartender")

/datum/uplink_item/role_restricted/sith_starter_kit
	name = "Sith Starter Kit"
	desc = "Has everything you need to get started with the Dark Side! \
			Includes smelly old man robes, snazzy red light saber and genuine Sith sacred texts \
			describing the secrets of saber fighting, force lightning and force push."
	item = /obj/item/storage/box/syndicate/bundle_sith
	cost = 19
	restricted_roles = list("Chaplain", "Curator")

/datum/uplink_item/role_restricted/laser_tag_kit_red
	name = "X-TREME Laser Tag Kit (RADICAL RED)"
	desc = "New X-TREME laser tag kit for when you want to play for keeps! \
			Now with SUPER stun and RADICAL lethal mode! \
			Comes complete with gun and reflective laser vest. Adult supervision recommended. \
			Swipe gun with ID to toggle state of the art stealth parental locks!"
	item = /obj/item/storage/box/syndicate/laser_tag_kit_red
	cost = 14
	restricted_roles = list("Clown", "Mime", "Assistant")

/datum/uplink_item/role_restricted/laser_tag_kit_blue
	name = "X-TREME Laser Tag Kit (BITCHIN' BLUE)"
	desc = "New X-TREME laser tag kit for when you want to play for keeps! \
			Now with SUPER stun and RADICAL lethal mode! \
			Comes complete with gun and reflective laser vest. Adult supervision recommended. \
			Swipe gun with ID to toggle state of the art stealth parental locks!"
	item = /obj/item/storage/box/syndicate/laser_tag_kit_blue
	cost = 14
	restricted_roles = list("Clown", "Mime", "Assistant")

/datum/uplink_item/role_restricted/laser_tag_partypack_red
	name = "X-TREME Laser Tag Party Pack (RADICAL RED)"
	desc = "The new X-TREME laser tag party pack is deadly fun for the whole family! \
			Now with SUPER stun and RADICAL lethal mode! \
			Comes complete with 4 guns and reflective laser vests. Adult supervision recommended. \
			Swipe gun with ID to toggle state of the art stealth parental locks!"
	include_modes = list(/datum/game_mode/nuclear/clown_ops)
	item = /obj/structure/closet/crate/laser_tag_partypack_red
	cost = 50

/datum/uplink_item/role_restricted/laser_tag_partypack_blue
	name = "X-TREME Laser Tag Party Pack (BITCHIN' BLUE)"
	desc = "The new X-TREME laser tag party pack is deadly fun for the whole family! \
			Now with SUPER stun and RADICAL lethal mode! \
			Comes complete with 4 guns and reflective laser vests. Adult supervision recommended. \
			Swipe gun with ID to toggle state of the art stealth parental locks!"
	include_modes = list(/datum/game_mode/nuclear/clown_ops)
	item = /obj/structure/closet/crate/laser_tag_partypack_blue
	cost = 50

/datum/uplink_item/race_restricted/diginoslip
	name = "No-Slip Digitigrade Shoes"
	desc = "Simple as that - Robust shoes for lizardmen aiming to control the galaxy. \
		Now nothing can stop you, our friend. \
		No longer the soap will ruin your villainous plans. \
		No longer the clown will HONK you with banana by-products!"
	cost = 2
	item = /obj/item/clothing/shoes/digicombat/noslip
	restricted_species = list("lizard")

////////////// INFILTRATION GAMEMODE ITEMS //////////////

/datum/uplink_item/role_restricted/cybersunsuit
	name = "Cybersun Hardsuit"
	desc = "A long forgotten hardsuit made by Cybersun industries. \
			Offers ROBUST protection against laser-based weapons, while giving quite bad chances \
			to survive assault from a toolbox or shotgun. \
			Not to mention, it doesn't slow you down and contains an integrated jetpack that runs on standard tanks."
	item = /obj/item/clothing/suit/space/hardsuit/cybersun
	cost = 10
	restricted_roles = list("Cybersun Infiltrator")
	cant_discount = FALSE

/datum/uplink_item/role_restricted/glovesplus
	name = "Combat Gloves Plus"
	desc = "A pair of gloves that are fireproof and electrically insulated, however unlike the regular Combat Gloves these use nanotechnology \
			to teach the martial art of krav maga to the wearer."
	item = /obj/item/clothing/gloves/krav_maga/combatglovesplus
	cost = 5 //Same as nuke ops.
	restricted_roles = list("Gorlex Infiltrator")
	cant_discount = FALSE

/datum/uplink_item/role_restricted/flukeop
	name = "Nuclear Operative Bundle"
	desc = "A starting kit for wannabe nuclear operatives. \
	Comes with a tactical duffelbag filled with: \
	blood-red hardsuit, micro-bomb implant, night vision googles, bowman headset, combat gloves and Makarov pistol."
	item = /obj/item/storage/backpack/duffelbag/syndie/flukeop
	cost = 16
	restricted_roles = list("Gorlex Infiltrator")

/datum/uplink_item/role_restricted/tiger/macrobomb
	name = "Macrobomb Implant"
	desc = "An implant injected into the body, and later activated either manually or automatically upon death. \
			Upon death, releases a massive explosion that will wipe out everything nearby."
	item = /obj/item/storage/box/syndie_kit/imp_macrobomb
	cost = 20
	restricted_roles = list("Tiger Co. Infiltrator")

/datum/uplink_item/role_restricted/tiger/manhacks
	name = "Viscerator Delivery Grenade"
	desc = "A unique grenade that deploys a swarm of viscerators upon activation, which will chase down and shred \
			any non-operatives in the area."
	item = /obj/item/grenade/spawnergrenade/manhacks
	cost = 6
	restricted_roles = list("Tiger Co. Infiltrator")
	cant_discount = FALSE

/datum/uplink_item/stealthy_tools/adv_mulligan
	name = "Advanced Mulligan"
	desc = "An advanced form of toxin created in one of the Tiger Cooperative laboratories using \
	technology that was made with help of their 'supervisors'. \
	This item allows you to change your appearance, race and DNA to completely different one. \
	To use it - stab someone with it and then inject yourself, you will transform into that person. \n \
	Be aware that it can't be used more than once on yourself."
	item = /obj/item/adv_mulligan
	cost = 5
	surplus = 18
	include_modes = list(/datum/game_mode/traitor/infiltrator) //It's only for infiltrators, 'cuz of low-cost.

/obj/item/toy/balloon/syndicate/gold
	name = "gold syndicate balloon"
	desc = "This is a balloon made out of pure gold. How it floats, nobody knows."
	random_color = FALSE
	icon = 'ModularTegustation/Teguicons/phoenix_nest/balloon.dmi'
	icon_state = "syndballoongold"
	inhand_icon_state = "syndballoongold"
	lefthand_file = 'ModularTegustation/Teguicons/phoenix_nest/balloons_lefthand.dmi'
	righthand_file = 'ModularTegustation/Teguicons/phoenix_nest/balloons_righthand.dmi'

/obj/item/storage/box/syndieballoons
	name = "syndicate box"
	desc = "A sleek, sturdy box."
	icon_state = "syndiebox"

/obj/item/storage/box/syndieballoons/PopulateContents()
	new /obj/item/toy/balloon/syndicate/gold(src)
	new /obj/item/toy/balloon/syndicate/gold(src)
	new /obj/item/toy/balloon/syndicate/gold(src)
