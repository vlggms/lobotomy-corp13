
/obj/item/ego_weapon/ranged/branch12
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'

/obj/item/ego_weapon/branch12
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'

//Weapons are simple for now.
// --------ZAYIN---------
//Signal
/obj/item/ego_weapon/ranged/branch12/mini/signal
	name = "signal"
	desc = "It continued calling out, expecting no response in return"
	special = "Upon hitting living target, the firer recovers a bit of SP."
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

/obj/projectile/ego_bullet/branch12/signal/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!ishuman(firer) || !isliving(target))
		return
	var/mob/living/carbon/human/user = firer
	user.adjustSanityLoss(-healing_on_hit)

//Serenity
/obj/item/ego_weapon/branch12/mini/serenity
	name = "serenity"
	desc = "By praying for its protection, the statue might grant you its gift if you�re worthy."
	icon_state = "serenity"
	force = 12
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'

//Age of Man
/obj/item/ego_weapon/branch12/age
	name = "age of man"
	desc = "A copper sword, freshly forged."
	icon_state = "age_of_man"
	force = 14
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes")
	attack_verb_simple = list("slice", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'

//Becoming
/obj/item/ego_weapon/branch12/becoming
	name = "becoming"
	desc = "A hammer made with the desire to become better"
	icon_state = "becoming"
	force = 14
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

//Making
/obj/item/ego_weapon/branch12/making
	name = "making"
	desc = "A hammer made with the desire to make anything"
	icon_state = "becoming"
	force = 14
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

//Exterminator
/obj/item/ego_weapon/ranged/branch12/mini/exterminator
	name = "exterminator"
	desc = "A gun that's made to take out pests."
	icon_state = "exterminator"
	inhand_icon_state = "exterminator"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/branch12/exterminator
	fire_delay = 7
	spread = 10
	shotsleft = 10
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/projectile/ego_bullet/branch12/exterminator
	name = "exterminator"
	damage = 12
	damage_type = BLACK_DAMAGE


// --------TETH---------
//Departure
/obj/item/ego_weapon/branch12/departure
	name = "Departure"
	desc = "Each man's death diminishes me, For I am involved in mankind"
	special = "Upon hitting living target, Inflict bleed to the target and gain some bleed to self."
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
	icon_state = "acupuncture"
	force = 20
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("jabs", "stabs")
	attack_verb_simple = list("jab", "stab")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'

//One Starry Night
/obj/item/ego_weapon/ranged/branch12/starry_night
	name = "One Starry Night"
	desc = "A gun that's made to take out pests."
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

//Slot Machine
/obj/item/ego_weapon/branch12/mini/slot_machine
	name = "Slot Machine"
	desc = "Big money!"
	special = "Upon throwing, this weapon returns to the user."
	icon_state = "coin"
	force = 10
	damtype = RED_DAMAGE
	throwforce = 45
	throw_speed = 1
	throw_range = 7
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

/obj/item/ego_weapon/branch12/mini/slot_machine/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()


// --------HE---------
//Perfectionist
/obj/item/ego_weapon/branch12/perfectionist
	name = "perfectionist"
	desc = "I couldn�t bear it, they silently judged, accusing every step I took."
	special = "Upon hitting living target, You have a chance to critically hit the target dealing quadruple damage. However, if you don't hit you take some damage."
	icon_state = "perfectionist"
	force = 30
	reach = 3
	stuntime = 8
	attack_speed = 0.7
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("whips", "lashes", "tears")
	attack_verb_simple = list("whip", "lash", "tear")
	hitsound = 'sound/weapons/whip.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/crit_chance = 10
	var/default_crit_chance = 10
	var/crit_chance_raise = 10

/obj/item/ego_weapon/branch12/perfectionist/attack(mob/living/target, mob/living/user)
	..()
	if(prob(crit_chance))
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust / 100
		var/extra_damage = force
		extra_damage *= justicemod
		target.deal_damage(extra_damage*3, damtype)
		playsound(target, 'sound/abnormalities/spiral_contempt/spiral_hit.ogg', 25, TRUE, 4)
		to_chat(user, span_nicegreen("FOR THEIR PERFORMANCE, I SHALL ACT!"))
		crit_chance = default_crit_chance
	else
		crit_chance += crit_chance_raise
		user.deal_damage(force*0.25, damtype)
		to_chat(user, span_boldwarning("They are watching... Judging..."))

// --------WAW---------
//Plagiarism
/obj/item/ego_weapon/branch12/plagiarism
	name = "plagiarism"
	desc = "This is my, my work!."
	special = "Applies a random damage number"
	icon_state = "plagiarism"
	force = 60
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/branch12/plagiarism/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	damtype = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	..()

//Degrading Honor
/obj/item/ego_weapon/branch12/honor
	name = "degrading honor"
	desc = "The whole art of life consists in belonging to oneself."
	special = "With a 1 minute cooldown, Using it in hand you are able to inspire your fellow workers by giving them a 40% damage buff for 5 seconds at the cost of some of your SP."
	icon_state = "honor"
	force = 60
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/warcry_cooldown
	var/warcry_cooldown_time = 60 SECONDS
	var/list/affected = list()
	var/range = 5
	var/affect_self = TRUE
	var/justice_buff = 40
	var/sp_cost = 20

//sound\magic\clockwork\invoke_general.ogg
/obj/item/ego_weapon/branch12/honor/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(warcry_cooldown > world.time)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/commander = user
	commander.adjustSanityLoss(sp_cost)
	warcry_cooldown = world.time + warcry_cooldown_time
	commander.say("SLAY THEM, FOR THE QUEEN!", list("colossus","yell"), sanitize = FALSE)
	playsound(commander, 'sound/magic/clockwork/invoke_general.ogg', 50, TRUE, 4)
	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		if (human == commander && !affect_self)
			continue
		human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, justice_buff)
		affected+=human

	addtimer(CALLBACK(src, PROC_REF(Warcry), commander), 0.5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	addtimer(CALLBACK(src, PROC_REF(RemoveBuff), commander), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)


/obj/item/ego_weapon/branch12/honor/proc/Warcry(mob/user)
	for(var/mob/living/carbon/human/human in affected)
		if(human == user)
			continue
		human.say("FOR THE QUEEN!")

/obj/item/ego_weapon/branch12/honor/proc/RemoveBuff(mob/user)
	for(var/mob/living/carbon/human/human in affected)
		if (human == user && !affect_self)
			continue
		human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -justice_buff)
		affected-=human

