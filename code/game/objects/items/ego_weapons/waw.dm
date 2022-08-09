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

/obj/item/ego_weapon/totalitarianism
	name = "totalitarianism"
	desc = "When one is oppressed, sometimes they try to break free."
	special = "This weapon attacks extremely slowly"
	icon_state = "totalitarianism"
	force = 120
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/totalitarianism/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 3) // Slow


/obj/item/ego_weapon/oppression
	name = "oppression"
	desc = "Even light forms of contraint can be considered totalitarianism"
	special = "Use this weapon enter a stance to deflect bullets."
	icon_state = "oppression"
	force = 32
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/mode = 0

/obj/item/ego_weapon/oppression/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.25) // FASTER

/obj/item/ego_weapon/oppression/attack_hand(mob/living/user)
	if (mode==0)
		mode = 1
		to_chat(user,"<span class='warning'>You take a defensive stance to block bullets. You find your attacks less effective</span>")
		force = 20
	if (mode==1)
		mode = 0
		to_chat(user,"<span class='warning'>You reset your stance, prepared to fight</span>")
		force = 32

/obj/item/ego_weapon/oppression/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK && mode == 1)
		final_block_chance = 100 //Anime Katana time
	return ..()

/obj/item/ego_weapon/remorse
	name = "remorse"
	desc = "A hammer and nail, unwieldy and impractical against most. \
	Any crack, no matter how small, will be pried open by this E.G.O."
	icon_state = "remorse"
	force = 80 // Extremely powerful, but extremely slow
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("Smashes", "Pierces", "Cracks")
	attack_verb_simple = list("Smash", "Pierce", "Crack")
	hitsound = 'sound/weapons/ego/remorse.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/remorse/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 2) // Extremely slow
	hitsound = "sound/weapons/ego/remorse.ogg"
