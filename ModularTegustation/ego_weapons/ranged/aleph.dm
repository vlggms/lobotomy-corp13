/obj/item/ego_weapon/ranged/star
	name = "sound of a star"
	desc = "The star shines brighter as our despair gathers. The weapon's small, evocative sphere fires a warm ray."
	icon_state = "star"
	inhand_icon_state = "star"
	special = "This weapon does an additional number of follow-up shots based on the wielder's SP.\nThis weapon also has IFF capabilities and pierces all hostile targets."

	force = 18
	damtype = WHITE_DAMAGE
	attack_speed = 0.5

	projectile_path = /obj/projectile/ego_bullet/star
	weapon_weight = WEAPON_MEDIUM
	spread = 0
	burst_size = 3
	burst_delay = 3
	fire_delay = 15
	max_shots = 60
	reloadtime = 0.25 SECONDS
	passive_reload = 10 SECONDS
	fire_sound = 'sound/weapons/ego/star.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 25
	ammo_name = "orb"
	ammo_name_plural = "orbs"
	projectile_name = "orb"
	projectile_name_plural = "orbs"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/star/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return
	burst_size = 1
	if(user.sanityhealth >= (user.maxSanity * 0.3))
		burst_size = 2
	if(user.sanityhealth >= (user.maxSanity * 0.6))
		burst_size = 3
	return ..()

