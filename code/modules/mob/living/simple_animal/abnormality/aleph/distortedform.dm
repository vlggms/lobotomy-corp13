/*
	Coded by Coxswain, sprited by Mr. Heavenly and Mel Taculo
	A monster that turns into other abnormalities,
	roughly as dangerous as white night and as rewarding.
*/
/mob/living/simple_animal/hostile/abnormality/distortedform
	name = "Distorted Form"
	desc = "A manmade horror beyond description."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	maxHealth = 20000
	health = 20000
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/distortedform/slam.ogg'
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL + 1
	icon_state = "distortedform"
	icon_living = "distortedform"
	icon_dead = "distortedform_dead"
	portrait = "distortedform"
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)
	melee_damage_lower = 55
	melee_damage_upper = 65
	move_to_delay = 3
	ranged = TRUE
	pixel_x = -48
	base_pixel_x = -48
	del_on_death = FALSE
	death_message = "reverts into a tiny, disgusting fetus-like creature."
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	can_breach = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 0, 40, 45),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 50, 55),
	)
	start_qliphoth = 3
	work_damage_amount = 4		//Work damage is later
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/armor/distortion,
	)
	gift_type = /datum/ego_gifts/distortion
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

//Work vars
	var/transform_timer
	var/list/transform_blacklist = list(
		/mob/living/simple_animal/hostile/abnormality/hammer_light,
		/mob/living/simple_animal/hostile/abnormality/black_swan,
		/mob/living/simple_animal/hostile/abnormality/fire_bird,
		/mob/living/simple_animal/hostile/abnormality/punishing_bird,
		/mob/living/simple_animal/hostile/abnormality/red_shoes,
		/mob/living/simple_animal/hostile/abnormality/seasons,
		/mob/living/simple_animal/hostile/abnormality/pisc_mermaid.
	)
	var/datum/looping_sound/distortedform/soundloop
	var/transformed = FALSE //We'll use this variable to check for whether or not to play the sound loop
	/// List of melting consoles
	var/list/meltdowns = list()

//Spawning
	var/obj/machinery/door/airlock/vault/connected_door
	var/obj/machinery/containment_panel/connected_panel

//Visuals
	var/obj/viscon_filtereffect/distortedform/current_effect
	var/fakename
	var/fakerisklevel

//Breach vars
	var/breached // what it says on the tin
	/// List of Living People on Breach
	var/list/survivors = list()
	/// Can it perform Another Attack?
	var/can_act = TRUE
	var/can_move = FALSE
	var/can_attack = TRUE
	var/changed = FALSE
	var/transform_cooldown
	var/transform_cooldown_time_short = 4 SECONDS
	var/transform_cooldown_time = 6 SECONDS
	var/transform_cooldown_time_long = 12 SECONDS
	var/list/transform_list = list(
		"Nothing There",
		"Apocalypse bird",
		"Puss in Boots",
		"Crumbling Armor",
		"Hammer of Light",
		"Halberd Apostle",
		"Red Queen",
		"Blubbering Toad",
		"Bloodbath",
		"Price of Silence",
	)
	var/list/transform_list_longrange = list("Doomsday Calendar", "Blue Star", "Der Freischutz", "Apocalypse bird", "Siren")
	var/list/transform_list_jump = list("Light", "Medium", "Heavy")
	var/transform_count = 0
	var/jump_ready = FALSE
	var/special_attack = null
	var/special_attack_cooldown
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/abnormality/distortedform/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/distortedform/PostSpawn()
	..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_FINISHED, PROC_REF(OnMeltdownFinish))
	soundloop.start()
	transform_timer = addtimer(CALLBACK(src, PROC_REF(Transform)), 3 MINUTES, TIMER_STOPPABLE & TIMER_OVERRIDE)

/mob/living/simple_animal/hostile/abnormality/distortedform/FearEffectText(mob/affected_mob, level = 0)
	level = num2text(clamp(level, 1, 5))
	var/list/result_text_list = list(
		"1" = list("There's no room for error here.", "My legs are trembling...", "Damn, it's scary."),
		"2" = list("GODDAMN IT!!!!", "H-Help...", "I don't want to die!"),
		"3" = list("What am I seeing...?", "I-I can't take it...", "I can't understand..."),
		"4" = list("I'm so dead...", "That thing's just a monster!", "I need to get out of here!"),
		"5" = list("Is that what it really looks like?", "It's over...", "I can’t even move my legs..."),
	)
	return pick(result_text_list[level])

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/distortedform/AttemptWork(mob/living/carbon/human/user, work_type)
	if(transformed) // distorted form jumpscare
		UnTransform(TRUE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/distortedform/WorktickFailure(mob/living/carbon/human/user)
	var/list/damtypes = list(RED_DAMAGE,WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	for(var/damagetype in damtypes) // take 4 of every damage type every failed tick
		user.apply_damage(work_damage_amount, damagetype, null, user.run_armor_check(null, damagetype))
	work_damage_type = pick(damtypes) //Displays a random work damage type every tick
	WorkDamageEffect()
	return

/mob/living/simple_animal/hostile/abnormality/distortedform/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/distortedform/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(CauseMelts)), 10) //Delaying it prevents some bugs; call a meltdown on a bad result or failed stat check
	return

/mob/living/simple_animal/hostile/abnormality/distortedform/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 100)
		if(pe > datum_reference.neutral_boxes) // Not work failure, we don't need to call TWO melts
			addtimer(CALLBACK(src, PROC_REF(CauseMelts)), 10)
	return

//Contained Mechanics
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/Transform()
	if(!(IsContained(src)))
		return
	if(datum_reference.working) //If we are being worked on - transform later instead.
		transform_timer = addtimer(CALLBACK(src, PROC_REF(Transform)), 3 MINUTES, TIMER_STOPPABLE & TIMER_OVERRIDE)
		return
	var/list/abno_list = AbnoListGen()
	if(!LAZYLEN(abno_list))
		return
	var/datum/abnormality/abno_datum = pick(abno_list)
	var/mob/living/simple_animal/hostile/abnormality/abno = abno_datum.current
	if(!abno || (abno.health <= 0)) //If the target is dead or otherwise missing, we'll try again in a minute
		transform_timer = addtimer(CALLBACK(src, PROC_REF(Transform)), 1 MINUTES, TIMER_STOPPABLE & TIMER_OVERRIDE)
		return
	soundloop.stop()
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	name = abno.name
	fakename = abno.name
	fakerisklevel = abno.threat_level
	desc = abno.desc
	icon = abno.icon
	icon_state = abno.icon_state
	portrait = abno.portrait
	pixel_x = abno.pixel_x
	base_pixel_x = abno.base_pixel_x
	pixel_y = abno.pixel_y
	base_pixel_y = abno.base_pixel_y
	if(!datum_reference?.console)
		return
	datum_reference.console.updateUsrDialog() //Update the console and change our name into a lie
	transformed = TRUE
	transform_timer = addtimer(CALLBACK(src, PROC_REF(UnTransform)), 1 MINUTES, TIMER_STOPPABLE & TIMER_OVERRIDE)
	update_icon()
	if(!connected_panel) // Update the panel and door so they don't give us away
		for(var/obj/machinery/door/airlock/vault/door in orange(3, src))
			if(door.name == "Distorted Form containment zone")
				connected_door = door
		connected_panel = datum_reference.console.linked_panel
	if(connected_door) //doors can be destroyed
		connected_door.name = "[abno.name] containment zone"
	connected_panel.name = "[abno.name]'s containment panel"

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/UnTransform()
	if(transform_timer)
		transform_timer = null
	soundloop.start() //Change EVERYTHING back to normal
	if(name != initial(name))
		new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	name = initial(name)
	desc = initial(desc)
	icon = initial(icon)
	icon_state = initial(icon_state)
	portrait = initial(portrait)
	pixel_x = initial(pixel_x)
	base_pixel_x = initial(base_pixel_x)
	pixel_y = initial(pixel_y)
	base_pixel_y = initial(base_pixel_y)
	fakename = null
	fakerisklevel = null
	if(!datum_reference?.console)
		return
	datum_reference.console.updateUsrDialog()
	if(connected_door) //doors can be destroyed
		connected_door.name = "Distorted Form containment zone" //Initial() turns it into "vault door"
	connected_panel.name = "Distorted Form's containment panel"
	transformed = FALSE
	transform_timer = addtimer(CALLBACK(src, PROC_REF(Transform)), 3 MINUTES, TIMER_STOPPABLE & TIMER_OVERRIDE)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/AbnoListGen() // List of possible transformations
	. = list()
	if(LAZYLEN(SSlobotomy_corp.all_abnormality_datums))
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			if(isnull(A.current))
				continue
			if(A.abno_path in transform_blacklist)
				continue
			if(A.name != name) //lets not turn into ourselves
				. += A
	return

