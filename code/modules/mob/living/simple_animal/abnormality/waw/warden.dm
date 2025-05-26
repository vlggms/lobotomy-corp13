#define STATUS_EFFECT_SOULDRAIN /datum/status_effect/souldrain
/mob/living/simple_animal/hostile/abnormality/warden
	name = "The Warden"
	desc = "An abnormality that takes the form of a fleshy stick wearing a dress and eyes. You don't want to know what's under that dress."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "warden"
	icon_living = "warden"
	icon_dead = "warden_dead"
	portrait = "warden"
	maxHealth = 2100
	health = 2100
	pixel_x = -8
	base_pixel_x = -8
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5)

	move_to_delay = 4
	melee_damage_lower = 70
	melee_damage_upper = 70
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_same = 1 // We are doing what is called a pro-gamer move (Friendly Fire)
	attack_sound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claws"
	del_on_death = FALSE
	can_breach = TRUE
	can_patrol = TRUE
	patrol_cooldown_time = 5 SECONDS
	threat_level = WAW_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 15,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony

	ego_list = list(
		/datum/ego_datum/weapon/correctional,
		/datum/ego_datum/armor/correctional,
	)
	gift_type =  /datum/ego_gifts/correctional
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "She wanders the facility's halls, doing her rounds and picking the last of us off. <br>\
		As far as I know it's just me left. <br>\
		The site burial went off and escape is impossible, yet, the other abnormalities remain in their cells - if they leave she forces them back inside. <br>\
		Maybe if I enter one of the unused cells, she might leave me alone?"
	observation_choices = list(
		"Enter a cell" = list(TRUE, "I step inside and lock the door behind me, <br>I'm stuck inside. <br>\
			She passes by the containment unit and peers through the glass and seems satisfied."),
		"Surrender to her" = list(FALSE, "Steeling myself, I confront her during one of her rounds. <br>I tell her I'm tired and just want it to end. <br>\
			She gets closer and lifts her skirt(?) and I'm thrust underneath, my colleagues are here- they're alive and well! <br>\
			But, they seem despondent. <br>One looks at me says simply; \"In here, you're with us. Forever.\""),
	)
	var/normal_sprite = "warden"
	var/finisher_sprite = "warden_attack"

	var/combatmap = FALSE

	var/finishing = FALSE
	var/locked_in = FALSE
	var/mob/living/hooligan
	var/KidnapThreshold = 0.2 // If an employee has less than this % of HP left, Warden will kidnap them.
	var/KidnapStuntime = 999 // By default extremely high, you are supposed to be freed by other employees.

	var/contained_people = 0
	var/captured_souls = 0
	var/indoctrinated_morons = list()
	// Resistance modifiers when Warden is eating/has fully eaten someone's soul.
	var/digestion_modifier = 0.2 // This one is weakening factor.
	var/consumed_soul_modifier = 0.1 // This one is strengthening factor.

	var/resistance_cap = 0.1 // Maximum level of resistances that Warden can get by eating people.
	var/consumed_soul_heal = 0.2 // This is the % of max HP that Warden heals after fully consuming someone.

	var/lower_damage_cap = 20
	var/upper_damage_cap = 30

	var/resistance_decrease = 0.2

	var/damage_down = 15 // Temporary damage down (by default, only affects lower_damage) while digesting someone's soul.
	var/damage_up = 5 // PERMANENT damage up (lower and upper) when Warden contains a low-risk abnormality.
	var/damage_degradation = 10 // PERMANENT damage down (by default, only affects lower_damage) after fully eating someone.

	var/weakjailthreshold = 2 // If available agents with a level higher than the level threshold is less than this var, then activate weakjail
	var/weaklevelthreshold = 3
	var/weakjail = FALSE // If this is true then Warden can be popped open like a piñata with enough damage (normally it's only on-kill), and also it does not stun those it consumes.
	var/release_damage // Keeps track of damage received after consuming someone on weakjail mode.
	var/jailbreak_threshold = 525 // Amount of damage required for Warden to surrender the goodies (Kidnapped people)

	var/overfilled_threshold = 3
	var/overfilled = FALSE // Funny.
	var/soul_names = list() // Funny 2.
	var/lastcreepysound = 0
	var/creepysoundcooldown = 20 SECONDS

