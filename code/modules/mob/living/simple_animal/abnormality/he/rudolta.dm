//ho ho hoe -gail
/mob/living/simple_animal/hostile/abnormality/rudolta
	name = "Rudolta of the Sleigh"
	desc = "An abnormality consisting of three parts: A hornless, disfigured reindeer, \"Santa\" and a sleigh. \
	Rudolta is a fair creature that will give gifts equally to everyone, whether you like them or not."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "rudolta"
	icon_living = "rudolta"
	icon_dead = "rudolta_dead"
	portrait = "rudolta"
	maxHealth = 1200
	health = 1200
	pixel_x = -16
	base_pixel_x = -16
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	move_to_delay = 6
	minimum_distance = 2 // Don't move all the way to melee
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 40, 40, 35, 0),
		ABNORMALITY_WORK_INSIGHT = list(50, 60, 60, 55, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 50, 50, 45, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	friendly_verb_continuous = "scorns"
	friendly_verb_simple = "scorns"

	ego_list = list(
		/datum/ego_datum/weapon/christmas,
		/datum/ego_datum/armor/christmas,
	)
	gift_type =  /datum/ego_gifts/christmas
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	//Try not to make other observations this long - This is by PM though so, we have to use it. -Coxswain
	observation_prompt = "I heard about a man who could give you anything you want once a year. <br>Good kids have a better chance of seeing him. <br>\
		A man who carries giant sack on his back. <br>A man who can go anywhere in the world with his reindeer-pulled sled. <br>\
		Alex got a present. <br>Even though he was a naughty kid. <br>It was unfair. <br>I could not accept it. <br>The next Christmas, I went to Alex's. <br>\
		If that man comes only for Alex this time again, I will ask him why had he not come to me. <br>\
		That night, when everyone was sleeping. <br>I waited for the man, sitting next to sleeping Alex. <br>\
		Sometimes, for someone, an absurd fairy tale is a silver lining of hope. <br>When I met Santa, I imagined dismembering him. <br>... <br>\
		In front of me is Santa. <br>My ideal. <br>People don't call it Santa. <br>Something is twitching inside of that sack. I......"
	observation_choices = list(
		"Did not open the sack" = list(TRUE, "Inside of the sack is a desire. <br>\
			A hope that I've been waiting for since when I was very young. <br>I never opened the sack. <br>Did your wish come true?"),
		"Opened the sack" = list(FALSE, "There was something that I have been longing for my entire life. <br>\
			Like Pandora's Box, it will never go back into the sack."),
	)

	var/pulse_cooldown
	var/pulse_cooldown_time = 1.8 SECONDS
	var/pulse_damage = 20

/mob/living/simple_animal/hostile/abnormality/rudolta/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/rudolta/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/rudolta/PickTarget(list/Targets)
	return

/mob/living/simple_animal/hostile/abnormality/rudolta/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		WhitePulse()

/mob/living/simple_animal/hostile/abnormality/rudolta/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/rudolta/proc/WhitePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/abnormalities/rudolta/throw.ogg', 50, FALSE, 4)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, WHITE_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

