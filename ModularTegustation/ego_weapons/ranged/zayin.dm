// All zayin pistols use the default 6 force for ego_gun pistols
/obj/item/ego_weapon/ranged/pistol/soda
	name = "soda pistol"
	desc = "A pistol painted in a refreshing purple. Whenever this EGO is used, a faint scent of grapes wafts through the air."
	special = "Perish while wearing matching armor and Wellcheers shrimp will arrive to mourn you."
	icon_state = "soda"
	inhand_icon_state = "soda"
	projectile_path = /obj/projectile/ego_bullet/ego_soda
	burst_size = 1
	fire_delay = 5
	shotsleft = 12
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	var/shrimp_chosen

/obj/item/ego_weapon/ranged/pistol/soda/pickup(mob/user)
	. = ..()
	shrimp_chosen = user
	RegisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH, PROC_REF(ShrimpFuneral))

/obj/item/ego_weapon/ranged/pistol/soda/dropped(mob/user)
	. = ..()
	UnregisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH)
	shrimp_chosen = null

/obj/item/ego_weapon/ranged/pistol/soda/Destroy(mob/user)
	if(shrimp_chosen)
		UnregisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH)
	shrimp_chosen = null
	return ..()

/obj/item/ego_weapon/ranged/pistol/soda/proc/ShrimpFuneral(mob/user)
	var/obj/item/clothing/suit/armor/ego_gear/zayin/soda/S = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(S))
		user.playsound_local(get_turf(user), 'sound/abnormalities/wellcheers/shrimptaps.ogg', 50, 0)
		for(var/i in 1 to 2)
			new /mob/living/simple_animal/hostile/shrimp/grieving(get_turf(user))

//friendly spawned shrimp
/mob/living/simple_animal/hostile/shrimp/grieving
	name = "wellcheers obituary serviceman"
	desc = "A shrimp that appears to be grieving. A moment of silence, please."
	icon_state = "wellcheers_funeral"
	icon_living = "wellcheers_funeral"
	faction = list("neutral", "shrimp")

/obj/item/ego_weapon/ranged/pistol/nostalgia
	name = "nostalgia"
	desc = "An old-looking pistol made of wood"
	special = "Use this weapon in your hand when wearing matching armor to heal the SP of others nearby."
	icon_state = "nostalgia"
	inhand_icon_state = "nostalgia"
	projectile_path = /obj/projectile/ego_bullet/ego_nostalgia
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	fire_delay = 12

	var/pulse_startup
	var/pulse_startup_time = 10 SECONDS
	var/pulse_cooldown = 1 SECONDS
	var/pulse_healing = -0.5 //negative damage
	var/pulse_enabled = FALSE

/obj/item/ego_weapon/ranged/pistol/nostalgia/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(pulse_startup > world.time)
		to_chat(H, "<span class='warning'>You have used this ability too recently!</span>")
		return
	pulse_startup = world.time + pulse_startup_time
	var/obj/item/clothing/suit/armor/ego_gear/zayin/nostalgia/N = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(N))
		pulse_enabled = TRUE
		to_chat(H, "<span class='warning'>You use the [src] to emit sanity healing pulses!</span>")
		H.playsound_local(get_turf(H), 'sound/abnormalities/old_lady/oldlady_debuff.ogg', 25, 0)
		HealPulse(user, 0)
	else
		pulse_enabled = FALSE
		to_chat(H, "<span class='warning'>You must have the corrosponding armor equipped to use this ability!</span>")

/obj/item/ego_weapon/ranged/pistol/nostalgia/dropped(mob/user)
	. = ..()
	pulse_enabled = FALSE

/obj/item/ego_weapon/ranged/pistol/nostalgia/Destroy(mob/user)
	. = ..()
	pulse_enabled = FALSE

/obj/item/ego_weapon/ranged/pistol/nostalgia/proc/HealPulse(mob/living/carbon/human/user, count)
	if(!pulse_enabled)
		return
	if(count >= 10)
		return
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustSanityLoss(pulse_healing)
		to_chat(L, "<span class='nicegreen'>A pulse from [user] makes your mind feel a bit clearer.</span>")
	addtimer(CALLBACK(src, PROC_REF(HealPulse), user, count += 1), pulse_cooldown)

