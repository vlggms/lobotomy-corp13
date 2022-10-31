/mob/living/simple_animal/hostile/abnormality/express_train
	name = "express train to hell"
	desc = "A creature with glowing eyes inside of an odd-looking ticket booth."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "express_booth"
	icon_living = "express_booth"
	faction = list("hostile")
	speak_emote = list("drones")

	threat_level = WAW_LEVEL
	start_qliphoth = 4
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 20,
						ABNORMALITY_WORK_INSIGHT = list(20, 30, 50, 65, 70),
						ABNORMALITY_WORK_ATTACHMENT = 20,
						ABNORMALITY_WORK_REPRESSION = list(20, 30, 50, 65, 70)
						)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	bound_width = 64

	ego_list = list(
		)

	var/meltdown_tick = 20 SECONDS
	var/meltdown_timer
	var/lightscount = 0

/mob/living/simple_animal/hostile/abnormality/express_train/Initialize()
	meltdown_timer = world.time + meltdown_tick
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/Life()
	if(meltdown_timer < world.time && !datum_reference.working)
		meltdown_timer = world.time + meltdown_tick
		datum_reference.qliphoth_change(-1)
		lightscount = 4 - datum_reference.qliphoth_meter
		src.update_overlays()
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/attempt_work(mob/living/carbon/human/user, work_type)
	meltdown_timer += 100 SECONDS
	switch(datum_reference.qliphoth_meter)
		if(0)
			for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
				H.adjustSanityLoss(50)
				H.adjustBruteLoss(-50)
		if(1)
			for(var/mob/living/carbon/human/H in livinginrange(30))
				H.adjustSanityLoss(50)
				H.adjustBruteLoss(-50)
		if(2)
			user.adjustSanityLoss(80)
			user.adjustBruteLoss(-80)
		if(3)
			user.adjustSanityLoss(40)
			user.adjustBruteLoss(-40)
		if(4)
			say("No tickets available. Thank you for your interest.")
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/work_complete(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(4)
	meltdown_timer = world.time + meltdown_tick
	src.update_overlays()
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/update_overlays()
	. = ..()
	var/mutable_appearance/lights_overlay = mutable_appearance(icon, "express_light1")
	if(lightscount)
		lights_overlay.icon_state = "express_light[lightscount]"
		say("Updating lights.")
	else
		say("Killing the lights.")
		cut_overlays()
		return
	. += lights_overlay
