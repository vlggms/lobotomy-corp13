//Dead Rabbits Boss
/datum/job/DeadRabbitsBoss
	title = "Dead Rabbits Boss"
	outfit = /datum/outfit/job/DeadRabbitsBoss
	department_head = list("The Ring.")
	faction = "Station"
	supervisors = "Fauvists."
	selection_color = "#cccccc"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_CITY_ANTAGONIST
	paycheck = 700
	maptype = list("city")
	job_important = "This is a roleplay role. You are the leader of the dead rabbits gang. \
			Your job is to get somewhere in your second life by ambushing lone people. \
			People can hire you to punt someone if they have the money to, carnivals and butchers are your allies. \
			If they scam you, you can do whatever to them. You may kill anyone in east alleyways without your permission.\
			You are supplied with dead rabbit gang members to do your bidding and to be manpower. \
			Your base is hidden in the alleyway in the east behind the NO ENTRY Door, east alleyways are your territory."
	job_notice = "You may kill gang members that disobey contract terms."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/DeadRabbitsBoss/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/DeadRabbit))
			processing.total_positions = 3
	. = ..()


/datum/outfit/job/DeadRabbitsBoss
	name = "Dead Rabbits Boss"
	jobtype = /datum/job/DeadRabbitsBoss

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list(/obj/item/structurecapsule/syndicate/DeadRabbit)
	shoes = /obj/item/clothing/shoes/jackboots
