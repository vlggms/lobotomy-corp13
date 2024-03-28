GLOBAL_LIST_EMPTY(cached_abno_work_rates)
GLOBAL_LIST_EMPTY(cached_abno_resistances)

/*
All descriptions of damage/resistances are in _HELPERS/abnormalities.dm

For escape damage you will have to get creative and figure out how dangerous it is
*/

/obj/item/paper/fluff/info
	show_written_words = FALSE
	slot_flags = null // No books on head, sorry
	/// Will not show up in Lobotomy Corp Archive Computer if true
	var/no_archive = FALSE
	var/mob/living/simple_animal/hostile/abnormality/abno_type = null
	var/abno_code = null
	/// List of random info about abnormality
	var/list/abno_info = list()
	// If null and has an abno_type, will append the end of the content with auto-generated info
	var/abno_work_damage_type = null
	var/abno_work_damage_count = null
	/// Associative list; Work type = Rate(text). If text is null - will generate its own.
	var/list/abno_work_rates = list(
		ABNORMALITY_WORK_INSTINCT = null,
		ABNORMALITY_WORK_INSIGHT = null,
		ABNORMALITY_WORK_ATTACHMENT = null,
		ABNORMALITY_WORK_REPRESSION = null)
	/// If FALSE - will not add breach info part to the paper; When null, will set itself depending on abno's var
	var/abno_can_breach = null
	var/abno_breach_damage_type = null
	var/abno_breach_damage_count = null
	/// Associative list similar to the above: Type = text; If text is null - generate it.
	var/list/abno_resistances = list(
		RED_DAMAGE = null,
		WHITE_DAMAGE = null,
		BLACK_DAMAGE = null,
		PALE_DAMAGE = null)

/obj/item/paper/fluff/info/Initialize()
	. = ..()
	if(info) // Someone wanted to fill it in manually, let's not touch it
		return
	if(!ispath(abno_type))
		return

	// Yes, we have to create the mob, it is that sad
	var/mob/living/simple_animal/hostile/abnormality/abno
	if(!(abno_type in GLOB.cached_abno_work_rates) || !(abno_type in GLOB.cached_abno_resistances))
		abno = new abno_type(src)
		QDEL_NULL(abno)

	if(isnull(abno_can_breach))
		abno_can_breach = initial(abno_type.can_breach)

	// Code/Name/Title
	name = initial(abno_type.name)
	if(isnull(abno_code))
		abno_code = initial(abno_type.name)
	else
		name += " - [abno_code]" // For RO enthusiasts
	info += "<h1><center>[abno_code]</center></h1><br>"

	// Basic information
	info += "Name: [initial(abno_type.name)]<br>\
			Risk Class: [THREAT_TO_NAME[initial(abno_type.threat_level)]]<br>\
			Max PE Boxes: [isnull(initial(abno_type.max_boxes)) ? initial(abno_type.threat_level) * 6 : initial(abno_type.max_boxes)]<br>\
			Qliphoth Counter: [initial(abno_type.start_qliphoth)]<br>"

	// Work damage
	if(isnull(abno_work_damage_type))
		abno_work_damage_type = uppertext(initial(abno_type.work_damage_type))
	if(isnull(abno_work_damage_count))
		abno_work_damage_count = SimpleWorkDamageToText(initial(abno_type.work_damage_amount))
	info += "Work Damage Type: [abno_work_damage_type]<br>"
	info += "Work Damage: [abno_work_damage_count]<br><br>"

	// All minor info
	for(var/line in abno_info)
		info += "- [line]<br>"
	if(LAZYLEN(abno_info))
		info += "<br>"

	// Work chances
	info += "<h3><center>Work Success Rates</center></h3><br>"
	for(var/line in abno_work_rates)
		var/rate = abno_work_rates[line]
		if(!rate)
			var/num_rate = GLOB.cached_abno_work_rates[abno_type][line]
			if(islist(num_rate))
				num_rate = num_rate[initial(abno_type.threat_level)] // This is quite silly
			rate = SimpleSuccessRateToText(num_rate)
		info += "<h4>[line]:</h4> [rate]<br>"
	info += "<br>"

	// Breach info
	if(!abno_can_breach)
		return

	info += "<h3><center>Breach Information</center></h3><br>"
	if(isnull(abno_breach_damage_type))
		abno_breach_damage_type = uppertext(initial(abno_type.melee_damage_type))
	if(isnull(abno_breach_damage_count))
		abno_breach_damage_count = SimpleDamageToText(initial(abno_type.melee_damage_upper) * initial(abno_type.rapid_melee))
	info += "<h4>Escape Damage Type:</h4> [abno_breach_damage_type]<br>"
	info += "<h4>Escape Damage:</h4> [abno_breach_damage_count]<br>"

	// Resistances
	for(var/line in abno_resistances)
		var/resist = abno_resistances[line]
		if(!resist)
			resist = SimpleResistanceToText(GLOB.cached_abno_resistances[abno_type][line])
		info += "<h4>[capitalize(line)] Resistance:</h4> [resist]<br>"

/obj/item/paper/fluff/info/AltClick(mob/living/user, obj/item/I)
	return

/obj/item/paper/fluff/info/attackby(obj/item/P, mob/living/user, params)
	ui_interact(user)	// only reading, sorry

/obj/item/paper/fluff/info/zayin
	icon_state = "zayin"

/obj/item/paper/fluff/info/teth
	icon_state = "teth"

/obj/item/paper/fluff/info/he
	icon_state = "he"

/obj/item/paper/fluff/info/waw
	icon_state = "waw"

/obj/item/paper/fluff/info/aleph
	icon_state = "aleph"

/obj/item/paper/fluff/info/zayin/archive_guide
	name = "Archive Guide"
	info = {"<h1><center>Archive Guide</center></h1>	<br>
	Welcome to Lobotomy Corps Digital Archive! <br>
	In order to effeciently navigate the archives please learn what the classification code of a abnormality actually means.<br>
	The first letter in a abnormalities classification code is their series or class.<br>
	F is for abnormalities that take on the traits of fictional stories or urban legends.<br>
	T is for abnormalities that formed from traumatic experiences or embody a certain phobia.<br>
	O is for abnormalities that do not take on the traits of traumas or fairy tales. <br>
	D and C is for abnormalities that were labeled as non essential for our overall goal. <br>
	M is for abnormalities that take on the traits of old world mythology. <br>
	-<br>
	The second letter of the classification code is their physical form, this is easier to find if you have seen the abnormality.<br>
	01 is humanoids, <br>
	02 is animals, <br>
	03 is otherworldy creatures, <br>
	04 is inanimate objects, <br>
	05 is mechanical or inorganic creatures,<br>
	06 is abstract or an amalgamation of entities, <br>
	07 is enities who are usable items while inert but can transform {currently used for O-O7-103}, <br>
	08 is currently unused,<br>
	09 is devices that require interaction to express their effects.<br>
	- <br>
	The final numbers in the code are unique to each abnormality.<br>
	Lobotomy Corp hopes you can meet their expectations.<br>"}
