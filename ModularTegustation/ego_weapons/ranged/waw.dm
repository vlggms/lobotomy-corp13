/obj/item/ego_weapon/ranged/correctional
	name = "correctional"
	desc = "In here, you're with us. Forever."
	icon_state = "correctional"
	inhand_icon_state = "correctional"
	special = "This weapon fires 6 pellets."
	force = 33
	damtype = BLACK_DAMAGE
	attack_speed = 1.3
	projectile_path = /obj/projectile/ego_bullet/ego_correctional
	weapon_weight = WEAPON_HEAVY
	pellets = 8
	variance = 20
	fire_delay = 7
	shotsleft = 12
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/hornet
	name = "hornet"
	desc = "The kingdom needed to stay prosperous, and more bees were required for that task. \
	The projectiles relive the legacy of the kingdom as they travel toward the target."
	icon_state = "hornet"
	inhand_icon_state = "hornet"
	force = 28
	projectile_path = /obj/projectile/ego_bullet/ego_hornet
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	fire_delay = 2
	shotsleft = 10
	reloadtime = 1.4 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)


/obj/item/ego_weapon/ranged/hatred
	name = "in the name of love and hate"
	desc = "A magic wand surging with the lovely energy of a magical girl. \
	The holy light can cleanse the body and mind of every villain, and they shall be born anew."
	icon_state = "hatred"
	inhand_icon_state = "hatred"
	special = "This weapon heals humans that it hits."
	force = 28
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hatred
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/hatred/GunAttackInfo(mob/user)
	return span_notice("Its bullets deal [last_projectile_damage] randomly chosen damage.")

