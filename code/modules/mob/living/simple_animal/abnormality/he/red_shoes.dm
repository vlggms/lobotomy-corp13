#define STATUS_EFFECT_REDPOSSESS /datum/status_effect/red_possess
/mob/living/simple_animal/hostile/abnormality/red_shoes
	name = "Red Shoes"
	desc = "A pair of elegant red women's shoes. The design is antique, but there is no telling where and how they were made."
	health = 800
	maxHealth = 800
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "redshoes"
	icon_living = "redshoes"
	icon_dead = "redshoes_breach"//dels on death if it's possessing someone. Egg goes here
	portrait = "red_shoes"
	can_breach = TRUE
	gender = NEUTER
	threat_level = HE_LEVEL
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 45, 50, 60),
		ABNORMALITY_WORK_INSIGHT = list(50, 60, 55, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(99, 99, 50, 40, 30),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	del_on_death = FALSE
	death_message = "crumples into a pile of bones."
	attack_sound = 'sound/abnormalities/redshoes/RedShoes_Attack.ogg'
	melee_damage_lower = 15
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	move_to_delay = 2
	rapid_melee = 2
	ego_list = list(
		/datum/ego_datum/weapon/sanguine,
		/datum/ego_datum/armor/sanguine,
	)
	gift_type =  /datum/ego_gifts/desire
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "There is a pair of red shoes. <br>\
		It could be sitting in front of me, or in my feet. I am......"
	observation_choices = list( //TODO: Second line of dialogue, must be coded
		"Wearing them." = list(TRUE, "I am wearing the shoes. <br>\
			They are perfect fit, it feels good. <br>I have a weird feeling as if I am in another world. <br>\
			There is a sharp axe in front of me. Maybe it was there all along, or maybe I just haven't realized it until now. <br>\
			A weapon will change a lot of things."),
		"Not wearing them." = list(FALSE, "I was not wearing the shoes. <br>\
			The shoes' crimson color is getting deeper."),
	)

	var/mutable_appearance/breach_icon
	var/mob/living/possessee
	var/list/death_lines = list(
		"Give them back to me!",
		"Don't take them away from me...",
		"No no no! Don't take them, no!",
		"I'm sorry...",
	)
	var/list/possessee_lines = list(
		"Where is everyone?",
		"Guys, look at me! I've got such nice shoes on!",
		"You all need to see how lovely my shoes are!",
		"They're much prettier with blood on them.",
	)
	var/datum/looping_sound/redshoes_ambience/soundloop
	var/numbermarked = 0//default amount of people that get possessed
	var/steppy = 0
	var/say_chance = 7

//*** Simple Mob Procs ***//
/mob/living/simple_animal/hostile/abnormality/red_shoes/Life()
	. = ..()
	if(!.)//dead
		return
	if(!possessee)
		return
	if(!prob(say_chance))
		return
	var/line = pick(possessee_lines)
	say(line)

/mob/living/simple_animal/hostile/abnormality/red_shoes/death()
	if(possessee)
		death_message = FALSE
		del_on_death = TRUE
	density = FALSE
	for(var/obj/O in src)
		O.forceMove(loc)
	if(possessee)//hopefully this refers to the specific individual
		var/mob/living/carbon/human/H = possessee
		possessee.status_flags &= ~GODMODE
		possessee.forceMove(loc)
		possessee = null
		H.adjustBruteLoss(500)//the host dies
	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)//stops possessing people, prevents runtimes. Panicked players are ghosted so use mob_living_list
		UnPossess(H)
	say(pick(death_lines))
	alpha = 255
	QDEL_IN(src, 10 SECONDS)
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_shoes/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_shoes/Initialize()
	. = ..()
	if(locate(/obj/structure/redshoes_cushion) in get_turf(src))
		icon_state = "redshoes"
		update_icon()
	soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/red_shoes/PostSpawn()
	if(locate(/obj/structure/redshoes_cushion) in get_turf(src))
		return
	new /obj/structure/redshoes_cushion(get_turf(src))
	soundloop.start()
	return ..()

