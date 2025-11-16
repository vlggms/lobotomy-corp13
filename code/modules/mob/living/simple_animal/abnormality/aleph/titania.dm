//Coded by Kirie Saito! EGO done by Chiemi <3
//Reworked by Crabby!!!!
#define STATUS_EFFECT_FAIRY_LIGHTS /datum/status_effect/fairy_lights
/mob/living/simple_animal/hostile/abnormality/titania
	name = "Titania"
	desc = "A gargantuan fairy."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "titania"
	icon_living = "titania"
	portrait = "titania"
	maxHealth = 1750
	health = 1750
	is_flying_animal = TRUE
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 50, 55),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 35, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 15, 25, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	start_qliphoth = 3
	move_to_delay = 4

	work_damage_amount = 9
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	can_breach = TRUE

	melee_damage_lower = 20
	melee_damage_upper = 27		//Will never one shot you.
	melee_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/soulmate,
		/datum/ego_datum/armor/soulmate,
	)
	gift_type = /datum/ego_gifts/soulmate
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "Is that you Oberon? <br>My nemesis, my beloved devil. <br>Is it you, who applied the concotion of baneful herb to my eyes?"
	observation_choices = list(
		"I am the Oberon you seek" = list(TRUE, "The abhorrent name of the one who stole my child. <br>By your death, I shall finally have my revenge."),
		"I am not him" = list(FALSE, "Ah... <br>A mere human, human, human. <br>Cease your fear, I shall rid you of your pains. <br>Be reborn as a flower."),
		"Stay silent" = list(FALSE, "Ah... <br>A mere human, human, human. <br>Cease your fear, I shall rid you of your pains. <br>Be reborn as a flower."),
	)
	patrol_cooldown_time = 5 SECONDS
	var/fairy_spawn_number = 2
	var/fairy_spawn_time = 5 SECONDS
	var/fairy_spawn_limit = 40 // Oh boy, what can go wrong?
	//Fairy spawn limit only matters for the spawn loop, players she kills and spawned via the law don't count
	var/list/spawned_mobs = list()
	/// Is user performing work not at full sanity at the beginning?
	var/agent_notfullsp = FALSE
	var/insane_counter = 0
	//Laws
	var/list/laws = list("melee", "ranged", "fairy", "armor", "ranged fairy")
	var/currentlaw
	var/nextlaw
	var/law_damage = 10		//Take damage, idiot
	var/law_timer = 60 SECONDS
	var/law_startup = 3 SECONDS
	//Oberon stuff
	var/fused = FALSE

/mob/living/simple_animal/hostile/abnormality/titania/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE, PROC_REF(OnHumanInsane))

/mob/living/simple_animal/hostile/abnormality/titania/Life()
	. = ..()
	if(fused) // So you can't just spoon her to death while in nobody is.
		adjustBruteLoss(-(maxHealth))

/mob/living/simple_animal/hostile/abnormality/titania/Move()
	if(fused)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/titania/CanAttack(atom/the_target)
	if(fused)
		return FALSE
	return ..()

//Attacking code
/mob/living/simple_animal/hostile/abnormality/titania/AttackingTarget(atom/attacked_target)
	if(fused)
		return FALSE
	var/mob/living/carbon/human/H = attacked_target
	. = ..()
	//Kills the weak immediately.
	if(ishuman(H) && (get_user_level(H) < 4 || H.sanity_lost))
		say("I rid you of your pain, mere human.")
		//Double Check
		SpawnFairies(fairy_spawn_number * 2, H, ignore_cap = TRUE)
		Convert(H)
		return

/mob/living/simple_animal/hostile/abnormality/titania/proc/Convert(mob/living/carbon/human/H)
	H.visible_message(span_userdanger("[H] is morphing into a flower!"))
	var/mob/living/simple_animal/hostile/titania_flower/F = new(get_turf(H))
	F.alpha = 0
	animate(F, alpha = 255,time = 15)
	var/obj/effect/temp_visual/decoy/fading/D = new(get_turf(H), H)
	D.layer = ABOVE_MOB_LAYER
	for(var/i = 0 to SLOTS_AMT)
		NestedItems(F, H.get_item_by_slot(0>>i))
	qdel(H)

