//ripped off of wall gazer, sorry devs
/mob/living/simple_animal/hostile/abnormality/mailpile
	name = "Letters on Standby"
	desc = "A pile of stamped letters, none reaching their intended receiver."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "mailbox"
	maxHealth = 100
	health = 100
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 40, 50, 60, 70),
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 40, 30),
		ABNORMALITY_WORK_REPRESSION = 0,
		)
	pixel_x = 0
	base_pixel_x = 0

	work_damage_amount = 5
	work_damage_type = RED_DAMAGE

	gift_type =  /datum/ego_gifts/mail
	gift_message = "An empty envelope slowly makes its way into your hands."

	max_boxes = 12

	ego_list = list(
		/datum/ego_datum/weapon/letter_opener,
		/datum/ego_datum/armor/letter_opener
		)
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	var/cooldown
	var/cooldown_time = 10 SECONDS
	var/spawned_effects = list()

/mob/living/simple_animal/hostile/abnormality/mailpile/Destroy()
	..()
	for(var/obj/effect/VFX in spawned_effects)
		VFX.Destroy()
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/Initialize(mapload)
	. = ..()

	for(var/dir in GLOB.alldirs)
		var/turf/dispense_turf = get_step(src, dir)
		var/obj/effect/letters_flow/TMP = new(dispense_turf)
		spawned_effects += TMP

//papercut due to failed work
/mob/living/simple_animal/hostile/abnormality/mailpile/WorktickFailure(mob/living/carbon/human/user)
	..()
	if(prob(10))
		to_chat(user,"<span class='warning'>Ouch! I got a paper cut!</span>")
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/DeliveryRepress(mob/living/carbon/human/user, work_type, pe, work_time)
	if(cooldown < world.time)
		to_chat(user,"<span class='warning'>You realized you have made a grave mistake as envelopes start flying out of the mailbox towards you.</span>")
		user.Stun(10 SECONDS)
		var/letterssave = list()
		for(var/i = 1 to 4)
			var/obj/item/mailpaper/hatred/MAIL = new(get_turf(src))
			MAIL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
			letterssave += MAIL
			sleep(1 SECONDS)
		user.gib()
		sleep(5 SECONDS)
		for(var/obj/item/mailpaper/MAIL in letterssave)
			qdel(MAIL)
		return

	cooldown = world.time + cooldown_time

	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)

	if(prob(25))
		var/obj/item/parcelself/PARCEL = new(get_turf(src),user)
		PARCEL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	else
		var/obj/item/mailpaper/junk/MAIL = new(get_turf(src))
		MAIL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/Delivery(mob/living/carbon/human/user, work_type, pe, work_time)
	if(prob(60))
		to_chat(user,"<span class='notice'>It seems the pile did not find a message for you.</span>")
		return
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)

	to_chat(user,"<span class='notice'>One of the letters from the pile slowly waves in the air.</span>")
	var/obj/item/mailpaper/MAIL
	if(prob(20))
		if(prob(10))
			MAIL = new /obj/item/mailpaper/pipebomb(get_turf(src))
		else
			MAIL = new /obj/item/mailpaper/junk(get_turf(src))
	else
		switch(work_type)
			if(ABNORMALITY_WORK_INSTINCT)
				MAIL = new /obj/item/mailpaper/instinct(get_turf(src),user)
			if(ABNORMALITY_WORK_INSIGHT)
				MAIL = new /obj/item/mailpaper/insight(get_turf(src),user)
			if(ABNORMALITY_WORK_ATTACHMENT)
				MAIL = new /obj/item/mailpaper/attachment(get_turf(src),user)
	MAIL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	return
//players get a parcel / letters for completing works
/mob/living/simple_animal/hostile/abnormality/mailpile/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		DeliveryRepress(user,work_type,pe)
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	Delivery(user,work_type,pe)
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	Delivery(user,work_type,pe)
	return

//what the fuck is this
/obj/effect/letters_flow
	name = "storm of letters"
	desc = "The storm rages on."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "letters"
	layer = ABOVE_MOB_LAYER

//x2 workspeed buff pro 2022 free hack free robux
/datum/status_effect/workspeed_buff
	id = "workspeed_buff"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/workspeed_buff
	duration = 6 SECONDS

/datum/status_effect/workspeed_buff/on_apply()
	. = ..()
	var/mob/living/carbon/human/user = owner
	user.physiology.work_speed_mod *= 1.5

/datum/status_effect/workspeed_buff/on_remove()
	. = ..()
	var/mob/living/carbon/human/user = owner
	user.physiology.work_speed_mod /= 1.5

/atom/movable/screen/alert/status_effect/workspeed_buff
	name = "letter from the past"
	desc = "Reading the letter made you want to try harder for your past friends."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail"

/datum/status_effect/nofear_buff
	id = "nofear_buff"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/nofear_buff
	duration = 6 SECONDS

/datum/status_effect/nofear_buff/on_apply()
	. = ..()
	var/mob/living/carbon/human/user = owner
	ADD_TRAIT(user, TRAIT_WORKFEAR_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_COMBATFEAR_IMMUNE, TRAIT_GENERIC)

