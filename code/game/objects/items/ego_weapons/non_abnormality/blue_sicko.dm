// Grade 1 / Colored Fixer
#define MODE_ADD 1
#define MODE_SUBTRACT -2
#define STATUS_EFFECT_VIBRATION /datum/status_effect/stacking/vibration
/obj/item/ego_weapon/city/reverberation
	name = "Elogio Bianco"
	desc = "This Scythe constantly emits a low hum, transfered to things you strike with it. \
		If your Vibration matches the target's, you resonate. This deals Pale Damage instead of White Damage and deals more of it."
	icon_state = "reverberation"
	inhand_icon_state = "reverberation"
	force = 60 // 85 DPS w/o Vibration, 128 with.
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_speed = 0.7
	hitsound = 'sound/weapons/fixer/reverb_normal.ogg'
	attack_verb_continuous = list("slashes", "cuts",)
	attack_verb_simple = list("slash", "cuts")
	run_item_attack_animation = FALSE
	actions_types = list(/datum/action/item_action/charging/tempestuous, /datum/action/item_action/charging/grandfinale)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 120,
		TEMPERANCE_ATTRIBUTE = 120,
		JUSTICE_ATTRIBUTE = 120
	)
	var/mode = MODE_ADD
	var/vibration = 4
	var/active = FALSE
	var/list/intrusive_thoughts = list(
		"Can’t you feel this tremor…?",
		"Could there be an overture with a rhythm more beautiful than this?",
		"We’ll complete our own score…",
		"One that can be played indefinitely, even if there seems to be an end!",
		"So you will take the honor of remembering the first note of this everlasting performance…"
	)

/obj/item/ego_weapon/city/reverberation/Initialize()
	. = ..()
	vibration = rand(4,6)
	addtimer(CALLBACK(src, .proc/VibrationChange))

/obj/item/ego_weapon/city/reverberation/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/city/reverberation/ui_action_click(mob/living/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/charging/tempestuous))
		TempestuousDanza(user)
	else
		GrandFinale(user)
	return

/obj/item/ego_weapon/city/reverberation/item_action_slot_check(slot, mob/living/user)
	if(slot == ITEM_SLOT_HANDS)
		return TRUE
	return FALSE

/obj/item/ego_weapon/city/reverberation/attack_self(mob/living/user)
	. = ..()
	if(mode == MODE_ADD)
		mode = MODE_SUBTRACT
	else
		mode = MODE_ADD
	to_chat(user, "<span class='notice'>You will now [mode == MODE_ADD ? "increase" : "decrease"] your target's vibration by [mode == MODE_ADD ? MODE_ADD : MODE_SUBTRACT * -1].")
	desc = initial(desc) + "\nYour attacks will [mode == MODE_ADD ? "increase" : "decrease"] your target's vibration by [mode == MODE_ADD ? MODE_ADD : MODE_SUBTRACT * -1]."

/obj/item/ego_weapon/city/reverberation/attack(mob/living/target, mob/living/user)
	var/datum/status_effect/stacking/S = target.has_status_effect(STATUS_EFFECT_VIBRATION)
	var/temp_sound = hitsound
	var/obj/effect/temp_visual/reverb_slash/VFX
	if(S)
		if(S.stacks == vibration)
			damtype = PALE_DAMAGE
			armortype = PALE_DAMAGE
			force = 90
			hitsound = "sound/weapons/fixer/reverb_strong[rand(1, 2)].ogg"
			VFX = new /obj/effect/temp_visual/reverb_slash/vertical(get_turf(user))
	if(!VFX)
		if(user.get_held_index_of_item(src) != 1)
			VFX = new /obj/effect/temp_visual/reverb_slash/right(get_turf(user))
		else
			VFX = new(get_turf(user))
	var/target_dir = get_cardinal_dir(user, target)
	VFX.dir = target_dir
	if(dir == NORTH)
		VFX.layer = user.layer - 0.1 // Below them, but sometimes above the target.
	. = ..()
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	force = 60
	hitsound = temp_sound
	if(!.)
		return
	if(S)
		if(S.stacks == vibration)
			if(prob(8))
				to_chat(user, "<span class='blueteamradio'>[pick(intrusive_thoughts)]</span>", MESSAGE_TYPE_LOCALCHAT)
			if(target.stat != DEAD && target != user)
				for(var/datum/action/item_action/charging/CA in actions)
					CA.charge += 1
		S.add_stacks(mode)
	else
		if(mode == MODE_ADD)
			S = target.apply_status_effect(STATUS_EFFECT_VIBRATION, mode)
	if(!S)
		to_chat(user, "<span class='notice'>Your blade emits a dull hum as your target ceases to vibrate.</span>", MESSAGE_TYPE_INFO)
		return
	if(vibration > S.stacks)
		to_chat(user, "<span class='notice'>Your blade emits a high pitched whine.</span>", MESSAGE_TYPE_INFO)
	else if(vibration < S.stacks)
		to_chat(user, "<span class='notice'>Your blade hums in a low tone.</span>", MESSAGE_TYPE_INFO)