/mob/living/simple_animal/hostile/abnormality/warden/Login() // I need to fully revamp this, ouuuuuuggghhhhh
	. = ..()
	to_chat(src, "<h1>You are Warden, A Tank Role Abnormality.</h1><br>\
		<b>|Soul Guard|: You are immune to all projectiles.<br>\
		<br>\
		|Soul Warden|: If you attack a corpse, you will dust it, heal and gain a stack of “Captured Soul”<br>\
		For each stack of “Captured Soul”, you become faster, deal 10 less melee damage and take 50% more damage.</b>")

/mob/living/simple_animal/hostile/abnormality/warden/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))
	if(IsCombatMap())
		CombatMapTweaks()

/mob/living/simple_animal/hostile/abnormality/warden/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/PickTarget(list/Targets) // Shamelessly stolen from MoSB
	var/list/rulebreakers = list()
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(L.stat == DEAD)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/rascal = L
			if(rascal.health <= (rascal.maxHealth * KidnapThreshold) || rascal.sanity_lost) // KIDNAP THEM, KIDNAP THEM NOOOOOW!!!
				highest_priority += rascal
			else if(rascal.health < (rascal.maxHealth * (KidnapThreshold * 1.5))) // You are awfully close to getting kidnapped, pal.
				lower_priority += rascal
		if(istype(L, /mob/living/simple_animal/hostile/abnormality)) // Are you a weakling breach, perchance?
			var/mob/living/simple_animal/hostile/abnormality/prisoner = L
			if(!prisoner.IsContained() && prisoner.threat_level == TETH_LEVEL && prisoner.datum_reference)
				rulebreakers += L // AAAAIIIEEEEEEE GO BACK TO YOUR CEEEEEEELL
			else
				continue
	if(LAZYLEN(rulebreakers))
		return pick(rulebreakers)
	if(locked_in) // If locked in, ignore anything that is not an abno.
		return FALSE
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	if(faction_check()) // So that we do not absolutely insane with the friendly fire
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/AttackingTarget(atom/attacked_target)
	if(finishing)
		return FALSE
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		if(H.stat == DEAD)
			return FALSE
		if(H.health < (H.maxHealth * KidnapThreshold) || H.sanity_lost)
			finishing = TRUE
			icon_state = finisher_sprite
			playsound(get_turf(src), 'sound/hallucinations/growl1.ogg', 75, 1)
			H.Stun(6)
			to_chat(H, span_userdanger("Oh no."))
			SLEEP_CHECK_DEATH(5)
			if(!targets_from.Adjacent(H) || QDELETED(H)) // They can still be saved if you move them away
				icon_state = normal_sprite
				to_chat(H, span_nicegreen("That was far too close."))
				finishing = FALSE
				return
			Kidnap(H) // It will now try to take your soul and leave your skin. You will become an eternal prisoner under her skirt in GBJ
			finishing = FALSE
			icon_state = normal_sprite
			if(combatmap)
				return // WIP
			return
	if(istype(attacked_target, /mob/living/simple_animal/hostile/abnormality))
		if(combatmap)
			return FALSE
		var/mob/living/simple_animal/hostile/abnormality/fugitive = attacked_target
		if(fugitive.stat == DEAD)
			return FALSE
		if(!fugitive.IsContained() && fugitive.threat_level == TETH_LEVEL && fugitive.datum_reference)
			finishing = TRUE
			icon_state = finisher_sprite
			fugitive.adjustBruteLoss(fugitive.maxHealth) // OBLITERATION!!!
			qdel(fugitive)
			playsound(get_turf(src), 'sound/hallucinations/growl1.ogg', 75, 1)
			SLEEP_CHECK_DEATH(5)
			icon_state = normal_sprite
			DamageAlteration(-damage_up, TRUE) // Placeholder bonus for containing an abno
			HuntFugitives() // Let's try to keep the combo going.
			finishing = FALSE
			return
	..()

