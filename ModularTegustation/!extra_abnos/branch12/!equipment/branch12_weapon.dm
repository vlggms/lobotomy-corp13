
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

//Serenity
/obj/item/ego_weapon/branch12/mini/serenity
	name = "serenity"
	desc = "By praying for its protection, the statue might grant you its gift if you’re worthy."
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
	icon_state = "depature"
	force = 22
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'

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
	desc = "I couldn’t bear it, they silently judged, accusing every step I took."
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

/obj/item/ego_weapon/honor/get_clamped_volume()
	return 25

//Fluttering Passion
/obj/item/ego_weapon/branch12/passion
	name = "fluttering passion"
	desc = "When a red butterfly appears at a funeral, it’s believed that the butterfly is the passion they once had."
	icon_state = "passion"
	force = 75
	stuntime = 5	//Stronger, so has quite the stun
	attack_speed = 1.5	//and is a bit slower
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("chops")
	attack_verb_simple = list("chop")
	hitsound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

//Average Joe
/obj/item/ego_weapon/branch12/joe
	name = "average joe"
	desc = "A good briefcase is your best friend. It can carry a lot of important documents, your pencils, and your lunch! It can even be a good self-defense tool!"
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

//Medea
/obj/item/ego_weapon/ranged/branch12/mini/medea
	name = "medea"
	desc = "Mortal fate is hard. You'd best get used to it."
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


/obj/projectile/ego_bullet/branch12/medea
	name = "medea"
	damage = 70
	damage_type = PALE_DAMAGE


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



