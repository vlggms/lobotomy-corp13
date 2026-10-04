/obj/projectile/ego_bullet/soda_rifle/weak
	damage = 4

/obj/projectile/ego_bullet/shrimp_red
	name = "9mm soda bullet R"
	damage = 3
	range = 12
	spread = 20
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/shrimp_white
	name = "9mm soda bullet W"
	damage = 30
	speed = 0.1
	damage_type = WHITE_DAMAGE
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/shrimp_white/on_hit(atom/target, blocked = FALSE)
	..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.sanity_lost)
		var/obj/item/bodypart/head/head = H.get_bodypart("head")
		if(istype(head))
			if(QDELETED(head))
				return
			head.dismember()
			H.regenerate_icons()
			visible_message(span_danger("[H]'s head blew right off!"))

/obj/projectile/ego_bullet/shrimp_pale
	name = "9mm soda bullet P"
	damage = 6
	damage_type = PALE_DAMAGE

/obj/projectile/ego_bullet/ego_kcorp
	damage = 5

/obj/projectile/ego_bullet/ego_knade
	damage = 10
	speed = 1
	icon_state = "kcorp_nade"

/obj/projectile/ego_bullet/ego_knade/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/turf/T in view(1, src))
		for(var/mob/living/L in T)
			L.deal_damage(30, RED_DAMAGE, firer, attack_type = (ATTACK_TYPE_RANGED))
	new /obj/effect/explosion(get_turf(src))
	qdel(src)
	return BULLET_ACT_HIT

/obj/projectile/ego_bullet/flammenwerfer
	name = "flames"
	icon_state = "flamethrower_fire"
	damage = 1
	damage_type = RED_DAMAGE
	speed = 2
	range = 5
	hitsound_wall = 'sound/weapons/tap.ogg'
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser

/obj/projectile/ego_bullet/flammenwerfer/on_hit(atom/target, blocked = FALSE)
	..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	H.adjust_fire_stacks(0.1)
	H.IgniteMob()
	return BULLET_ACT_HIT

/obj/projectile/ego_bullet/fivedamage
	name = "bullet"
	damage = 5

//feather of honor
/obj/projectile/ego_bullet/ego_feather
	name = "feather"
	icon_state = "lava"
	damage = 15
	damage_type = WHITE_DAMAGE
	homing = TRUE
	speed = 0.75
	alpha = 0
	spread = 5

/obj/projectile/ego_bullet/ego_feather/Initialize()
	. = ..()
	hitsound = "sound/abnormalities/seasons/summer_attack.ogg"
	hitsound_wall = hitsound
	animate(src, alpha = 255, time = 2)

/obj/projectile/ego_bullet/ego_feather/fire()
	playsound(loc, "sound/abnormalities/seasons/summer_change.ogg", 5, TRUE, -1)
	. = ..()

/obj/projectile/ego_bullet/hatred_nihil
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	damage = 30
	spread = 0

/obj/projectile/ego_bullet/hatred_nihil/Initialize()
	. = ..()
	icon_state = "qoh[pick(1,2,3)]"

/obj/projectile/ego_bullet/hatred_nihil/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	var/obj/item/ego_weapon/ranged/hatred_nihil/staff = fired_from
	if(!isliving(target))
		return ..()
	var/mob/living/L = target
	var/old_stat = L.stat
	. = ..()
	if(.) // Hit passed and damage applied
		if((old_stat == DEAD) || L.status_flags & GODMODE)//if the target was already dead or godmode
			return
		var/heal_amt = damage*damage_multiplier*0.15
		if(isanimal(target))
			var/mob/living/simple_animal/S = L
			if(S.damage_coeff.getCoeff(damage_type) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
		if(heal_amt)
			staff.HealingAura(firer, heal_amt)
