/obj/item/ego_weapon/lamp
	name = "lamp"
	desc = "Big Bird's eyes gained another in number for every creature it saved. \
	On this weapon, the radiant pride is apparent."
	icon_state = "lamp"
	force = 50
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/lamp/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.25) // Slow

/obj/item/ego_weapon/despair
	name = "sword sharpened with tears"
	desc = "A sword suitable for swift thrusts. \
	Even someone unskilled in dueling can rapidly puncture an enemy using this E.G.O with remarkable agility."
	icon_state = "despair"
	force = 20
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	var/combo = 0
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/despair/melee_attack_chain(mob/user, atom/target, params)
	..()
	hitsound = "sound/weapons/ego/rapier[pick(1,2)].ogg"

	if(combo < 4)
		force = 20
		user.changeNext_move(CLICK_CD_MELEE * 0.5)
		to_chat(user,"<span class='warning'>You advance with a swing.</span>")
		combo+=1

	if(combo == 4)
		force = 40		//CRIT!!!
		playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
		to_chat(user,"<span class='warning'>You are offbalance, you take a moment to reset your stance.</span>")
		combo+=1

	if(combo == 5)
		force = 20
		user.changeNext_move(CLICK_CD_MELEE * 2.5)		//Reset at the end
		combo = 0