/mob/living/simple_animal/hostile/abnormality/distortedform/GetName()
	if(fakename)
		return fakename
	return name

/mob/living/simple_animal/hostile/abnormality/distortedform/GetRiskLevel()
	if(fakerisklevel)
		return fakerisklevel
	return threat_level

//Qlipthoth Stuff
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/OnMeltdownFinish(datum/source, datum/abnormality/abno_datum, worked)
	SIGNAL_HANDLER
	if(!worked)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/CauseMelts(datum/source, datum/abnormality/abno_datum, worked)
	var/meltdown_text = "Horrible screeches have caused a disturbance in the containment zones of the following abnormalities:"
	var/meltdown_sound = pick(
		"sound/abnormalities/distortedform/screech3.ogg",
		"sound/abnormalities/distortedform/screech4.ogg",
	)
	var/player_count = 0
	for(var/mob/player in GLOB.player_list)
		if(isliving(player) && (player.mind?.assigned_role in GLOB.security_positions))
			player_count += 1.5
	player_count = round(player_count) + (player_count > round(player_count) ? TRUE : FALSE) // Trying to round up
	meltdowns = SSlobotomy_corp.InitiateMeltdown(clamp(rand(player_count*0.5, player_count), 1, 10), TRUE, MELTDOWN_BLACK, 45, 60, meltdown_text, meltdown_sound)
	for(var/obj/machinery/computer/abnormality/A in meltdowns) // TODO: Figure out a way to exclude it entirely from melts so it doesn't breach itself.
		if(A == datum_reference.console) // TODO: This shouldn't be neccessary when I fix the above comment
			continue
		RegisterSignal(A, COMSIG_MELTDOWN_FINISHED, PROC_REF(SpecialMeltFinish))

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/SpecialMeltFinish(datum/source, datum/abnormality/abno_datum, worked)
	SIGNAL_HANDLER
	if(!LAZYLEN(meltdowns))
		return
	meltdowns -= source
	UnregisterSignal(source, COMSIG_MELTDOWN_FINISHED)
	var/list/breaching_list = shuffle(GLOB.abnormality_mob_list)
	if(!worked)
		for(var/mob/living/simple_animal/hostile/abnormality/A in breaching_list)
			if(A.datum_reference.qliphoth_meter > 0 && A.IsContained() && A.z == z)
				A.datum_reference.qliphoth_change(-200)
				return

//Breach
/mob/living/simple_animal/hostile/abnormality/distortedform/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(breached)
		return
	breached = TRUE
	if(transformed)
		UnTransform(TRUE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_FINISHED)
	sound_to_playing_players_on_level("sound/abnormalities/distortedform/screech1.ogg", 85, zlevel = z)
	for(var/mob/M in GLOB.player_list)
		if(isnewplayer(M))
			continue
		var/check_z = M.z
		if(isatom(M.loc))
			check_z = M.loc.z // So it plays even when you are in a locker/sleeper
		if((check_z == z) && M.client)
			to_chat(M, span_userdanger("Horrifying screams come from out of the darkness!"))
			flash_color(M, flash_color = COLOR_ALMOST_BLACK, flash_time = 80)
		if(M.stat != DEAD && ishuman(M) && M.ckey)
			survivors += M
	can_act = FALSE
	addtimer(CALLBACK(src, PROC_REF(GoActive)), 50)
	addtimer(CALLBACK(src, PROC_REF(BreachAudioFX)), 45)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/GoActive(mob/living/carbon/human/user)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/BreachAudioFX(mob/living/carbon/human/user)
	sound_to_playing_players_on_level("sound/abnormalities/distortedform/screech2.ogg", 85, zlevel = z)

/mob/living/simple_animal/hostile/abnormality/distortedform/death(gibbed)
	if(changed)
		ChangeForm()
	can_act = FALSE
	icon_state = icon_dead
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	desc = "A gross, pathetic looking thing that was once a terrible monster."
	pixel_x = 0
	base_pixel_x = 0
	pixel_y = 0
	base_pixel_y = 0
	density = FALSE
	playsound(src, 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 60, 1)
	animate(src, transform = matrix()*0.6,time = 0)
	for(var/mob/living/carbon/human/survivor in survivors)
		if(survivor.stat == DEAD || !survivor.ckey)
			continue
		survivor.Apply_Gift(new /datum/ego_gifts/fervor)
		survivor.playsound_local(get_turf(survivor), 'sound/weapons/black_silence/snap.ogg', 50)
		to_chat(survivor, span_userdanger("The screams subside - you recieve a gift!"))
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	new /obj/item/ego_weapon/shield/distortion(get_turf(src))
	..()

/mob/living/simple_animal/hostile/abnormality/distortedform/Move()
	if(!can_move || !can_act)
		return FALSE
	if(name == "Nothing There")
		playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3)
	return ..()

/mob/living/simple_animal/hostile/abnormality/distortedform/Moved()
	. = ..()
	MoveVFX()

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/MoveVFX()
	set waitfor = FALSE
	var/obj/viscon_filtereffect/distortedform_trail/trail = new(src.loc,themob = src, waittime = 5)
	trail.vis_contents += src
	trail.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=2, color=rgb(0, 250, 229))
	trail.filters += filter(type = "blur", size = 3)
	animate(trail, alpha=120)
	animate(alpha = 0, time = 10)