/obj/item/ego_weapon/honor/get_clamped_volume()
	return 25

//Fluttering Passion
/obj/item/ego_weapon/branch12/passion
	name = "fluttering passion"
	desc = "When a red butterfly appears at a funeral, it�s believed that the butterfly is the passion they once had."
	special = "On hit, if you have less then 50% HP, heal SP and HP. If the target has less then 50% HP, increase your attack speed against that target."
	icon_state = "passion"
	force = 60
	stuntime = 5	//Stronger, so has quite the stun
	attack_speed = 1.5	//and is a bit slower
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("chops")
	attack_verb_simple = list("chop")
	hitsound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/healing_on_hit = 5
	var/inflicted_bleed = 1

/obj/item/ego_weapon/branch12/passion/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return FALSE
	if(isliving(target))
		target.apply_lc_bleed(inflicted_bleed)
		if(target.health < target.maxHealth * 0.5)
			attack_speed = 0.75
			stuntime = 0
			to_chat(user, span_nicegreen("May their death, bring forth passion..."))
		else
			stuntime = 5
			attack_speed = 1.5
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.health < H.maxHealth * 0.5)
			H.adjustSanityLoss(-healing_on_hit)
			H.adjustBruteLoss(-healing_on_hit)
			to_chat(H, span_nicegreen("Within this passion of death, we find love..."))

//Average Joe
/obj/item/ego_weapon/branch12/joe
	name = "average joe"
	desc = "A good briefcase is your best friend. It can carry a lot of important documents, your pencils, and your lunch! It can even be a good self-defense tool!"
	special = "You are able to turn on abnormality deterrence, which lets you make the foes you attack ignore you, at the cost of your SP."
	icon_state = "joe"
	force = 72
	attack_speed = 2
	damtype = WHITE_DAMAGE
	knockback = KNOCKBACK_LIGHT
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/active = FALSE
	var/range = 4
	var/list/other_targets = list()
	var/sp_cost = 10

/obj/item/ego_weapon/branch12/joe/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(active)
		active = FALSE
		to_chat(user,span_warning("You turn off your abnormality deterrence..."))
		return
	if(!active)
		active = TRUE
		to_chat(user,span_warning("You turn on your abnormality deterrence..."))
		return

