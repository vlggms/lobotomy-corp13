//Coded by me, Kirie Saito!

//Remind me to give it contract features later.....
/mob/living/simple_animal/hostile/abnormality/contract
	name = "A Contract, Signed"
	desc = "A man with a flaming head sitting behind a desk."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "firstfold"
	portrait = "contract"
	health = 1000
	maxHealth = 1000
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 35, 45, 55),
	)
	pixel_x = -16
	base_pixel_x = -16
	start_qliphoth = 2
	damage_coeff = list(BRUTE = 1.0, RED_DAMAGE = 1.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.3, PALE_DAMAGE = -1)
	melee_damage_lower = 20
	melee_damage_upper = 20
	melee_damage_type = PALE_DAMAGE
	work_damage_amount = 8
	work_damage_type = PALE_DAMAGE	//Lawyers take your fucking soul

	ego_list = list(
		/datum/ego_datum/weapon/infinity,
		/datum/ego_datum/armor/infinity,
	)
	gift_type = /datum/ego_gifts/infinity

	observation_prompt = "Before you, sitting on a desk is a man with a flaming head. <br>\
		On the table sits a rather conspicuous piece of paper. <br>\
		\"As per our agreement, the signatory will recieve one E.G.O. gift.\" <br>\
		\"All you need to do is sign here.\" <br>\
		The paper is a jumbled mess of words, you can't make out anything on it. <br>\
		A pen appears in your hand. <br>\
		The seems to be running out of patience. <br>Will you sign?"
	observation_choices = list("Sign the contract", "Do not sign")
	correct_choices = list("Do not sign")
	observation_success_message = "You take a closer look at the contract <br>\
		There is a tiny clause in fine print <br>\
		\"Your soul becomes the property of a contract signed.\" <br>\
		At your refusal, the man sighs and hands you a new contract. <br>\
		This contract seems legitimate, so you sign."
	observation_fail_message = "You sign the contract in haste. <br>\
		In a few moments, you feel as if a piece of you is missing. <br>\
		You walk out in a daze, unable to remember what the contract was about. <br>\
		Perhaps you should have read the fine print."

	var/list/total_havers = list()
	var/list/fort_havers = list()
	var/list/prud_havers = list()
	var/list/temp_havers = list()
	var/list/just_havers = list()
	var/list/spawnables = list()
	var/total_per_contract = 4
	var/list/contract_abilities = list(
		/obj/effect/proc_holder/spell/pointed/contract/ruin,
		/obj/effect/proc_holder/spell/pointed/contract/stealth,
		/obj/effect/proc_holder/spell/pointed/contract/recall,
		/datum/action/cooldown/contracted_passage,
		)

/mob/living/simple_animal/hostile/abnormality/contract/Initialize()
	. = ..()
	//We need a list of all abnormalities that are TETH to HE level and Can breach.
	var/list/queue = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in queue)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(!(initial(abno.can_spawn)) || !(initial(abno.can_breach)))
			continue

		if((initial(abno.threat_level)) <= WAW_LEVEL)
			spawnables += abno

	for (var/A in contract_abilities)
		if (ispath(A, /obj/effect/proc_holder/spell))
			var/obj/effect/proc_holder/spell/AS = new A(src)
			AddSpell(AS)
	if(IsCombatMap())
		icon = 'ModularTegustation/Teguicons/32x32.dmi'
		pixel_x = 0
		base_pixel_x = 0

/mob/living/simple_animal/hostile/abnormality/contract/WorkChance(mob/living/carbon/human/user, chance, work_type)
	. = chance
	if(!(user in total_havers))
		return

	if(ContractedUser(user, work_type))
		. /= 2

	return

/mob/living/simple_animal/hostile/abnormality/contract/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_amount = initial(work_damage_amount)
	if(ContractedUser(user, work_type) && .)
		work_damage_amount /= 3
	if(user in total_havers)
		work_damage_amount /= 1.2
		say("Yes, yes... I remember the contract.")

	. = ..()
	return

/mob/living/simple_animal/hostile/abnormality/contract/proc/ContractedUser(mob/living/carbon/human/user, work_type)
	. = FALSE
	if(!(user in total_havers))
		return

	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			if(user in fort_havers)
				return TRUE

		if(ABNORMALITY_WORK_INSIGHT)
			if(user in prud_havers)
				return TRUE

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(user in temp_havers)
				return TRUE

		if(ABNORMALITY_WORK_REPRESSION)
			if(user in just_havers)
				return TRUE

