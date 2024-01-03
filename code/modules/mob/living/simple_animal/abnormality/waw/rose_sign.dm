#define STATUS_EFFECT_THORNS /datum/status_effect/stacking/crownthorns
/mob/living/simple_animal/hostile/abnormality/rose_sign
	name = "Sign Of Roses"
	desc = "An armless humanoid shape strapped onto a signboard with rose vines."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "rose_sign"
	icon_living = "rose_sign"
	icon_dead = "rosesign_egg"
	del_on_death = FALSE
	gender = NEUTER
	threat_level = WAW_LEVEL
	maxHealth = 2000
	health = 2000
	max_boxes = 16
	pixel_x = -16
	base_pixel_x = -16
	speech_span = SPAN_ITALICS
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 10, 20, 20, 20),
		ABNORMALITY_WORK_INSIGHT = list(35, 40, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 10, 20, 20, 20),
		ABNORMALITY_WORK_REPRESSION = 0
		)
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE
	can_breach = TRUE
	start_qliphoth = 2
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.5)
	ranged = TRUE
	ego_list = list(
		/datum/ego_datum/weapon/rosa,
		/datum/ego_datum/armor/rosa
		)
	gift_type = /datum/ego_gifts/rosa
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/list/work_roses = list()
	var/list/work_damages = list()
	var/list/summoned_roses = list()
	var/rose_max = 4
	var/rose_cooldown
	var/rose_cooldown_time = 160 SECONDS
	var/vine_cooldown
	var/vine_cooldown_time = 45 SECONDS
	var/can_act = TRUE

//*** Basic Simple mob procs***//
/mob/living/simple_animal/hostile/abnormality/rose_sign/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/rose_sign/AttackingTarget(atom/attacked_target)
	if(prob(30))
		return OpenFire()
	return

/mob/living/simple_animal/hostile/abnormality/rose_sign/Life()
	. = ..()
	if(!.) // Dead
		return FALSE//VERY bad things will happen if roses are spawned while its dead
	if((rose_cooldown < world.time) && !(status_flags & GODMODE))
		PickTargets()
		return

/mob/living/simple_animal/hostile/abnormality/rose_sign/death()
	for(var/mob/living/R in summoned_roses)
		R.death()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/rose_sign/WorkChance(mob/living/carbon/human/user, chance, work_type)//set the new work chances
	. = chance // Set default return to chance
	var/rose_amount = LAZYLEN(work_roses)
	switch(work_type)
		if(ABNORMALITY_WORK_INSIGHT)
			rose_amount *= 4
		if(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_ATTACHMENT)
			rose_amount *= 8
		if(ABNORMALITY_WORK_REPRESSION)
			rose_amount *= 16
	. += rose_amount // Add scaling amount based on work type and roses
	return

/mob/living/simple_animal/hostile/abnormality/rose_sign/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSIGHT || work_type == ABNORMALITY_WORK_REPRESSION)
		return
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/rose_sign/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_REPRESSION && !LAZYLEN(work_roses))
		datum_reference.qliphoth_change(-1)
		var/list/speech_styles = list(SPAN_ITALICS, SPAN_ROBOT, SPAN_ITALICS, SPAN_SANS, SPAN_PAPYRUS, SPAN_ROBOT, SPAN_ITALICS)
		var/list/lines = list("Foolish.", "Everyone has wishes. To deny them is to deny yourself.", "I can see how... vivid your seeds are. To not allow them to bloom isn't fair.", \
		"Well... That's too bad.", "If you have no wishes, then remain here forevermore.", "Until you realize that there is no moving on without acceptance.", "Be with us. With me.")
		INVOKE_ASYNC(src, .proc/WorkSpeech, lines, speech_styles)
		return
	if(work_type == ABNORMALITY_WORK_INSIGHT && LAZYLEN(work_roses) >= rose_max)
		datum_reference.qliphoth_change(-1)
		var/list/speech_styles = list(SPAN_ITALICS, SPAN_ROBOT, SPAN_SANS)
		var/list/lines = list("Mm, still too pale.", "We don't need bland flowers like yours.", "How disappointing~")
		INVOKE_ASYNC(src, .proc/WorkSpeech, lines, speech_styles)
		return
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		SpawnWorkRose()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		var/rose = pick(work_roses)
		var/obj/structure/rose_work/rosewk = rose
		rosewk.killed = FALSE
		work_roses -= rose
		qdel(rose)
	return

