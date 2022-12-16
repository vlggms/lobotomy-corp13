/mob/living/simple_animal/hostile/abnormality/touchme
	name = "Don't touch me"
	desc = "You feel like you shouldn't touch this."
	icon_state = "touch"
	icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	maxHealth = 50
	health = 50
	threat_level = ZAYIN_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = 0,
						ABNORMALITY_WORK_ATTACHMENT = 0,
						ABNORMALITY_WORK_REPRESSION = 0
						)
	work_damage_amount = 1
	work_damage_type = PALE_DAMAGE	//You will die anyways lol

	ego_list = list()


/mob/living/simple_animal/hostile/abnormality/touchme/AttemptWork(mob/living/carbon/human/user, work_type)
	KillEveryone()

/mob/living/simple_animal/hostile/abnormality/touchme/attack_hand(mob/living/carbon/human/user)
	KillEveryone()

/mob/living/simple_animal/hostile/abnormality/touchme/proc/KillEveryone()
	for(var/mob/living/carbon/human/M in GLOB.player_list)
		flash_color(M, flash_color = COLOR_RED, flash_time = 150)
		M.playsound_local(M, pick('sound/abnormalities/donttouch/kill.ogg', 'sound/abnormalities/donttouch/kill2.ogg'), 50, FALSE)
		M.gib()