/obj/item/ego_weapon/city/reverberation/proc/VibrationChange()
	addtimer(CALLBACK(src, .proc/VibrationChange), 10 SECONDS)
	if(active)
		return
	var/list/vibes = list(4, 5, 6)
	vibes -= vibration
	vibration = pick(vibes)
	update_icon()

/obj/item/ego_weapon/city/reverberation/update_overlays()
	. = ..()
	var/mob/living/L = loc
	if(istype(L))
		if(L.get_inactive_held_item() == src || L.get_active_held_item() == src)
			. += mutable_appearance('icons/effects/number_overlays.dmi', "b[vibration]")

/obj/item/ego_weapon/city/reverberation/equipped(mob/user, slot, initial)
	. = ..()
	update_icon()

/obj/item/ego_weapon/city/reverberation/dropped(mob/user, silent)
	. = ..()
	update_icon()

/obj/item/ego_weapon/city/reverberation/proc/TempestuousDanza(mob/living/user)
	set waitfor = FALSE
	if(active || !CanUseEgo(user))
		return FALSE
	active = TRUE
	to_chat(user, "<span class='blueteamradio'>We will shape this world together.</span>", MESSAGE_TYPE_LOCALCHAT)
	for(var/mob/living/L in livinginrange(8, user))
		if(L == src)
			continue
		if(faction_check(user.faction, L.faction))
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		var/turf/prev_loc = get_turf(user)
		var/turf/tp_loc = get_step(L.loc, pick(GetSafeDir(get_turf(L))))
		user.forceMove(tp_loc)
		playsound(user, "sound/weapons/fixer/reverb_far[rand(1,2)].ogg", 50)
		src.attack(L, user)
		var/datum/status_effect/stacking/vibration/V = L.has_status_effect(STATUS_EFFECT_VIBRATION)
		if(V)
			qdel(V)
		L.apply_status_effect(STATUS_EFFECT_VIBRATION, 4)
		prev_loc.Beam(tp_loc, "sm_arc_supercharged", time=25)
		sleep(5)
	active = FALSE

