/datum/map_template/shuttle
	name = "Base Shuttle Template"
	var/prefix = "_maps/shuttles/"
	var/suffix
	var/port_id
	var/shuttle_id

	var/description
	var/prerequisites
	var/admin_notes
	/// How much does this shuttle cost the cargo budget to purchase? Put in terms of CARGO_CRATE_VALUE to properly scale the cost with the current balance of cargo's income.
	var/credit_cost = INFINITY
	/// Can the  be legitimately purchased by the station? Used by hardcoded or pre-mapped shuttles like the lavaland or cargo shuttle.
	var/can_be_bought = TRUE
	/// If set, overrides default movement_force on shuttle
	var/list/movement_force

	var/port_x_offset
	var/port_y_offset
	var/extra_desc = ""

/datum/map_template/shuttle/proc/prerequisites_met()
	return TRUE

/datum/map_template/shuttle/New()
	shuttle_id = "[port_id]_[suffix]"
	mappath = "[prefix][shuttle_id].dmm"
	. = ..()

/datum/map_template/shuttle/preload_size(path, cache)
	. = ..(path, TRUE) // Done this way because we still want to know if someone actualy wanted to cache the map
	if(!cached_map)
		return

	discover_port_offset()

	if(!cache)
		cached_map = null

/datum/map_template/shuttle/proc/discover_port_offset()
	var/key
	var/list/models = cached_map.grid_models
	for(key in models)
		if(findtext(models[key], "[/obj/docking_port/mobile]")) // Yay compile time checks
			break // This works by assuming there will ever only be one mobile dock in a template at most

	for(var/i in cached_map.gridSets)
		var/datum/grid_set/gset = i
		var/ycrd = gset.ycrd
		for(var/line in gset.gridLines)
			var/xcrd = gset.xcrd
			for(var/j in 1 to length(line) step cached_map.key_len)
				if(key == copytext(line, j, j + cached_map.key_len))
					port_x_offset = xcrd
					port_y_offset = ycrd
					return
				++xcrd
			--ycrd

/datum/map_template/shuttle/load(turf/T, centered, register=TRUE)
	. = ..()
	if(!.)
		return
	var/list/turfs = block(	locate(.[MAP_MINX], .[MAP_MINY], .[MAP_MINZ]),
							locate(.[MAP_MAXX], .[MAP_MAXY], .[MAP_MAXZ]))
	for(var/i in 1 to turfs.len)
		var/turf/place = turfs[i]
		if(istype(place, /turf/open/space)) // This assumes all shuttles are loaded in a single spot then moved to their real destination.
			continue
		if(length(place.baseturfs) < 2) // Some snowflake shuttle shit
			continue
		var/list/sanity = place.baseturfs.Copy()
		sanity.Insert(3, /turf/baseturf_skipover/shuttle)
		place.baseturfs = baseturfs_string_list(sanity, place)

		for(var/obj/docking_port/mobile/port in place)
			if(register)
				port.register()
			if(isnull(port_x_offset))
				continue
			switch(port.dir) // Yeah this looks a little ugly but mappers had to do this in their head before
				if(NORTH)
					port.width = width
					port.height = height
					port.dwidth = port_x_offset - 1
					port.dheight = port_y_offset - 1
				if(EAST)
					port.width = height
					port.height = width
					port.dwidth = height - port_y_offset
					port.dheight = port_x_offset - 1
				if(SOUTH)
					port.width = width
					port.height = height
					port.dwidth = width - port_x_offset
					port.dheight = height - port_y_offset
				if(WEST)
					port.width = height
					port.height = width
					port.dwidth = port_y_offset - 1
					port.dheight = width - port_x_offset

//Whatever special stuff you want
/datum/map_template/shuttle/post_load(obj/docking_port/mobile/M)
	if(movement_force)
		M.movement_force = movement_force.Copy()
	M.linkup()

/datum/map_template/shuttle/emergency
	port_id = "emergency"
	name = "Base Shuttle Template (Emergency)"

/datum/map_template/shuttle/cargo
	port_id = "cargo"
	name = "Base Shuttle Template (Cargo)"
	can_be_bought = FALSE

/datum/map_template/shuttle/ferry
	port_id = "ferry"
	name = "Base Shuttle Template (Ferry)"

/datum/map_template/shuttle/whiteship
	port_id = "whiteship"