/mob/living/simple_animal/hostile/abnormality/titania/proc/NestedItems(/mob/living/simple_animal/hostile/titania_flower/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

// Modified patrolling
/mob/living/simple_animal/hostile/abnormality/titania/patrol_select()
	var/list/target_turfs = list() // Stolen from Punishing Bird
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4) // Unnecessary for this distance
			continue
		if(!H.has_status_effect(/datum/status_effect/fairy_lights))
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()

//Spawning Fairies
/mob/living/simple_animal/hostile/abnormality/titania/proc/FairyLoop()
	if(IsCombatMap())
		return
	SpawnFairies(fairy_spawn_number)
	addtimer(CALLBACK(src, PROC_REF(FairyLoop)), fairy_spawn_time)

/mob/living/simple_animal/hostile/abnormality/titania/proc/SpawnFairies(amount, mob/turf_mob, ignore_cap = FALSE)
	if(!ignore_cap && (length(spawned_mobs) > fairy_spawn_limit))
		return

	var/turf/spawn_turf
	if(turf_mob)
		spawn_turf = get_turf(turf_mob)
	else
		spawn_turf = get_turf(src)

	for(var/i in 1 to amount)
		var/mob/living/simple_animal/hostile/fairyswarm/fairy = new(spawn_turf)
		fairy.faction = faction
		fairy.mommy = src
		if(fused)
			fairy.icon_state = "fairyswarm_oberon"
		spawned_mobs += fairy

/mob/living/simple_animal/hostile/abnormality/titania/proc/FairyOberon()
	for(var/mob/living/A in spawned_mobs)
		A.icon_state = "fairyswarm_oberon"
	for(var/mob/living/carbon/human/L in GLOB.player_list) // update debuffs
		var/datum/status_effect/fairy_lights/F = L.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS)
		if(F)
			F.UpdateOverlay()

//Cleaning fairies
/mob/living/simple_animal/hostile/abnormality/titania/death(gibbed)
	for(var/mob/living/A in spawned_mobs)
		A.death()
	return ..()

//Preventing her from trying to hit Oberon
/mob/living/simple_animal/hostile/abnormality/titania/EscapeConfinement()
	if(fused)
		return
	. = ..()

//------------------------------------------------------------------------------
//Fairy Laws
//------------------------------------------------------------------------------

/mob/living/simple_animal/hostile/abnormality/titania/proc/SetLaw()
	if(IsCombatMap())
		return


	var/lawmessage

	nextlaw = pick(laws.Copy() - currentlaw)

	switch(nextlaw)
		if("melee")
			lawmessage = "Thou shalt not hit thy queen with melee attacks."
		if("ranged")
			lawmessage = "Thou shalt not hit thy queen with ranged attacks."
		if("fairy")
			lawmessage = "Mine fairies are now heartier."
		if("armor")
			lawmessage = "Thy queen shalt not be hurt by red damage."
		if("ranged fairy")
			lawmessage = "Mine fairies will come to my aid if you strike me with ranged attacks."

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		to_chat(H, span_colossus("[lawmessage]"))
	addtimer(CALLBACK(src, PROC_REF(ActivateLaw)), law_startup)	//Start Law 3 Seconds


/mob/living/simple_animal/hostile/abnormality/titania/proc/ActivateLaw()
	addtimer(CALLBACK(src, PROC_REF(SetLaw)), law_timer)	//Set Laws in 30 Seconds
	currentlaw = nextlaw
	to_chat(GLOB.clients, span_danger("The new law is now in effect."))

	if(currentlaw == "fairies")
		for(var/mob/living/simple_animal/L in spawned_mobs)
			L.ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.1))
	else
		for(var/mob/living/simple_animal/L in spawned_mobs)
			L.ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))


/mob/living/simple_animal/hostile/abnormality/titania/proc/Punishment(mob/living/sinner)
	to_chat(sinner, span_userdanger("You are hurt due to breaking Fairy Law."))
	sinner.deal_damage(law_damage, PALE_DAMAGE)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(sinner), pick(GLOB.alldirs))

//Ranged stuff
/mob/living/simple_animal/hostile/abnormality/titania/bullet_act(obj/projectile/Proj)
	..()

	if(!ishuman(Proj.firer))
		return

	if(currentlaw == "ranged")
		Punishment(Proj.firer)

	if(currentlaw == "armor" && Proj.damage_type == RED_DAMAGE)
		Punishment(Proj.firer)

	if(currentlaw == "ranged fairy")
		SpawnFairies(1)