/obj/item/ego_weapon/ranged/star/suicide_act(mob/living/carbon/user)
	. = ..()
	user.visible_message(span_suicide("[user]'s legs distort and face opposite directions, as [user.p_their()] torso seems to pulsate! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 50, FALSE, 40, falloff_distance = 10)
	user.unequip_everything()
	QDEL_IN(user, 1)
	return MANUAL_SUICIDE

/obj/item/ego_weapon/ranged/adoration
	name = "adoration"
	desc = "A big mug filled with mysterious slime that never runs out. \
	It’s the byproduct of some horrid experiment in a certain laboratory that eventually failed."
	icon_state = "adoration"
	inhand_icon_state = "adoration"

	force = 40
	damtype = BLACK_DAMAGE

	projectile_path = /obj/projectile/ego_bullet/adoration
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 10
	pellets = 3
	variance = 20
	max_shots = 30
	passive_reload = 8 SECONDS
	reloadtime = 5

	fire_sound = 'sound/effects/attackblob.ogg'
	fire_sound_volume = 50
	projectile_name = "slime shot"
	projectile_name_plural = "slime shots"
	ammo_name = "slime"
	ammo_name_plural = "slime"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	alternate_reload_time = 5
	alternate_fire_name = "Infectious Love"
	alternate_projectile_path = /obj/projectile/ego_bullet/adoration/super
	alternate_info = "This weapon fires a large, slow moving glob of goo that costs twice as much ammo to fire and reqires the weapon to be charged up to fire. \
	The glob of goo deals damage in an area while applying a DOT effect."
	alternate_reload_type = RANGEDEGO_ALTERNATEFIRE_RELOADTYPE_SHARED_MAGAZINE
	alternate_fire_sound = 'sound/effects/attackblob.ogg'
	alternate_pellets = 1
	alternate_variance  = 0
	alternate_toggle_sound = 'sound/effects/attackblob.ogg'
	alternate_toggle_sound_volume = 50
	alternate_toggle_enabled_message = span_notice("You focus, changing for a charge up shot.")
	alternate_toggle_disabled_message = span_notice(">You focus, changing for a spread shot.")

/obj/item/ego_weapon/ranged/adoration/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	ammo_per_shot = 2
	chargetime = 5

/obj/item/ego_weapon/ranged/adoration/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	ammo_per_shot = 1
	chargetime = 0

/*/obj/item/ego_weapon/ranged/adoration/attack_self(mob/user)
	. = ..()
	switch(mode)
		if(SHOT_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for a DOT blast</span>")
			projectile_path = /obj/projectile/ego_bullet/adoration/dot
			pellets = 1
			variance = 0
			mode = DOT_MODE
			return
		if(DOT_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for an AOE blast</span>")
			projectile_path = /obj/projectile/ego_bullet/adoration/aoe
			mode = AOE_MODE
			return
		if(AOE_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for a shotgun blast</span>")
			projectile_path = /obj/projectile/ego_bullet/adoration
			pellets = initial(pellets)
			variance = initial(variance)
			mode = SHOT_MODE
			return
*/

/obj/item/ego_weapon/ranged/nihil
	name = "nihil"
	desc = "Having decided to trust its own intuition, the jester spake the names of everyone it had met on that path with each step it took."
	icon_state = "nihil"
	inhand_icon_state = "nihil"
	force = 28
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/nihil
	weapon_weight = WEAPON_HEAVY
	pellets = 4
	variance = 20
	fire_sound = 'sound/weapons/fixer/generic/energy1.ogg'
	fire_sound_volume = 50
	fire_delay = 10
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	var/wrath
	var/despair
	var/greed
	var/hate
	var/list/powers = list("hatred", "despair", "greed", "wrath")

/obj/item/ego_weapon/ranged/nihil/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!istype(I, /obj/item/nihil))
		return

	if(powers[1] == "hatred" && istype(I, /obj/item/nihil/heart))
		powers[1] = "hearts"
		IncreaseAttributes(user, powers[1])
		qdel(I)
	else if(powers[2] == "despair" && istype(I, /obj/item/nihil/spade))
		powers[2] = "spades"
		IncreaseAttributes(user, powers[2])
		qdel(I)
	else if(powers[3] == "greed" && istype(I, /obj/item/nihil/diamond))
		powers[3] = "diamonds"
		IncreaseAttributes(user, powers[3])
		qdel(I)
	else if(powers[4] == "wrath" && istype(I, /obj/item/nihil/club))
		powers[4]= "clubs"
		IncreaseAttributes(user, powers[4])
		qdel(I)
	else
		to_chat(user,"<span class='warning'>You have already used this upgrade!</span>")

/obj/item/ego_weapon/ranged/nihil/proc/IncreaseAttributes(user, current_suit)
	for(var/atr in attribute_requirements)
		if(atr == TEMPERANCE_ATTRIBUTE)
			attribute_requirements[atr] += 5
		else
			attribute_requirements[atr] += 10
	to_chat(user,"<span class='warning'>The requirements to use [src] have increased!</span>")

	switch(current_suit)
		if("hearts")
			to_chat(user,"<span class='nicegreen'>The ace of [current_suit] has removed friendly fire from [src]!</span>")

		if("spades")
			to_chat(user,"<span class='nicegreen'>The ace of [current_suit] granted [src] the capability of dealing pale damage!</span>")

		if("diamonds")
			to_chat(user,"<span class='nicegreen'>The ace of [current_suit] granted [src] the capability of dealing red damage!</span>")

		if("clubs")
			to_chat(user,"<span class='nicegreen'>The ace of [current_suit] granted [src] the capability of dealing black damage!</span>")
	to_chat(user,"<span class='nicegreen'>The ace of [current_suit] fades away as it makes [src] become even more powerful!</span>")
	return

/obj/item/ego_weapon/ranged/pink
	name = "pink"
	desc = "Pink is considered to be the color of warmth and love, but is that true? \
			Can guns really bring peace and love?"
	icon_state = "pink"
	inhand_icon_state = "pink"
	special = "This weapon has a scope, and fires projectiles with zero travel time and IFF detection. Damage dealt is increased when hitting targets further away. Middle mouse button click/alt click to zoom in that direction."
	force = 40
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/pink
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/abnormalities/armyinblack/pink.ogg'
	fire_delay = 20
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	max_shots = 5
	reloadtime = 2.1 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/mob/current_holder

/obj/item/ego_weapon/ranged/pink/MiddleClickAction(atom/target, mob/living/user)
	. = ..()
	if(.)
		return
	zoom(user, get_cardinal_dir(user, target))

/obj/item/ego_weapon/ranged/pink/zoom(mob/living/user, direc, forced_zoom)
	if(!CanUseEgo(user))
		return
	if(!user || !user.client)
		return
	if(isnull(forced_zoom))
		zoomed = !zoomed
	else
		zoomed = forced_zoom
	if(src != user.get_active_held_item())
		if(!zoomed)
			UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
			user.client.view_size.zoomIn()
		return
	if(!zoomed)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		user.client.view_size.zoomIn()
	else
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(rotate))
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(UserMoved))
		user.client.view_size.zoomOut(zoom_out_amt, zoom_amt, direc)
	return zoomed