//*** Work Mechanics ***//
/mob/living/simple_animal/hostile/abnormality/red_shoes/proc/Apply_Desire(mob/living/carbon/human/user)
	if(user.has_status_effect(/datum/status_effect/red_possess))//crimsons ownzoned people too hard
		return
	user.apply_status_effect(STATUS_EFFECT_REDPOSSESS)//desire applied
	playsound(src, 'sound/abnormalities/redshoes/RedShoes_Activate.ogg', 100, 1)
	return

/mob/living/simple_animal/hostile/abnormality/red_shoes/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/red_shoes/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60)
		Apply_Desire(user)
		user.adjustSanityLoss(500)
		user.visible_message(span_userdanger("[user] ignores [p_their()] orders and continually glances at The Red Shoes. Now [p_theyre()] reaching out their hand to take the shoes."), span_userdanger("What lovely shoes..."))

//***Breach Mechanics***//
/mob/living/simple_animal/hostile/abnormality/red_shoes/ZeroQliphoth(mob/living/carbon/human/user)//silent girl with extra steps
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return
	if(possessee)//If the first check fails
		return
	SLEEP_CHECK_DEATH(30)
	if(LAZYLEN(GLOB.player_list) < 3)//solo breach if there aren't many players
		BreachEffect()
		return
	numbermarked = (1 + round(LAZYLEN(GLOB.player_list) / 6))
	var/list/potentialmarked = list()//mark code from cherry
	var/list/marked = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
	var/mob/living/Y
	while(numbermarked > marked.len && potentialmarked.len > 0)
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(faction_check_mob(Y, FALSE) || Y.z != z || Y.stat == DEAD)
			continue
		marked+=Y
		Apply_Desire(Y)
	datum_reference.qliphoth_change(2)
	return

/mob/living/simple_animal/hostile/abnormality/red_shoes/proc/Assimilate(mob/living/carbon/user)
	if(!(status_flags & GODMODE))
		return
	if(possessee)
		return
	possessee = user
	var/mob/living/carbon/human/H = user
	if(ishuman(H) && (H.sanity_lost))
		var/obj/item/clothing/suit/armor/ego_gear/EQ = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)//copies all resistances from worn E.G.O
		if(EQ)
			var/list/temp = EQ.armor.getList()
			for(var/damtype in temp)
				temp[damtype] = 1 - (temp[damtype] / 100)
			ChangeResistances(temp)
		user.forceMove(src)
		playsound(src, 'sound/abnormalities/redshoes/RedShoes_Activate.ogg', 50, 1)
		name = user.name
		appearance = user.appearance
		gender = user.gender
		desc = "[user.name] appears to be grinning from ear to ear. Does [p_they()] normally wear shoes like those?"
		maxHealth += (user.maxHealth * 4.5)
		revive(full_heal = TRUE, admin_revive = FALSE)
		add_overlay(mutable_appearance('icons/mob/clothing/feet.dmi', "red_shoes", -ABOVE_MOB_LAYER))
		add_overlay(mutable_appearance('icons/mob/inhands/weapons/ego_righthand.dmi', "sanguine", -ABOVE_MOB_LAYER))
		cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "panicked", -ABOVE_MOB_LAYER))
		BreachEffect(user)
		return TRUE


/mob/living/simple_animal/hostile/abnormality/red_shoes/proc/UnPossess(mob/living/carbon/human/user)//called on death() and BreachEffect()
	if(HAS_AI_CONTROLLER_TYPE(user, /datum/ai_controller/insane/red_possess))
		user.SanityLossEffect(FORTITUDE_ATTRIBUTE)

//BreachEffect and combat
/mob/living/simple_animal/hostile/abnormality/red_shoes/BreachEffect(mob/living/carbon/human/user, breach_type)
	soundloop.stop()
	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)//stops possessing people, prevents runtimes. Panicked players are ghosted so use mob_living_list
		UnPossess(H)
	. = ..()
	if(!possessee)
		name = "Red Shoe"
		desc = "The Red Shoes’s bloody enameled leather glistens in the light."
		icon_state = "redshoes_breach"
		icon_living = "redshoes_breach"
		ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5))
		sleep(10)
		new /mob/living/simple_animal/hostile/red_shoe(get_turf(src))
	datum_reference.qliphoth_change(-2)

