//This golden bough should be placed at the end of away missions for ER - Mr.Heavenly
GLOBAL_VAR(bough_collected)//roundend text
/obj/structure/bough/mining//from rcorp's objective.dm

/obj/structure/bough/mining/RoundEndEffect(mob/living/carbon/human/user)
	if(!do_after(user, 10 SECONDS))
		return
	bastards += user.ckey
	clear_filters()
	bough.clear_filters()
	vis_contents.Cut()
	qdel(bough)
	light_on = FALSE
	update_light()

	if(!SSticker.force_ending)
		//Round End Effects
		SSvote.initiate_vote("restart", "golden bough")
		GLOB.roundend_music = file("sound/roundend/canto_1.ogg")//Hopefully I'm doing this correctly
		for(var/mob/M in GLOB.player_list)
			to_chat(M, span_userdanger("[uppertext(user.real_name)] has collected the bough!"))
		//The thread of prophecy has severed. You can choose to end the round here, or continue the doomed timeline you've created.
		GLOB.bough_collected = TRUE
	else
		var/turf/turf = get_turf(src)
		new /obj/effect/decal/cleanable/confetti(turf)
		playsound(turf, 'sound/misc/sadtrombone.ogg', 100)

/obj/structure/bough/gateway//this doesn't call RoundEndEffect
	var/mission_list = list(//IMPORTANT: these are not on the config or taken from the config. These maps must have the golden bough path above for the ER's objective.
		"_maps/templates/enkr_missions/lcorp_er_ver.dmm",
		)
	var/enabled = TRUE//please refer to the "mirror world" incident on 2/11/2025

/obj/structure/bough/gateway/attack_hand(mob/living/carbon/human/user)
	if(!enabled)
		to_chat(user, span_danger("Someone is already resonating with the golden bough!"))
		return
	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("[uppertext(user.real_name)] is resonating with the golden bough!"))
	enabled = FALSE
	if(!do_after(user, 10 SECONDS))
		enabled = TRUE
		return
	var/obj/machinery/gateway/centerstation/G = new(get_turf(src))
	GLOB.the_gateway = G
	Create_Away()
	qdel(src)

/obj/structure/bough/gateway/proc/Create_Away(mob/living/carbon/human/user)
	mission_list += "_maps/templates/enkr_missions/lcorp_er_ver.dmm"
	if(!mission_list)
		mission_list += GLOB.potentialRandomZlevels
	var/datum/space_level/away_level
	var/mymission = pick(mission_list)
	var/away_name = mymission
	to_chat(usr,span_notice("Loading [away_name]..."))
	var/datum/map_template/template = new(away_name, "Away Mission")
	away_level = template.load_new_z()
	if(!away_level)
		message_admins("Loading [away_name] failed!")
		return

/obj/structure/advmap_generator//causes thousands of runtimes- find a better solution.
	name = "ladder"
	desc = "generates adventure maps"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder01"
	var/map_file = "_maps/map_files/enkephalin_rush/adventure/great_lake.dmm"//change this when adding district4's map
	var/datum/space_level/adventure_level
	var/map_loaded//change this to be roundstart
	var/map_x = 0
	var/map_y = 0

/obj/structure/advmap_generator/attack_hand(mob/living/carbon/human/user)
	user.forceMove(locate(map_x, map_y, 7))//remove this shit

/obj/structure/advmap_generator/great_lake
	map_file = "_maps/map_files/enkephalin_rush/adventure/great_lake.dmm"
	desc = "A ladder leading into the lower decks."
	map_x = 128
	map_y = 4

/obj/structure/middle_ship
	name = "Middle Warship"
	desc = "A massive, flashy and intimidating warship. Electronic dance music loudly blares from its many speakers."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "middle_ship"
	anchored = TRUE

/obj/structure/middle_ship/attack_hand(mob/living/carbon/human/user)
	say("Arr! Sailors with short tow ropes ought to steer closer to the poop deck!")
	to_chat(user, "The Middle's warship is not available to enter yet.")