//Melee stuff
/mob/living/simple_animal/hostile/abnormality/titania/attacked_by(obj/item/I, mob/living/user)
	..()

	if(!user)
		return

	if(currentlaw == "melee")
		Punishment(user)

	if(currentlaw == "armor" && I.damtype == RED_DAMAGE && I.force >= 10)
		Punishment(user)



//Breach, work, 'n' stuff
/mob/living/simple_animal/hostile/abnormality/titania/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(FairyLoop)), 10 SECONDS)	//10 seconds from now you start spawning fairies
	addtimer(CALLBACK(src, PROC_REF(SetLaw)), law_timer)	//Set Laws in 30 Seconds

/mob/living/simple_animal/hostile/abnormality/titania/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(agent_notfullsp)
		datum_reference.qliphoth_change(-1)
		agent_notfullsp = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/titania/AttemptWork(mob/living/carbon/human/user, work_type)
	if(user.sanityhealth != user.maxSanity)
		agent_notfullsp = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/titania/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/titania/proc/OnHumanInsane(datum/source, mob/living/carbon/human/H, attribute)
	SIGNAL_HANDLER
	if(!IsContained())
		return FALSE
	if(!H.mind) // That wasn't a player at all...
		return FALSE
	if(H.z != z)
		return FALSE
	insane_counter += 1
	if(insane_counter >= 2)
		insane_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE

//The flower
/mob/living/simple_animal/hostile/titania_flower
	name = "fairy flower"
	desc = "A pretty purple flower."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "titania_flower"
	gender = NEUTER
	density = TRUE
	maxHealth = 200
	health = 200
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1)
	del_on_death = TRUE

/mob/living/simple_animal/hostile/titania_flower/Move()
	return FALSE

/mob/living/simple_animal/hostile/titania_flower/CanAttack(atom/the_target)
	return FALSE

//The Mini fairies
/mob/living/simple_animal/hostile/fairyswarm
	name = "fairy"
	desc = "A tiny, extremely hungry fairy."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "fairyswarm"
	icon_living = "fairyswarm"
	pass_flags = PASSTABLE | PASSMOB
	is_flying_animal = TRUE
	density = FALSE
	a_intent = INTENT_HARM
	health = 10
	maxHealth = 10
	melee_damage_lower = 1
	melee_damage_upper = 3
	melee_damage_type = WHITE_DAMAGE
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	mob_size = MOB_SIZE_TINY
	del_on_death = TRUE
	var/mob/living/simple_animal/hostile/abnormality/titania/mommy
	var/datum/status_effect/fairy_lights/status

/mob/living/simple_animal/hostile/fairyswarm/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	pixel_y = rand(-16, 16)

/mob/living/simple_animal/hostile/fairyswarm/EscapeConfinement()
	if(status)
		return
	return ..()

/mob/living/simple_animal/hostile/fairyswarm/Destroy()
	if(status)
		status.fairies -= src
		status.UpdateOverlay()
		status = null
	if(mommy)
		mommy.spawned_mobs -= src
		mommy = null
	return ..()

//Attacking code
/mob/living/simple_animal/hostile/fairyswarm/AttackingTarget(atom/attacked_target)
	if(ishuman(target) && prob(50))
		var/mob/living/victim = target
		if (victim.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS))
			var/datum/status_effect/fairy_lights/F = victim.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS)
			if(F.fairies.len < F.limit)
				F.duration = world.time + 30 SECONDS
				F.AddToPlayer(src)
				to_chat(victim, span_userdanger("Another fairy is orbiting you!"))
		else
			var/datum/status_effect/fairy_lights/F = victim.apply_status_effect(STATUS_EFFECT_FAIRY_LIGHTS)
			F.AddToPlayer(src)
			to_chat(victim, span_userdanger("A fairy is orbiting you!"))
	. = ..()

/datum/status_effect/fairy_lights
	id = "fairy_lights"
	alert_type = /atom/movable/screen/alert/status_effect/fairy_lights
	duration = 30 SECONDS // Hits 15 times
	tick_interval = 2 SECONDS
	var/list/fairies = list()
	var/limit = 4
	var/current_overlay = ""