/obj/item/ego_weapon/ranged/hatred/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/heart))
		return
	new /obj/item/ego_weapon/ranged/hatred_nihil(get_turf(src))
	to_chat(user,span_warning("The [I] seems to drain all of the light away as it is absorbed into [src]!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

// Magic Bullet armour increases attack speed from 30 to 15
// Big Iron armour on the other hand increases damage by a factor of 2.5x80, which will give it 40 more damage than the magic bullet armour
/obj/item/ego_weapon/ranged/magicbullet
	name = "magic bullet"
	desc = "Though the original's power couldn't be fully extracted, the magic this holds is still potent. \
	The weapon's bullets travel across the corridor, along the horizon."
	icon_state = "magic_bullet"
	inhand_icon_state = "magic_bullet"
	special = "This weapon fires extremely slowly. \
		This weapon pierces all targets. \
		This weapon gets a firespeed bonus when wearing the matching armor."
	force = 28
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_magicbullet
	weapon_weight = WEAPON_HEAVY
	fire_delay = 30	//Put on the armor, jackass.
	shotsleft = 7
	reloadtime = 2.1 SECONDS
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'

	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/cached_multiplier

/obj/item/ego_weapon/ranged/magicbullet/before_firing(atom/target, mob/user)
	if(cached_multiplier)
		projectile_damage_multiplier = cached_multiplier
	fire_delay = initial(fire_delay)
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/he/magicbullet/Y = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		fire_delay = 8
	if(istype(Z))
		cached_multiplier = projectile_damage_multiplier
		projectile_damage_multiplier *= 2.5
		fire_delay = 15
	..()


//Funeral guns have two different names;
//Solemn Lament is the white gun, Solemn Vow is the black gun.
//Likewise, they emit butterflies of those respective colors.
/obj/item/ego_weapon/ranged/pistol/solemnlament
	name = "solemn lament"
	desc = "A pistol which carries with it a lamentation for those that live. \
	Can feathers gain their own wings?"
	icon_state = "solemnlament"
	inhand_icon_state = "solemnlament"
	special = "Firing both solemn lament and solemn vow at the same time will increase damage by 1.5x"
	force = 17
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solemnlament
	fire_delay = 5
	shotsleft = 18
	reloadtime = 0.7 SECONDS
	fire_sound = 'sound/abnormalities/funeral/spiritgunwhite.ogg'
	fire_sound_volume = 30
	attribute_requirements = list(PRUDENCE_ATTRIBUTE = 80)
	var/cached_multiplier

/obj/item/ego_weapon/ranged/pistol/solemnlament/before_firing(atom/target, mob/user)
	if(cached_multiplier)
		projectile_damage_multiplier = cached_multiplier
	fire_delay = initial(fire_delay)
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		cached_multiplier = projectile_damage_multiplier
		projectile_damage_multiplier *= 2.5
	return ..()

/obj/item/ego_weapon/ranged/pistol/solemnlament/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	for(var/obj/item/ego_weapon/ranged/pistol/solemnvow/Vow in user.held_items)
		projectile_damage_multiplier = 1.5
		break
	. = ..()
	projectile_damage_multiplier = 1


/obj/item/ego_weapon/ranged/pistol/solemnvow
	name = "solemn vow"
	desc = "A pistol which carries with it grief for those who have perished. \
	Even with wings, no feather can leave this place."
	icon_state = "solemnvow"
	inhand_icon_state = "solemnvow"
	special = "Firing both solemn lament and solemn vow at the same time will increase damage by 1.5x"
	force = 17
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solemnvow
	fire_delay = 5
	shotsleft = 18
	reloadtime = 0.7 SECONDS
	fire_sound = 'sound/abnormalities/funeral/spiritgunblack.ogg'
	fire_sound_volume = 30
	var/cached_multiplier
	attribute_requirements = list(JUSTICE_ATTRIBUTE = 80)

/obj/item/ego_weapon/ranged/pistol/solemnvow/before_firing(atom/target, mob/user)
	if(cached_multiplier)
		projectile_damage_multiplier = cached_multiplier
	fire_delay = initial(fire_delay)
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		cached_multiplier = projectile_damage_multiplier
		projectile_damage_multiplier *= 2.5
	return ..()

/obj/item/ego_weapon/ranged/pistol/solemnvow/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	for(var/obj/item/ego_weapon/ranged/pistol/solemnlament/Lament in user.held_items)
		projectile_damage_multiplier = 1.5
		break
	. = ..()
	projectile_damage_multiplier = 1


/obj/item/ego_weapon/ranged/loyalty
	name = "loyalty"
	desc = "Courtesy of the 16th Ego rifleman's brigade."
	icon_state = "loyalty"
	inhand_icon_state = "loyalty"
	force = 28
	projectile_path = /obj/projectile/ego_bullet/ego_loyalty/iff
	weapon_weight = WEAPON_HEAVY
	spread = 26
	shotsleft = 95
	reloadtime = 3.2 SECONDS
	special = "This weapon has IFF capabilities."
	fire_sound = 'sound/weapons/gun/smg/vp70.ogg'
	autofire = 0.08 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
	)

//Just a funny gold soda pistol. It was originally meant to just be a golden meme weapon, now it is the only pale gun, lol
/obj/item/ego_weapon/ranged/pistol/executive
	name = "executive"
	desc = "A pistol painted in black with a gold finish. Whenever this EGO is used, a faint scent of fillet mignon wafts through the air."
	icon_state = "executive"
	inhand_icon_state = "executive"
	special = "This gun scales with justice."
	force = 12
	damtype = PALE_DAMAGE
	burst_size = 1
	fire_delay = 5
	shotsleft = 10
	reloadtime = 0.7 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	projectile_path = /obj/projectile/ego_bullet/ego_executive
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/pistol/executive/fire_projectile(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, temporary_damage_multiplier)
	if(!ishuman(user))
		return ..()

	var/userjust = get_attribute_level(user, JUSTICE_ATTRIBUTE)
	var/justicemod = 1 + userjust/100
	temporary_damage_multiplier = justicemod
	return ..()

/obj/item/ego_weapon/ranged/pistol/crimson
	name = "crimson scar"
	desc = "With steel in one hand and gunpowder in the other, there's nothing to fear in this place."
	icon_state = "crimsonscar"
	inhand_icon_state = "crimsonscar"
	force = 17
	projectile_path = /obj/projectile/ego_bullet/ego_crimson
	weapon_weight = WEAPON_MEDIUM
	pellets = 3
	variance = 14
	special = "This weapon fires 3 pellets."
	fire_delay = 7
	shotsleft = 9
	reloadtime = 1 SECONDS
	fire_sound = 'sound/abnormalities/redhood/fire.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/ecstasy
	name = "ecstasy"
	desc = "Tell the kid today's treat is going to be grape-flavored candy. It's his favorite."
	icon_state = "ecstasy"
	inhand_icon_state = "ecstasy"
	special = "This weapon fires slow bullets with limited range."
	force = 28
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_ecstasy
	weapon_weight = WEAPON_MEDIUM
	spread = 40
	fire_sound = 'sound/weapons/ego/ecstasy.ogg'
	autofire = 0.08 SECONDS
	shotsleft = 40
	reloadtime = 1.8 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/pistol/praetorian
	name = "praetorian"
	desc = "And with her guard, she conquered all."
	icon_state = "praetorian"
	inhand_icon_state = "executive"
	special = "This weapon fires IFF bullets."
	force = 28
	projectile_path = /obj/projectile/ego_bullet/ego_praetorian
	fire_sound = 'sound/weapons/gun/pistol/tp17.ogg'
	autofire = 0.12 SECONDS
	shotsleft = 12
	reloadtime = 0.5 SECONDS
	fire_sound_volume = 30
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/pistol/magic_pistol
	name = "magic pistol"
	desc = "All the power of magic bullet, in a smaller package."
	icon_state = "magic_pistol"
	inhand_icon_state = "magic_pistol"
	special = "This weapon pierces all targets. This weapon fires faster with the matching armor"
	force = 17
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_magicpistol
	fire_delay = 6
	shotsleft = 7
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/cached_multiplier

/obj/item/ego_weapon/ranged/pistol/magic_pistol/before_firing(atom/target, mob/user)
	if(cached_multiplier)
		projectile_damage_multiplier = cached_multiplier
	fire_delay = initial(fire_delay)
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/he/magicbullet/Y = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		fire_delay = 8
	if(istype(Z))
		cached_multiplier = projectile_damage_multiplier
		projectile_damage_multiplier *= 2.5
		fire_delay = 8
	..()

/obj/item/ego_weapon/ranged/pistol/laststop
	name = "last stop"
	desc = "There are no clocks to alert the arrival times."
	icon_state = "laststop"
	inhand_icon_state = "laststop"
	force = 17
	projectile_path = /obj/projectile/ego_bullet/ego_laststop
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	shotsleft = 2
	reloadtime = 10 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/intentions
	name = "good intentions"
	desc = "Go ahead and rattle 'em boys."
	icon_state = "intentions"
	inhand_icon_state = "intentions"
	force = 17
	projectile_path = /obj/projectile/ego_bullet/ego_intention
	weapon_weight = WEAPON_MEDIUM
	spread = 40
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.07 SECONDS
	shotsleft = 50
	reloadtime = 2.1 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/aroma
	name = "faint aroma"
	desc = "Simply carrying it gives the illusion that you're standing in a forest in the middle of nowhere. \
			The arrowhead is dull and sprouts flowers of vivid color wherever it strikes."
	icon_state = "aroma"
	inhand_icon_state = "aroma"
	force = 28
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_aroma
	weapon_weight = WEAPON_HEAVY
	fire_delay = 25
	fire_sound = 'sound/weapons/ego/crossbow.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/assonance
	name = "assonance"
	desc = "However, the world is more than simply warmth and light. The sky exists, for so does the land; darkness exists, \
				for so does light; life exists for so does death; hope exists for so does despair."
	icon_state = "assonance"
	inhand_icon_state = "assonance"
	special = "This weapon fires a hitscan beam. \nUpon hitting an enemy, this weapon heals a nearby Discord weapon user."
	force = 28
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/beam/assonance
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	shotsleft = 17
	reloadtime = 1.6 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

//It's a magic sword. Cope Egor
/obj/item/ego_weapon/ranged/feather
	name = "feather of honor"
	desc = "A flaming, but very sharp, feather."
	icon_state = "featherofhonor"
	worn_icon_state = "featherofhonor"
	inhand_icon_state = "featherofhonor"
	projectile_path = /obj/projectile/ego_bullet/ego_feather
	weapon_weight = WEAPON_HEAVY
	special = "This weapon is highly effective in melee."
	force = 42
	damtype = WHITE_DAMAGE
	fire_delay = 12
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/exuviae
	name = "exuviae"
	desc = "A chunk of the naked nest inigrated with a launching mechanism."
	icon_state = "exuviae"
	inhand_icon_state = "exuviae"
	force = 33
	attack_speed = 1.3
	projectile_path = /obj/projectile/ego_bullet/ego_exuviae
	weapon_weight = WEAPON_HEAVY
	special = "Upon hit the targets RED vulnerability is increased by 0.2."
	damtype = RED_DAMAGE
	fire_delay = 30 //5 less than the Rend Armor status effect
	fire_sound = 'sound/misc/moist_impact.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

//Full manual bow-type E.G.O, must be loaded before firing.
/obj/item/ego_weapon/ranged/warring
	name = "feather of valor"
	desc = "A shimmering bow adorned with carved wooden panels. It crackes with arcing electricity."
	icon_state = "warring"
	inhand_icon_state = "warring"
	special = "This weapon can unleash a special attack by loading a second arrow."
	force = 28
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_warring
	weapon_weight = WEAPON_HEAVY
	fire_delay = 0//it caused some jank, like failing to charge after the do-after
	spread = 0
	//firing sound 1
	fire_sound = 'sound/weapons/bowfire.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)
	var/drawn = 0
	charge = TRUE
	attack_charge_gain = FALSE
	charge_cost = 3
	charge_effect = "fire a beam of electricity."
	var/ammo_2 = /obj/projectile/ego_bullet/ego_warring2

/obj/item/ego_weapon/ranged/warring/examine(mob/user)//attack speed isn't used, so it needs to be overridden
	. = ..()
	. -= span_notice("This weapon fires fast.")//it doesn't
	. += span_notice("This weapon must be loaded manually by activating it in your hand.")

/obj/item/ego_weapon/ranged/warring/can_shoot()
	if(drawn == 0)
		icon_state = "[initial(icon_state)]"
		return FALSE
	return TRUE

/obj/item/ego_weapon/ranged/warring/afterattack(atom/target, mob/user)
	. = ..()
	drawn = 0
	projectile_path = initial(projectile_path)
	icon_state = "[initial(icon_state)]"

/obj/item/ego_weapon/ranged/warring/attack_self(mob/user)
	switch(drawn)
		if(0)
			if(!do_after(user, 1 SECONDS, src, IGNORE_USER_LOC_CHANGE))
				return

			drawn  = 1
			to_chat(user, span_warning("You draw the [src] with all your might."))
			projectile_path = initial(projectile_path)
			fire_sound = 'sound/weapons/bowfire.ogg'
			icon_state = "warring_drawn"
		if(1)
			if(!do_after(user, 1, src, IGNORE_USER_LOC_CHANGE))
				return
			if(drawn != 1 || charge_amount < charge_cost)
				return
			drawn = 2
			charge_amount -= charge_cost
			projectile_path = ammo_2
			playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
			to_chat(user, span_warning("An arrow of lightning appears."))
			fire_sound = 'sound/abnormalities/thunderbird/tbird_beam.ogg'
			icon_state = "warring_firey"
		if(2)
			if(!do_after(user, 1, src, IGNORE_USER_LOC_CHANGE))
				return
			drawn = 1
			charge_amount += charge_cost
			projectile_path = initial(projectile_path)
			fire_sound = 'sound/weapons/bowfire.ogg'
			icon_state = "warring_drawn"
			to_chat(user, span_warning("The lightning fades."))

/obj/item/ego_weapon/ranged/banquet
	name = "banquet"
	desc = "Time for a feast! Enjoy the blood-red night imbued with madness to your heart’s content!"
	icon_state = "banquet"
	inhand_icon_state = "banquet"
	special = "This weapon uses HP to reload and heals you on a melee hit."
	force = 36
	damtype = BLACK_DAMAGE
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/ego_banquet
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 13
	shotsleft = 7
	reloadtime = 1.6 SECONDS
	fire_sound = 'sound/weapons/ego/cannon.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/banquet/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.10
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)
	return ..()

