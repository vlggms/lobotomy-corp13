#define SHOT_MODE 0
#define DOT_MODE 1
#define AOE_MODE 2

/obj/item/gun/ego_gun/star
	name = "sound of a star"
	desc = "The star shines brighter as our despair gathers. The weapon's small, evocative sphere fires a warm ray."
	icon_state = "star"
	inhand_icon_state = "star"
	special = "This gun scales with remaining SP."
	ammo_type = /obj/item/ammo_casing/caseless/ego_star
	weapon_weight = WEAPON_HEAVY
	spread = 5
	fire_sound = 'sound/weapons/ego/star.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 25
	autofire = 0.25 SECONDS
	shotsleft = 333
	reloadtime = 2.1 SECONDS

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/gun/ego_gun/star/suicide_act(mob/living/carbon/user)
	. = ..()
	user.visible_message(span_suicide("[user]'s legs distort and face opposite directions, as [user.p_their()] torso seems to pulsate! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 50, FALSE, 40, falloff_distance = 10)
	user.unequip_everything()
	QDEL_IN(user, 1)
	return MANUAL_SUICIDE

/obj/item/gun/ego_gun/adoration
	name = "adoration"
	desc = "A big mug filled with mysterious slime that never runs out. \
	It’s the byproduct of some horrid experiment in a certain laboratory that eventually failed."
	icon_state = "adoration"
	inhand_icon_state = "adoration"
	special = "Use in hand to swap between AOE, DOT and shotgun modes."
	ammo_type = /obj/item/ammo_casing/caseless/ego_adoration
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/effects/attackblob.ogg'
	fire_sound_volume = 50
	fire_delay = 10

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	var/mode = 0

/obj/item/gun/ego_gun/adoration/attack_self(mob/user)
	..()
	switch(mode)
		if(SHOT_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for a DOT blast</span>")
			ammo_type = /obj/item/ammo_casing/caseless/ego_adoration/dot
			mode = DOT_MODE
			return
		if(DOT_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for an AOE blast</span>")
			ammo_type = /obj/item/ammo_casing/caseless/ego_adoration/aoe
			mode = AOE_MODE
			return
		if(AOE_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for a shotgun blast</span>")
			ammo_type = /obj/item/ammo_casing/caseless/ego_adoration
			mode = SHOT_MODE
			return

#undef SHOT_MODE
#undef DOT_MODE
#undef AOE_MODE

/obj/item/gun/ego_gun/nihil
	name = "nihil"
	desc = "Having decided to trust its own intuition, the jester spake the names of everyone it had met on that path with each step it took."
	icon_state = "nihil"
	inhand_icon_state = "nihil"
	ammo_type = /obj/item/ammo_casing/caseless/ego_nihil
	weapon_weight = WEAPON_HEAVY
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

/obj/item/gun/ego_gun/nihil/attackby(obj/item/I, mob/living/user, params)
	..()
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

/obj/item/gun/ego_gun/nihil/proc/IncreaseAttributes(user, current_suit)
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

/obj/item/gun/ego_gun/pink
	name = "pink"
	desc = "Pink is considered to be the color of warmth and love, but is that true? \
			Can guns really bring peace and love?"
	icon_state = "pink"
	inhand_icon_state = "pink"
	special = "This weapon has a scope, and fires projectiles with zero travel time. Damage dealt is increased when hitting targets further away. Middle mouse button click/alt click to zoom in that direction."
	ammo_type = /obj/item/ammo_casing/caseless/pink
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/abnormalities/armyinblack/pink.ogg'
	fire_delay = 9
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	shotsleft = 5
	reloadtime = 2.1 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/mob/current_holder

/obj/item/gun/ego_gun/pink/MiddleClickAction(atom/target, mob/living/user)
	. = ..()
	if(.)
		return
	zoom(user, get_cardinal_dir(user, target))

/obj/item/gun/ego_gun/pink/zoom(mob/living/user, direc, forced_zoom)
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

/obj/item/gun/ego_gun/pink/proc/UserMoved(mob/living/user, direc)
	SIGNAL_HANDLER
	zoom(user)//disengage

/obj/item/gun/ego_gun/pink/Destroy(mob/user)//FIXME: causes component runtimes
	if(!user)
		return ..()
	if(zoomed)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(current_holder, COMSIG_ATOM_DIR_CHANGE)
		current_holder = null
		return ..()

/obj/item/gun/ego_gun/pink/dropped(mob/user)
	. = ..()
	if(!user)
		return
	if(zoomed)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(current_holder, COMSIG_ATOM_DIR_CHANGE)
		current_holder = null

/obj/item/gun/ego_gun/arcadia
	name = "Et in Arcadia Ego"
	desc = "With the waxing of the sun, humanity wanes."
	icon_state = "arcadia"
	inhand_icon_state = "arcadia"
	special = "Use in hand to load bullets."
	ammo_type = /obj/item/ammo_casing/caseless/arcadia
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


	shotsleft = 16	//Based off a henry .44
	reloadtime = 0.5 SECONDS

/obj/item/gun/ego_gun/arcadia/reload_ego(mob/user)
	if(shotsleft == initial(shotsleft))
		return
	is_reloading = TRUE
	to_chat(user,"<span class='notice'>You start loading a bullet.</span>")
	if(do_after(user, reloadtime, src)) //gotta reload
		playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
		shotsleft +=1
	is_reloading = FALSE

/obj/item/gun/ego_gun/arcadia/judge
	name = "Judge"
	desc = "You will be judged; as I have."
	icon_state = "judge"
	inhand_icon_state = "judge"
	weapon_weight = WEAPON_MEDIUM	//Cannot be dual wielded
	recoil = 2
	fire_sound_volume = 30
	fire_delay = 12


	shotsleft = 6	//Based off a colt Single Action Navy
	reloadtime = 0.8 SECONDS
