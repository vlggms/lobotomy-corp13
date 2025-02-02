
// --------TETH---------
//Departure
/obj/item/ego_weapon/branch12/departure
	name = "Departure"
	desc = "Each man's death diminishes me, For I am involved in mankind"
	special = "Upon hitting living target, Inflict 4 Bleed to the target and gain 1 Bleed."
	icon_state = "departure"
	force = 8
	attack_speed = 0.5
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'
	var/inflicted_bleed = 4
	var/gained_bleed = 1

/obj/item/ego_weapon/branch12/departure/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target))
		target.apply_lc_bleed(inflicted_bleed)
	if(isliving(user))
		user.apply_lc_bleed(gained_bleed)

//Acupuncture
/obj/item/ego_weapon/branch12/mini/acupuncture
	name = "Acupuncture"
	desc = "One man's medicine is another man's poison."
	special = "You are able to inject yourself with this weapon. If you inject yourself with the weapon, you will take toxic damage, but gain a 30% damage buff and inflict 3 Mental Decay on hit for 5 seconds. <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "acupuncture"
	force = 20
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("jabs", "stabs")
	attack_verb_simple = list("jab", "stab")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	var/inject_cooldown
	var/inject_cooldown_time = 5.1 SECONDS
	var/justice_buff = 30
	var/normal_mental_decay_inflict = 3
	var/mental_decay_inflict = 0

/obj/item/ego_weapon/branch12/mini/acupuncture/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target))
		target.apply_lc_mental_decay(mental_decay_inflict)

/obj/item/ego_weapon/branch12/mini/acupuncture/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/drugie = user
	if(inject_cooldown < world.time)
		inject_cooldown = world.time + inject_cooldown_time
		drugie.set_drugginess(15)
		drugie.adjustToxLoss(7)
		to_chat(drugie, span_nicegreen("Wow... I can taste the colors..."))
		mental_decay_inflict = normal_mental_decay_inflict
		if(prob(20))
			drugie.emote(pick("twitch","drool","moan","giggle"))
		drugie.adjust_attribute_buff(JUSTICE_ATTRIBUTE, justice_buff)
		addtimer(CALLBACK(src, PROC_REF(RemoveBuff), drugie), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else
		to_chat(drugie, span_boldwarning("[src] has not refueled yet."))

/obj/item/ego_weapon/branch12/mini/acupuncture/proc/RemoveBuff(mob/user)
	var/mob/living/carbon/human/human = user
	mental_decay_inflict = 0
	human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -justice_buff)

//One Starry Night
/obj/item/ego_weapon/ranged/branch12/starry_night
	name = "One Starry Night"
	desc = "A gun that's made to take out pests."
	special = "This weapon deal 1% more damage to abnormalities, per 1% of their understanding. If they have max understanding, this weapon also reduces the target's white resistance by 20% for 5 seconds.<br>\
	You also inflict 1 Mental Decay per 50% understanding the target has. <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "starry_night"
	inhand_icon_state = "starry_night"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/branch12/starry_night
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	spread = 10
	shotsleft = 25
	reloadtime = 2.5 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/projectile/ego_bullet/branch12/starry_night
	name = "starry night"
	icon_state = "whitelaser"
	damage = 22
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/branch12/starry_night/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!istype(target, /mob/living/simple_animal/hostile/abnormality))
		return
	var/mob/living/simple_animal/hostile/abnormality/A = target
	var/extra_damage = 0
	if(A.datum_reference)
		extra_damage = (A.datum_reference.understanding / A.datum_reference.max_understanding)
		A.deal_damage(damage*extra_damage, "white")
		A.apply_lc_mental_decay(round(extra_damage*2))
		if(A.datum_reference.understanding == A.datum_reference.max_understanding)
			if(!A.has_status_effect(/datum/status_effect/rend_white))
				new /obj/effect/temp_visual/cult/sparks(get_turf(A))
				A.apply_status_effect(/datum/status_effect/rend_white)


//Slot Machine
/obj/item/ego_weapon/branch12/mini/slot_machine
	name = "Slot Machine"
	desc = "Big money!"
	special = "Upon throwing, this weapon returns to the user. Also, When hitting a foe by throwing this weapon you will inflict Mental Detonation if the target has 15+ Mental Decay. Then you inflict 3 Mental Decay. <br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "coin"
	force = 10
	damtype = RED_DAMAGE
	throwforce = 45
	throw_speed = 1
	throw_range = 7
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	var/detonation_breakpoint = 15
	var/mental_decay_inflict = 3

/obj/item/ego_weapon/branch12/mini/slot_machine/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		mental_inflict(hit_atom, thrownby)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/branch12/mini/slot_machine/proc/mental_inflict(hit_target, thrower)
	if(!ismob(hit_target) && !iscarbon(thrower))
		return
	var/mob/living/T = hit_target
	var/datum/status_effect/stacking/lc_mental_decay/D = T.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
	if(D.stacks >= detonation_breakpoint)
		T.apply_status_effect(/datum/status_effect/mental_detonate)
	T.apply_lc_mental_decay(mental_decay_inflict)

//White Lotus
/obj/item/ego_weapon/branch12/mini/white_lotus
	name = "white lotus"
	desc = "Has a beautiful smell to it."
	icon_state = "white_lotus"
	force = 20
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")

//Black Lotus
/obj/item/ego_weapon/shield/branch12/mini/black_lotus
	name = "black lotus"
	desc = "Has a beautiful smell to it."
	icon_state = "black_lotus"
	special = "Upon throwing, this weapon returns to the user."
	force = 22
	attack_speed = 3
	throwforce = 22
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	reductions = list(20, 20, 50, 20)
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/parry.ogg'
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You reset your buckler."


/obj/item/ego_weapon/shield/branch12/mini/black_lotus/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

//Lovine Memory
/obj/item/ego_weapon/branch12/mini/loving_memory
	name = "loving memory"
	desc = "In Memory of that which you lost."
	icon_state = "nostalgia"
	force = 14
	throwforce = 33
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