/datum/map_template/shuttle/labour
	port_id = "labour"
	can_be_bought = FALSE

/datum/map_template/shuttle/mining
	port_id = "mining"
	can_be_bought = FALSE

/datum/map_template/shuttle/mining_common
	port_id = "mining_common"
	can_be_bought = FALSE

/datum/map_template/shuttle/arrival
	port_id = "arrival"
	can_be_bought = FALSE

/datum/map_template/shuttle/infiltrator
	port_id = "infiltrator"
	can_be_bought = FALSE

/datum/map_template/shuttle/aux_base
	port_id = "aux_base"
	can_be_bought = FALSE

/datum/map_template/shuttle/escape_pod
	port_id = "escape_pod"
	can_be_bought = FALSE

/datum/map_template/shuttle/assault_pod
	port_id = "assault_pod"
	can_be_bought = FALSE

/datum/map_template/shuttle/pirate
	port_id = "pirate"
	can_be_bought = FALSE

/datum/map_template/shuttle/hunter
	port_id = "hunter"
	can_be_bought = FALSE

/datum/map_template/shuttle/ruin //For random shuttles in ruins
	port_id = "ruin"
	can_be_bought = FALSE

/datum/map_template/shuttle/snowdin
	port_id = "snowdin"
	can_be_bought = FALSE

/datum/map_template/shuttle/manager
	port_id = "manager"
	can_be_bought = FALSE

/datum/map_template/shuttle/epsilon
	port_id = "epsilon"
	can_be_bought = FALSE

/datum/map_template/shuttle/secondary
	port_id = "secondary"
	can_be_bought = FALSE

/datum/map_template/shuttle/iotamain
	port_id = "iotamain"
	can_be_bought = FALSE

/datum/map_template/shuttle/iotaextra
	port_id = "iotaextra"
	can_be_bought = FALSE

/datum/map_template/shuttle/iotafinal
	port_id = "iotafinal"
	can_be_bought = FALSE

/datum/map_template/shuttle/zetadepartwest
	port_id = "zetadepartwest"
	can_be_bought = FALSE

/datum/map_template/shuttle/zetadeparteast
	port_id = "zetadeparteast"
	can_be_bought = FALSE

/datum/map_template/shuttle/deltamain
	port_id = "deltamain"
	can_be_bought = FALSE

// Shuttles start here:

/datum/map_template/shuttle/manager/elevator
	suffix = "elevator"
	name = "manager elevator"

/datum/map_template/shuttle/epsilon/elevator
	suffix = "elevator"
	name = "epsilon elevator"

/datum/map_template/shuttle/secondary/epsilon
	suffix = "epsilon"
	name = "epsilon backup"

/datum/map_template/shuttle/iotamain/elevator
	suffix = "elevator"
	name = "iotamain elevator"

/datum/map_template/shuttle/iotaextra/elevator
	suffix = "elevator"
	name = "iotaextra elevator"

/datum/map_template/shuttle/iotafinal/elevator
	suffix = "elevator"
	name = "iotafinal elevator"

/datum/map_template/shuttle/zetadepartwest/elevator
	suffix = "elevator"
	name = "zetadepartwest elevator"

/datum/map_template/shuttle/zetadeparteast/elevator
	suffix = "elevator"
	name = "zetadeparteast elevator"

/datum/map_template/shuttle/deltamain/elevator
	suffix = "elevator"
	name = "deltamain elevator"

/datum/map_template/shuttle/emergency/backup
	suffix = "backup"
	name = "Backup Shuttle"
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/construction
	suffix = "construction"
	name = "Build Your Own Shuttle Kit!"
	description = "For the enterprising shuttle engineer! The chassis will dock upon purchase, but launch will have to be authorized as usual via shuttle call. Comes stocked with construction materials. If you have a supply department at your facility, you can order shuttle engine crates from there upon purchase of this kit."
	admin_notes = "No brig, no medical facilities, no shuttle console."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/airless/post_load()
	. = ..()
	//enable buying engines from cargo
	var/datum/supply_pack/P = SSshuttle.supply_packs[/datum/supply_pack/engineering/shuttle_engine]
	P.special_enabled = TRUE


