/obj/item/ego_weapon/rabbit_blade
	name = "high-frequency combat blade"
	desc = "A high-frequency combat blade made for use against abnormalities and other threats in Lobotomy Corporation and the outskirts."
	icon_state = "rabbitblade"
	inhand_icon_state = "rabbit_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 35
	throwforce = 24
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stabs", "slices")
	attack_verb_simple = list("stab", "slice")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 55,
							PRUDENCE_ATTRIBUTE = 55,
							TEMPERANCE_ATTRIBUTE = 55,
							JUSTICE_ATTRIBUTE = 55
							)

/obj/item/ego_weapon/rabbit_blade/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
		if(WHITE_DAMAGE)
			damtype = BLACK_DAMAGE
			force = 30
		if(BLACK_DAMAGE)
			damtype = PALE_DAMAGE
			force = 25
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
			force = 35
	armortype = damtype // TODO: In future, armortype should be gone entirely
	to_chat(user, "<span class='notice'>\The [src] will now deal [damtype] damage.</span>")
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

///Zwei Equipment///

/obj/item/ego_weapon/zwei_blade
	name = "zwei claymore"
	desc = "The weapon of a professional fixer, protecting the city one neighborhood at a time."
	icon_state = "claymore"
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 50,
							PRUDENCE_ATTRIBUTE = 50,
							TEMPERANCE_ATTRIBUTE = 50,
							JUSTICE_ATTRIBUTE = 50
							)
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 40
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	block_chance = 50
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF

/obj/item/ego_weapon/zwei_blade/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 40, 105)

/obj/item/ego_weapon/zwei_blade/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is falling on [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return(BRUTELOSS)

//////////////////////////////Hardhead Fireaxe//////////////////////////////

/obj/item/ego_weapon/fireaxe  // I took the fireaxe code, for the people...
	icon_state = "fireaxe0"
	lefthand_file = 'icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/axes_righthand.dmi'
	name = "drumhead axe"
	desc = "When the company was demolished, a tribunal was held. Few were spared, many axes dulled."
	force = 5
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	var/faction_bonus_force = 15
	var/nemesis_factions = list("green_ordeal") // Deal more damage to Green Ordeal, wrecking crew style!
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("attacks", "chops", "cleaves", "tears", "lacerates", "cuts")
	attack_verb_simple = list("attack", "chop", "cleave", "tear", "lacerate", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	wound_bonus = -15
	bare_wound_bonus = 20
	var/wielded = FALSE // track wielded status on item

/obj/item/ego_weapon/fireaxe/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/ego_weapon/fireaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 80, 0 , hitsound) //Axes are not good for getting the most meat.
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=20, icon_wielded="fireaxe1")

/// triggered on wield of two handed item
/obj/item/ego_weapon/fireaxe/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/ego_weapon/fireaxe/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/ego_weapon/fireaxe/update_icon_state()
	icon_state = "fireaxe0"

/obj/item/ego_weapon/fireaxe/attack(mob/living/target, mob/living/carbon/human/user)
	var/nemesis_faction = FALSE
	if(LAZYLEN(nemesis_factions))
		for(var/F in target.faction)
			if(F in nemesis_factions)
				nemesis_faction = TRUE
				force += faction_bonus_force
				break
	. = ..()
	if(nemesis_faction)
		playsound(target.loc,'sound/effects/wounds/pierce1.ogg', rand(30,50), TRUE) // Play funny sound to signify additional damage.
		force -= faction_bonus_force

/obj/item/ego_weapon/fireaxe/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] axes [user.p_them()]self from head to toe! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/ego_weapon/fireaxe/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(wielded) //destroys windows and grilles in one hit
		if(istype(A, /obj/structure/window) || istype(A, /obj/structure/grille))
			var/obj/structure/W = A
			W.obj_destruction("fireaxe")

//////////////////////////////Hardhead Wrench//////////////////////////////

