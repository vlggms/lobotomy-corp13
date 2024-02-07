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
		JUSTICE_ATTRIBUTE = 120,
	)
	var/mode = MODE_ADD
	var/vibration = 4
	var/vibration_timer
	var/active = FALSE
	var/list/intrusive_thoughts = list(
		"Can't you feel this tremor…?",
		"Could there be an overture with a rhythm more beautiful than this?",
		"We'll complete our own score…",
		"One that can be played indefinitely, even if there seems to be an end!",
		"So you will take the honor of remembering the first note of this everlasting performance…",
	)
	var/finale_damage = 200

/obj/item/ego_weapon/city/reverberation/Initialize()
	. = ..()
	vibration = rand(4,6)
	VibrationChange()

/obj/item/ego_weapon/city/reverberation/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/city/reverberation/ui_action_click(mob/living/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/charging/tempestuous))
		TempestuousDanza(user)
	if(istype(actiontype, /datum/action/item_action/charging/grandfinale))
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
	var/datum/status_effect/stacking/vibration/S = target.has_status_effect(STATUS_EFFECT_VIBRATION)
	var/temp_sound = hitsound
	var/obj/effect/temp_visual/reverb_slash/VFX
	if(S)
		if(S.stacks == vibration)
			damtype = PALE_DAMAGE

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

	force = 60
	hitsound = temp_sound
	if(!. || target.stat == DEAD)
		return
	for(var/datum/action/item_action/charging/CA in actions)
		CA.charge += 1
	if(S)
		if(S.stacks == vibration)
			if(prob(8))
				to_chat(user, span_blueteamradio("[pick(intrusive_thoughts)]"), MESSAGE_TYPE_LOCALCHAT)
			if(target.stat != DEAD && target != user)
				for(var/datum/action/item_action/charging/CA in actions)
					CA.charge += 2
		S.add_stacks(mode)
	else
		if(mode == MODE_ADD)
			S = target.apply_status_effect(STATUS_EFFECT_VIBRATION, mode)
			S.seers |= user
			S.UpdateStatus()
	if(!S)
		to_chat(user, span_notice("Your blade emits a dull hum as your target ceases to vibrate."), MESSAGE_TYPE_INFO)
	return

/obj/item/ego_weapon/city/reverberation/proc/VibrationChange()
	vibration_timer = addtimer(CALLBACK(src, PROC_REF(VibrationChange)), 10 SECONDS, TIMER_STOPPABLE)
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
	for(var/datum/status_effect/stacking/vibration/V in SSfastprocess.processing)
		V.AddVisual(user)

/obj/item/ego_weapon/city/reverberation/dropped(mob/user, silent)
	. = ..()
	update_icon()
	for(var/datum/status_effect/stacking/vibration/V in SSfastprocess.processing)
		V.RemoveVisual(user)

/obj/item/ego_weapon/city/reverberation/proc/TempestuousDanza(mob/living/user)
	set waitfor = FALSE
	if(active || !CanUseEgo(user))
		return FALSE
	active = TRUE
	to_chat(user, span_blueteamradio("We will shape this world together."), MESSAGE_TYPE_LOCALCHAT)
	deltimer(vibration_timer)
	var/hit_target = FALSE
	for(var/mob/living/L in livinginrange(8, user))
		if(L == src)
			continue
		if(faction_check(user.faction, L.faction))
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		hit_target = TRUE
		var/turf/prev_loc = get_turf(user)
		var/turf/tp_loc = get_step(L.loc, pick(GetSafeDir(get_turf(L))))
		user.forceMove(tp_loc)
		playsound(user, "sound/weapons/fixer/reverb_far[rand(1,2)].ogg", 50)
		src.attack(L, user)
		var/datum/status_effect/stacking/vibration/V = L.has_status_effect(STATUS_EFFECT_VIBRATION)
		if(V)
			qdel(V)
		L.apply_status_effect(STATUS_EFFECT_VIBRATION, vibration)
		prev_loc.Beam(tp_loc, "sm_arc_supercharged", time=25)
		sleep(5)
	if(!hit_target)
		var/datum/action/item_action/charging/tempestuous/T = locate() in actions
		T.AddCharge(T.max_charge) // Refund if no targets
	active = FALSE
	vibration_timer = addtimer(CALLBACK(src, PROC_REF(VibrationChange)), 10 SECONDS, TIMER_STOPPABLE)

