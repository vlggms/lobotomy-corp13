// Rest of the Midnight Ordeal EGO weapons will be added in a future PR

// FOR ADMIN USE ONLY, SHOULD NEVER BE OBTAINED IN GAME
// Weapon dps is 142.9 at 0 just, 220.9 at 130.
/obj/item/ego_weapon/the_claw
	name = "The Claw"
	desc = "A large metal arm with a claw for a hand. Used by the Executioners of the Claw."
	special = "This weapon can not be removed once equipped by any normal means. Use in hand to inject the selected serum with a cooldown of 30 Seconds. \
	\nEach serum changes the damage type of the weapon."
	icon_state = "claw"
	force = 60
	attack_speed = 0.6
	damtype = RED_DAMAGE
	slot_flags = null
	attack_verb_continuous = list("slashes", "eviscerates", "tears")
	attack_verb_simple = list("slash", "eviscerate", "tear")
	hitsound = 'ModularTegustation/Tegusounds/claw/attack.ogg'
	actions_types = list(/datum/action/item_action/switch_serum)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 130,
		PRUDENCE_ATTRIBUTE = 130,
		TEMPERANCE_ATTRIBUTE = 130,
		JUSTICE_ATTRIBUTE = 130,
	)
	var/serum = "K"
	var/special_attack = FALSE
	var/special_cooldown
	var/special_cooldown_time = 30 SECONDS
	var/dash_charges = 3
	var/dash_limit = 3
	var/dash_range = 8
	var/justicemod
	var/dash_ignore_walls = FALSE
	var/serum_desc = "This serum heals you by 25% of max health after injecting for 2 seconds."

/obj/item/ego_weapon/the_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP) //You may not drop this, it is your arm, do you think baral can take off his claw?

/obj/item/ego_weapon/the_claw/examine(mob/user)
	. = ..()
	. += span_notice("Current Serum: Serum [serum]")
	. += span_notice("[serum_desc]")

/obj/item/ego_weapon/the_claw/equipped(mob/living/user)
	. = ..()
	to_chat(user, span_warning("[src] attaches itself to your body!"))
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	justicemod = 1 + userjust/100

/obj/item/ego_weapon/the_claw/dropped()
	src.visible_message(span_warning("The claw arm disappears, you've violated a crucial law of physics."))
	playsound(src, 'ModularTegustation/Tegusounds/claw/death.ogg', 50, TRUE)
	qdel(src)
	return ..()

/datum/action/item_action/switch_serum
	name = "Swap Serum"
	desc = "Swaps your currently selected serum."
	icon_icon = 'icons/obj/ego_weapons.dmi'
	button_icon_state = "claw"

/datum/action/item_action/switch_serum/Trigger()
	var/obj/item/ego_weapon/the_claw/H = target
	if(istype(H))
		H.SwitchSerum(owner)

/obj/item/ego_weapon/the_claw/proc/SwitchSerum(mob/living/user)
	switch(serum)
		if("K")
			serum = "R"
			serum_desc = "This serum prepares [dash_charges] deadly dashes to the location you choose, dealing massive RED damage to all that stand in your way. This serum's charge time is halved."
			damtype = RED_DAMAGE
		if("R")
			serum = "W"
			serum_desc = "This serum locks on to one target of your choosing, and teleports them through multiple locations dealing massive BLACK damage at the end."
			damtype = BLACK_DAMAGE
			dash_charges = dash_limit
		if("W")
			serum = "Tri"
			serum_desc = "Will inject all 3 serums at once, providing a heal fo 15% of your max HP and prepares a mass slash attack to all enemies within a 12 tile radius. This however overclocks the injection systems and double the cooldown."
			damtype = PALE_DAMAGE
			force = 40
		if("Tri")
			serum = "K"
			serum_desc = "This serum heals you by 50% of max health after injecting for 2 seconds."
			damtype = WHITE_DAMAGE
			force = initial(force)
	special_attack = FALSE
	to_chat(user, span_notice("You prime your serum [serum]."))
	playsound(src, 'ModularTegustation/Tegusounds/claw/error.ogg', 50, TRUE)

