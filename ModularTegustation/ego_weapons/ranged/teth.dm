//All teth Rifles should be around 22 DPS (31 per bullet
//All Teth Pistols should hit about

//Does slightly less damage due to AOE.
/obj/item/ego_weapon/ranged/match
	name = "fourth match flame"
	desc = "The light of the match will not go out until it has burned away happiness, warmth, light, \
	and all the other good things of the world; there's no need to worry about it being quenched."
	icon_state = "match"
	inhand_icon_state = "match"
	special = "This weapon does AOE damage."
	force = 23
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/ego_match
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	shotsleft = 8
	reloadtime = 2.2 SECONDS
	fire_sound = 'sound/weapons/ego/cannon.ogg'

/obj/item/ego_weapon/ranged/beak
	name = "beak"
	desc = "As if to prove that size doesn't matter when it comes to force, \
	the weapon has high firepower despite its small size."
	icon_state = "beak"
	inhand_icon_state = "beak"
	force = 14
	projectile_path = /obj/projectile/ego_bullet/ego_beak
	weapon_weight = WEAPON_MEDIUM
	spread = 10
	shotsleft = 30
	reloadtime = 1.3 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.14 SECONDS

/obj/item/ego_weapon/ranged/pistol/beakmagnum
	name = "beak mk2"
	desc = "A heavy revolver that fires at a surprisingly fast rate, and is deadly accurate."
	icon_state = "beakmagnum"
	inhand_icon_state = "beakmagnum"
	force = 8
	special = "This weapon has pinpoint accuracy when dual wielded."
	projectile_path = /obj/projectile/ego_bullet/ego_beakmagnum
	fire_delay = 10
	shotsleft = 7
	reloadtime = 2.1 SECONDS
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	dual_wield_spread = 0

/obj/item/ego_weapon/ranged/noise
	name = "noise"
	desc = "The noises take you back to the very moment of the day that everyone had forgotten."
	icon_state = "noise"
	inhand_icon_state = "noise"
	special = "This weapon fires 5 pellets."
	force = 14
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_noise
	weapon_weight = WEAPON_HEAVY
	pellets = 5
	variance = 20
	fire_delay = 10
	shotsleft = 8
	reloadtime = 1.6 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

/obj/item/ego_weapon/ranged/pistol/solitude
	name = "solitude"
	desc = "A classic blue revolver, that gives you feelings of loneliness."
	icon_state = "solitude"
	inhand_icon_state = "solitude"
	force = 8
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solitude
	fire_delay = 10
	shotsleft = 5
	reloadtime = 2 SECONDS
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/ego_weapon/ranged/pistol/shy
	name = "todays expression"
	desc = "Many different expressions are padded on the equipment like patches. \
	When throbbing emotions surge up from time to time, it's best to simply cover the face."
	icon_state = "shy"
	inhand_icon_state = "shy"
	force = 8
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_shy
	fire_sound = 'sound/effects/meatslap.ogg'
	vary_fire_sound = FALSE
	shotsleft = 20
	reloadtime = 1.2 SECONDS
	autofire = 0.2 SECONDS

/obj/item/ego_weapon/ranged/dream
	name = "engulfing dream"
	desc = "And when the crying stops, dawn will break."
	icon_state = "dream"
	inhand_icon_state = "dream"
	force = 14
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_dream
	weapon_weight = WEAPON_HEAVY
	fire_sound = "dreamy_gun"
	autofire = 0.25 SECONDS

/obj/item/ego_weapon/ranged/page
	name = "page"
	desc = "The pain of creation! The pain! The pain!"
	icon_state = "page"
	inhand_icon_state = "page"
	force = 14
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_page
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	shotsleft = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'

/obj/item/ego_weapon/ranged/snapshot
	name = "snapshot"
	desc = "I swear, that obscene portrait was just trying to make us lower our guard."
	icon_state = "snapshot"
	inhand_icon_state = "snapshot"
	special = "This weapon fires a hitscan beam."
	force = 14
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/beam/snapshot
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/sonic_jackhammer.ogg'

/obj/item/ego_weapon/ranged/wishing_cairn
	name = "wishing cairn"
	desc = "Speak unto me your wish, vocalize your eagerness..."
	icon_state = "wishing_cairn"
	inhand_icon_state = "wishing_cairn"
	special = "This weapon has a combo system with a short range."
	force = 14
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_wishing
	weapon_weight = WEAPON_HEAVY
	fire_delay = 3
	burst_size = 2
	fire_sound = 'sound/abnormalities/pagoda/throw.ogg'
	var/ammo2 = /obj/projectile/ego_bullet/ego_wishing2

