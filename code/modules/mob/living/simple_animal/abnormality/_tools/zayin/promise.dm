/obj/structure/toolabnormality/promise
	name = "old faith and promise"
	desc = "A mysterious marble which hangs in a Containment Unit."
	icon_state = "promise"
	var/processing = FALSE

/obj/structure/toolabnormality/promise/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 0.5 SECONDS))
		to_chat(user, "<span class='notice'>You decide you want to keep [I].</span>")
		return
	if(processing)
		to_chat(user, "<span class='notice'>[src] is busy!</span>")
		return

	if(istype(I, /obj/item/ego_weapon))
		var/obj/item/ego_weapon/theweapon = I
		if(theweapon.force_multiplier == 1)
			DoTheThing(I, 50)
		else if(theweapon.force_multiplier <= 1.2)
			DoTheThing(I, 25)
		else
			to_chat(user, "<span class='notice'>You can no longer improve [I]!</span>")
			return

	if(istype(I, /obj/item/gun/ego_gun/pistol) || istype(I, /obj/item/gun/ego_gun) && !istype(I, /obj/item/gun/ego_gun/clerk))
		var/obj/item/gun/thegun = I
		if(thegun.projectile_damage_multiplier == 1)
			DoTheOtherThing(I, 50)
		else if(thegun.projectile_damage_multiplier <= 1.2)
			DoTheOtherThing(I, 25)
		else
			to_chat(user, "<span class='notice'>You can no longer improve [I]!</span>")
			return

/obj/structure/toolabnormality/promise/proc/DoTheThing(obj/item/ego_weapon/I, successrate)
	processing = TRUE
	I.forceMove(src)
	if(prob(successrate))
		SuccessEffect()
		I.force_multiplier += 0.1
		I.forceMove(get_turf(src))
	else
		FailureEffect()
		qdel(I)
	color = null
	processing = FALSE

/obj/structure/toolabnormality/promise/proc/DoTheOtherThing(obj/item/gun/I, successrate)
	processing = TRUE
	I.forceMove(src)
	if(prob(successrate))
		SuccessEffect()
		I.projectile_damage_multiplier += 0.1
		I.forceMove(get_turf(src))
	else
		FailureEffect()
		qdel(I)
	color = null
	processing = FALSE

/obj/structure/toolabnormality/promise/proc/SuccessEffect() //Success Effects
	animate(src, color = "#FFD700", time = 10 SECONDS)
	RotateVFX()
	playsound(src.loc, 'sound/abnormalities/promise/process.ogg', 100, FALSE)
	sleep(3 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/marble.ogg', 100, FALSE)
	sleep(3 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/marble.ogg', 100, FALSE)
	sleep(3 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/result.ogg', 100, FALSE)
	sleep(1 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/success.ogg', 125, FALSE)

/obj/structure/toolabnormality/promise/proc/FailureEffect() //Failure Effects
	animate(src, color = "#000000", time = 10 SECONDS)
	RotateVFX()
	playsound(src.loc, 'sound/abnormalities/promise/process.ogg', 100, FALSE)
	sleep(3 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/marble.ogg', 100, FALSE)
	sleep(3 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/marble.ogg', 100, FALSE)
	sleep(3 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/result.ogg', 100, FALSE)
	sleep(1 SECONDS)
	playsound(src.loc, 'sound/abnormalities/promise/fail.ogg', 125, FALSE)

/obj/structure/toolabnormality/promise/proc/RotateVFX()
	set waitfor = FALSE
	var/matrix/M = matrix()
	var/degree = 0
	for(var/i in 1 to 10)
		switch(degree)
			if(0)
				M.TurnTo(0, 80)
				degree = 80
			if(80)
				M.TurnTo(80, -80)
				degree = -80
			if(-80)
				M.TurnTo(-80, 80)
				degree = 80
		if(i == 10)
			M.TurnTo(degree, 0)
		var/waittime = (10 - i)
		animate(src, transform = M, time = (waittime + 6), ANIMATION_LINEAR_TRANSFORM )
		sleep(waittime + 5)
