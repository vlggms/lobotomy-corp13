//Like this so we can add a charge mechanic to one of them and have it carry down.
/obj/item/ego_weapon/city/wcorp
	name = "W corp baton"
	desc = "A glowing blue baton used by W corp employees."
	icon_state = "wbatong"
	inhand_icon_state = "wbatong"
	force = 18
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	var/release_message = "You release your charge, damaging your opponent!"
	var/charge_effect = "deal an extra attack in damage."
	var/charge_cost = 2
	var/charge
	var/activated

/obj/item/ego_weapon/city/wcorp/attack_self(mob/user)
	..()
	if(charge>=charge_cost)
		to_chat(user, "<span class='notice'>You prepare to release your charge.</span>")
		activated = TRUE
	else
		to_chat(user, "<span class='notice'>You don't have enough charge.</span>")

/obj/item/ego_weapon/city/wcorp/examine(mob/user)
	. = ..()
	. += "Spend [charge]/[charge_cost] charge to [charge_effect]"

/obj/item/ego_weapon/city/wcorp/attack(mob/living/target, mob/living/user)
	..()
	if(charge<20 && target.stat != DEAD)
		charge+=1
	if(activated)
		charge -= charge_cost
		release_charge(target, user)
		activated = FALSE

/obj/item/ego_weapon/city/wcorp/proc/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(2)
	target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/justitia_effect(T)

//Non-baton Wcorp is Grade 5
/obj/item/ego_weapon/city/wcorp/fist
	name = "w-corp gauntlet"
	desc = "A glowing blue fist used by senior W corp staff."
	icon_state = "wcorp_fist"
	inhand_icon_state = "wcorp_fist"
	force = 40
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	release_message = "You release your charge, slamming your whole weight into your opponent!"
	charge_effect = "knock your opponent backwards."
	charge_cost = 3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/city/wcorp/fist/release_charge(mob/living/target, mob/living/user)
	..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(2, 5), whack_speed, user)


