// Threats appropriate for a single grade 8-7 fixer, or multiple weaker fixers.
// These should be the very weakest things that might require multiple people to defeat.

/mob/living/simple_animal/hostile/distortion/another_day_work
	name = "Another Day at Work"
	desc = "A man covered in... ties?"
	icon = 'ModularTegustation/Teguicons/48x96.dmi'
	icon_state = "work"
	maxHealth = 900
	health = 900
	pixel_x = -16
	base_pixel_x = -16
	fear_level = TETH_LEVEL
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2)
	melee_damage_lower = 10
	melee_damage_upper = 14
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/censored/attack.ogg'
	attack_verb_continuous = "whips"
	attack_verb_simple = "whip"
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/tie
	projectilesound = 'sound/weapons/whip.ogg'

//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/ego_weapon/waging,
		/obj/item/clothing/suit/armor/ego_gear/teth/waging
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Paige Turner", "Larry Sal", "Nota Dollar", "Donnar Profit", "Collin Beck")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/documents/ncorporation)

	var/can_act = TRUE

//Proc that can be used for additional effects on unmanifest
/mob/living/simple_animal/hostile/distortion/another_day_work/PostUnmanifest()
	new /obj/item/clothing/neck/tie/horrible(get_turf(src))
	return

//Unmanifesting is not linked to any proc by default, if you want it to happen during gameplay, it must be called manually.
/mob/living/simple_animal/hostile/distortion/another_day_work/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	var/value
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		value = H.credits
	if(istype(I, /obj/item/stack/spacecash))
		var/obj/item/stack/spacecash/H = I
		value = H.value
	if(!value)
		return
	if(value <= 250)
		say("That's not enough! It is never enough!")
		user.visible_message(span_danger("[src] is not fazed by [user]'s offering!"), span_userdanger("Your peace offering is rejected by [src]!"))
	else
		qdel(I)
		say("You really mean it? A paid vacation?")
		can_act = FALSE
		addtimer(CALLBACK(src, PROC_REF(Unmanifest)),3 SECONDS)

/mob/living/simple_animal/hostile/distortion/another_day_work/OpenFire(atom/A)
	if(!can_act)
		return FALSE
	if(get_dist(src, A) <= 2) //no shooty in mele
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/another_day_work/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/distortion/another_day_work/AttackingTarget()
	if(!can_act)
		return FALSE
	..()

//Projectile
/obj/projectile/tie
	name = "stretchy tie"
	damage = 15
	damage_type = BLACK_DAMAGE

	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/tracer/laser/tie
	tracer_type = /obj/effect/projectile/tracer/laser/tie
	impact_type = /obj/effect/projectile/impact/laser/tie

/obj/effect/projectile/tracer/laser/tie
	name = "tie tracer"
	icon_state = "tie"

/obj/effect/projectile/impact/laser/tie
	name = "tie impact"
	icon_state = "tie"

/obj/projectile/tie/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.Knockdown(50)//trip the target
	qdel(src)

//Ego
//Another Day at Work - Waging
/datum/ego_datum/armor/waging
	item_path = /obj/item/clothing/suit/armor/ego_gear/teth/waging
	cost = 20

/datum/ego_datum/weapon/waging
	item_path = /obj/item/ego_weapon/waging
	cost = 20

/obj/item/clothing/suit/armor/ego_gear/teth/waging
	name = "waging"
	desc = "It appears to be a suit and tie at first glance; closer inspection reveals that it is actually a tie and suit."
	icon_state = "waging"
	armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = -20, BLACK_DAMAGE = 40, PALE_DAMAGE = 0) // 20

/obj/item/ego_weapon/waging
	name = "waging"
	desc = "A whip made of ties, strikes are imbued with the pain and exhaustion of a 9-5."
	special = "This E.G.O. functions as both a gun and a melee weapon."
	icon_state = "waging"
	force = 32
	reach = 2		//Has 2 Square Reach.
	damtype = BLACK_DAMAGE

	attack_speed = 1.6
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/whip.ogg'

	var/gun_cooldown
	var/gun_cooldown_time = 5 SECONDS //this is amazing for pvp, so long cooldown

/obj/item/ego_weapon/waging/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	..()

/obj/item/ego_weapon/waging/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if((get_dist(user,target) >= 3) && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/tie/G = new /obj/projectile/tie(proj_turf)
		G.fired_from = src //for signal check
		playsound(user, 'sound/weapons/whip.ogg', 100, TRUE)
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/waging/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE
