#define STATUS_EFFECT_BLAZING /datum/status_effect/blazing
#define STATUS_EFFECT_BLINDED /datum/status_effect/blinded
//CREDIT TO REDACTED FOR HELPING ME WITH THIS UNHOLY CODE
/mob/living/simple_animal/hostile/abnormality/fire_bird
	name = "The Firebird"
	desc = "A large bird covered in ashes, pray its feathers do not re-ignite."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "burntbird"
	icon_living = "firebird_active"
	portrait = "fire_bird"
	threat_level = WAW_LEVEL
	maxHealth = 2000
	health = 2000
	max_boxes = 24
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -16
	base_pixel_y = -16
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 50, 50, 60),
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 25, 25, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(45, 45, 40, 40, 50),
		ABNORMALITY_WORK_REPRESSION = list(45, 45, 40, 40, 50),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	good_hater = TRUE
	faction = list("hostile", "neutral")
	can_breach = TRUE
	start_qliphoth = 3
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2.0)
	light_color = COLOR_LIGHT_ORANGE
	light_range = 0
	light_power = 0
	loot = list(/obj/item/ego_weapon/ranged/feather)
	ego_list = list(/datum/ego_datum/armor/feather)
	gift_type = /datum/ego_gifts/feather
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	friendly_verb_continuous = "grazes"
	friendly_verb_simple = "grazes"

	observation_prompt = "You can only hunt it wearing a thick blindfold, but even through the fabric you can track it by the light that manages to seep through and by the heat it radiates. <br>\
		In your hands you carry a bow nocked with an arrow, it's your last one. <br>\
		You've been pursuing your prey for days, you..."
	observation_choices = list(
		"Do nothing" = list(TRUE, "You watch and wait as the light and heat pass until only cold and darkness reign in the forest. <br>\
			Feeling safe, you remove your blindfold and find on the ground one of its radiant feathers. <br>\
			Bravo brave hunter, have you found what you were seeking?"),
		"Take off your blindfold" = list(TRUE, "Your curiosity gets the better of you. <br>\
			The sight of a mythological bird that no one has seen before is a prize no hunter has claimed. <br>\
			Steeling yourself, you remove the blindfold and immediately your vision is seared by the intensity of the light but you will yourself through the pain to catch a glimpse of what has long evaded every hunter's sight. <br>\
			The bird offers a tear for your efforts. <br>\
			Though your eyes may never recover, you have done what no hunter has dared to accomplish - captured it in your sight."),
		"Fire an arrow" = list(FALSE, "You fire an arrow at what you percieve to be the source of the light and miss entirely. <br>You return empty-handed like so many hunters before you."),
	)

	var/pulse_cooldown
	var/pulse_cooldown_time = 1 SECONDS
	var/pulse_damage = 10
	var/can_act = TRUE
	var/dash_cooldown
	var/dash_cooldown_time = 5 SECONDS
	var/dash_max = 50
	var/dash_damage = 220
	var/list/been_hit = list()

//Initialize
/mob/living/simple_animal/hostile/abnormality/fire_bird/HandleStructures()
	. = ..()
	if(!.)
		return
	if(locate(/obj/structure/firetree) in datum_reference.connected_structures)
		return
	SpawnConnectedStructure(/obj/structure/firetree)

//Work Procs
/mob/living/simple_animal/hostile/abnormality/fire_bird/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/fire_bird/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/fire_bird/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/fire_bird/OnQliphothChange(mob/living/carbon/human/user)
	. = ..()
	switch(datum_reference?.qliphoth_meter)
		if(1)
			work_damage_amount = 20
			light_range = 10
			light_power = 20
			update_light()
		if(2)
			work_damage_amount = 15
			light_range = 2
			light_power = 10
			update_light()
		else
			work_damage_amount = 10
			light_range = 0
			light_power = 0
			update_light()

/mob/living/simple_animal/hostile/abnormality/fire_bird/WorkComplete(mob/living/carbon/human/user, work_type, pe, work_time)
	. = ..()
	if(datum_reference?.qliphoth_meter == 1 || user.health <= (user.maxHealth * 0.2))
		to_chat(user, span_nicegreen("The Fire Bird heals your wounds!"))
		user.health = user.maxHealth
		if(ishuman(user))
			user.apply_status_effect(STATUS_EFFECT_BLAZING)

/mob/living/simple_animal/hostile/abnormality/fire_bird/proc/BlindedWork(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user)
	SIGNAL_HANDLER
	user.remove_status_effect(STATUS_EFFECT_BLINDED)

//Breach
/mob/living/simple_animal/hostile/abnormality/fire_bird/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	loot = list(/obj/item/ego_weapon/ranged/feather)
	icon_state = icon_living
	light_range = 20
	light_power = 20
	update_light()
	if(IsCombatMap())
		loot = list()
		return
	addtimer(CALLBACK(src, PROC_REF(KillOtherBird)), 90 SECONDS)

/mob/living/simple_animal/hostile/abnormality/fire_bird/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		crispynugget()

