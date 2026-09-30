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

/obj/projectile/ego_bullet/ego_lovejustice
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	damage = 75
	spread = 0

/obj/projectile/ego_bullet/ego_lovejustice/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	if(QDELETED(src) || !T || !target)
		return
	if(isliving(target))
		var/mob/living/L = target
		if(L.has_status_effect(/datum/status_effect/display/villan_mark))
			damage_multiplier *= 1.3
	return ..()

/obj/projectile/ego_bullet/ego_lovejustice/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(firer==target)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(H)) // Our faction
			H.visible_message("<span class='warning'>[src] vanishes on contact with [H]!</span>")
			Healing(target)
			qdel(src)
			return BULLET_ACT_BLOCK
	..()
	Healing(target)
	return BULLET_ACT_BLOCK

/obj/projectile/ego_bullet/ego_lovejustice/Initialize()
	. = ..()
	icon_state = "qoh[pick(1,2,3)]"
	damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/obj/projectile/ego_bullet/ego_lovejustice/proc/Healing(atom/target)
	if(!isliving(firer))
		return
	var/mob/living/user = firer
	for(var/mob/living/carbon/human/H in view(1, target))
		if(!user.faction_check_mob(H) || H == user || H.is_working)
			continue
		if((H.stat == DEAD) || H.status_flags & GODMODE)//if the target was already dead or godmode. We don't want someone to farm charge off of a dead body
			continue
		switch(damage_type)
			if(WHITE_DAMAGE)
				if(H.sanityhealth < H.maxSanity)
					handle_charge(user,target)
				H.adjustSanityLoss(-10)
			if(BLACK_DAMAGE)
				if(H.sanityhealth < H.maxSanity || H.health < H.maxHealth)
					handle_charge(user,target)
				H.adjustBruteLoss(-5)
				H.adjustSanityLoss(-5)
			else // Red or pale
				if(H.health < H.maxHealth)
					handle_charge(user,target)
				H.adjustBruteLoss(-10)

/obj/projectile/ego_bullet/ego_lovejustice/proc/handle_charge(mob/living/user, atom/target)
	if(!ishuman(user))
		return
	var/obj/item/ego_weapon/ranged/lovejustice/staff = fired_from
	if(staff && !QDELETED(staff))
		staff.HandleCharge(1)

	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/lovejustice/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		for(var/datum/action/spell_action/ability/item/ego_arcana_slave/AS in Z.actions)
			to_chat(world, "Works")
			AS.AdjustCooldown(-5 SECONDS)