/obj/item/ego_weapon/ranged/banquet/reload_ego(mob/user)
	is_reloading = TRUE
	to_chat(user,span_notice("You start loading a new magazine."))
	playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
	if(do_after(user, reloadtime, src)) //gotta reload
		playsound(src, 'sound/weapons/gun/general/bolt_rack.ogg', 50, TRUE)
		if(isliving(user))
			var/mob/living/the_gunner = user
			the_gunner.adjustBruteLoss(3 * (initial(shotsleft) - shotsleft)) // Lose 3 * shots spent in hp
		shotsleft = initial(shotsleft)
	is_reloading = FALSE
	forced_melee = FALSE //no longer forced to resort to melee

/obj/item/ego_weapon/ranged/blind_rage
	name = "Blind Fire"
	desc = "The pain inflicted by rash action and harsh words last longer than most think."
	icon_state = "blind_gun"
	special = "This weapon fires burning bullets. Watch out for friendly fire!"
	projectile_path = /obj/projectile/ego_bullet/ego_blind_rage
	force = 28
	damtype = BLACK_DAMAGE
	weapon_weight = WEAPON_HEAVY
	pellets = 4
	variance = 30
	fire_delay = 8
	shotsleft = 8
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/my_own_bride
	name = "My own Bride"
	desc = "Simply carrying it gives the illusion that you're standing in a forest in the middle of nowhere. \
			The arrowhead is dull and sprouts flowers of vivid color wherever it strikes."
	icon_state = "wife"
	inhand_icon_state = "wife"
	force = 28
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_bride
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	shotsleft = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
	)