/obj/item/ego_weapon/wrench
	name = "left hand monkey wrench"
	desc = "An old wrench with common uses. Can be found in your hand."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	worn_icon_state = "wrench"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 10
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	var/faction_bonus_force = 15
	var/nemesis_factions = list("green_ordeal") // UNLOCK YOUR COVER AND STATE LAWS!
	throwforce = 12
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/ratchet.ogg'
	custom_materials = list(/datum/material/iron=150)
	drop_sound = 'sound/items/handling/wrench_drop.ogg'
	pickup_sound =  'sound/items/handling/wrench_pickup.ogg'

	attack_verb_continuous = list("bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "whack")
	tool_behaviour = TOOL_WRENCH
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

/obj/item/ego_weapon/wrench/attack(mob/living/target, mob/living/carbon/human/user)
	var/nemesis_faction = FALSE
	if(LAZYLEN(nemesis_factions))
		for(var/F in target.faction)
			if(F in nemesis_factions)
				nemesis_faction = TRUE
				force += faction_bonus_force
				break
	. = ..()
	if(nemesis_faction)
		playsound(target.loc,'sound/effects/wounds/pierce1.ogg', rand(30,50), TRUE) // Play funny sound to signify additional damage.
		force -= faction_bonus_force

/obj/item/ego_weapon/wrench/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is tightening their own bolts with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

//////////////////////////////Hardhead Crowbar//////////////////////////////

/obj/item/ego_weapon/crowbar
	name = "hardened crowbar"
	desc = "A small crowbar, useful for fixing a situation, usually by breaking the problem with furious revolution."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/crowbar.ogg'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 10
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	var/faction_bonus_force = 15
	var/nemesis_factions = list("green_ordeal") // UNLOCK YOUR COVER AND STATE LAWS!
	throwforce = 12
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("attacks", "bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("attack", "bash", "batter", "bludgeon", "whack")
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	var/force_opens = FALSE

/obj/item/ego_weapon/crowbar/attack(mob/living/target, mob/living/carbon/human/user)
	var/nemesis_faction = FALSE
	if(LAZYLEN(nemesis_factions))
		for(var/F in target.faction)
			if(F in nemesis_factions)
				nemesis_faction = TRUE
				force += faction_bonus_force
				break
	. = ..()
	if(nemesis_faction)
		playsound(target.loc,'sound/effects/wounds/pierce1.ogg', rand(30,50), TRUE) // Play funny sound to signify additional damage.
		force -= faction_bonus_force

/obj/item/ego_weapon/crowbar/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is claiming worker's compensation with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

//////////////////////////////Hardhead Shotgun//////////////////////////////

/obj/item/gun/ego_gun/hardened_shotgun
	name = "appropiated shotgun"
	desc = "Company guards hesitated to fire bullets coming out of their own pay, and quickly abandoned both guns and duty."
	worn_icon_state = null
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	icon_state = "shotgun"
	inhand_icon_state = "shotgun"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	ammo_type = /obj/item/ammo_casing/caseless/hardhead_shotgun
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	recoil = 1		//Shakes your screen
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BACK

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 30,
							JUSTICE_ATTRIBUTE = 40
							)

//////////////////////////////Hardhead Clipboard//////////////////////////////

/obj/item/ego_weapon/clipboard
	name = "combat clipboard"
	desc = "When you need to smack sense into hardheaded employees, show them the deadline, with your clipboard."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	inhand_icon_state = "clipboard"
	worn_icon_state = "clipboard"
	force = 40
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/paper/toppaper	//The topmost piece of paper.
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FLAMMABLE

/obj/item/ego_weapon/clipboard/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins putting [user.p_their()] head into the clip of \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS//the clipboard's clip is very strong. industrial duty. can kill a man easily.

/obj/item/ego_weapon/clipboard/Initialize()
	update_icon()
	. = ..()

/obj/item/ego_weapon/clipboard/Destroy()
	QDEL_NULL(haspen)
	QDEL_NULL(toppaper)	//let movable/Destroy handle the rest
	return ..()

/obj/item/ego_weapon/clipboard/update_overlays()
	. = ..()
	if(toppaper)
		. += toppaper.icon_state
		. += toppaper.overlays
	if(haspen)
		. += "clipboard_pen"
	. += "clipboard_over"

/obj/item/ego_weapon/clipboard/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/paper))
		if(!user.transferItemToLoc(W, src))
			return
		toppaper = W
		to_chat(user, "<span class='notice'>You clip the paper onto \the [src].</span>")
		update_icon()
	else if(toppaper)
		toppaper.attackby(user.get_active_held_item(), user)
		update_icon()


/obj/item/ego_weapon/clipboard/attack_self(mob/user)
	var/dat = "<title>Clipboard</title>"
	if(haspen)
		dat += "<A href='?src=[REF(src)];pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='?src=[REF(src)];addpen=1'>Add Pen</A><BR><HR>"

	//The topmost paper. You can't organise contents directly in byond, so this is what we're stuck with.	-Pete
	if(toppaper)
		var/obj/item/paper/P = toppaper
		dat += "<A href='?src=[REF(src)];write=[REF(P)]'>Write</A> <A href='?src=[REF(src)];remove=[REF(P)]'>Remove</A> - <A href='?src=[REF(src)];read=[REF(P)]'>[P.name]</A><BR><HR>"

		for(P in src)
			if(P == toppaper)
				continue
			dat += "<A href='?src=[REF(src)];write=[REF(P)]'>Write</A> <A href='?src=[REF(src)];remove=[REF(P)]'>Remove</A> <A href='?src=[REF(src)];top=[REF(P)]'>Move to top</A> - <A href='?src=[REF(src)];read=[REF(P)]'>[P.name]</A><BR>"
	user << browse(dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)


/obj/item/ego_weapon/clipboard/Topic(href, href_list)
	..()
	if(usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(usr.contents.Find(src))

		if(href_list["pen"])
			if(haspen)
				haspen.forceMove(usr.loc)
				usr.put_in_hands(haspen)
				haspen = null

		if(href_list["addpen"])
			if(!haspen)
				var/obj/item/held = usr.get_active_held_item()
				if(istype(held, /obj/item/pen))
					var/obj/item/pen/W = held
					if(!usr.transferItemToLoc(W, src))
						return
					haspen = W
					to_chat(usr, "<span class='notice'>You slot [W] into [src].</span>")

		if(href_list["write"])
			var/obj/item/P = locate(href_list["write"]) in src
			if(istype(P))
				if(usr.get_active_held_item())
					P.attackby(usr.get_active_held_item(), usr)

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"]) in src
			if(istype(P))
				P.forceMove(usr.loc)
				usr.put_in_hands(P)
				if(P == toppaper)
					toppaper = null
					var/obj/item/paper/newtop = locate(/obj/item/paper) in src
					if(newtop && (newtop != P))
						toppaper = newtop
					else
						toppaper = null

		if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"]) in src
			if(istype(P))
				usr.examinate(P)

		if(href_list["top"])
			var/obj/item/P = locate(href_list["top"]) in src
			if(istype(P))
				toppaper = P
				to_chat(usr, "<span class='notice'>You move [P.name] to the top.</span>")

		//Update everything
		attack_self(usr)
		update_icon()
