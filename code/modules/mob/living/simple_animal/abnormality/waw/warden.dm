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
	attack_sound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claws"
	del_on_death = FALSE
	can_breach = TRUE
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

	var/finishing = FALSE
	var/KidnapThreshold = 0.25
	var/KidnapStuntime = 9999

	var/contained_people = 0
	var/captured_souls = 0
	var/indoctrinated_morons = list()
	var/digestion_modifier = 0.2
	var/consumed_soul_modifier = 0.1
	var/resistance_cap = 0.1
	var/lower_damage_cap = 20
	var/upper_damage_cap = 30

	var/resistance_decrease = 0.2

	var/damage_down = 15
	var/damage_degradation = 10

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
			if(!prisoner.IsContained() && prisoner.threat_level == TETH_LEVEL)
				rulebreakers += L // AAAAIIIEEEEEEE GO BACK TO YOUR CEEEEEEELL
	if(rulebreakers)
		return pick(rulebreakers)
	if(highest_priority)
		return pick(highest_priority)
	if(lower_priority)
		return pick(lower_priority)
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
			icon_state = "warden_attack"
			H.Stun(5)
			to_chat(H, span_userdanger("Oh no."))
			playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 75, 1)
			SLEEP_CHECK_DEATH(5)
			if(!targets_from.Adjacent(H) || QDELETED(H)) // They can still be saved if you move them away
				icon_state = "warden"
				finishing = FALSE
				return
			Kidnap(H) // It will now try to take your soul and leave your skin. You will become an eternal prisoner under her skirt in GBJ
			finishing = FALSE
			icon_state = "warden"
			if(IsCombatMap())
				CombatMapTweaks()
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

/mob/living/simple_animal/hostile/abnormality/warden/proc/Indoctrination(mob/living/loser)
	var/notquitefreedom = pick(get_adjacent_open_turfs(src))
	dropHardClothing(loser, get_turf(src))
	var/mob/living/simple_animal/hostile/soulless/L = new(notquitefreedom)
	qdel(loser) // Lol, lmao.
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
	adjustBruteLoss(-(maxHealth*0.2)) // Heals 20% HP, fuck you that's why.

/mob/living/simple_animal/hostile/abnormality/warden/proc/ResistanceAlteration(factor)
	// TODO: Make it so Burn and Brute resistances are not affected (Especially Brute)
	var/list/defenses = damage_coeff.getList()
	for(var/damtype in defenses)
		if(defenses[damtype] == resistance_cap)
			continue
		if(defenses[damtype] < resistance_cap)
			defenses[damtype] = resistance_cap
			continue
		defenses[damtype] += factor
	ChangeResistances(defenses)

/mob/living/simple_animal/hostile/abnormality/warden/proc/DamageAlteration(factor) // The alteration is negative when the factor is positive and viceversa.
	if(melee_damage_lower > lower_damage_cap + factor)
		melee_damage_lower -= factor
	else
		melee_damage_lower = lower_damage_cap
	if(IsCombatMap())
		if(melee_damage_upper > upper_damage_cap + factor)
			melee_damage_upper -= factor
		else
			melee_damage_upper = upper_damage_cap

/mob/living/simple_animal/hostile/abnormality/warden/proc/CombatMapTweaks()
	return

/mob/living/simple_animal/hostile/abnormality/warden/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/warden/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/Move()
	if(finishing)
		return FALSE
	return ..()

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
	var/mob/living/simple_animal/hostile/abnormality/warden/master = warden
	status_holder.Stun(master.KidnapStuntime) // You gotta get saved by another person, nerd.
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
