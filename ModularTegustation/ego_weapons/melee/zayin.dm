//ZAYIN E.G.O. Support abilities - use this subtype to reduce some copy-paste
/obj/item/ego_weapon/support
	special = "Use this weapon in your hand when wearing matching armor to activate a special ability."
	var/ability_cooldown
	var/ability_cooldown_time = 10 SECONDS
	var/pulse_delay = 1 SECONDS
	var/pulse_enabled = FALSE
	var/pulse_enable_toggle = FALSE
	var/matching_armor
	var/use_message
	var/use_sound

/obj/item/ego_weapon/support/attack_self(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(ability_cooldown > world.time)
		to_chat(H, span_warning("You have used this ability too recently!"))
		return FALSE
	var/obj/item/clothing/suit/armor/ego_gear/zayin/P = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(P, matching_armor))
		pulse_enabled = TRUE
		ability_cooldown = world.time + ability_cooldown_time
		to_chat(H, span_nicegreen("[use_message]"))
		H.playsound_local(get_turf(H), use_sound, 25, 0)
		Pulse(user, 0)
		return TRUE
	else
		if(pulse_enable_toggle)
			pulse_enabled = FALSE
		to_chat(H, span_warning("You must have the corrosponding armor equipped to use this ability!"))
		return FALSE

/obj/item/ego_weapon/support/dropped(mob/user)
	. = ..()
	if(pulse_enable_toggle)
		pulse_enabled = FALSE

/obj/item/ego_weapon/support/Destroy(mob/user)
	. = ..()
	if(pulse_enable_toggle)
		pulse_enabled = FALSE

/obj/item/ego_weapon/support/proc/Pulse(mob/living/carbon/human/user, count)
	if(!pulse_enabled && pulse_enable_toggle)
		return
	if(count >= 10)
		return
	addtimer(CALLBACK(src, PROC_REF(Pulse), user, count += 1), pulse_delay)

/obj/item/ego_weapon/support/penitence
	name = "penitence"
	desc = "A mace meant to purify the evil thoughts."
	special = "Use this weapon in your hand when wearing matching armor to heal the SP of others nearby."
	icon_state = "penitence"
	force = 14
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/penitence
	pulse_enable_toggle = TRUE
	use_message = "You use penitence to emit sanity healing pulses!"
	use_sound = "sound/abnormalities/onesin/bless.ogg"
	var/pulse_healing = -0.5

/obj/item/ego_weapon/support/penitence/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustSanityLoss(pulse_healing)
		to_chat(L, span_nicegreen("A pulse from [user] makes your mind feel a bit clearer."))

/obj/item/ego_weapon/support/little_alice
	name = "little alice"
	desc = "You, now in wonderland!"
	special = "Use this weapon in your hand when wearing matching armor to create food for people nearby."
	icon_state = "little_alice"
	force = 14
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slices", "slashes", "stabs")
	hitsound = 'sound/weapons/bladeslice.ogg'
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/little_alice
	use_message = "You use little alice to share snacks!"
	use_sound = "sound/items/eatfood.ogg"
	ability_cooldown_time = 60 SECONDS

/obj/item/ego_weapon/support/little_alice/Pulse(mob/living/carbon/human/user)
	var/list/foodoptions = list(/obj/item/food/cookie, /obj/item/food/cookie/sugar/pbird)
	for(var/mob/living/carbon/human/L in livinginview(5, user))
		if((!ishuman(L)) || L.stat == DEAD || L == user)
			continue
		if(L.nutrition > NUTRITION_LEVEL_WELL_FED)
			continue
		to_chat(L, span_warning("[user] gives you a snack!"))
		var/gift = pick(foodoptions)
		new gift(get_turf(L))

/obj/item/ego_weapon/support/wingbeat
	name = "wingbeat"
	desc = "If an agent can show that they are competent, then they may be able to draw Fairy Festival’s attention.."
	icon_state = "wingbeat"
	special = "Use this weapon in your hand when wearing matching armor to heal the HP of others nearby."
	force = 14
	damtype = RED_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/wingbeat
	pulse_enable_toggle = TRUE
	use_message = "You use wingbeat to emit healing pulses!"
	use_sound = "sound/abnormalities/fairyfestival/fairylaugh.ogg"
	var/pulse_healing = -0.5