/datum/map_template/shuttle/emergency/asteroid
	suffix = "asteroid"
	name = "Ceres Station Transport"
	description = "A respectable mid-sized shuttle that first saw service shuttling Ceres colonists to and from their mining operations in the belt."
	credit_cost = CARGO_CRATE_VALUE * 6

/datum/map_template/shuttle/emergency/bar
	suffix = "bar"
	name = "Lobotomy Corporation Welfare Transport"
	description = "Features the combined efforts of the Information and Welfare departments to provide bar staff (a Bardrone and a Barmaid), a bathroom, a quality lounge for the officers, and a large gathering table. After a hard day of mass death to sustain humanity, crack open a drink!"
	admin_notes = "Bardrone and Barmaid are GODMODE, will be automatically sentienced by the fun balloon at 60 seconds before arrival. \
	Has medical facilities."
	credit_cost = CARGO_CRATE_VALUE * 10

/datum/map_template/shuttle/emergency/pod
	suffix = "pod"
	name = "Emergency Pods"
	description = "We did not expect an evacuation this quickly. All we have available is two escape pods. How did you manage this?"
	admin_notes = "For player punishment."
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/russiafightpit
	suffix = "russiafightpit"
	name = "RFS Mother Russia Bleeds"
	description = "Dis is a high-quality shuttle, da. Many seats, lots of space, all equipment! Even includes entertainment! Such as lots to drink, and a fighting arena for drunk workers to have fun! If arena not fun enough, simply press button of releasing bears. Do not worry, bears trained not to break out of fighting pit, so totally safe so long as nobody stupid or drunk enough to leave door open. As long as we never forget our history, Mother Russia never dies!"
	admin_notes = "Includes a small variety of weapons. And bears. Only captain-access can release the bears. Bears won't smash the windows themselves, but they can escape if someone lets them."
	credit_cost = CARGO_CRATE_VALUE * 10 // While the shuttle is rusted and poorly maintained, trained bears are costly.

/datum/map_template/shuttle/emergency/monastery
	suffix = "monastery"
	name = "Grand Corporate Monastery"
	description = "Originally built by a group of wealthy proselytizing nest residents to preach from a safe distance, this grand edifice to religion, due to budget cuts, is now available as a transport for the right... donation. Due to its large size and careless owners, this transport may cause collateral damage."
	admin_notes = "WARNING: This shuttle WILL destroy a fourth of the station, likely picking up a lot of objects with it."
	credit_cost = CARGO_CRATE_VALUE * 250
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 5)

/datum/map_template/shuttle/emergency/medisim
	suffix = "medisim"
	name = "Medieval Reality Simulation Dome Transport"
	description = "A state of the art simulation dome, loaded onto your shuttle! Watch and laugh at how petty humanity used to be before the city. Guaranteed to be at least 40% historically accurate."
	admin_notes = "Ghosts can spawn in and fight as knights or archers. The CTF auto restarts, so no admin intervention necessary."
	credit_cost = 20000

/datum/map_template/shuttle/emergency/medisim/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_MEDISIM]

/datum/map_template/shuttle/emergency/arena
	suffix = "arena"
	name = "The Arena"
	description = "The passengers must pass through an otherworldy arena to board this transport. Expect massive casualties. The source of the Bloody Signal must be tracked down and eliminated to unlock this vessel."
	admin_notes = "RIP AND TEAR."
	credit_cost = CARGO_CRATE_VALUE * 20
	/// Whether the arena z-level has been created
	var/arena_loaded = FALSE

/datum/map_template/shuttle/emergency/arena/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_BUBBLEGUM]

/datum/map_template/shuttle/emergency/arena/post_load(obj/docking_port/mobile/M)
	. = ..()
	if(!arena_loaded)
		arena_loaded = TRUE
		var/datum/map_template/arena/arena_template = new()
		arena_template.load_new_z()

/datum/map_template/arena
	name = "The Arena"
	mappath = "_maps/templates/the_arena.dmm"

/datum/map_template/shuttle/emergency/birdboat
	suffix = "birdboat"
	name = "N-Corporation Birdboat Transport"
	description = "Though a little on the small side, this shuttle is feature complete, which is more than can be said for the pattern of station it was commissioned for, decommissioned by N-Corporation early into orbital construction."
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/box
	suffix = "box"
	name = "N-Corporation Box Transport"
	credit_cost = CARGO_CRATE_VALUE * 4
	description = "The gold standard in orbital employee transit, this tried and true design is equipped with everything the crew needs for a safe flight home. Coined the Box due to the lack of creativity in engineering majors, and its box shape."

