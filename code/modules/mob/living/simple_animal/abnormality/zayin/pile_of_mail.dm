//ripped off of wall gazer, sorry devs
/mob/living/simple_animal/hostile/abnormality/mailpile
	name = "Letters on Standby"
	desc = "A pile of stamped letters, none reaching their intended receiver."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "mailbox"
	portrait = "pile_of_mail"
	maxHealth = 100
	health = 100
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 40, 30),
		ABNORMALITY_WORK_REPRESSION = 40,
	)

	work_damage_amount = 5
	work_damage_type = RED_DAMAGE

	gift_type =  /datum/ego_gifts/mail
	gift_message = "A postage stamp makes its way to your hands. Without thinking, you stick it on your cheek."

	max_boxes = 12

	ego_list = list(
		/datum/ego_datum/weapon/letter_opener,
		/datum/ego_datum/armor/letter_opener,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "Letters addressed to various addresses and recipients litter the containment cell. <br>\
		Occasionally, some of the letters flutter in the air, as if a breeze has come through the cell. <br>\
		A new batch of letters comes flooding out of the mailbox, one lands right in front of you, with your name on it."
	observation_choices = list(
		"Open the letter" = list(TRUE, "You open the letter, but the inside is blank. <br>\
			Looking at the envelope, you notice that it is labelled \"RETURN TO SENDER\" <br>\
			You put the envelope back in the mailbox, and find a gift inside."),
		"Ignore it" = list(FALSE, "You know better than to fall for the tricks of an abnormality. <br>You walk out of the cell, never knowing what was in that letter."),
	)

	var/cooldown
	var/cooldown_time = 10 SECONDS
	var/spawned_effects = list()
	var/list/bad_mail_types = list(
		/obj/item/mailpaper/junk,
		/obj/item/mailpaper/pipebomb,
		/obj/item/mailpaper/hatred,
		/obj/item/mailpaper/trapped/flashbang,
	)

/mob/living/simple_animal/hostile/abnormality/mailpile/Destroy()
	for(var/obj/effect/VFX in spawned_effects)
		qdel(VFX)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mailpile/Initialize(mapload)
	. = ..()

	for(var/dir in GLOB.alldirs)
		var/turf/dispense_turf = get_step(src, dir)
		var/obj/effect/letters_flow/TMP = new(dispense_turf)
		spawned_effects += TMP

//papercut due to failed work
/mob/living/simple_animal/hostile/abnormality/mailpile/WorktickFailure(mob/living/carbon/human/user)
	if(prob(10))
		to_chat(user, span_warning("Ouch! I got a paper cut!"))
		user.deal_damage(1, RED_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/Delivery(mob/living/carbon/human/user, work_type, pe, work_time)
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)
	to_chat(user, span_notice("One of the letters from the pile slowly waves in the air."))
	var/obj/item/mailpaper/MAIL
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			MAIL = new /obj/item/mailpaper/instinct(get_turf(src),user)
		if(ABNORMALITY_WORK_INSIGHT)
			MAIL = new /obj/item/mailpaper/insight(get_turf(src),user)
		if(ABNORMALITY_WORK_ATTACHMENT)
			MAIL = new /obj/item/mailpaper/attachment(get_turf(src),user)
		if(ABNORMALITY_WORK_REPRESSION)
			var/mailtype = pick(bad_mail_types)
			MAIL = new mailtype(get_turf(src))
	MAIL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/BadDelivery(mob/living/carbon/human/user, work_type, pe, work_time)
	if(cooldown > world.time)
		to_chat(user, span_warning("You realized you have made a grave mistake as envelopes start flying out of the mailbox towards you."))
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

//players get a parcel / letters for completing works
/mob/living/simple_animal/hostile/abnormality/mailpile/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	BadDelivery(user,work_type,pe)

/mob/living/simple_animal/hostile/abnormality/mailpile/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	Delivery(user,work_type,pe)
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	Delivery(user,work_type,pe)
	return

// Pink Midnight
/mob/living/simple_animal/hostile/abnormality/mailpile/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		SendDeathThreat()
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/SendDeathThreat()
	var/chance = 20
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		var/role = H.mind?.assigned_role
		var/weaken = FALSE
		if(isnull(role))
			continue
		if(H.stat == DEAD)
			continue
		if(!prob(chance))
			chance *= 2
			continue
		chance = 20
		if(role in list("Manager", "Extraction Officer", "Records Officer", "Sephirah"))
			weaken = TRUE
		var/threat_type = pickweight(list(
			/obj/item/mailpaper/trapped/fairies = 10,
			/obj/item/mailpaper/trapped/acid = 10,
			/obj/item/mailpaper/trapped/urgent = 6,
			/obj/item/mailpaper/trapped/flashbang = 3,
			/obj/item/mailpaper/coupon = 1,
		))
		switch(threat_type)
			if(/obj/item/mailpaper/trapped/fairies)
				var/obj/item/mailpaper/trapped/fairies/MF = new threat_type(get_turf(H))
				MF.weaken_fairy = weaken
			else
				new threat_type(get_turf(H))

// kinda bad visual effect. Someone PLEASE update this.
/obj/effect/letters_flow
	name = "storm of letters"
	desc = "The storm rages on."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "letters"
	layer = ABOVE_MOB_LAYER

// x2 workspeed buff pro 2022 free hack free robux
/datum/status_effect/workspeed_buff
	id = "workspeed_buff"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/workspeed_buff
	duration = 30 SECONDS

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
	duration = 3 MINUTES

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
		to_chat(user, span_notice("It feels wrong to try to open someone else's package."))
		return
	if(prob(50))
		new /obj/item/ego_weapon/mail_satchel(get_turf(user))
		to_chat(user, span_nicegreen("As you unravel the parcel a satchel falls out."))
	else
		new /obj/item/clothing/suit/armor/ego_gear/zayin/letter_opener(get_turf(user))
		to_chat(user, span_nicegreen("As you unravel the parcel an outfit falls out."))
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
	desc = "A letter with all identifying features scratched off. Sketchy."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "pipebomb_gift"

/obj/item/mailpaper/pipebomb/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_warning("What is this... Is this a pipebomb!?"))
	sleep(10)
	playsound(get_turf(user), 'sound/weapons/flashbang.ogg', 30, TRUE, 8, 0.9)
	for(var/direction in GLOB.alldirs)
		var/turf/dispense_turf = get_step(src, direction)
		new /obj/effect/decal/cleanable/glitter(dispense_turf)
	qdel(src)

