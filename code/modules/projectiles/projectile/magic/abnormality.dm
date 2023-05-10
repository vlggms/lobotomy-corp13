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

/obj/projectile/despair_rapier/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	if(!ishuman(target))
		return ..()
	var/mob/living/carbon/human/H = target
	var/old_stat = H.stat
	. = ..()
	if(.) // Hit passed and damage applied
		if((old_stat < DEAD) && (H.stat >= DEAD))
			H.add_overlay(icon('ModularTegustation/Teguicons/tegu_effects.dmi', "despair_kill"))

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
		var/mob/living/mob_firer = firer
		if(istype(mob_firer) && mob_firer.faction_check_mob(H))
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
	damage = 15 // Launches 16(48) of those, for a whooping 240(720) black damage
	spread = 60
	slur = 3
	eyeblur = 3

/obj/projectile/mountain_spit/Initialize()
	. = ..()
	speed += pick(0, 0.1, 0.2, 0.3) // Randomized speed
	animate(src, transform = src.transform*pick(1.8, 2.4, 2.8, 3.2), time = rand(1,4))

/obj/projectile/mountain_spit/Range()
	for(var/mob/living/L in range(1, get_turf(src)))
		if(L.stat != DEAD && L != firer && !L.faction_check_mob(firer, FALSE))
			return Bump(L)
	..()

/obj/projectile/clown_throw
	name = "blade"
	desc = "A blade thrown maliciously"
	icon_state = "clown"
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE
	damage = 5

/obj/projectile/clown_throw/Initialize()
	. = ..()
	SpinAnimation()

/obj/projectile/clown_throw/on_hit(target)
	if(!ishuman(target))
		return ..()
	var/mob/living/carbon/human/H = target
	H.add_movespeed_modifier(/datum/movespeed_modifier/clowned)
	addtimer(CALLBACK(H, .mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/clowned), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	..()

/datum/movespeed_modifier/clowned
	variable = TRUE
	multiplicative_slowdown = 1.5

/obj/projectile/bride_bolts
	name = "mind bolts"
	desc = "A magic white bolt, enchanted to protect or to avenge the sculptor."
	icon_state = "bride_bolt"
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
	damage = 25
	spread = 10

/obj/projectile/bride_bolts_enraged
	name = "mind bolts"
	desc = "A magic white bolt, enchanted to protect or to avenge the sculptor."
	icon_state = "bride_bolt_enraged"
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
	damage = 50
	spread = 5
