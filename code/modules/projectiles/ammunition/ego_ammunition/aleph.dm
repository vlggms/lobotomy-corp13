/obj/item/ammo_casing/caseless/ego_star
	name = "star shard"
	desc = "A star shard."
	projectile_type = /obj/projectile/ego_bullet/ego_star

/obj/item/ammo_casing/caseless/ego_star/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	..()
	if(isgun(fired_from) && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/damage_mod = 1 + (H.sanityhealth / H.maxSanity * 0.5) // Maximum SP will add 50% to the damage
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

/obj/item/ammo_casing/caseless/ego_nihil
	name = "nihil slug"
	desc = "A nihil slug."
	projectile_type = /obj/projectile/ego_bullet/nihil
	pellets = 4
	variance = 20

/obj/item/ammo_casing/caseless/ego_nihil/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	..()
	if(isgun(fired_from) && istype(fired_from, /obj/item/gun/ego_gun/nihil) && istype(BB, /obj/projectile/ego_bullet/nihil))
		var/obj/item/gun/ego_gun/nihil/G = fired_from
		var/obj/projectile/ego_bullet/nihil/GG = BB
		GG.powers = G.powers

/obj/item/ammo_casing/caseless/pink
	name = "pink bullet"
	desc = "A pink bullet."
	projectile_type = /obj/projectile/ego_bullet/pink
	pellets = 1
	variance = 0