/mob/living/simple_animal/hostile/abnormality/rose_sign/AttemptWork(mob/living/carbon/human/user, work_type)
	datum_reference.max_boxes = (max_boxes + (LAZYLEN(work_roses) * 2))//16 to 24
	work_damages = list()
	if(LAZYLEN(work_roses))//Check for any roses in the containment cell
		for(var/obj/structure/rose_work/R in work_roses)
			switch(R.picked_color)
				if("red")
					work_damages[RED_DAMAGE] += 2//convert the strings into damtypes
				if("white")
					work_damages[WHITE_DAMAGE] += 2
				if("black")
					work_damages[BLACK_DAMAGE] += 2
				if("pale")
					work_damages[PALE_DAMAGE] += 2
	return ..()

/mob/living/simple_animal/hostile/abnormality/rose_sign/WorktickFailure(mob/living/carbon/human/user)
	if(LAZYLEN(work_damages))//are there any children under work damages? Apply all of the damages!
		for(var/damtype in work_damages)
			user.apply_damage(work_damages[damtype], damtype, null, user.run_armor_check(null, damtype), spread_damage = TRUE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/rose_sign/proc/WorkSpeech(list/lines, list/speech_styles)
	if(datum_reference.qliphoth_meter < 1)
		return
	var/i = 1
	for(var/line in lines)
		speech_span = speech_styles[i]
		say(line)
		i++
		sleep(15)

/mob/living/simple_animal/hostile/abnormality/rose_sign/proc/SpawnWorkRose()
	var/turf/T = get_turf(src)//the turf of the abnormality
	var/list/target_turfs = list()
	for(var/turf/TT in orange(1, T))//the 3x3 circle around the abnormality
		if(locate(/obj/structure/rose_work) in get_turf(TT))//prevents roses from stacking on the same tile
			continue
		target_turfs |= TT
	T = pick(target_turfs)
	var/obj/structure/rose_work/R = new(T)
	R.master = src
	work_roses += R
	R.RoseLines(src)
	return

//***Breach Mechanics***//
/mob/living/simple_animal/hostile/abnormality/rose_sign/BreachEffect(mob/living/carbon/human/user)
	..()
	for(var/obj/structure/rose_work/R in work_roses)//Destroy any roses left in the containment cell. How terrible!
		work_roses -= R
		qdel(R)
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)

/mob/living/simple_animal/hostile/abnormality/rose_sign/proc/PickTargets()//this is called by life()
	rose_cooldown = world.time + rose_cooldown_time
	var/list/spawns = GLOB.xeno_spawn.Copy()
	var/delay = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat == DEAD)
			continue
		if((H.mind?.assigned_role in GLOB.service_positions)) // Clerks and managers don't have to deal with this bulshit
			continue
		var/A = pick_n_take(spawns)
		SpawnBreachRose(H, get_turf(A))
		INVOKE_ASYNC(src, .proc/RoseSounds, delay)
		delay += 5

/mob/living/simple_animal/hostile/abnormality/rose_sign/proc/RoseSounds(delay)
	sleep(delay)
	sound_to_playing_players_on_level("sound/abnormalities/rosesign/rose_summon.ogg", 100, zlevel = z)