/obj/item/ego_weapon/the_claw/attack_self(mob/living/user)
	..()
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		to_chat(user, span_warning("Your serum is not ready!"))
		return
	switch(serum)
		if("K")
			to_chat(user, span_notice("You inject the serum K."))
			playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 50, TRUE)
			var/obj/effect/serum_energy/heals = new /obj/effect/serum_energy(user.loc)
			heals.color = "#51e715"
			if(!do_after(user, 2 SECONDS, src))
				qdel(heals)
				return
			animate(heals, alpha = 0, transform = matrix()*2, time = 5)
			to_chat(user, span_notice("The injection is complete, you feel much better."))
			user.adjustBruteLoss(-user.maxHealth*0.50) // Heals 50% of max HP, powerful because its admin only.
			special_cooldown = world.time + special_cooldown_time
			QDEL_IN(heals, 5)
		if("R")
			to_chat(user, span_notice("You prepare the serum R."))
			playsound(src, 'ModularTegustation/Tegusounds/claw/r_prep.ogg', 50, TRUE)
			special_attack = TRUE
			var/obj/effect/serum_energy/dash = new /obj/effect/serum_energy(user.loc)
			dash.color = "#c8720c"
			dash.orbit(user, 0)
			QDEL_IN(dash, 10)
		if("W")
			to_chat(user, span_notice("You prepare the serum W."))
			playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 50, TRUE)
			special_attack = TRUE
			var/obj/effect/serum_energy/death = new /obj/effect/serum_energy(user.loc)
			death.color = "#288ad3"
			death.orbit(user, 0)
			QDEL_IN(death, 10)
		if("Tri")
			to_chat(user, span_notice("You prepare all 3 serums"))
			playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 50, TRUE)
			var/obj/effect/serum_energy/omega_death = new /obj/effect/serum_energy(user.loc)
			omega_death.orbit(user, 0)
			QDEL_IN(omega_death, 10)
			if(!do_after(user, 2 SECONDS, src))
				to_chat(user, span_notice("You disengage the injection sequence."))
				return
			special_cooldown = world.time + special_cooldown_time
			TriSerum(user)

