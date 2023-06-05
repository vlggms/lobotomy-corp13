//Marks - These augment the hammers.
/obj/item/ego_weapon/city/ncorp_mark
	name = "n-corp red seal"
	desc = "A red seal used by Ncorp."
	special = "Use on an N corp hammer to change its damage. \
		This weapon is single use."
	icon_state = "mark"
	force = 40
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("marks")
	attack_verb_simple = list("mark")

/obj/item/ego_weapon/city/ncorp_mark/attack(mob/living/target, mob/living/user)
	..()
	qdel(src)

/obj/item/ego_weapon/city/ncorp_mark/white
	name = "n-corp white seal"
	icon_state = "wmark"
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE

/obj/item/ego_weapon/city/ncorp_mark/black
	name = "n-corp black seal"
	icon_state = "bmark"
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE

/obj/item/ego_weapon/city/ncorp_mark/pale
	name = "n-corp pale seal"
	icon_state = "pmark"
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE

//Nails - These mark enemies to enable the hammer
/obj/item/ego_weapon/city/ncorp_nail
	name = "KleinNagel"
	desc = "A small nail used by junior Ncorp inquisitors."
	special = "Hit an enemy with this weapon to mark it. \
		Hit this weapon with an N-Corp hammer to hurt all marked enemies."
	icon_state = "kleinnagel"
	force = 18
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("jabs", "stabs")
	attack_verb_simple = list("jab", "stab")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	var/list/marked = list()

/obj/item/ego_weapon/city/ncorp_nail/attack(mob/living/target, mob/living/user)
	..()
	if(!(target in marked))
		marked+=target

/obj/item/ego_weapon/city/ncorp_nail/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/ego_weapon/city/ncorp_hammer))
		return

	for(var/mob/living/M in marked)
		playsound(M, 'sound/weapons/fixer/generic/nail2.ogg', 100, FALSE, 4)
		M.apply_damage(I.force, I.damtype, null, M.run_armor_check(null, I.damtype), spread_damage = TRUE, white_healable = TRUE)
		new /obj/effect/temp_visual/remorse(get_turf(M))
		marked -= M

/obj/item/ego_weapon/city/ncorp_nail/big
	name = "MittleNagel"
	desc = "A large nail used by senior Ncorp inquisitors."
	icon_state = "mittlenagel"
	force = 37
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/city/ncorp_nail/huge
	name = "GrossNagel"
	desc = "A huge nail used by Ncorp captains."
	icon_state = "grossnagel"
	force = 50
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/city/ncorp_nail/grip
	name = "Nagel der Gerechten"
	desc = "A huge nail used by The One Who Grips."
	icon_state = "gripnagel"
	force = 50
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)


//Hammers - This is your bread and butter attacking weapon.
/obj/item/ego_weapon/city/ncorp_hammer
	name = "KleinHammer"
	desc = "A small hammer used by junior Ncorp inquisitors."
	special = "Use a mark on this weapon to change its damage type. \
		This weapon doubles as an N-Corp hammer"
	icon_state = "kleinhammer"
	force = 30
	attack_speed = 1.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("marks")
	attack_verb_simple = list("mark")
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'
	var/charges
	var/charged		//so you don't get the message every time

/obj/item/ego_weapon/city/ncorp_hammer/attack(mob/living/target, mob/living/user)
	..()
	if(charges > 0)
		charges-=1
	if(charges <= 0 && charged)
		damtype = initial(damtype)
		armortype = initial(damtype)
		to_chat(user, "<span class='notice'>Your hammer has run out of charges.</span>")
		charged = FALSE

/obj/item/ego_weapon/city/ncorp_hammer/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/ego_weapon/city/ncorp_mark))
		return
	to_chat(user, "<span class='notice'>You apply a mark to your hammer, changing its damage type.</span>")
	damtype = I.damtype
	armortype = I.damtype
	charges = 5
	charged = TRUE
	qdel(I)

//Big hammer
/obj/item/ego_weapon/city/ncorp_hammer/big
	name = "MittelHammer"
	desc = "A large hammer used by senior Ncorp inquisitors."
	icon_state = "mittlehammer"
	force = 60
	hitsound = 'sound/weapons/ego/shield1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

//SHE WHO GRIPS
/obj/item/ego_weapon/city/ncorp_hammer/grippy
	name = "Hand der Gerechten"
	desc = "A steel fist used by Ncorp captains, to bring the light of justice to heretics in need of it."
	icon_state = "grip"
	force = 60
	attack_speed = 1
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

