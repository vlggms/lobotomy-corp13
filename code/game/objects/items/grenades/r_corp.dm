/obj/item/grenade/r_corp
	name = "r-corp red grenade"
	desc = "An anti-abnormality grenade, this weapon excels at damaging abnormality using the tech from L-Corp. It deals 90% less damage to humans."
	icon_state = "r_corp"
	var/explosion_damage_type = RED_DAMAGE
	var/explosion_damage = 200
	var/explosion_range = 2
	var/carbon_damagemod = 0.1

/obj/item/grenade/r_corp/attack_self(mob/user)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("You wouldn't stoop so low as to use the weapons of those below you.")) //You are a arbiter not a demoman
			return FALSE
	..()

/obj/item/grenade/r_corp/detonate(mob/living/lanced_by)
	var/aThrower = thrower
	. = ..()
	update_mob()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_boom.ogg', 75, TRUE)
	for(var/mob/living/simple_animal/H in view(explosion_range, src))
		H.apply_damage(explosion_damage, explosion_damage_type, null, H.run_armor_check(null, explosion_damage_type))
	for(var/mob/living/carbon/C in view(explosion_range, src))
		C.apply_damage(C == aThrower ? explosion_damage * 0.5 : explosion_damage * carbon_damagemod, explosion_damage_type, null, C.run_armor_check(null, RED_DAMAGE))
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

/obj/item/grenade/r_corp/thumb
	name = "frag grenade"
	desc = "An anti-personnel fragmentation grenade, this weapon is used by the Thumb."
	icon_state = "frag"
	explosion_damage = 200	//Dude if you get hit by this you dumb as fuck
	carbon_damagemod = 1
	det_time = 20


/obj/effect/spawner/lootdrop/grenade
	name = "rcorp grenade spawner"
	lootdoubles = FALSE

	loot = list(
			/obj/item/grenade/r_corp = 3,
			/obj/item/grenade/r_corp/white = 3,
			/obj/item/grenade/r_corp/black = 3,
			/obj/item/grenade/r_corp/pale = 1,
		)
