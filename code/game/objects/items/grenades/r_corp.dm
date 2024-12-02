/obj/item/grenade/r_corp
	name = "r-corp red grenade"
	desc = "An anti-abnormality grenade, this weapon excels at damaging abnormality using the tech from L-Corp. It deals 90% less damage to humans."
	icon_state = "r_corp"
	var/explosion_damage_type = RED_DAMAGE
	var/explosion_damage = 200
	var/explosion_range = 2

/obj/item/grenade/r_corp/detonate(mob/living/lanced_by)
	var/aThrower = thrower
	. = ..()
	update_mob()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_boom.ogg', 75, TRUE)
	for(var/mob/living/simple_animal/H in view(explosion_range, src))
		H.apply_damage(explosion_damage, explosion_damage_type, null, H.run_armor_check(null, RED_DAMAGE))
	for(var/mob/living/carbon/C in view(explosion_range, src))
		C.apply_damage(C == aThrower ? explosion_damage * 0.5 : explosion_damage * 0.1, explosion_damage_type, null, C.run_armor_check(null, RED_DAMAGE))
	qdel(src)

/obj/item/grenade/r_corp/white
	name = "r-corp white grenade"
	icon_state = "r_corp_white"
	explosion_damage_type = WHITE_DAMAGE

/obj/item/grenade/r_corp/black
	name = "r-corp black grenade"
	icon_state = "r_corp_black"
	explosion_damage_type = BLACK_DAMAGE

/obj/item/grenade/r_corp/pale
	name = "r-corp pale grenade"
	icon_state = "r_corp_pale"
	explosion_damage_type = PALE_DAMAGE
	explosion_damage = 150
