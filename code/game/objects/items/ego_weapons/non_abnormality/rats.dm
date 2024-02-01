//Rats weapons. This is all throwaway junk.
/obj/item/ego_weapon/city/rats
	name = "rat hammer"
	desc = "A hammer sometimes found in the hands of rats. This one belonged to a rat who lost nearly everything to sweepers."
	icon_state = "rathammer"
	force = 18
	damtype = RED_DAMAGE

	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/city/rats/knife
	name = "rat combat knife"
	desc = "A combat knife sometimes found in the hands of rats. This one belonged to a rat who once had a dream of something bigger."
	icon_state = "ratknife"
	force = 10
	attack_speed = 0.5
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/city/rats/scalpel
	name = "rat scalpel"
	desc = "A combat scalpel sometimes found in the hands of rats. This one belonged to a rat who gave up a dream of a better future."
	icon_state = "ratscalpel"
	force = 20
	attack_speed = 1.2
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/city/rats/brick
	name = "brick"
	desc = "It's a brick."
	special = "Fits into an EGO belt."
	icon_state = "ratbrick"
	force = 5
	throwforce = 50
	attack_speed = 0.8
	attack_verb_continuous = list("bricks", "smashes", "shatters")
	attack_verb_simple = list("brick", "smash", "shatter")
	hitsound = 'sound/weapons/ego/bricksmash.ogg'

/obj/item/ego_weapon/city/rats/brick/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		playsound(src, 'sound/weapons/ego/bricksmash.ogg', 50, TRUE)
		qdel(src)

/obj/item/ego_weapon/city/rats/pipe
	name = "pipe"
	desc = "It's a pipe. It would hurt if you hit someone over the head with it."
	icon_state = "ratpipe"
	force = 55
	attack_speed = 3
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pipes", "smashes", "shatters", "nails over the head")
	attack_verb_simple = list("pipe", "smash", "shatter", "nail in the head")
	hitsound = 'sound/weapons/ego/pipesuffering.ogg'

// From CRUELTY SQUAD. It's really, really bad
/obj/item/gun/ego_gun/pistol/rats
	name = "XX-Corp Zippy 3000"
	desc = "The ultimate weapon, in ejection failures and misfires. You'll be lucky to get two shots out of this thing without blowing off your fingers. \
		One of the weapons made by XX Corp. Due to the vast amount of ejections, failures, and being so unbearable for the lowest of the low fixers, \
		XX-Corp abandoned the project. It is rumored that they dumped the remaining thousands of products in an alleyway. \
		There's little other explanation to how this got into the hands of so many rats."
	icon_state = "zippy"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_type = /obj/item/ammo_casing/caseless/ego_kcorp
	fire_delay = 5
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	fire_sound_volume = 70

/obj/item/gun/ego_gun/pistol/rats/can_shoot()
	..()
	if(prob(33))
		playsound(src, 'sound/weapons/gun/general/dry_fire.ogg', 30, TRUE)
		visible_message(span_notice("The gun jams."))
		return FALSE
	else
		return TRUE

/obj/item/gun/ego_gun/pistol/rats/afterattack(atom/target, mob/living/user, flag, params)
	if(prob(50))
		to_chat(user,span_warning("You pinch your fingers in the weapon."))
		user.apply_damage(10, RED_DAMAGE, null, user.run_armor_check(null, BLACK_DAMAGE))
		return FALSE
	..()

