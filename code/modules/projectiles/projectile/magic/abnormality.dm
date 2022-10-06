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
	damage = 30
	alpha = 0
	spread = 45
	projectile_phasing = (ALL & (~PASSMOB))

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
		H.apply_damage(rand(mindmg,maxdmg), BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE))
		if(!isbot(H) && isliving(H))
			H.visible_message("<span class='warning'>[target] is hit by [src], they seem to wither away!</span>")
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

/obj/projectile/wellcheers
	name = "shaken can of 'Wellcheers' soda"
	desc = "A shaken can of soda."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "wellcheers_red"
	nodamage = TRUE

/obj/projectile/wellcheers/red
	name = "shaken can of cherry 'Wellcheers' soda"
	desc = "A shaken can of cherry-flavored soda."

/obj/projectile/wellcheers/red/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/cooler_target = target
		cooler_target.apply_status_effect(/datum/status_effect/wellcheers_bad/red)

/obj/projectile/wellcheers/white
	name = "shaken can of 'Wellcheers' soda"
	desc = "A shaken can of soda."
	icon_state = "wellcheers_white"

/obj/projectile/wellcheers/white/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/cooler_target = target
		cooler_target.apply_status_effect(/datum/status_effect/wellcheers_bad/white)

/obj/projectile/wellcheers/purple
	name = "shaken can of grape 'Wellcheers' soda"
	desc = "A shaken can of grape-flavored soda."
	icon_state = "wellcheers_purple"

/obj/projectile/wellcheers/purple/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/cooler_target = target
		cooler_target.apply_status_effect(/datum/status_effect/wellcheers_bad/purple)

/obj/projectile/queen_diamond
	name = "red diamond"
	desc = "A red diamond, symbolizing the power of royalty soaked in blood."
	icon_state = "queen_diamond"
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE
	damage = 40
	alpha = 0
	spread = 20
	projectile_piercing = PASSMOB
	nodamage = TRUE

/obj/projectile/queen_diamond/Initialize()
	. = ..()
	hitsound = 'sound/weapons/guillotine.ogg'
	animate(src, alpha = 255, time = 3)
	def_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG)

/obj/projectile/queen_diamond/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		if(ishostile(target) && !isnull(firer))
			var/mob/living/simple_animal/hostile/hostile_mob = target
			var/mob/living/simple_animal/hostile/abnormality/red_queen/RQ = firer
			if(RQ.faction_check_mob(hostile_mob, FALSE))
				return BULLET_ACT_BLOCK
		else
			return BULLET_ACT_BLOCK
	nodamage = FALSE
	var/mob/living/L = target
	..()
	if(L.health <= 0)
		if(def_zone != BODY_ZONE_CHEST && L.get_bodypart(def_zone))
			var/obj/item/bodypart/BP = L.get_bodypart(def_zone)
			BP.dismember() // Chop Chop
	qdel(src)