/obj/item/ego_weapon/support/wingbeat/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustBruteLoss(pulse_healing)
		to_chat(L, span_nicegreen("Fairies come from [user] to heal your wounds."))

/obj/item/ego_weapon/support/wingbeat/suicide_act(mob/living/carbon/user)
	. = ..()
	user.visible_message(span_suicide("[user] yells to the fairies around [user.p_them()] that [user.p_they()] won't spend time with the fairies anymore! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(user, 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg', 50, TRUE, -1)
	user.unequip_everything()
	user.dust()
	return MANUAL_SUICIDE

/obj/item/ego_weapon/change
	name = "change"
	desc = "A hammer made with the desire to change anything"
	special = "Attack a friendly human while wearing matching armor to heal their HP slightly."
	icon_state = "change"
	force = 14
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

/obj/item/ego_weapon/change/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || M == user || !user.faction_check_mob(M) || (user.a_intent != INTENT_HELP))
		..()
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/change/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(C))
		..()
		return
	var/mob/living/carbon/human/HT = M
	if(HT.is_working)
		to_chat(user,span_notice("You cannot defend others from responsibility!"))
		return
	playsound(get_turf(user), 'sound/abnormalities/change/change_end.ogg', 25, 0, -9)
	HT.visible_message(span_nicegreen("[HT] is patched up with [src] by [user]!"))
	HT.adjustBruteLoss(-10)
	user.changeNext_move(CLICK_CD_MELEE * 3)

/obj/item/ego_weapon/support/doze
	name = "dozing"
	desc = "Knock the daylights out of 'em!"
	special = "Use this weapon in your hand when wearing matching armor to heal the HP and SP of others nearby. Using this ability will briefly put you to sleep."
	icon_state = "doze"
	force = 14
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	hitsound = 'sound/abnormalities/happyteddy/teddy_guard.ogg'
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/doze
	use_message = "You use the doze to emit healing pulses! It knocks you right out!"
	use_sound = "sound/abnormalities/happyteddy/teddy_lullaby.ogg"
	var/pulse_healing = -2

/obj/item/ego_weapon/support/doze/attack_self(mob/user) //using it puts you to sleep
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	H.Stun(10 SECONDS)
	H.Knockdown(1)

/obj/item/ego_weapon/support/doze/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustSanityLoss(pulse_healing)
		L.adjustBruteLoss(pulse_healing)
		to_chat(L, span_nicegreen("You feel warmth coming from [user]!"))

/obj/item/ego_weapon/support/evening
	name = "evening twilight"
	desc = "I accepted the offer and paid the price."
	special = "Use this weapon in your hand when wearing matching armor to generate weak pale shields for others nearby."
	icon_state = "evening"
	force = 12
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/evening
	use_message = "You use evening to generate pale shields!"
	use_sound = "sound/abnormalities/lighthammer/chain.ogg"

/obj/item/ego_weapon/support/evening/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.apply_status_effect(/datum/status_effect/evening)

/datum/status_effect/evening
	id = "evening twilight"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3 SECONDS
	alert_type = null

/datum/status_effect/evening/on_apply()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_nicegreen("A shield increases your resistance to pale damage!"))
	H.physiology.pale_mod /= 1.1
	return ..()

/datum/status_effect/evening/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_warning("Your shield has warn off."))
	H.physiology.pale_mod *= 1.1
	return ..()


/obj/item/ego_weapon/cavernous_wailing
	name = "cavernous wailing"
	desc = "Cry with me..."
	special = "Attack a friendly human while wearing matching armor to heal their HP and SP by a small amount."
	icon_state = "cavernous_wailing"
	force = 14
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	hitsound = 'sound/abnormalities/blubbering_toad/attack.ogg'

