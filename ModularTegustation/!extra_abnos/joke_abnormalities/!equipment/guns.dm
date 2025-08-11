//Zayin
//The Mcrib
/obj/item/ego_weapon/ranged/pistol/mcrib
	name = "mcrib"
	desc = "Try a mcrib at your nearest McDonalds!"
	special = "Use this weapon in your hand when wearing matching armor to create food for people nearby."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "mcrib"
	force = 3
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
	damage = 4
	damage_type = RED_DAMAGE
