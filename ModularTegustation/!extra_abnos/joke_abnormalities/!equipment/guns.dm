//Zayin
//The Mcrib
/obj/item/ego_weapon/ranged/pistol/mcrib
	name = "mcrib"
	desc = "Try a mcrib at your nearest McDonalds!"
	special = "Use this weapon in your hand when wearing matching armor to create food for people nearby."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "mcrib"
	force = 6
	projectile_path = /obj/projectile/ego_bullet/ego_mcrib
	burst_size = 1
	fire_delay = 10
	fire_sound = 'sound/effects/meatslap.ogg'
	var/ability_cooldown_time = 60 SECONDS
	var/ability_cooldown

/obj/item/ego_weapon/ranged/pistol/mcrib/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(ability_cooldown > world.time)
		to_chat(H, "<span class='warning'>You have used this ability too recently!</span>")
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/mcrib/T = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(T))
		to_chat(H, "<span class='warning'>You must have the corrosponding armor equipped to use this ability!</span>")
		return
	to_chat(H, "<span class='warning'>You use mcrib to share snacks!</span>")
	H.playsound_local(get_turf(H), 'sound/abnormalities/mcrib/mcrib.ogg', 25, 0)
	SpawnItem(user)
	ability_cooldown = world.time + ability_cooldown_time

/obj/item/ego_weapon/ranged/pistol/mcrib/proc/SpawnItem(mob/user)
	var/foodoption = /obj/item/food/mcrib
	for(var/mob/living/carbon/human/L in livinginview(5, user))
		if((!ishuman(L)) || L.stat == DEAD || L == user)
			continue
		to_chat(L, "<span class='warning'>Is that... authentic Kansas City Barbecue sauce I smell? [user] gives you a snack!</span>")
		new foodoption(get_turf(L))
	new foodoption(get_turf(user))

/obj/projectile/ego_bullet/ego_mcrib
	name = "mcrib"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "patty"
	damage = 10
	damage_type = RED_DAMAGE

/obj/item/ego_weapon/ranged/anti_skub
	name = "anti-skub"
	desc = "A weapon easily created from schematics posted on illicit internet forums."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "anti_skub"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	inhand_icon_state = "beer"
	special = "This weapon deals AOE damage."
	force = 33
	attack_speed = 1.2
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/skub
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	fire_sound = 'sound/weapons/fixer/generic/dodge.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/projectile/ego_bullet/skub
	name = "skub cocktail"
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "anti_skub2"
	damage = 45
	damage_type = RED_DAMAGE
	hitsound = "shatter"

/obj/projectile/ego_bullet/skub/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/mob/living/L in view(1, target))
		new /obj/effect/temp_visual/fire/fast(get_turf(L))
		L.apply_damage(45, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT
