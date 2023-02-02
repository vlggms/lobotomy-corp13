/obj/item/ammo_casing/caseless/ego_star
	name = "star shard"
	desc = "A star shard."
	projectile_type = /obj/projectile/ego_bullet/ego_star

/obj/item/ammo_casing/caseless/ego_star/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	..()
	if(isgun(fired_from) && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/damage_mod = clamp((H.sanityhealth / 100), 1, 1.5) // Maximum SP will add 50% to the damage
		BB.damage *= damage_mod

/obj/item/ammo_casing/caseless/ego_adoration
	name = "adoration slug"
	desc = "A adoration slug."
	projectile_type = /obj/projectile/ego_bullet/melting_blob
	pellets = 3
	variance = 20

/obj/item/ammo_casing/caseless/ego_adoration/dot
	name = "adoration slug"
	desc = "A adoration slug."
	projectile_type = /obj/projectile/ego_bullet/melting_blob/dot
	pellets = 1
	variance = 0

/obj/item/ammo_casing/caseless/ego_adoration/aoe
	name = "adoration slug"
	desc = "A adoration slug."
	projectile_type = /obj/projectile/ego_bullet/melting_blob/aoe
	pellets = 1
	variance = 0