/mob/living/simple_animal/hostile/abnormality/red_shoes/Found(atom/A)//The solo breach generally sticks together
	if(istype(A, /mob/living/simple_animal/hostile/red_shoe))
		var/mob/living/simple_animal/hostile/red_shoe/S = A
		if(S.stat != DEAD && !S.target && !S.client && faction_check_mob(S))//cannibalized from steel ordeals
			S.Goto(src,S.move_to_delay,1)

/mob/living/simple_animal/hostile/abnormality/red_shoes/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		ChopFeet(H)

/mob/living/simple_animal/hostile/abnormality/red_shoes/proc/ChopFeet(mob/living/carbon/human/H)
	var/obj/item/bodypart/l_foot = H.get_bodypart(BODY_ZONE_L_LEG)//Feet are defined as BODY_ZONE_PRECISE_L_FOOT. Does the dismember proc not affect them?
	var/obj/item/bodypart/r_foot = H.get_bodypart(BODY_ZONE_R_LEG)
	if(HAS_TRAIT(H, TRAIT_NODISMEMBER))
		return
	if(!l_foot && !r_foot)//stops spamming the sound effect after being applied once
		return
	playsound(src, 'sound/abnormalities/redshoes/RedShoes_Kill.ogg', 100, 1)
	l_foot?.dismember()
	r_foot?.dismember()

//***Debuff Definition***/
//Possession
/datum/status_effect/red_possess//This status will cause you to special panic if your sanity reaches 0 while you have it. If red shoes isn't present or already breached, it will swap to murder panic.
	id = "redpossess"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/red_possess

/atom/movable/screen/alert/status_effect/red_possess
	name = "Allure"
	desc = "Red Shoes is trying to possess you!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "allure"

/datum/status_effect/red_possess/on_apply()
	if(!ishuman(owner))
		qdel(src)
		return
	var/mob/living/carbon/human/status_holder = owner
	var/usertemp = (get_attribute_level(status_holder, TEMPERANCE_ATTRIBUTE))
	var/desire_damage = clamp((80 - (usertemp / 2)),80, 10)//deals between 80 and 10 white damage depending on your temperance attribute when applied.
	status_holder.deal_damage(desire_damage, WHITE_DAMAGE) //DIE!
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -50)//By using bonuses, this lowers your maximum prudence
	if(status_holder.sanity_lost)
		qdel(src)
		return
	return ..()

/datum/status_effect/red_possess/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 50)//Return prudence back to normal
	if(status_holder.sanity_lost)
		QDEL_NULL(owner.ai_controller)
		status_holder.ai_controller = /datum/ai_controller/insane/red_possess
		status_holder.InitializeAIController()
	return ..()

/datum/status_effect/red_possess/tick()//delete the status if sanity is restored or a panic occurs
	..()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanityhealth == status_holder.maxSanity)
		qdel(src)
	if(status_holder.sanity_lost)
		qdel(src)

//***Custom Panic Definiton***
/datum/ai_controller/insane/red_possess//define AI controller
	lines_type = /datum/ai_behavior/say_line/insanity_red_possess

/datum/ai_behavior/say_line/insanity_red_possess
	lines = list(
		"Where is everyone?",
		"Guys, look at me! I've got such nice shoes on!",
		"You all need to see how lovely my shoes are!",
		"They're much prettier with blood on them.",
	)

/datum/ai_controller/insane/red_possess/SelectBehaviors(delta_time)//Selects red shoes as the target
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return
	var/mob/living/simple_animal/hostile/abnormality/red_shoes/shoes
	for(var/mob/living/simple_animal/hostile/abnormality/red_shoes/M in GLOB.mob_living_list)
		if(!istype(M))
			continue
		shoes = M
	if (!shoes)//No runtimes after suppression, woohoo!
		return
	if(shoes.status_flags & GODMODE)//don't get possessed if it's already breaching
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/desire_move)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = shoes

/datum/ai_behavior/desire_move//define AI behavior
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	var/list/current_path = list()

