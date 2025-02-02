
/obj/item/ego_weapon/ranged/branch12
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'

/obj/item/ego_weapon/branch12
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'

/obj/item/ego_weapon/shield/branch12
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'


//Weapons are simple for now.
// --------ZAYIN---------
//Signal
/obj/item/ego_weapon/ranged/branch12/mini/signal
	name = "signal"
	desc = "It continued calling out, expecting no response in return"
	special = "Upon hitting living target, inflict 1 Mental Decay per 20 missing SP. Then the firer recovers a bit of SP. <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "signal"
	inhand_icon_state = "signal"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/branch12/signal
	fire_delay = 7
	spread = 10
	shotsleft = 12
	reloadtime = 1.3 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/projectile/ego_bullet/branch12/signal
	name = "signal"
	damage = 12
	damage_type = WHITE_DAMAGE
	var/healing_on_hit = 4
	var/inflict_per_sanityloss = 20

/obj/projectile/ego_bullet/branch12/signal/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!ishuman(firer) || !isliving(target))
		return
	var/mob/living/carbon/human/user = firer
	var/mob/living/target_hit = target
	var/inflicted_decay = round((user.maxSanity - user.sanityhealth)/inflict_per_sanityloss)
	target_hit.apply_lc_mental_decay(inflicted_decay)
	user.adjustSanityLoss(-healing_on_hit)

//Serenity
/obj/item/ego_weapon/branch12/mini/serenity
	name = "serenity"
	desc = "By praying for its protection, the statue might grant you its gift if you�re worthy."
	special = "Every time you attack with this weapon, you heal SP. You heal more SP per status effect you have. You also inflict Mental Decay equal to the amount of statues effects you have. <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "serenity"
	force = 12
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/heal_per_status = 5

/obj/item/ego_weapon/branch12/mini/serenity/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.adjustSanityLoss((user.status_effects.len)*(-heal_per_status))
	if(isliving(target))
		target.apply_lc_mental_decay(user.status_effects.len)

//Age of Man
/obj/item/ego_weapon/branch12/age
	name = "age of man"
	desc = "A copper sword, freshly forged."
	special = "Using the weapon in hand, you will revive all fallen humans within 5 sqrs. Revived humans will then slowly decay over the course of 1.5 minutes. But, they will gain extra attributes for the duration of the decay. <br>\
	Also, This weapon inflicts 2 Mental Decay on hit. If the target has 15+ Mental Decay, inflict 3 more Mental Decay <br><br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "age_of_man"
	force = 14
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes")
	attack_verb_simple = list("slice", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/attribute_buff = 40
	var/range = 5
	var/inflicted_decay = 2
	var/target_stacks = 15
	var/inflicted_extra_decay = 3

/obj/item/ego_weapon/branch12/age/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		target.apply_lc_mental_decay(inflicted_decay)
	var/datum/status_effect/stacking/lc_mental_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
	if(D)
		if(D.stacks > target_stacks)
			target.apply_lc_mental_decay(inflicted_extra_decay)

/obj/item/ego_weapon/branch12/age/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	var/success = FALSE
	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		if (human == user)
			continue
		if (human.stat == DEAD)
			success = TRUE
			human.revive(full_heal = TRUE, admin_revive = TRUE)
			human.grab_ghost(force = TRUE) // even suicides
			to_chat(human, span_spider("The bells are ringing. It's not your day to die... At least not for now..."))
			human.apply_status_effect(/datum/status_effect/fade_away)
			human.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, attribute_buff)
			human.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, attribute_buff)
			human.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -attribute_buff)
			human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, attribute_buff)
	for(var/mob/living/simple_animal/hostile/ordeal/O in view(range, get_turf(src)))
		success = TRUE
		O.revive(full_heal = TRUE, admin_revive = TRUE)
		O.faction = list("neutral")
		O.apply_status_effect(/datum/status_effect/fade_away)
		O.color = "#fffc66"

	if(success)
		user.visible_message(span_spider("May the dead rise once more, to fight one last time..."))
		playsound(user, 'sound/abnormalities/silence/church.ogg', 50, TRUE, 4)
		qdel(src)
	else
		to_chat(user, "There is none to bring back!")

//Becoming
/obj/item/ego_weapon/branch12/becoming
	name = "becoming"
	desc = "A hammer made with the desire to become better"
	special = "This weapon inflicts 2 Mental Decay on hit. When this weapon hits a target with Mental Detonation, it will cause it to 'Shatter', and the weapon will deal double damage. This weapon can also change forms by being used in hand.<br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "becoming"
	force = 14
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	var/inflicted_decay = 2
	var/damage_multiplier = 2

/obj/item/ego_weapon/branch12/becoming/attack(mob/living/target, mob/living/user)
	var/old_force_multiplier = force_multiplier
	if(isliving(target))
		target.apply_lc_mental_decay(inflicted_decay)
		var/datum/status_effect/mental_detonate/D = target.has_status_effect(/datum/status_effect/mental_detonate)
		if(D)
			force_multiplier = damage_multiplier
			D.shatter()
	. = ..()
	force_multiplier = old_force_multiplier

/obj/item/ego_weapon/branch12/becoming/proc/equip_self(target)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	src.attack_hand(H)

/obj/item/ego_weapon/branch12/becoming/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/held = H.get_active_held_item()
	H.dropItemToGround(held) //Drop weapon
	var/obj/item/ego_weapon/branch12/making/maker = new(get_turf(user))
	playsound(src, 'sound/effects/hokma_meltdown_short.ogg', 30, TRUE, 5)
	addtimer(CALLBACK(maker, PROC_REF(equip_self), user), 1, TIMER_UNIQUE | TIMER_OVERRIDE)
	Destroy(src)

//Making
/obj/item/ego_weapon/branch12/making
	name = "making"
	desc = "A hammer made with the desire to make anything"
	special = "This weapon inflicts Mental Detonation if the target has 15+ Mental Decay. This weapon can also change forms by being used in hand. <br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "making"
	force = 14
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	var/detonation_breakpoint = 15

/obj/item/ego_weapon/branch12/making/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		var/datum/status_effect/stacking/lc_mental_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
		if(D.stacks >= detonation_breakpoint)
			target.apply_status_effect(/datum/status_effect/mental_detonate)

/obj/item/ego_weapon/branch12/making/proc/equip_self(target)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	src.attack_hand(H)

/obj/item/ego_weapon/branch12/making/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/held = H.get_active_held_item()
	H.dropItemToGround(held) //Drop weapon
	var/obj/item/ego_weapon/branch12/becoming/becomer = new(get_turf(user))
	playsound(src, 'sound/effects/hokma_meltdown_short.ogg', 30, TRUE, 5)
	addtimer(CALLBACK(becomer, PROC_REF(equip_self), user), 1, TIMER_UNIQUE | TIMER_OVERRIDE)
	Destroy(src)

//Needing
/obj/item/ego_weapon/branch12/needing
	name = "needing"
	desc = "A hammer made with the desire to need everyone"
	icon_state = "needing"
	force = 14
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

