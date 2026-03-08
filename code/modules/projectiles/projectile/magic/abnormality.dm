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

/obj/projectile/despair_rapier/justice
	desc = "A magic rapier, enchanted with the power of justice."
	nodamage = TRUE	//Damage is calculated later
	projectile_piercing = PASSMOB

/obj/projectile/despair_rapier/justice/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		nodamage = FALSE
	else
		return
	..()
	if(!ishuman(target))
		qdel(src)

/obj/projectile/apocalypse
	name = "light"
	icon_state = "apocalypse"
	damage_type = BLACK_DAMAGE
	damage = 14
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
	damage = 7
	spread = 15

/obj/projectile/melting_blob
	name = "slime projectile"
	desc = "A glob of infectious slime. It's going for your heart."
	icon_state = "slime"
	hitsound = 'sound/abnormalities/meltinglove/ranged_hit.ogg'
	damage_type = BLACK_DAMAGE

	damage = 10 // Mainly a disabling tool, to pursue escaping opponents
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
	damage = 15
	stamina = 40 // Ranged cooldown is 5 seconds on ML, so it theoretically cannot stam crit

/obj/projectile/mountain_spit
	name = "spit"
	desc = "Gross, disgusting spit."
	icon_state = "mountain"
	damage_type = BLACK_DAMAGE
	damage = 6 // Launches 16(48) of those, for a whooping 96(288) black damage
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
	damage = 3

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

/obj/projectile/clown_throw_rcorp
	name = "blade"
	desc = "A blade thrown maliciously"
	icon_state = "clown"
	damage_type = RED_DAMAGE
	nodamage = TRUE
	damage = 0
	projectile_piercing = PASSMOB
	ricochets_max = 2
	ricochet_chance = 100
	ricochet_decay_chance = 1
	ricochet_decay_damage = 2
	ricochet_auto_aim_range = 3
	ricochet_incidence_leeway = 0

/obj/projectile/clown_throw_rcorp/Initialize()
	. = ..()
	SpinAnimation()

/obj/projectile/clown_throw_rcorp/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	return FALSE

/obj/projectile/clown_throw_rcorp/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target))
		damage = 3
		nodamage = FALSE
		var/mob/living/carbon/human/H = target
		H.apply_lc_bleed(6)
		H.add_movespeed_modifier(/datum/movespeed_modifier/clowned)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/clowned), 1 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		qdel(src)

	if(istype(target, /mob/living))
		to_chat(target, "The [src] flies right passed you!")
		return
	..()

/obj/projectile/bride_bolts
	name = "mind bolts"
	desc = "A magic white bolt, enchanted to protect or to avenge the sculptor."
	icon_state = "bride_bolt"
	damage_type = WHITE_DAMAGE

	damage = 10
	spread = 10

/obj/projectile/bride_bolts_enraged
	name = "mind bolts"
	desc = "A magic white bolt, enchanted to protect or to avenge the sculptor."
	icon_state = "bride_bolt_enraged"
	damage_type = WHITE_DAMAGE
	damage = 20
	spread = 5

/obj/projectile/season_projectile
	name = "buggy mess"
	desc = "Report this to a dev"
	icon_state = "mountain"
	damage_type = RED_DAMAGE
	damage = 9

/obj/projectile/season_projectile/Moved(atom/OldLoc, Dir)
	. = ..()
	if(!istype(firer, /mob/living/simple_animal/hostile/abnormality/seasons))
		return
	var/mob/living/simple_animal/hostile/abnormality/seasons/source = firer
	if(!isturf(get_turf(src)) || isspaceturf(get_turf(src)))
		return
	if(locate(/obj/effect/season_turf) in get_turf(src))
		return
	var/obj/effect/season_turf/newturf = new(get_turf(src))
	source.spawned_turfs += newturf

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
	damage = 25

/obj/projectile/season_projectile/winter/weak
	damage = 20
	color = COLOR_DARK_CYAN
	spread = 15

/obj/projectile/season_projectile/winter/weakspready
	damage = 20
	spread = 360

/obj/projectile/season_projectile/winter/special
	name = "ice sphere"
	desc = "Stop reading this and run away!"
	icon_state = "ice_1"
	damage = 40
	speed = 6 // really slow projectile
	ricochet_chance = 100
	ricochets_max = 2
	ricochet_ignore_flag = TRUE // Heehoo