/mob/living/simple_animal/hostile/abnormality/rose_sign/proc/SpawnBreachRose(mob/living/carbon/human/target, turf/T)
	if(locate(/mob/living/simple_animal/hostile/rose_summoned) in get_turf(T))//Needs to be tested in a multiplayer environment
		T = get_ranged_target_turf(T, pick(GLOB.alldirs), 1)//This will move the target's turf to an adjacent one, preventing stacking and visual clutter to some degree.
	var/list/flower_damtype = list()
	var/damtype
	var/mob/living/simple_animal/hostile/rose_summoned/R = new(T)//Spawns the rose
	summoned_roses += R
	for(var/obj/item/W in target.held_items + target.get_equipped_items())//Searches the human for any E.G.O and adds them to a list.
		if(istype(W, /obj/item/ego_weapon))//FIXME!!!! The above line doesn't actually check suit storage slots, could be more efficient too
			flower_damtype += W.damtype
		if(istype(W, /obj/item/gun/ego_gun))
			var/obj/item/gun/ego_gun/G = W
			flower_damtype += G.chambered.BB.damage_type
	if(LAZYLEN(flower_damtype))//Picks damage types from the list compiled previously, spawning a rose of that color.
		damtype = pick(flower_damtype)
	else
		damtype = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	R.PickColor(damtype)
	R.master = src
	R.status_target = target
	target.apply_status_effect(STATUS_EFFECT_THORNS)
	var/datum/status_effect/stacking/crownthorns/C = target.has_status_effect(/datum/status_effect/stacking/crownthorns)
	C.status_applicant = R
	C.master = src
	to_chat(target, "<span class='userdanger'>You feel a terrifying pain coming from [get_area(T)].</span>")

/mob/living/simple_animal/hostile/abnormality/rose_sign/OpenFire()
	if(!can_act)
		return
	if(vine_cooldown < world.time)
		VineGrab(target)//Wide AOE trip
		return
	rootBarrage(target)//Ebony queen-style basic attack

/mob/living/simple_animal/hostile/abnormality/rose_sign/proc/rootBarrage(target)//Ebony queen's basic attack, fired at a low rate.
	can_act = FALSE
	playsound(get_turf(target), 'sound/creatures/venus_trap_hurt.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(3)
	var/turf/target_turf = get_turf(target)
	for(var/turf/T in view(0, target_turf))
		new /obj/effect/roseRoot(T)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/rose_sign/proc/VineGrab(target)
	if(vine_cooldown > world.time)
		return
	vine_cooldown = world.time + vine_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/rosesign/vinegrab_prep.ogg', 75, 0, 3)
	var/grab_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(grab_delay)
	new /obj/effect/rose_target(get_turf(target))
	can_act = TRUE

//Vine AOE effect
/obj/effect/rose_target//this works similarly to KQE
	name = "approaching vines"
	desc = "LOOK OUT!"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "warning_rose"
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/boom_damage = 45
	var/grabbed
	layer = POINT_LAYER//Sprite should always be visible

/obj/effect/temp_visual/rose_vine
	name = "garden of infinity"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "rose_vines"
	pixel_x = -32
	base_pixel_x = -32
	duration = 6 SECONDS
	randomdir = 0
	pixel_y = 0

/obj/effect/rose_target/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/GrabAttack), 3 SECONDS)

/obj/effect/rose_target/proc/GrabAttack()
	playsound(get_turf(src), 'sound/abnormalities/rosesign/vinegrab.ogg', 75, 0, 3)
	new /obj/effect/temp_visual/rose_vine(get_turf(src))
	alpha = 1
	for(var/mob/living/carbon/human/H in view(3, src))//big, big AOE
		grabbed = TRUE
		H.apply_damage(boom_damage, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		if(H.buckled)//Otherwise it would rip people off their crucifixes. Not too exploitable
			continue
		H.forceMove(get_turf(src))//pulls them all to the target
		H.Knockdown(50)
	if(grabbed)
		sleep(10 SECONDS)
	qdel(src)

/obj/effect/roseRoot
	name = "root"
	desc = "A target warning you of incoming pain"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "vines"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/root_damage = 30 //Black Damage
	layer = POINT_LAYER//should always be visible.

/obj/effect/roseRoot/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/explode), 0.5 SECONDS)