/datum/map_template/shuttle/emergency/alpha
	suffix = "alpha"
	name = "A-098 WARP Train Transport"
	credit_cost = CARGO_CRATE_VALUE * 4
	description = "A Warp-Corporation commissioned transport train. All the other shuttles take ages with their old engines and fuel. Go anywhere in just 10 seconds!"

/datum/map_template/shuttle/emergency/donut
	suffix = "donut"
	name = "Vice-Admiral Kirk Memoriam Transport"
	description = "The perfect spearhead for any crude joke involving a von Braun wheel station's shape, this shuttle supports a separate containment cell for prisoners and a compact medical wing."
	admin_notes = "Has airlocks on both sides of the shuttle and will probably intersect near the front on some stations that build past departures."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/clown
	suffix = "clown"
	name = "Snappop(tm)!"
	description = "Hey kids and grownups! \
	Are you bored of DULL and TEDIOUS shuttle journeys after you're evacuating for probably BORING reasons. Well then order the Snappop(tm) today! \
	We've got fun activities for everyone, an all access cockpit, and no boring security brig! Boo! Play dress up with your friends! \
	Collect all the bedsheets before your neighbour does! Check if the Head is watching you with our patent pending \"Peeping Tom Multitool Detector\" or PEEEEEETUR for short. \
	Have a fun ride!"
	admin_notes = "Brig is replaced by anchored greentext book surrounded by lavaland chasms, stationside door has been removed to prevent accidental dropping. No brig."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/emergency/cramped
	suffix = "cramped"
	name = "Secure Transport Vessel 5 (STV5)"
	description = "Well, looks like the city only had this ship on standby, they probably weren't expecting you to need evac for a while. \
	Probably best if you don't rifle around in whatever salvage they were transporting. I hope you're friendly with your coworkers, because there is very little space in this thing.\n\
	\n\
	Contains contraband armory guns, space station loot, and abandoned crates!"
	admin_notes = "Due to origin as a solo piloted secure vessel, has an active GPS onboard labeled STV5. Has roughly as much space as Hi Daniel, except with explosive crates."

/datum/map_template/shuttle/emergency/meta
	suffix = "meta"
	name = "N-Corporation Meta Transport"
	credit_cost = CARGO_CRATE_VALUE * 8
	description = "A fairly standard shuttle, though larger and slightly better equipped than the usual N-Corporation vessel."

/datum/map_template/shuttle/emergency/kilo
	suffix = "kilo"
	name = "N-Corporation Atlas Transport"
	credit_cost = CARGO_CRATE_VALUE * 10
	description = "A fully functional shuttle including a complete infirmary, storage facilties and regular amenities. Fit for corporate expeditions far from known space."

/datum/map_template/shuttle/emergency/mini
	suffix = "mini"
	name = "N-Corporation Sardine Transport"
	credit_cost = CARGO_CRATE_VALUE * 2
	description = "Despite its namesake, this shuttle is actually only slightly smaller than standard, and still complete with a brig and medbay."

/datum/map_template/shuttle/emergency/scrapheap
	suffix = "scrapheap"
	name = "Standby Evacuation Vessel \"Scrapheap Challenge\""
	credit_cost = CARGO_CRATE_VALUE * -2
	description = "Due to a lack of functional emergency shuttles, we bought this second hand from an orbital scrapyard and pressed it into service. Please do not lean too heavily on the exterior windows, they are fragile!"
	admin_notes = "An abomination with no functional medbay, sections missing, and some very fragile windows. Surprisingly airtight."
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/narnar
	suffix = "narnar"
	name = "N-Corporation Horizon Transport"
	description = "Looks like this shuttle may have wandered into the darkness between the stars on route to the city. Let's not think too hard about where all the bodies came from."
	admin_notes = "Contains real cult ruins, mob eyeballs, and inactive constructs. Cult mobs will automatically be sentienced by fun balloon. \
	Cloning pods in 'medbay' area are showcases and nonfunctional."
	credit_cost = 6667 ///The joke is the number so no defines

/datum/map_template/shuttle/emergency/narnar/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_NARNAR]