/datum/ai_behavior/desire_move/perform(delta_time, datum/ai_controller/controller)//Paths the pancicked to red shoes, causes runtimes if it's dead
	. = ..()
	var/walkspeed = 1
	var/mob/living/carbon/human/living_pawn = controller.pawn//the panicked
	if(IS_DEAD_OR_INCAP(living_pawn))//stop if the panicked is dead
		return
	var/mob/living/simple_animal/hostile/abnormality/red_shoes/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!istype(target))
		finish_action(controller, FALSE)
		return
	if(!LAZYLEN(current_path))
		current_path = get_path_to(living_pawn, target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 80)
		if(!current_path) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
	if(!ishuman(living_pawn))
		return
	walkspeed -= (max(0.95,((get_attribute_level(living_pawn, JUSTICE_ATTRIBUTE)) * 0.01)))//one-hundreth of a second for every point of justice, capped at 95
	addtimer(CALLBACK(src, PROC_REF(Movement), controller), walkspeed SECONDS, TIMER_UNIQUE)
	if(isturf(target.loc) && living_pawn.Adjacent(target))
		finish_action(controller, TRUE)
		return

/datum/ai_behavior/desire_move/proc/Movement(datum/ai_controller/controller)//Ditto
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/red_shoes/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!target)
		if(living_pawn)//there's a runtime if you panic right next to it
			living_pawn.SanityLossEffect(FORTITUDE_ATTRIBUTE)//switch to a murder panic
		return
	if(!LAZYLEN(current_path))
		living_pawn.SanityLossEffect(FORTITUDE_ATTRIBUTE)//ditto
		return
	var/target_turf = current_path[1]
	step_towards(living_pawn, target_turf)
	current_path.Cut(1, 2)
	if(target)
		if(isturf(target.loc) && living_pawn.Adjacent(target))
			finish_action(controller, TRUE)
			return

/datum/ai_behavior/desire_move/finish_action(datum/ai_controller/controller, succeeded)//When the panicked reach Red Shoes
	. = ..()
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/obj/item/held = living_pawn.get_active_held_item()
	var/mob/living/simple_animal/hostile/abnormality/red_shoes/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(succeeded)
		living_pawn.dropItemToGround(held)
		target.Assimilate(living_pawn)//breaches red shoes with target as the argument for user
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

//Simple mob
/mob/living/simple_animal/hostile/red_shoe
	name = "Red Shoe"
	desc = "Teeth and leg bones jut out of this ragged shoe, as if the wearer's will was made manifest."
	health = 800
	maxHealth = 800
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "redshoes_breach2"
	icon_living = "redshoes_breach2"
	icon_dead = "redshoes_breach2"//dels on death
	gender = NEUTER
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.5)
	del_on_death = TRUE
	death_message = "crumples into a pile of bones."
	attack_sound = 'sound/abnormalities/redshoes/RedShoes_Attack.ogg'
	melee_damage_lower = 15
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	speed = 1
	move_to_delay = 3
	var/steppy = 0

/mob/living/simple_animal/hostile/red_shoe/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		ChopFeet(H)

/mob/living/simple_animal/hostile/red_shoe/proc/ChopFeet(mob/living/carbon/human/H)
	var/obj/item/bodypart/l_foot = H.get_bodypart(BODY_ZONE_L_LEG)//Feet are defined as BODY_ZONE_PRECISE_L_FOOT. Does the dismember proc not affect them?
	var/obj/item/bodypart/r_foot = H.get_bodypart(BODY_ZONE_R_LEG)
	if(HAS_TRAIT(H, TRAIT_NODISMEMBER))
		return
	if(!l_foot && !r_foot)//stops spamming the sound effect after being applied once
		return
	playsound(src, 'sound/abnormalities/redshoes/RedShoes_Kill.ogg', 100, 1)
	l_foot?.dismember()
	r_foot?.dismember()


//*** Pedestal ***//
/obj/structure/redshoes_cushion
	name = "red pedestal"
	desc = "The shoes must be in high regard.."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "redshoes_cushion"
	anchored = TRUE
	density = FALSE
	layer = BELOW_MOB_LAYER//beneath the shoes
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE

#undef STATUS_EFFECT_REDPOSSESS