/obj/item/ego_weapon/city/wcorp/axe
	name = "w-corp axe"
	desc = "A glowing blue axe used by senior W corp staff."
	icon_state = "wcorp_axe"
	inhand_icon_state = "wcorp_fist"
	force = 70
	attack_speed = 2
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleave", "cut")
	release_message = "You release your charge, attempting to execute your opponent!"
	charge_effect = "deal 3x damage and slow your next attack down."
	charge_cost = 4
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/wcorp/axe/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(5)
	target.apply_damage(force*3, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/justitia_effect(T)
	user.changeNext_move(CLICK_CD_MELEE * 6)

/obj/item/ego_weapon/city/wcorp/spear
	name = "w-corp spear"
	desc = "A glowing blue spear used by senior W corp staff."
	icon_state = "wcorp_spear"
	inhand_icon_state = "wcorp_spear"
	force = 40
	reach = 2
	attack_speed = 1.2
	release_message = "You release your charge, resulting in a massive discharge!"
	charge_effect = "deal damage in an area around you."
	charge_cost = 3
	attack_verb_continuous = list("slashes", "pokes")
	attack_verb_simple = list("slash", "poke")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/wcorp/spear/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(2)
	for(var/mob/living/L in range(1, src))
		var/aoe = 25
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		if(L == user || ishuman(L))
			continue
		L.apply_damage(force, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	user.changeNext_move(CLICK_CD_MELEE * 3)


/obj/item/ego_weapon/city/wcorp/dagger
	name = "w-corp dagger"
	desc = "A glowing blue dagger used by senior W corp staff."
	icon_state = "wcorp_dagger"
	inhand_icon_state = "wcorp_dagger"
	force = 24
	attack_speed = 0.5
	charge_cost = 8
	attack_verb_continuous = list("slices", "stabs")
	attack_verb_simple = list("slice", "stab")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)


/obj/item/ego_weapon/city/wcorp/dagger/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(2)
	for(var/i = 1 to 3)
		sleep(2)
		target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
		playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
		var/turf/T = get_turf(target)
		new /obj/effect/temp_visual/justitia_effect(T)



//Modified W-Corp weapons are above Grade 5, usually stopping at the higher end of Grade 3.
//Alongside the burst damage, they usually include a minor side-effect. Custom-made by ValerieSteel!

//Kirie Note: don't really want to you know, add a very rare part to the Wcorp banner, so I'm gonna keep these at Grade 5.
/obj/item/ego_weapon/city/wcorp/hatchet
	name = "w-corp hatchet"
	desc = "A glowing blue W-Corp handaxe once used by senior W-Corp staff. This one's seen some after-market modifications."
	special = "This weapon fits in an EGO belt."
	icon_state = "wcorp_hatchet"
	inhand_icon_state = "wcorp_hatchet"
	force = 34	//Slowing is massive.
	attack_speed = 1
	charge_cost = 5
	attack_verb_continuous = list("cleaves", "slashes", "carves")
	attack_verb_simple = list("cleave", "slash", "carve")
	release_message = "You release your charge, attempting to cripple your enemy!"
	charge_effect = "deliver a crippling blow, slowing your target."
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/wcorp/hatchet/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(2)
	target.apply_damage(force*2, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	target.apply_status_effect(/datum/status_effect/qliphothoverload)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/justitia_effect(T)


/obj/item/ego_weapon/city/wcorp/hammer
	name = "w-corp warhammer"
	desc = "A glowing blue W-Corp warhammer once used by senior W-Corp staff. This one's seen some after-market modifications."
	icon_state = "wcorp_hammer"
	inhand_icon_state = "wcorp_hammer"
	force = 80
	attack_speed = 2
	attack_verb_continuous = list("smashes", "crushes", "shatters")
	attack_verb_simple = list("smash", "crush", "shatter")
	charge_cost = 8
	release_message = "You release your charge, shattering the will of your foe!"
	charge_effect = "increase the BLACK damage your target takes for a short time."
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)


/obj/item/ego_weapon/city/wcorp/hammer/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(5)
	target.apply_damage(force*2, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	target.apply_status_effect(/datum/status_effect/rendBlackArmor)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/justitia_effect(T)

/datum/status_effect/rendBlackArmor
	id = "rend Black armor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 50 //5 seconds since it's melee-ish
	alert_type = null

/datum/status_effect/rendBlackArmor/on_apply()
	. = ..()
	if(isanimal(owner))
		var/mob/living/simple_animal/M = owner
		M.damage_coeff[BLACK_DAMAGE] *= 1.2

/datum/status_effect/rendBlackArmor/on_remove()
	. = ..()
	if(isanimal(owner))
		var/mob/living/simple_animal/M = owner
		M.damage_coeff[BLACK_DAMAGE] /= 1.2


//Type C weapons

/datum/status_effect/interventionshield/wcorp
	statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "pale_shield")

/obj/item/ego_weapon/city/wcorp/shield
	name = "w-corp type-C shieldblade"
	desc = "A glowing blue W-Corp blade used to project barriers. The glowing end is dangerous, and can slice through about anything"
	icon_state = "wcorp_sword"
	inhand_icon_state = "wcorp_sword"
	force = 35 //Meant originally as a support device, used as a mace in a pinch.
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleave", "cut")
	charge_cost = 16
	release_message = "You release your charge, projecting shields upon your allies!"
	charge_effect = "grant shields to nearby allies on hit."
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/wcorp/shield/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(2)
	for(var/mob/living/carbon/human/L in range(7, user))
		if(!ishuman(L))
			continue
		L.apply_status_effect(/datum/status_effect/interventionshield/wcorp)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)

//Type C Spear
/obj/item/ego_weapon/city/wcorp/shield/spear
	name = "w-corp type-C shieldglaive"
	desc = "A glowing blue W-Corp glaive used to project barriers."
	icon_state = "wcorp_glaive"
	inhand_icon_state = "wcorp_glaive"
	reach = 2
	attack_speed = 1.2

//Type C club
/obj/item/ego_weapon/city/wcorp/shield/club
	name = "w-corp type-C shieldclub"
	desc = "A glowing blue W-Corp club used to project barriers."
	icon_state = "wcorp_club"
	inhand_icon_state = "wcorp_club"
	attack_speed = 1.5

/obj/item/ego_weapon/city/wcorp/shield/club/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//Type C axe
/obj/item/ego_weapon/city/wcorp/shield/axe
	name = "w-corp type-C shieldaxe"
	desc = "A glowing blue W-Corp battleaxe used to project barriers."
	icon_state = "wcorp_battleaxe"
	inhand_icon_state = "wcorp_battleaxe"
	force = 45
	attack_speed = 1.5
