/* Fragment of the Universe - One with the Universe */
/obj/effect/proc_holder/ability/universe_song
	name = "Song of the Universe"
	desc = "An ability that allows its user to damage and slow down the enemies around them."
	action_icon_state = "universe_song0"
	base_icon_state = "universe_song"
	cooldown_time = 20 SECONDS

	var/damage_amount = 25 // Amount of white damage dealt to enemies per "pulse".
	var/damage_slowdown = 0.6 // Slowdown per pulse
	var/damage_count = 5 // How many times the damage and slowdown is applied
	var/damage_range = 6

/obj/effect/proc_holder/ability/universe_song/Perform(target, mob/user)
	playsound(get_turf(user), 'sound/abnormalities/fragment/sing.ogg', 50, 0, 4)
	Pulse(user)
	for(var/i = 1 to damage_count - 1)
		addtimer(CALLBACK(src, .proc/Pulse, user), i*3)
	return ..()

/obj/effect/proc_holder/ability/universe_song/proc/Pulse(mob/user)
	new /obj/effect/temp_visual/fragment_song(get_turf(user))
	for(var/mob/living/L in view(damage_range, user))
		if(user.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(damage_amount, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
		new /obj/effect/temp_visual/revenant(get_turf(L))
		if(ishostile(L))
			var/mob/living/simple_animal/hostile/H = L
			H.TemporarySpeedChange(damage_slowdown, 5 SECONDS) // Slow down

/* Judgement Bird - Head of God */
/obj/effect/proc_holder/ability/judgement
	name = "Soul Judgement"
	desc = "An ability that damages all enemies around the user and increases their weakness to pale damage."
	action_icon_state = "judgement0"
	base_icon_state = "judgement"
	cooldown_time = 20 SECONDS

	var/damage_amount = 150 // Amount of pale damage dealt to enemies. Humans receive half of it.
	var/damage_range = 9

/obj/effect/proc_holder/ability/judgement/Perform(target, mob/user)
	playsound(get_turf(user), 'sound/abnormalities/judgementbird/pre_ability.ogg', 50, 0)
	var/obj/effect/temp_visual/judgement/still/J = new (get_turf(user))
	animate(J, pixel_y = 24, time = 1.5 SECONDS)
	if(!do_after(user, 1.5 SECONDS))
		to_chat(user, "<span class='warning'>You must stand still to perform judgement!</span>")
		return
	playsound(get_turf(user), 'sound/abnormalities/judgementbird/ability.ogg', 75, 0, 2)
	for(var/mob/living/L in view(damage_range, user))
		if(user.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/judgement(get_turf(L))
		L.apply_damage(ishuman(L) ? damage_amount*0.5 : damage_amount, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
		L.apply_status_effect(/datum/status_effect/judgement_pale_debuff)
	return ..()

/datum/status_effect/judgement_pale_debuff
	id = "judgement_pale_debuff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/judgement_pale_debuff

/datum/status_effect/judgement_pale_debuff/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.pale_mod /= 1.5
		return
	var/mob/living/simple_animal/M = owner
	if(M.damage_coeff[PALE_DAMAGE] <= 0)
		qdel(src)
		return
	M.damage_coeff[PALE_DAMAGE] += 0.5

/datum/status_effect/judgement_pale_debuff/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.pale_mod *= 1.5
		return
	var/mob/living/simple_animal/M = owner
	M.damage_coeff[PALE_DAMAGE] -= 0.5

/atom/movable/screen/alert/status_effect/judgement_pale_debuff
	name = "Soul Drain"
	desc = "Your sinful actions have made your soul more vulnerable to PALE attacks."
	icon = 'icons/mob/actions/actions_ability.dmi'
	icon_state = "judgement"