/datum/status_effect/nofear_buff/on_remove()
	. = ..()
	var/mob/living/carbon/human/user = owner
	REMOVE_TRAIT(user,TRAIT_WORKFEAR_IMMUNE,TRAIT_GENERIC)
	REMOVE_TRAIT(user,TRAIT_COMBATFEAR_IMMUNE,TRAIT_GENERIC)

/atom/movable/screen/alert/status_effect/nofear_buff
	name = "letter from the present"
	desc = "Reading the letter made you fearless."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail"

//yes this is ripped off of paper and mermaid gift but fuck you.
/obj/item/parcelself
	name = "Parcel from your alternate self"
	desc = "You should not see this."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "parcel"
	inhand_icon_state = "parcel"
	worn_icon_state = "parcel"
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	gender = NEUTER
	color = "white"
	var/mob/living/carbon/receiver = null

//this is using the parcel. you either go insane or get special ego
/obj/item/parcelself/attack_self(mob/living/carbon/human/user)
	if(receiver != user)
		to_chat(user,"<span class='notice'>It feels wrong to try to open someone else's package.</span>")
		return
	if(prob(50))
		new /obj/item/ego_weapon/mail_satchel(get_turf(user))
		to_chat(user,"<span class='nicegood'>As you unravel the parcel a satchel falls out.</span>")
	else
		new /obj/item/clothing/suit/armor/ego_gear/zayin/letter_opener(get_turf(user))
		to_chat(user,"<span class='nicegood'>As you unravel the parcel an outfit falls out.</span>")
	qdel(src)
	return

/obj/item/parcelself/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "This parcel seems to be addressed to \a [user]. Where did it come from..?"
	receiver = user

/obj/item/mailpaper
	name = "Mail"
	desc = "One of the letters from the pile slowly waves in the air."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail"
	inhand_icon_state = "mail"
	worn_icon_state = "mail"
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	gender = NEUTER
	color = "white"

/obj/item/mailpaper/pipebomb
	name = "Suspicious letter"
	desc = "letter addressed to a scratched out name, by... Neco-Arc?"

/obj/item/mailpaper/pipebomb/attack_self(mob/living/carbon/human/user)
	to_chat(user,"<span class='warning'>What is this... Is this a pipebomb!?</span>")
	sleep(10)
	//add glitterbomb sfx, maybe a toot horn or something funny
	for(var/direction in GLOB.alldirs)
		var/turf/dispense_turf = get_step(src, direction)
		new /obj/effect/decal/cleanable/glitter(dispense_turf)
	qdel(src)

/obj/item/mailpaper/junk
	var/JUNKMAIL = list(list("letter from RobustCO","The outside reads 'Improve your robustness today! Read our letter now!"),list("Suspicious message","Ever felt like you need a boost? Get swole today!"))

/obj/item/mailpaper/junk/Initialize()
	. = ..()
	var/temp = pick(JUNKMAIL)
	name = temp[1]
	desc = temp[2]

/obj/item/mailpaper/junk/attack_self(mob/living/carbon/human/user)
	to_chat(user,"<span class='notice'>This was a waste of time....</span>")
	user.adjustSanityLoss(5)
	qdel(src)

/obj/item/mailpaper/hatred
	name = "A hastily written angry letter"
	desc = "IHATEYOUIHATEYOUIHATEYOUIHATEYOUIHATEYOU."

/obj/item/mailpaper/hatred/attack_self(mob/living/carbon/human/user)
	to_chat(user,"<span class='warning'>The pages are filled with scribbles and threats...</span>")
	user.adjustSanityLoss(5)
	qdel(src)

/obj/item/mailpaper/instinct

/obj/item/mailpaper/instinct/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "A past letter from a friend addressed to \a [user]. The thought of such conduct makes you feel happy, albeit bittersweet."

/obj/item/mailpaper/instinct/attack_self(mob/living/carbon/human/user)
	to_chat(user,"<span class='nicegood'>Reading the friendly letter helps you find peace in the passing of time.</span>")
	user.adjustSanityLoss(-5)
	qdel(src)

/obj/item/mailpaper/insight

/obj/item/mailpaper/insight/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "letter from coworkers addressed to \a [user]. It feels quite nostalgic."

/obj/item/mailpaper/insight/attack_self(mob/living/carbon/human/user)
	to_chat(user,"<span class='nicegood'>Reading the letter from your coworkers steel your resolve.</span>")
	if(!HAS_TRAIT(user,TRAIT_WORKFEAR_IMMUNE) && !HAS_TRAIT(user,TRAIT_COMBATFEAR_IMMUNE))
		user.apply_status_effect(/datum/status_effect/nofear_buff)
	qdel(src)

/obj/item/mailpaper/attachment

/obj/item/mailpaper/attachment/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "A promotion letter addressed to \a [user]. The new manager of the corp!?!? Oh wait, that's from the future."

/obj/item/mailpaper/attachment/attack_self(mob/living/carbon/human/user)
	to_chat(user,"<span class='nicegood'>Reading the promotion letter fills you with determination to work harder!</span>")
	var/datum/status_effect/workspeed_buff/TMPEFF = user.has_status_effect(/datum/status_effect/workspeed_buff)
	if (!TMPEFF)
		user.apply_status_effect(/datum/status_effect/workspeed_buff)
	qdel(src)
