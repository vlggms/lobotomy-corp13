/mob/living/simple_animal/hostile/abnormality/der_freischutz
	name = "Der Freischutz"
	desc = "A tall man adorned in grey, gold, and regal blue. His aim is impeccable."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "derfreischutz"
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 30, // Can you believe he has actual attachment work rates in LC proper, despite that you can't do attachment work on him there?
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 60, 60, 60)
		)
	work_damage_amount = 4
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		)

/mob/living/simple_animal/hostile/abnormality/der_freischutz/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
    if(get_attribute_level(user, JUSTICE_ATTRIBUTE) >= 60)
        datum_reference.qliphoth_change(-1)
    return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/failure_effect(mob/living/carbon/human/user, work_type, pe)
    datum_reference.qliphoth_change(-(prob(75)))
    return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/neutral_effect(mob/living/carbon/human/user, work_type, pe)
    datum_reference.qliphoth_change(-(prob(50)))
    return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/zero_qliphoth(mob/living/carbon/human/user)
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -32
	base_pixel_x = -32
	update_icon()
	datum_reference.qliphoth_change(3)
	return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/find_target()
	var/list/freischutz_list
	for(var/mob/living/L in urange(45, src))
		if(faction_check_mob(L)!=station)
			continue
		freischutz_list.Add(L)
	var/freischutz_target = pick(freischutz_list)
	var/central_center
	for(var/turf/T in GLOB.department_centers)
		if(istype(get_area(T),/area/department_main/command))
			central_center = T
			break
	var/freischutz_direction
	var/aim_x = freischutz_target.x
	var/aim_y = freischutz_target.y
	if(abs(central_center.x - freischutz_target.x) >= abs(central_center.y - freischutz_target.y))
		if(central_center.x > freischutz_target.x)
			freischutz_direction = EAST
		else
			freischutz_direction = WEST
	else
		if(central_center.y > freischutz_target.y)
			freischutz_direction = NORTH
		else
			freischutz_direction = SOUTH
	return(aim_x, aim_y, freischutz_direction)

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/fire_magic_bullet(aim_x = 128, aim_y = 128, frei_dir = SOUTH)
	var/bullet_time = world.time + 30
	var/portal_time = world.time + 6
	var/num_portals = 0
	var/stepcount
	var/list/portals
	var/turf/T = locate(aim_x,aim_y,src.z)
	var/loaded = 1
	playsound(T, 'sound/abnormalities/freischutz/prepare.ogg', 100, 1)
	for(loaded)
		if((world.time >= portal_time) && (num_portals < 4))
			var/obj/effect/frei_magic/P = new(T)
			P.dir = frei_dir
			stepcount = num_portals * 8
			P.step(src,frei_dir,stepcount)
			num_portals += 1
			P.icon_state = "freicircle[num_portals]"
			P.update_icon()
			portals += P
			portal_time += 6
		else if(bullet_time >= world.time)
			continue
		else
			playsound(T, 'sound/abnormalities/freischutz/shoot.ogg', 100, 1)
			var/obj/effect/magic_bullet/B = new(T)
			B.dir = frei_dir
			B.
			for(var/obj/effect/frei_magic/P in portals)
				P.fade_out()
			loaded = 0

	return
