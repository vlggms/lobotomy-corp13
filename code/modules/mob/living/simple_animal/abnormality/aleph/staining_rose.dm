#define STATUS_EFFECT_WILTING /datum/status_effect/wilting
#define STATUS_EFFECT_SCHISMATIC /datum/status_effect/schismatic
#define STATUS_EFFECT_SACRIFICE /datum/status_effect/sacrifice
//Coded by me, Kirie Saito!
/mob/living/simple_animal/hostile/abnormality/staining_rose
	name = "Staining Rose"
	desc = "A tiny, wilting rose."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "rose"
	portrait = "staining_rose"
	maxHealth = 10
	health = 10			//It's a rose lol
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 30, 40),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 45, 50),
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
		/datum/ego_datum/armor/flowering,
	)
	gift_type = /datum/ego_gifts/blossoming
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/chosen
	var/list/sacrificed = list()
	var/list/heretics = list()
	var/meltdown_cooldown_time = 15 MINUTES
	var/meltdown_cooldown
	var/safe = FALSE //work on it and you're safe for 15 minutes
	var/reset_time = 3 MINUTES //Qliphoth resets after this time


/mob/living/simple_animal/hostile/abnormality/staining_rose/Initialize()
	. = ..()
	meltdown_cooldown = world.time + meltdown_cooldown_time

/mob/living/simple_animal/hostile/abnormality/staining_rose/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	safe = TRUE
	if (chosen == null)
		chosen = user
		user.visible_message(span_warning("You are now Staining Rose's Chosen."))
		icon_state = "rose_activated"

	if (user != chosen)		//Your body starts to wilt.
		user.visible_message(span_warning("Staining Rose already has a Chosen named [chosen]!"))
		user.apply_status_effect(STATUS_EFFECT_SCHISMATIC)
		if(!(user in heretics))
			heretics += user
		pissed()
	else
		user.visible_message(span_warning("Staining Rose is content."))

	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 100)
		user.apply_status_effect(STATUS_EFFECT_SACRIFICE)
		if(!(user in sacrificed))
			sacrificed += user
			user.visible_message(span_warning("Staining Rose drains your strength, and it is born anew."))
			meltdown_cooldown = world.time + meltdown_cooldown_time	//There we go!
		pissed()

/mob/living/simple_animal/hostile/abnormality/staining_rose/Life()
	. = ..()
	if(meltdown_cooldown < world.time && !datum_reference.working)
		meltdown_cooldown = world.time + meltdown_cooldown_time
		sound_to_playing_players('sound/abnormalities/rose/meltdown.ogg')	//Church bells ringing, whether it happens or not.
		if(chosen)
			to_chat(chosen, span_boldwarning("Staining Rose requires you to resonate with it again!"))
		if(!safe)
			datum_reference.qliphoth_change(-1)
		safe = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/pissed()
	var/matrix/init_transform = transform
	animate(src, transform = transform*2, time = 3, easing = BACK_EASING|EASE_OUT)
	icon_state = "rose_pissed"
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)
	icon_state = "rose_activated"

//Death and Meltdown
/mob/living/simple_animal/hostile/abnormality/staining_rose/ZeroQliphoth(mob/living/carbon/human/user)
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
	telegraph_message = span_warning("The petals are falling. They're so beautiful...")
	telegraph_duration = 300
	telegraph_overlay = "petal"
	weather_message = span_userdanger("<i>You can feel yourself wilting away like a delicate rose.</i>")
	weather_overlay = "petal_harsh"
	weather_duration_lower = 1500		//2.5-5 minutes.
	weather_duration_upper = 3000
	end_duration = 100
	end_message = span_boldannounce("The last of the petals are falling. You'll never forget it.")
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
	duration = 5 MINUTES // Can end early when the weather ends
	alert_type = null

/datum/status_effect/wilting/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 0.5
	status_holder.physiology.white_mod /= 0.5
	status_holder.physiology.black_mod /= 0.5
	status_holder.physiology.pale_mod /= 0.5

/datum/status_effect/wilting/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.5
	status_holder.physiology.white_mod *= 0.5
	status_holder.physiology.black_mod *= 0.5
	status_holder.physiology.pale_mod *= 0.5


//SCHISMATIC
//Decrease defenses of heretics.
/datum/status_effect/schismatic
	id = "schismatic"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1		//Lasts until the rose dies
	alert_type = /atom/movable/screen/alert/status_effect/schismatic

/atom/movable/screen/alert/status_effect/schismatic
	name = "Schismatic"
	desc = "You have ruined the sanctity between the rose and its chosen and have been punished."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "schismatic"

/datum/status_effect/schismatic/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 0.8
	status_holder.physiology.white_mod /= 0.8
	status_holder.physiology.black_mod /= 0.8
	status_holder.physiology.pale_mod /= 0.8

/datum/status_effect/schismatic/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.8
	status_holder.physiology.white_mod *= 0.8
	status_holder.physiology.black_mod *= 0.8
	status_holder.physiology.pale_mod *= 0.8


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
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "sacrifice"

/datum/status_effect/sacrifice/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 0.7
	status_holder.physiology.white_mod /= 0.7
	status_holder.physiology.black_mod /= 0.7
	status_holder.physiology.pale_mod /= 0.7

/datum/status_effect/sacrifice/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.7
	status_holder.physiology.white_mod *= 0.7
	status_holder.physiology.black_mod *= 0.7
	status_holder.physiology.pale_mod *= 0.7

#undef STATUS_EFFECT_WILTING
#undef STATUS_EFFECT_SCHISMATIC
#undef STATUS_EFFECT_SACRIFICE
