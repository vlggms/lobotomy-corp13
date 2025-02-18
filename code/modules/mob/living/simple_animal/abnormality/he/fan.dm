//I think I want to do the idea of temptation.
//The works are always max but you can only do it 3 times per person.	-Kirie
/mob/living/simple_animal/hostile/abnormality/fan
	name = "F.A.N."
	desc = "It appears to be an office fan."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fan"
	portrait = "fan"
	maxHealth = 400
	health = 400
	threat_level = HE_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 100,
		ABNORMALITY_WORK_INSIGHT = 100,
		ABNORMALITY_WORK_ATTACHMENT = 100,
		ABNORMALITY_WORK_REPRESSION = 100,
	)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE
	max_boxes = 12

	ego_list = list(
		/datum/ego_datum/weapon/metal,
		/datum/ego_datum/armor/metal,
	)
	gift_type = /datum/ego_gifts/metal
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "It's an ordinary office fan, made of metal. <br>It's turned off for now and you're feeling warm. <br>\
		Turn it on?"
	observation_choices = list(
		"Set it to 3" = list(TRUE, "You set it to its highest setting. <br>The breeze feels pleasant, a nap would be nice..."),
		"Leave it off" = list(FALSE, "It's just an old urban legend, but, they say fans like this one can kill people if you slept with them on..."),
		"Set it to 1" = list(FALSE, "It's not enough, you're still too hot!"),
		"Set it to 2" = list(FALSE, "You can barely feel a breeze, you just need a little more..."),
	)

	var/list/safe = list()
	var/list/warning = list()
	var/list/danger = list()
	pet_bonus = "powers on" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/safework = FALSE //Safe if the abnormality was melting
	var/successcount
	var/turned_off = FALSE

/mob/living/simple_animal/hostile/abnormality/fan/examine(mob/user)
	. = ..()
	if(turned_off)
		. += span_notice("It looks like it's turned off.")

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/fan/WorkChance(mob/living/carbon/human/user, chance)
	var/newchance = 100 - (successcount*3)
	return newchance

/mob/living/simple_animal/hostile/abnormality/fan/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	successcount+=1

/mob/living/simple_animal/hostile/abnormality/fan/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in danger)
		if(safework)
			to_chat(user, span_notice("You don't feel quite as tempted this time."))
			safework = FALSE
			return
		to_chat(user, span_danger("Oh."))
		user.throw_at(src, 10, 10, user, spin = TRUE, gentle = FALSE, quickstart = TRUE)
		SLEEP_CHECK_DEATH(3)
		playsound(loc, 'sound/machines/juicer.ogg', 100, TRUE)
		user.gib()

	else if(user in warning)
		danger+=user
		to_chat(user, span_nicegreen("You feel elated."))

	else if(user in safe)
		warning+=user
		to_chat(user, span_nicegreen("You feel refreshed."))

	else
		safe+=user
		to_chat(user, span_nicegreen("You could use some more."))

//Meltdown
/mob/living/simple_animal/hostile/abnormality/fan/AttemptWork(mob/living/carbon/human/user, work_type)
	if(turned_off)
		to_chat(user, span_nicegreen("You hit the on switch. Aaah, that feels nice."))
		TurnOn()
		return FALSE
	if(datum_reference.console.meltdown)
		safework = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fan/funpet(mob/petter)
	if(turned_off)
		to_chat(petter, span_nicegreen("You hit the on switch. Aaah, that feels nice."))
		TurnOn()

//Breach
/mob/living/simple_animal/hostile/abnormality/fan/ZeroQliphoth(mob/living/carbon/human/user)
	. = ..()
	if(!turned_off)
		TurnOff()

/mob/living/simple_animal/hostile/abnormality/fan/proc/TurnOn(mob/living/carbon/human/user)
	turned_off = FALSE
	icon_state = "fan"
	playsound(get_turf(src), 'sound/abnormalities/FAN/turnon.ogg', 100, FALSE, 2)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		var/datum/status_effect/stacking/fanhot/V = L.has_status_effect(/datum/status_effect/stacking/fanhot)
		if(!V)
			continue
		else
			qdel(V)

/mob/living/simple_animal/hostile/abnormality/fan/proc/TurnOff(mob/living/carbon/human/user)
	turned_off = TRUE
	icon_state = "fan_idle"
	playsound(get_turf(src), 'sound/abnormalities/FAN/turnoff.ogg', 100, TRUE, 2)
	HeatWave()
	sound_to_playing_players_on_level('sound/abnormalities/seasons/summer_idle.ogg', 150, zlevel = z)

/mob/living/simple_animal/hostile/abnormality/fan/proc/HeatWave()
	set waitfor = FALSE
	if(!turned_off)
		datum_reference.qliphoth_change(1)
		return
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(z != L.z || L.stat >= HARD_CRIT) // on a different Z level or dead
			continue
		var/datum/status_effect/stacking/fanhot/V = L.has_status_effect(/datum/status_effect/stacking/fanhot)
		if(!V)
			L.apply_status_effect(/datum/status_effect/stacking/fanhot)
		else
			V.add_stacks(1)
			V.refresh()
	SLEEP_CHECK_DEATH(3 SECONDS)
	HeatWave(TRUE)

/datum/status_effect/stacking/fanhot
	id = "stacking_fanhot"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20 SECONDS
	alert_type = null
	stack_decay = 0
	tick_interval = 10
	stacks = 1
	stack_threshold = 33
	max_stacks = 35
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/fanhot
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/fanhot
	name = "Hot"
	desc = "Someone turn on the AC!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "hot"

/datum/status_effect/stacking/fanhot/on_apply()
	. = ..()
	to_chat(owner, span_warning("You're starting to sweat."))
	if(owner.client)
		owner.add_client_colour(/datum/client_colour/glass_colour/orange)

/datum/status_effect/stacking/fanhot/add_stacks(stacks_added)
	. = ..()
	if(!stacks_added)
		return
	if(stacks <= 10)
		return
	owner.deal_damage((stacks / 5), RED_DAMAGE)
	owner.playsound_local(owner, 'sound/effects/burn.ogg', 25, TRUE)

/datum/status_effect/stacking/fanhot/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	to_chat(owner, span_nicegreen("Someone turned on the AC! Rejoice!"))
	if(owner.client)
		owner.remove_client_colour(/datum/client_colour/glass_colour/orange)

/datum/status_effect/stacking/fanhot/threshold_cross_effect()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_warning("IT'S TOO HOT!"))
	status_holder.adjust_fire_stacks(15)
	status_holder.IgniteMob()
	stacks -= 5