/obj/effect/roseRoot/proc/explode()
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/attack.ogg', 50, 0, 8)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(0, target_turf))
		new /obj/effect/temp_visual/thornspike(T)
		for(var/mob/living/L in T)
			L.apply_damage(root_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			if(L.stat == DEAD)
				if(L.has_status_effect(/datum/status_effect/stacking/crownthorns))//Stops a second crucifix from appearing
					L.remove_status_effect(STATUS_EFFECT_THORNS)
				if(locate(/obj/structure/rose_crucifix) in T)
					T = pick_n_take(T.reachableAdjacentTurfs())//if a crucifix is on this tile, it'll still create another one. You probably shouldn't be letting this many people die to begin with
					L.forceMove(T)
				var/obj/structure/rose_crucifix/N = new(get_turf(T))
				N.buckle_mob(L)
	qdel(src)

//***Breach Roses***//

/mob/living/simple_animal/hostile/rose_summoned
	mob_size = MOB_SIZE_HUGE
	gender = NEUTER
	name = "Blank rose"
	desc = "You shouldn't see this"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "rose_red"
	maxHealth = 500
	health = 500
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	del_on_death = FALSE
	var/flower_damage_type
	var/mob/living/simple_animal/hostile/abnormality/rose_sign/master
	var/mob/living/status_target
	var/killed = TRUE

/mob/living/simple_animal/hostile/rose_summoned/proc/PickColor(picked_color)//fixme: new roses STILL spawn with added weaknesses, even from spawn commands
	icon_state = "rose_" + picked_color
	desc = "The heavier your sins, the deeper the color of petals will be."
	flower_damage_type = picked_color
	switch(picked_color)
		if(RED_DAMAGE)
			name = "rose of war"
		if(WHITE_DAMAGE)
			name = "rose of conquest"
		if(BLACK_DAMAGE)
			name = "rose of famine"
		if(PALE_DAMAGE)
			name = "rose of death"
	ChangeResistance(picked_color, 2, update = TRUE)

/mob/living/simple_animal/hostile/rose_summoned/Move()
	return FALSE

/mob/living/simple_animal/hostile/rose_summoned/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/rose_summoned/death()
	if(!killed || !status_target)
		return ..()
	if(flower_damage_type && master)
		master.summoned_roses -= src
		master.ChangeResistance(flower_damage_type, (master.damage_coeff.getCoeff(flower_damage_type) + 0.3), update = TRUE)
	if(status_target.has_status_effect(/datum/status_effect/stacking/crownthorns))
		status_target.remove_status_effect(STATUS_EFFECT_THORNS)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//***Work-Based Roses***//
/obj/structure/rose_work
	gender = NEUTER
	name = "Blank rose"
	desc = "You shouldn't see this"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "rose_red"
	anchored = TRUE
	density = FALSE
	resistance_flags = FLAMMABLE
	var/killed = TRUE
	var/sin
	var/picked_color = RED_DAMAGE
	var/mob/living/simple_animal/hostile/abnormality/rose_sign/master

/obj/structure/rose_work/Initialize()
	..()
	picked_color = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	icon_state = "rose_" + picked_color
	desc = "The heavier your sins, the deeper the color of petals will be."
	switch(picked_color)
		if(RED_DAMAGE)
			name = "rose of war"
			sin = "war"
		if(WHITE_DAMAGE)
			name = "rose of conquest"
			sin = "conquest"
		if(BLACK_DAMAGE)
			name = "rose of famine"
			sin = "famine"
		if(PALE_DAMAGE)
			name = "rose of death"
			sin = "death"

/obj/structure/rose_work/proc/RoseLines(mob/living/simple_animal/hostile/abnormality/rose_sign/master)
	var/list/speech_styles = list(SPAN_ITALICS, SPAN_SANS, SPAN_ROBOT, SPAN_ITALICS, SPAN_PAPYRUS, SPAN_SANS, SPAN_SINGING)
	var/list/lines = list("Ah, how pretty.", "And so vivid, too!", "Your sin was such a beautiful hue of [sin].", "You've really made a fine addition to the garden.", \
	"The color [sin]?! I'll plant it right next to me.", "Then... Shall we play some more?", "This garden will become terribly beautiful with more sinful flowers we bloom!")
	INVOKE_ASYNC(master, /mob/living/simple_animal/hostile/abnormality/rose_sign.proc/WorkSpeech, lines, speech_styles)

/obj/structure/rose_work/Destroy()
	if(killed)
		master.datum_reference.qliphoth_change(-1)
	master.work_roses -= src
	..()

//debuff definition
/datum/status_effect/stacking/crownthorns
	id = "thorns"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = -1//INFINITE POWER!!!
	max_stacks = 5
	stacks = 1
	tick_interval = 25 SECONDS//you get about a minute and a half
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/crownthorns
	consumed_on_threshold = FALSE
	var/mob/living/simple_animal/hostile/rose_summoned/status_applicant
	var/mob/living/simple_animal/hostile/abnormality/rose_sign/master
	var/attribute_penalty = 25

/atom/movable/screen/alert/status_effect/crownthorns
	name = "Crown of Thorns"
	desc = "You are bound to an abnormal entity."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "rose_sign"

/datum/status_effect/stacking/crownthorns/on_apply()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -attribute_penalty)
	return ..()