/datum/map_template/shuttle/emergency/pubby
	suffix = "pubby"
	name = "Pubby Station Emergency Shuttle"
	description = "A train but in space! Complete with a first, second class, brig and storage area."
	admin_notes = "Choo choo motherfucker!"
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/cere
	suffix = "cere"
	name = "Ceres Station Transport II"
	description = "The large, beefed-up version of the box-standard shuttle. Includes an expanded brig, fully stocked medbay, enhanced cargo storage with mech chargers, \
	an engine room stocked with various supplies, and a crew capacity of 80+ to top it all off. Live large, Beltah Loadah."
	admin_notes = "Seriously big, even larger than the Delta shuttle."
	credit_cost = CARGO_CRATE_VALUE * 20

/datum/map_template/shuttle/emergency/imfedupwiththisworld
	suffix = "imfedupwiththisworld"
	name = "Oh, Hi Roland"
	description = "How was work today? Oh, pretty good. We got a new outskirts facility and the company will make a lot of energy. What facility? I cannot tell you; it's confidential. \
	Aw, come space on. Why not? No, I can't. Anyway, how is your dead wife?"
	admin_notes = "Tiny, with a single airlock and wooden walls. What could go wrong?"
	can_be_bought = FALSE
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/goon
	suffix = "goon"
	name = "NES Port"
	description = "The N-Corporation Emergency Shuttle Port (NES Port for short) is a shuttle used at other less known N-Corporation facilities and has a more open inside for larger crowds, but fewer onboard shuttle facilities. Reserved for distant outposts dedicated to mining or experimental research."
	credit_cost = CARGO_CRATE_VALUE

/datum/map_template/shuttle/emergency/rollerdome
	suffix = "rollerdome"
	name = "Uncle Pete's Rollerdome"
	description = "Developed by a member of Lobotomy Corporation's Welfare team that claims to have travelled from the year 2028. \
	He says this shuttle is based off an old entertainment complex from the 1990s, though our database has no records on anything pertaining to that decade."
	admin_notes = "ONLY NINETIES KIDS REMEMBER. Uses the fun balloon and drone from the Emergency Bar."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/wabbajack
	suffix = "wabbajack"
	name = "USS Lepton Violet"
	description = "The research team based on this vessel went missing one day, and no amount of investigation could discover what happened to them. \
	The only occupants were a number of dead rodents, who appeared to have clawed each other to death. \
	Needless to say, no engineering team wanted to go near the thing, and it's only being used as a transport shuttle because there is literally nothing else available. \
	It has sat completely untouched since before the city, recovered from an orbital graveyard by an N-Corporation salvage team."
	admin_notes = "If the crew can solve the puzzle, they will wake the wabbajack statue. It will likely not end well. There's a reason it's boarded up. Maybe they should have just left it alone."
	credit_cost = CARGO_CRATE_VALUE * 30

/datum/map_template/shuttle/emergency/omega
	suffix = "omega"
	name = "N-Corporation Mackerel Transport"
	description = "On the smaller size with a modern design, this shuttle is for the crew who like the cosier things, while still being able to stretch their legs."
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/cruise
	suffix = "cruise"
	name = "The ISS Partyboat"
	description = "Ordinarily reserved for special functions and events, this retrofitted cruise ship can bring a summery cheer to your next joyride in low orbit for a 'modest' fee!"
	admin_notes = "This motherfucker is BIG. You might need to force dock it."
	credit_cost = CARGO_CRATE_VALUE * 100

/datum/map_template/shuttle/emergency/monkey
	suffix = "nature"
	name = "Crazy Monkey Business Transport"
	description = "A large shuttle with a center biodome that is flourishing with life. Frolick with the monkeys! (Extra monkeys are stored on the bridge.)"
	admin_notes = "Pretty freakin' large, almost as big as Raven or Cere. Excercise caution with it."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/ferry/base
	suffix = "base"
	name = "transport ferry"
	description = "Standard issue Box/Metastation CentCom ferry."

/datum/map_template/shuttle/ferry/meat
	suffix = "meat"
	name = "\"meat\" ferry"
	description = "Ahoy! We got all kinds o' meat aft here. Meat from plant people, people who be dark, not in a racist way, just they're dark black. \
	Oh and lizard meat too,mighty popular that is. Definitely 100% fresh, just ask this guy here. *person on meatspike moans* See? \
	Definitely high quality meat, nothin' wrong with it, nothin' added, definitely no zombifyin' reagents!"
	admin_notes = "Meat currently contains no zombifying reagents, lizard on meatspike must be spawned in."

