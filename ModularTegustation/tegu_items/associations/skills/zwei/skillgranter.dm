/obj/item/assoc_skill_granter/zwei
	name = "Zwei Association Skill Book"
	icon_state = "zwei_book"

/obj/item/assoc_skill_granter/zwei/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned two Zwei association skills. <br>Your Shield which allows you to reduce incoming damage. <br>Stand Proud which allows you to negate damage at the cost of being immobilized."))

	var/datum/action/G = new /datum/action/cooldown/yourshield
	G.Grant(user)
	G = new /datum/action/cooldown/standproud
	G.Grant(user)

	qdel(src)

/obj/item/assoc_skill_granter/zwei/veteran
	name = "Zwei Association Veteran Skill Book"
	allowedjob = list("Association Veteran")

/obj/item/assoc_skill_granter/zwei/veteran/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned four Zwei association skills. <br>Your Shield which allows you to reduce incoming damage. <br>Stand Proud which allows you to negate damage at the cost of being immobilized. <br>Protect the Innocent which allows you to grant damage reduction for those weaker than you. <br>Last Stand which allows you to come back from dead at the cost of taking constant damage."))

	var/datum/action/G = new /datum/action/cooldown/yourshield
	G.Grant(user)
	G = new /datum/action/cooldown/standproud
	G.Grant(user)
	G = new /datum/action/cooldown/protectinnocent
	G.Grant(user)
	G = new /datum/action/cooldown/laststand
	G.Grant(user)

	qdel(src)

/obj/item/assoc_skill_granter/zwei/director
	name = "Zwei Association Director Skill Book"
	allowedjob = list("Association Section Director")

/obj/item/assoc_skill_granter/zwei/director/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned five Zwei association skills. <br>Your Shield which allows you to reduce incoming damage. <br>Stand Proud which allows you to negate damage at the cost of being immobilized. <br>Protect the Innocent which allows you to grant damage reduction for those weaker than you. <br>Last Stand which allows you to come back from dead at the cost of taking constant damage. <br>Flexible Suppression which will strike and slowdown those with higher max hp than you"))

	var/datum/action/G = new /datum/action/cooldown/yourshield
	G.Grant(user)
	G = new /datum/action/cooldown/standproud
	G.Grant(user)
	G = new /datum/action/cooldown/protectinnocent
	G.Grant(user)
	G = new /datum/action/cooldown/laststand
	G.Grant(user)
	G = new /datum/action/cooldown/flexsuppress
	G.Grant(user)

	qdel(src)
