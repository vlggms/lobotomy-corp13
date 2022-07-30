/obj/item/ego_weapon/rabbit_blade
	name = "high-frequency combat blade"
	desc = "A sharp high-frequency combat blade manufactured for use against abnormalities and other threats within L corp facilities."
	icon_state = "rabbitblade"
	inhand_icon_state = "rabbit_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 35
	throwforce = 24
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stabs", "slices")
	attack_verb_simple = list("stab", "slice")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 55,
							PRUDENCE_ATTRIBUTE = 55,
							TEMPERANCE_ATTRIBUTE = 55,
							JUSTICE_ATTRIBUTE = 55
							)

/obj/item/ego_weapon/rabbit_blade/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
		if(WHITE_DAMAGE)
			damtype = BLACK_DAMAGE
			force = 30
		if(BLACK_DAMAGE)
			damtype = PALE_DAMAGE
			force = 25
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
			force = 35
	armortype = damtype // TODO: In future, armortype should be gone entirely
	to_chat(user, "<span class='notice'>\The [src] will now deal [damtype] damage.</span>")
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)