/atom/movable/screen/alert/status_effect/fairy_lights
	name = "Fairy Lights"
	desc = "Fairies orbiting around you is causing you to take WHITE damage!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "fairy_lights"

/datum/status_effect/fairy_lights/on_apply()
	. = ..()
	if(!owner)
		return
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(HurtFaries))

/datum/status_effect/fairy_lights/on_remove()
	. = ..()
	if(!owner)
		return
	if(fairies.len > 0)
		for(var/mob/living/simple_animal/hostile/fairyswarm/fairy in fairies)
			fairy.toggle_ai(AI_ON)
			fairy.forceMove(get_turf(owner))
			fairy.status = null
			fairies -= fairy
	if(ishuman(owner))
		owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', current_overlay, -FIRE_LAYER))
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)

/datum/status_effect/fairy_lights/proc/AddToPlayer(mob/living/simple_animal/hostile/fairyswarm/F)
	if(F)
		fairies += F
		F.forceMove(owner)
		F.status = src
		F.toggle_ai(AI_OFF)
		UpdateOverlay()

/datum/status_effect/fairy_lights/proc/UpdateOverlay()
	if(fairies.len < 1)//to prevent overlays from sticking
		return
	if(fairies.len > 1)
		linked_alert.desc = "[fairies.len] fairies are orbiting around your head, causing you to take WHITE damage!."
	else
		linked_alert.desc = "A fairy is orbiting around your head, causing you to take WHITE damage!."
	if(ishuman(owner))
		var/old_overlay = current_overlay
		current_overlay = "fairy_lights_[fairies.len]"
		var/mob/living/simple_animal/hostile/fairyswarm/F = fairies[1]
		if(F)
			if(F.icon_state == "fairyswarm_oberon")
				current_overlay += "_oberon"
		owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', old_overlay, -FIRE_LAYER))
		owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', current_overlay, -FIRE_LAYER))
		owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', current_overlay, -FIRE_LAYER))

/datum/status_effect/fairy_lights/proc/HurtFaries(datum/source, damage, damagetype, def_zone)
	if(!owner || damagetype != RED_DAMAGE)//I know in wonderlab it says red or white but if it was white than fairies could kill the fairies inside you
		return
	if(!damage || damage <= 20)
		return
	if(fairies.len > 1)
		to_chat(owner, span_nicegreen("The hit killed all of the fairies orbiting you."))
	else
		to_chat(owner, span_nicegreen("The hit killed the fairy orbiting you."))
		for(var/mob/living/simple_animal/hostile/fairyswarm/F in fairies)
			F.death()
		qdel(src)

/datum/status_effect/fairy_lights/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(fairies.len > 1)
		owner.visible_message(span_danger("The fairies orbiting [owner] are spilling nectar on their head!"), span_danger("The fairies are spilling nectar on you!"))
	else
		owner.visible_message(span_danger("The fairy orbiting [owner] is spilling nectar on their head!"), span_danger("The fairy is spilling nectar on you!"))
	playsound(owner, 'sound/effects/magic.ogg', 25, TRUE)
	H.deal_damage(3 * fairies.len, WHITE_DAMAGE)
	if(H.sanity_lost && H.stat != DEAD)
		H.death()
		H.visible_message(span_userdanger("[H] collapses onto the floor as flowers start to bloom from their body!"))
		var/obj/flower_overlay = new
		flower_overlay.icon = 'ModularTegustation/Teguicons/32x32.dmi'
		flower_overlay.icon_state = "fairy_kill"
		flower_overlay.layer = -BODY_FRONT_LAYER
		flower_overlay.plane = FLOAT_PLANE
		flower_overlay.mouse_opacity = 0
		flower_overlay.vis_flags = VIS_INHERIT_ID
		flower_overlay.alpha = 0
		flower_overlay.setDir(H.dir)
		animate(flower_overlay, alpha = 255, time = 2 SECONDS)
		H.vis_contents += flower_overlay
		for(var/mob/living/simple_animal/hostile/fairyswarm/fairy in fairies)
			if(fairy.mommy)
				fairy.mommy.SpawnFairies(1, H, ignore_cap = TRUE)
		qdel(src)

#undef STATUS_EFFECT_FAIRY_LIGHTS