/mob/living/simple_animal/hostile/abnormality/distortedform/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return
	if(!can_act) //Don't transform mid-attack
		return
	if(transform_cooldown > world.time)
		return
	if(changed && (transform_count >= 3)) //change back into our base form
		transform_count = 0
		ChangeForm()
		return
	var/punishment = TRUE
	var/transform_target
	for(var/mob/living/L in livinginrange(15, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		if((L.stat == DEAD) || (L.status_flags & GODMODE))
			continue
		punishment = FALSE
		break
	if(punishment && !jump_ready) //No one is within 15 tiles? Let's just snipe players instead!
		transform_target = pick(transform_list_longrange)
		jump_ready = TRUE
	else if (jump_ready)
		transform_target = "Jump"
		jump_ready = FALSE
	else
		transform_target = pick(transform_list)
		if(prob(1))
			transform_target = "Pause"
	ChangeForm(transform_target)
	transform_count += 1

//Attacks
/mob/living/simple_animal/hostile/abnormality/distortedform/CanAttack(atom/the_target)
	if(!can_attack || !can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/distortedform/OpenFire()
	if(!can_act)
		return
	if(special_attack_cooldown > world.time)
		return
	if(special_attack)
		if(target)
			call(src, special_attack)(target)
		else
			call(src, special_attack)()
	return

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeForm(form)
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	TurnNormal() //reset offsets/icon/resistances
	clear_filters()
	vis_contents.Cut()
	current_effect = null
	SLEEP_CHECK_DEATH(1)
	if(!form)
		TurnNormal(TRUE)
		changed = FALSE
		return
	switch(form)
		if("Nothing There")
			ChangeNT()
		if("Puss in Boots")
			ChangeCat()
		if("Crumbling Armor")
			ChangeArmor()
		if("Hammer of Light")
			ChangeHammer()
		if("Halberd Apostle")
			ChangeApostle()
		if("Red Queen")
			ChangeQueen()
		if("Blubbering Toad")
			ChangeToad()
		if("Bloodbath")
			ChangeBloodBath()
		if("Price of Silence")
			ChangePrice()
		if("Doomsday Calendar")
			ChangeCalander()
		if("Blue Star")
			ChangeStar()
		if("Der Freischutz")
			ChangeDer()
		if("Siren")
			ChangeSiren()
		if("Apocalypse bird")
			ChangeApoc()
		if("Jump")
			ReadyJump()
		if("Pause") // Unused for now
			Pause()
	changed = TRUE
	DFApplyFilters()

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFApplyFilters()
//Filter stuff - Generates a randomized displacement of the icon's sprites
	var/icon/filter_icon = new(icon, icon_state)
	var/newcolor = pick(COLOR_RED, COLOR_BLUE, COLOR_YELLOW, COLOR_GREEN, COLOR_PURPLE, COLOR_ORANGE)
	filter_icon.Blend(newcolor,ICON_MULTIPLY)
	filters += filter(type="displace", size=3, icon=filter_icon, render_source = src)
	alpha = rand(150,255)
	qdel(filter_icon)
	current_effect = new() //Visual contents - An animation underlay for the icon
	current_effect.icon = icon
	current_effect.icon_state = icon_state
	current_effect.vis_flags |= VIS_UNDERLAY
	src.vis_contents += current_effect
	current_effect.render_target = "displace"
	var/size = rand(-5,5)
	var/size_end = rand(-10,10)
	current_effect.color = rgb(rand(120,255), rand(120,255), rand(120,255), rand(120,160))
	current_effect.filters += filter(type="displace", size=rand(5,10), render_source="displace")
	var/f1 = current_effect.filters[current_effect.filters.len]
	animate(f1, size = size,time=10,loop=-1)
	animate(size = size_end, time=10)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/TurnNormal(newicon) //We'll use the variable to see if this is just an icon update or an actual transformation
	name = "Distorted Form"
	desc = "A manmade horror beyond description."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = null // We can change this into a between-frame for transformation when I have one
	pixel_x = initial(pixel_x)
	base_pixel_x = initial(base_pixel_x)
	pixel_y = initial(pixel_y)
	base_pixel_y = initial(base_pixel_y)
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/distortedform/slam.ogg'
	melee_damage_type = RED_DAMAGE
	ChangeResistances(list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8))
	melee_damage_lower = 55
	melee_damage_upper = 65
	rapid_melee = 1
	can_move = FALSE
	can_attack = TRUE
	special_attack = null
	alpha = 255
	color = null
	update_icon()
	if(!newicon)
		return
	icon_state = icon_living
	addtimer(CALLBACK(src, PROC_REF(DFScreech)), 10)
	addtimer(CALLBACK(src, PROC_REF(DFAttack)), 60) //We call DFAttack() which picks one of four attacks
	transform_cooldown = transform_cooldown_time + world.time

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFScreech()
	if(!can_act)
		return
	playsound(src, "sound/abnormalities/distortedform/screech4.ogg", 75, FALSE, 8)
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
		for(var/mob/living/L in view(8, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(5, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFAttack()
	if(!can_act)
		return
	var/list/target_list = list()
	for(var/mob/living/L in livinginrange(10, src))
		if(L.z != z || (L.status_flags & GODMODE))
			continue
		if(faction_check_mob(L, FALSE))
			continue
		target_list += L

	if(!target)
		if(LAZYLEN(target_list))
			target = pick(target_list)

	if(!target || !ishuman(target) || QDELETED(target) || (target_list.len < 2) || prob(50))
		if(prob(50))
			DFLine() //Safe in the middle, unsafe outside
		else
			DFSlam() //Your usual run of the mill AOE, safe in the middle
		return

	if(prob(50))
		DFSpread(target) //Everyone has to stand far away from eachother. or die.
	else
		DFStack(target) //Everyone has to bunch up together. or die.

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFLine(combo)
	can_act = FALSE
	var/turf/area_of_effect = list()
	for(var/turf/L in view(10, src))
		if((get_dist(src, L) > 2))
			if((L.x != x) && (L.y != y) && (L.x != (x - 1)) && (L.x != (x + 1)) && (L.y != (y - 1)) && (L.y != (y + 1)))
				continue
		new /obj/effect/temp_visual/cult/sparks(L)
		area_of_effect += L
	playsound(get_turf(src), 'sound/abnormalities/armyinblack/black_attack.ogg', 50, 0, 5)
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 150, WHITE_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.health <= 0)
				H.gib()
	playsound(get_turf(src), 'ModularTegustation/Tegusounds/claw/prepare.ogg', 50, 0, 5)
	visible_message(span_danger("[src] releases a strange mist!"))
	// Shake effect
	for(var/mob/living/M in livinginrange(20, get_turf(src)))
		shake_camera(M, 2, 3)
	SLEEP_CHECK_DEATH(3)
	if(!combo)
		DFSlam(TRUE)
		return
	can_act = TRUE
	transform_cooldown = world.time

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFSlam(combo)
	can_act = FALSE
	var/turf/area_of_effect = list()
	for(var/turf/L in view(7, src))
		if((get_dist(src, L) > 1))
			if((L.x == x) || (L.y == y))
				continue
		new /obj/effect/temp_visual/cult/sparks(L)
		area_of_effect += L
	playsound(get_turf(src), 'sound/abnormalities/apocalypse/pre_attack.ogg', 50, 0, 5) // todo: find a better sfx set
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in area_of_effect)
		var/obj/effect/temp_visual/smash_effect/bloodeffect =  new(T)
		bloodeffect.color = "#b52e19"
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 150, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.sanity_lost)
				H.gib()
	playsound(get_turf(src), 'sound/abnormalities/apocalypse/slam.ogg', 50, 0, 5)
	visible_message(span_danger("[src] slams at the floor!"))
	// Shake effect
	for(var/mob/living/M in livinginrange(20, get_turf(src)))
		shake_camera(M, 2, 3)
	SLEEP_CHECK_DEATH(3)
	if(!combo)
		DFLine(TRUE)
		return
	can_act = TRUE
	transform_cooldown = world.time

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFSpread(mob/living/carbon/human/target)
	if(!isliving(target))
		DFLine()
		return
	can_act = FALSE
	playsound(src, 'sound/abnormalities/ichthys/charge.ogg', 75, 1)
	face_atom(target)
	var/list/potential_targets = list()
	var/list/chosen_targets = list()
	var/mob/living/Y
	potential_targets += target
	for(var/mob/living/L in view(10, src))
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || z != L.z || (L.status_flags & GODMODE)) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(L == target)
			continue
		potential_targets += L
		if((LAZYLEN(potential_targets)) > 5)
			break
	for(var/i = LAZYLEN(potential_targets), i >= 1, i--)
		if(potential_targets.len <= 0)
			break
		Y = pick(potential_targets)
		potential_targets -= Y
		if(Y.stat == DEAD) //they chose to die instead of facing the fear
			continue
		Y.add_overlay(icon('icons/effects/effects.dmi', "spreadwarning"))
		addtimer(CALLBACK(Y, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('icons/effects/effects.dmi', "spreadwarning")), 45)
		chosen_targets += Y

	SLEEP_CHECK_DEATH(10)
	if(prob(50))
		DFLine(TRUE)
	else
		DFSlam(TRUE)
	SLEEP_CHECK_DEATH(40)
	for(var/i = LAZYLEN(chosen_targets), i >= 1, i--)
		if(chosen_targets.len <= 0)
			break
		Y = pick(chosen_targets)
		chosen_targets -= Y
		if(Y.stat == DEAD) //they chose to die instead of facing the fear
			continue
		DFSpreadAttack(Y)
	can_act = TRUE
	transform_cooldown = world.time

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFSpreadAttack(mob/living/carbon/human/target)
	playsound(target, 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 80, FALSE, -3)
	new /obj/effect/gibspawner/generic/silent/wrath_acid(get_turf(target))
	for(var/turf/T in range(1, target))
		new /obj/effect/temp_visual/mustardgas(T)
	var/list/target_list = list()
	for(var/mob/living/L in livinginrange(1, target))
		if(L.z != z || (L.status_flags & GODMODE))
			continue
		if(faction_check_mob(L, FALSE))
			continue
		L.apply_damage(20, BLACK_DAMAGE, null, target.run_armor_check(null, BLACK_DAMAGE))
		if(target == L)
			continue
		target_list += L

	if(LAZYLEN(target_list))
		target_list += target
		for(var/mob/living/L in target_list)
			L.apply_damage(300, BLACK_DAMAGE, null, target.run_armor_check(null, BLACK_DAMAGE)) //You - you are probably going to die!
			if(L.health < 0)
				L.gib() //maybe someday we'll have a cool acid melting animation for this

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DFStack(mob/living/carbon/human/target)
	if((!isliving(target)) || (!(target in view(src, 10))))
		DFSlam()
		return
	can_act = FALSE
	playsound(target, 'sound/abnormalities/fairy_longlegs/attack.ogg', 50, FALSE)
	face_atom(target)
	target.Immobilize(55)
	if(target.sanity_lost)
		target.Stun(55) //Immobilize does not stop AI controllers from moving, for some reason.
	target.add_overlay(icon('icons/effects/effects.dmi', "distortedgrab"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "distortedgrab")), 50)
	if(get_dist(src, target) > 3)
		var/list/all_turfs = RANGE_TURFS(1, src) //We need to grab the player, but also have them be visible.
		for(var/turf/T in all_turfs)
			if(T == get_turf(src))
				continue
			if(get_dir(src,T) == NORTH) //directly north is icky, blocks view.
				continue
			var/list/target_line = getline(T, src)
			var/available_turf
			for(var/turf/line_turf in target_line)
				if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
					available_turf = FALSE
					break
				available_turf = TRUE
			if(!available_turf)
				continue
			target.forceMove(T)
			break
	SLEEP_CHECK_DEATH(5)
	new/obj/effect/temp_visual/distortedwarning(get_turf(target))
	playsound(src, 'sound/abnormalities/crying_children/sorrow_charge.ogg', 50, FALSE, 5)
	SLEEP_CHECK_DEATH(50)
	playsound(target, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 50, FALSE)
	new /obj/effect/temp_visual/beam_in_giant(get_turf(target))
	var/list/target_list = list()
	for(var/mob/living/L in livinginrange(2, target))
		if(L.z != z || (L.status_flags & GODMODE))
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(target == L)
			continue
		target_list += L

	if(LAZYLEN(target_list))
		target_list += target
		var/total_damage = 30 //There will very rarely be over 2 people in the stack
		var/new_damage = total_damage / (target_list.len)
		for(var/mob/living/L in target_list)
			L.apply_damage(new_damage, PALE_DAMAGE, null, target.run_armor_check(null, PALE_DAMAGE))
			if(L.health < 0)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					H.dust()
				else
					L.gib()
	else
		target.apply_damage(250, PALE_DAMAGE, null, target.run_armor_check(null, PALE_DAMAGE)) //You - you are probably going to die!
		if(target.health < 0)
			target.dust()
	can_act = TRUE
	transform_cooldown = world.time