/obj/item/ego_weapon/ranged/pistol/innocence
	name = "childhood memories"
	desc = "If no one had come in to get me, I would have stayed in that room, not even realizing the passing time."
	icon_state = "innocence_gun"
	inhand_icon_state = "innocence_gun"
	force = 17
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_innocence
	fire_sound = 'sound/abnormalities/orangetree/ding.ogg'
	vary_fire_sound = TRUE
	autofire = 0.2 SECONDS
	shotsleft = 32
	reloadtime = 2.1 SECONDS
	fire_sound_volume = 20
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/hypocrisy
	name = "hypocrisy"
	desc = "The tree turned out to be riddled with hypocrisy and deception; those who wear its blessing act in the name of bravery and faith."
	icon_state = "hypocrisy"
	inhand_icon_state = "hypocrisy"
	worn_icon_state = "hypocrisy"
	special = "Use this weapon in hand to place a trap that inflicts \
		50 RED damage and alerts the user of the area it was triggered."
	force = 28
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hypocrisy
	weapon_weight = WEAPON_HEAVY
	fire_delay = 25
	fire_sound = 'sound/weapons/ego/crossbow.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)
	var/trap_cooldown = 0

/obj/item/ego_weapon/ranged/hypocrisy/attack_self(mob/living/carbon/user)
	if(locate(/obj/structure/liars_trap) in range(1, get_turf(src)))
		to_chat(user,span_notice("Your too close to another trap."))
		return
	to_chat(user,span_notice("You pull out an arrow and attempt to stab it into the ground."))
	playsound(src, 'sound/items/crowbar.ogg', 50, TRUE)
	if(do_after(user, 3 SECONDS, src))
		if(trap_cooldown >= world.time)
			to_chat(user,span_notice("You cant place a sapling trap yet."))
			return
		playsound(get_turf(user), 'sound/creatures/venus_trap_hurt.ogg', 50, TRUE)
		var/obj/structure/liars_trap/c = new(get_turf(user))
		c.creator = user
		c.faction = user.faction.Copy()
		trap_cooldown = world.time + (10 SECONDS)

//Parasite Tree Ego Weapon Trap
/obj/structure/liars_trap
	gender = PLURAL
	name = "sapling trap"
	desc = "A small harmless looking sapling. Its leaves never seem to wilt."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "liars_trap"
	anchored = TRUE
	density = FALSE
	resistance_flags = FLAMMABLE
	max_integrity = 15
	var/mob/living/carbon/human/creator
	var/list/faction = list()

/obj/structure/liars_trap/Initialize()
	. = ..()
	if(creator)
		faction = creator.faction.Copy()

/obj/structure/liars_trap/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(!faction_check(faction, L.faction))
			playsound(get_turf(src), 'sound/machines/clockcult/steam_whoosh.ogg', 10, 1)
			L.apply_damage(50, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = FALSE)
			new /obj/effect/temp_visual/cloud_swirl(get_turf(L)) //placeholder
			to_chat(creator, span_warning("You feel a itch towards [get_area(L)]."))
			qdel(src)