/mob/living/simple_animal/hostile/abnormality/fire_bird/proc/KillOtherBird()
	loot = null
	light_range = 0
	light_power = 0
	death()

//Attacks
/mob/living/simple_animal/hostile/abnormality/fire_bird/proc/crispynugget()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/carbon/human/L in livinginview(48, src))
		L.deal_damage(pulse_damage, RED_DAMAGE)

/mob/living/simple_animal/hostile/abnormality/fire_bird/proc/retaliatedash()
	if(dash_cooldown > world.time)
		return
	dash_cooldown = world.time + dash_cooldown_time
	if(!(status_flags & GODMODE))
		can_act = FALSE
		var/dir_to_target = get_dir(src, target)
		var/turf/T = get_turf(src)
		for(var/i = 1 to dash_max)
			T = get_step(T, dir_to_target)
			if(T.density)
				if(i < 4) // Mob attempted to dash into a wall too close, stop it
					can_act = TRUE
					return
				break
			new /obj/effect/temp_visual/small_smoke(T)
		dash_cooldown = world.time + dash_cooldown_time
		SLEEP_CHECK_DEATH(11)
		been_hit = list()
		playsound(get_turf(src), 'sound/abnormalities/firebird/Firebird_Hit.ogg', 100, 0, 20) //TEMPORARY
		DoDash(dir_to_target, 0)

/mob/living/simple_animal/hostile/abnormality/fire_bird/proc/DoDash(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= dash_max)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		can_act = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("flames")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK (D, TYPE_PROC_REF(/obj/machinery/door, open)))
	if(stop_charge)
		can_act = TRUE
		return
	forceMove(T)
	for(var/turf/TF in view(1, T))
		new /obj/effect/temp_visual/fire/fast(TF)
		for(var/mob/living/carbon/human/L in TF)
			if(L in been_hit)
				continue
			visible_message(span_boldwarning("[src] blazes through [L]!"))
			L.deal_damage(dash_damage, WHITE_DAMAGE)
			new /obj/effect/temp_visual/cleave(get_turf(L))
			if(L.sanity_lost) // TODO: TEMPORARY AS HELL
				L.adjustFireLoss(999)
			if(!(L in been_hit))
				been_hit += L


	addtimer(CALLBACK(src, PROC_REF(DoDash), move_dir, (times_ran + 1)), 0.5) // SPEED

/mob/living/simple_animal/hostile/abnormality/fire_bird/attackby(obj/item/I, mob/living/user, params)
	..()
	GiveTarget(user)
	if(ishuman(user) && !(status_flags & GODMODE))
		user.apply_status_effect(STATUS_EFFECT_BLINDED)
	retaliatedash()

/mob/living/simple_animal/hostile/abnormality/fire_bird/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(Proj.firer && ishuman(Proj.firer))
		var/mob/living/carbon/carbon_firer = Proj.firer
		GiveTarget(carbon_firer)
		carbon_firer.apply_status_effect(STATUS_EFFECT_BLINDED)
	retaliatedash()

//Containment object
/obj/structure/firetree
	name = "Fire Bird's tree"
	desc = "A burnt tree that is the Fire Bird's favored perching spot. There should probably be a bird here." //uhoh
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "burnttree"
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE //should make this indestructible
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -16
	base_pixel_y = -16

//Status effect
/datum/status_effect/blazing
	id = "blazing"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 60 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/FireRegen
	var/b_tick = 10
	tick_interval = 5 SECONDS

/atom/movable/screen/alert/status_effect/FireRegen
	name = "Blazing"
	desc = "The Firebird's flames are healing your wounds"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/blazing/tick()
	..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjustBruteLoss(-b_tick)
	status_holder.adjustFireLoss(-b_tick)
	status_holder.adjustSanityLoss(-b_tick)

#undef STATUS_EFFECT_BLAZING

/datum/status_effect/blinded
	id = "blinded"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/OwMyEyes
	var/cantsee = list()

/atom/movable/screen/alert/status_effect/OwMyEyes
	name = "Burnt Eyes"
	desc = "The Firebird has burnt your eyes and made it harder to work!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/blinded/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	cantsee += status_holder
	cantsee[status_holder] = get_attribute_level(status_holder, TEMPERANCE_ATTRIBUTE)/2
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -cantsee[status_holder])
	to_chat(status_holder, span_userdanger("The light of the bird burns your eyes!"))
	RegisterSignal(status_holder, COMSIG_WORK_COMPLETED, PROC_REF(BlindedWork))

/datum/status_effect/blinded/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, cantsee[status_holder])
	cantsee -= status_holder
	to_chat(status_holder, span_nicegreen("The blinding light fades..."))
	UnregisterSignal(status_holder, COMSIG_WORK_COMPLETED, PROC_REF(BlindedWork))

/datum/status_effect/blinded/proc/BlindedWork(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user)
	SIGNAL_HANDLER
	user.remove_status_effect(STATUS_EFFECT_BLINDED)

#undef STATUS_EFFECT_BLINDED