/obj/item/ego_weapon/the_claw/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!special_attack)
		return
	switch(serum)
		if("R") // Thanks helper
			var/turf/target_turf = get_turf(user)
			var/list/line_turfs = list(target_turf)
			var/list/mobs_to_hit = list()
			for(var/turf/T in getline(user, get_ranged_target_turf_direct(user, A , dash_range)))
				if(!dash_ignore_walls && T.density)
					break
				target_turf = T
				line_turfs += T
			user.forceMove(target_turf)
			// "Movement" effect
			for(var/i = 1 to line_turfs.len)
				var/turf/T = line_turfs[i]
				if(!istype(T))
					continue
				for(var/mob/living/L in view(1, T))
					mobs_to_hit |= L
				var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, user)
				D.alpha = min(150 + i*15, 255)
				animate(D, alpha = 0, time = 2 + i*2)
				for(var/turf/TT in range(T, 1))
					new /obj/effect/temp_visual/small_smoke/halfsecond(TT)
				playsound(user, 'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
				for(var/obj/machinery/door/MD in T.contents) // Hiding behind a door mortal?
					if(MD.density)
						addtimer(CALLBACK (MD, TYPE_PROC_REF(/obj/machinery/door, open)))
			// Damage
			for(var/mob/living/L in mobs_to_hit)
				if(user.faction_check_mob(L))
					continue
				if(L.status_flags & GODMODE)
					continue
				visible_message(span_boldwarning("[user] claws through [L]!"))
				playsound(L, 'ModularTegustation/Tegusounds/claw/stab.ogg', 25, 1)
				new /obj/effect/temp_visual/cleave(get_turf(L))
				L.apply_damage(justicemod*60, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			dash_charges--
			if(dash_charges == 0)
				special_attack = FALSE
				special_cooldown = world.time + (special_cooldown_time * 0.5)
				dash_charges = dash_limit
				to_chat(user, span_warning("Your dashes have run out."))
		if("W")
			if(!isliving(A))
				return
			var/obj/effect/temp_visual/target_field/uhoh = new /obj/effect/temp_visual/target_field(A.loc)
			uhoh.orbit(A, 0)
			playsound(A, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
			to_chat(A, span_warning("[user] stares you down, running won't help you."))
			if(!do_after(user, 1 SECONDS, src))
				to_chat(user, span_notice("Whats this, mercy?"))
				qdel(uhoh)
				return
			special_attack = FALSE
			special_cooldown = world.time + special_cooldown_time
			qdel(uhoh)
			SerumW(user, A)

/obj/item/ego_weapon/the_claw/proc/SerumW(mob/living/user, mob/living/target) // It wasn't nice meeting you, farewell.
	var/turf/tp_loc = get_step(target, pick(GLOB.alldirs))
	user.forceMove(tp_loc)
	user.face_atom(target)
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	user.Stun(60 SECONDS, ignore_canstun = TRUE) // Here we go.
	target.Stun(60 SECONDS, ignore_canstun = TRUE)
	to_chat(user, span_notice("You grab [target] by the neck."))
	to_chat(target, span_warning("Your neck is grabbed by [user]!."))
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_portal.ogg', 50, 1)
	new /obj/effect/temp_visual/serum_w(target.loc)
	target.face_atom(user)
	animate(target, pixel_x = 0, pixel_z = 8, time = 5) // The gripping
	sleep(10) // Dramatic effect
	target.visible_message(
		span_warning("[user] disappears, taking [target] with them!"),
		span_userdanger("[user] teleports you with them!")
	)
	animate(target, pixel_x = 0, pixel_z = 0, time = 1)
	var/list/teleport_turfs = list()
	var/list/alt = list("rcorp", "wcorp", "city")
	if(SSmaptype.maptype in alt)
		for(var/turf/T in range(12, user))
			if(!IsSafeTurf(T))
				continue
			teleport_turfs += T
	else
		for(var/turf/T in shuffle(GLOB.department_centers))
			if(T in range(12, user))
				continue
			teleport_turfs += T
	for(var/i = 1 to 5) // Thanks egor
		if(!LAZYLEN(teleport_turfs))
			break
		var/turf/target_turf = pick(teleport_turfs)
		playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		tp_loc.Beam(target_turf, "nzcrentrs_power", time=15)
		playsound(target_turf, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		user.forceMove(target_turf)
		new /obj/effect/temp_visual/emp/pulse(target_turf)
		for(var/mob/living/AA in range(1, target_turf))
			if(faction_check(user.faction, AA.faction))
				continue
			if(AA == target)
				continue
			to_chat(AA, span_userdanger("[user] slashes you!"))
			AA.apply_damage(justicemod*50, BLACK_DAMAGE, null, AA.run_armor_check(null, BLACK_DAMAGE))
			new /obj/effect/temp_visual/cleave(get_turf(AA))
		for(var/obj/item/I in get_turf(target))
			if(I.anchored)
				continue
			I.forceMove(tp_loc)
		tp_loc= get_step(user.loc, pick(GetSafeDir(get_turf(user))))
		target.forceMove(tp_loc)
		new /obj/effect/temp_visual/emp/pulse(tp_loc)
		user.face_atom(target)
		sleep(4)
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_slashes.ogg', 75, 1)
	user.face_atom(target)
	target.visible_message(
		span_warning("Slashes appear around [target], its unwise to stick around.")
	)
	for(var/turf/T in range(2, target))
		if(prob(25))
			new /obj/effect/temp_visual/justitia_effect(T)
	sleep(20)
	for(var/mob/living/AA in range(2, target))
		if(faction_check(user.faction, AA.faction))
			continue
		if(AA == target)
			continue
		to_chat(AA, span_userdanger("You start gushing blood!"))
		AA.apply_damage(justicemod*60, BLACK_DAMAGE, null, AA.run_armor_check(null, BLACK_DAMAGE)) // Shouldn't have gotten close.
		new /obj/effect/temp_visual/cleave(get_turf(AA))
	user.AdjustStun(-60 SECONDS, ignore_canstun = TRUE)
	target.AdjustStun(-60 SECONDS, ignore_canstun = TRUE)
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_fin.ogg', 75, 1)
	target.visible_message(
		span_warning("[target] suddenly gushes blood!"),
		span_userdanger("As [user] lets go, you start gushing blood!")
	)
	target.apply_damage(justicemod*150, BLACK_DAMAGE, null, target.run_armor_check(null, BLACK_DAMAGE)) // 150 so that it can scale form justice to about 300
	for(var/turf/T in range(1, target))
		if(prob(35))
			var/obj/effect/decal/cleanable/blood/B = new /obj/effect/decal/cleanable/blood(get_turf(target))
			B.bloodiness = 100
	if(target.health <= 0)
		target.gib()

/obj/item/ego_weapon/the_claw/proc/TriSerum(mob/living/user) // from PT, which was from Blue reverb
	var/list/targets = list()
	for(var/mob/living/L in livinginrange(12, user))
		if(L == src)
			continue
		if(faction_check(user.faction, L.faction))
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		targets += L
		var/obj/effect/temp_visual/target_field/blue/oh_dear = new /obj/effect/temp_visual/target_field/blue(L.loc)
		oh_dear.orbit(L, 0)
		playsound(L, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 25, 1)
		to_chat(L, span_warning("You're being hunted down by [user]!."))
		QDEL_IN(oh_dear, 10)
	if(!LAZYLEN(targets))
		to_chat(user, span_warning("There are no enemies nearby!"))
		return
	new /obj/effect/temp_visual/serum_w(user.loc)
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_portal.ogg', 50, 1)
	sleep(1 SECONDS) // Dramatic effect
	for(var/mob/living/L in targets)
		var/turf/prev_loc = get_turf(user)
		var/turf/tp_loc= get_step(L.loc, pick(GetSafeDir(get_turf(L))))
		user.forceMove(tp_loc)
		to_chat(L, span_userdanger("[user] decimates you!"))
		playsound(L, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		L.apply_damage(justicemod*60, PALE_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		prev_loc.Beam(tp_loc, "bsa_beam", time=25)
		new /obj/effect/temp_visual/cleave(get_turf(L))
		sleep(3)

/obj/effect/serum_energy
	name = "serum energies"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "white_shield"
	layer = BYOND_LIGHTING_LAYER
	plane = BYOND_LIGHTING_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/serum_w
	name = "serum w portal"
	desc = "No... Not again..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "blueshatter"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = POINT_LAYER
