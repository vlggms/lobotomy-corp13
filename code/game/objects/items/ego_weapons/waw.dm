/obj/item/ego_weapon/lamp
	name = "lamp"
	desc = "Big Bird's eyes gained another in number for every creature it saved. \
	On this weapon, the radiant pride is apparent."
	special = "This weapon has a slightly slower attack speed."
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
	special = "This weapon has a combo system.\
			This weapon has a fast attack speed"
	icon_state = "despair"
	force = 18
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/despair/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)

		if(4)
			combo = 0
			user.changeNext_move(CLICK_CD_MELEE * 3)
			force *= 2
			playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
			to_chat(user,"<span class='warning'>You are offbalance, you take a moment to reset your stance.</span>")
		else
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)
