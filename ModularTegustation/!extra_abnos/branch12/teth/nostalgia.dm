/mob/living/simple_animal/hostile/abnormality/branch12/nostalgia
	name = "Whiff of Nostalgia"
	desc = "A small vending machine that distributes small yellow capsules."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "nostalgia"
	icon_living = "nostalgia"
	threat_level = TETH_LEVEL

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 20,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 45,
	)
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/ready = TRUE
	ego_list = list(
		/datum/ego_datum/weapon/branch12/loving_memory,
		/datum/ego_datum/armor/branch12/loving_memory,
	)

/mob/living/simple_animal/hostile/abnormality/branch12/nostalgia/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		if(!ready)
			return
		var/transfer_capsule = user.maxSanity*0.4
		user.adjustSanityLoss(transfer_capsule)

		var/obj/item/nostalgia_capsule/spawning_capsule = new(get_turf(user))
		spawning_capsule.heal_amount = transfer_capsule
		ready = FALSE
		icon_state = "nostalgia_unpowered"
		addtimer(CALLBACK(src, PROC_REF(reset)), 60 SECONDS)


/mob/living/simple_animal/hostile/abnormality/branch12/nostalgia/proc/reset()
	icon_state = "nostalgia"
	ready = TRUE

	//Nostalgia Capsules
/obj/item/nostalgia_capsule
	name = "nostalgia capsule"
	desc = "A small yellow capsule holding some nostalgia."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "capsule"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/heal_amount = 10

/obj/item/nostalgia_capsule/attack_self(mob/living/carbon/human/user)
	..()
	to_chat(user, span_notice("You open the capsule and take a smell."))
	user.adjustSanityLoss(-heal_amount)
	qdel(src)
