/mob/living/simple_animal/hostile/abnormality/schadenfreude
	name = "Schadenfreude"
	desc = "A box with a keyhole. You don't want to know what's inside."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "schadenfreude"
	icon_living = "schadenfreude"
	pixel_x = -16
	base_pixel_x = -16
	del_on_death = TRUE
	maxHealth = 1800		//It's fucking slow as hell, and you can beat it to death if you're alone for free
	health = 1800
	move_to_delay = 5
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.7)
	melee_damage_lower = 40		//Yeah it's super slow, and you're not gonna get hit by it too often
	melee_damage_upper = 48
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/scarecrow/attack.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 4
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = list(30, 40, 40, 50, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 40, 30, 20),
						ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 55, 60)
						)
	work_damage_amount = 7
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/gaze,
		/datum/ego_datum/armor/gaze
		)
//	gift_type =  /datum/ego_gifts/gaze

	var/seen	//Are you being looked at right now?

//Sight Check
/mob/living/simple_animal/hostile/abnormality/schadenfreude/Life()
	. = ..()
	//Make sure there actually are two players on the Z level
	var/living_players
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z == z && H.stat != DEAD)
			living_players +=1
	if(living_players == 1)
		seen = TRUE
		damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 1.5)
		return

	//Who is watching us
	var/people_watching
	for(var/mob/living/carbon/human/L in viewers(world.view + 1, src))
		if(L.client && CanAttack(L) && L.stat != DEAD)
			if(!L.is_blind())
				people_watching+=1

	//Only gets mad if there are two people looking at you. If there are 3 or more the counter decreases.
	if(people_watching >= 3)
		datum_reference.qliphoth_change(-1)
	if(people_watching == 1)
		seen = FALSE
		damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.7)
	else	//any amount of people that's not 1.
		seen = TRUE
		damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 1.5)

//Stuff that needs sight check
/mob/living/simple_animal/hostile/abnormality/schadenfreude/Move()
	if(!seen)
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are not enough eyes on you!</span>")
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/schadenfreude/AttackingTarget()
	if(!seen)
		if(client)
			to_chat(src, "<span class='warning'>You cannot attack, there are not enough eyes on you!</span>")
		return FALSE
	..()

//Work stuff
/mob/living/simple_animal/hostile/abnormality/schadenfreude/BreachEffect(mob/living/carbon/human/user)
	..()
	icon_living = "schadenfreude_breach"
	icon_state = icon_living
	GiveTarget(user)

//I'm not writing more snowflake code for this lol. You just take more damage
/mob/living/simple_animal/hostile/abnormality/schadenfreude/Worktick(mob/living/carbon/human/user)
	if(seen)
		to_chat(user, "<span class='warning'>You are injured by schadenfreude!</span>")
		user.apply_damage(work_damage_amount, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(user), pick(GLOB.alldirs))
