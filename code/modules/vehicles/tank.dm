//BM SPEEDWAGON

/obj/vehicle/ridden/tank
	name = "R Corp Tank"
	desc = "Push it to the limit, walk along the razor's edge."
	icon = 'icons/obj/car.dmi'
	icon_state = "speedwagon"
	layer = LYING_MOB_LAYER
	var/static/mutable_appearance/overlay
	max_buckled_mobs = 4
	var/crash_all = FALSE //CHAOS
	pixel_y = -48
	pixel_x = -48

/obj/vehicle/ridden/speedwagon/Initialize()
	. = ..()
	overlay = mutable_appearance(icon, "speedwagon_cover", ABOVE_MOB_LAYER)
	add_overlay(overlay)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/speedwagon)

/obj/vehicle/ridden/speedwagon/Bump(atom/A)
	. = ..()
	if(!A.density || !has_buckled_mobs())
		return

	var/atom/throw_target = get_edge_target_turf(A, dir)
	if(crash_all)
		if(ismovable(A))
			var/atom/movable/AM = A
			AM.throw_at(throw_target, 4, 3)
		visible_message("<span class='danger'>[src] crashes into [A]!</span>")
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.Paralyze(100)
		H.adjustStaminaLoss(30)
		H.apply_damage(rand(20,35), BRUTE)
		if(!crash_all)
			H.throw_at(throw_target, 4, 3)
			visible_message("<span class='danger'>[src] crashes into [H]!</span>")
			playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
