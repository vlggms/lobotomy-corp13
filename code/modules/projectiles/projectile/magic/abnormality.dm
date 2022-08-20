/obj/projectile/despair_rapier
	name = "enchanted rapier"
	desc = "A magic rapier, enchanted by the sheer despair and suffering the knight has been through."
	icon_state = "despair"
	damage_type = PALE_DAMAGE
	flag = PALE_DAMAGE
	damage = 40
	alpha = 0
	spread = 20

/obj/projectile/despair_rapier/Initialize()
	. = ..()
	hitsound = "sound/weapons/ego/rapier[pick(1,2)].ogg"
	animate(src, alpha = 255, time = 3)

/obj/projectile/apocalypse
	name = "light"
	icon_state = "apocalypse"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 40
	alpha = 0
	spread = 45

/obj/projectile/apocalypse/Initialize()
	. = ..()
	animate(src, alpha = 255, pixel_x = rand(-10,10), pixel_y = rand(-10,10), time = 5 SECONDS)

/obj/projectile/hatred
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 25
	spread = 15

/obj/projectile/melting_blob
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	nodamage = TRUE
	spread = 10
	speed = 1.2
	hitsound = "sound/effects/footstep/slime1.ogg"
	var/maxdmg = null
	var/mindmg = null
	maxdmg = 90
	mindmg = 50

/obj/projectile/melting_blob/enraged
	desc = "A glob of infectious slime. It's going for your heart, It seems bigger..."
	maxdmg = 120
	mindmg = 60

/obj/projectile/melting_blob/on_hit(target)
	if(ismob(target))
		var/mob/living/H = target
		if("slime" in H.faction)
			H.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
		if(H.stat == DEAD && ishuman(H))
			var/turf/T = get_turf(H)
			visible_message("<span class='danger'>[src] submerge in slime \the [H] and another Slime Pawn appears!</span>")
			H.gib()
			new /mob/living/simple_animal/hostile/slime(T)
			return BULLET_ACT_HIT
		H.visible_message("<span class='warning'>[target] is hit by [src], they seem to wither away!</span>")
		H.apply_damage(rand(mindmg,maxdmg), BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE))
		if(!isbot(H) && isliving(H))
			for(var/i = 1 to 10)
				addtimer(CALLBACK(H, /mob/living/proc/apply_damage, rand(4,6), BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE)), 2 SECONDS * i)
			return BULLET_ACT_HIT
	. = ..()

/obj/projectile/mountain_spit
	name = "spit"
	desc = "Gross, disgusting spit."
	icon_state = "mountain"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 10 // Launches 32(96) of those, for a whooping 320(960) black damage
	spread = 60
	slur = 3
	eyeblur = 3

/obj/projectile/mountain_spit/Initialize()
	. = ..()
	speed += pick(0, 0.1, 0.2, 0.3) // Randomized speed