/datum/map_template/shuttle/ferry/lighthouse
	suffix = "lighthouse"
	name = "The Lighthouse(?)"
	description = "*static*... part of a much larger vessel, possibly military in origin. \
	The weapon markings aren't anything we've seen ...static... by almost never the same person twice, possible use of unknown storage ...static... \
	seeing ERT officers onboard, but no missions are on file for ...static...static...annoying jingle... only at The LIGHTHOUSE! \
	Fulfilling needs you didn't even know you had. We've got EVERYTHING, and something else!"
	admin_notes = "Currently larger than ferry docking port on Box, will not hit anything, but must be force docked. Trader and ERT bodyguards are not included."

/datum/map_template/shuttle/ferry/fancy
	suffix = "fancy"
	name = "fancy transport ferry"
	description = "At some point, someone upgraded the ferry to have fancier flooring... and fewer seats."

/datum/map_template/shuttle/ferry/kilo
	suffix = "kilo"
	name = "kilo transport ferry"
	description = "Standard issue N-Corporation Ferry for Kilo pattern stations. Includes additional equipment and rechargers."

/datum/map_template/shuttle/whiteship/box
	suffix = "box"
	name = "Hospital Ship"

/datum/map_template/shuttle/whiteship/meta
	suffix = "meta"
	name = "Salvage Ship"

/datum/map_template/shuttle/whiteship/pubby
	suffix = "pubby"
	name = "NT White UFO"

/datum/map_template/shuttle/whiteship/cere
	suffix = "cere"
	name = "NT Construction Vessel"

/datum/map_template/shuttle/whiteship/kilo
	suffix = "kilo"
	name = "NT Mining Shuttle"

/datum/map_template/shuttle/whiteship/donut
	suffix = "donut"
	name = "NT Long-Distance Bluespace Jumper"

/datum/map_template/shuttle/whiteship/delta
	suffix = "delta"
	name = "NT Frigate"

/datum/map_template/shuttle/whiteship/pod
	suffix = "whiteship_pod"
	name = "Salvage Pod"

/datum/map_template/shuttle/cargo/kilo
	suffix = "kilo"
	name = "supply shuttle (Kilo)"

/datum/map_template/shuttle/cargo/birdboat
	suffix = "birdboat"
	name = "supply shuttle (Birdboat)"

/datum/map_template/shuttle/cargo/donut
	suffix = "donut"
	name = "supply shuttle (Donut)"

/datum/map_template/shuttle/cargo/pubby
	suffix = "pubby"
	name = "supply shuttle (Pubby)"

/datum/map_template/shuttle/emergency/delta
	suffix = "delta"
	name = "N-Corporation Gecko Transport"
	description = "A large shuttle for a large station, this shuttle can comfortably fit all your overpopulation and crowding needs. Complete with all facilities plus additional equipment."
	admin_notes = "Go big or go home."
	credit_cost = CARGO_CRATE_VALUE * 15

/datum/map_template/shuttle/emergency/raven
	suffix = "raven"
	name = "N-Corporation Raven Corvette Vessel"
	description = "The N-Corporation Raven Corvette is a high-risk exploration vessel, on loan at great expense to your facility. \
	Always first to secure the scene before N-Corporation salvage tugs pick through orbital warzones for valuable remains, it also serves as transportation for executives who like to travel in style. \
	N-Corporation denies there are any threats in space for their personnel aside from defunct automated security systems in old orbital stations and vessels. Any rumors of alien life or ancient AI cores in orbit are blatantly false.\
	This vessel boasts shields and numerous anti-personnel turrets guarding its perimeter to fend off meteors and enemy boarding party attempts."
	admin_notes = "Comes with turrets that will target anything without the neutral faction (nuke ops, xenos etc, but not pets)."
	credit_cost = CARGO_CRATE_VALUE * 60

/datum/map_template/shuttle/emergency/zeta
	suffix = "zeta"
	name = "Tr%nPo2r& Z3TA"
	description = "A glitch appears on your monitor, flickering in and out of the options laid before you. \
	It seems strange and alien, you may need a special technology to access the signal.."
	admin_notes = "Has alien surgery tools, and a void core that provides unlimited power."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/emergency/zeta/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_ALIENTECH]

