//Night Awl - Grade 4 with crits.
/obj/item/ego_weapon/city/awl
	name = "night awl stilleto"
	desc = "A thin stabbing knife, used by the Night Awls syndicate group."
	special = "This weapon has a 10% chance to deal double damage. This weapon fits in an EGO belt."
	icon_state = "nightawl"
	force = 40
	attack_speed = 1.2
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)


/obj/item/ego_weapon/city/awl/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(prob(10))
		force*=2
		to_chat(user, span_userdanger("Critical!"))
	..()
	force = initial(force)

//Kurokumo - Grade 4 with poise crits.
/obj/item/ego_weapon/city/kurokumo
	name = "kurokumo blade"
	desc = "A very sharp blade used by the Kurokumo clan. Get it bloody."
	special = "This weapon gains 1 poise for every attack. 1 poise gives you a 2% chance to crit at 3x damage, stacking linearly. Critical hits reduce poise to 0."
	icon_state = "kurokumo_sheathed"
	inhand_icon_state = "kurokumo_sheathed"
	force = 52
	attack_speed = 1.2
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)
	var/poise = 0

/obj/item/ego_weapon/city/kurokumo/examine(mob/user)
	. = ..()
	. += "Current Poise: [poise]/20."

/obj/item/ego_weapon/city/kurokumo/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	poise+=1
	if(poise>=10)
		icon_state = "kurokumo"
		inhand_icon_state = "kurokumo"
	else if(poise>= 20)
		poise = 20

	//Crit itself.
	if(prob(poise*2))
		force*=3
		to_chat(user, span_userdanger("Critical!"))
		poise = 0
		icon_state = "kurokumo_sheathed"
		inhand_icon_state = "kurokumo_sheathed"
	..()
	force = initial(force)

//Blade Lineage - Grade 4, use in hand to immobilize and give you a massive damage boost
/obj/item/ego_weapon/city/bladelineage
	name = "blade lineage katana"
	desc = "A blade that is standard among blade lineage."
	special = "Use this weapon in hand to immobilize yourself for 3 seconds and deal 5x damage on the next attack within 5 seconds."
	icon_state = "blade_lineage"
	inhand_icon_state = "blade_lineage"
	force = 46
	attack_speed = 1.2
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)
	var/ready = TRUE
	var/multiplier = 5


/obj/item/ego_weapon/city/bladelineage/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(3 SECONDS)
	to_chat(user, span_userdanger("Yield my flesh."))
	force*=multiplier

	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/obj/item/ego_weapon/city/bladelineage/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(force != initial(force))
		to_chat(user, span_userdanger("To claim their bones."))
		force = initial(force)

/obj/item/ego_weapon/city/bladelineage/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	ready = TRUE
	to_chat(user, span_notice("Your blade is ready."))
