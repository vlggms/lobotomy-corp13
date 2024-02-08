//Grade 3. They're pretty strong
/obj/item/ego_weapon/city/mirae
	name = "mirae cane"
	desc = "An elegant cane. There's the logo of a life insurance company on the top."
	special = "On kill, heal yourself and get a small payday. 20% of the force is done as pale."
	icon_state = "miraecane"
	force = 50
	damtype = WHITE_DAMAGE	//Also does a small bit of pale, because lawyers hurt your mind and soul.

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 80,
	)
	var/ahn_amount = 300
	var/boxchance = 10

/obj/item/ego_weapon/city/mirae/attack(mob/living/target, mob/living/carbon/human/user)
	var/living = FALSE
	if(!CanUseEgo(user))
		return
	if(target.stat != DEAD)
		living = TRUE
	target.apply_damage(force*0.2, PALE_DAMAGE, null, target.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	..()

	if(target.stat == DEAD && living)
		to_chat(user, span_minorannounce("Payday!!!"))
		var/obj/item/holochip/C = new (get_turf(src))
		C.credits = rand(ahn_amount/4,ahn_amount)
		//10% chance for this
		if(prob(boxchance))
			new /obj/item/rawpe(get_turf(src))
		user.adjustBruteLoss(-50)


//Grade 3, but does less damage with a way better payout
/obj/item/ego_weapon/city/mirae/page
	name = "mirae life insurance package"
	desc = "Life insurance papers that are extremely hefty, should get you a good payout."
	icon_state = "insurance"
	force = 45
	damtype = WHITE_DAMAGE	//Also does a small bit of pale, because lawyers eat your soul.

	ahn_amount = 700
	boxchance = 30
