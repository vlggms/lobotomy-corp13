/obj/item/gun/ego_gun/correctional
	name = "correctional"
	desc = "In here, you're with us. Forever."
	icon_state = "correctional"
	inhand_icon_state = "correctional"
	special = "This weapon fires 6 pellets."
	ammo_type = /obj/item/ammo_casing/caseless/ego_correctional
	weapon_weight = WEAPON_HEAVY
	fire_delay = 8
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/gun/ego_gun/hornet
	name = "hornet"
	desc = "The kingdom needed to stay prosperous, and more bees were required for that task. \
	The projectiles relive the legacy of the kingdom as they travel toward the target."
	icon_state = "hornet"
	inhand_icon_state = "hornet"
	ammo_type = /obj/item/ammo_casing/caseless/ego_hornet
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	fire_delay = 3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)


/obj/item/gun/ego_gun/hatred
	name = "in the name of love and hate"
	desc = "A magic wand surging with the lovely energy of a magical girl. \
	The holy light can cleanse the body and mind of every villain, and they shall be born anew."
	icon_state = "hatred"
	inhand_icon_state = "hatred"
	special = "This weapon heals humans that it hits."
	ammo_type = /obj/item/ammo_casing/caseless/ego_hatred
	weapon_weight = WEAPON_HEAVY
	fire_delay = 8
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/gun/ego_gun/hatred/EgoAttackInfo(mob/user)
	if(chambered && chambered.BB)
		return "<span class='notice'>Its bullets deal [chambered.BB.damage] randomly chosen damage.</span>"
	return

/obj/item/gun/ego_gun/magicbullet
	name = "magic bullet"
	desc = "Though the original's power couldn't be fully extracted, the magic this holds is still potent. \
	The weapon's bullets travel across the corridor, along the horizon."
	icon_state = "magic_bullet"
	inhand_icon_state = "magic_bullet"
	special = "This weapon fires extremely slowly. \
		This weapon pierces all targets. \
		This weapon fires significantly faster wearing the matching armor"
	ammo_type = /obj/item/ammo_casing/caseless/ego_magicbullet
	weapon_weight = WEAPON_HEAVY
	fire_delay = 24	//Put on the armor, jackass.
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'

	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/gun/ego_gun/magicbullet/before_firing(atom/target, mob/user)
	fire_delay = initial(fire_delay)
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/magicbullet/Y = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		fire_delay = 13
	..()

//Funeral guns have two different names;
//Solemn Lament is the white gun, Solemn Vow is the black gun.
//Likewise, they emit butterflies of those respective colors.
/obj/item/gun/ego_gun/pistol/solemnlament
	name = "solemn lament"
	desc = "A pistol which carries with it a lamentation for those that live. \
	Can feathers gain their own wings?"
	icon_state = "solemnlament"
	inhand_icon_state = "solemnlament"
	special = "Firing both solemn lament and solemn vow at the same time will increase damage by 1.5x"
	ammo_type = /obj/item/ammo_casing/caseless/ego_solemnlament
	fire_delay = 3
	fire_sound = 'sound/abnormalities/funeral/spiritgunwhite.ogg'
	fire_sound_volume = 30
	attribute_requirements = list(PRUDENCE_ATTRIBUTE = 80)

/obj/item/gun/ego_gun/pistol/solemnlament/process_fire(atom/target, mob/living/user)
	for(var/obj/item/gun/ego_gun/pistol/solemnvow/Vow in user.held_items)
		projectile_damage_multiplier = 1.5
		break
	..()
	projectile_damage_multiplier = 1


/obj/item/gun/ego_gun/pistol/solemnvow
	name = "solemn vow"
	desc = "A pistol which carries with it grief for those who have perished. \
	Even with wings, no feather can leave this place."
	icon_state = "solemnvow"
	inhand_icon_state = "solemnvow"
	special = "Firing both solemn lament and solemn vow at the same time will increase damage by 1.5x"
	ammo_type = /obj/item/ammo_casing/caseless/ego_solemnvow
	fire_delay = 3
	fire_sound = 'sound/abnormalities/funeral/spiritgunblack.ogg'
	fire_sound_volume = 30

	attribute_requirements = list(JUSTICE_ATTRIBUTE = 80)

