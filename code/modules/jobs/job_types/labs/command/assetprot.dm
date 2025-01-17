/datum/job/asset_protection
	title = "LC Asset Protection"
	faction = "Station"
	supervisors = "Limbus Company Executives"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#444444"
	trusted_only = TRUE
	outfit = /datum/outfit/job/asset_protection

	access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)
	departments = DEPARTMENT_COMMAND

	job_attribute_limit = 0

	display_order = 2
	alt_titles = list()
	job_abbreviation = "OVR"
	maptype = "limbus_labs"
	job_important = "You are the LC Asset Protection. Your job is to make sure that all assets are taken care of, and that no abnormalites are suppressed. Report to the Executives (Admins) as needed."

/datum/job/asset_protection/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	add_verb(H, /mob/living/carbon/human/proc/peccetulum_spawn)

/datum/outfit/job/asset_protection
	name = "LC Asset Protection"
	jobtype = /datum/job/asset_protection

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/radio


/mob/living/carbon/human/proc/peccetulum_spawn()
	set name = "Spawn Peccetulum"
	set category = "Gamemaster"

	var/list/peccetulum = list(
		/mob/living/simple_animal/hostile/ordeal/sin_gloom,
		/mob/living/simple_animal/hostile/ordeal/sin_gluttony,
		/mob/living/simple_animal/hostile/ordeal/sin_pride,
		/mob/living/simple_animal/hostile/ordeal/sin_lust,
		/mob/living/simple_animal/hostile/ordeal/sin_wrath
	)

	message_admins("<span class='notice'>Asset Protection ([src.ckey]) has spawned Peccetulum.</span>")
	var/turf/W = pick(GLOB.xeno_spawn)
	for(var/turf/T in orange(1, W))
		var/spawning = pick(peccetulum)
		if(prob(40))
			new spawning (T)
	minor_announce("LCD and Asset acquisition has delivered new minor abnormalities to study. Caution, they may be extremely hostile.", "LCD Team update:", TRUE)


