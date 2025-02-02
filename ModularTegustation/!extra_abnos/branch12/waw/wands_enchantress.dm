/mob/living/simple_animal/hostile/abnormality/branch12/enchantress_of_wands
	name = "Enchantress of Wands"
	desc = "A short magician that, while creative, is full of chaos."
	icon = 'ModularTegustation/Teguicons/branch12/32x48.dmi'
	icon_state = "enchantress"
	icon_living = "enchantress"
	threat_level = WAW_LEVEL
	maxHealth = 1750
	health = 1750

	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.4)
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 24
	melee_damage_upper = 28

	faction = list()
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 50, 50, 55, 60),
		ABNORMALITY_WORK_INSIGHT = list(20, 20, 20, 25, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 20, 20, 25, 30),
		ABNORMALITY_WORK_REPRESSION = list(45, 50, 50, 55, 60),
		)
	work_damage_amount = 7
	work_damage_type = PALE_DAMAGE

	ranged = TRUE
	retreat_distance = 3
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_enchanted
	projectilesound = 'sound/magic/wandodeath.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/branch12/icon_of_chaos,
		//datum/ego_datum/armor/icon_of_chaos,
		)

	//gift_type =  /datum/ego_gifts/icon_of_chaos


/mob/living/simple_animal/hostile/abnormality/branch12/enchantress_of_wands/WorkChance(mob/living/carbon/human/user, chance)
	return chance - (datum_reference.qliphoth_meter-1)*10


/mob/living/simple_animal/hostile/abnormality/branch12/enchantress_of_wands/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	say("Here kid, this one's for you.")

	//Force a wand into their hands.
	var/obj/item/held = user.get_active_held_item()
	var/obj/item/wep = new /obj/item/ego_weapon/ranged/branch12/enchanted_wand(user)
	user.dropItemToGround(held) //Drop weapon
	ADD_TRAIT(wep, TRAIT_NODROP, wep)
	user.put_in_hands(wep) 		//Time for pale

/mob/living/simple_animal/hostile/abnormality/branch12/enchantress_of_wands/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/enchantress_of_wands/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/enchantress_of_wands/BreachEffect(mob/living/carbon/human/user, work_type, pe)
	..()

/obj/item/ammo_casing/caseless/ego_enchanted
	name = "casing"
	desc = "A casing."
	projectile_type = /obj/projectile/ego_bullet/enchanted_wand

//The projectile and wands
/obj/item/ego_weapon/ranged/branch12/enchanted_wand
	name = "enchanted wand"
	desc = "Who knows what this holds?"
	icon_state = "enchanted_wand"
	inhand_icon_state = "enchanted_wand"
	special = "This gun self destructs after being fired."

	projectile_path = /obj/projectile/ego_bullet/enchanted_wand
	fire_sound = 'sound/magic/wandodeath.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 25

/obj/item/ego_weapon/ranged/branch12/enchanted_wand/fire_projectile(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, temporary_damage_multiplier)
	..()
	qdel(src)

/obj/projectile/ego_bullet/enchanted_wand
	name = "chaos bullet"
	icon_state = "arcane_barrage"
	speed = 1

/obj/projectile/ego_bullet/enchanted_wand/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		switch(rand(1,8))
			if(1)	//Instant Crit
				H.adjustBruteLoss(H.health+5)
			if(2)	//Vomit
				H.vomit(20, FALSE, distance = 0)
			if(3)	//Heal 100 HP
				H.adjustBruteLoss(-100)
			if(4)
				H.deal_damage(80, RED_DAMAGE)
			if(5)
				H.deal_damage(80, WHITE_DAMAGE)
			if(6)
				H.deal_damage(80, BLACK_DAMAGE)
			if(7)
				H.deal_damage(80, PALE_DAMAGE)
			if(8)	//Heal 100 SP
				H.adjustSanityLoss(-100)

	if(isliving(target))
		var/mob/living/L = target
		switch(rand(1,5))
			if(1)	//Heal 300
				L.adjustBruteLoss(-300)
			if(2)
				L.deal_damage(100, RED_DAMAGE)
			if(3)
				L.deal_damage(100, WHITE_DAMAGE)
			if(4)
				L.deal_damage(100, BLACK_DAMAGE)
			if(5)
				L.deal_damage(100, PALE_DAMAGE)