/mob/living/simple_animal/hostile/abnormality/contract/proc/NewContract(mob/living/carbon/human/user, work_type)
	if((user in total_havers))
		return
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			if(fort_havers.len < total_per_contract)
				user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, (fort_havers.len - 4)*-1 )
				fort_havers |= user
			else
				return

		if(ABNORMALITY_WORK_INSIGHT)
			if(prud_havers.len < total_per_contract)
				user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, (prud_havers.len - 4)*-1 )
				prud_havers |= user
			else
				return

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(temp_havers.len < total_per_contract)
				user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, (temp_havers.len - 4)*-1 )
				temp_havers |= user
			else
				return

		if(ABNORMALITY_WORK_REPRESSION)
			if(just_havers.len < total_per_contract)
				user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, (just_havers.len - 4)*-1 )
				just_havers |= user
			else
				return

	total_havers |= user
	say("Just sign here on the dotted line... and I'll take care of the rest.")
	return


//Meltdown
/mob/living/simple_animal/hostile/abnormality/contract/ZeroQliphoth(mob/living/carbon/human/user)
	// Don't need to lazylen this. If this is empty there is a SERIOUS PROBLEM.
	var/mob/living/simple_animal/hostile/abnormality/spawning =	pick(spawnables)
	var/mob/living/simple_animal/hostile/abnormality/spawned = new spawning(get_turf(src))
	spawned.BreachEffect()
	spawned.color = "#000000"	//Make it black to look cool
	spawned.name = "???"
	spawned.desc = "What is that thing?"
	spawned.faction = list("hostile")
	spawned.core_enabled = FALSE
	datum_reference.qliphoth_change(2)

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/contract/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	NewContract(user, work_type)

/mob/living/simple_animal/hostile/abnormality/contract/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	work_damage_amount = initial(work_damage_amount)
	return


/mob/living/simple_animal/hostile/abnormality/contract/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	NewContract(user, work_type)
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/contract/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return


/obj/effect/proc_holder/spell/pointed/contract
	action_background_icon_state = "bg_alien"
	var/contract_overlay_icon = 'icons/mob/actions/actions_abnormality.dmi'
	var/contract_overlay_icon_state = "contract"
	var/mutable_appearance/colored_overlay

/obj/effect/proc_holder/spell/pointed/contract/cast(list/targets, mob/living/user, silent = FALSE)
	if(!targets.len)
		if(!silent)
			to_chat(user, span_warning("No target found!"))
		return FALSE
	if(targets.len > 1)
		if(!silent)
			to_chat(user, span_warning("Too many targets!"))
		return FALSE
	if(!can_target(targets[1], user, silent))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/pointed/contract/can_target(atom/target, mob/user, silent)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(target, /mob/living/simple_animal))
		if(!silent)
			to_chat(user, span_warning("You can only contract living!"))
		return FALSE


/obj/effect/proc_holder/spell/pointed/contract/proc/AddOverlay(mob/living/simple_animal/A)
	var/contractlayer = A.layer + 0.1
	colored_overlay = mutable_appearance(contract_overlay_icon, contract_overlay_icon_state, contractlayer)
	A.add_overlay(colored_overlay)
	// if (A.pixel_x != 0)
	// 	colored_overlay.pixel_x = A.pixel_x * -1

/obj/effect/proc_holder/spell/pointed/contract/proc/RemoveOverlay(mob/living/simple_animal/A)
	if (colored_overlay != null)
		A.cut_overlay(colored_overlay)

/obj/effect/proc_holder/spell/pointed/contract/ruin
	name = "Contract of Ruin"
	desc = "The Contract of Ruin, Increases the target's damage against objects for a few seconds."
	panel = "Contract"
	has_action = TRUE
	action_icon = 'icons/mob/actions/actions_abnormality.dmi'
	action_icon_state = "contract"
	clothes_req = FALSE
	charge_max = 100
	selection_type = "range"
	active_msg = "You prepare your Contract of Ruin..."
	deactive_msg = "You put away your Contract of Ruin..."

