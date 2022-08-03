/obj/item/ammo_casing/caseless/ego_star
	name = "star shard"
	desc = "A star shard."
	projectile_type = /obj/projectile/ego_bullet/ego_star

/obj/item/ammo_casing/caseless/ego_star/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	..()
	if(isgun(fired_from) && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/damage_mod = max(0.8, (H.sanityhealth / 100)) // Maximum SP will double the damage
		BB.damage *= damage_mod

/obj/item/ammo_casing/caseless/ego_adoration
	name = "adoration slug"
	desc = "A adoration slug."
	projectile_type = /obj/projectile/melting_blob
