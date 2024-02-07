// Entire code ripped from Black Silence file tbh, don't murder me for theivery please
// Main gimmick is that each weapon deals a different damage, switching between stances is pretty fast and can Sheathe your current weapon for a special attack.
/obj/item/ego_weapon/city/pt //This shouldn't be obtainable, like at all
	name = "A Purple Tear"
	desc = "You really shouldn't be seeing this."
	icon_state = "Jeong"
	damtype = RED_DAMAGE

	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 120,
		TEMPERANCE_ATTRIBUTE = 120,
		JUSTICE_ATTRIBUTE = 120,
	)
	actions_types = list(/datum/action/item_action/miragestorm)
	var/special_cooldown
	var/special_cooldown_time = 30 SECONDS
	var/exchange_cooldown
	var/exchange_cooldown_time = 10 SECONDS
	var/mirage_charge
	var/mirage_charge_max = 40 //40 hits
	var/sheathed = FALSE
	var/boost = FALSE
	var/active = FALSE
	var/list/targets = list()

/obj/item/ego_weapon/city/pt/equipped(mob/user, slot) //here comes Chiemi's dark magicks
	. = ..()
	if(!user)
		return
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, PROC_REF(DoChecks))

/obj/item/ego_weapon/city/pt/Destroy(mob/user)
	UnregisterSignal(user, COMSIG_MOB_SHIFTCLICKON)
	return ..()

/obj/item/ego_weapon/city/pt/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_SHIFTCLICKON)

/obj/item/ego_weapon/city/pt/proc/DoChecks(mob/living/user, atom/target)
	if(!CanUseEgo(user))
		return
	if(user.get_active_held_item() != src)
		return
	if(special_cooldown > world.time)
		to_chat(user, span_warning("You can't sheathe your blade yet!"))
		return
	else
		if(target == user)
			return
	Special(user, target)

/obj/item/ego_weapon/city/pt/proc/Special(mob/living/user, atom/target)
	if(sheathed)
		to_chat(user, span_warning("Your blade is already sheathed!"))
		return
	sheathed = TRUE
	to_chat(user, span_notice("You prepare your blade."))

/obj/item/ego_weapon/city/pt/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	if(target.stat != DEAD)
		if(mirage_charge == mirage_charge_max)
			to_chat(user,span_userdanger("Your storm is ready.")) //If i cant figure out how to update the action icon, heres the notif
		mirage_charge += 1
	if(boost)
		boost = FALSE
		force = force/1.5

/datum/action/item_action/miragestorm/Trigger()
	var/obj/item/ego_weapon/city/pt/H = target
	var/obj/item/trimming = owner.get_active_held_item()
	if(H.mirage_charge > H.mirage_charge_max)
		if(istype(trimming, H))
			H.MirageStorm(owner)
		else
			to_chat(owner,span_warning("You must hold the weapon to unleash Mirage Storm!"))
			return
	else
		to_chat(owner,span_warning("You're not ready to unleash Mirage Storm!"))
		return

/obj/item/ego_weapon/city/pt/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	exchange_armaments(user)

// Radial menu
// currently causes a runtime everytime a switch occurs, killing myself
/obj/item/ego_weapon/city/pt/proc/exchange_armaments(mob/user)
	if(exchange_cooldown > world.time)
		to_chat(user, span_notice("You can't change stances yet."))
		return

	var/list/display_names = list()
	var/list/armament_icons = list()
	for(var/arms in typesof(/obj/item/ego_weapon/city/pt))
		var/obj/item/ego_weapon/city/pt/armstype = arms
		if(initial(armstype))
			if(initial(armstype.name) == "A Purple Tear")
				continue
			display_names[initial(armstype.name)] = armstype
			armament_icons += list(initial(armstype.name) = image(icon = initial(armstype.icon), icon_state = initial(armstype.icon_state)))

	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, src , armament_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(user))
		return

	var/picked = display_names[choice] // "This needs to be on a separate var as list member access is not allowed for new" -Chiemi
	var/obj/item/ego_weapon/city/pt/selected_armament = new picked(user.drop_location())

	if(selected_armament)
		var/obj/item/ego_weapon/city/pt/Y = selected_armament
		Y.special_cooldown = special_cooldown
		Y.mirage_charge = mirage_charge
		qdel(src)
		user.put_in_hands(Y)
		playsound(user, 'sound/weapons/purple_tear/change.ogg', 50, 1)
		new /obj/effect/temp_visual/turn_book(get_turf(user)) //Le Placeholder babyyyyy
		Y.exchange_cooldown = world.time + exchange_cooldown_time
		Y.sheathed = FALSE
		Y.boost = TRUE
		Y.force = Y.force*1.5 //This makes slash: 67.5, pierce: 135, blunt: 202.5, and guard 135

