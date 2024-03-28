/obj/projectile/despair_rapier
	name = "enchanted rapier"
	desc = "A magic rapier, enchanted by the sheer despair and suffering the knight has been through."
	icon_state = "despair"
	damage_type = PALE_DAMAGE
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
	damage = 25
	spread = 15

/obj/projectile/melting_blob
	name = "slime projectile"
	desc = "A glob of infectious slime. It's going for your heart."
	icon_state = "slime"
	hitsound = 'sound/abnormalities/meltinglove/ranged_hit.ogg'
	damage_type = BLACK_DAMAGE

	damage = 30 // Mainly a disabling tool, to pursue escaping opponents
	spread = 5
	slur = 5
	eyeblur = 5
	stamina = 30

/obj/projectile/melting_blob/prehit_pierce(atom/A)
	if(isliving(A) && isliving(firer))
		var/mob/living/mob_firer = firer
		var/mob/living/L = A
		if(mob_firer.faction_check_mob(L))
			return PROJECTILE_PIERCE_PHASE
	return ..()

/obj/projectile/melting_blob/on_hit(target)
	if(isliving(target))
		new /obj/effect/gibspawner/generic/silent/melty_slime(get_turf(target))
		var/mob/living/L = target
		if(L.stat == DEAD && ishuman(L))
			var/turf/T = get_turf(L)
			visible_message("<span class='danger'>[L] is submerged in slime as another slime pawn appears!</span>")
			L.gib()
			new /mob/living/simple_animal/hostile/slime(T)
			return BULLET_ACT_HIT
		if(!isbot(L))
			L.visible_message("<span class='warning'>[L] is hit by [src], they seem to wither away!</span>")
			L.apply_status_effect(/datum/status_effect/melty_slimed)
			return BULLET_ACT_HIT
	return ..()

/obj/projectile/melting_blob/enraged
	desc = "A glob of infectious slime. It's going for your heart, It seems bigger..."
	damage = 40
	stamina = 40 // Ranged cooldown is 5 seconds on ML, so it theoretically cannot stam crit

/obj/projectile/mountain_spit
	name = "spit"
	desc = "Gross, disgusting spit."
	icon_state = "mountain"
	damage_type = BLACK_DAMAGE
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
	damage = 5

/obj/projectile/clown_throw/Initialize()
	. = ..()
	SpinAnimation()

/obj/projectile/clown_throw/on_hit(target)
	if(!ishuman(target))
		return ..()
	var/mob/living/carbon/human/H = target
	H.add_movespeed_modifier(/datum/movespeed_modifier/clowned)
	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/clowned), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	..()

/datum/movespeed_modifier/clowned
	variable = TRUE
	multiplicative_slowdown = 1.5

/obj/projectile/bride_bolts
	name = "mind bolts"
	desc = "A magic white bolt, enchanted to protect or to avenge the sculptor."
	icon_state = "bride_bolt"
	damage_type = WHITE_DAMAGE

	damage = 25
	spread = 10

/obj/projectile/bride_bolts_enraged
	name = "mind bolts"
	desc = "A magic white bolt, enchanted to protect or to avenge the sculptor."
	icon_state = "bride_bolt_enraged"
	damage_type = WHITE_DAMAGE

	damage = 50
	spread = 5

/obj/projectile/season_projectile
	name = "buggy mess"
	desc = "Report this to a dev"
	icon_state = "mountain"
	damage_type = RED_DAMAGE

	damage = 45

/obj/projectile/season_projectile/Moved(atom/OldLoc, Dir)
	. = ..()
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/effect/season_turf/temporary) in get_turf(src))
		return
	new /obj/effect/season_turf/temporary(get_turf(src))

/obj/projectile/season_projectile/spring
	name = "burr"
	desc = "A spiky burr"
	icon_state = "toxin"
	damage_type = WHITE_DAMAGE


/obj/projectile/season_projectile/summer
	name = "fireball"
	desc = "A ball of heated plasma"
	icon_state = "fireball"
	damage_type = RED_DAMAGE


/obj/projectile/season_projectile/fall
	name = "wisp"
	desc = "A glowing ember"
	icon_state = "pulse1"
	damage_type = BLACK_DAMAGE


/obj/projectile/season_projectile/winter
	name = "ice spear"
	desc = "A sharp-looking icicle"
	icon_state = "ice_2"
	damage_type = PALE_DAMAGE

	damage = 35

//slow, dodgable, and make it hard to see and talk
/obj/projectile/fleshblob
	name = "blood blob"
	icon_state = "mini_leaper"
	damage_type = RED_DAMAGE

	damage = 30
	spread = 15
	eyeblur = 10
	slur = 5
	speed = 2.4

/obj/projectile/actor
	name = "bullet"
	icon_state = "bullet"
	desc = "causes a lot of pain"
	damage_type = WHITE_DAMAGE

	damage = 10

/obj/projectile/actor/on_hit(target)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(!H.sanity_lost)
		return
	damage = 0
	QDEL_NULL(H.ai_controller)
	H.ai_controller = /datum/ai_controller/insane/suicide/scene
	H.InitializeAIController()
	H.apply_status_effect(/datum/status_effect/panicked_type/scene)

/obj/projectile/thunder_tomahawk
	name = "tomahawk"
	desc = "Look out!"
	icon = 'icons/obj/ego_weapons.dmi'
	icon_state = "warring2_firey"
	damage_type = BLACK_DAMAGE

	damage = 45

/obj/projectile/thunder_tomahawk/Initialize()
	. = ..()
	SpinAnimation()

/obj/projectile/beam/water_jet //it's just a reskin for gold ordeals
	name = "water jet"
	icon_state = "snapshot"
	hitsound = null
	damage = 10
	damage_type = WHITE_DAMAGE

	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/snapshot
	tracer_type = /obj/effect/projectile/tracer/laser/snapshot
	impact_type = /obj/effect/projectile/impact/laser/snapshot
	wound_bonus = -100
	bare_wound_bonus = -100

/obj/projectile/hunter_blade
	name = "hunter's scythe"
	desc = "A weapon thrown with deadly accuracy."
	icon_state = "hunter_blade_animated"
	projectile_piercing = PASSMOB
	range = 10
	nondirectional_sprite = TRUE
	speed = 1
	pixel_y = 16
	hitsound = 'sound/abnormalities/redhood/attack_2.ogg'

/obj/projectile/hunter_blade/on_hit(atom/target, blocked = FALSE, pierce_hit)
	var/living = FALSE
	if(!isliving(target))
		return ..()
	var/mob/living/attacked_mob = target
	if(attacked_mob.stat != DEAD)
		living = TRUE
	..()
	if(attacked_mob.stat == DEAD && living)
		var/mob/living/simple_animal/hostile/abnormality/red_hood/red_owner
		red_owner.ConfirmRangedKill(0.1)

/obj/projectile/red_hollowpoint
	name = "hollowpoint shell"
	desc = "A bullet fired from a red-cloaked mercenary's ruthless weapon."
	icon_state = "loyalty"
	range = 15
	speed = 0.6
	spread = 10
	pixel_y = 30

/obj/projectile/red_hollowpoint/on_hit(atom/target, blocked = FALSE, pierce_hit)
	var/living = FALSE
	if(!isliving(target))
		return ..()
	var/mob/living/attacked_mob = target
	if(attacked_mob.stat != DEAD)
		living = TRUE
	..()
	if(attacked_mob.stat == DEAD && living)
		var/mob/living/simple_animal/hostile/abnormality/red_hood/red_owner
		red_owner.ConfirmRangedKill(0.1)