/mob/living/simple_animal/hostile/abnormality/warden/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/warden/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/warden/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	// TODO: Make the Warden actually search and contain low-risk abnos quickly/instantly, and maybe buff her slightly each time she does it.
	if(!IsContained())
		return
	if(istype(abno, /mob/living/simple_animal/hostile/abnormality/punishing_bird))
		return
	if(istype(abno, /mob/living/simple_animal/hostile/abnormality/training_rabbit))
		return
	if(abno.threat_level != ALEPH_LEVEL) //Local Warden too scared to ¿fistfight? (Does it even have fists?) WhiteNight
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/warden/proc/Kidnap(mob/living/rulebreaker)
	if(!rulebreaker)
		return FALSE
	SoloCheck() // Ok sure lets throw you a bone here.
	if(KidnapStuntime)
		rulebreaker.Stun(KidnapStuntime) // You gotta get saved by another person, nerd.
	else
		KidnapStuntime = 999 // Reset the var for future kidnappings
	rulebreaker.forceMove(src)
	rulebreaker.apply_status_effect(STATUS_EFFECT_SOULDRAIN)
	var/datum/status_effect/souldrain/S = rulebreaker.has_status_effect(/datum/status_effect/souldrain)
	S.warden = src
	contained_people++
	Weaken(digestion_modifier)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/warden/proc/Jailbreak()
	var/freedom = pick(get_adjacent_open_turfs(src))
	playsound(get_turf(src), 'sound/effects/limbus_death.ogg', 75, 1)
	for(var/atom/movable/i in contents)
		if(isliving(i))
			var/mob/living/L = i
			L.remove_status_effect(STATUS_EFFECT_SOULDRAIN)
			contained_people--
			RevertWeakness(digestion_modifier)
		i.forceMove(freedom)
	// Just reset the variables after popping.
	weakjail = FALSE
	release_damage = 0
	SLEEP_CHECK_DEATH(50) // 5 whole seconds of stun, you should be grateful.

/mob/living/simple_animal/hostile/abnormality/warden/proc/Indoctrination(mob/living/loser)
	var/notquitefreedom = pick(get_adjacent_open_turfs(src))
	dropHardClothing(loser, get_turf(src))
	var/mob/living/simple_animal/hostile/soulless/L = new(notquitefreedom)
	qdel(loser) // Lol, lmao.
	soul_names += loser.real_name
	L.name = "[loser.real_name]"
	L.desc = "Is that [loser.real_name]? [loser.p_their(TRUE)] face is drained of colour and [loser.p_their()] eyes look glassy and unfocused."
	indoctrinated_morons += L
	contained_people--
	captured_souls++
	RevertWeakness(digestion_modifier)
	Strengthen(consumed_soul_modifier)

/mob/living/simple_animal/hostile/abnormality/warden/proc/Weaken(VulnerabilityFactor)
	DamageAlteration(damage_down)
	ResistanceAlteration(VulnerabilityFactor)
	ChangeMoveToDelayBy(1.25, TRUE)

/mob/living/simple_animal/hostile/abnormality/warden/proc/RevertWeakness(VulnerabilityFactor) // Inverse function of Weaken()
	DamageAlteration(-(damage_down))
	ResistanceAlteration(-(VulnerabilityFactor))
	ChangeMoveToDelayBy(0.8, TRUE)

/mob/living/simple_animal/hostile/abnormality/warden/proc/Strengthen(StrengthenFactor)
	// A tiny bit of damage degradation for each soul consumed, capped at 20 lower damage and 30 upper damage.
	DamageAlteration(damage_degradation)
	ResistanceAlteration(-StrengthenFactor)
	ChangeMoveToDelayBy(0.9, TRUE)
	UpdatePhase()
	adjustBruteLoss(-(maxHealth*consumed_soul_heal)) // Heals a % of her max HP, fuck you that's why.

/mob/living/simple_animal/hostile/abnormality/warden/proc/UpdatePhase() // WIP, REMEMBER TO USE IP SPRITES
	if(overfilled)
		return
	if(captured_souls > overfilled_threshold && !overfilled)
		overfilled = TRUE
		// Add here the changes to both sprite variables