/obj/item/mailpaper/junk
	var/JUNKMAIL = list(
		list(
			"Letter from RobustCO",
			"The outside reads \"Improve your robustness today! Read our letter now!\"",
		),
		list(
			"Suspicious message",
			"Ever felt like you need a boost? Get swole today!",
		),
		list(
			"Letter from Shrimpcorp",
			"Is your establishment or workplace completely and utterly lacking in shrimp? Call now for a free chonchsultation!",
		),
		list(
			"Notice from the Head",
			"To: Ayin, As of -/--/----, we have not received your overdue tax after sending several notices to you. You must pay your balance by -/--/---- or we may levy (seize) your property.",
		),
	)

/obj/item/mailpaper/junk/Initialize()
	. = ..()
	var/temp = pick(JUNKMAIL)
	name = temp[1]
	desc = temp[2]

/obj/item/mailpaper/junk/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_notice("This was a waste of time..."))
	user.adjustSanityLoss(5)
	qdel(src)

/obj/item/mailpaper/hatred
	name = "A hastily written angry letter"
	desc = "IHATEYOUIHATEYOUIHATEYOUIHATEYOUIHATEYOU."

/obj/item/mailpaper/hatred/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_warning("The pages are filled with scribbles and threats..."))
	user.adjustSanityLoss(5)
	qdel(src)

