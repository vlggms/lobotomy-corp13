#define STATUS_EFFECT_WILTING /datum/status_effect/wilting
#define STATUS_EFFECT_SCHISMATIC /datum/status_effect/schismatic
#define STATUS_EFFECT_SACRIFICE /datum/status_effect/sacrifice
#define STATUS_EFFECT_WONDERLAND /datum/status_effect/wonderland
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
	start_qliphoth = 1
	work_damage_amount = 14
	work_damage_type = PALE_DAMAGE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -8
	base_pixel_y = -8

	ego_list = list(
		/datum/ego_datum/weapon/blooming,
		/datum/ego_datum/armor/blooming,
		/datum/ego_datum/armor/flowering
		)
	gift_type = /datum/ego_gifts/blossoming

	pinkable = FALSE

	var/chosen
	var/list/sacrificed = list()
	var/list/heretics = list()
	var/meltdown_cooldown_time = 15 MINUTES
	var/meltdown_cooldown
	var/safe = FALSE //work on it and you're safe for 15 minutes
	var/reset_time = 3 MINUTES //Qliphoth resets after this time
	var/pink_applied = FALSE


/mob/living/simple_animal/hostile/abnormality/staining_rose/Initialize()
	..()
	meltdown_cooldown = world.time + meltdown_cooldown_time

/mob/living/simple_animal/hostile/abnormality/staining_rose/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	safe = TRUE
	if (chosen == null)
		chosen = user
		user.visible_message("<span class='warning'>You are now the rose's chosen.</span>")
		icon_state = "rose_activated"

	if (user != chosen)		//Your body starts to wilt.
		user.visible_message("<span class='warning'>The rose has already chosen another, [chosen]!</span>")
		user.apply_status_effect(STATUS_EFFECT_SCHISMATIC)
		if(!(user in heretics))
			heretics += user
		pissed()

	else
		user.visible_message("<span class='warning'>The Rose is satisfied.</span>")

	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 100)
		user.apply_status_effect(STATUS_EFFECT_SACRIFICE)
		if(!(user in sacrificed))
			sacrificed += user
			user.visible_message("<span class='warning'>The rose adds your strength to it, and it is born anew.</span>")
			meltdown_cooldown = world.time + meltdown_cooldown_time	//There we go!
		pissed()

/mob/living/simple_animal/hostile/abnormality/staining_rose/Life()
	. = ..()
	if(meltdown_cooldown < world.time && !datum_reference.working)
		meltdown_cooldown = world.time + meltdown_cooldown_time
		sound_to_playing_players('sound/abnormalities/rose/meltdown.ogg')	//Church bells ringing, whether it happens or not.
		if(chosen)
			to_chat(chosen, "<span class='warning'>The rose requires you.</span>")
		if(!safe)
			datum_reference.qliphoth_change(-1)
		safe = FALSE
	if(!pink_applied && !isnull(chosen))
		var/pink_midnight
		for(var/mob/living/simple_animal/hostile/A in GLOB.mob_list)
			if(A != src)
				if("pink_midnight" in A.faction)
					pink_midnight = TRUE
					break
		if(pink_midnight && ishuman(chosen))
			var/mob/living/carbon/human/blessed = chosen
			blessed.apply_status_effect(STATUS_EFFECT_WONDERLAND)
			pink_applied = TRUE
	return

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
	//Clean up the sacrificed and schismatic
	for(var/mob/living/carbon/human/G in sacrificed)
		G.remove_status_effect(STATUS_EFFECT_SACRIFICE)
	for(var/mob/living/carbon/human/G in heretics)
		G.remove_status_effect(STATUS_EFFECT_SCHISMATIC)
	death()	//It wilts away.

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

/datum/weather/petals/end()
	..()
	//Remove it. If we keep it then people will cheese a respawn to remove it
	for(var/mob/living/carbon/human/L in GLOB.player_list)
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


//SCHISMATIC
//Decrease defenses of heretics.
/datum/status_effect/schismatic
	id = "schismatic"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1		//Lasts until the rose dies
	alert_type = /atom/movable/screen/alert/status_effect/schismatic

/atom/movable/screen/alert/status_effect/schismatic
	name = "Schismatic"
	desc = "You have ruined the sanctity between the rose and it's chosen and have been punished."

/datum/status_effect/schismatic/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 0.8
		L.physiology.white_mod /= 0.8
		L.physiology.black_mod /= 0.8
		L.physiology.pale_mod /= 0.8

/datum/status_effect/schismatic/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 0.8
		L.physiology.white_mod *= 0.8
		L.physiology.black_mod *= 0.8
		L.physiology.pale_mod *= 0.8


//SACRIFICE
//Decrease defenses of sacrifices.
/datum/status_effect/sacrifice
	id = "sacrifice"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1		//Lasts until the rose dies
	alert_type = /atom/movable/screen/alert/status_effect/sacrifice

/atom/movable/screen/alert/status_effect/sacrifice
	name = "Sacrifice"
	desc = "You have sacrificed a bit of yourself to the rose."

/datum/status_effect/sacrifice/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 0.7
		L.physiology.white_mod /= 0.7
		L.physiology.black_mod /= 0.7
		L.physiology.pale_mod /= 0.7

/datum/status_effect/sacrifice/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 0.7
		L.physiology.white_mod *= 0.7
		L.physiology.black_mod *= 0.7
		L.physiology.pale_mod *= 0.7

#undef STATUS_EFFECT_WILTING
#undef STATUS_EFFECT_SCHISMATIC
#undef STATUS_EFFECT_SACRIFICE

/datum/status_effect/wonderland
	id = "wonderland"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/wonderland

/datum/status_effect/wonderland/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(L, "<span class='notice'>An unfamiliar strength fills you.</span>")
		L.physiology.black_mod *= 0.7
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)

/datum/status_effect/wonderland/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(L, "<span class='notice'>It passess by, as all things shall.</span>")
		L.physiology.black_mod /= 0.7
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10)

/atom/movable/screen/alert/status_effect/wonderland
	name = "Face the Fear, Build the Future"
	desc = "Only one can show her the way home from Wonderland."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "fairy_bastard"

#undef STATUS_EFFECT_WONDERLAND
