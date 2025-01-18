/mob/living/simple_animal/hostile/abnormality/doomsday_calendar
	name = "Doomsday Calendar"
	desc = "Likely a tool for predicting a date of some kind, judging from the many letters carved on the bricks."
	health = 2012
	maxHealth = 2012
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "doomsday_inert"
	icon_living = "doomsday_inert"
	icon_dead = "doomsday_egg"
	core_icon = "doomsday_egg"
	portrait = "doomsday"
	light_color = COLOR_LIGHT_ORANGE
	light_range = 0
	light_power = 0
	base_pixel_x = -16
	pixel_x = -16
	can_breach = TRUE
	can_buckle = TRUE
	threat_level = HE_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.3)//only when initialized
	start_qliphoth = 5
	max_boxes = 18//this is the normal amount
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 20,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	can_patrol = FALSE
	wander = FALSE
	del_on_death = FALSE
	death_message = "crumbles into bits."
	attack_sound = 'sound/abnormalities/doomsdaycalendar/Doomsday_Attack.ogg'
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_type = BLACK_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/impending_day,
		/datum/ego_datum/armor/impending_day,
	)
	gift_type =  /datum/ego_gifts/impending_day
	gift_message = "Let the blood flow, the fire ignite, and the star fall."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "I'm standing before an altar on top of an impossibly long flight of stairs, the sky is crimson red and the heat from the air licks at my skin painfully. <br>The world is ending. <br>\
		On the altar is a tied and bound man with a clay mask on his head, he squirms and is clearly crying but I cannot hear his words. <br>\
		In my hand is a dagger. <br>I know what I have to do."
	observation_choices = list(
		"Plunge the dagger into his chest" = list(TRUE, "I'm laying on an altar, a heavy clay mask is on my head, my arms and legs are tied with thick rope and the air is hot enough to scald my skin. <br>\
			I see the priest through the pinholes of the mask and plead for him to spare me, before I feel cold metal plunge into my chest."),
		"Cut his bindings" = list(FALSE, "I cut the man free and he thanks me profusely before he speeds down the stairs. <br>He won't make it. <br>I close my eyes and accept the end."),
	)

	var/player_count
	var/other_works_maximum
	var/other_works = 0
	var/flavor_dist = 40
	var/pulse_cooldown
	var/pulse_cooldown_time = 2 SECONDS
	var/pulse_damage = 5
	var/bonusRed = 0
	var/next_phase_time
	var/next_phase_time_cooldown = 45 SECONDS
	var/current_phase_num = -1
	var/aflame_range = 5//it goes up if ignored
	var/aflame_damage = 20
	var/gibtime = 5
	var/is_fed = FALSE
	var/is_firey = FALSE
	var/doll_count_maximum = 2
	var/list/spawned_dolls = list()
	pet_bonus = "rumbles" //saves a few lines of code by allowing funpet() to be called by attack_hand()

//*** Simple Mob Procs ***//
/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Initialize()
	. = ..()
	updateWorkMaximum()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED, PROC_REF(OnAbnoWork))

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/CanAttack(atom/the_target)//should only attack when it has fists
	return FALSE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!IsContained())//if it's breaching
		CheckCountdown()
		if((pulse_cooldown < world.time) && (is_firey == TRUE))
			playsound(src, 'sound/effects/burn.ogg', 50, TRUE)
			AoeBurn()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/death()
	density = FALSE
	playsound(src, 'sound/abnormalities/doomsdaycalendar/Doomsday_Dead.ogg', 100, 1)
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	for(var/mob/living/simple_animal/hostile/doomsday_doll/D in spawned_dolls) //delete the dolls when suppressed
		D.death()
		QDEL_IN(D, rand(1,5) SECONDS)
		spawned_dolls -= D
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED)
	return ..()

