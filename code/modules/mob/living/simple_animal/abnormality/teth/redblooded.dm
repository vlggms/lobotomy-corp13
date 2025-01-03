/mob/living/simple_animal/hostile/abnormality/redblooded
	name = "Red Blooded American"
	desc = "A bright red demon with oversized arms and greasy black hair. It is keeping its eyes focused on you."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "american_idle"
	icon_living = "american_idle"
	core_icon = "american"
	portrait = "red_blooded_american"
	var/icon_furious = "american_idle_injured"
	del_on_death = TRUE
	maxHealth = 825
	health = 825
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 4
	attack_sound = 'sound/weapons/ego/mace1.ogg'
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	casingtype = /obj/item/ammo_casing/caseless/true_patriot
	projectilesound = 'sound/weapons/gun/shotgun/shot.ogg'
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 10
	melee_damage_upper = 15
	faction = list("hostile")
	speak_emote = list("snarls")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 55, 60, 60),
	)
	max_boxes = 14
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/patriot,
		/datum/ego_datum/armor/patriot,
	)
	gift_type = /datum/ego_gifts/patriot
	gift_message = "Protect and serve."
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "\"I was a good soldier, you know.\" <br>\
		\"Blowing freakshits away with my shotgun. <br>Talking with my brothers in arms.\" <br>\
		\"That's all I ever needed. <br>All I ever wanted. <br>Even now, I fight for the glory of my country.\" <br>\
		\"Do you have anything, anyone, to serve and protect?\""
	observation_choices = list(
		"I do" = list(TRUE, "\"Heh.\" <br>\
			\"We might not be on the same side but I can respect that.\" <br>\
			\"Go on then, freak. <br>Show me that you can protect what matters to you.\""),
		"I don't" = list(FALSE, "\"Feh. <br>Then what's the point of living, huh?\" <br>\
			\"Without a flag to protect, without a goal to achieve...\" <br>\
			\"Are you any better than an animal? <br>Get out of my sight.\""),
	)

	var/bloodlust = 0 //more you do repression, more damage it deals. decreases on other works.
	var/list/fighting_quotes = list(
		"Go ahead, freakshit! Do your best!",
		"Pft. Go ahead and try, freakshit.",
		"Good, something fun for once. Go ahead, freakshit.",
		"One of you finally has some balls.",
		"Pathetic. You're too weak for this, you know?",
	)

	var/list/bored_quotes = list(
		"Boring. C'mon, we both know a little roughhousing would be better.",
		"Aw, what a wimp. Alright, you do your thing, pansy.",
		"Yawn. Damn, you freakshits are lame.",
		"Commies. None of them have any fight in them, do they?",
		"Why was I sent here if I was just going to sit around waiting all day?",
	)

	var/list/breach_quotes = list(
		"Time to wipe you freakshits out!",
		"HA! It's over for you freaks!",
		"You're outmatched! Just drop dead already!",
		"Eat shit, you fucking commies!",
		"This is going to be fun!",
	)

/mob/living/simple_animal/hostile/abnormality/redblooded/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_amount = 6 + bloodlust
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		say(pick(fighting_quotes))
		bloodlust +=2
	if(bloodlust >= 6)
		icon_state = icon_furious
	else
		icon_state = "american_idle"
	return ..()

/mob/living/simple_animal/hostile/abnormality/redblooded/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50)) //slightly higher than other TETHs, given that the counter can be raised
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/redblooded/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/redblooded/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(1)
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		if(bloodlust > 0)
			bloodlust -= ( 1 + round(bloodlust / 5)) //just to keep high bloodlust from being impossibly hard to lower
		if(bloodlust == 0)
			say(pick(bored_quotes))
	return ..()

/mob/living/simple_animal/hostile/abnormality/redblooded/ZeroQliphoth(mob/living/carbon/human/user)
	say(pick(breach_quotes))
	BreachEffect()
	return

/mob/living/simple_animal/hostile/abnormality/redblooded/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = "american_aggro"
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/redblooded/MoveToTarget(list/possible_targets)
	if(ranged_cooldown <= world.time)
		OpenFire(target)
	return ..()

/mob/living/simple_animal/hostile/abnormality/redblooded/OpenFire(atom/A)
	if(get_dist(src, A) <= 2)
		return FALSE
	return ..()

//Projectiles
/obj/item/ammo_casing/caseless/true_patriot
	name = "true patriot casing"
	desc = "a true patriot casing"
	projectile_type = /obj/projectile/true_patriot
	pellets = 6
	variance = 25

/obj/projectile/true_patriot
	name = "american pellet"
	desc = "100% real, surplus military ammo."
	damage_type = RED_DAMAGE

	damage = 8