/mob/living/simple_animal/hostile/abnormality/warden/proc/ResistanceAlteration(factor)
	// TODO: Make it so Burn and Brute resistances are not affected (Especially Brute)
	var/list/defenses = damage_coeff.getList()
	for(var/damtype in defenses)
		if(damtype == "brute" || damtype == "fire")
			continue
		if(defenses[damtype] == resistance_cap)
			continue
		if(defenses[damtype] < resistance_cap) // Yes, if you set the resistance cap too high (> 0.4) this will actually weaken certain Warden resistances.
			defenses[damtype] = resistance_cap // Why would you do that though?
			continue
		defenses[damtype] += factor
	ChangeResistances(defenses)

/mob/living/simple_animal/hostile/abnormality/warden/proc/DamageAlteration(factor, affects_upper = FALSE) // The alteration is negative when the factor is positive and viceversa.
	if(melee_damage_lower > lower_damage_cap + factor)
		melee_damage_lower -= factor
	else
		melee_damage_lower = lower_damage_cap
	if(combatmap || affects_upper)
		if(melee_damage_upper > upper_damage_cap + factor)
			melee_damage_upper -= factor
		else
			melee_damage_upper = upper_damage_cap

/mob/living/simple_animal/hostile/abnormality/warden/proc/SoloCheck()
	if(combatmap)
		return
	var/vandals = 0
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(get_user_level(L) <= weaklevelthreshold)	// If their pals are too weak, lets throw the kidnapped agent a bone.
			continue
		vandals += 1
	if(vandals <= weakjailthreshold) // Let's not talk about how a "Solo" check applies to a duo by default, I do not want to hear it.
		KidnapStuntime = 0
		weakjail = TRUE

/mob/living/simple_animal/hostile/abnormality/warden/proc/CombatMapTweaks() // WIP
	combatmap = TRUE
	return

/mob/living/simple_animal/hostile/abnormality/warden/proc/HuntFugitives()
	var/list/breached_abnos = list()
	for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
		if(!A.current)
			continue
		if(!A.current.IsContained() && A.current.threat_level == TETH_LEVEL)
			breached_abnos += A.current
	if(LAZYLEN(breached_abnos))
		var/mob/living/simple_animal/hostile/abnormality/escapee = pick(breached_abnos)
		Lock_in(escapee)
		return TRUE
	else
		Lock_out()

/mob/living/simple_animal/hostile/abnormality/warden/proc/Lock_in(mob/living/condemned) // There is no escape for the wicked.
	hooligan = condemned
	patrol_reset()
	if(!locked_in)
		lose_patience_timeout *= 4 // 24 (60 * 4 deciseconds) seconds of its full and unwavering attention.
		target_switch_resistance *= 4 // The idea is that nothing you do can distract it.
		ChangeMoveToDelayBy(0.5, TRUE)
		density = FALSE // I AM COMING FOR YOU.
		locked_in = TRUE
	// TODO: Create some sort of fallback in case that Warden cannot reach its target, even if it exists.

/mob/living/simple_animal/hostile/abnormality/warden/proc/Lock_out() // Mission accomplished, let's head ba- Sike! Time to kill agents.
	if(locked_in)
		lose_patience_timeout /= 4
		target_switch_resistance /= 4
		ChangeMoveToDelayBy(2, TRUE)
		density = TRUE
		locked_in = FALSE
	SLEEP_CHECK_DEATH(5)

/mob/living/simple_animal/hostile/abnormality/warden/patrol_select()
	if(hooligan)
		var/turf/target_turf = get_turf(hooligan)
		patrol_path = get_path_to(src, target_turf, /turf/proc/Distance_cardinal, 0, 200)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	HuntFugitives()
	if(!locked_in) // We didn't manage to find any rulebreakers? Snap the knees of the agent in front of you.
		GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/warden/Life()
	. = ..()
	if(world.time > lastcreepysound + creepysoundcooldown)
		if(prob(1 + (captured_souls * 2))) // Add creepy whispers scaling with captured souls and upgrade to screams if Warden is overfilled.
			if(overfilled)
				var/message = "You hear a horrible cacophony of discordant voices coming from [src]'s dress."
				if(LAZYLEN(soul_names))
					var/dumbidiot = pick(soul_names)
					message += " You think you can hear [dumbidiot] screaming in there too."
				visible_message("[message]")
				playsound(get_turf(src), 'sound/creatures/legion_spawn.ogg', 30, 0, 8)
				lastcreepysound = world.time
			else
				visible_message("You hear strange sounds coming from beneath [src]'s dress.")
				playsound(get_turf(src), 'sound/spookoween/ghost_whisper.ogg', 30, 0, 8)
				lastcreepysound = world.time
		return

