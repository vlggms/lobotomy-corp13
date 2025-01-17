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
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 15,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

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

	var/captured_souls = 0

	var/resistance_decrease = 0.5

	var/base_red_resistance = 0.7
	var/base_white_resistance = 1.2
	var/base_black_resistance = 0.4
	var/base_pale_resistance = 1.5

	var/new_red_resistance = 0.7
	var/new_white_resistance = 1.2
	var/new_black_resistance = 0.4
	var/new_pale_resistance = 1.5

	var/damage_down = 5

/mob/living/simple_animal/hostile/abnormality/warden/Login()
	. = ..()
	to_chat(src, "<h1>You are Warden, A Tank Role Abnormality.</h1><br>\
		<b>|Soul Guard|: You are immune to all projectiles.<br>\
		<br>\
		|Soul Warden|: If you attack a corpse, you will dust it, heal and gain a stack of “Captured Soul”<br>\
		For each stack of “Captured Soul”, you become faster, deal 10 less melee damage and take 50% more damage.</b>")

/mob/living/simple_animal/hostile/abnormality/warden/AttackingTarget(atom/attacked_target)
	. = ..()
	if(.)
		if(finishing)
			return FALSE
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = attacked_target

		if(H.health < 0)

			finishing = TRUE
			icon_state = "warden_attack"
			playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 50, 1)
			SLEEP_CHECK_DEATH(5)

			//Takes your skin and leaves your bone. You are now a flesh servant under her skirt in GBJ
			H.dust()

			// it gets faster.

			if(IsCombatMap())
				captured_souls++
				new_red_resistance = (base_red_resistance + resistance_decrease * captured_souls)
				new_white_resistance = (base_white_resistance + resistance_decrease * captured_souls)
				new_black_resistance = (base_black_resistance + resistance_decrease * captured_souls)
				new_pale_resistance = (base_pale_resistance + resistance_decrease * captured_souls)
				ChangeResistances(list(RED_DAMAGE = new_red_resistance, WHITE_DAMAGE = new_white_resistance, BLACK_DAMAGE = new_black_resistance, PALE_DAMAGE = new_pale_resistance))
				to_chat(src, span_warning("As you capture a soul, you feel that you are growing more... Fragile."))

			if(move_to_delay>1)
				ChangeMoveToDelayBy(0.75, TRUE)
				if(melee_damage_lower > 30)
					melee_damage_lower -= damage_down
				if(IsCombatMap())
					if(melee_damage_upper > 30)
						melee_damage_upper -= damage_down
			adjustBruteLoss(-(maxHealth*0.2)) // Heals 20% HP, fuck you that's why. Still not as bad as judgement or big bird

			finishing = FALSE
			icon_state = "warden"

/mob/living/simple_animal/hostile/abnormality/warden/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/warden/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
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
	..()

/mob/living/simple_animal/hostile/abnormality/warden/bullet_act(obj/projectile/P)
	visible_message(span_userdanger("[src] is unfazed by \the [P]!"))
	new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
	P.Destroy()