/obj/item/ego_weapon/branch12/joe/attack(mob/living/target, mob/living/user)
	..()
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust / 100
	var/extra_damage = force * justicemod
	target.deal_damage(-extra_damage, AGGRO_DAMAGE)
	if(active)
		if(ishuman(user))
			var/mob/living/carbon/human/joe = user
			for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
				if(human == user)
					continue
				else if(human.stat == DEAD)
					continue
				else
					other_targets += human
			if(ishostile(target))
				var/mob/living/simple_animal/hostile/getawayplease = target
				if(other_targets && getawayplease.target == user)
					shuffle_inplace(other_targets)
					var/killthem = other_targets[1]
					getawayplease.GiveTarget(killthem)
					to_chat(user, span_nicegreen("Ignore me, am just a normal joe..."))
					joe.adjustSanityLoss(sp_cost)
	other_targets = list()

//Medea
/obj/item/ego_weapon/ranged/branch12/mini/medea
	name = "medea"
	desc = "Mortal fate is hard. You'd best get used to it."
	special = "You are able to activate 'Dead Eye' mode while wielding this weapon. While 'Dead Eye' is active, your shots take 2.5 extra seconds to fire, but they become piercing and deal more damage."
	icon_state = "medea"
	inhand_icon_state = "medea"
	force = 14
	damtype = PALE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/branch12/medea
	fire_delay = 10
	shotsleft = 5
	reloadtime = 2.1 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/lock_on = TRUE
	var/lock_on_time = 2.5 SECONDS
	var/aiming = FALSE

/obj/item/ego_weapon/ranged/branch12/mini/medea/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(lock_on)
		lock_on = FALSE
		to_chat(user,span_warning("You turn off your dead eye aimming..."))
	else
		lock_on = TRUE
		to_chat(user,span_warning("You turn on your dead eye aimming..."))
	. = ..()

/obj/item/ego_weapon/ranged/branch12/mini/medea/afterattack(atom/target, mob/living/user, flag, params)
	if (aiming)
		to_chat(user, span_warning("You are already aiming at someone!"))
		return
	. = ..()

/obj/item/ego_weapon/ranged/branch12/mini/medea/process_fire(atom/target, mob/living/user, message = TRUE)
	if(!CanUseEgo(user))
		return
	if(lock_on)
		to_chat(user, span_warning("You start aiming for [target]..."))
		playsound(user, 'sound/abnormalities/freischutz/prepare.ogg', 35, 0, 20)
		aiming = TRUE
		if(do_after(user, lock_on_time, src))
			projectile_path = /obj/projectile/ego_bullet/branch12/medea/big
			fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'
			. = ..()
			fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
			projectile_path = /obj/projectile/ego_bullet/branch12/medea
		aiming = FALSE
	else
		aiming = FALSE
		. = ..()

/obj/projectile/ego_bullet/branch12/medea
	name = "medea"
	damage = 70
	damage_type = PALE_DAMAGE

/obj/projectile/ego_bullet/branch12/medea/big
	icon_state = "magic_bullet"
	damage = 90
	speed = 0.1
	projectile_piercing = PASSMOB
	range = 18 // Don't want people shooting it through the entire facility
	hit_nondense_targets = TRUE

//Icon of Chaos
/obj/item/ego_weapon/ranged/branch12/icon_of_chaos
	name = "Icon of Chaos"
	desc = "Endless chaos comes from this wand."
	special = "The beams from this wand perform various effects."
	icon_state = "chaos"
	inhand_icon_state = "chaos"
	force = 20
	damtype = PALE_DAMAGE
	fire_delay = 10
	projectile_path = /obj/projectile/ego_bullet/enchanted_wand
	fire_sound = 'sound/magic/wandodeath.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)


// --------ALEPH---------
//Pulsating Insanity
/obj/item/ego_weapon/branch12/mini/insanity
	name = "pulsating insanity"
	desc = "I could scarcely contain my feelings of triumph"
	icon_state = "insanity"
	force = 52
	swingstyle = WEAPONSWING_LARGESWEEP
	throwforce = 100
	throw_speed = 5
	throw_range = 7
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("jabs")
	attack_verb_simple = list("jabs")
	hitsound = 'sound/weapons/slashmiss.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

//Purity
/obj/item/ego_weapon/branch12/purity
	name = "purity"
	desc = "To be pure is to be different than Innocent, for innocence requires ignorance while the pure takes in the experiences \
	they go through grows while never losing that spark of light inside. To hold the weight of the world requires someone Pure, \
	and the same can be said for this EGO which is weighed down by a heavy past that might as well be the weight of the world."
	icon_state = "purity"
	force = 120
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	attack_speed = 1.2
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

//Sands of Time
/obj/item/ego_weapon/branch12/time_sands
	name = "sands of time"
	desc = "And so it was lost."
	icon_state = "pharoh"
	force = 80
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)



