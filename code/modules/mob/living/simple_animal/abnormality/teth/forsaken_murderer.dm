/mob/living/simple_animal/hostile/abnormality/forsaken_murderer //designed to be a very forgiving and standard abnormality.
	name = "Forsaken Murderer"
	desc = "A unhealthy looking human bound in a full body straightjacket. His neck is broken and in the middle of his forehead is a old wound that refuses to heal."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "forsakenmurdererinert"
	icon_living = "forsakenmurdererinert"
	icon_dead = "forsakenmurdererdead"
	var/icon_aggro = "forsakenmurdererbreach" //code stolen from /mob/living/simple_animal/hostile/asteroid/basilisk/watcher
	var/lc13admin_mode_variable = 0 //for variables that are edited during a round.
	del_on_death = FALSE
	maxHealth = 1100 //originally was 270. Fragment health is 800 with a original game health of 230 so techically forsaken murderer has more health than fragment? Ill round the numbers to 600 since 270 can be rounded to 300 and doubled.
	health = 1100 //Was suggested to give them more health, Rationalization of this is that despite being a human body the forsaken murderer is immortal and has a metal head.
	rapid_melee = 1 //attack speed modifier. 2 is twice the normal.
	melee_queue_distance = 2 //If target is close enough start preparing to hit them if we have rapid_melee enabled. Originally was 4.
	move_to_delay = 5 //speed? lower is faster.
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2) //Red damage is applied to health. White damage is applied to sanity with only a few abnormalities using that to instantly kill the victem. Black damage is applied to both health and sanity "10 black damage would do 10 health damage and 10 sanity damage. Pale damage is a % of health. Weird i know.
	melee_damage_lower = 10 //the lowest damage in regular attacks. Normal murderer is 2~4 so we double it.
	melee_damage_upper = 18 // fragments Lobotomy Corp damage was 3~4 so im giving murderer a larger gap between his lower and upper damage. Unsure if i should be comparing Forsaken Murderer to Fragment of the Universe. Most HE level abnormalities do 20+ damange.
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE //is the second half of melee damage type. This the armor type checked when attacking someone.
	stat_attack = CONSCIOUS //originally was HARD_CRIT. This setting makes forsaken murderer attack you until you go into crit.
	attack_sound = 'sound/effects/hit_kick.ogg' //used chrome to listen to these
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	faction = list() //leaving the faction list blank only attributes them to one faction and thats its own unique mob number. With this forsaken murderer will even attack duplicates of themselves.
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(60, 60, 50, 50, 50),
						ABNORMALITY_WORK_INSIGHT = list(40, 40, 30, 30, 30),
						ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 40, 40, 40),
						ABNORMALITY_WORK_REPRESSION = list(30, 20, 0, -80, -80),
						) //work chance fluctuates based on level. left to right as level increase.
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE
	deathmessage = "falls over." //shows in chat when the creature is defeated. Default is "stops moving".
	environment_smash = 1
	speak_chance = 2
	emote_see = list("shakes while mumbling...")
	emote_hear = list("screams!")
	max_boxes = 14
	//success_boxes = 7 //said to be a undefined var
	zone_selected = BODY_ZONE_CHEST //alternate is BODY_ZONE_HEAD but this made damage go past the armor
	speed = 5 //Player speed indipendent of Move to Delay.
	wander = 0 //0 prevents wandering when idle. 1 activates it.
	ego_list = list(
		/datum/ego_datum/weapon/regret,
		/datum/ego_datum/armor/regret
		) //ego_list is the things you can buy with its unique type of PE
	gift_type =  /datum/ego_gifts/regret //special thing you get from interacting with the abnormality
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/FailureEffect(mob/living/carbon/human/user, work_type, pe) //when work type is bad the qliphoth counter lowers with no chance.
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/death(gibbed) //So people see him fall.
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/BreachEffect(mob/living/carbon/human/user) //causes breach?
	..()
	update_icon()
	AddElement(/datum/element/waddling) //This made forsaken murderer waddle. Im supprised it was this easy to do this.
	AddComponent(/datum/component/knockback, 1, FALSE, TRUE) //1 is distance thrown, False is if it can throw anchored objects, True if doesnt apply damage or stun when hits a wall.
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/update_icon_state()
	if(status_flags & GODMODE) // Not breaching
		icon_state = initial(icon)
	else if(health < 1)
		icon_state = icon_dead //to return to original sprite. Honestly a bit at my wits endwith this because the death animation doesnt proc if placed under gib
	else
		icon_state = icon_aggro
		if(lc13admin_mode_variable == 1) //teleports the abnormality out of its cell
			x = x + 2
			y = y - 3
