/obj/item/ego_weapon/city/smiling_pipe
	name = "Long pipe"
	desc = "A really long smoking pipe."
	special = "Hitting someome will inflict smoke on them"
	icon_state = "smiling_pipe"
	force = "40"
	attack_speed = 1.5
	damtype = BLACK_DAMAGE
	inhand_icon_state = "smiling_pipe"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	attack_verb_simple = list("Bashes", "Crushes")
	attack_verb_continuous = list("Bashes", "Crushes")
	var/hit_count = 0

//Ok so basically if you hit someome with this they'll get covered in smoke
/obj/item/ego_weapon/city/smiling_pipe/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	. = ..()
	if(isliving(target))
		++hit_count
		if(hit_count = 1)
			var/mob/living/simple_animal/M = target
			if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/smoke))
				to_chat(user, "Smoke engulfs [target].")
				new /obj/effect/temp_visual/smoke(get_turf(M))
				M.apply_status_effect(/datum/status_effect/smoke)
				hit_count = 0

/obj/item/ego_weapon/city/smiling_sword
	name = "Smiling sword"
	desc = "A pointy nail-like sword"
	special = "Hitting someome with smoke on them will 2x the damage dealt."
	icon_state = "smiling_face"
	force = "20"
	attack_speed = 1
	damtype = BLACK_DAMAGE
	inhand_icon_state = "smiling_face"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("Bashes", "Crushes")
	attack_verb_continuous = list("Bashes", "Crushes")

//If you hit someome with this, it will do double damage if they have smoke on
/obj/item/ego_weapon/city/smiling_sword/attack(mob/living/target, mob/living/user)
	if(has_status_effect(smoke))
		force = 40