/obj/item/ego_weapon/city/reverberation/proc/GrandFinale(mob/living/user)
	set waitfor = FALSE
	if(active || !CanUseEgo(user))
		return FALSE
	active = TRUE
	user.visible_message("<span class='blueteamradio'>Your performance may be reaching an end, but I do hope you’ll shine gorgeously in your own right.</span>")
	playsound(user, "sound/weapons/fixer/reverb_grand_start.ogg", 70, extrarange = 8)
	sleep(3)
	var/turf/original_turf = get_turf(user)
	var/list/to_hit = list()
	for(var/mob/living/L in livinginrange(12, user))
		if(L == src)
			continue
		if(faction_check(user.faction, L.faction))
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		var/turf/prev_loc = get_turf(user)
		var/turf/tp_loc = get_step(L.loc, pick(GetSafeDir(get_turf(L))))
		user.forceMove(tp_loc)
		to_hit += L
		playsound(user, "sound/weapons/fixer/reverb_grand_dash.ogg", 50)
		prev_loc.Beam(tp_loc, "sm_arc_supercharged", time=25)
		sleep(2)
	user.forceMove(original_turf)
	user.visible_message("<span class='blueteamradio'>I hope you can stay with me until the end of the performance, at least.</span>")
	playsound(user, "sound/weapons/fixer/reverb_grand_end.ogg", 70, extrarange = 8)
	for(var/mob/living/L in to_hit)
		var/damage = 200
		var/datum/status_effect/stacking/vibration/V = L.has_status_effect(STATUS_EFFECT_VIBRATION)
		if(V)
			if(V.stacks == vibration)
				damage = 300
		if(isanimal(L))
			damage *= 1.5
		L.apply_damage(damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
		to_chat(L, "<span class='userdanger'>[user] eviscerates you!</span>", MESSAGE_TYPE_COMBAT)
		to_chat(user, "<span class='warning'>You eviscerate [L]!</span>", MESSAGE_TYPE_COMBAT)
	active = FALSE

/obj/item/ego_weapon/city/reverberation/proc/GetSafeDir(turf/target)
	. = list()
	for(var/dir in GLOB.alldirs)
		var/turf/T = get_step(target, dir)
		if(!T)
			continue
		if(T.density)
			continue
		var/obj/structure/window/W = locate() in T
		if(W)
			continue
		var/obj/machinery/door/D = locate() in T
		if(D)
			continue
		. += dir
	return

/obj/item/ego_weapon/city/reverberation/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	if(attack_type == PROJECTILE_ATTACK)
		owner.visible_message("<span class='blueteamradio'>[owner.real_name] deflects the projectile!</span>", "<span class='blueteamradio>Like the pecking of baby chicks~</span>", "<span class='warning'>*clang*</span>")
		return TRUE
	return FALSE

/// Antagonist version, switches faction for easy use.
/obj/item/ego_weapon/city/reverberation/antag
	var/list/old_faction = list()

/obj/item/ego_weapon/city/reverberation/antag/equipped(mob/user, slot, initial)
	. = ..()
	old_faction.Add(user.faction)
	user.faction = list("hostile")

/obj/item/ego_weapon/city/reverberation/antag/dropped(mob/user, silent)
	. = ..()
	user.faction = old_faction
	old_faction.Cut()

/datum/status_effect/stacking/vibration
	id = "vibration"
	alert_type = /atom/movable/screen/alert/status_effect/vibration
	tick_interval = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	stack_decay = 0
	max_stacks = 7
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/vibration
	name = "Vibration"
	desc = "Your body hums with a strange vibration."
	icon_state = "vibration"

/datum/status_effect/stacking/vibration/tick()
	qdel(src)
	return

/datum/status_effect/stacking/vibration/add_stacks(stacks_added)
	if(tick_interval < (world.time + (10 SECONDS)))
		tick_interval = world.time + (10 SECONDS)
	return ..()

/obj/effect/temp_visual/reverb_slash
	icon = 'ModularTegustation/Teguicons/lc13_effects.dmi'
	icon_state = "Horizontal_L"
	duration = 6.6
	pixel_x = -8
	pixel_y = -8

/obj/effect/temp_visual/reverb_slash/right
	icon_state = "Horizontal_R"

/obj/effect/temp_visual/reverb_slash/vertical
	icon_state = "VerticalS"

/datum/action/item_action/charging
	var/charge = 0
	var/max_charge = 10
	var/charge_cost

/datum/action/item_action/charging/New(Target)
	. = ..()
	if(!charge_cost)
		charge_cost = max_charge

/datum/action/item_action/charging/Trigger()
	. = ..()
	if(.)
		AddCharge(-charge_cost)
	return

/datum/action/item_action/charging/proc/AddCharge(amount)
	charge = clamp(charge + amount, 0, max_charge)
	UpdateButtonIcon()

/datum/action/item_action/charging/IsAvailable()
	if(charge <= charge_cost)
		return FALSE
	return ..()

/datum/action/item_action/charging/tempestuous
	name = "Tempestuous Danza"
	desc = "Dash to and Strike all nearby enemies, setting their Vibration to 4."
	max_charge = 5
	icon_icon = 'icons/mob/actions/actions_ability.dmi'
	button_icon_state = "reverberation"

/datum/action/item_action/charging/grandfinale
	name = "Grand Finale"
	desc = "Stand still and conduct your orchestra's finale, dealing damage to all nearby enemies. Deals more damage if your hit resonates with the target."
	max_charge = 15
	icon_icon = 'icons/mob/actions/actions_ability.dmi'
	button_icon_state = "reverberation"


#undef MODE_ADD
#undef MODE_SUBTRACT
