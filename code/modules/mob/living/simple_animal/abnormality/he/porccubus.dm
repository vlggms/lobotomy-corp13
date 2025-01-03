#define STATUS_EFFECT_ADDICTION /datum/status_effect/porccubus_addiction
/mob/living/simple_animal/hostile/abnormality/porccubus
	name = "Porccubus"
	desc = "A long flowerlike creature covered in thorns"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "porrcubus_inert"
	portrait = "porccubus"
	maxHealth = 1500
	health = 1500
	pixel_x = -10
	base_pixel_x = -10
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 30,
		"Touch" = 100,
	) //for some reason all its work rates are uniform through attribute levels in LC
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	ranged = TRUE
	ranged_cooldown_time = 15 SECONDS //will dash at people if they get out of range but not too often
	melee_damage_lower = 15
	melee_damage_upper = 20
	rapid_melee = 3 //you can withdraw out of its range very easily so it needs to be a little harder to melee it
	melee_reach = 2
	work_damage_amount = 12
	can_patrol = FALSE //it can't move anyway but why not
	stat_attack = HARD_CRIT
	work_damage_type = BLACK_DAMAGE
	melee_damage_type = WHITE_DAMAGE
	start_qliphoth = 2
	can_breach = TRUE
	death_sound = 'sound/abnormalities/porccubus/porccu_death.ogg'
	attack_sound = 'sound/abnormalities/porccubus/porccu_attack.ogg'
	attack_verb_continuous = "stings"
	attack_verb_simple = "stabs"

	faction = list("hostile", "porccubus") //so that he stops attacking overdosed people while still not attacking random abnormalities
	ego_list = list(
		/datum/ego_datum/weapon/pleasure,
		/datum/ego_datum/armor/pleasure,
	)
	gift_type = /datum/ego_gifts/pleasure
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "The red flower waits expectantly for you as you enter the containment unit, \
		studying your movements it leans down towards you and bares its thorns to you."
	observation_choices = list(
		"Just observe" = list(TRUE, "The flower pulls back when it realises you make no effort to try and touch it. <br>\
			You study it and it studies you back, it only ever wanted to make people happy the only way it knew how. <br>\
			You turn to leave, resolving to chase after happiness with your own power."),
		"Touch the thorns" = list(FALSE, "The thorns prick your hands and you feel an indescribable rush of pleasure. <br>\
			Poppy flowers like this one have ruined many lives and now it's ruined yours, but for now - you're happy."),
	)

	//the agent that started work on porccubus
	var/agent_ckey
	var/teleport_cooldown_time = 5 MINUTES
	var/teleport_cooldown
	var/damage_taken = FALSE

	//PLAYABLE ATTACKS
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/porccubus_dash_toggle)

/datum/action/innate/abnormality_attack/toggle/porccubus_dash_toggle
	name = "Toggle Dash"
	button_icon_state = "porccubus_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't dash anymore.")
	button_icon_toggle_activated = "porccubus_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now dash to your target when possible.")
	button_icon_toggle_deactivated = "porccubus_toggle0"

//Work Code
/mob/living/simple_animal/hostile/abnormality/porccubus/AttemptWork(mob/living/carbon/human/user, work_type)
	. = ..()
	if(.)
		agent_ckey = user //just in case the agent goes insane midwork

/mob/living/simple_animal/hostile/abnormality/porccubus/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost) //if the person is driven insane mid work
		DrugOverdose(user, agent_ckey)
	agent_ckey = null

/mob/living/simple_animal/hostile/abnormality/porccubus/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(1)
	var/datum/status_effect/porccubus_addiction/PA = user.has_status_effect(STATUS_EFFECT_ADDICTION)

	if(PA)
		PA.IncreaseTolerance()
	else if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60 || work_type == "Touch")
		if(LAZYFIND(datum_reference.transferable_var, agent_ckey )) //if they were already drugged before we basically drug them to death for trying to pull that shit again
			DrugOverdose(user, agent_ckey)
			return ..()
		user.apply_status_effect(STATUS_EFFECT_ADDICTION) //psst, you want some happiness?
	..()

