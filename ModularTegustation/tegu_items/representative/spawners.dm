
//R CORP Mobspawners
/obj/effect/mob_spawn/human/supplypod/r_corp
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "rabbit_logo"
	short_desc = "You are part of the 4th pack. A subsidiary of the miliaristic R corp which is assigned to handle requests from their long time client L corp."
	flavour_text = "Your team is regularly sent in to L corp in order to handle hostile elements. \
	Use your gun in hand to change its damage type. L corp is supplying us these special bullets for whatever they are holding in there. \
	Teleport in, graze the grass, then teleport out for debriefing."
	//This is the size of the team.
	uses = 6
	var/spawn_level = 60
	faction = list("neutral", "rabbit")
	var/team_name = "rabbit team"

/obj/effect/mob_spawn/human/supplypod/r_corp/Initialize(mapload, datum/team/ert/rabbit_team)
	. = ..()
	notify_ghosts("A [team_name] has been requested at [get_area(src)]!", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE)

/obj/effect/mob_spawn/human/supplypod/r_corp/allow_spawn(mob/user)
	if(!(user.key in players_spawned))//one per person
		return TRUE
	to_chat(user, "<span class='warning'><b>Fourth Pack HQ: Sending in another team would cost more energy from our hatcheries than we are being paid.</b>.</span>")
	return FALSE

/obj/effect/mob_spawn/human/supplypod/r_corp/special(mob/living/carbon/human/new_spawn)
	..()
	new_spawn.adjust_all_attribute_levels(spawn_level)
	new_spawn.fully_replace_character_name(null, "[assignedrole] [new_spawn.real_name]([rand(1,999)])")
	ADD_TRAIT(new_spawn, TRAIT_COMBATFEAR_IMMUNE, type)
	ADD_TRAIT(new_spawn, TRAIT_WORK_FORBIDDEN, type)

//Rabbit Mobspawner
/obj/effect/mob_spawn/human/supplypod/r_corp/rabbit_call
	name = "rabbit teleport zone"
	desc = "A authorized zone for teleporting in rabbits."
	mob_name = "Suppressive Rabbit"
	outfit = /datum/outfit/centcom/ert/security/rabbit
	assignedrole = "SGT"

//Raven Mobspawner
/obj/effect/mob_spawn/human/supplypod/r_corp/raven_call
	name = "raven teleport zone"
	desc = "A authorized zone for teleporting in ravens."
	mob_name = "Scout Raven"
	outfit = /datum/outfit/job/raven
	assignedrole = "SPC"
	spawn_level = 40

/obj/effect/mob_spawn/human/supplypod/r_corp/raven_call/special(mob/living/new_spawn)
	..()
	H.adjust_attribute_level(JUSTICE_ATTRIBUTE, 60)

//Rhino Mobspawner
/obj/effect/mob_spawn/human/supplypod/r_corp/rhino_call
	name = "rhino teleport zone"
	desc = "A authorized zone for teleporting in rhinos."
	mob_name = "Gunner Rhino"
	outfit = /datum/outfit/centcom/ert/security/rhino
	assignedrole = "SGT"
	uses = 3

/obj/effect/mob_spawn/human/supplypod/r_corp/rhino_call/PrepareForHellDiving(mob/living/user)
	var/obj/vehicle/sealed/mecha/combat/rhino/mech = new
		//Step 1 pick a acceptable turf to land. No dense turf or tables.
	var/turf/LZ = pick(acceptable_turf)
		//Step 2 spawn the pod we land in.
	var/obj/structure/closet/supplypod/centcompod/pod = new
		//Step 3 learn that the landing zone is actually a effect that requires a defined landing turf and pod.
	new /obj/effect/pod_landingzone(get_turf(LZ), pod)
		//Step 4 INSERT INTO POD!
	mech.forceMove(pod)
	mech.mob_enter(user)


//Wcorp Mobspawners
/obj/effect/mob_spawn/human/supplypod/r_corp/wcorp_call
	name = "Wcorp L1 teleport zone"
	desc = "A authorized zone for teleporting in wcorp trainees."
	short_desc = "You are part of the WARP Cleanup Crew, stick together and help cleanup to gain some experience."
	flavour_text = "Your team is new to assisting L-Corp, you're just looking for that monthly bonus, and to skip 2 weeks of training. Fight out as long as you can."
	mob_name = "Cleanup Agent"
	outfit = /datum/outfit/wcorp
	assignedrole = "L0"
	spawn_level = 40
	faction = list("neutral", "wcorp")
	icon_state = "Warp"
	uses = 10	//More because they suck

/obj/effect/mob_spawn/human/supplypod/r_corp/wcorp_call/level3
	name = "Wcorp L2 teleport zone"
	desc = "A authorized zone for teleporting in wcorp L2 agents."
	flavour_text = "Your team is new to assisting L-Corp, you're just looking for that monthly bonus. Fight out as long as you can."
	outfit = /datum/outfit/wcorp/level2
	assignedrole = "L2"
	spawn_level = 80
	uses = 4	//Not at much.


//Fixers
/obj/effect/mob_spawn/human/supplypod/r_corp/zwei_call
	name = "Zwei teleport zone"
	desc = "A authorized zone for teleporting in zwei fixers."
	short_desc = "You are part of the Zwei Association, stick together and assist the people of htis station."
	flavour_text = "You've been paid to assist L-Corp today. Be their shield"
	mob_name = "Zwei Fixer"
	outfit = /datum/antagonist/ert/zwei_shield
	assignedrole = "Z6"
	spawn_level = 60
	faction = list("neutral", "zwei")
	icon_state = "zwei"
	uses = 8	//More because they job
