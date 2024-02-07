//Jeong's Office - Grade 5, use in hand to cut your HP by 10%. Next attack deals 5x damage
//The brightest stars last half as long
/obj/item/ego_weapon/city/jeong
	name = "jeong's office wakizashi"
	desc = "A small blade, easy to keep with you. It would be nice to have on hand in a casino brawl."
	special = "Use this weapon in hand to cut your HP by 20%. Next attack within 5 seconds deals 3x damage. This weapon fits in an EGO belt."
	icon_state = "jeong_fixer"
	force = 30
	attack_speed = 0.7
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("slices", "stabs")
	attack_verb_simple = list("slice", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)
	var/ready = TRUE


/obj/item/ego_weapon/city/jeong/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	to_chat(user, span_userdanger("Low at Night."))
	force*=3
	user.adjustBruteLoss(user.maxHealth*0.2)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/obj/item/ego_weapon/city/jeong/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(force != initial(force))
		to_chat(user, span_userdanger("High at Day."))
		force = initial(force)

/obj/item/ego_weapon/city/jeong/proc/Return(mob/living/carbon/human/user)
	ready = TRUE
	force = initial(force)
	to_chat(user, span_notice("Your blade is ready."))

//Grade 4
/obj/item/ego_weapon/city/jeong/large
	name = "jeong's office katana"
	desc = "A long blade, lightweight and easy to move with. It would be simple to break up a fight with this."
	icon_state = "jeong_long"
	force = 70
	attack_speed = 1.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
