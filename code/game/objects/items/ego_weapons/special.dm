/obj/item/ego_weapon/rabbit_blade
	name = "high-frequency combat blade"
	desc = "A high-frequency combat blade made for use against abnormalities and other threats in Lobotomy Corporation and the outskirts."
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

/obj/item/ego_weapon/zwei_blade
	name = "zwei claymore"
	desc = "The weapon of a professional fixer, protecting the city one neighborhood at a time."
	icon_state = "claymore"
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 50,
							PRUDENCE_ATTRIBUTE = 50,
							TEMPERANCE_ATTRIBUTE = 50,
							JUSTICE_ATTRIBUTE = 50
							)
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 40
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	block_chance = 50
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF

/obj/item/ego_weapon/zwei_blade/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 40, 105)

/obj/item/ego_weapon/zwei_blade/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is falling on [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return(BRUTELOSS)

/obj/item/ego_weapon/tutorial
	name = "rookie dagger"
	desc = "E.G.O intended for Agent Education"
	icon_state = "rookie"
	force = 7
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "stabs", "slashes")
	attack_verb_simple = list("cuts", "stabs", "slashes")

/obj/item/ego_weapon/tutorial/white
	name = "fledgling dagger"
	icon_state = "fledgling"
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE

/obj/item/ego_weapon/tutorial/black
	name = "apprentice dagger"
	icon_state = "apprentice"
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE

/obj/item/ego_weapon/tutorial/pale
	name = "freshman dagger"
	icon_state = "freshman"
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