/obj/item/ego_weapon/city/pt/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

// Fast red damage with mega attack
/obj/item/ego_weapon/city/pt/slash
	name = "Vipers Blade" //All weapon names are placeholders at the moment, I don't really have better names
	desc = "An extremely sharp blade used by the Purple Tear."
	special = "SHIFT + CLICK to sheathe the blade and prepare a powered up strike." //Violet Blade Card
	icon_state = "ptslash"
	inhand_icon_state = "ptslash"
	force = 45
	attack_speed = 0.5
	damtype = RED_DAMAGE //Iori's quite physical with this stance

	attack_verb_continuous = list("slashes", "rends")
	attack_verb_simple = list("slash", "rend")
	hitsound = 'sound/weapons/purple_tear/slash1.ogg'

/obj/item/ego_weapon/city/pt/slash/Special(mob/living/user, atom/target)
	..()
	icon_state = "ptslash_sheath"

/obj/item/ego_weapon/city/pt/slash/attack(mob/living/target, mob/living/user)
	if(sheathed)
		force = force*2 //Power effects this die x2
		hitsound = 'sound/weapons/purple_tear/slash3.ogg'
	..()
	if(sheathed) //reset and apply cooldown
		sheathed = FALSE
		force = force/2
		icon_state = "ptslash"
		hitsound = 'sound/weapons/purple_tear/slash1.ogg'
		if(target.health <= 0 && ishuman(target)) //Get sliced in half motherfucker
			var/mob/living/carbon/human/H = target
			new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
			H.set_lying_angle(360)
			H.gib()
		special_cooldown = world.time + special_cooldown_time

// Normal white damage with a debuff attack
/obj/item/ego_weapon/city/pt/pierce
	name = "Serpents Fang"
	desc = "A deadly rapier used by the Purple Tear."
	special = "SHIFT + CLICK to sheathe the blade and prepare a devestating blow that weakens your enemy." //Laceration Card
	icon_state = "ptpierce"
	inhand_icon_state = "ptpierce"
	force = 90
	attack_speed = 1
	damtype = WHITE_DAMAGE //tbh white does not fit but also i don't think Iori should use pale, thats Blue Sicko's job

	attack_verb_continuous = list("pierces", "stabs")
	attack_verb_simple = list("pierce", "stab")
	hitsound = 'sound/weapons/purple_tear/stab1.ogg'

/obj/item/ego_weapon/city/pt/pierce/Special(mob/living/user, atom/target)
	..()
	icon_state = "ptpierce_sheath"

/obj/item/ego_weapon/city/pt/pierce/attack(mob/living/target, mob/living/user)
	if(sheathed)
		if(user != target)
			target.apply_status_effect(/datum/status_effect/pt_lacerate)
		attack_verb_continuous = "lacerates"
		attack_verb_simple = "lacerate"
		hitsound = 'sound/weapons/purple_tear/stab2.ogg'
	..()
	if(sheathed)
		sheathed = FALSE
		icon_state = "ptpierce"
		attack_verb_continuous = list("pierces", "stabs")
		attack_verb_simple = list("pierce", "stab")
		hitsound = 'sound/weapons/purple_tear/stab1.ogg'
		special_cooldown = world.time + special_cooldown_time

