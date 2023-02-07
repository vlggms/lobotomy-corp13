//Brain go brrrr.
/mob/living/simple_animal/hostile/abnormality/my_sweet_home
	name = "My Sweet Home"
	desc = "This cozy little house is a safe nest built only for you. Everything is here for you..."
	icon = '---'
	icon_state = "---"
	icon_living = "---"
	icon_dead = "---"
	threat_level = TETH_LEVEL
	can_breach = TRUE
	del_on_death = TRUE
	var/icon_aggro = "---"
	var/lc13admin_mode_variable = 0
	max_boxes = 13
	maxHealth = 600
	health = 500
	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 5
	melee_damage_upper = 5
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	rapid_melee = 1
	melee_queue_distance = 3
	retreat_distance = 2
	minimum_distance = 1
	stat_attack = CONSCIOUS
	attack_verb_continuous = "stomps"
	attack_verb_simple = "stomp"
	deathmessage = "crumbles."
	faction = list("hostile")
	zone_selected = BODY_ZONE_CHEST
	start_qliphoth = 1
	vision_range = 10
	aggro_vision_range = 20
	wander = 1


	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = (40, 40, 50, 50, 50),
						ABNORMALITY_WORK_INSIGHT = (40, 40, 50, 50, 50),
						ABNORMALITY_WORK_ATTACHMENT = (70, 70, 80, 80, 90),
						ABNORMALITY_WORK_REPRESSION = (60, 60, 50, 40, 40),
						)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE

	var/list/ok = list() //from FAN, although changed
	var/list/bad = list()

	//ego_list = list(
		///datum/ego_datum/weapon/hkey,//hkey, aka house key
		///datum/ego_datum/armor/hkey
		//)

	//gift_type =  /datum/ego_gifts/hkey

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/AttackingTarget()//pulled from smile
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		L.Knockdown(20)
		var/obj/item/held = L.get_active_held_item()
		L.dropItemToGround(held)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(50))
		datum_reference.qliphoth_change(-1)
		to_chat(user, "<span class='danger'>It whispers in your mind.</span>")
		SLEEP_CHECK_DEATH(3)
		user.gib()
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time) //grabbed from FAN
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		if(user in bad)
			to_chat(user, "<span class='danger'>Oh no.</span>")
			SLEEP_CHECK_DEATH(3)
			user.gib()
			datum_reference.qliphoth_change(-1)
		else if(user in ok)
			bad+=user
		else
			ok+=user
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/update_icon_state() //code grabbed from forsaken_murderer
	if(status_flags & GODMODE)
		icon_state = initial(icon)
	else if(health < 1)
		icon_state = icon_dead
	else
		icon_state = icon_aggro
		if(lc13admin_mode_variable == 1)
			x = x + 2
			y = y - 3