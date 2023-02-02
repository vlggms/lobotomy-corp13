/obj/projectile/ego_bullet/ego_star
	name = "star"
	icon_state = "star"
	damage = 28 // Multiplied by 1.5x when at high SP
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE

/obj/projectile/ego_bullet/melting_blob
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	damage = 40	//Fires 3
	speed = 0.8
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	hitsound = "sound/effects/footstep/slime1.ogg"

/obj/projectile/ego_bullet/melting_blob/dot
	color = "#111111"

/obj/projectile/ego_bullet/melting_blob/dot/on_hit(target)
	. = ..()
	var/mob/living/H = target
	if(!isbot(H) && isliving(H))
		H.visible_message("<span class='warning'>[target] is hit by [src], they seem to wither away!</span>")
		for(var/i = 1 to 14)
			addtimer(CALLBACK(H, /mob/living/proc/apply_damage, rand(6,8), BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE)), 2 SECONDS * i)

/obj/projectile/ego_bullet/melting_blob/aoe
	color = "#6666BB"

/obj/projectile/ego_bullet/melting_blob/aoe/on_hit(target)
	. = ..()
	for(var/mob/living/L in view(2, target))
		new /obj/effect/temp_visual/revenant/cracks(get_turf(L))
		L.apply_damage(50, BLACK_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT

