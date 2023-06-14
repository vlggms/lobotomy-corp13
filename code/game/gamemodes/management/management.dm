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
	name = "L Corp - Main Branch"
	config_tag = "pure"
	votable = 1

	announce_span = "notice"
	announce_text = "Manage a selection of abnormalities strictly from Lobotomy Corporation HQ!"
	abno_types = list(
		ABNORMALITY_ORIGIN_LOBOTOMY
		)

/datum/game_mode/management/classic
	name = "L Corp - All Abnormalities"
	config_tag = "classic"
	votable = 1

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

/datum/game_mode/management/branch
	name = "L Corp - Side Branch"
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

/datum/game_mode/management/suppression
	name = "L Corp - Core Suppression"
	config_tag = "suppression"
	votable = 1

	announce_span = "warning"
	announce_text = "<span style='background_color:red;color:white'>WARNING WARNING WARNING WARNING WARNING<br>\
	Manifestation of Qlipha due to Sephirah Breakdown<br>\
	Suppression of Sephirah's Core Required<br>\
	WARNING WARNING WARNING WARNING WARNING<br></span>"

	var/list/threat_levels = list(WAW_LEVEL, ALEPH_LEVEL)

// Flat out REMOVE everything that isn't waw or aleph, because setting available_levels quite literally isn't enough.
/datum/game_mode/management/suppression/post_setup()
	var/list/all_abnos = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in all_abnos)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(initial(abno.can_spawn) && (initial(abno.threat_level) in threat_levels))
			gamemode_abnos[initial(abno.threat_level)] += abno

	SSabnormality_queue.possible_abnormalities = list()
	SSabnormality_queue.possible_abnormalities = gamemode_abnos
	SSabnormality_queue.available_levels = list(WAW_LEVEL, ALEPH_LEVEL)
	if(LAZYLEN(gamemode_abnos))
		SSabnormality_queue.pick_abno()

	// Setting up ordeals, and the round end
	SSlobotomy_corp.ordeal_timelock = list(14 MINUTES, 29 MINUTES, 44 MINUTES, 59 MINUTES, 0, 0, 0, 0, 0)
	addtimer(CALLBACK(SSlobotomy_corp, /datum/controller/subsystem/lobotomy_corp/proc/OrdealEvent), 15 MINUTES)
	addtimer(CALLBACK(SSlobotomy_corp, /datum/controller/subsystem/lobotomy_corp/proc/OrdealEvent), 30 MINUTES)
	addtimer(CALLBACK(SSlobotomy_corp, /datum/controller/subsystem/lobotomy_corp/proc/OrdealEvent), 45 MINUTES)
	addtimer(CALLBACK(SSlobotomy_corp, /datum/controller/subsystem/lobotomy_corp/proc/OrdealEvent), 60 MINUTES)
	addtimer(CALLBACK(SSlobotomy_corp, /datum/controller/subsystem/lobotomy_corp/proc/FailSuppression), 75 MINUTES)
	// This looks AND feels like shitcode. But fuck it.

	// Starting the actual core suppression
	var/list/possible_suppressions = subtypesof(/datum/suppression)
	var/picked_suppression = pick(possible_suppressions)
	SSlobotomy_corp.core_suppression = new picked_suppression
	SSlobotomy_corp.core_suppression.Run()
	return ..()