/obj/item/gun/ego_gun/pistol/solemnvow/process_fire(atom/target, mob/living/user)
	for(var/obj/item/gun/ego_gun/pistol/solemnlament/Lament in user.held_items)
		projectile_damage_multiplier = 1.5
		break
	..()
	projectile_damage_multiplier = 1


/obj/item/gun/ego_gun/loyalty
	name = "loyalty"
	desc = "Courtesy of the 16th Ego rifleman's brigade."
	icon_state = "loyalty"
	inhand_icon_state = "loyalty"
	ammo_type = /obj/item/ammo_casing/caseless/ego_loyalty
	weapon_weight = WEAPON_HEAVY
	spread = 20
	special = "This weapon has IFF capabilities. \
		Use in hand to turn off IFF."
	fire_sound = 'sound/weapons/gun/smg/vp70.ogg'
	autofire = 0.08 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
	)

/obj/item/gun/ego_gun/loyalty/attack_self(mob/user)
	..()
	if(ammo_type == /obj/item/ammo_casing/caseless/ego_loyaltynoiff)
		to_chat(user,"<span class='warning'>You hit the switch, enabling IFF and decreasing damage.</span>")
		ammo_type = /obj/item/ammo_casing/caseless/ego_loyalty
		return
	if(ammo_type == /obj/item/ammo_casing/caseless/ego_loyalty)
		to_chat(user,"<span class='warning'>You hit the fire selector, disabling IFF and increasing damage.</span>")
		ammo_type = /obj/item/ammo_casing/caseless/ego_loyaltynoiff
		return

//Just a funny gold soda pistol. It was originally meant to just be a golden meme weapon, now it is the only pale gun, lol
/obj/item/gun/ego_gun/pistol/soda/executive
	name = "executive"
	desc = "A pistol painted in black with a gold finish. Whenever this EGO is used, a faint scent of fillet mignon wafts through the air."
	icon_state = "executive"
	inhand_icon_state = "executive"
	special = "This gun scales with justice."
	fire_delay = 3
	ammo_type = /obj/item/ammo_casing/caseless/ego_executive
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
	)


/obj/item/gun/ego_gun/pistol/crimson
	name = "crimson scar"
	desc = "With steel in one hand and gunpowder in the other, there's nothing to fear in this place."
	icon_state = "crimsonscar"
	inhand_icon_state = "crimsonscar"
	ammo_type = /obj/item/ammo_casing/caseless/ego_crimson
	special = "This weapon fires 3 pellets."
	fire_delay = 12
	fire_sound = 'sound/abnormalities/redhood/fire.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/gun/ego_gun/ecstasy
	name = "ecstasy"
	desc = "Tell the kid today's treat is going to be grape-flavored candy. It's his favorite."
	icon_state = "ecstasy"
	inhand_icon_state = "ecstasy"
	special = "This weapon fires slow bullets with limited range."
	ammo_type = /obj/item/ammo_casing/caseless/ego_ecstasy
	weapon_weight = WEAPON_HEAVY
	spread = 40
	fire_sound = 'sound/weapons/ego/ecstasy.ogg'
	autofire = 0.08 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

/obj/item/gun/ego_gun/pistol/praetorian
	name = "praetorian"
	desc = "And with her guard, she conquered all."
	icon_state = "praetorian"
	inhand_icon_state = "executive"
	special = "This weapon fires IFF bullets."
	ammo_type = /obj/item/ammo_casing/caseless/ego_praetorian
	fire_sound = 'sound/weapons/gun/pistol/tp17.ogg'
	autofire = 0.12 SECONDS
	fire_sound_volume = 30
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/gun/ego_gun/pistol/magic_pistol
	name = "magic pistol"
	desc = "All the power of magic bullet, in a smaller package."
	icon_state = "magic_pistol"
	inhand_icon_state = "magic_pistol"
	special = "This weapon pierces all targets."
	ammo_type = /obj/item/ammo_casing/caseless/ego_magicpistol
	fire_delay = 9
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/gun/ego_gun/pistol/laststop
	name = "last stop"
	desc = "There are no clocks to alert the arrival times."
	icon_state = "laststop"
	inhand_icon_state = "laststop"
	ammo_type = /obj/item/ammo_casing/caseless/ego_laststop
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10 SECONDS 	// I mean it's a derringer
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/gun/ego_gun/intentions
	name = "good intentions"
	desc = "Go ahead and rattle 'em boys."
	icon_state = "intentions"
	inhand_icon_state = "intentions"
	ammo_type = /obj/item/ammo_casing/caseless/ego_intentions
	weapon_weight = WEAPON_HEAVY
	spread = 40
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.07 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/gun/ego_gun/aroma
	name = "faint aroma"
	desc = "Simply carrying it gives the illusion that you're standing in a forest in the middle of nowhere. \
			The arrowhead is dull and sprouts flowers of vivid color wherever it strikes."
	icon_state = "aroma"
	inhand_icon_state = "aroma"
	ammo_type = /obj/item/ammo_casing/caseless/ego_aroma
	weapon_weight = WEAPON_HEAVY
	fire_delay = 18
	fire_sound = 'sound/weapons/ego/crossbow.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/gun/ego_gun/assonance
	name = "assonance"
	desc = "However, the world is more than simply warmth and light. The sky exists, for so does the land; darkness exists, \
				for so does light; life exists for so does death; hope exists for so does despair."
	icon_state = "assonance"
	inhand_icon_state = "assonance"
	special = "This weapon fires a hitscan beam."
	ammo_type = /obj/item/ammo_casing/caseless/ego_assonance
	weapon_weight = WEAPON_HEAVY
	fire_delay = 3
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