//Nothing There
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeNT()
	transform_cooldown = transform_cooldown_time_long + world.time
	name = "Nothing There"
	desc = "A wicked creature that consists of various human body parts and organs."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "nothing"
	pixel_x = -16
	base_pixel_x = -16
	attack_verb_continuous = "strikes"
	attack_verb_simple = "strike"
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8))
	melee_damage_lower = 65
	melee_damage_upper = 75
	move_to_delay = 4.5
	UpdateSpeed()
	can_move = TRUE
	addtimer(CALLBACK(src, PROC_REF(Goodbye)), 30)
	special_attack = PROC_REF(Hello)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/Goodbye()
	if(!can_act)
		return
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, FALSE, 5)
	icon_state = "nothing_blade"
	SLEEP_CHECK_DEATH(8)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/nt_goodbye(T)
		for(var/mob/living/L in HurtInTurf(T, list(), 500, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE))
			if(L.health < 0)
				L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, FALSE, 7)
	SLEEP_CHECK_DEATH(3)
	icon_state = "nothing"
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/Hello(target)
	if(!can_act)
		return
	if(!target)
		return
	special_attack_cooldown = world.time + 6 SECONDS
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_cast.ogg', 75, FALSE, 3)
	icon_state = "nothing_ranged"
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/hello_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(hello_delay)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, 120, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3)
	icon_state = "nothing"
	can_act = TRUE

//Puss in Boots
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeCat()
	transform_cooldown = transform_cooldown_time_long + world.time
	name = "Puss in Boots"
	desc = "A scraggly looking black cat, it seems like the boots are missing."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "cat_breached"
	pixel_x = 0
	base_pixel_x = 0
	attack_sound = 'sound/weapons/ego/rapier1.ogg'
	melee_damage_lower = 17
	melee_damage_upper = 25
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	rapid_melee = 4
	move_to_delay = 2.5
	UpdateSpeed()
	can_move = TRUE
	can_attack = TRUE
	special_attack = PROC_REF(Execute)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/Execute(target) //Puss in boots execute but it hits up to 5 people with 300 pale. Youch!
	if(!can_act)
		return
	if(!isliving(target))
		return
	special_attack_cooldown = world.time + 10 SECONDS
	can_act = FALSE
	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, 1)
	face_atom(target)
	var/list/potential_targets = list()
	var/list/chosen_targets = list()
	var/mob/living/Y
	potential_targets += target
	for(var/mob/living/L in view(10, src))
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || z != L.z || (L.status_flags & GODMODE)) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(L == target)
			continue
		potential_targets += L
		if((LAZYLEN(potential_targets)) > 5)
			break
	for(var/i = LAZYLEN(potential_targets), i >= 1, i--)
		if(potential_targets.len <= 0)
			break
		Y = pick(potential_targets)
		potential_targets -= Y
		if(Y.stat == DEAD) //they chose to die instead of facing the fear
			continue
		Y.add_overlay(icon('icons/effects/effects.dmi', "zorowarning"))
		addtimer(CALLBACK(Y, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('icons/effects/effects.dmi', "zorowarning")), 40)
		chosen_targets += Y
	SLEEP_CHECK_DEATH(35)
	for(var/i = LAZYLEN(chosen_targets), i >= 1, i--)
		if(chosen_targets.len <= 0)
			break
		Y = pick(chosen_targets)
		chosen_targets -= Y
		if(Y.stat == DEAD) //they chose to die instead of facing the fear
			continue
		if(!(Y in view(src, 8)))
			continue
		var/turf/jump_turf = get_step(Y, pick(GLOB.alldirs))
		if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
			jump_turf = get_turf(Y)
		Y.add_overlay(icon('icons/effects/effects.dmi', "zoro"))
		addtimer(CALLBACK(Y, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('icons/effects/effects.dmi', "zoro")), 14)
		playsound(Y, 'sound/abnormalities/pussinboots/slash.ogg', 50, FALSE, 2)
		forceMove(jump_turf)
		if(ishuman(Y))
			var/mob/living/carbon/human/H = Y
			H.Stun(9)
		SLEEP_CHECK_DEATH(3)
		playsound(Y, 'sound/abnormalities/pussinboots/counterslash.ogg', 50, FALSE, 2)
		SLEEP_CHECK_DEATH(6)
		playsound(Y, 'sound/abnormalities/crumbling/attack.ogg', 50, TRUE)
		Finisher(Y)
	can_act = TRUE
	icon_state = "cat_breached"
	transform_cooldown = world.time

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/Finisher(mob/living/target)
	to_chat(target, span_danger("[src] is trying to cut you in half!"))
	if(!ishuman(target))
		target.apply_damage(150, PALE_DAMAGE, null, target.run_armor_check(null, PALE_DAMAGE)) //bit more than usual DPS in pale damage
		return
	target.apply_damage(500, RED_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE)) //You are probably going to die!
	if(target.health > 0)
		return
	var/mob/living/carbon/human/H = target
	new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
	H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
	H.gib()