/obj/item/mailpaper/instinct

/obj/item/mailpaper/instinct/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "A past letter from a friend addressed to \a [user]. The thought of such conduct makes you feel happy, albeit bittersweet."

/obj/item/mailpaper/instinct/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("Reading the friendly letter helps you find peace in the passing of time."))
	user.adjustSanityLoss(-10)
	qdel(src)

/obj/item/mailpaper/insight

/obj/item/mailpaper/insight/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "letter from coworkers addressed to \a [user]. It feels quite nostalgic."

/obj/item/mailpaper/insight/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("Reading the letter from your coworkers steel your resolve."))
	if(!HAS_TRAIT(user,TRAIT_WORKFEAR_IMMUNE) && !HAS_TRAIT(user,TRAIT_COMBATFEAR_IMMUNE))
		user.apply_status_effect(/datum/status_effect/nofear_buff)
	qdel(src)

/obj/item/mailpaper/attachment

/obj/item/mailpaper/attachment/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "A promotion letter addressed to \a [user]. The new manager of the corp!?!? Oh wait, that's from the future."

/obj/item/mailpaper/attachment/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("Reading the promotion letter fills you with determination to work harder!"))
	var/datum/status_effect/workspeed_buff/TMPEFF = user.has_status_effect(/datum/status_effect/workspeed_buff)
	if (!TMPEFF)
		user.apply_status_effect(/datum/status_effect/workspeed_buff)
	qdel(src)

/obj/item/mailpaper/trapped
	name = "From the Abnormalities"
	desc = "Does something automatically or when opened."
	var/datum/timedevent/effect_timer
	var/effect_min_time = 6 SECONDS
	var/effect_max_time = 12 SECONDS

/obj/item/mailpaper/trapped/Initialize()
	. = ..()
	effect_timer = new(CALLBACK(src, PROC_REF(Trap)), rand(effect_min_time, effect_max_time))
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)

/obj/item/mailpaper/trapped/attack_self(mob/user)
	to_chat(user, span_warning("What the-"))
	Trap()

/obj/item/mailpaper/trapped/proc/Trap()
	set waitfor = FALSE
	if(effect_timer)
		deltimer(effect_timer)
	qdel(src)
	return

/obj/item/mailpaper/trapped/fairies
	desc = "Why does this paper smell faintly of Pixy Stix?"
	var/fairy_count = 4
	var/weaken_fairy = FALSE

/obj/item/mailpaper/trapped/fairies/Trap()
	var/turf/T = get_turf(src)
	T.visible_message(span_warning("[fairy_count > 1 ? "Ravenous fairies" : "A ravenous fairy"] burst from the mail!"))
	for(var/i = 1 to fairy_count)
		var/mob/living/simple_animal/hostile/mini_fairy/MF =  new(T)
		MF.faction += "pink"
		if(weaken_fairy)
			MF.adjustBruteLoss(43)
			break
	return ..()

/obj/item/mailpaper/trapped/acid
	desc = "Why does this paper smell faintly of battery acid?"

/obj/item/mailpaper/trapped/acid/Trap()
	var/turf/T = get_turf(src)
	T.visible_message(span_warning("Acid sprays from the letter!"))
	for(var/i = 1 to 8)
		var/angle = rand(0, 360)
		var/obj/effect/decal/cleanable/wrath_acid/bad/AB = new(get_turf(src))
		MoveAcidAngle(AB, angle)
	return ..()

/obj/item/mailpaper/trapped/acid/proc/MoveAcidAngle(obj/effect/decal/cleanable/wrath_acid/bad/bad_acid, angle)
	set waitfor = FALSE
	var/turf/target_turf = get_turf_in_angle(angle, get_turf(src), pick(1, 2, 4))
	while(step_towards(bad_acid, target_turf, 0))
		stoplag(2)
	return