/mob/living/simple_animal/hostile/abnormality/porccubus/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//Drug-related Code
/mob/living/simple_animal/hostile/abnormality/porccubus/proc/DrugOverdose(mob/living/carbon/human/addict, ckey, nirvana = FALSE)//apply 3 drugs at once and speedruns the withdrawal process,
	var/previous_addict = FALSE
	var/datum/status_effect/porccubus_addiction/PA = addict.has_status_effect(STATUS_EFFECT_ADDICTION)
	if(PA)
		OverdoseEffect(PA,nirvana)//if nirvana is false then they will barely get any buffs. bypass ckey restrictions
		return

	if(!datum_reference)
		return
	if(LAZYFIND(datum_reference.transferable_var, ckey))
		previous_addict = TRUE
	LAZYREMOVE(datum_reference.transferable_var, ckey) //otherwise they will just puke it out
	PA = addict.apply_status_effect(STATUS_EFFECT_ADDICTION)
	if(previous_addict)
		LAZYADD(datum_reference.transferable_var, ckey) //we take them out of the list after if they weren't already part of the list because it doesn't really "count" as a real drug dose
	OverdoseEffect(PA,nirvana)

/mob/living/simple_animal/hostile/abnormality/porccubus/proc/OverdoseEffect(datum/status_effect/porccubus_addiction/PA, nirvana)
	PA.IncreaseTolerance(nirvana, 1)
	PA.withdrawal_cooldown_time = 1 SECONDS
	PA.withdrawal_cooldown_time = 1 SECONDS
	if(nirvana)
		PA.sanity_gain = 60 //this basically instantly snaps them out of insanity and they get to play god for like 2 minute

//Breach Code
//Porccubus can't actually move so it's more of a "bring your friend to beat it to death it isn't going anywhere" type of thing.
//it does have a dash that makes it able to jump around, but it can't properly "roam" per say.
/mob/living/simple_animal/hostile/abnormality/porccubus/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	playsound(src, 'sound/abnormalities/porccubus/head_explode_laugh.ogg', 50, FALSE, 4)
	icon_living = "porrcubus"
	icon_state = icon_living
	ranged_cooldown = world.time + ranged_cooldown_time
	if(!IsCombatMap())
		var/turf/T = pick(GLOB.xeno_spawn)
		forceMove(T)
		teleport_cooldown = world.time + teleport_cooldown_time

/mob/living/simple_animal/hostile/abnormality/porccubus/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/porccubus/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(IsCombatMap())
		return
	if(teleport_cooldown < world.time) //if porccubus hasn't taken damage for 5 minutes we make him move so he doesn't stay stuck in whatever cell he got thrown in.
		teleport_cooldown = world.time + teleport_cooldown_time
		if(damage_taken)
			damage_taken = FALSE
			return
		var/turf/T = pick(GLOB.xeno_spawn - get_turf(src))
		forceMove(T)
		damage_taken = FALSE

/mob/living/simple_animal/hostile/abnormality/porccubus/adjustHealth(amount, updating_health, forced)
	..()
	if(amount > 0)
		damage_taken = TRUE

/mob/living/simple_animal/hostile/abnormality/porccubus/bullet_act(obj/projectile/P)
	visible_message(span_warning("Porccubus playfully swat [P] projectile away!"))
	return FALSE //COME CLOSER AND GET DRUGGED COWARD

//Breach Code Attacks
/mob/living/simple_animal/hostile/abnormality/porccubus/OpenFire(atom/A)
	if(client)
		if(ranged_cooldown > world.time || chosen_attack != 1)
			RangedAttack(A)
		switch(chosen_attack)
			if(1)
				PorcDash(target)
		return

	if(!target)
		return
	if(!isliving(target))
		return
	PorcDash(A)

