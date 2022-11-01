/obj/projectile/ego_bullet/ego_prank
	name = "prank"
	damage = 30
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_gaze
	name = "gaze"
	damage = 52 //Slow as balls
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE

//Homing weapon (Galaxy)
/obj/projectile/ego_bullet/ego_galaxy
	name = "galaxy"
	icon_state = "magicm"
	damage = 40
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	homing = TRUE
	speed = 1.5
	var/homing_range = 15
	var/list/targetslist = list()

/obj/projectile/ego_bullet/ego_galaxy/Initialize()
	..()
	for(var/mob/living/L in livinginview(homing_range, src))
		if(ishuman(L) || isbot(L))
			continue
		if(L.stat == DEAD)
			continue
		targetslist+=L
	if(!LAZYLEN(targetslist))
		return
	homing_target = pick(targetslist)