/obj/item/ego_weapon/ranged/wishing_cairn/proc/Ammo_Change()
	projectile_path = ammo2
	fire_sound = 'sound/abnormalities/pagoda/throw2.ogg'

/obj/item/ego_weapon/ranged/wishing_cairn/afterattack(atom/target, mob/user)
	. = ..()
	projectile_path = initial(projectile_path)
	fire_sound = 'sound/abnormalities/pagoda/throw.ogg'

/obj/item/ego_weapon/ranged/aspiration
	name = "aspiration"
	desc = "The desire to live was stronger than anything. That is when regret finally ran a shudder through my body."
	icon_state = "aspiration"
	inhand_icon_state = "aspiration"
	special = "This weapon fires a hitscan beam at the cost of health. \n Upon hitting an ally, this weapon heals the target,"
	force = 14
	projectile_path = /obj/projectile/ego_bullet/ego_aspiration
	weapon_weight = WEAPON_HEAVY
	autofire = 0.5 SECONDS
	fire_sound = 'sound/abnormalities/fragment/attack.ogg'

/obj/item/ego_weapon/ranged/aspiration/before_firing(atom/target,mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjustBruteLoss(3)
	return ..()

/obj/item/ego_weapon/ranged/patriot
	name = "patriot"
	desc = "Are you willing to do what it takes to protect your country?"
	icon_state = "patriot"
	inhand_icon_state = "patriot"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	special = "This weapon fires 4 pellets."
	force = 18
	attack_speed = 1.3
	projectile_path = /obj/projectile/ego_bullet/ego_patriot
	pellets = 4
	variance = 25
	weapon_weight = WEAPON_HEAVY
	fire_delay = 12
	shotsleft = 8
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'

/obj/item/ego_weapon/ranged/luckdraw
	name = "luck of the draw"
	desc = "A seemingly infinite deck of bladed cards. How much are you willing to risk to win it big?"
	icon_state = "luckdraw"
	inhand_icon_state = "luckdraw"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	special = "This weapon's projectiles move slowly and pierce enemies."
	projectile_path = /obj/projectile/ego_bullet/ego_luckdraw
	weapon_weight = WEAPON_HEAVY
	autofire = 0.6 SECONDS
	fire_sound = 'sound/items/handling/paper_pickup.ogg' //Mostly just using this for a lack of a better "card-flicking" noise

/obj/item/ego_weapon/ranged/pistol/tough
	name = "tough pistol"
	desc = "A glock reminiscent of a certain detective who fought evil for 25 years, losing hair as time went by."
	special = "Use this weapon in your hand when wearing matching armor to turn others nearby bald."
	icon_state = "bald"
	inhand_icon_state = "bald"
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_tough
	burst_size = 1
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	var/pulse_cooldown
	var/pulse_cooldown_time = 60 SECONDS
	var/blast_delay = 3 SECONDS

/obj/item/ego_weapon/ranged/pistol/tough/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(pulse_cooldown > world.time)
		to_chat(H, "<span class='warning'>You have used this ability too recently!</span>")
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/tough/T = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(T))
		to_chat(H, "<span class='warning'>You must have the corrosponding armor equipped to use this ability!</span>")
		return
	to_chat(H, "<span class='warning'>You use the [src] to create a field of baldness!</span>")
	H.playsound_local(get_turf(H), 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 25, 0)
	BaldBlast(user)
	pulse_cooldown = world.time + pulse_cooldown_time

/obj/item/ego_weapon/ranged/pistol/tough/proc/BaldBlast(mob/living/carbon/human/user ,list/baldtargets = list(), burst_chain)
	for(var/mob/living/carbon/human/L in livinginview(5, user)) //not even the dead are safe.
		if(!ishuman(L))
			continue
		if(HAS_TRAIT(L, TRAIT_BALD))
			continue
		if(L in baldtargets)
			to_chat(L, "<span class='warning'>You feel awesome!</span>")
			ADD_TRAIT(L, TRAIT_BALD, "ABNORMALITY_BALD")
			L.hairstyle = "Bald"
			L.update_hair()
			continue

		baldtargets += L
		to_chat(L, "<span class='warning'>You have been hit by the baldy-bald psychological attack. If a non-bald person is reading this, they will be granted the privilege of going bald at an extremely rapid pace if they stay within range of [user]!</span>")
	if(!burst_chain)
		addtimer(CALLBACK(src, PROC_REF(BaldBlast), user, baldtargets, TRUE), blast_delay)

/obj/item/ego_weapon/ranged/pistol/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_BALD))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with dedication to clean hairstyle can use [src]!</span>")
	return FALSE

/obj/item/ego_weapon/ranged/pistol/tough/SpecialGearRequirements()
	return "\n<span class='warning'>The user must have clean hairstyle.</span>"

