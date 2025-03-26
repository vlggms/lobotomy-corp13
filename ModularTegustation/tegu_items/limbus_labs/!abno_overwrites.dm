/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		suffocation_range = 1

/mob/living/simple_animal/hostile/abnormality/nothing_there/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 1500
		maxHealth = 1500
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2))

/mob/living/simple_animal/hostile/abnormality/scorched_girl/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 600
		boom_damage = 80

/mob/living/simple_animal/hostile/abnormality/general_b/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 2000
		maxHealth = 2000
		ChangeResistances(list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1))
		melee_damage_lower = 35
		melee_damage_upper = 47
		faction = list("neutral", "bee")

/mob/living/simple_animal/hostile/abnormality/hatred_queen/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		beam_damage = 4
		beats_damage = 80
		faction = list("neutral")

/mob/living/simple_animal/hostile/abnormality/steam/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5))

/mob/living/simple_animal/hostile/abnormality/nosferatu/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5))
		summon_cooldown_time = 60 MINUTES
		bat_spawn_number = 0
		faction = list("neutral", "nosferatu")

//The faction changes let them kill each other with their abilities while sentient
/mob/living/simple_animal/hostile/abnormality/nosferatu/Login()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("nosferatu")

/mob/living/simple_animal/hostile/abnormality/nosferatu/Logout()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral", "nosferatu")

/mob/living/simple_animal/hostile/nosferatu_mob/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral", "nosferatu")

/mob/living/simple_animal/hostile/nosferatu_mob/Login()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("hostile", "nosferatu")

/mob/living/simple_animal/hostile/nosferatu_mob/Logout()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral", "nosferatu")

/mob/living/simple_animal/hostile/abnormality/red_hood/Login()
	. = ..()
	faction = list("redhood")

/mob/living/simple_animal/hostile/abnormality/kqe/Login()
	. = ..()
	faction = list("kqe")

/mob/living/simple_animal/hostile/abnormality/funeral/Login()
	. = ..()
	faction = list("funeral")

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Login()
	. = ..()
	faction = list("blueshep")

/mob/living/simple_animal/hostile/abnormality/fragment/Login()
	. = ..()
	faction = list("fragment")

/mob/living/simple_animal/hostile/abnormality/woodsman/Login()
	. = ..()
	faction = list("oz")

/mob/living/simple_animal/hostile/abnormality/mountain/Login()
	. = ..()
	faction = list("mosb")

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/Login()
	. = ..()
	faction = list("piscine")

/mob/living/simple_animal/hostile/abnormality/scorched_girl/Login()
	. = ..()
	faction = list("scorched")

/mob/living/simple_animal/hostile/abnormality/clouded_monk/Login()
	. = ..()
	faction = list("monk")

/mob/living/simple_animal/hostile/abnormality/general_b/Login()
	. = ..()
	faction = list("bee")

/mob/living/simple_animal/hostile/abnormality/general_b/Logout()
	. = ..()
	faction = list("neutral", "bee")

/mob/living/simple_animal/hostile/soldier_bee/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral", "bee")

/mob/living/simple_animal/hostile/soldier_bee/Login()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("hostile", "bee")

/mob/living/simple_animal/hostile/soldier_bee/Logout()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral", "bee")

/mob/living/simple_animal/hostile/laetitia/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral", "laetitia")

/mob/living/simple_animal/hostile/laetitia/Login()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("laetitia")

/mob/living/simple_animal/hostile/laetitia/Logout()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral", "laetitia")