/obj/item/ego_weapon/ranged/pink/proc/UserMoved(mob/living/user, direc)
	SIGNAL_HANDLER
	zoom(user)//disengage

/obj/item/ego_weapon/ranged/pink/Destroy(mob/user)//FIXME: causes component runtimes
	if(!user)
		return ..()
	if(zoomed)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(current_holder, COMSIG_ATOM_DIR_CHANGE)
		current_holder = null
		return ..()

/obj/item/ego_weapon/ranged/pink/dropped(mob/user)
	. = ..()
	if(!user)
		return
	if(zoomed)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(current_holder, COMSIG_ATOM_DIR_CHANGE)
		current_holder = null

/obj/item/ego_weapon/ranged/arcadia
	name = "Et in Arcadia Ego"
	desc = "With the waxing of the sun, humanity wanes."
	icon_state = "arcadia"
	inhand_icon_state = "arcadia"
	special = "Use in hand to load bullets."
	force = 40
	projectile_path = /obj/projectile/ego_bullet/arcadia
	weapon_weight = WEAPON_HEAVY
	spread = 5
	recoil = 1.5
	fire_sound = 'sound/weapons/gun/rifle/shot_atelier.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 30
	fire_delay = 7

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)


	max_shots = 16	//Based off a henry .44
	reloadtime = 0.5 SECONDS
	ammo_on_reload = 1

/obj/item/ego_weapon/ranged/arcadia/judge
	name = "Judge"
	desc = "You will be judged; as I have."
	icon_state = "judge"
	inhand_icon_state = "judge"
	force = 40
	damtype = WHITE_DAMAGE
	weapon_weight = WEAPON_MEDIUM	//Cannot be dual wielded
	recoil = 2
	fire_sound_volume = 30
	fire_delay = 3	//FAN THE HAMMER

	max_shots = 6	//Based off a colt Single Action Navy
	reloadtime = 1 SECONDS


/obj/item/ego_weapon/ranged/havana
	name = "havana"
	desc = "Within it's simple design lies a lot of struggle"
	icon_state = "havana"
	inhand_icon_state = "havana"
	force = 30
	damtype = PALE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hookah
	weapon_weight = WEAPON_HEAVY
	spread = 20
	fire_sound = 'sound/effects/burn.ogg'
	autofire = 0.04 SECONDS
	fire_sound_volume = 5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
	)
	reloadtime = 3 SECONDS
	max_shots = 150

//Just a funny gold soda pistol. It was originally meant to just be a golden meme weapon, now it is the only pale gun, lol
/obj/item/ego_weapon/ranged/pistol/executive
	name = "executive"
	desc = "A pistol painted in black with a gold finish. Whenever this EGO is used, a faint scent of fillet mignon wafts through the air."
	icon_state = "executive"
	inhand_icon_state = "executive"
	special = "This weapon has pinpoint accuracy. \nThe final bullet of the clip does heavy damage. When the final bullet kills something, this weapon will automatically reload."
	force = 15
	damtype = PALE_DAMAGE
	burst_size = 1
	fire_delay = 5
	max_shots = 12
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	spread = 0
	variance = 0
	dual_wield_spread = 0
	projectile_path = /obj/projectile/ego_bullet/ego_executive
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
	)

/obj/item/ego_weapon/ranged/pistol/executive/proc/AutoReload(mob/user)
	if(shotsleft == max_shots)
		return
	playsound(src, 'sound/weapons/ego/executive_reload.ogg', 70, FALSE)
	shotsleft = max_shots
	to_chat(user, span_nicegreen("A new magazine materialized within [src]!"))
	// Might as well reload the other gun
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/pistol/executive/G in H.held_items)
			if(G == src || G.shotsleft == G.max_shots)
				continue
			G.shotsleft = G.max_shots
			playsound(G, 'sound/weapons/ego/executive_reload.ogg', 70, FALSE)
			to_chat(user, span_nicegreen("A new magazine materialized within the other [G]!"))

/obj/item/ego_weapon/ranged/pistol/executive/afterattack(atom/target, mob/user)
	if(shotsleft == 1)
		projectile_path = /obj/projectile/ego_bullet/ego_executive/kill_shot
		fire_sound = 'sound/weapons/ego/executive_shot.ogg'
	. = ..()
	if(!shotsleft)
		projectile_path = initial(projectile_path)
		fire_sound = initial(fire_sound)
		update_projectile_examine()