/mob/living/simple_animal/hostile/abnormality/porccubus/proc/PorcDash(atom/target)//additionally, it can dash to its target every 15 seconds if it's out of range
	var/dist = get_dist(target, src)
	if(dist > 2 && ranged_cooldown < world.time)
		ranged_cooldown = world.time + ranged_cooldown_time
		var/list/dash_line = getline(src, target)
		for(var/turf/line_turf in dash_line) //checks if there's a valid path between the turf and the friend
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				break
			forceMove(line_turf)
			SLEEP_CHECK_DEATH(0.8)
		playsound(src, 'sound/abnormalities/porccubus/porccu_giggle.ogg', 10, FALSE, 4) // This thing is absurdly loud
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/abnormality/porccubus/AttackingTarget(atom/attacked_target)
	var/mob/living/carbon/human/H
	if(ishuman(attacked_target))
		H = attacked_target
	. = ..()
	if(.)
		if(!H)
			return
		if(!H.sanity_lost)
			return
		var/nirvana = FALSE
		if(get_attribute_level(H, TEMPERANCE_ATTRIBUTE) < 60) //if they have under 60 temp they actually get all the stats from overdose, otherwise they just get fucked.
			nirvana = TRUE
		DrugOverdose(H, H.ckey, nirvana)
		LoseTarget()
		H.faction += "porccubus" //that guy's already fucked, even if they can kill porccubus safely now, porccubus has done its job of being a cunt

//Drug Item
//this is only obtainable if someone else dies from the addiction, but it's the only way to get drugged without working on porccubus
/obj/item/porccubus_drug
	name = "Porccubus stinger"
	desc = "A stinger extracted from Porccubus or those affected by it."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "porrcubus_drug"

//taking this drug as your first hit instead of porccubus will lead to an instant increased tolerance so using it at the last moment is less rewarded
/obj/item/porccubus_drug/attack_self(mob/user)
	if(!ishuman(user))
		return //stop drugging my cat please
	var/buff_attributes = TRUE
	var/mob/living/carbon/human/H = user
	var/datum/status_effect/porccubus_addiction/PA = H.has_status_effect(STATUS_EFFECT_ADDICTION)
	if(!PA)
		PA = H.apply_status_effect(STATUS_EFFECT_ADDICTION)
		buff_attributes = FALSE //tolerance won't apply extra attribute so it doesn't feel like you took two drugs at once
	PA.IncreaseTolerance(buff_attributes)
	qdel(src)


//ideally, we want the drug to feel like an excellent short term decision and a terrible long term one.
//random stats :
//3 drug uses before max tolerance
//30 minutes before the stats start going into the negative on first use
//if you take a drug the moment your buffed stat reaches 0, you can technically keep your stats in the positive for up to 40 minutes before you're truly screwed
//at max tolerance, your stats will go up to +60 but decrease every 10 seconds, which will take around 10 minutes to reach 0, and then another 10 minutes to become -60
//a lot of these numbers are bound to change as balancing this is really hard without it being not worth the risk or too broken because of the duration
/datum/status_effect/porccubus_addiction
	id = "porccubus_addiction"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/porccubus_addiction
	var/withdrawal_cooldown
	var/withdrawal_cooldown_time = 60 SECONDS
	var/tolerance_sanity_gain = 60
	var/sanity_gain = 60
	var/attribute_gain = 30
	var/previous_addict = FALSE
	var/mob/living/carbon/human/addict

/atom/movable/screen/alert/status_effect/porccubus_addiction
	name = "Indescribable pleasure"
	desc = "YOU FEEL HAPPY, YOU FEEL GREATER THAN YOU EVER DID IN YOUR ENTIRE LIFE! MORE, YOU WANT MORE!"

/datum/status_effect/porccubus_addiction/on_apply()
	. = ..()
	withdrawal_cooldown = withdrawal_cooldown_time + world.time
	var/datum/abnormality/porc_datum
	for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
		if(A.name != "Porccubus")
			continue
		porc_datum = A
		break
	if(!ishuman(owner))
		owner.remove_status_effect(src)
		return

	addict = owner
	if(!porc_datum || LAZYFIND(porc_datum?.transferable_var, addict.ckey) && !isnull(addict.ckey)) //we don't allow the same person to drug themselves again even after respawn
		previous_addict = TRUE
		addict.remove_status_effect(src)
		return

	playsound(addict, 'sound/abnormalities/porccubus/porccu_giggle.ogg', 50, FALSE, 4)
	if(!isnull(addict.ckey))
		LAZYADD(porc_datum.transferable_var,addict.ckey)
	ADD_TRAIT(addict, TRAIT_WORKFEAR_IMMUNE, type)
	ADD_TRAIT(addict, TRAIT_COMBATFEAR_IMMUNE, type) //essentially the only buffs that don't get worse as time goes on
	addict.adjust_all_attribute_buffs(attribute_gain)