/obj/projectile/season_projectile/winter/special/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!isliving(target))
		return
	for(var/turf/T in view(2, get_turf(target)))
		if(get_dist(T,target) <= 1)
			continue
		var/obj/projectile/season_projectile/winter/weakspready/P = new(T)
		P.starting = T
		P.firer = firer
		P.fired_from = src
		P.yo = original.y - y
		P.xo = original.x - x
		P.original = original
		P.preparePixelProjectile(original, src)
		P.fire()

/obj/projectile/season_projectile/winter/special/Moved(atom/OldLoc, Dir)
	. = ..()
	var/the_turf = get_turf(src)
	var/splits = rand(1,3)
	for(var/k = 1 to splits)
		if(!original)
			break
		var/obj/projectile/season_projectile/winter/weakspready/P = new(the_turf)
		P.starting = the_turf
		P.firer = firer
		P.fired_from = src
		P.yo = original.y - y
		P.xo = original.x - x
		P.original = original
		P.preparePixelProjectile(original, src)
		P.fire()

/obj/projectile/fall_projectile
	name = "dark flame"
	desc = "Unnatural black flames"
	icon_state = "pulse1"
	damage_type = BLACK_DAMAGE
	damage = 3
	spread = 20
	speed = 2

/obj/projectile/fall_projectile/Initialize()
	. = ..()
	animate(src, transform = src.transform*pick(0.8, 1.2, 1.3, 1.4), time = rand(1,4))

/obj/projectile/fall_projectile/on_hit(target)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	L.apply_dark_flame(1)

/obj/projectile/needle_spring
	name = "needle"
	desc = "a thorn from a plant"
	icon_state = "needle"
	ricochet_chance = 60
	ricochets_max = 2
	damage = 5
	damage_type = WHITE_DAMAGE
	ricochet_ignore_flag = TRUE

/obj/projectile/needle_spring/can_hit_target(atom/target, direct_target, ignore_loc, cross_failed)
	if(!fired)
		return FALSE
	return ..()

/obj/projectile/needle_spring/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_venom(3)

/obj/projectile/actor
	name = "bullet"
	icon_state = "bullet"
	desc = "causes a lot of pain"
	damage_type = WHITE_DAMAGE
	damage = 5

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
	damage = 10

/obj/projectile/thunder_tomahawk/Initialize()
	. = ..()
	SpinAnimation()

/obj/projectile/beam/water_jet
	name = "water jet"
	icon_state = "snapshot"
	hitsound = null
	damage = 0
	damage_type = WHITE_DAMAGE
	hitscan = TRUE
	projectile_piercing = PASSMOB
	muzzle_type = /obj/effect/projectile/muzzle/laser/snapshot
	tracer_type = /obj/effect/projectile/tracer/laser/snapshot
	impact_type = /obj/effect/projectile/impact/laser/snapshot
	wound_bonus = -100
	bare_wound_bonus = -100

/obj/projectile/beam/water_jet/on_hit(atom/target, blocked = FALSE)
	if(isliving(target) && isliving(firer))
		var/mob/living/T = target
		var/mob/living/F = firer
		if(faction_check(F.faction, T.faction, FALSE))
			return
	damage = 5 // Using nodamage var does not work for this purpose
	. = ..()
	qdel(src)

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

/obj/projectile/red_hollowpoint
	name = "hollowpoint shell"
	desc = "A bullet fired from a red-cloaked mercenary's ruthless weapon."
	icon_state = "loyalty"
	range = 15
	speed = 0.6
	spread = 10
	pixel_y = 30

/obj/item/ammo_casing/caseless/nihil_abnormality
	name = "dark energy casing"
	desc = "A casing."
	projectile_type = /obj/projectile/ego_bullet/abno_nihil
	pellets = 4
	variance = 16

/obj/projectile/ego_bullet/abno_nihil
	name = "dark energy"
	icon_state = "nihil"
	desc = "Just looking at it seems to suck the life out of you..."
	damage = 7 //Fires 4
	damage_type = WHITE_DAMAGE //deals both white and red
	projectile_piercing = PASSMOB
	hitsound = 'sound/abnormalities/nihil/filter.ogg'

/obj/projectile/ego_bullet/abno_nihil/on_hit(atom/target, blocked = FALSE, pierce_hit)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	L.apply_void(1)

/obj/projectile/lifestew_spit
	name = "soup projectile"
	desc = "Hot soup."
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	hitsound = 'sound/abnormalities/ichthys/jump.ogg'
	damage_type = BLACK_DAMAGE
	damage = 2
	spread = 60
	slur = 3
	eyeblur = 3
	speed = 1.5 //VERY SLOW, to make it easier to dodge
	var/random_sprite_list = list(
	"fishbone",
	"bone"
	)

