//Tegu Geneticist Edit

//Adds Medsci Radio to their lineup
/datum/outfit/job/geneticist/pre_equip(mob/living/carbon/human/H)
	..()
	var/datum/job/geneticist/J = SSjob.GetJobType(jobtype)
	if(J)
		ears = /obj/item/radio/headset/headset_medsci