//It's a magic sword. Cope Egor
/obj/item/gun/ego_gun/feather
	name = "feather of honor"
	desc = "A flaming, but very sharp, feather."
	icon_state = "featherofhonor"
	inhand_icon_state = "featherofhonor"
	ammo_type = /obj/item/ammo_casing/caseless/ego_feather
	weapon_weight = WEAPON_HEAVY
	special = "This weapon deals 35 white in melee."
	force = 35
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	fire_delay = 16
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
	)

/obj/item/gun/ego_gun/exuviae
	name = "exuviae"
	desc = "A chunk of the naked nest inigrated with a launching mechanism."
	icon_state = "exuviae"
	inhand_icon_state = "exuviae"
	ammo_type = /obj/item/ammo_casing/caseless/ego_exuviae
	weapon_weight = WEAPON_HEAVY
	special = "Upon hit the targets RED vulnerability is increased by 0.2."
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	fire_delay = 23 //5 less than the Rend Armor status effect
	fire_sound = 'sound/misc/moist_impact.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

//Full manual bow-type E.G.O, must be loaded before firing.
/obj/item/gun/ego_gun/warring
	name = "feather of valor"
	desc = "A shimmering bow adorned with carved wooden panels. It crackes with arcing electricity."
	icon_state = "warring"
	inhand_icon_state = "warring"
	special = "This weapon must be drawn before firing. \
		It has perfect accuracy."
	ammo_type = /obj/item/ammo_casing/caseless/ego_warring
	weapon_weight = WEAPON_HEAVY
	fire_delay = 9
	spread = 0
	//firing sound 1
	fire_sound = 'sound/weapons/bowfire.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)
	var/drawn = 0

/obj/item/gun/ego_gun/warring/can_shoot()
	if (drawn == 0)
		icon_state = "[initial(icon_state)]"
		ammo_type = /obj/item/ammo_casing/caseless/ego_warring
		return FALSE
	return TRUE

/obj/item/gun/ego_gun/warring/before_firing(atom/target, mob/user)
	..()
	if (drawn == 0)//gun should not fire here
		can_shoot()
		return

/obj/item/gun/ego_gun/warring/afterattack(atom/target, mob/user)
	..()
	drawn = 0
	icon_state = "[initial(icon_state)]"
	can_shoot()

/obj/item/gun/ego_gun/warring/attack_self(mob/user)
	switch(drawn)
		if (0)
			if(do_after(user, 10, src))
				drawn  = 1
				to_chat(user,"<span class='warning'>You draw the [src] with all your might.</span>")
				ammo_type = /obj/item/ammo_casing/caseless/ego_warring
				fire_sound = 'sound/weapons/bowfire.ogg'
				icon_state = "warring_drawn"
		if (1)
			if(do_after(user, 15, src))
				if(drawn != 1)
					return
				drawn = 2
				ammo_type = /obj/item/ammo_casing/caseless/ego_warring2//FIXME: the problem line, occasionally fails for no reason.
				playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
				to_chat(user,"<span class='warning'>An arrow of lightning appears.</span>")
				fire_sound = 'sound/abnormalities/thunderbird/tbird_beam.ogg'
				icon_state = "warring_firey"
		if (2)
			return
