//Ting-Tang, weapons are quite gimmicky, and leaves up to chance. Thus does a bit more damage than their tier allows.
//All weapons, but leader are grade 7, they are all quite the jobber anyways.
/obj/item/ego_weapon/city/ting_tang
	name = "ting tang shank"
	desc = "A twisted piece of metal. The shape makes very open wounds."
	special = "This deals a random damage amount between 50% and 100% of max damage. Untreated sanity damage will lower the minimum down to 10% depending on severity."
	icon_state = "tingtang_shank"
	inhand_icon_state = "tingtang_shank"
	force = 27
	attack_speed = 1
	damtype = WHITE_DAMAGE //Almost everyone and their mother in this god forsaken district does something with sanity.

	attack_verb_continuous = list("slices", "gashes", "stabs")
	attack_verb_simple = list("slice", "gash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/sp_mod

/obj/item/ego_weapon/city/ting_tang/attack(mob/living/target, mob/living/user) //mostly stolen from dice code
	sp_mod = user.sanityhealth / user.maxSanity * 0.5 //hits .5 at max sanity.
	sp_mod = max(0.10, sp_mod)
	force = rand(force*sp_mod, force)
	..()
	force = initial(force)

/obj/item/ego_weapon/city/ting_tang/cleaver
	name = "ting tang cleaver"
	desc = "It's quite heavy, clearly made for throwing your weight around."
	icon_state = "tingtang_cleaver"
	inhand_icon_state = "tingtang_cleaver"
	force = 40
	attack_speed = 1.5
	hitsound = 'sound/weapons/fixer/generic/blade5.ogg'

/obj/item/ego_weapon/city/ting_tang/pipe
	name = "ting tang pipe"
	desc = "A heavy pipe that you're pretty sure used to belong in a car."
	icon_state = "tingtang_pipe"
	inhand_icon_state = "tingtang_pipe"
	force = 54
	attack_speed = 2
	attack_verb_continuous = list("smacks", "bludgeons", "beats")
	attack_verb_simple = list("smack", "bludgeon", "beat")
	hitsound = 'sound/weapons/fixer/generic/baton1.ogg'

/obj/item/ego_weapon/city/ting_tang/knife //Leader, Grade 6
	name = "ting tang knife"
	desc = "The finger hook at the end lets you pull off some sick tricks. If you had the skill."
	icon_state = "tingtang_knife"
	inhand_icon_state = "tingtang_knife"
	force = 37
	attack_speed = 1
	hitsound = 'sound/weapons/fixer/generic/knife1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

//Los Mariachis - Grade 7 with poise crits, white version of Kurokumo.
/obj/item/ego_weapon/city/mariachi
	name = "maraca"
	desc = "A single maraca used by Los Mariachis."
	special = "This weapon gains 1 poise for every attack. 1 poise gives you a 2% chance to crit at 3x damage, stacking linearly. Critical hits reduce poise to 0."
	icon_state = "maracas"
	inhand_icon_state = "maracas"
	force = 22
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/maracas1.ogg'
	var/poise = 0

/obj/item/ego_weapon/city/mariachi/examine(mob/user)
	. = ..()
	. += "Current Poise: [poise]/20."

/obj/item/ego_weapon/city/mariachi/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	poise+=1
	if(poise>= 20)
		poise = 20

	//Crit itself.
	if(prob(poise*2))
		force*=3
		to_chat(user, span_userdanger("Critical!"))
		poise = 0
	..()
	force = initial(force)

/obj/item/ego_weapon/city/mariachi/attack_self(mob/user)
	var/obj/item/clothing/suit/armor/ego_gear/city/mariachi/aida/Y = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		to_chat(user,span_notice("You shake the maracas. Your performance is beautiful."))
		playsound(src, 'sound/weapons/fixer/generic/maracas_shake.ogg', 50, TRUE)
	else
		to_chat(user,span_warning("Someone as uninspiring as you? You are not worthy to shake the maracas."))

//Sp healing for jobbers
/obj/item/ego_weapon/city/mariachi_blades
	name = "dual machetes"
	desc = "A pair of machetes used by the Los Mariachis."
	special = "On kill, heal 15 sanity."
	icon_state = "mariachi_blades"
	inhand_icon_state = "mariachi_blades"
	force = 22
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("slashes", "slices")
	attack_verb_simple = list("slash", "slice")
	hitsound = 'sound/weapons/fixer/generic/blade1.ogg'

/obj/item/ego_weapon/city/mariachi_blades/attack(mob/living/target, mob/living/carbon/human/user)
	var/living = FALSE
	if(!CanUseEgo(user))
		return
	if(target.stat != DEAD)
		living = TRUE
	..()
	if(target.stat == DEAD && living)
		user.adjustSanityLoss(-15)
		living = FALSE

//Leader, Grade 6 (She's pretty weak)
/obj/item/ego_weapon/city/mariachi/dual
	name = "maracas"
	desc = "A pair of maracas used by the leader of Los Mariachis."
	icon_state = "dualmaracas"
	inhand_icon_state = "dualmaracas"
	force = 19		//Double the maracas twice the attack speed.
	attack_speed = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

//Pre-nerf Aida, the real prize of J-corp. Grade 5
/obj/item/ego_weapon/city/mariachi/dual/boss
	name = "glowing maracas"
	desc = "A pair of glowing maracas used by the leader of Los Mariachis. Only seen by the no longer living."
	icon_state = "dualmaracas_boss"
	inhand_icon_state = "dualmaracas_boss"
	force = 25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
