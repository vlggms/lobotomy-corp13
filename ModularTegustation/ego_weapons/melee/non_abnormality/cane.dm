//Like this so we can add a charge mechanic to one of them and have it carry down.
//All of these weapons are grade 4.
/obj/item/ego_weapon/city/cane
	name = "cane office template"
	desc = "This is a template and should not be seen."
	force = 9
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)

	charge = TRUE
	ability_type = ABILITY_ON_ACTIVATION
	charge_cost = 2
	charge_effect = "deal an extra attack in damage."
	successfull_activation = "You release your charge, damaging your opponent!"

//Actual weapons
/obj/item/ego_weapon/city/cane/cane
	name = "cane office - cane"
	desc = "A white cane that holds electricity."
	icon_state = "cane_cane"
	inhand_icon_state = "cane_cane"
	force = 25
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

	charge_cost = 8
	charge_effect = "heal yourself."
	successfull_activation = "You release your charge, healing yourself!"

/obj/item/ego_weapon/city/cane/cane/ChargeAttack(target, mob/living/carbon/human/user)
	..()
	user.adjustBruteLoss(-user.maxHealth*0.07)
	user.adjustSanityLoss(-user.maxSanity*0.07)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/obj/item/ego_weapon/city/cane/cane/proc/Return(mob/living/carbon/human/user)
	to_chat(user, span_notice("You heal once more."))
	user.adjustBruteLoss(-user.maxHealth*0.07)
	user.adjustSanityLoss(-user.maxSanity*0.07)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/justitia_effect(T)

/obj/item/ego_weapon/city/cane/claw
	name = "cane office - claw"
	desc = "A white claw seen in use by the cane office."
	icon_state = "cane_claw"
	inhand_icon_state = "cane_claw"
	force = 10
	attack_speed = 0.3
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cut", "slice")

	charge_cost = 3
	charge_effect = "dash a short distance."
	successfull_activation = "You release your charge, boosting forwards!"

	var/dodgelanding

/obj/item/ego_weapon/city/cane/claw/ChargeAttack(target, mob/living/user)
	..()
	if(user.dir == NORTH)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == SOUTH)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == EAST)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == WEST)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.throw_at(dodgelanding, 3, 2, spin = FALSE)


/obj/item/ego_weapon/city/cane/fist
	name = "cane office - gauntlet"
	desc = "A gauntlet seen in use by the cane office."
	icon_state = "cane_gauntlet"
	inhand_icon_state = "cane_gauntlet"
	force = 25
	attack_verb_continuous = list("smashes", "bashes")
	attack_verb_simple = list("smash", "bash")

	charge_cost = 8
	charge_effect = "boost this weapon's attack."
	successfull_activation = "You release your energy, powering your gauntlet!"

/obj/item/ego_weapon/city/cane/fist/ChargeAttack(target, mob/living/carbon/human/user)
	..()
	force = force*2
	addtimer(CALLBACK(src, PROC_REF(Return), user), 2 SECONDS)

/obj/item/ego_weapon/city/cane/fist/proc/Return(mob/living/user)
	force = initial(force)

/obj/item/ego_weapon/city/cane/briefcase
	name = "cane office - briefcase"
	desc = "A briefcase seen in use by the cane office."
	icon_state = "cane_briefcase"
	inhand_icon_state = "cane_briefcase"
	force = 15
	attack_verb_continuous = list("smashes", "bashes")
	attack_verb_simple = list("smash", "bash")

	charge_cost = 4
	charge_effect = "knock others backwards!"
	successfull_activation = "You release your energy, knocking everyone nearby backwards!"

/obj/item/ego_weapon/city/cane/briefcase/ChargeAttack(target, mob/living/user)
	..()
	goonchem_vortex(get_turf(src), 1, 4)

	for(var/turf/T in orange(2, user))
		new /obj/effect/temp_visual/smash_effect(T)

	for(var/mob/living/L in range(2, user))
		if(L == user)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.sanity_lost)
				continue
		L.deal_damage(10, WHITE_DAMAGE, user, attack_type = (ATTACK_TYPE_SPECIAL))