/datum/status_effect/stacking/crownthorns/tick()
	to_chat(owner, "<span class='warning'>Thorns painfully dig into your skin!</span>")
	owner.emote("scream")
	stacks += 1
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -25)//By using bonuses, this lowers your maximum health
	attribute_penalty += 25
	if(master)
		master.adjustBruteLoss(-100)
	if(H.stat >= HARD_CRIT || stacks == max_stacks)
		status_applicant.killed = FALSE
		status_applicant.death()
		H.death()
		var/turf/T = get_turf(owner)
		if(locate(/obj/structure/rose_crucifix) in T)
			T = pick_n_take(T.reachableAdjacentTurfs())//if a crucifix is on this tile, it'll still create another one. You probably shouldn't be letting this many people die to begin with
			owner.forceMove(T)
		var/obj/structure/rose_crucifix/N = new(get_turf(T))
		N.buckle_mob(owner)
		qdel(src)

/datum/status_effect/stacking/crownthorns/on_remove()
	to_chat(owner, "<span class='nicegreen'>The prickly feeling stops.</span>")
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, attribute_penalty)
	owner.adjustBruteLoss(-attribute_penalty)
	return ..()

//On-kill visual effect
/obj/structure/rose_crucifix
	name = "thorny crucifix"
	desc = "A terrifying yet beautiful covering of roses."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "crucify"
	max_integrity = 60
	buckle_lying = 0
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/rose_crucifix/Initialize()
	..()
	if(prob(25))//TODO: make this from a white rose
		add_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "crucify_white", -ABOVE_MOB_LAYER))
	else
		var/mutable_appearance/roses = mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "crucify_rose", -ABOVE_MOB_LAYER)
		roses.color = pick("#CC0C0C", "#571278", "#5E7D84")//TODO: make it correspond to the rose, not really necessary though
		add_overlay(roses)

/obj/structure/rose_crucifix/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return

/obj/structure/rose_crucifix/buckle_mob(mob/living/M, force, check_loc, buckle_mob_flags)
	if(M.buckled)
		return
	M.setDir(2)
	addtimer(CALLBACK(src, .proc/BuckleAnimation, M), 1)
	return ..()

/obj/structure/rose_crucifix/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	return

/obj/structure/rose_crucifix/proc/release_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x
	unbuckle_mob(M,force=1)
	M.pixel_z = 0
	src.visible_message(text("<span class='danger'>[M] falls free of [src]!</span>"))
	M.update_icon()

/obj/structure/rose_crucifix/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()

/obj/structure/rose_crucifix/proc/BuckleAnimation(mob/living/M)
	set waitfor = FALSE
	animate(M, pixel_z = 1, time = 5)

#undef STATUS_EFFECT_THORNS