//*** Work Mechanics ***//
//Even clerks can appease it with their blood
/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/funpet(mob/living/carbon/human/user)
	if(IsContained() && datum_reference.qliphoth_meter != datum_reference.qliphoth_meter_max)
		if(do_after(user, gibtime, target = src))
			to_chat(user, span_warning("[src] bites you! It seems to have been appeased."))
			user.adjustBruteLoss(75 - (datum_reference.qliphoth_meter * 15))
			datum_reference.qliphoth_change(1)
			return
		else
			to_chat(user, span_notice("Maybe it's better to leave this thing alone."))

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/OnAbnoWork(datum/source, datum/abnormality/abno_datum, mob/user, work_type)//from punishing bird
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(abno_datum == datum_reference)//If working on this abnormality
		return FALSE
	if(datum_reference.working)//If the abnormality is being worked on, may invalidate the previous conditional statement
		return FALSE
	++other_works
	if(other_works >= other_works_maximum)
		datum_reference.qliphoth_change(-1)
		other_works = 0
	return TRUE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/WorkChance(mob/living/carbon/human/user, chance)
	if(bonusRed)
		return chance + (bonusRed * 3)//extra work success on instinct work if it's hungry. Up to +12%, making it a 72% base success rate at counter 1.
	return chance

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		return
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		datum_reference.qliphoth_change(4)//Work damage is multiplied by missing qliphoth counter, restore it fully.
	return

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/AttemptWork(mob/living/carbon/human/user, work_type)
	datum_reference.max_boxes = (max_boxes + (5 - datum_reference.qliphoth_meter))//18 at max qliphoth, up to 22.
	if(work_type != ABNORMALITY_WORK_INSTINCT)// Sets bonus damage on instinct work only.
		bonusRed = 0
		return..()
	bonusRed = (5 - (datum_reference.qliphoth_meter))//It samples your blood if it's below the maximum counter, damage is RED instead of typeless
	if(bonusRed)
		to_chat(user, span_warning("A clay doll arrives with a bowl, demanding blood."))
		playsound(src, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 40, 0, 1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Worktick(mob/living/carbon/human/user)
	if(bonusRed) // If you have bonus red damage to apply...
		user.deal_damage(bonusRed, RED_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/OnQliphothChange(mob/living/carbon/human/user)//woodsman icon change
	. = ..()
	if(datum_reference.qliphoth_meter == 1)
		icon_state = "doomsday_active"
		playsound(get_turf(src), 'sound/abnormalities/doomsdaycalendar/Impending_Charge.ogg', 75, 0, 5)
	else
		icon_state = "doomsday_inert"

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/updateWorkMaximum()
	player_count = 0
	for(var/mob/player in GLOB.player_list)
		if(isliving(player) && ishuman(player))
			player_count += 1
	other_works_maximum = (4 + round(player_count / 6))

//***Breach Mechanics***//
/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(breach_type != BREACH_MINING)
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)
	icon_state = "doomsday_active"
	AnnounceBreach()
	SpawnAdds()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/AnnounceBreach()
	send_to_playing_players(span_narsiesmall("The day of the Apocalypse has arrived."))
	sound_to_playing_players('sound/creatures/narsie_rises.ogg')
	for(var/mob/living/carbon/human/H in livinginrange(20, src))//same range as universe aflame when fully charged
		if(H.z != z)
			return
		to_chat(H, span_boldwarning("You hear rumbling..."))


/obj/effect/temp_visual/doomsday
	icon = 'icons/effects/effects.dmi'
	icon_state = "universe_aflame"
	alpha = 170
	duration = 50

/obj/effect/temp_visual/doomsday/Initialize()
	add_overlay(mutable_appearance('icons/effects/effects.dmi', "empdisable", -ABOVE_OBJ_LAYER))
	return ..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/CheckCountdown()//grabbed from TSO
	if(world.time >= next_phase_time) // Next phase
		if(current_phase_num < 4)
			current_phase_num += 1
		switch(current_phase_num)
			if(1)
				next_phase_time_cooldown = 30 SECONDS
				for(var/mob/living/carbon/human/H in livinginview(10, src))
					to_chat(H, span_boldwarning("[src] appears upset as its bricks begin to rattle."))
				CheckFed()
				SpawnAdds()
				icon_state = "doomsday_angry"
			if(2)
				for(var/mob/living/carbon/human/H in livinginview(10, src))
					to_chat(H, span_boldwarning("The heat emitting from [src] is unbearable."))
				CheckFed()
				SpawnAdds()
				icon_state = "doomsday_firey"
				EnableFire()
			if(3)
				for(var/mob/living/carbon/human/H in livinginview(10, src))
					to_chat(H, span_boldwarning("[src] takes on an ominous appearance and starts glowing."))
				CheckFed()
				SpawnAdds()
				icon_state = "doomsday_charging"
				EnableFire()
			if(4)//begin nuking
				CheckFed()
				icon_state = "doomsday_universe"
				EnableFire()
		next_phase_time = world.time + next_phase_time_cooldown

		if(current_phase_num >= 4)//UNIVERSE AFLAME!
			for(var/turf/T in range(aflame_range, src))
				for(var/mob/living/carbon/human/H in T)
					to_chat(H, span_narsiesmall("The stars are twinkling. When they shine, they'll rob us all of our sight."))
			playsound(src, 'sound/abnormalities/doomsdaycalendar/Impending_Charge.ogg', 50, TRUE)
			SLEEP_CHECK_DEATH(15 SECONDS)
			playsound(src, 'sound/abnormalities/doomsdaycalendar/Doomsday_Universe.ogg', 50, TRUE)
			for(var/turf/T in range(aflame_range, src))
				if(prob(25))
					new /obj/effect/temp_visual/doomsday(T)
				for(var/mob/living/H in T)
					if(isabnormalitymob(H))
						var/mob/living/simple_animal/hostile/abnormality/A = H
						if(!(A.IsContained()))
							continue
						A.datum_reference.qliphoth_change(-1)
					if(faction_check_mob(H))
						continue
					H.deal_damage(aflame_damage, BLACK_DAMAGE)
					if(H.stat >= SOFT_CRIT || H.health < 0)
						H.fire_stacks += 1
						H.IgniteMob()//unforunately this fire isn' blue.
			adjustBruteLoss(1000)

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/AoeBurn()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/L in livinginview(10, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, RED_DAMAGE)

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/EnableFire()
	if(current_phase_num <= 1)
		return
	if(pulse_damage <= 0)
		set_light_on(FALSE)
		update_light()
		is_firey = FALSE
		return
	light_range = 10
	light_power = 10
	set_light_on(TRUE)
	update_light()
	is_firey = TRUE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/CheckFed()
	if(IsContained())
		return
	if(!is_fed)
		pulse_damage += 2
		aflame_range += 5
		aflame_damage += 20
	doll_count_maximum += 1
	is_fed = FALSE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(IsContained())//is contained
		return FALSE
	if(M.stat != DEAD)
		return FALSE
	if(do_after(user, 20, target = M))
		if(!ishuman(M) && !istype(M, /mob/living/simple_animal/hostile/doomsday_doll))
			to_chat(user, span_warning("[src] rejects your offering!"))
			return
		if(istype(M ,/mob/living/simple_animal/hostile/doomsday_doll))
			spawned_dolls -= M
		to_chat(user, span_nicegreen("[src] is sated by your offering!"))
		M.gib()
		is_fed = TRUE
		adjustBruteLoss(100)
		pulse_damage -= 1
		playsound(get_turf(src),'sound/effects/limbus_death.ogg', 50, 1)
		AddModifier(/datum/dc_change/sacrificed)

//***Simple Mobs***//
//clay dolls
/mob/living/simple_animal/hostile/doomsday_doll
	name = "doomsday clay doll"
	desc = "A vaguely humanoid figure bearing a heavy clay helmet."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "doomsday_doll"
	icon_living = "doomsday_doll"
	icon_dead = "doomsday_doll_dead"
	speak_emote = list("groans", "moans", "howls", "screeches", "grunts")
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/abnormalities/doomsdaycalendar/Doomsday_Slash.ogg'
	/*Stats*/
	health = 200
	maxHealth = 200
	obj_damage = 50
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 12
	melee_damage_upper = 15
	move_to_delay = 3
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = FALSE
	density = TRUE
	var/list/breach_affected = list()
	var/can_act = TRUE

/mob/living/simple_animal/hostile/doomsday_doll/Initialize()
	. = ..()
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/SpawnAdds()
	var/doll_count = length(spawned_dolls)
	if (doll_count >= doll_count_maximum)
		return
	for(var/i = doll_count, i < doll_count_maximum, i++)//This counts up
		var /mob/living/simple_animal/hostile/doomsday_doll/D= new(get_turf(src))
		spawned_dolls += D
