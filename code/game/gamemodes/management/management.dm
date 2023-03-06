/datum/game_mode/management
	name = "Management"
	config_tag = "management_basic"
	report_type = "extended"
	false_report_weight = 5
	required_players = 0

	announce_span = "notice"
	announce_text = "You shouldn't be seeing this!!"
	var/list/abno_types = list("Lobotomy Corporation", "Altered LC", "Artbook", "Wonderlab", "Library of Ruina", "Limbus Company", "Original")
	var/list/gamemode_abnos = list(ZAYIN_LEVEL = list(), TETH_LEVEL = list(), HE_LEVEL = list(), WAW_LEVEL = list(), ALEPH_LEVEL = list())

/datum/game_mode/management/post_setup()
	var/list/all_abnos = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in all_abnos)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(initial(abno.can_spawn) && (initial(abno.abnormality_origin) in abno_types))
			gamemode_abnos[initial(abno.threat_level)] += abno

	SSabnormality_queue.possible_abnormalities = list()
	SSabnormality_queue.possible_abnormalities = gamemode_abnos
	if(LAZYLEN(gamemode_abnos))
		SSabnormality_queue.pick_abno()
	return ..()

/datum/game_mode/management/pure
	name = "Pure"
	config_tag = "pure"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage a selection of abnormalities strictly from Lobotomy Corporation HQ!"
	abno_types = list("Lobotomy Corporation")

/datum/game_mode/management/classic
	name = "classic"
	config_tag = "classic"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage a wide cast of abnormalities from all normal sources!"
	abno_types = list("Lobotomy Corporation", "Altered LC", "Artbook", "Wonderlab", "Library of Ruina", "Limbus Company", "Original")

/datum/game_mode/management/branch
	name = "Lobotomy Corporation - Side Branch"
	config_tag = "sidebranch"
	votable = 0

	announce_span = "notice"
	announce_text = "Manage all abnormalities not originating from Lobotomy Corporation HQ!"
	abno_types = list("Artbook", "Wonderlab", "Library of Ruina", "Limbus Company", "Original")