//Crumbling Armor
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeArmor()
	transform_cooldown = transform_cooldown_time_short + world.time
	name = "Crumbling Armor"
	desc = "A thoroughly aged suit of samurai style armor with a V shaped crest on the helmet. It appears desuetude."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "crumbling"
	ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.2))
	pixel_x = 0
	base_pixel_x = 0
	can_move = FALSE
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(CrumblingArmorAttack)), 20)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/CrumblingArmorAttack()
	for(var/mob/living/L in livinginrange(10, src))
		if(L.z != z || (L.status_flags & GODMODE))
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(!ishuman(L))
			playsound(get_turf(L), 'sound/abnormalities/crumbling/attack.ogg', 50, FALSE)
			L.apply_damage(50, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/slice(get_turf(L))
		else
			var/mob/living/carbon/human/H = L
			playsound(get_turf(H), 'sound/abnormalities/crumbling/warning.ogg', 50, FALSE, -3)
			to_chat(H, span_userdanger("Show me that you can stand your ground!"))
			new /obj/effect/temp_visual/markedfordeath(get_turf(H))
			H.apply_status_effect(/datum/status_effect/cowardice)
			var/datum/status_effect/cowardice/C = H.has_status_effect(/datum/status_effect/cowardice)
			C.punishment_damage = 60

//Hammer of Light
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeHammer()
	transform_cooldown = transform_cooldown_time_short + world.time
	name = "Hammer of Light"
	desc = "A white specter carrying a white hammer engraved with yellow runic writing."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "hammer_distorted"
	ChangeResistances(list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0))
	pixel_x = -16
	base_pixel_x = -16
	can_attack = FALSE
	can_move = FALSE
	can_act = FALSE //we stay transformed until the attack finishes firing
	playsound(get_turf(src), 'sound/abnormalities/lighthammer/chain.ogg', 75, FALSE, 7)
	addtimer(CALLBACK(src, PROC_REF(HammerOfLightAttack)), 20)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/HammerOfLightAttack()
	playsound(src, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 50, FALSE, 7)
	var/targetAmount = 0
	for(var/mob/living/L in livinginrange(10, src))
		if(L.z != z || (L.status_flags & GODMODE))
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if (targetAmount <= 5)
			++targetAmount
			if(!ishuman(L))
				new /obj/effect/temp_visual/beam_in(get_turf(L))
				L.apply_damage(60, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
				if(L.health < 0)
					L.gib()
			else
				var/obj/effect/lightbolt/light = new /obj/effect/lightbolt(get_turf(L))//do this for the # of targets + 1
				light.target = L
	targetAmount = 0
	can_act = TRUE

/obj/effect/lightbolt	//lightbolt objects
	name = "light bolt"
	desc = "LOOK OUT!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "lightwarning"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER	//Sprite should always be visible
	var/boom_damage = 50
	var/mob/living/carbon/human/target
	var/times_hit = 0

/obj/effect/lightbolt/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 2 SECONDS)