/datum/status_effect/pt_lacerate
	id = "purple tear lacerate"
	duration = 4 SECONDS //I mean double damage for free? window's gotta be mega small
	alert_type = /atom/movable/screen/alert/status_effect/pt_lacerate
	status_type = STATUS_EFFECT_UNIQUE

/atom/movable/screen/alert/status_effect/pt_lacerate
	name = "Lacerated"
	desc = "Is that... A hole in your chest? You feel awful..."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "lacerate" //Bit of a placeholder sprite, it works-ish so

/datum/status_effect/pt_lacerate/on_apply() //Notes: Future plan make this slow you down as well.
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner //If you're purple-ing on their tear you are evil
		L.physiology.red_mod *= 2
		L.physiology.white_mod *= 2
		L.physiology.black_mod *= 2
		L.physiology.pale_mod *= 2
		return
	var/mob/living/simple_animal/M = owner
	M.AddModifier(/datum/dc_change/lacerated)

/datum/status_effect/pt_lacerate/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(L, span_userdanger("The hole in your chest heals.")) //fluff text
		L.physiology.red_mod /= 2
		L.physiology.white_mod /= 2
		L.physiology.black_mod /= 2
		L.physiology.pale_mod /= 2
		return
	var/mob/living/simple_animal/M = owner
	M.RemoveModifier(/datum/dc_change/lacerated)

// Slow black damage with a buff attack
/obj/item/ego_weapon/city/pt/blunt
	name = "Serpentine Greatsword"
	desc = "A heavy greatsword used by the Purple Tear."
	special = "SHIFT + CLICK to sheathe the blade and prepare a defensive strike which will decrease all damage taken for a few seconds." //Duel Card
	icon_state = "ptblunt"
	inhand_icon_state = "ptblunt"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 135
	attack_speed = 1.5
	damtype = BLACK_DAMAGE //Blunt stance deals both high damage and stagger damage

	attack_verb_continuous = list("bludgeons", "smacks")
	attack_verb_simple = list("bludgeon", "smack")
	hitsound = 'sound/weapons/purple_tear/blunt1.ogg'

/obj/item/ego_weapon/city/pt/blunt/Special(mob/living/user, atom/target)
	..()
	icon_state = "ptblunt_sheath"

/obj/item/ego_weapon/city/pt/blunt/attack(mob/living/target, mob/living/user)
	if(sheathed)
		if(user != target)
			user.apply_status_effect(/datum/status_effect/pt_defense)
		hitsound = 'sound/weapons/purple_tear/blunt2.ogg'
	..()
	if(sheathed)
		sheathed = FALSE
		icon_state = "ptblunt"
		hitsound = 'sound/weapons/purple_tear/blunt1.ogg'
		special_cooldown = world.time + special_cooldown_time

/datum/status_effect/pt_defense
	id = "purple tear defense"
	duration = 5 SECONDS //Gotta make it count
	alert_type = /atom/movable/screen/alert/status_effect/pt_defense
	status_type = STATUS_EFFECT_UNIQUE

/atom/movable/screen/alert/status_effect/pt_defense
	name = "Serpents Poise"
	desc = "You're poised to take more damage, reducing all taken by half."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "pt_defense"

/datum/status_effect/pt_defense/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 2
		L.physiology.white_mod /= 2
		L.physiology.black_mod /= 2
		L.physiology.pale_mod /= 2
		return

/datum/status_effect/pt_defense/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(L, span_userdanger("You return to a normal posture."))
		L.physiology.red_mod *= 2
		L.physiology.white_mod *= 2
		L.physiology.black_mod *= 2
		L.physiology.pale_mod *= 2
		return

