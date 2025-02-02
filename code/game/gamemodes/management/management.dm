/datum/game_mode/management
	name = "Management"
	config_tag = "management_basic"
	report_type = "extended"
	false_report_weight = 5
	required_players = 0

	announce_span = "notice"
	announce_text = "You shouldn't be seeing this!!"
	var/list/abno_types = list(
		ABNORMALITY_ORIGIN_LOBOTOMY,
		ABNORMALITY_ORIGIN_ALTERED,
		ABNORMALITY_ORIGIN_ARTBOOK,
		ABNORMALITY_ORIGIN_WONDERLAB,
		ABNORMALITY_ORIGIN_RUINA,
		ABNORMALITY_ORIGIN_LIMBUS,
		ABNORMALITY_ORIGIN_ORIGINAL
		)
	var/list/gamemode_abnos = list(ZAYIN_LEVEL = list(), TETH_LEVEL = list(), HE_LEVEL = list(), WAW_LEVEL = list(), ALEPH_LEVEL = list())

/datum/game_mode/management/pre_setup()
	create_portrait_paths()
	return ..()

/datum/game_mode/management/post_setup()
	SSpersistence.LoadAbnoPicks() // Persistence system WILL have loaded at this point. Functionally means 0 abnos are slotted/loaded before the game itself is ready.
	var/list/all_abnos = SSpersistence.abno_rates
	var/highest = max(all_abnos[ReturnHighestValue(all_abnos)] + 1, 2) // Ensures no 0 results
	for(var/i in all_abnos)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(initial(abno.can_spawn) && (initial(abno.abnormality_origin) in abno_types))
			if(abno in gamemode_abnos[initial(abno.threat_level)])
				stack_trace("WARNING! Duplicate [abno] found in Persistent Abno Rates!")
				continue
			gamemode_abnos[initial(abno.threat_level)] += abno
			var/rate = (all_abnos[i] * -1) + highest * 2	//Weight counts for half of the abno chance, the other half is guaranteed.
			gamemode_abnos[initial(abno.threat_level)][abno] = rate

	SSabnormality_queue.possible_abnormalities = list()
	SSabnormality_queue.possible_abnormalities = gamemode_abnos
	if(LAZYLEN(gamemode_abnos))
		SSabnormality_queue.PickAbno()
	return ..()

/datum/game_mode/management/classic
	name = "L Corp - All Abnormalities"
	config_tag = "classic"
	votable = 0 //Automatically goes after a gamemode is voted

	announce_span = "notice"
	announce_text = "Manage a wide cast of abnormalities from all normal sources!"
	abno_types = list(
		ABNORMALITY_ORIGIN_LOBOTOMY,
		ABNORMALITY_ORIGIN_ALTERED,
		ABNORMALITY_ORIGIN_ARTBOOK,
		ABNORMALITY_ORIGIN_WONDERLAB,
		ABNORMALITY_ORIGIN_RUINA,
		ABNORMALITY_ORIGIN_LIMBUS,
		ABNORMALITY_ORIGIN_ORIGINAL
		)

/datum/game_mode/management/pure
	name = "L Corp - Main Branch"
	config_tag = "pure"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage a selection of abnormalities strictly from Lobotomy Corporation HQ!"
	abno_types = list(
		ABNORMALITY_ORIGIN_LOBOTOMY
		)

/datum/game_mode/management/branch
	name = "L Corp - Branch Office"
	config_tag = "sidebranch"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage all abnormalities not originating from Lobotomy Corporation HQ!"
	abno_types = list(
		ABNORMALITY_ORIGIN_ARTBOOK,
		ABNORMALITY_ORIGIN_WONDERLAB,
		ABNORMALITY_ORIGIN_RUINA,
		ABNORMALITY_ORIGIN_LIMBUS,
		ABNORMALITY_ORIGIN_ORIGINAL
		)

/datum/game_mode/management/limbuswl
	name = "L Corp - Limbus/Wonderlab"
	config_tag = "limbuswl"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage all abnormalities originating from Limbus Company and Wonderlabs!"
	abno_types = list(
		ABNORMALITY_ORIGIN_WONDERLAB,
		ABNORMALITY_ORIGIN_LIMBUS,
		)

/datum/game_mode/management/limbuswl
	name = "L Corp - Developer's Select"
	config_tag = "original"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage all abnormalities designed by our development team!"
	abno_types = list(
		ABNORMALITY_ORIGIN_ARTBOOK,
		ABNORMALITY_ORIGIN_ORIGINAL
		)

/datum/game_mode/management/joke
	name = "L Corp - Joke Abnormalities"
	config_tag = "joke"
	votable = 0 //God no

	announce_span = "notice"
	announce_text = "Manage a wide cast of abnormalities from all normal sources, and joke abnormalities!"
	abno_types = list(
		ABNORMALITY_ORIGIN_LOBOTOMY,
		ABNORMALITY_ORIGIN_ALTERED,
		ABNORMALITY_ORIGIN_ARTBOOK,
		ABNORMALITY_ORIGIN_WONDERLAB,
		ABNORMALITY_ORIGIN_RUINA,
		ABNORMALITY_ORIGIN_LIMBUS,
		ABNORMALITY_ORIGIN_ORIGINAL,
		ABNORMALITY_ORIGIN_JOKE,
		)

/datum/game_mode/management/community
	name = "L Corp - Community Abnormalities"
	config_tag = "community"
	votable = 0 //God no

	announce_span = "notice"
	announce_text = "Manage a wide cast of abnormalities from all normal sources, and community abnormalities!"
	abno_types = list(
		ABNORMALITY_ORIGIN_LOBOTOMY,
		ABNORMALITY_ORIGIN_ALTERED,
		ABNORMALITY_ORIGIN_ARTBOOK,
		ABNORMALITY_ORIGIN_WONDERLAB,
		ABNORMALITY_ORIGIN_RUINA,
		ABNORMALITY_ORIGIN_LIMBUS,
		ABNORMALITY_ORIGIN_ORIGINAL,
		ABNORMALITY_ORIGIN_COMMUNITY
		)

/datum/game_mode/management/branch12
	name = "Branch 12"
	config_tag = "branch12"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage a group of Unique Branch 12 Abnormalities!"
	abno_types = list(
		ABNORMALITY_ORIGIN_BRANCH12
		)
