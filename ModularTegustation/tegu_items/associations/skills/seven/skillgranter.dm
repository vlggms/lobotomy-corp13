/obj/item/assoc_skill_granter/seven
	name = "Seven Association Skill Book"
	icon_state = "seven_book"

/obj/item/assoc_skill_granter/seven/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned three Seven association skills. <br>Analysis which allows you to see the health of others. <br>Third Eye which allows you to spot hostiles and areas of interest through walls. <br>Quick Getaway which allows you to sacrifice your defense for a temporary boost to speed and deploy a smokebomb"))

	var/datum/action/G = new /datum/action/innate/analyze
	G.Grant(user)
	G = new /datum/action/cooldown/thirdeye
	G.Grant(user)
	G = new /datum/action/cooldown/quickgetaway
	G.Grant(user)

	qdel(src)

/obj/item/assoc_skill_granter/seven/veteran
	name = "Seven Association Veteran Skill Book"
	allowedjob = list("Association Veteran")

/obj/item/assoc_skill_granter/seven/veteran/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned five Seven association skills. <br>Analysis which allows you to see the health of others. <br>Third Eye which allows you to spot hostiles and areas of interest through walls. <br>Quick Getaway which allows you to sacrifice your defense for a temporary boost to speed and deploy a smokebomb. <br>Weakness Analyzed which allows you to do increased black damage against opposing monsters. <br>Field Command which allows you to permanently raise the defense and speed of allies."))

	var/datum/action/G = new /datum/action/innate/analyze
	G.Grant(user)
	G = new /datum/action/cooldown/thirdeye
	G.Grant(user)
	G = new /datum/action/cooldown/quickgetaway
	G.Grant(user)
	G = new /datum/action/cooldown/weaknessanalyzed
	G.Grant(user)
	G = new /datum/action/cooldown/fieldcommand
	G.Grant(user)

	qdel(src)

/obj/item/assoc_skill_granter/seven/director
	name = "Seven Association Director Skill Book"
	allowedjob = list("Association Section Director")

/obj/item/assoc_skill_granter/seven/director/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned five Seven association skills. <br>Analysis which allows you to see the health of others. <br>Third Eye which allows you to spot hostiles and areas of interest through walls. <br>Quick Getaway which allows you to sacrifice your defense for a temporary boost to speed and deploy a smokebomb. <br>Weakness Analyzed which allows you to do increased black damage against opposing monsters. <br>Field Command which allows you to permanently raise the defense and speed of allies. <br>Exploit the Gap which allows you to raise your speed then lower the defense of anyone next to you by the end of that speed boost"))

	var/datum/action/G = new /datum/action/innate/analyze
	G.Grant(user)
	G = new /datum/action/cooldown/thirdeye
	G.Grant(user)
	G = new /datum/action/cooldown/quickgetaway
	G.Grant(user)
	G = new /datum/action/cooldown/weaknessanalyzed
	G.Grant(user)
	G = new /datum/action/cooldown/fieldcommand
	G.Grant(user)
	G = new /datum/action/cooldown/exploitgap
	G.Grant(user)

	qdel(src)