/obj/item/mailpaper/trapped/urgent
	desc = "The paper has been stamped 'Urgent'."
	effect_min_time = 10 SECONDS
	effect_max_time = 10 SECONDS

/obj/item/mailpaper/trapped/urgent/attack_self(mob/user)
	to_chat(user, span_notice("If don't read this within 10 seconds we are going to kill you."))
	to_chat(user, span_nicegreen("Well, you read it fast enough so that's nice!"))
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjustSanityLoss(-20)
	deltimer(effect_timer)
	qdel(src)
	return

/obj/item/mailpaper/trapped/urgent/Trap()
	audible_message(span_warning("We are going to kill you."))
	for(var/mob/living/carbon/human/H in hearers(7, src))
		H.deal_damage(50, WHITE_DAMAGE)
	return ..()

/obj/item/mailpaper/trapped/flashbang
	desc = "This paper has a large cylindrical lump in the middle of it..."
	effect_min_time = 10 SECONDS
	effect_max_time = 20 SECONDS

/obj/item/mailpaper/trapped/flashbang/Trap()
	var/turf/T = get_turf(src)
	var/obj/item/grenade/flashbang/F = new(T)
	T.visible_message(span_notice("A beeping flashbang drops out of the mail."))
	T.visible_message(span_userdanger("WAIT, WHAT!?"))
	F.det_time = isnull(timeleft(effect_timer)) ? 0 : timeleft(effect_timer)
	F.arm_grenade()
	return ..()

/obj/item/mailpaper/coupon
	name = "From the Abnormalities"
	desc = "'Contains one (1) coupon for a free item!' *Contents may vary, user discretion is advised"
	var/obj/item/coupon_lc13/C

/obj/item/mailpaper/coupon/Initialize()
	. = ..()
	C = new(src)
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)

/obj/item/mailpaper/coupon/attack_self(mob/user)
	user.visible_message(
		span_notice("[user] rips the coupon out of the mail."),\
		span_notice("You rip the coupon out of the mail."),\
		span_notice("You hear the sound of ripping paper.")
		)
	playsound(user, 'sound/items/poster_ripped.ogg', 100)
	C.forceMove(get_turf(user))
	qdel(src)

/obj/item/coupon_lc13
	name = "coupon"
	desc = "Hell yeah, a free item!"
	icon_state = "data_1"
	icon = 'icons/obj/card.dmi'
	var/obj/item/item_type = null
	var/list/potential_items = list()

/obj/item/coupon_lc13/Initialize()
	. = ..()
	if(!isnull(item_type))
		return
	if(potential_items.len <= 0)
		potential_items += subtypesof(/obj/item/food/pizza)
		potential_items -= /obj/item/food/pizza/arnold
		potential_items -= /obj/item/food/pizza/margherita/robo
		potential_items += subtypesof(/obj/item/reagent_containers/food/drinks/soda_cans)
		potential_items += subtypesof(/obj/item/toy)
		potential_items -= /obj/item/toy/talking
		potential_items -= /obj/item/toy/cards/cardhand
		potential_items -= /obj/item/toy/cards/singlecard
		potential_items -= /obj/item/toy/figure
		potential_items -= /obj/item/toy/plush
	item_type = pick(potential_items)

/obj/item/coupon_lc13/examine(mob/user)
	. = ..()
	. += span_notice("Use in hand to have the [initial(item_type?.name)] sent right to you!")

/obj/item/coupon_lc13/attack_self(mob/user)
	var/obj/structure/closet/supplypod/centcompod/pod = new()
	pod.explosionSize = list(0,0,0,0)
	for(var/i = 1 to (istype(item_type, /obj/item/reagent_containers/food/drinks/soda_cans) ? 6 : 1))
		new item_type(pod)
	new /obj/effect/pod_landingzone(get_turf(user), pod)
	to_chat(user, span_notice("Your [initial(item_type?.name)] is on it's way!"))
	qdel(src)