/obj/item/ego_weapon/cavernous_wailing/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || M == user || !user.faction_check_mob(M) || (user.a_intent != INTENT_HELP))
		..()
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/cavernous_wailing/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(C))
		..()
		return
	var/mob/living/carbon/human/HT = M
	if(HT.is_working)
		to_chat(user,span_notice("You cannot defend others from responsibility!"))
		return
	playsound(get_turf(user), 'sound/abnormalities/blubbering_toad/blurble3.ogg', 25, 0, -9) //change to blubber sfx when toad is merged
	HT.visible_message(span_nicegreen("[HT] is healed by the resin on [src] by [user]!"))
	HT.adjustSanityLoss(-5)
	HT.adjustBruteLoss(-5)
	user.changeNext_move(CLICK_CD_MELEE * 3)

/obj/item/ego_weapon/support/letter_opener
	name = "letter opener"
	desc = "Trusty aid of a mailman."
	special = "Use this weapon in your hand when wearing matching armor to send a secret letter to a person of your choice."
	icon_state = "letteropener"
	force = 14
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slices", "slashes", "stabs")
	hitsound = 'sound/weapons/bladeslice.ogg'
	ability_cooldown_time = 30 SECONDS
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/letter_opener
	use_message = "You use letter opener to send a message!"
	use_sound = 'sound/items/handling/paper_drop.ogg'

/obj/item/ego_weapon/support/letter_opener/Pulse(mob/user)
	var/M = input(user,"Who would you like to message?","Select Someone") as null|anything in GetPlayers(user)
	if(!M)
		return
	var/msg = stripped_input(usr, "What do you wish to tell [M]?", null, "")
	if(!msg)
		return
	to_chat(M, span_warning("[user] has sent you a message!"))
	var/obj/item/paper/P = new(get_turf(M))
	P.setText(msg)
	P.icon_state = "mail"
	var/mob/living/carbon/human/H = M
	var/datum/attribute/highest_attribute = null
	for(var/datum/attribute/A in H.attributes)
		if(isnull(highest_attribute))
			highest_attribute = A
			continue
		if(A.get_level() > highest_attribute.get_level())
			highest_attribute = A
	switch(highest_attribute)
		if(/datum/attribute/fortitude)
			new /obj/item/mailpaper/instinct(get_turf(H), H)
		if(/datum/attribute/prudence)
			new /obj/item/mailpaper/insight(get_turf(H), H)
		if(/datum/attribute/temperance)
			new /obj/item/mailpaper/coupon(get_turf(H))
		if(/datum/attribute/justice) // "These two seem to be backwards?" Yes. Justice is the one stat that does basically nothing for grinding, this buffs those who want to be able to do damage AND work.
			new /obj/item/mailpaper/attachment(get_turf(H), H)
	QDEL_IN(P, 30 SECONDS)
	to_chat(user, span_boldnotice("You transmit to [M]:</span> <span class='notice'>[msg]"))
	for(var/ded in GLOB.dead_mob_list)
		if(!isobserver(ded))
			continue
		var/follow_rev = FOLLOW_LINK(ded, user)
		var/follow_whispee = FOLLOW_LINK(ded, M)
		to_chat(ded, "[follow_rev] <span class='boldnotice'>[user] [name]:</span> <span class='notice'>\"[msg]\" to</span> [follow_whispee] <span class='name'>[M]</span>")

/obj/item/ego_weapon/support/letter_opener/proc/GetPlayers(mob/living/carbon/human/user)
	. = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(user == H)
			continue
		if(!isliving(H))
			continue
		. += H
	sortList(.)
	return

/obj/item/ego_weapon/eclipse
	name = "eclipse of scarlet moths"
	desc = "It's beautiful."
	icon_state = "eclipse"
	force = 14
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/plastic
	name = "plastic smile"
	desc = "A mysterious worn-out tool used for operations."
	special = "Attack a friendly human while wearing matching armor to buff their JUSTICE by the amount of damage you would have dealt."
	icon_state = "plastic"
	force = 14
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")
	hitsound = 'sound/abnormalities/kqe/hitsound1.ogg'