// Weak ahh red damage with a powerful block
//Currently special cooldown also applies to the block here, causes some jank when switching stances. Could fix with either an exception in special code or just reset cooldown when switiching to this stance
/obj/item/ego_weapon/city/pt/guard
	name = "Sheathed Serpentine Greatsword"
	desc = "A heavy greatsword used by the Purple Tear. The sheathe gives more defnese."
	special = "SHIFT + CLICK to parry an incoming attack. A successful parry will make your next hit in this stnace do 1.5x in True Damage." //ID weakpoint card
	icon_state = "ptguard"
	inhand_icon_state = "ptguard"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 90 //I mean its the block stance, you're not really supposed to attack here
	attack_speed = 1.5
	var/block = 0
	var/block_success
	var/parry_buff = FALSE
	var/buff_check = FALSE
	var/list/reductions = list(90, 90, 90, 90) //wild
	damtype = RED_DAMAGE

	attack_verb_continuous = list("smashes", "bashes")
	attack_verb_simple = list("smash", "bash")
	hitsound = 'sound/weapons/purple_tear/blunt2.ogg'

/obj/item/ego_weapon/city/pt/guard/Special(mob/living/user, atom/target) //Shoutout to Chiemi for making something completely incomprehensible
	if (block == 0)
		var/mob/living/carbon/human/shield_user = user
		if(shield_user.physiology.armor.bomb) //"We have NOTHING that should be modifying this, so I'm using it as an existant parry checker." - Ancientcoders
			to_chat(shield_user,span_warning("You're still off-balance!"))
			return FALSE
		for(var/obj/machinery/computer/abnormality/AC in range(1, shield_user))
			if(AC.datum_reference.working) // No blocking during work.
				to_chat(shield_user,span_notice("You cannot defend yourself from responsibility!"))
				return FALSE
		block = TRUE
		block_success = FALSE
		shield_user.physiology.armor = shield_user.physiology.armor.modifyRating(bomb = 1) //bomb defense must be over 0
		shield_user.physiology.red_mod *= max(0.001, (1 - ((reductions[1]) / 100)))
		shield_user.physiology.white_mod *= max(0.001, (1 - ((reductions[2]) / 100)))
		shield_user.physiology.black_mod *= max(0.001, (1 - ((reductions[3]) / 100)))
		shield_user.physiology.pale_mod *= max(0.001, (1 - ((reductions[4]) / 100)))
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, PROC_REF(AnnounceBlock))
		addtimer(CALLBACK(src, PROC_REF(DisableBlock), shield_user), 1 SECONDS)
		to_chat(user,span_userdanger("You attempt to parry the attack!"))
		return TRUE

/obj/item/ego_weapon/city/pt/guard/proc/DisableBlock(mob/living/carbon/human/user)
	user.physiology.armor = user.physiology.armor.modifyRating(bomb = -1)
	user.physiology.red_mod /= max(0.001, (1 - ((reductions[1]) / 100)))
	user.physiology.white_mod /= max(0.001, (1 - ((reductions[2]) / 100)))
	user.physiology.black_mod /= max(0.001, (1 - ((reductions[3]) / 100)))
	user.physiology.pale_mod /= max(0.001, (1 - ((reductions[4]) / 100)))
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	buff_check = FALSE
	addtimer(CALLBACK(src, PROC_REF(BlockCooldown), user), 3 SECONDS)
	if (!block_success)
		BlockFail(user)

/obj/item/ego_weapon/city/pt/guard/proc/BlockCooldown(mob/living/carbon/human/user)
	block = FALSE
	to_chat(user,span_nicegreen("You rearm your greatsword"))

/obj/item/ego_weapon/city/pt/guard/proc/BlockFail(mob/living/carbon/human/user)
	to_chat(user,span_warning("Your stance is widened."))
	force = 50
	addtimer(CALLBACK(src, PROC_REF(RemoveDebuff), user), 2 SECONDS)

/obj/item/ego_weapon/city/pt/guard/proc/RemoveDebuff(mob/living/carbon/human/user)
	to_chat(user,span_nicegreen("You recollect your stance."))
	force = 90

/obj/item/ego_weapon/city/pt/guard/proc/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	block_success = TRUE

	playsound(get_turf(src), 'sound/weapons/purple_tear/guard.ogg', 50, 0, 7)
	source.visible_message(span_userdanger("[source.real_name] parried the attack!"))
	if(!(buff_check))
		parry_buff = TRUE

