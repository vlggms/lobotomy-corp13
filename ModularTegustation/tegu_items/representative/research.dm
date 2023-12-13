
/*Representative Datum that contains research procs
	Researched var is for if we have already bought
	this research and it is a one time thing.*/
/datum/data/lc13research
	var/research_name = "ERROR"
	var/research_desc = "ERROR"
	var/cost = 0
	//What type of rep is this research visable to.
	var/corp
	//for repeatable research cooldowns.
	var/repeat_cooldown = 0
	//research required for this to appear.
	//I tried making this a list but the methods i used didnt work. -IP
	var/required_research

//Pre loaded with making researched true since most researches will only happen once.
/datum/data/lc13research/proc/ResearchEffect(obj/structure/representative_console/caller)
	caller.researched_stuff += src

/datum/data/lc13research/proc/CanResearch(obj/structure/representative_console/caller)
	if(!ReqResearch(caller, required_research))
		return FALSE
	if(repeat_cooldown > world.time)
		return FALSE
	return TRUE

//Proc that returns false if any of the research that is required is missing from the callers researched_stuff.
/datum/data/lc13research/proc/ReqResearch(obj/structure/representative_console/caller, research_needed)
	var/req = locate(research_needed) in caller.research_list
	if(!req || LAZYFIND(caller.researched_stuff, req))
		return TRUE
	return FALSE

/* Generalized item unlock for the ahn section.
	Override this section with a proc in order
	to make it effect stuff outside the console.*/
/datum/data/lc13research/proc/ItemUnlock(list/for_sale, product_name, product_path, product_cost)
	var/list/product = list( new /datum/data/extraction_cargo(product_name, product_path, product_cost, corp) = 1)
	LAZYADD(for_sale, product)

//Utilize mobspawners in the ghost_role_spawners.dm file.
/datum/data/lc13research/mobspawner
	var/mobspawner_type

/datum/data/lc13research/mobspawner/ResearchEffect(obj/structure/representative_console/caller)
	var/landing_zone = AnalyzeLandingZone()
	if(!landing_zone)
		//Well shit i guess we will just land here.
		landing_zone = get_turf(src)
	new mobspawner_type(landing_zone)
	..()

//Makes sure we spawn the mobspawner in a safe area.
/datum/data/lc13research/mobspawner/proc/AnalyzeLandingZone()
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		//if the landing zone is hot just skip it.
		if(locate(/mob/living/simple_animal/hostile/abnormality) in get_area(T))
			continue
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return pick(GLOB.department_centers)
	return pick(teleport_potential)

//This honestly doesnt help with understanding because im already adding + 10 to some of these. We just need a standard.
#define LOW_RESEARCH_PRICE 5
#define AVERAGE_RESEARCH_PRICE 10
#define HIGH_RESEARCH_PRICE 25
#define MAX_RESEARCH_PRICE 50

/*	Unfinished
/datum/data/lc13research/mobspawner/association
	research_name = "Association Call"
	research_desc = "Send out the local association. It's pricy, but they're worth it <br>."
	cost = HIGH_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/association/zwei
	var/list/associationspawners = list(
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/hana,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/zwei,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/shi,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/shi5,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/cinq,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/liu,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/liu6,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/seven,
	)

/datum/data/lc13research/mobspawner/association/ResearchEffect(obj/structure/representative_console/caller)
	mobspawner_type = pick(associationspawners)
	..()	*/