/obj/item/ego_weapon/city/reverberation/proc/GrandFinale(mob/living/user)
	set waitfor = FALSE
	if(active || !CanUseEgo(user))
		return FALSE
	active = TRUE
	deltimer(vibration_timer)
	user.visible_message(span_blueteamradio("Your performance may be reaching an end, but I do hope you’ll shine gorgeously in your own right."))
	playsound(user, "sound/weapons/fixer/reverb_grand_start.ogg", 70, extrarange = 8)
	sleep(3)
	var/turf/original_turf = get_turf(user)
	var/list/to_hit = list()
	var/hit_target = FALSE
	for(var/mob/living/L in livinginrange(12, user))
		if(L == src)
			continue
		if(faction_check(user.faction, L.faction))
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		hit_target = TRUE
		var/turf/prev_loc = get_turf(user)
		var/turf/tp_loc = get_step(L.loc, pick(GetSafeDir(get_turf(L))))
		user.forceMove(tp_loc)
		to_hit += L
		playsound(user, "sound/weapons/fixer/reverb_grand_dash.ogg", 50)
		prev_loc.Beam(tp_loc, "sm_arc_supercharged", time=25)
		sleep(2)
	if(!hit_target)
		var/datum/action/item_action/charging/tempestuous/T = locate() in actions
		T.AddCharge(T.max_charge) // Refund if no targets
		return
	user.forceMove(original_turf)
	user.visible_message(span_blueteamradio("I hope you can stay with me until the end of the performance, at least."))
	playsound(user, "sound/weapons/fixer/reverb_grand_end.ogg", 70, extrarange = 8)
	for(var/mob/living/L in to_hit)
		var/datum/status_effect/stacking/vibration/V = L.has_status_effect(STATUS_EFFECT_VIBRATION)
		var/damage = finale_damage
		if(V)
			if(V.stacks == vibration)
				damage *= 1.5
		if(isanimal(L))
			damage *= 1.5
		L.apply_damage(damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
		to_chat(L, span_userdanger("[user] eviscerates you!"), MESSAGE_TYPE_COMBAT)
		to_chat(user, span_warning("You eviscerate [L]!"), MESSAGE_TYPE_COMBAT)
	active = FALSE
	vibration_timer = addtimer(CALLBACK(src, PROC_REF(VibrationChange)), 10 SECONDS, TIMER_STOPPABLE)

/obj/item/ego_weapon/city/reverberation/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	if(attack_type == PROJECTILE_ATTACK)
		owner.visible_message(span_blueteamradio("[owner.real_name] deflects the projectile!"), span_blueteamradio("Like the pecking of baby chicks~"), span_warning("*clang*"))
		return TRUE
	return FALSE

/// Antagonist version, switches faction for easy use.
/obj/item/ego_weapon/city/reverberation/antag
	var/list/old_faction = list()
	finale_damage = 80 // meant to hit people

/obj/item/ego_weapon/city/reverberation/antag/equipped(mob/user, slot, initial)
	. = ..()
	old_faction.Add(user.faction)
	user.faction = list("hostile")
	ADD_TRAIT(user, TRAIT_COMBATFEAR_IMMUNE, "antag")

/obj/item/ego_weapon/city/reverberation/antag/dropped(mob/user, silent)
	. = ..()
	user.faction = old_faction
	old_faction.Cut()
	REMOVE_TRAIT(user, TRAIT_COMBATFEAR_IMMUNE, "antag")

/datum/status_effect/stacking/vibration
	id = "vibration"
	alert_type = /atom/movable/screen/alert/status_effect/vibration
	tick_interval = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	stack_decay = 0
	max_stacks = 7
	consumed_on_threshold = FALSE
	var/image/I
	var/list/seers = list()

/datum/status_effect/stacking/vibration/on_creation(mob/living/new_owner, stacks_to_apply)
	. = ..()
	for(var/datum/status_effect/stacking/vibration/V in SSfastprocess.processing)
		seers |= V.seers
	UpdateStatus()

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
	. = ..()
	UpdateStatus()
	return

/datum/status_effect/stacking/vibration/proc/UpdateStatus()
	for(var/mob/M in seers)
		M.client?.images -= I
	if(stacks <= 0)
		return
	if(!I)
		I = image('icons/effects/number_overlays.dmi', owner, "b[stacks]")
	else
		I.icon_state = "b[stacks]"
	for(var/mob/M in seers)
		M.client?.images |= I

/datum/status_effect/stacking/vibration/proc/AddVisual(mob/M)
	M.client?.images |= I
	seers |= M

/datum/status_effect/stacking/vibration/proc/RemoveVisual(mob/M)
	M.client?.images -= I
	seers -= M

/datum/status_effect/stacking/vibration/on_remove()
	stacks = 0
	UpdateStatus()
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
	desc = "Dash to and Strike all nearby enemies, setting their Vibration to your current vibration."
	max_charge = 15
	icon_icon = 'icons/mob/actions/actions_ability.dmi'
	button_icon_state = "reverberation"

/datum/action/item_action/charging/grandfinale
	name = "Grand Finale"
	desc = "Stand still and conduct your orchestra's finale, dealing damage to all nearby enemies. Deals more damage if your hit resonates with the target."
	max_charge = 40
	icon_icon = 'icons/mob/actions/actions_ability.dmi'
	button_icon_state = "reverberation"


#undef MODE_ADD
#undef MODE_SUBTRACT