/obj/item/ego_weapon/plastic/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || M == user || !user.faction_check_mob(M) || user.a_intent != INTENT_HELP)
		..()
		return
	var/obj/item/clothing/suit/armor/ego_gear/tools/plastic/P = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(P))
		..()
		return
	var/mob/living/carbon/human/HT = M
	if(HT.has_status_effect(/datum/status_effect/you_happy_buff))
		if(user.a_intent == INTENT_HELP)
			return
		..()
		return
	var/justice_mod = 1 + (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
	HT.apply_status_effect(/datum/status_effect/you_happy_buff)
	var/datum/status_effect/you_happy_buff/Y = HT.has_status_effect(/datum/status_effect/you_happy_buff)
	Y.EnableBuff((force * justice_mod) * force_multiplier)
	playsound(get_turf(user), 'sound/effects/light_flicker.ogg', 25, TRUE, -9)
	HT.visible_message(span_nicegreen("[HT] had their justice buffed with [src] by [user]!"))
	user.changeNext_move(CLICK_CD_MELEE * 5)

/datum/status_effect/you_happy_buff
	id = "you must be happy ego buff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 6 SECONDS
	alert_type = null
	var/buff_amount = 0

/datum/status_effect/you_happy_buff/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -buff_amount)
	return ..()

/datum/status_effect/you_happy_buff/proc/EnableBuff(amount)
	if(!ishuman(owner))
		return
	if(!amount)
		return
	buff_amount = amount
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, amount)

/*
* Ironically this shield reveals to you all the dangerous
* things around you.
*/
/obj/item/ego_weapon/shield/dead_dream
	name = "dead dream"
	desc = "The last thing Maria saw before entering the dream. She felt... safe."
	special = "Upon deflecting a attack, glimpse the location of all nearby mobs for 1 seconds."
	icon_state = "dead_dream"
	damtype = WHITE_DAMAGE
	var/glimpse_cooldown = 0
	var/glimpse_cooldown_delay = 3 SECONDS

/obj/item/ego_weapon/shield/dead_dream/attack_self(mob/user)
	. = ..()
	if(glimpse_cooldown < world.time)
		Glimpse()

//Experimental Feature, Most likely too costly for its own good.
/obj/item/ego_weapon/shield/dead_dream/proc/Glimpse()
	for(var/mob/living/carbon/human/H in view(6, get_turf(src)))
		H.apply_status_effect(/datum/status_effect/display/glimpse_thermal)
		to_chat(H, span_info("You glimpse into her dream."))
	glimpse_cooldown = world.time + glimpse_cooldown_delay

/obj/item/ego_weapon/prohibited
	name = "PROHIBITED!!!"
	desc = "You've pressed it numerous times and you still have something you want to know about it?"
	special = "Attack an enemy while wearing matching armor to make them lose interest in you. Might also just make them angry."
	icon_state = "touch"
	force = 14
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("sprays", "hoses", "mists", "drizzles")
	attack_verb_simple = list("spray", "hose", "mist", "drizzle")
	hitsound = 'sound/effects/spray3.ogg'

/obj/item/ego_weapon/prohibited/attack(mob/living/M, mob/living/user)
	. = ..()
	if(prob(75)) //75% chance of just not working at all - this ability has the potential to be OP
		return
	if(user.faction_check_mob(M) || (!istype(M, /mob/living/simple_animal/hostile)))
		return
	var/obj/item/clothing/suit/armor/ego_gear/tools/prohibited/P = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(P))
		return
	var/mob/living/simple_animal/hostile/T = M
	if(T.target == user)
		T.LoseTarget()
		T.visible_message(span_nicegreen("[T] lost interest in [user]!"))

/obj/item/ego_weapon/promise
	name = "belief and promise"
	desc = "If you make an attempt with an austere heart devoid of desire or expectation, you may receive an unexpected reward."
	icon_state = "promise"
	force = 14
	throwforce = 25
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/promise/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/mirror
	name = "mirror"
	desc = "Those who face themselves in the mirror may appear the same, but in actuality, they have become completely different people."
	icon_state = "mirror"
	force = 14
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/wcorp4.ogg'