/obj/effect/lightbolt/proc/explode()
	playsound(get_turf(src), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, FALSE, -3)
	for(var/mob/living/carbon/human/H in view(1, src))
		H.apply_damage(boom_damage, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		if(H.health < 0)
			H.dust()
	new /obj/effect/temp_visual/beam_in(get_turf(src))
	times_hit ++
	if(times_hit >= 3)
		qdel(src)
		return
	if(target) //not movable so we cannot forcemove()
		var/obj/effect/lightbolt/light = new /obj/effect/lightbolt(get_turf(target))
		light.target = target
		light.times_hit = times_hit
	qdel(src)

//White Night Apostle
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeApostle()
	transform_cooldown = transform_cooldown_time_long + world.time
	name = "Halberd Apostle"
	desc = "A disformed human wielding a halberd."
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/abnormalities/whitenight/scythe.ogg'
	icon_state = "apostle_halberd"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	ChangeResistances(list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.4))
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 25
	melee_damage_upper = 30
	pixel_x = -8
	base_pixel_x = -8
	move_to_delay = 5
	can_move = TRUE
	special_attack = PROC_REF(SpearAttack)
	addtimer(CALLBACK(src, PROC_REF(ScytheAttack)), 30)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ScytheAttack()
	if(!can_act)
		return
	can_act = FALSE
	for(var/turf/T in view(3, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(10)
	var/gibbed = FALSE
	for(var/turf/T in view(3, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T) // Does not gib pre-dead bodies, only living ones.
			if(L.stat == DEAD)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(150, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if(L.stat == DEAD)
				for(var/i = 1 to 5) // Eventually turn this into a horizontal bisect. That would be cool.
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
				new /obj/effect/gibspawner/generic/silent(get_turf(L))
				gibbed = TRUE
	playsound(get_turf(src), (gibbed ? 'sound/abnormalities/whitenight/scythe_gib.ogg' : 'sound/abnormalities/whitenight/scythe_spell.ogg'), (gibbed ? 100 : 75), FALSE, (gibbed ? 12 : 5))
	SLEEP_CHECK_DEATH(5)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/SpearAttack(target)
	can_act = FALSE
	var/dir_to_target = get_dir(src, target)
	var/turf/T = get_turf(src)
	for(var/i = 1 to 50)
		T = get_step(T, dir_to_target)
		if(T.density)
			if(i < 4) // Mob attempted to dash into a wall too close, stop it
				can_act = TRUE
				return
			break
		new /obj/effect/temp_visual/cult/sparks(T)
	special_attack_cooldown = world.time + 10 SECONDS
	playsound(get_turf(src), 'sound/abnormalities/whitenight/spear_charge.ogg', 75, FALSE, 5)
	SLEEP_CHECK_DEATH(22)
	been_hit = list()
	playsound(get_turf(src), 'sound/abnormalities/whitenight/spear_dash.ogg', 100, FALSE, 20)
	do_dash(dir_to_target, 0)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/do_dash(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= 50)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		transform_cooldown += 1 SECONDS
		can_act = TRUE
		addtimer(CALLBACK(src, PROC_REF(ScytheAttack)), 5)
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("holy spear")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK (D, TYPE_PROC_REF(/obj/machinery/door, open)))
	if(stop_charge)
		transform_cooldown += 1 SECONDS
		can_act = TRUE
		addtimer(CALLBACK(src, PROC_REF(ScytheAttack)), 5)
		return
	forceMove(T)
	for(var/turf/TF in view(1, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
		var/list/new_hits = HurtInTurf(T, been_hit, 250, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			visible_message(span_boldwarning("[src] runs through [L]!"), span_nicegreen("You impaled heretic [L]!"))
			new /obj/effect/temp_visual/cleave(get_turf(L))
	addtimer(CALLBACK(src, PROC_REF(do_dash), move_dir, (times_ran + 1)), 0.5) // SPEED

//Red Queen
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeQueen()
	name = "Red Queen"
	desc = "A noble red abnormality sitting in her chair."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "redqueen"
	pixel_x = -8
	base_pixel_x = -8
	can_move = FALSE
	can_attack = FALSE
	can_act = FALSE //we stay transformed until the skill finishes firing
	var/target_counter = 0
	for(var/mob/living/L in orange(6, get_turf(src)))
		if(faction_check_mob(L, FALSE) || L.stat == DEAD || target_counter >= 2) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(L.status_flags & GODMODE) //no aiming for cleanbots
			continue
		QueenAttack(L)
		target_counter += 1
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/QueenAttack(target)
	set waitfor = FALSE
	if(!target)
		return
	playsound(get_turf(src), 'sound/weapons/fixer/generic/sheath2.ogg', 75, FALSE, 5)
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/slash_delay = (get_dist(src, target) <= 2) ? (1.5 SECONDS) : (1 SECONDS)
	SLEEP_CHECK_DEATH(slash_delay)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, 80, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			if(!ishuman(L))
				L.gib()
			else
				var/mob/living/carbon/human/H = L
				var/obj/item/bodypart/head/head = H.get_bodypart("head")
				//OFF WITH HIS HEAD!
				if(!istype(head))
					return FALSE
				head.dismember()
	playsound(get_turf(src), 'sound/weapons/guillotine.ogg', 100, FALSE, 6)

//Blubbering Toad
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeToad()
	transform_cooldown = transform_cooldown_time_long + world.time
	name = "Blubbering Toad"
	desc = "A giant toad, wailing with tears in its eyes. The tears are thick, like a blue resin. This one seems to be missing an eye."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "blubbering_red"
	ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.8))
	melee_damage_type = BLACK_DAMAGE
	pixel_x = -16
	base_pixel_x = -16
	attack_sound = 'sound/abnormalities/blubbering_toad/attack.ogg'
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"
	UpdateSpeed()
	can_move = TRUE
	special_attack = PROC_REF(ToadAttack)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ToadAttack()
	if(!can_act)
		return
	if(!target)
		return
	var/dist = get_dist(target, src)
	if((dist > 2) && (dist < 5))
		TongueAttack(target)
	if(dist >= 5)
		ToadJump(target)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ToadJump(mob/living/target)
	special_attack_cooldown = world.time + 6 SECONDS
	can_act = FALSE
	animate(src, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
	src.pixel_z = 16
	playsound(src, 'sound/abnormalities/blubbering_toad/windup.ogg', 50, FALSE, 4)
	var/turf/target_turf = get_turf(target)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	forceMove(target_turf) //look out, someone is rushing you!
	animate(src, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
	src.pixel_z = 0
	for(var/turf/T in view(1, src))
		var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
		FX.color = "#0A1172"
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(50, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.gib()
	playsound(src, 'sound/abnormalities/blubbering_toad/attack.ogg', 50, FALSE, 4)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/TongueAttack(mob/living/target)
	special_attack_cooldown = world.time + 2 SECONDS
	can_act = FALSE
	var/turf/target_turf = get_turf(target)
	var/list/turfs_to_hit = getline(src, target_turf)
	var/turf/MT = get_turf(src)
	playsound(get_turf(src), "sound/abnormalities/blubbering_toad/tongue.ogg", 100, FALSE)
	MT.Beam(target_turf, "tongue", time=5)
	icon_state = "blubbering_tongue_red"
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		for(var/mob/living/L in T)
			if(L.z != z)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(30, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(MT, rand(1, 2), whack_speed, src)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.gib()
	SLEEP_CHECK_DEATH(5)
	can_act = TRUE
	icon_state = "blubbering_red"

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeBloodBath()
	transform_cooldown = transform_cooldown_time_long + world.time
	name = "Bloodbath"
	desc = "A large humanoid made of blood"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "bloodbath_DF"
	ChangeResistances(list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8))
	melee_damage_lower = 65
	melee_damage_upper = 75
	move_to_delay = 4.5
	melee_damage_type = WHITE_DAMAGE
	pixel_x = -8
	base_pixel_x = -8
	attack_sound = 'sound/abnormalities/ichthys/slap.ogg'
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"
	UpdateSpeed()
	can_move = TRUE
	addtimer(CALLBACK(src, PROC_REF(BloodBathBeamPrep)), 30)
	special_attack = PROC_REF(BloodBathSlam)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/BloodBathBeamPrep()
	if(!can_act)
		return FALSE
	can_act = FALSE
	var/target_counter = 0
	for(var/mob/living/L in view(10, get_turf(src)))
		if(faction_check_mob(L, FALSE) || L.stat == DEAD || target_counter >= 3) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(L.status_flags & GODMODE)
			continue
		BloodBathBeam(L)
		target_counter += 1
	SLEEP_CHECK_DEATH(2 SECONDS) //Delay VFX
	if(target_counter)
		for(var/turf/T in view(1, src))
			var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
			FX.color = "#b52e19"
	SLEEP_CHECK_DEATH(2 SECONDS) //Rest after laser beam
	icon_state = "bloodbath_DF"
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/BloodBathBeam(target_mob) //Headless Ichthys beam, but lots of them.
	set waitfor = FALSE
	if(!target_mob)
		return FALSE
	var/datum/beam/current_beam
	icon_state = "bloodbath_slamprepare"
	var/turf/target_turf = get_turf(target_mob)
	face_atom(target_turf)
	var/turf/my_turf = get_turf(src)
	playsound(src, "sound/abnormalities/ichthys/charge.ogg", 50, FALSE)
	var/turf/TT = get_ranged_target_turf_direct(my_turf, target_turf, 15)
	SLEEP_CHECK_DEATH(2 SECONDS) //Chargin' mah lazor
	icon_state = "bloodbath_slam"
	var/list/target_line = getline(my_turf, TT) //gets a line 15 tiles away
	for(var/turf/TF in target_line) //checks if that line has anything in the way, resets TT as the new beam end location
		if(TF.density)
			TT = TF
			break
	var/list/hit_line = getline(my_turf, TT) //old target_line is discarded with hit_line which respects walls
	for(var/turf/TF in hit_line) //spawns blood effects, separate loop because we only want to do it once
		if(TF.density)
			break
		var/obj/effect/decal/cleanable/blood/B  = new(TF)
		B.bloodiness = 100
	current_beam = my_turf.Beam(TT, "qoh")
	playsound(src, "sound/abnormalities/ichthys/blast.ogg", 50, FALSE)
	for(var/h = 1 to 20) //from this point on it's basically the same as queenie's but with balance adjustments
		var/list/already_hit = list()
		current_beam.visuals.color = COLOR_RED
		for(var/turf/TF in hit_line)
			if(TF.density)
				break
			for(var/mob/living/L in range(1, TF))
				if(L.status_flags & GODMODE)
					continue
				if(L == src) //stop hitting yourself
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				if(faction_check_mob(L))
					continue
				already_hit += L
				var/truedamage = ishuman(L) ? 25 : 20 //less damage dealt to nonhumans
				L.apply_damage(truedamage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		SLEEP_CHECK_DEATH(1.71)
	QDEL_NULL(current_beam)
	SLEEP_CHECK_DEATH(1 SECONDS) //Rest after laser beam
	icon_state = "bloodbath_DF"

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/BloodBathSlam()//AOE attack
	if(!can_act)
		return
	special_attack_cooldown = world.time + 3 SECONDS
	can_act = FALSE
	for(var/turf/L in view(3, src))
		new /obj/effect/temp_visual/cult/sparks(L)
	playsound(get_turf(src), 'sound/abnormalities/ichthys/jump.ogg', 100, FALSE, 6)
	icon_state = "bloodbath_slamprepare"
	SLEEP_CHECK_DEATH(12)
	for(var/turf/T in view(3, src))
		var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
		FX.color = "#b52e19"
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 350, WHITE_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.sanity_lost)
				H.gib()
	playsound(get_turf(src), 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 125, FALSE, 6)
	icon_state = "bloodbath_slam"
	SLEEP_CHECK_DEATH(3)
	icon_state = "bloodbath_DF"
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangePrice()
	transform_cooldown = transform_cooldown_time + world.time
	name = "The Price of Silence"
	desc = "A scythe with a clock attached, quietly ticking."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "silence"
	ChangeResistances(list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0))
	pixel_x = 0
	base_pixel_x = 0
	can_move = FALSE
	can_attack = FALSE
	can_act = FALSE //we stay transformed until the skill finishes firing
	var/target_counter = 0
	playsound(src, 'sound/abnormalities/silence/ambience.ogg', 75, TRUE, -1)
	SLEEP_CHECK_DEATH(1.5)
	for(var/mob/living/L in orange(7, get_turf(src)))
		if(faction_check_mob(L, FALSE) || L.stat == DEAD || target_counter >= 5) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(L.status_flags & GODMODE) //no aiming for cleanbots
			continue
		PriceOfSilenceAttack(L)
		target_counter += 1
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/PriceOfSilenceAttack(mob/living/target)
	set waitfor = FALSE
	if(!target)
		return
	playsound(target, 'sound/weapons/ego/price_of_silence.ogg', 25, FALSE, 9)
	target.add_overlay(icon('icons/effects/effects.dmi', "chronofield"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "chronofield")), 40)
	addtimer(CALLBACK(src, PROC_REF(FreezeMob), target), 40)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/FreezeMob(mob/living/H)
	if(!H)
		return
	if(!ishuman(H))
		return
	playsound(src, 'sound/magic/timeparadox2.ogg', 75, TRUE, -1)
	H.Stun(20, ignore_canstun = TRUE)
	ADD_TRAIT(H, TRAIT_MUTE, TIMESTOP_TRAIT)
	walk(H, 0) //stops them mid pathing even if they're stunimmune
	H.add_atom_colour(list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0), TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(src, PROC_REF(UnFreezeMob), H), 20)
	var/flipped_dir = turn(H.dir, 180)
	var/turf/T = get_step(H, flipped_dir)
	var/obj/effect/temp_visual/remnant_of_time/attack = new(T, src) //Effect defined at the end of file
	attack.dir = H.dir

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/UnFreezeMob(mob/living/H)
	playsound(src, 'sound/magic/timeparadox2.ogg', 75, TRUE, frequency = -1) //reverse!
	H.AdjustStun(-20, ignore_canstun = TRUE)
	REMOVE_TRAIT(H, TRAIT_MUTE, TIMESTOP_TRAIT)
	H.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)

/*
	Long-ranged "Punishment" Transfromations
	The farther you are - the less damage it deals. Followed up by a Teleport
*/
//Doomsday Calander
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeCalander()
	transform_cooldown = transform_cooldown_time_short + world.time
	name = "Doomsday Calendar"
	desc = "Likely a tool for predicting a date of some kind, judging from the many letters carved on the bricks."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "doomsday_charging"
	base_pixel_x = -16
	pixel_x = -16
	can_move = FALSE
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(CalanderAttack)), 5)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/CalanderAttack(faction_check = "hostile")
	icon_state = "doomsday_universe"
	been_hit = list()
	playsound(src, 'sound/abnormalities/doomsdaycalendar/Doomsday_Universe.ogg', 50, FALSE, 50)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	for(var/i = 1 to 48)
		turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/open/T in turf_list)
			var/obj/effect/temp_visual/cult/sparks/S = new(T)
			S.color = "#003FFF"
			for(var/mob/living/L in T)
				new /obj/effect/temp_visual/dir_setting/cult/phase(T, L.dir)
				addtimer(CALLBACK(src, PROC_REF(CalanderAttackHit), L, i, faction_check))
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/CalanderAttackHit(mob/living/L, attack_range = 1, faction_check = "hostile")
	if(L in been_hit)
		return
	been_hit += L
	if(!(faction_check in L.faction))
		playsound(L.loc, 'sound/abnormalities/doomsdaycalendar/Effect_Burn.ogg', 50 - attack_range, TRUE, -1)
		var/dealt_damage = max(5, 75 - (attack_range))
		L.apply_damage(dealt_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(ishuman(L) && dealt_damage > 25)
			L.emote("scream")
		to_chat(L, span_userdanger("IT BURNS!!"))

//Blue Star
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeStar()
	transform_cooldown = transform_cooldown_time_short + world.time
	name = "Blue Star"
	desc = "Floating heart-shaped object. It's alive, and soon you will become one with it."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "blue_star"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -16
	base_pixel_y = -16
	can_move = FALSE
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(BlueStarAttack)), 5)