/obj/projectile/lifestew_spit/Initialize()
	. = ..()
	speed += pick(0, 0.1, 0.2, 0.3) // Randomized speed
	animate(src, transform = src.transform*pick(1.8, 2.4, 2.8, 3.2), time = rand(1,4))
	var/chansu = rand(1,100)
	switch(chansu)
		if(1)
			icon = 'icons/obj/projectiles.dmi'
			icon_state = "wishing_rock"
			hitsound = 'sound/weapons/smash.ogg'
		if(2 to 20)
			icon = 'icons/obj/food/soupsalad.dmi'
			icon_state = "lifetime_stew_chunk"
			hitsound = 'sound/effects/meatslap.ogg'
		if(21 to 30)
			icon = 'icons/obj/janitor.dmi'
			icon_state = pick(random_sprite_list)
			hitsound = 'sound/weapons/smash.ogg'
		else
			color = "#622F22"
			return

/obj/projectile/lifestew_spit/Range()
	for(var/mob/living/L in range(1, get_turf(src)))
		if(L.stat != DEAD && L != firer && !L.faction_check_mob(firer, FALSE))
			return Bump(L)
	..()

//Last shot projectiles
/obj/projectile/bonebullet
	name = "bone round"
	icon_state = "bonebullet"
	damage_type = RED_DAMAGE
	damage = 5 //rapid fire/shotgun fire
	spread = 30
	projectile_piercing = PASSMOB
	nodamage = TRUE	//Damage is calculated later
	var/list/safe_mobs = list(
	/mob/living/simple_animal/hostile/abnormality/last_shot,
	/mob/living/simple_animal/hostile/meatblob,
	/mob/living/simple_animal/hostile/meatblob/gunner,
	/mob/living/simple_animal/hostile/meatblob/gunner/shotgun,
	/mob/living/simple_animal/hostile/meatblob/gunner/sniper,
	)

/obj/projectile/bonebullet/on_hit(atom/target, blocked = FALSE)
	if(!is_type_in_list(target, safe_mobs))
		nodamage = FALSE
	else
		return
	. = ..()
	if(nodamage)
		return
	qdel(src)

/obj/projectile/bonebullet/bonebullet_piercing
	name = "bone sniper round"
	icon_state = "bonebullet_long"
	damage = 40
	speed = 0.4

/obj/projectile/frost_splinter
	name = "frost splinter"
	desc = "A large shard of ice."
	icon_state = "ice_2"
	damage_type = RED_DAMAGE
	damage = 15
	speed = 3
	alpha = 0
	spread = 20

/obj/projectile/frost_splinter/Initialize()
	. = ..()
	hitsound = "sound/weapons/ego/rapier[pick(1,2)].ogg"
	animate(src, alpha = 255, time = 3)

/obj/projectile/nosferatu_bat
	name = "bat"
	icon_state = "bat"
	damage = 5
	hitsound = 'sound/abnormalities/nosferatu/bat_attack.ogg'
	var/mob/living/simple_animal/hostile/abnormality/nosferatu/owner = null

/obj/projectile/nosferatu_bat/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/guaranteed_spawn = FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.stat == DEAD)
			return
		var/obj/effect/decal/cleanable/blood/B = new(get_turf(src))
		B.bloodiness = 200 // 200 Blood for nosferatu or its minions to collect
		guaranteed_spawn = TRUE
	if(owner)
		if(!guaranteed_spawn && prob(75))
			return
		owner.BatSpawn(target)

/obj/projectile/water_ball
	name = "water"
	desc = "A glob of salty water."
	icon_state = "water"
	damage_type = BLACK_DAMAGE
	damage = 5
	alpha = 120
	spread = 5

/obj/projectile/moth_fire
	name = "fireball"
	desc = "A ball of fire"
	icon_state = "fireball"
	damage = 5
	damage_type = FIRE

/obj/projectile/moth_fire/on_hit(target)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	L.apply_lc_burn(5)

/obj/projectile/skin_fire
	name = "ember"
	desc = "HOT!"
	icon_state = "red_1"
	damage_type = RED_DAMAGE
	damage = 3
	spread = 5
	projectile_piercing = PASSMOB
	hitsound = 'sound/abnormalities/skinprophet/Skin_Projectile_Impact.ogg'
