#define STATUS_EFFECT_WILTING /datum/status_effect/wilting
//Coded by me, Kirie Saito!
/mob/living/simple_animal/hostile/abnormality/staining_rose
	name = "Staining Rose"
	desc = "A tiny, wilting rose."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "rose"
	maxHealth = 10
	health = 10			//It's a rose lol
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 30, 40),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 45, 50)
			)
	start_qliphoth = 3
	work_damage_amount = 16
	work_damage_type = PALE_DAMAGE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -8
	base_pixel_y = -8

	ego_list = list(
//		/datum/ego_datum/weapon/blooming,
//		/datum/ego_datum/armor/blooming
		)

	var/chosen
	var/meltdown_cooldown_time = 300 SECONDS
	var/meltdown_cooldown


/mob/living/simple_animal/hostile/abnormality/staining_rose/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if (chosen == null)
		chosen = user
		user.visible_message("<span class='warning'>You are now the rose's chosen.</span>")
		icon_state = "rose_activated"

	if (user != chosen)		//Your body starts to wilt.
		user.visible_message("<span class='warning'>The rose has already chosen another, [chosen]!</span>")
		user.physiology.red_mod *= 1.2
		user.physiology.white_mod *= 1.2
		user.physiology.black_mod *= 1.2
		user.physiology.pale_mod *= 1.2
		datum_reference.qliphoth_change(-1)
		pissed()

	else
		datum_reference.qliphoth_change(1)
		user.visible_message("<span class='warning'>The Rose is satisfied.</span>")

	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 100)
		user.visible_message("<span class='warning'>The Rose is sapping your strength</span>")
		user.physiology.red_mod *= 1.1
		user.physiology.white_mod *= 1.1
		user.physiology.black_mod *= 1.1
		user.physiology.pale_mod *= 1.1
		pissed()

/mob/living/simple_animal/hostile/abnormality/staining_rose/Life()
	. = ..()
	if(meltdown_cooldown < world.time)
		meltdown_cooldown = world.time + meltdown_cooldown_time
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/pissed()
	var/matrix/init_transform = transform
	animate(src, transform = transform*2, time = 3, easing = BACK_EASING|EASE_OUT)
	icon_state = "rose_pissed"
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)
	icon_state = "rose_activated"

//Death and Meltdown
/mob/living/simple_animal/hostile/abnormality/staining_rose/zero_qliphoth(mob/living/carbon/human/user)
	SSweather.run_weather(/datum/weather/petals)
	chosen = null 	//You breached, now pick a new person to work on you
	icon_state = "rose"
	death()	//It wilts away.
	datum_reference.qliphoth_change(3)

/mob/living/simple_animal/hostile/abnormality/staining_rose/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//Weather and such
/datum/weather/petals
	name = "petal storm"
	immunity_type = "petal"
	desc = "Petals shed by the Staining Rose."
	telegraph_message = "<span class='warning'>The petals are falling.... they're so beautiful...</span>"
	telegraph_duration = 300
	telegraph_overlay = "petal"
	weather_message = "<span class='userdanger'><i>The petals are so beautiful, you can feel yourself wilting away</i></span>"
	weather_overlay = "petal_harsh"
	weather_duration_lower = 1500		//2.5-5 minutes.
	weather_duration_upper = 3000
	end_duration = 100
	end_message = "<span class='boldannounce'>The last of the petals are falling. You'll never forget it.</span>"
	area_type = /area
	target_trait = ZTRAIT_STATION

/datum/weather/petals/weather_act(mob/living/carbon/human/L)
	if(ishuman(L))
		L.apply_status_effect(STATUS_EFFECT_WILTING)

/datum/weather/petals/end(mob/living/carbon/human/L)
	..()
	//Remove it. If we keep it then people will cheese a respawn to remove it
	L.remove_status_effect(STATUS_EFFECT_WILTING)

//WILTING
//Decrease defenses of everyone.
/datum/status_effect/wilting
	id = "wilting"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000		//Lasts 5 minutes, or when the weather ends
	alert_type = null

/datum/status_effect/wilting/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 0.5
		L.physiology.white_mod /= 0.5
		L.physiology.black_mod /= 0.5
		L.physiology.pale_mod /= 0.5

/datum/status_effect/wilting/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 0.5
		L.physiology.white_mod *= 0.5
		L.physiology.black_mod *= 0.5
		L.physiology.pale_mod *= 0.5

#undef STATUS_EFFECT_WILTING
