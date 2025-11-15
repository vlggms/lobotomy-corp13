/mob/living/simple_animal/hostile/abnormality/der_fluschutze
	name = "Der Fluschutze"
	desc = "A tall man wearing ragged military fatigues. You can see the glint of a locket chained to his neck."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "DrFluShots"
	icon_living = "DrFluShots"
	icon_dead = "DrFluShots"
	portrait = "der_fluschutze"
	maxHealth = 300
	health = 300
	ranged = TRUE
	can_breach = TRUE
	casingtype = /obj/item/ammo_casing/caseless/ego_fellscatter
	projectilesound = 'sound/abnormalities/fluchschutze/fell_bullet.ogg'
	move_to_delay = 6
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.2)
	stat_attack = HARD_CRIT
	vision_range = 28
	aggro_vision_range = 40
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(20, 30, 60, 60, 60),
	)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride

	ego_list = list(
		/datum/ego_datum/weapon/fellbullet,
		/datum/ego_datum/weapon/fellscatter,
		/datum/ego_datum/armor/fellbullet,
	)
	gift_type =  /datum/ego_gifts/fellbullet
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "In this gory war, the devil approached me one day to suggest a deal. <br>\
		\"Thanks to that, I'm free to point the barrel at anyone I want. No matter where I fire it, this shotgun can blast anyone into fireworks like it hit them point blank, how wonderful is that? <br>\
		By the way, whose side are you on?\""
	observation_choices = list(
		"Tell him to look at the pendant on his neck" = list(TRUE, "Filled with rage, the shooter pointed its gun at me and pulled the trigger. <br>\
			However, the projectiles vanished in the air, and the shooter fell to the floor and started to cry."),
		"Say you're on his side" = list(FALSE, "The man scowls. <br>\"Let me do you a favor. \
		The people you love will remember you as yet another victim that lost their head."),
	)

	var/can_act = TRUE
	var/bullet_cooldown
	var/bullet_cooldown_time = 7 SECONDS
	var/bullet_fire_delay = 1.5 SECONDS
	var/bullet_max_range = 50
	var/bullet_damage = 50
	var/list/portals = list()
	var/zoomed = FALSE
	var/max_portals = 7
	var/current_portal_index = 0
	var/portal_cooldown
	var/portal_cooldown_time = 5 SECONDS
	var/icon_aim = 'ModularTegustation/Teguicons/64x64.dmi'

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/Move()
	if(!can_act)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/AttackingTarget(atom/attacked_target)
	if(ranged_cooldown <= world.time)
		OpenFire(attacked_target)
		return

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/OpenFire()
	if(!can_act)
		return
	var/portaling = FALSE
	if(portal_cooldown <= world.time)
		portaling = TRUE
	AimAnimation(portaling)
	if(portaling)
		CreatePortal(target)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	if(work_type != ABNORMALITY_WORK_ATTACHMENT)
		return
	datum_reference.qliphoth_change(-3)

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/proc/AimAnimation(portaling = FALSE)
	can_act = FALSE
	if(portaling)
		playsound(src, 'sound/abnormalities/fluchschutze/fell_portal.ogg', 80)
		filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=0, color=rgb(255, 0, 0))
	else
		new /obj/effect/temp_visual/cult/sparks(get_turf(target))
	playsound(src, 'sound/abnormalities/fluchschutze/fell_aim.ogg', 80)
	icon = icon_aim
	pixel_x -= 16
	sleep(5)
	icon = initial(icon)
	pixel_x += 16
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/der_fluschutze/proc/CreatePortal(target)
	portal_cooldown = world.time + portal_cooldown_time
	playsound(src, 'sound/abnormalities/fluchschutze/fell_bullet.ogg', 80)
	var/list/target_turfs = (oview(3, target))
	for(var/atom/A in target_turfs)
		if(!isturf(A))
			target_turfs -= A
		var/turf/T = A
		if(!isopenturf(T))
			target_turfs -= T
	if(!target_turfs)
		return
	var/turf/T = pick(target_turfs)
	var/obj/effect/fell_portal/myportal = new(T)
	filters = list()//clear all filters
	myportal.target = target
	sleep(15)

/obj/effect/fell_portal
	name = "magic circle"
	desc = "A circle of red magic featuring a six-pointed star "
	icon = 'icons/effects/effects.dmi'
	icon_state = "fellcircle"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER
	var/target

/obj/effect/fell_portal/Initialize()
	. = ..()
	var/matrix/init_transform = transform
	transform = transform*0.01
	animate(src, transform = init_transform, time = 5, easing = BACK_EASING)
	addtimer(CALLBACK(src, PROC_REF(Explode)))
	INVOKE_ASYNC(src, PROC_REF(DoAnimation))

/obj/effect/fell_portal/proc/Explode()
	sleep(5)
	playsound(src, 'sound/abnormalities/fluchschutze/fell_portal.ogg', 80)

	if(!target)
		target = get_turf(get_step(pick(GLOB.alldirs), 8))
	target = get_turf(target)//locked in
	dir = get_cardinal_dir(src, target)
	AdjustCircle()

	sleep(5)
	playsound(src, 'sound/abnormalities/fluchschutze/fell_bullet.ogg', 80)
	var/obj/projectile/P = new /obj/projectile/ego_bullet/ego_fellbullet()
	P.damage = 15//slightly weaker than normal
	P.preparePixelProjectile(target, src)
	P.fire(target)

/obj/effect/fell_portal/proc/DoAnimation()
	sleep(15)
	animate(src, alpha = 0, time = 1 SECONDS)
	QDEL_IN(src, 1 SECONDS)

/obj/effect/fell_portal/proc/AdjustCircle(angle)
	var/matrix/M = matrix(transform)
	var/rot_angle = angle
	M.Turn(rot_angle)
	switch(dir)
		if(EAST)
			M.Scale(0.5, 1)
			M.Translate(12, 0)
		if(WEST)
			M.Scale(0.5, 1)
			M.Translate(-16, 0)
		if(NORTH)
			M.Translate(0, 8)
	transform = M
