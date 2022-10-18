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
	var/tick = 60 SECONDS
	var/timer = 0 SECONDS
	var/list/lights = list() // A list that will only ever contain one object, so that I can declare the list out here and refer to it anywhere. This feels like the wrong solution.

/mob/living/simple_animal/hostile/abnormality/express_train/Initialize()
	timer = world.time + tick
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/Life()
	if(world.time < timer)
		timer = world.time + tick
		if(datum_reference.qliphoth_meter > 0)
			datum_reference.qliphoth_change(-1)
			if(!LAZYLEN(lights))
				var/obj/effect/express_light/L = new(get_turf(src))
				lights += L
				say("Let there be light.")
			else
				var/lightsnum = 4 - datum_reference.qliphoth_meter
				for(var/obj/effect/express_light/L in lights)
					L.icon_state = "express_light[lightsnum]"
				say("Counting down.")
		else
			for(var/obj/effect/express_light/L in lights)
				L.disappear()
			say("Timer at zero.")
			datum_reference.qliphoth_change(4)
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/zero_qliphoth(mob/living/carbon/human/user)
	say("You buffoon. You imbecile. You absolute fucking donkey. You've let yourself run out of time.")
	return ..()