/obj/item/ego_weapon/city/pt/guard/attack(mob/living/M, mob/living/user)
	if(parry_buff)
		force = force*1.5
		damtype = BRUTE
	..()
	if(parry_buff)
		force = force/1.5
		damtype = RED_DAMAGE
		parry_buff = FALSE

// Mirage Storm, fittingly stolen from blue sicko and black silence
/obj/item/ego_weapon/city/pt/proc/MirageStorm(mob/living/user)
	if(active || !CanUseEgo(user))
		return FALSE
	active = TRUE
	for(var/mob/living/L in livinginrange(8, user))
		if(L == src)
			continue
		if(faction_check(user.faction, L.faction))
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		targets += L
	if(!LAZYLEN(targets))
		to_chat(user, span_warning("There are no enemies nearby!")) //so you dont fuck up i guess
		active = FALSE
		return

	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP) //In order to prevent duping the item
	exchange_cooldown = world.time + 999 SECONDS
	special_cooldown = world.time + 999 SECONDS
	sheathed = FALSE

	//Vipers Blade
	playsound(user, 'sound/weapons/purple_tear/change.ogg', 50, 1)
	new /obj/effect/temp_visual/turn_book(get_turf(user))
	icon_state = "ptslash"
	inhand_icon_state = "ptslash"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	force = 45
	damtype = RED_DAMAGE

	attack_verb_continuous = list("slashes", "rends")
	attack_verb_simple = list("slash", "rend")
	hitsound = 'sound/weapons/purple_tear/slash2.ogg'
	sleep(3) //dramatic affect
	MirageAttack(user)

	//Serpentine Greatsword
	playsound(user, 'sound/weapons/purple_tear/change.ogg', 50, 1)
	new /obj/effect/temp_visual/turn_book(get_turf(user))
	icon_state = "ptblunt"
	inhand_icon_state = "ptblunt"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 135
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("bludgeons", "smacks")
	attack_verb_simple = list("bludgeon", "smack")
	hitsound = 'sound/weapons/purple_tear/blunt2.ogg'
	sleep(3)
	MirageAttack(user)

	//Serpents Fang
	playsound(user, 'sound/weapons/purple_tear/change.ogg', 50, 1)
	new /obj/effect/temp_visual/turn_book(get_turf(user))
	icon_state = "ptpierce"
	inhand_icon_state = "ptpierce"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	force = 90
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("pierces", "stabs")
	attack_verb_simple = list("pierce", "stab")
	hitsound = 'sound/weapons/purple_tear/stab2.ogg'
	sleep(3)
	MirageAttack(user)

	var/obj/item/ego_weapon/city/pt/slash/Y = new /obj/item/ego_weapon/city/pt/slash //currently defaults to slash stash... wagh
	qdel(src)
	Y.exchange_cooldown = 0
	Y.special_cooldown = 0
	Y.sheathed = FALSE
	Y.boost = TRUE
	Y.mirage_charge = 0
	user.put_in_hands(Y) //defaults to slash stance
	playsound(user, 'sound/weapons/purple_tear/change.ogg', 50, 1)
	new /obj/effect/temp_visual/turn_book(get_turf(user))
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP) //Can't drop it before it replaces
	active = FALSE
	user.apply_status_effect(/datum/status_effect/pt_defense) //Enjoy your spoils, rene- i mean agent
	targets = list()

/obj/item/ego_weapon/city/pt/proc/MirageAttack(mob/living/user)
	for(var/mob/living/L in targets)
		var/turf/prev_loc = get_turf(user)
		var/turf/tp_loc= get_step(L.loc, pick(GetSafeDir(get_turf(L))))
		user.forceMove(tp_loc)
		src.attack(L, user)
		prev_loc.Beam(tp_loc, "pt_ray", time=10)
		if(L.stat == DEAD) //So you don't bash a corpse in
			targets -= L
		sleep(4)

/datum/action/item_action/miragestorm
	name = "Mirage Storm"
	desc = "Unleash a flurry of blows upon any enemies around you utilizing the 3 offensive stances."
	icon_icon = 'icons/mob/actions/actions_ability.dmi'
	button_icon_state = "mirage"
