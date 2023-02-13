/obj/item/ammo_casing/caseless/ego_correctional
	name = "correctional casing"
	desc = "A correctional casing."
	projectile_type = /obj/projectile/ego_bullet/ego_correctional
	pellets = 6
	variance = 20

/obj/item/ammo_casing/caseless/ego_hornet
	name = "hornet casing"
	desc = "A hornet casing."
	projectile_type = /obj/projectile/ego_bullet/ego_hornet

/obj/item/ammo_casing/caseless/ego_hatred
	projectile_type = /obj/projectile/ego_bullet/ego_hatred

/obj/item/ammo_casing/caseless/ego_magicbullet
	name = "magic bullet casing"
	desc = "A magic casing."
	projectile_type = /obj/projectile/ego_bullet/ego_magicbullet

/obj/item/ammo_casing/caseless/ego_solemnlament
	name = "solemn casing"
	desc = "a solemn casing."
	projectile_type = /obj/projectile/ego_bullet/ego_solemnlament

/obj/item/ammo_casing/caseless/ego_solemnvow
	name = "solemn casing"
	desc = "a solemn casing"
	projectile_type = /obj/projectile/ego_bullet/ego_solemnvow

/obj/item/ammo_casing/caseless/ego_loyalty
	name = "loyalty IFF casing"
	desc = "A loyalty IFF casing."
	projectile_type = /obj/projectile/ego_bullet/ego_loyalty/iff

/obj/item/ammo_casing/caseless/ego_loyaltynoiff
	name = "loyalty casing"
	desc = "A loyalty casing."
	projectile_type = /obj/projectile/ego_bullet/ego_loyalty

/obj/item/ammo_casing/caseless/ego_executive
	name = "executive casing"
	desc = "An executive casing."
	projectile_type = /obj/projectile/ego_bullet/ego_executive

//The only justice scaling gun is a shitty 10 pale pistol
/obj/item/ammo_casing/caseless/ego_executive/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	..()
	if(isgun(fired_from) && ishuman(user))
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		BB.damage *= justicemod

/obj/item/ammo_casing/caseless/ego_crimson
	name = "crimson casing"
	desc = "A crimson casing."
	projectile_type = /obj/projectile/ego_bullet/ego_crimson
	pellets = 3
	variance = 14

/obj/item/ammo_casing/caseless/ego_ecstasy
	name = "executive casing"
	desc = "An executive casing."
	projectile_type = /obj/projectile/ego_bullet/ego_ecstasy

/obj/item/ammo_casing/caseless/ego_praetorian
	name = "praetorian casing"
	desc = "A praetorian casing."
	projectile_type = /obj/projectile/ego_bullet/ego_praetorian

/obj/item/ammo_casing/caseless/ego_magicpistol
	name = "magic pistol casing"
	desc = "A magic casing."
	projectile_type = /obj/projectile/ego_bullet/ego_magicpistol

/obj/item/ammo_casing/caseless/ego_laststop
	name = "last stop casing"
	desc = "A last stop casing."
	projectile_type = /obj/projectile/ego_bullet/ego_laststop

/obj/item/ammo_casing/caseless/ego_intentions
	name = "intentions casing"
	desc = "intentions casing."
	projectile_type = /obj/projectile/ego_bullet/ego_intention

/obj/item/ammo_casing/caseless/ego_aroma
	name = "aroma casing"
	desc = "aroma casing"
	projectile_type = /obj/projectile/ego_bullet/ego_aroma

/obj/item/ammo_casing/caseless/ego_assonance
	name = "assonance casing"
	desc = "assonance casing."
	projectile_type = /obj/projectile/beam/assonance

/obj/item/ammo_casing/caseless/ego_feather
	name = "feather casing"
	desc = "A feather casing."
	projectile_type = /obj/projectile/ego_bullet/ego_feather

/obj/item/ammo_casing/caseless/ego_exuviae
	name = "exuviae casing"
	desc = "A casing from a exuviae cannon."
	projectile_type = /obj/projectile/ego_bullet/ego_exuviae

/obj/item/ammo_casing/caseless/ego_warring
	name = "warring casing"
	desc = "A warring casing."
	projectile_type = /obj/projectile/ego_bullet/ego_warring

/obj/item/ammo_casing/caseless/ego_warring2
	name = "warring casing"
	desc = "A warring casing."
	projectile_type = /obj/projectile/ego_bullet/ego_warring2
