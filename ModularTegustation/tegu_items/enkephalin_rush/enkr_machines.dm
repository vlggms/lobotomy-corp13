/obj/machinery/button/door/landmarkspawner
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/button/door/landmarkspawner/attack_hand(mob/user)
	..()
	for(var/obj/effect/landmark/delayed/D in GLOB.landmarks_list)
		D.CreateLandmark(D.spawner)