/mob/living/simple_animal/hostile/abnormality/warden/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(weakjail)
		release_damage += damage
		if(release_damage >= jailbreak_threshold)
			Jailbreak()

/mob/living/simple_animal/hostile/abnormality/warden/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	for(var/mob/living/carbon/human/L in GLOB.player_list) // cleanse debuffs
		if(faction_check_mob(L, FALSE) || L.stat == DEAD) // Dead? Fuck them
			continue
		var/datum/status_effect/S = L.has_status_effect(/datum/status_effect/souldrain)
		if(S)
			qdel(S)
	..()

/mob/living/simple_animal/hostile/abnormality/warden/bullet_act(obj/projectile/P)
	visible_message(span_userdanger("[src] is unfazed by \the [P]!"))
	new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
	P.Destroy()

/datum/status_effect/souldrain
	id = "souldrain"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/souldrain
	var/collected_soul
	var/warden

/atom/movable/screen/alert/status_effect/souldrain
	name = "Soul Drain"
	desc = "Your identity is slipping through the pores of your skin."
	icon = 'icons/mob/actions/actions_spells.dmi'
	icon_state = "void_magnet"

/datum/status_effect/souldrain/on_apply()
	var/mob/living/carbon/human/status_holder = owner
	ADD_TRAIT(status_holder, TRAIT_NOBREATH, type)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -20)
	collected_soul += 20
	if(!status_holder.sanity_lost || status_holder.stat != DEAD)
		status_holder.adjustSanityLoss(-(status_holder.maxSanity*0.1)) // Heal 10% of their max sanity after prudence modifier, just to give them a bit more leeway to escape.
	return ..()

/datum/status_effect/souldrain/tick()
	. = ..()
	var/mob/living/carbon/human/status_holder = owner
	var/mob/living/simple_animal/hostile/abnormality/warden/master = warden
	var/soulless = get_turf(owner)
	var/girlboss = get_turf(master)
	if(soulless == girlboss) // Are you still inside the Warden? If yes then get ready to get spiritually husked bucko
		status_holder.adjustBruteLoss(-(status_holder.maxHealth*0.025)) // It cares for your fleshy form while sucking out your soul.
		status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -10) // This lowers your maximum sanity
		status_holder.adjustSanityLoss(round(collected_soul*0.1)) // Somehow people can have negative max sanity without insanning if they do not receive damage.
		collected_soul += 10 // Every 6 seconds the sanity damage increases by one.
		if(status_holder.sanity_lost || status_holder.stat == DEAD)
			master.Indoctrination(status_holder)
	else // If not, then congrats you have mastered the art of teleportation (And you are safe, for now.)
		to_chat(owner, span_nicegreen("That thing is still alive, but you have somehow managed to escape from its grasp."))
		master.RevertWeakness(master.digestion_modifier)
		master.contained_people--
		qdel(src)

/datum/status_effect/souldrain/on_remove()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.IsStun())
		status_holder.SetStun(0)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, collected_soul)
	status_holder.adjustSanityLoss(-collected_soul)
	return ..()


// The mob that spawns when someone's soul gets fully consumed.
/mob/living/simple_animal/hostile/soulless
	name = "Soulless husk"
	desc = "A flesh automaton animated only by neurotransmitters after having their divine light severed."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_kidnap" // Obviously placeholder, but its funny.
	icon_living = "wellcheers_kidnap"
	speak_emote = list("screeches")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/creatures/lc13/lovetown/slam.ogg'
	/* Stats */
	health = 600
	maxHealth = 600
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 30
	speed = 2
	move_to_delay = 2
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	density = FALSE
