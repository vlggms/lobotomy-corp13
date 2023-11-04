//Ncorp levelers
/obj/item/attribute_increase
	name = "training accelerator"
	desc = "A fluid used to increase the user's stats. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"
	var/amount = 1

/obj/item/attribute_increase/attack_self(mob/living/carbon/human/user)
	to_chat(user, "<span class='nicegreen'>You suddenly feel different.</span>")
	user.adjust_all_attribute_levels(amount)
	qdel(src)


/obj/item/attribute_increase/small
	name = "ncorp small training accelerator"
	icon_state = "ncorp_syringe1"
	amount = 3

/obj/item/attribute_increase/medium
	name = "ncorp medium training accelerator"
	icon_state = "ncorp_syringe2"
	amount = 5

/obj/item/attribute_increase/large
	name = "ncorp large training accelerator"
	icon_state = "ncorp_syringe3"
	amount = 10

/obj/item/attribute_increase/xtralarge
	name = "ncorp extra large training accelerator"
	icon_state = "ncorp_syringe4"
	amount = 20

//Limit increaser
/obj/item/limit_increase
    name = "ncorp limit breaker"
    desc = "A fluid used to increase an agent's maximum potential. Use in hand to activate."
    icon = 'ModularTegustation/Teguicons/teguitems.dmi'
    icon_state = "ncorp_syringe5"
    var/amount = 140
    var/list/allowed_roles = list()

/obj/item/limit_increase/Initialize()
	..()
	if(!LAZYLEN(allowed_roles))
		allowed_roles = GLOB.security_positions // defaults to agents.

/obj/item/limit_increase/attack_self(mob/living/carbon/human/user)
	if(user?.mind?.assigned_role in allowed_roles)
		to_chat(user, "<span class='nicegreen'>You feel like you can become even more powerful.</span>")
		user.set_attribute_limit(amount)
		qdel(src)
		return
	to_chat(user, "<span class='notice'>This is not for you.</span>")
	return

//Officer limit increase.
/obj/item/limit_increase/officer
	name = "officer limit breaker"
	desc = "A fluid used to increase the limit of L-Corp officer's potential. Use in hand to activate."
	icon_state = "oddity7_gween"
	amount = 80
	allowed_roles = list("Records Officer", "Extraction Officer")

