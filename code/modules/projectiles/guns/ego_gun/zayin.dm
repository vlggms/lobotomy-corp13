/obj/item/gun/ego_gun/pistol/tough
	name = "tough pistol"
	desc = "A glock reminiscent of a certain detective who fought evil for 25 years, losing hair as time went by."
	special = "Use this weapon in your hand when wearing matching armor to activate a special ability."
	icon_state = "bald"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_type = /obj/item/ammo_casing/caseless/ego_tough
	burst_size = 1
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	var/pulse_cooldown
	var/pulse_cooldown_time = 60 SECONDS
	var/blast_delay = 3 SECONDS

/obj/item/gun/ego_gun/pistol/tough/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(pulse_cooldown > world.time)
		to_chat(H, "<span class='warning'>You have used this ability too recently!</span>")
		return
	var/obj/item/clothing/suit/armor/ego_gear/tough/T = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(T))
		to_chat(H, "<span class='warning'>You must have the corrosponding armor equipped to use this ability!</span>")
		return
	to_chat(H, "<span class='warning'>You use the [src] to create a field of baldness!</span>")
	H.playsound_local(get_turf(H), 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 25, 0)
	BaldBlast(user)
	pulse_cooldown = world.time + pulse_cooldown_time

/obj/item/gun/ego_gun/pistol/tough/proc/BaldBlast(mob/living/carbon/human/user ,list/baldtargets = list(), burst_chain)
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
		addtimer(CALLBACK(src, .proc/BaldBlast, user, baldtargets, TRUE), blast_delay)

/obj/item/gun/ego_gun/pistol/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_BALD))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with dedication to clean hairstyle can use [src]!</span>")
	return FALSE

/obj/item/gun/ego_gun/pistol/tough/SpecialGearRequirements()
	return "\n<span class='warning'>The user must have clean hairstyle.</span>"

/obj/item/gun/ego_gun/pistol/soda
	name = "soda pistol"
	desc = "A pistol painted in a refreshing purple. Whenever this EGO is used, a faint scent of grapes wafts through the air."
	special = "This weapon has a special ability that activates when the user dies while wearing matching armor."
	icon_state = "soda"
	inhand_icon_state = "soda"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	burst_size = 1
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	var/shrimp_chosen

/obj/item/gun/ego_gun/pistol/soda/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	shrimp_chosen = user
	RegisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH, .proc/ShrimpFuneral)

/obj/item/gun/ego_gun/pistol/soda/dropped(mob/user)
	. = ..()
	UnregisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH)
	shrimp_chosen = null

/obj/item/gun/ego_gun/pistol/soda/Destroy(mob/user)
	. = ..()
	UnregisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH)
	shrimp_chosen = null

/obj/item/gun/ego_gun/pistol/soda/proc/ShrimpFuneral(mob/user)
	var/obj/item/clothing/suit/armor/ego_gear/soda/S = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(S))
		var/shrimpcount
		while(shrimpcount < 2)
			new /mob/living/simple_animal/hostile/shrimp/friendly(get_turf(user))
			shrimpcount += 1
	user.playsound_local(get_turf(user), 'sound/abnormalities/wellcheers/shrimptaps.ogg', 50, 0)

//friendly spawned shrimp
/mob/living/simple_animal/hostile/shrimp/friendly
	name = "wellcheers obituary serviceman"
	desc = "A shrimp that appears to be grieving. A moment of silence, please."
	icon_state = "wellcheers_funeral"
	icon_living = "wellcheers_funeral"
	faction = list("neutral", "shrimp")