//wow this sure feels great I sure do hope there are no negative consequences for my hubris
/datum/status_effect/porccubus_addiction/tick()
	if(withdrawal_cooldown < world.time)
		addict.adjustSanityLoss(-sanity_gain)
		addict.adjust_all_attribute_buffs(-1)
		sanity_gain--
		withdrawal_cooldown = withdrawal_cooldown_time + world.time

	if(addict.sanity_lost && sanity_gain < 0)
		addict.remove_status_effect(src)
	return ..()

//every time you take another hit the effects decrease
/datum/status_effect/porccubus_addiction/proc/IncreaseTolerance(extra_attribute = TRUE, tolerance_amount = 0)
	for(var/i = 0 to tolerance_amount)
		if(withdrawal_cooldown_time > 30 SECONDS)
			withdrawal_cooldown_time -= 25 SECONDS //"I can stop whenever I want"

		if(attribute_gain > 0)
			attribute_gain -= 10

		if(extra_attribute)
			addict.adjust_all_attribute_buffs(attribute_gain)

		if(tolerance_sanity_gain > 10)
			tolerance_sanity_gain -= 25
		sanity_gain = tolerance_sanity_gain

	withdrawal_cooldown = withdrawal_cooldown_time + world.time
	playsound(addict, 'sound/abnormalities/porccubus/porccu_giggle.ogg', 50, FALSE, 4)

/datum/status_effect/porccubus_addiction/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	if(previous_addict)
		to_chat(addict, span_userdanger("Your body has a sudden allergic reaction to the substance!"))
		addict.vomit()
		return
	var/obj/item/bodypart/head/head = addict.get_bodypart("head")
	if(QDELETED(head))
		return
	playsound(addict, 'sound/abnormalities/porccubus/head_explode_laugh.ogg', 50, FALSE, 4)
	var/obj/expanding_head = HeadExplode(head)
	sleep(2 SECONDS) //mostly so the head exploding is synced in with the sound effect and animation
	head.dismember(silent = TRUE)
	QDEL_NULL(head)
	addict.regenerate_icons()
	addict.vis_contents -= expanding_head
	playsound(addict, 'sound/abnormalities/porccubus/head_explode.ogg', 50, FALSE, 4)
	var/turf/orgin = get_turf(addict)
	var/list/all_turfs = RANGE_TURFS(2, orgin)
	new /obj/effect/gibspawner/generic/silent(get_turf(addict))
	for(var/i = 1 to 3)
		var/obj/item/porccubus_drug/drug = new(get_turf(addict)) //if you still want to try it out after seeing a man's head fucking explode
		var/turf/open/Y = pick(all_turfs - orgin)
		if(!LAZYLEN(all_turfs))
			return
		drug.throw_at(Y, 2, 3)
		all_turfs -= Y //so it doesn't throw all of them on the same tiles

//we copy the head icon and apply it as a vis content. because while overlays can't be animated, visual objects that have overlays on them can
/datum/status_effect/porccubus_addiction/proc/HeadExplode(obj/item/bodypart/head/head)
	var/obj/expanding_head = new()
	expanding_head.layer = -BODY_FRONT_LAYER
	expanding_head.plane = FLOAT_PLANE
	expanding_head.mouse_opacity = 0
	expanding_head.vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_DIR
	expanding_head.add_overlay(head.get_limb_icon(TRUE, TRUE, TRUE))
	addict.vis_contents += expanding_head
	addict.managed_vis_overlays += expanding_head
	animate(expanding_head, transform = matrix()*2, color = "#FF0000", pixel_y = expanding_head.pixel_y - 5, time = 2 SECONDS) //you can actually still somewhat see the head under it but the overlay should hide it well enough
	return expanding_head

#undef STATUS_EFFECT_ADDICTION