/datum/map_template/shuttle/arrival/box
	suffix = "box"
	name = "arrival shuttle (Box)"

/datum/map_template/shuttle/cargo/box
	suffix = "box"
	name = "cargo ferry (Box)"

/datum/map_template/shuttle/mining/box
	suffix = "box"
	name = "mining shuttle (Box)"

/datum/map_template/shuttle/labour/box
	suffix = "box"
	name = "labour shuttle (Box)"

/datum/map_template/shuttle/arrival/donut
	suffix = "donut"
	name = "arrival shuttle (Donut)"

/datum/map_template/shuttle/infiltrator/basic
	suffix = "basic"
	name = "basic syndicate infiltrator"

/datum/map_template/shuttle/infiltrator/advanced
	suffix = "advanced"
	name = "advanced syndicate infiltrator"

/datum/map_template/shuttle/cargo/delta
	suffix = "delta"
	name = "cargo ferry (Delta)"

/datum/map_template/shuttle/mining/delta
	suffix = "delta"
	name = "mining shuttle (Delta)"

/datum/map_template/shuttle/mining/kilo
	suffix = "kilo"
	name = "mining shuttle (Kilo)"

/datum/map_template/shuttle/mining/large
	suffix = "large"
	name = "mining shuttle (Large)"

/datum/map_template/shuttle/labour/delta
	suffix = "delta"
	name = "labour shuttle (Delta)"

/datum/map_template/shuttle/labour/kilo
	suffix = "kilo"
	name = "labour shuttle (Kilo)"

/datum/map_template/shuttle/mining_common/meta
	suffix = "meta"
	name = "lavaland shuttle (Meta)"

/datum/map_template/shuttle/mining_common/kilo
	suffix = "kilo"
	name = "lavaland shuttle (Kilo)"

/datum/map_template/shuttle/arrival/delta
	suffix = "delta"
	name = "arrival shuttle (Delta)"

/datum/map_template/shuttle/arrival/kilo
	suffix = "kilo"
	name = "arrival shuttle (Kilo)"

/datum/map_template/shuttle/arrival/pubby
	suffix = "pubby"
	name = "arrival shuttle (Pubby)"

/datum/map_template/shuttle/arrival/omega
	suffix = "omega"
	name = "arrival shuttle (Omega)"

/datum/map_template/shuttle/aux_base/default
	suffix = "default"
	name = "auxilliary base (Default)"

/datum/map_template/shuttle/aux_base/small
	suffix = "small"
	name = "auxilliary base (Small)"

/datum/map_template/shuttle/escape_pod/default
	suffix = "default"
	name = "escape pod (Default)"

/datum/map_template/shuttle/escape_pod/large
	suffix = "large"
	name = "escape pod (Large)"

/datum/map_template/shuttle/assault_pod/default
	suffix = "default"
	name = "assault pod (Default)"

/datum/map_template/shuttle/pirate/default
	suffix = "default"
	name = "pirate ship (Default)"

/datum/map_template/shuttle/hunter/space_cop
	suffix = "space_cop"
	name = "Police Spacevan"

/datum/map_template/shuttle/hunter/russian
	suffix = "russian"
	name = "Russian Cargo Ship"

/datum/map_template/shuttle/hunter/bounty
	suffix = "bounty"
	name = "Bounty Hunter Ship"

/datum/map_template/shuttle/ruin/caravan_victim
	suffix = "caravan_victim"
	name = "Small Freighter"

/datum/map_template/shuttle/ruin/pirate_cutter
	suffix = "pirate_cutter"
	name = "Pirate Cutter"

/datum/map_template/shuttle/ruin/syndicate_dropship
	suffix = "syndicate_dropship"
	name = "Syndicate Dropship"

/datum/map_template/shuttle/ruin/syndicate_fighter_shiv
	suffix = "syndicate_fighter_shiv"
	name = "Syndicate Fighter"

/datum/map_template/shuttle/snowdin/mining
	suffix = "mining"
	name = "Snowdin Mining Elevator"

/datum/map_template/shuttle/snowdin/excavation
	suffix = "excavation"
	name = "Snowdin Excavation Elevator"