/mob/living/simple_animal/hostile/abnormality/distortedform/proc/BlueStarAttack()
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 100, FALSE, 40, falloff_distance = 10)
	var/matrix/init_transform = transform
	animate(src, transform = transform*1.5, time = 3, easing = BACK_EASING|EASE_OUT)
	for(var/mob/living/L in livinginrange(48, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		L.apply_damage((75 - get_dist(src, L)), WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		flash_color(L, flash_color = COLOR_BLUE_LIGHT, flash_time = 70)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.sanity_lost) // TODO: TEMPORARY AS HELL
			H.death()
			animate(H, transform = H.transform*0.01, time = 5)
			QDEL_IN(H, 5)
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)

//Der Freischutz
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeDer()
	transform_cooldown = transform_cooldown_time_short + world.time
	name = "Der Freischutz"
	desc = "A tall man adorned in grey, gold, and regal blue. His aim is impeccable."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "derfreischutz"
	addtimer(CALLBACK(src, PROC_REF(DerAttack)), 5)
	pixel_x = 0
	base_pixel_x = 0

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/DerAttack(freidir = pick(EAST,WEST))
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	var/list/targets = list()
	for(var/mob/M in GLOB.mob_living_list)
		if((faction_check_mob(M)) || (src.z != M.z) || (M.stat == DEAD) || (M.status_flags & GODMODE))
			continue
		targets += M
	if(!LAZYLEN(targets))
		return
	var/mob/target = pick(targets)
	face_atom(target)
	freidir = dir
	update_icon()
	var/offset = -12
	var/list/portals = list()
	var/turf/T = src.loc
	var/turf/barrel = locate(T.x + 2, T.y + 1, T.z)
	var/turf/tpos = target
	if (freidir == EAST)
		T = locate(tpos.x - 5, tpos.y, tpos.z)
	else if (freidir == WEST)
		T = locate(tpos.x + 5, tpos.y, tpos.z)
	else if (freidir == SOUTH)
		T = locate(tpos.x, tpos.y + 5, tpos.z)
	else
		T = locate(tpos.x, tpos.y - 5, tpos.z)
	playsound(T, 'sound/abnormalities/freischutz/prepare.ogg', 100, FALSE, 20)
	playsound(src.loc, 'sound/abnormalities/freischutz/prepare.ogg', 100, FALSE)
	for(var/i=1, i<5, i++)
		var/obj/effect/frei_magic/P = new(barrel)
		P.dir = EAST
		P.icon_state = "freicircle[i]"
		P.update_icon()
		P.pixel_x += offset
		portals += P
		var/obj/effect/frei_magic/PX = new(T)
		PX.dir = freidir
		PX.icon_state = "freicircle[i]"
		PX.update_icon()
		if (freidir == EAST)
			PX.pixel_x += offset
		else if (freidir == WEST)
			PX.pixel_x -= offset
		else if (freidir == SOUTH)
			PX.pixel_y -= offset
		else
			PX.pixel_y += offset
		offset += 8
		portals += PX
		sleep(6)
		if(i != 4)
			continue
		else
			var/obj/effect/magic_bullet/B = new(T)
			playsound(get_turf(src), 'sound/abnormalities/freischutz/shoot.ogg', 100, FALSE, 20)
			B.dir = freidir
			addtimer(CALLBACK(B, TYPE_PROC_REF(/obj/effect/magic_bullet, moveBullet)), 0.1)
			src.icon = 'ModularTegustation/Teguicons/32x64.dmi'
			src.update_icon()
			for(var/obj/effect/frei_magic/Port in portals)
				Port.fade_out()

//Siren
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeSiren()
	transform_cooldown = transform_cooldown_time_short + world.time
	name = "Siren"
	desc = "The siren that sings the past."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "siren_breach"
	can_move = FALSE
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(SirenAttack)), 5)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/SirenAttack() //EXTREMELY Evil
	playsound(src, 'sound/abnormalities/siren/sirenhappy.ogg', 100, FALSE, 10)
	for(var/mob/living/L in orange(20, src))
		if(isabnormalitymob(L))
			var/mob/living/simple_animal/hostile/abnormality/ABNO = L
			if(ABNO.IsContained())
				ABNO.datum_reference.qliphoth_change(-1)
				continue


