/obj/projectile/ego_bullet/ego_star
	name = "star"
	icon_state = "star"
	damage = 28 // Multiplied by 1.5x when at high SP
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/melting_blob
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	damage = 40	//Fires 3
	speed = 0.8
	damage_type = BLACK_DAMAGE
	hitsound = "sound/effects/footstep/slime1.ogg"

/obj/projectile/ego_bullet/melting_blob/dot
	color = "#111111"
	speed = 1.3

/obj/projectile/ego_bullet/melting_blob/dot/on_hit(target)
	. = ..()
	var/mob/living/H = target
	if(!isbot(H) && isliving(H))
		H.visible_message("<span class='warning'>[target] is hit by [src], they seem to wither away!</span>")
		for(var/i = 1 to 14)
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living, apply_damage), rand(4,8), BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE)), 2 SECONDS * i)

/obj/projectile/ego_bullet/melting_blob/aoe
	color = "#6666BB"

/obj/projectile/ego_bullet/melting_blob/aoe/on_hit(target)
	. = ..()
	for(var/mob/living/L in view(2, target))
		new /obj/effect/temp_visual/revenant/cracks(get_turf(L))
		L.apply_damage(50, BLACK_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT

/obj/projectile/ego_bullet/nihil
	name = "dark energy"
	icon_state = "nihil"
	desc = "Just looking at it seems to suck the life out of you..."
	damage = 35	//Fires 4 +10 damage per upgrade, up to 75
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
	..()

/obj/projectile/ego_bullet/nihil/fire(angle, atom/direct_target)
	..()
	if(powers[1] == "hearts")
		icon_list += "heart"
		damage += 10
	if(powers[2] == "spades")
		icon_list += "spade"
		damage_list += PALE_DAMAGE
		damage += 10
	if(powers[3] == "diamonds")
		icon_list += "diamond"
		damage_list += RED_DAMAGE
		damage += 10
	if(powers[4] == "clubs")
		icon_list += "club"
		damage_list += BLACK_DAMAGE
		damage += 10

	if(length(icon_list) > 0)
		icon_state = "nihil_[pick(icon_list)]"
		color = pick("#818589", "#C0C0C0")
	else
		color = pick("#36454F", "#818589")
	damage_type = pick(damage_list)

/obj/projectile/ego_bullet/pink
	name = "heart-piercing bullet"
	damage = 130
	damage_type = WHITE_DAMAGE

	hitscan = TRUE
	damage_falloff_tile = 5//the damage ramps up; 5 extra damage per tile. Maximum range is about 32 tiles, dealing 290 damage

/obj/projectile/ego_bullet/pink/on_hit(atom/target, blocked = FALSE, pierce_hit)
	..()
	new /obj/effect/temp_visual/friend_hearts(get_turf(target))//looks better than impact_effect_type and works