/obj/effect/proc_holder/spell/pointed/contract/ruin/cast(list/targets, mob/user)
	var/target = targets[1]
	user.visible_message(span_danger("[user] uses the contract of Ruin."), span_alert("You targeted [target]"))
	if (istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target
		A.obj_damage += 50
		addtimer(CALLBACK(src, PROC_REF(RestoreDamage), A), 10 SECONDS)
		AddOverlay(A)
		spawn(20)
		RemoveOverlay(A)

/obj/effect/proc_holder/spell/pointed/contract/ruin/proc/RestoreDamage(mob/living/simple_animal/A)
	if (A.stat != DEAD)
		A.obj_damage -= 50

/obj/effect/proc_holder/spell/pointed/contract/stealth
	name = "Contract of Stealth"
	desc = "The Contract of Stealth, reduce the target's visibility for a few seconds."
	panel = "Contract"
	has_action = TRUE
	action_icon = 'icons/mob/actions/actions_abnormality.dmi'
	action_icon_state = "contract"
	clothes_req = FALSE
	charge_max = 100
	selection_type = "range"
	active_msg = "You prepare your Contract of Stealth..."
	deactive_msg = "You put away your Contract of Stealth..."

/obj/effect/proc_holder/spell/pointed/contract/stealth/cast(list/targets, mob/user)
	var/target = targets[1]
	user.visible_message(span_danger("[user] uses the contract of Stealth."), span_alert("You targeted [target]"))
	if (istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target
		var/old_alpha = A.alpha
		var/old_density = A.density
		A.alpha = 50
		A.density = FALSE
		addtimer(CALLBACK(src, PROC_REF(RestoreAlpha), A, old_alpha, old_density), 10 SECONDS)
		AddOverlay(A)
		spawn(20)
		RemoveOverlay(A)

/obj/effect/proc_holder/spell/pointed/contract/stealth/proc/RestoreAlpha(mob/living/simple_animal/A, old_alpha, old_density)
	if (A.stat != DEAD)
		A.alpha = old_alpha
		A.density = old_density

/obj/effect/proc_holder/spell/pointed/contract/recall
	name = "Contract of Recall"
	desc = "The Contract of Recall"
	panel = "Contract"
	has_action = TRUE
	action_icon = 'icons/mob/actions/actions_abnormality.dmi'
	action_icon_state = "contract"
	clothes_req = FALSE
	charge_max = 100
	selection_type = "range"
	active_msg = "You prepare your Contract of Recall..."
	deactive_msg = "You put away your Contract of Recall..."
	var/mob/living/simple_animal/marked_animal = null

/obj/effect/proc_holder/spell/pointed/contract/recall/Click()
	if (marked_animal != null)
		// do recall
		marked_animal.forceMove(action.owner.loc)
		marked_animal.Stun(10)
		RemoveOverlay(marked_animal)
		marked_animal = null
	else
		..()

/obj/effect/proc_holder/spell/pointed/contract/recall/cast(list/targets, mob/user)
	var/target = targets[1]
	user.visible_message(span_danger("[user] uses the contract of Recall."), span_alert("You targeted [target]"))
	if (istype(target, /mob/living/simple_animal))
		marked_animal = target
		AddOverlay(marked_animal)

// /obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/ash/contract
// 	name = "Contracted Passage"
// 	desc = "A short range spell allowing you to pass unimpeded through a few walls."
// 	school = SCHOOL_FORBIDDEN
// 	invocation = null
// 	charge_max = 100
// 	range = -1
// 	action_icon = 'icons/mob/actions/actions_ecult.dmi'
// 	action_icon_state = "ash_shift"
// 	action_background_icon_state = "bg_alien"
// 	jaunt_in_time = 13
// 	jaunt_duration = 50
// 	jaunt_in_type = /obj/effect/temp_visual/dir_setting/ash_shift
// 	jaunt_out_type = /obj/effect/temp_visual/dir_setting/ash_shift/out

/datum/action/cooldown/contracted_passage
	name = "Contracted Passage"
	desc = "A short range spell allowing you to pass unimpeded through a few walls"
	icon_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "ash_shift"
	background_icon_state = "bg_alien"
	var/in_teleport = FALSE
	cooldown_time = 60 SECONDS
	var/teleport_timer
	var/teleport_time = 10 SECONDS

/datum/action/cooldown/contracted_passage/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/contract))
		return FALSE

	var/mob/living/simple_animal/hostile/abnormality/contract/C = owner
	if (in_teleport)
		if (teleport_timer)
			deltimer(teleport_timer)
		C.incorporeal_move = FALSE
		in_teleport = FALSE
		StartCooldown()
		EndTeleport()
	else
		// change button icon
		in_teleport = TRUE
		C.StartTeleport()
		teleport_timer = addtimer(CALLBACK(src, PROC_REF(EndTeleport), C), teleport_time, TIMER_STOPPABLE)

/datum/action/cooldown/contracted_passage/proc/EndTeleport(mob/living/simple_animal/hostile/abnormality/contract/C)
	C.incorporeal_move = FALSE
	in_teleport = FALSE
	animate(src, alpha = 255, time = 25)
	StartCooldown()

// Procedure to start the leap
/mob/living/simple_animal/hostile/abnormality/contract/proc/StartTeleport()
	visible_message(span_warning("[src] pops out of existence!"))
	// animate
	animate(src, alpha = 0, time = 10)
	density = FALSE
	incorporeal_move = TRUE // Assuming there is a variable for incorporeal state)