//Apocalypse Bird
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ChangeApoc()
	transform_cooldown = transform_cooldown_time + world.time
	name = "Apocalypse bird"
	desc = "A terrifying giant beast that lives in the black forest. It's constantly looking for a monster \
	that terrorizes the forest, without realizing that it is looking for itself."
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "apocalypse"
	pixel_x = -96
	base_pixel_x = -96
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)) //It is immobile, just run away
	can_move = FALSE
	can_attack = FALSE
	var/LongRange = TRUE //Check if there's anyone within 15 tiles when we transformed
	for(var/mob/living/L in livinginrange(15, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		if((L.stat == DEAD) || (L.status_flags & GODMODE))
			continue
		LongRange = FALSE
		break
	if(LongRange)
		addtimer(CALLBACK(src, PROC_REF(ApocJudge)), 30)
	else
		addtimer(CALLBACK(src, PROC_REF(ApocSlam)), 30)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ApocSlam()
	playsound(src, 'sound/abnormalities/apocalypse/pre_attack.ogg', 125, FALSE, 4)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(src, 'sound/abnormalities/apocalypse/swing.ogg', 125, FALSE, 6)
	flick("apocalypse_slam", src)
	SLEEP_CHECK_DEATH(4)
	playsound(src, 'sound/abnormalities/apocalypse/slam.ogg', 100, FALSE, 12)
	visible_message(span_danger("[src] slams at the floor with its talons!"))
	// Shake effect
	for(var/mob/living/M in livinginrange(20, get_turf(src)))
		shake_camera(M, 2, 3)
	// Actual stuff
	for(var/turf/open/T in view(8, src))
		new /obj/effect/temp_visual/small_smoke(T)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage((300 - (16 * get_dist(src, L))), BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	SLEEP_CHECK_DEATH(2 SECONDS)

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ApocJudge()
	can_act = FALSE
	sound_to_playing_players_on_level('sound/abnormalities/apocalypse/judge.ogg', 75, zlevel = z)
	icon_state = "apocalypse_judge"
	SLEEP_CHECK_DEATH(5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/judgementbird/ability.ogg', 75, zlevel = z)
	for(var/mob/living/L in GLOB.mob_living_list)
		var/check_z = L.z
		if(isatom(L.loc))
			check_z = L.loc.z
		if(check_z != z)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/judgement(get_turf(L))
		L.apply_damage(max(5, 60 - get_dist(src, L)), PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	SLEEP_CHECK_DEATH(1 SECONDS)
	icon_state = "apocalypse"
	SLEEP_CHECK_DEATH(1 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/ReadyJump()
	var/list/potentialmarked = list()
	var/list/marked = list()
	var/mob/living/carbon/human/Y
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
	var/numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
	for(var/i = numbermarked, i>=1, i--)
		if(potentialmarked.len <= 0)
			break
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(Y.stat == DEAD || Y.is_working)
			continue
		marked+=Y
	if(marked.len <= 0) //Oh no, everyone's dead!
		ChangeForm("Pause")
		return
	can_act = FALSE
	var/mob/living/carbon/human/final_target = pick(marked)
	final_target.apply_status_effect(/datum/status_effect/panicked_lvl_5)
	to_chat(final_target, span_userdanger("Look out!"))
	var/jump_type = pick(transform_list_jump)
	playsound(get_turf(src), 'sound/abnormalities/babayaga/charge.ogg', 100, 1)
	pixel_z = 128
	alpha = 0
	density = FALSE
	var/target_turf = get_turf(final_target)
	forceMove(target_turf) //look out, someone is rushing you!
	switch(jump_type)
		if("Light")
			LightJump(target_turf)
		if("Medium")
			MediumJump(target_turf)
		if("Heavy")
			HeavyJump(target_turf)
	visible_message(span_danger("[src] drops down from the ceiling!"))
	density = TRUE
	SLEEP_CHECK_DEATH(5)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/LightJump(turf/target_turf)
	name = "Fridge?"
	desc = "It refridgerates."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "freezer_fake"
	pixel_x = 0
	base_pixel_x = 0
	playsound(target_turf, 'sound/abnormalities/roadhome/Cartoon_Falling_Sound_Effect.ogg', 75, FALSE, -1)
	SLEEP_CHECK_DEATH(1 SECONDS)
	animate(src, pixel_z = 0, alpha = 255, time = 5)
	SLEEP_CHECK_DEATH(5)
	playsound(get_turf(src), 'sound/abnormalities/distortedform/metal_impact.ogg', 65, 1)
	var/obj/effect/temp_visual/decoy/D = new(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)
	for(var/turf/T in view(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 100, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.health <= 0)
				H.gib()

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/MediumJump(turf/target_turf)
	name = "grant us love"
	desc = "A dark monolith structure with incomprehensible writing on it."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "violet_noon"
	base_pixel_x = -8
	pixel_x = -8
	new /obj/effect/temp_visual/jumpwarning(target_turf)
	SLEEP_CHECK_DEATH(5 SECONDS)
	animate(src, pixel_z = 0, alpha = 255, time = 7)
	SLEEP_CHECK_DEATH(7)
	playsound(get_turf(src), 'sound/effects/ordeals/violet/monolith_down.ogg', 65, 1)
	var/obj/effect/temp_visual/decoy/D = new(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)
	for(var/turf/T in view(4, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 150, BLACK_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.health <= 0)
				H.gib()

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/HeavyJump(turf/target_turf)
	name = "Baba Yaga"
	desc = "A giant house stomping around on an equally large chicken leg."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "babayaga_breach"
	pixel_x = -16
	base_pixel_x = -16
	new /obj/effect/temp_visual/giantwarning(target_turf)
	SLEEP_CHECK_DEATH(10 SECONDS)
	animate(src, pixel_z = 0, alpha = 255, time = 10)
	SLEEP_CHECK_DEATH(10)
	playsound(get_turf(src), 'sound/abnormalities/babayaga/land.ogg', 100, FALSE, 20)
	var/obj/effect/temp_visual/decoy/D = new(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)
	for(var/turf/open/T in view(3, src))
		new /obj/effect/temp_visual/ice_turf(T)
	for(var/turf/open/T in view(8, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		if(prob(20))
			new /obj/effect/temp_visual/ice_spikes(T)

	for(var/mob/living/L in view(8, src))
		if(faction_check_mob(L, TRUE)) //so it doesn't kill its own minions
			continue
		var/dist = get_dist(src, L)
		if(ishuman(L)) //Different damage formulae for humans vs mobs
			L.apply_damage(clamp((15 * (2 ** (8 - dist))), 15, 4000), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE)) //15-3840 damage scaling exponentially with distance
		else
			L.apply_damage(600 - ((dist > 2 ? dist : 0 )* 75), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE)) //0-600 damage scaling on distance, we don't want it oneshotting mobs
		if(L.health < 0)
			L.gib()


//Miscellaneous random sprites - does nothing. Very low chance. This where you put the silly meme stuff.
/mob/living/simple_animal/hostile/abnormality/distortedform/proc/Pause()
	transform_cooldown = transform_cooldown_time_short + world.time
	name = "Distorted Form"
	desc = "That doesn't look right."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	pixel_x = 0
	base_pixel_x = 0
	can_move = FALSE
	can_attack = FALSE
	PickForm()

/mob/living/simple_animal/hostile/abnormality/distortedform/proc/PickForm()
	name = pick("bill", "cube", "fairies", "shadow")
	icon_state = name

//Misc Objects
/obj/effect/temp_visual/jumpwarning
	name = "stack warning"
	desc = "RUN!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "zorowarning"
	randomdir = FALSE
	duration = 5 SECONDS
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what hit you

/obj/effect/temp_visual/distortedwarning
	name = "stack warning"
	desc = "GROUP UP! QUICKLY!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "stackwarning"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	randomdir = FALSE
	duration = 5 SECONDS
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what hit you

/obj/effect/temp_visual/beam_in_giant
	name = "light beam"
	desc = "A beam of light"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "beamin"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = 16
	base_pixel_y = 16
	randomdir = FALSE
	duration = 1 SECONDS
	layer = POINT_LAYER

/obj/effect/temp_visual/beam_in_giant/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, transform = matrix()*1.8, time = 0)

/obj/viscon_filtereffect/distortedform
	name = "Visual Distortion"
	render_target = "displace"
	appearance_flags = PASS_MOUSE | KEEP_TOGETHER
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR | VIS_UNDERLAY

/obj/viscon_filtereffect/distortedform_trail
	name = "Visual Distortion"
	render_target = "displace"
	vis_flags = VIS_INHERIT_DIR | VIS_UNDERLAY

/obj/viscon_filtereffect/distortedform_trail/New(mob/themob, waittime)
	set waitfor = FALSE
	switch(themob.dir)
		if(NORTH)
			pixel_y = -24
		if(SOUTH)
			pixel_y = 24
		if(WEST)
			pixel_x = 24
		if(EAST)
			pixel_x = -24
	sleep(waittime)
	loc = null
	qdel(src)

/obj/effect/temp_visual/remnant_of_time
	name = "remnant of time"
	desc = "A ghost with a scythe"
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "remnant_of_time"
	duration = 40
	layer = RIPPLE_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	var/damage = 45 //Pale Damage
	var/mob/living/caster
	var/slash_width = 2
	var/slash_length = 5

/obj/effect/temp_visual/remnant_of_time/Initialize(mapload, new_caster)
	. = ..()
	if(new_caster)
		caster = new_caster
	addtimer(CALLBACK(src, PROC_REF(explode)), 2 SECONDS)

/obj/effect/temp_visual/remnant_of_time/proc/explode()
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir)
		if(EAST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, EAST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, WEST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, SOUTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, NORTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T
	if (!LAZYLEN(area_of_effect))
		return
	playsound(get_turf(src), 'sound/weapons/fixer/generic/sheath2.ogg', 75, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/cult/sparks(T)
	sleep(0.8 SECONDS)
	playsound(get_turf(src), 'sound/weapons/fixer/generic/blade3.ogg', 100, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(L == caster)
				continue
			caster.HurtInTurf(T, list(), damage, PALE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
