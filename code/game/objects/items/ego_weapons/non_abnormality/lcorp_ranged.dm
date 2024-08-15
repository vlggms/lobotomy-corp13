//A file for all ranged weapons manufactured at L-corp that is not E.G.O.

//Contains ERA, clerk. and officer (?) weapons

///////////////////////
//ERA/AGENT EQUIPMENT//
///////////////////////

/obj/item/gun/ego_gun/city/lcorp
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	ammo_type = /obj/item/ammo_casing/caseless/ego_clerk
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20,
							PRUDENCE_ATTRIBUTE = 20,
							TEMPERANCE_ATTRIBUTE = 20,
							JUSTICE_ATTRIBUTE = 20
							)
	var/installed_shard
	var/equipped
	var/tier = 0

/obj/item/gun/ego_gun/city/lcorp/examine(mob/user)
	. = ..()
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Emergency Response Agent"))
			. += span_notice("Due to your abilties, you get a +20 to your stats when equipping this weapon.")
	if(!installed_shard)
		. += span_warning("This weapon can be enhanced with an egoshard.")
	else
		. += span_nicegreen("It has a [installed_shard] installed.")

/obj/item/gun/ego_gun/city/lcorp/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/gun/ego_gun/city/lcorp/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/gun/ego_gun/city/lcorp/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("You need to put down [src] before attempting this!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src] already has an egoshard installed!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/gun/ego_gun/city/lcorp/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	tier = egoshard.tier
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("The requirements to equip [src] have increased!"))
	to_chat(user, span_nicegreen("[src] has been successfully improved!"))
	icon_state = "[initial(icon_state)]_[egoshard.damage_type]"
	if(chambered) //This bit of code is supposed to update the examine by loading in a fresh bullet. It doesn't. I do not know why, but I do know that it at least runs properly.
		if(chambered.BB)
			QDEL_NULL(chambered.BB)
	else
		chambered = new ammo_type(src)
	chambered.newshot()

/obj/item/ammo_casing/caseless/lcorp
	name = "9mm pistol casing"
	desc = "A casing."
	projectile_type = /obj/projectile/ego_bullet/lcorp
	var/tier = 0
	damtype = RED_DAMAGE

/obj/item/ammo_casing/caseless/lcorp/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	..()
	if(tier) //No reason to run this again
		return
	if(isgun(fired_from))
		var/obj/item/gun/ego_gun/city/lcorp/G = fired_from
		var/obj/projectile/ego_bullet/lcorp/GG = BB
		GG.tier = G.tier
		GG.damage_type = G.damtype
		GG.damage = GG.damage_tier[GG.tier]
		tier = G.tier
		damtype = GG.damage_type
		if(damtype == PALE_DAMAGE) //pale deals 25% less damage
			GG.damage = round(GG.damage * 0.75)

/obj/item/ammo_casing/caseless/lcorp/newshot() //We're reusing the code here so that the damage shows up on examine
	if(!BB)
		BB = new projectile_type(src, src)
	if(tier)
		var/obj/projectile/ego_bullet/lcorp/GG = BB
		GG.tier = tier
		GG.damage_type = damtype
		GG.damage = GG.damage_tier[GG.tier]
		if(damtype == PALE_DAMAGE)
			GG.damage = round(GG.damage * 0.75)

/obj/projectile/ego_bullet/lcorp
	name = "bullet"
	damage = 4
	damage_type = RED_DAMAGE
	var/tier = 0
	var/list/damage_tier = list(11,20,30,55,90) //These numbers are just for reference

/obj/item/gun/ego_gun/city/lcorp/pistol
	name = "l-corp suppression pistol"
	desc = "A special pistol issued by L-Corp to those who cannot utilize E.G.O."
	icon_state = "pistol"
	inhand_icon_state = "pistol"
	special = "This weapon has pinpoint accuracy when dual wielded."
	ammo_type = /obj/item/ammo_casing/caseless/lcorp/pistol
	fire_delay = 10
	shotsleft = 7
	reloadtime = 2.1 SECONDS
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	dual_wield_spread = 0

/obj/item/ammo_casing/caseless/lcorp/pistol
	name = ".357 l-corp bullet casing"
	desc = "A casing."
	projectile_type = /obj/projectile/ego_bullet/lcorp/pistol

/obj/projectile/ego_bullet/lcorp/pistol
	name = "bullet"
	damage = 11
	damage_tier = list(11,20,30,55,90)

/obj/item/gun/ego_gun/city/lcorp/automatic_pistol
	name = "l-corp automatic pistol"
	desc = "A rapid-fire pistol issued by L-Corp to those who cannot utilize E.G.O."
	icon_state = "automatic"
	inhand_icon_state = "automatic"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/caseless/lcorp/automatic
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	shotsleft = 20
	reloadtime = 1.2 SECONDS
	autofire = 0.2 SECONDS

/obj/item/ammo_casing/caseless/lcorp/automatic
	name = "9mm l-corp bullet casing"
	desc = "A casing."
	projectile_type = /obj/projectile/ego_bullet/lcorp/automatic

/obj/projectile/ego_bullet/lcorp/automatic
	name = "bullet"
	damage = 2
	damage_tier = list(2,4,6,9,15)

///////////////////
//CLERK EQUIPMENT//
///////////////////

//Standard clerk pistol
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
	shotsleft = 10
	reloadtime = 0.5 SECONDS
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