/obj/item/gun/ego_gun/clerk
	name = "clerk pistol"
	desc = "A shitty pistol, labeled 'Point open end towards enemy'."
	icon_state = "clerk"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/caseless/ego_clerk
	burst_size = 1
	fire_delay = 3
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/gun/ego_gun/clerk/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(semicd)
		return

	var/user_target = FALSE
	if(user == target)
		target.visible_message("<span class='warning'>[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger...</span>", \
			"<span class='userdanger'>You stick [src] in your mouth, ready to pull the trigger...</span>")
		user_target = TRUE
	else
		target.visible_message("<span class='warning'>[user] points [src] at [target]'s head, ready to pull the trigger...</span>", \
			"<span class='userdanger'>[user] points [src] at your head, ready to pull the trigger...</span>")

	semicd = TRUE

	if(!bypass_timer && (!do_mob(user, target, (user_target ? 3 SECONDS : 12 SECONDS)) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] decided not to shoot.</span>")
			else if(target?.Adjacent(user))
				target.visible_message("<span class='notice'>[user] has decided to spare [target]</span>", "<span class='notice'>[user] has decided to spare your life!</span>")
		semicd = FALSE
		return

	semicd = FALSE

	target.visible_message("<span class='warning'>[user] pulls the trigger!</span>", "<span class='userdanger'>[(user == target) ? "You pull" : "[user] pulls"] the trigger!</span>")

	if(chambered?.BB)
		chambered.BB.damage *= (user_target ? 100 : 5) // This should certainly kill you on suicide
		chambered.BB.wound_bonus += (user_target ? 200 : 10) // THERE WILL BE BLOOD
		chambered.BB.dismemberment = (user_target ? 5 : 0) // Tiny chance to behead you for no reason at all

	var/fired = process_fire(target, user, TRUE, params, BODY_ZONE_HEAD)
	if(!fired && chambered?.BB)
		chambered.BB.damage /= (user_target ? 100 : 5)
		chambered.BB.wound_bonus -= (user_target ? 200 : 10)
		chambered.BB.dismemberment = 0

/obj/item/gun/ego_gun/pistol/nostalgia
	name = "nostalgia"
	desc = "An old-looking pistol made of wood"
	special = "Use this weapon in your hand when wearing matching armor to activate a special ability."
	icon_state = "nostalgia"
	inhand_icon_state = "nostalgia"
	ammo_type = /obj/item/ammo_casing/caseless/ego_nostalgia
	fire_delay = 20
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

	var/pulse_startup
	var/pulse_startup_time = 10 SECONDS
	var/pulse_cooldown = 1 SECONDS
	var/pulse_healing = -0.5 //negative damage
	var/pulse_enabled = FALSE

/obj/item/gun/ego_gun/pistol/nostalgia/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(pulse_startup > world.time)
		to_chat(H, "<span class='warning'>You have used this ability too recently!</span>")
		return
	pulse_startup = world.time + pulse_startup_time
	var/obj/item/clothing/suit/armor/ego_gear/nostalgia/N = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(N))
		pulse_enabled = TRUE
		to_chat(H, "<span class='warning'>You use the [src] to emit sanity healing pulses!</span>")
		H.playsound_local(get_turf(H), 'sound/abnormalities/old_lady/oldlady_debuff.ogg', 25, 0)
		HealPulse(user, 0)
	else
		pulse_enabled = FALSE
		to_chat(H, "<span class='warning'>You must have the corrosponding armor equipped to use this ability!</span>")

/obj/item/gun/ego_gun/pistol/nostalgia/dropped(mob/user)
	. = ..()
	pulse_enabled = FALSE

/obj/item/gun/ego_gun/pistol/nostalgia/Destroy(mob/user)
	. = ..()
	pulse_enabled = FALSE

/obj/item/gun/ego_gun/pistol/nostalgia/proc/HealPulse(mob/living/carbon/human/user, count)
	if(!pulse_enabled)
		return
	if(count >= 10)
		return
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustSanityLoss(pulse_healing)
		to_chat(L, "<span class='nicegreen'>A pulse from [user] makes your mind feel a bit clearer.</span>")
	addtimer(CALLBACK(src, .proc/HealPulse, user, count += 1), pulse_cooldown)

/obj/item/gun/ego_gun/pistol/nightshade
	name = "nightshade"
	desc = "Strange that it was more than just a bleeding person in a vegetative state."
	icon_state = "nightshade"
	inhand_icon_state = "nightshade"
	ammo_type = /obj/item/ammo_casing/caseless/ego_nightshade
	burst_size = 1
	fire_delay = 10
	fire_sound = 'sound/weapons/bowfire.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 50

/obj/item/gun/ego_gun/pistol/nightshade/process_fire(atom/target, mob/living/user)
	var/obj/item/clothing/suit/armor/ego_gear/nightshade/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(C))
		if(ammo_type == /obj/item/ammo_casing/caseless/ego_nightshade/healing)
			ammo_type = /obj/item/ammo_casing/caseless/ego_nightshade
	else
		if(ammo_type == /obj/item/ammo_casing/caseless/ego_nightshade)
			ammo_type = /obj/item/ammo_casing/caseless/ego_nightshade/healing
	return ..()
