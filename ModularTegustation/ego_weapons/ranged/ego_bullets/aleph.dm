/obj/projectile/ego_bullet/star
	name = "star"
	icon_state = "star"
	damage = 27
	damage_type = WHITE_DAMAGE
	speed = 0.15
	ff_multiplier = 0
	projectile_piercing = PASSMOB
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/adoration
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	damage = 27	//Fires 3
	speed = 0.8
	spread = 5
	hit_nondense_targets = TRUE
	damage_type = BLACK_DAMAGE
	hitsound = "sound/effects/footstep/slime1.ogg"

/obj/projectile/ego_bullet/adoration/super
	damage = 120
	speed = 1.3
	var/aoe = 60
	spread = 0

/obj/projectile/ego_bullet/adoration/super/on_hit(target)
	. = ..()
	var/mob/living/user = firer
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(/datum/status_effect/gooped)
		L.visible_message(span_warning("[target] is hit by [src], they seem to wither away!"))
	for(var/turf/T in view(2, target))
		var/obj/effect/temp_visual/small_smoke/halfsecond/S = new(T)
		S.color = "#FF0081"
	for(var/mob/living/L in view(2, target))
		if(user.faction_check_mob(L) || L == target)//player faction
			continue
		L.apply_damage(aoe * damage_multiplier, BLACK_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		L.apply_status_effect(/datum/status_effect/gooped)
		L.visible_message(span_warning("[target] is hit by [src], they seem to wither away"))

/datum/status_effect/gooped
	id = "gooped"
	status_type = STATUS_EFFECT_REFRESH
	duration = 5 SECONDS
	tick_interval = 10 //One tick every second
	on_remove_on_mob_delete = TRUE
	alert_type = null
	var/damage_amount = 5

/datum/status_effect/gooped/on_apply()
	owner.apply_damage(damage_amount, BLACK_DAMAGE, null, owner.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	playsound(owner, 'sound/effects/wounds/sizzle2.ogg', 25, TRUE)
	return ..()

/datum/status_effect/gooped/tick()
	if(QDELETED(owner) || owner.stat == DEAD)
		qdel(src)
		return

	owner.apply_damage(damage_amount, BLACK_DAMAGE, null, owner.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	playsound(owner, 'sound/effects/wounds/sizzle2.ogg', 25, TRUE)



/obj/projectile/ego_bullet/nihil
	name = "dark energy"
	icon_state = "nihil"
	desc = "Just looking at it seems to suck the life out of you..."
	damage = 18 //Fires 4 +10 damage per upgrade, up to 75
	speed = 0.7
	damage_type = WHITE_DAMAGE

	hitsound = 'sound/abnormalities/nihil/filter.ogg'
	var/damage_list = list(WHITE_DAMAGE)
	var/icon_list = list()
	var/list/powers = list("hatred", "despair", "greed", "wrath")

/obj/projectile/ego_bullet/nihil/on_hit(atom/target, blocked = FALSE)
	if(powers[1] != "hearts")
		return ..()
	if(ishuman(target) && isliving(firer)) //this only happens with the queen of hatred upgrade
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(firer==target)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(H)) // Our faction
			if(H.is_working)
				H.visible_message("<span class='warning'>[src] vanishes on contact with [H]... but nothing happens!</span>")
				qdel(src)
				return BULLET_ACT_BLOCK
			switch(damage_type)
				if(WHITE_DAMAGE)
					H.adjustSanityLoss(-damage*0.2)
				if(BLACK_DAMAGE)
					H.adjustBruteLoss(-damage*0.1)
					H.adjustSanityLoss(-damage*0.1)
				else // Red or pale
					H.adjustBruteLoss(-damage*0.2)
			H.visible_message("<span class='warning'>[src] vanishes on contact with [H]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	return ..()

/obj/projectile/ego_bullet/nihil/fire(angle, atom/direct_target)
	if(fired_from)
		if(istype(fired_from, /obj/item/ego_weapon/ranged/nihil))
			var/obj/item/ego_weapon/ranged/nihil/our_weapon = fired_from
			powers = our_weapon.powers
	. = ..()
	if(powers[1] == "hearts")
		icon_list += "heart"
		damage += 7
	if(powers[2] == "spades")
		icon_list += "spade"
		damage_list += PALE_DAMAGE
		damage += 5
	if(powers[3] == "diamonds")
		icon_list += "diamond"
		damage_list += RED_DAMAGE
		damage += 5
	if(powers[4] == "clubs")
		icon_list += "club"
		damage_list += BLACK_DAMAGE
		damage += 5

	if(length(icon_list) > 0)
		icon_state = "nihil_[pick(icon_list)]"
		color = pick("#818589", "#C0C0C0")
	else
		color = pick("#36454F", "#818589")
	damage_type = pick(damage_list)

/obj/projectile/ego_bullet/pink
	name = "heart-piercing bullet"
	damage = 72
	damage_type = WHITE_DAMAGE
	impact_effect_type = null
	hitscan = TRUE
	ff_multiplier = 0
	damage_falloff_tile = 4//the damage ramps up; 4 extra damage per tile. Maximum range is about 32 tiles, dealing 200 damage

/obj/projectile/ego_bullet/pink/on_hit(atom/target, blocked = FALSE, pierce_hit)
	new /obj/effect/temp_visual/friend_hearts(get_turf(target))//looks better than impact_effect_type and works
	return ..()

/obj/projectile/ego_bullet/arcadia
	name = "arcadia"
	damage = 70 // VERY high damage
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/judge
	name = "judge"
	damage = 45
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_hookah
	name = "havana"
	icon_state = "smoke"
	damage = 2
	damage_type = PALE_DAMAGE
	speed = 2
	range = 6
	projectile_piercing = PASSMOB
	hit_nondense_targets = TRUE
	ff_multiplier = 0 //It'll be too annoying to use with other people if I didn't do this
	var/damage_decay = 0.9
	var/iframes = 1

/obj/projectile/ego_bullet/ego_hookah/on_hit(atom/target, blocked = FALSE)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(HitListRemove), target), iframes)
	if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target
		if(LAZYLEN(A.projectile_blockers))
			damage *= damage_decay**2//Decay more to prevent it from melting shit
	damage *= damage_decay
	if(damage < 0.1)
		qdel(src)
		return

/obj/projectile/ego_bullet/ego_hookah/proc/HitListRemove(mob/living/target)
	if(!target || QDELETED(target))
		return
	impacted[target] = FALSE
	if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target
		if(LAZYLEN(A.projectile_blockers))
			for(var/mob/living/simple_animal/projectile_blocker_dummy/L in A.projectile_blockers)
				impacted[L] = FALSE

/obj/projectile/ego_bullet/ego_executive
	name = "executive"
	damage = 12
	spread = 0
	damage_type = PALE_DAMAGE	//hehe

/obj/projectile/ego_bullet/ego_executive/kill_shot
	damage = 60
	var/stat = null

/obj/projectile/ego_bullet/ego_executive/kill_shot/process()
	. = ..()
	for(var/i = 1 to 3)
		if(prob(50))
			var/obj/effect/temp_visual/sparkle/S = new(get_turf(loc))
			S.pixel_x = pixel_x + rand(-8,8)
			S.dir = pick(NORTH, SOUTH, EAST, WEST)
			S.pixel_y = pixel_y + rand(-8,8)

/obj/projectile/ego_bullet/ego_executive/kill_shot/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	if(isliving(target))
		var/mob/living/L = target
		stat = L.stat
	return ..()

/obj/projectile/ego_bullet/ego_executive/kill_shot/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/T = target
	if(!isliving(target))
		return
	if(!isliving(firer))
		return
	var/mob/living/user = firer
	if(T.stat == DEAD && stat != DEAD)
		var/obj/item/ego_weapon/ranged/pistol/executive/gun = fired_from
		gun.AutoReload(user)
	return
