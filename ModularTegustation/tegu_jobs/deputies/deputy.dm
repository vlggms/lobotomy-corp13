/datum/job/tegu/deputy
	title = "Deputy"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Head of Security")
	faction = "Station"
	total_positions = 4 //Kept in for posterity
	spawn_positions = 4 //ditto
	supervisors = "the head of security, and the head of your assigned department"
	selection_color = "#ffeeee"
	minimal_player_age = 3
	exp_requirements = 50
	exp_type = EXP_TYPE_CREW
	id_icon = 'ModularTegustation/Teguicons/cards.dmi'
	hud_icon = 'ModularTegustation/Teguicons/teguhud.dmi'
	tegu_spawn = /obj/effect/landmark/start/deputy

	outfit = /datum/outfit/job/deputy

	access = list(ACCESS_SECURITY, ACCESS_BRIG, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_WEAPONS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_BRIG, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SEC
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER
	bounty_types = CIV_JOB_SEC

/obj/item/clothing/under/rank/security/mallcop
	name = "deputy shirt"
	desc = "An awe-inspiring tactical shirt-and-pants combo; because safety never takes a holiday."
	worn_icon = 'ModularTegustation/Teguicons/mith_stash/clothing/under_worn.dmi' //will be sharing a DMI with digisuits
	icon = 'ModularTegustation/Teguicons/mith_stash/clothing/under_icons.dmi'
	icon_state = "mallcop"
	strip_delay = 50
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	tegu_item = TRUE
	mutantrace_variation = MUTANTRACE_VARIATION
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/mallcop/skirt
	name = "deputy skirt"
	desc = "An awe-inspiring tactical shirt-and-skirt combo; perfectly tailored for segway-riding."
	icon_state = "mallcop_skirt"
	mutantrace_variation = NO_MUTANTRACE_VARIATION
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/head/beret/sec/engineering
	name = "engineering deputy beret"
	desc = "Perhaps the only thing standing between the supermatter and a station-wide explosive sabotage."
	worn_icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_worn.dmi'
	icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_icons.dmi'
	icon_state = "beret_engi"
	tegu_item = TRUE

/obj/item/clothing/head/beret/sec/medical
	name = "medical deputy beret"
	desc = "This proud white-blue beret is a welcome sight when the greytide descends on chemistry."
	worn_icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_worn.dmi'
	icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_icons.dmi'
	icon_state = "beret_medbay"
	tegu_item = TRUE

/obj/item/clothing/head/beret/sec/science
	name = "science deputy beret"
	desc = "This loud purple beret screams 'Dont mess with his matter manipulator!'"
	worn_icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_worn.dmi'
	icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_icons.dmi'
	icon_state = "beret_science"
	tegu_item = TRUE

/obj/item/clothing/head/beret/sec/supply
	name = "supply deputy beret"
	desc = "The headwear for only the most eagle-eyed Deputy, able to watch both Cargo and Mining."
	worn_icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_worn.dmi'
	icon = 'ModularTegustation/Teguicons/mith_stash/clothing/head_icons.dmi'
	icon_state = "beret_supply"
	tegu_item = TRUE

/datum/outfit/job/deputy
	name = "Deputy"
	jobtype = /datum/job/tegu/deputy

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/storage/belt/security/tegu_starter_full
	ears = /obj/item/radio/headset/headset_sec
	uniform = /obj/item/clothing/under/rank/security/mallcop
	accessory = /obj/item/clothing/accessory/armband/deputy
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs/cable/zipties
	r_pocket = /obj/item/pda/security

	glasses = /obj/item/clothing/glasses/hud/security/sunglasses

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/survival

	implants = list(/obj/item/implant/mindshield)

GLOBAL_LIST_INIT(available_deputy_depts, list(SEC_DEPT_ENGINEERING, SEC_DEPT_MEDICAL, SEC_DEPT_SCIENCE, SEC_DEPT_SUPPLY))

/datum/job/tegu/deputy/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	// Assign department
	var/department
	if(M && M.client && M.client.prefs)
		department = M.client.prefs.prefered_security_department
		if(!LAZYLEN(GLOB.available_deputy_depts))
			return
		else if(department in GLOB.available_deputy_depts)
			LAZYREMOVE(GLOB.available_deputy_depts, department)
		else
			department = pick_n_take(GLOB.available_deputy_depts)
	var/ears = null
	var/head = null
	var/head_p = null
	var/accessory = null
	var/list/dep_access = null
	var/destination = null
	var/spawn_point = null
	switch(department)
		if(SEC_DEPT_SUPPLY)
			ears = /obj/item/radio/headset/headset_sec/department/supply
			head = /obj/item/clothing/head/beret/sec/supply
			head_p = /obj/item/clothing/head/helmet/space/plasmaman/cargo
			dep_access = list(ACCESS_AUX_BASE, ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION)
			destination = /area/security/checkpoint/supply
			spawn_point = locate(/obj/effect/landmark/start/depsec/supply)
			accessory = /obj/item/clothing/accessory/armband/cargo
		if(SEC_DEPT_ENGINEERING)
			ears = /obj/item/radio/headset/headset_sec/alt/department/engi
			head = /obj/item/clothing/head/beret/sec/engineering
			head_p = /obj/item/clothing/head/helmet/space/plasmaman/engineering
			dep_access = list(ACCESS_AUX_BASE, ACCESS_MINING_STATION, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS)
			destination = /area/security/checkpoint/engineering
			spawn_point = locate(/obj/effect/landmark/start/depsec/engineering)
			accessory = /obj/item/clothing/accessory/armband/engine
		if(SEC_DEPT_MEDICAL)
			ears = /obj/item/radio/headset/headset_sec/alt/department/med
			head = /obj/item/clothing/head/beret/sec/medical
			head_p = /obj/item/clothing/head/helmet/space/plasmaman/medical
			dep_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_PHARMACY)
			destination = /area/security/checkpoint/medical
			spawn_point = locate(/obj/effect/landmark/start/depsec/medical)
			accessory =  /obj/item/clothing/accessory/armband/medblue
		if(SEC_DEPT_SCIENCE)
			ears = /obj/item/radio/headset/headset_sec/alt/department/sci
			head = /obj/item/clothing/head/beret/sec/science
			head_p = /obj/item/clothing/head/helmet/space/plasmaman/science
			dep_access = list(ACCESS_RESEARCH, ACCESS_RND, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_GENETICS, ACCESS_ROBOTICS)
			destination = /area/security/checkpoint/science
			spawn_point = locate(/obj/effect/landmark/start/depsec/science)
			accessory = /obj/item/clothing/accessory/armband/science
	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		U.attach_accessory(new accessory)
	if(ears)
		if(H.ears)
			qdel(H.ears)
		H.equip_to_slot_or_del(new ears(H),ITEM_SLOT_EARS)
	if(head)
		if(isplasmaman(H))
			head = head_p
		if(H.head)
			qdel(H.head)
		H.equip_to_slot_or_del(new head(H),ITEM_SLOT_HEAD)

	var/obj/item/card/id/W = H.wear_id
	W.access |= dep_access

	var/teleport = 0
	if(!CONFIG_GET(flag/sec_start_brig))
		if(destination || spawn_point)
			teleport = 1
	if(teleport)
		var/turf/T
		if(spawn_point)
			T = get_turf(spawn_point)
			H.Move(T)
		else
			var/list/possible_turfs = get_area_turfs(destination)
			while (length(possible_turfs))
				var/I = rand(1, possible_turfs.len)
				var/turf/target = possible_turfs[I]
				if (H.Move(target))
					break
				possible_turfs.Cut(I,I+1)
	to_chat(M, "<b>You have been assigned to [department]!</b>")

/obj/item/radio/headset/headset_sec/department/Initialize()
	. = ..()
	wires = new/datum/wires/radio(src)
	secure_radio_connections = new
	recalculateChannels()

/obj/item/radio/headset/headset_sec/department/engi
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_sec/department/supply
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_sec/department/med
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_sec/department/sci
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_sci

/obj/effect/landmark/start/deputy
	name = "Deputy"
	icon_state = "Security Officer"

/obj/effect/landmark/start/security_officer/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	new /obj/effect/landmark/start/deputy(T)