/obj/item/ego_weapon/ranged/pistol/nightshade
	name = "nightshade"
	desc = "Strange that it was more than just a bleeding person in a vegetative state."
	special = "If you are wearing the matching armor, fired shots will heal friendlies on hit."
	icon_state = "nightshade"
	inhand_icon_state = "nightshade"
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_nightshade
	burst_size = 1
	fire_delay = 10
	fire_sound = 'sound/weapons/bowfire.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 50

/obj/item/ego_weapon/ranged/pistol/nightshade/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	var/obj/item/clothing/suit/armor/ego_gear/zayin/nightshade/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(C))
		projectile_path = /obj/projectile/ego_bullet/ego_nightshade/healing
	else
		projectile_path = /obj/projectile/ego_bullet/ego_nightshade
	return ..()

/obj/item/ego_weapon/ranged/bucket
	name = "bucket"
	desc = "A slingshot made from wooden staves that fires skipping stones. What will you wish for?"
	special = "Use this weapon in your hand when wearing matching armor to create gifts for people nearby."
	icon_state = "bucket"
	inhand_icon_state = "bucket"
	projectile_path = /obj/projectile/ego_bullet/ego_bucket
	fire_delay = 10
	fire_sound = 'sound/weapons/bowfire.ogg'
	vary_fire_sound = TRUE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 50
	var/ability_cooldown_time = 60 SECONDS
	var/ability_cooldown

/obj/item/ego_weapon/ranged/bucket/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(ability_cooldown > world.time)
		to_chat(H, "<span class='warning'>You have used this ability too recently!</span>")
		return
	var/obj/item/clothing/suit/armor/ego_gear/tools/bucket/T = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(T))
		to_chat(H, "<span class='warning'>You must have the corrosponding armor equipped to use this ability!</span>")
		return
	to_chat(H, "<span class='warning'>You use the [src] to draw something from wishing well!</span>")
	H.playsound_local(get_turf(H), 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 25, 0)
	SpawnItem(user)
	ability_cooldown = world.time + ability_cooldown_time

/obj/item/ego_weapon/ranged/bucket/proc/SpawnItem(mob/user)
	var/list/lootoptions = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
		/obj/item/food/salad/lifestew,
		/obj/item/reagent_containers/food/drinks/fairywine,
		/obj/item/food/breadslice/plain,
		/obj/item/food/mint,
		/obj/item/food/rationpack,
		/obj/item/clothing/mask/facehugger/bongy,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/neck/tie/blue,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/neck/tie/horrible,
		/obj/item/clothing/mask/cigarette/cigar/havana,
		/obj/item/poster/random_contraband,
		/obj/item/poster/random_official,
		/obj/item/toy/plush/rabbit,
		/obj/item/toy/plush/blank,
		/obj/item/toy/plush/bongy,
		/obj/item/trash/raisins,
		/obj/item/trash/candy,
		/obj/item/trash/cheesie,
		/obj/item/trash/chips,
		/obj/item/trash/popcorn,
		/obj/item/trash/sosjerky,
		/obj/item/trash/plate,
		/obj/item/trash/pistachios,
		/obj/item/food/candy_corn/prison,)
	for(var/mob/living/carbon/human/L in livinginview(5, user))
		if((!ishuman(L)) || L.stat == DEAD || L == user)
			continue
		to_chat(L, "<span class='warning'>[user] gives you an item!</span>")
		var/gift = pick(lootoptions)
		new gift(get_turf(L))
	var/gift = pick(lootoptions)//you get one too!
	new gift(get_turf(user))

/obj/item/ego_weapon/ranged/pistol/oceanic
	name = "a taste of the ocean"
	desc = "A pistol painted in a refreshing orange. Whenever this EGO is used, a faint scent of orange wafts through the air."
	icon_state = "oceanic"
	inhand_icon_state = "oceanic"
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_oceanic
	burst_size = 1
	fire_delay = 5
	shotsleft = 7
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

