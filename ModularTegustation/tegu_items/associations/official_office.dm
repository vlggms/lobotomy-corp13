/obj/item/office_marker
	desc = "A small device which allows hana to assign official offices."
	name = "office marker"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "delivery"
	inhand_icon_state = "flashbang"
	var/list/usable_roles = list("Hana Representative", "Hana Administrator", "Hana Intern")
	var/current_office

/obj/item/office_marker/examine(mob/user)
	. = ..()
	. += span_notice("This marker currently adds people to the [current_office] office.")

/obj/item/office_marker/attack_self(mob/living/carbon/human/user)
	//only hana can use this.
	if(!(user?.mind?.assigned_role in usable_roles))
		to_chat(user, span_danger("You cannot use this item, as you are not a part of Hana Association."))
		return

	current_office = input("Set a new office", "Set Office") as null | text
	to_chat(user, span_nicegreen("[src] will now add people to the [current_office] Office."))

/obj/item/office_marker/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!(user?.mind?.assigned_role in usable_roles))
		to_chat(user, span_danger("You cannot use this item, as you are not a part of Hana Association."))
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.assigned_office)
			H.assigned_office = current_office
			to_chat(user, span_nicegreen("You added [target] to the [current_office] Office."))
		else
			var/hana_ask = alert("Target is a a part of the [H.assigned_office] Office, do you wish to remove them?", "Office Update", "Yes", "No")
			if(hana_ask == "Yes")
				H.assigned_office = null
				to_chat(user, span_nicegreen("You removed [target] from the [H.assigned_office] Office."))

/obj/item/office_marker/syndicate
	desc = "A small device which allows syndicates to bypass the office gates."
	name = "syndicate bypass"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "delivery"
	inhand_icon_state = "flashbang"
	usable_roles = list("Blade Lineage Cutthroat", "Index Messenger", "Kurokumo Kashira", "Grand Inquisitor", "Thumb Sottocapo")

/obj/item/office_marker/syndicate/attack_self(mob/living/carbon/human/user)
	return

/obj/item/office_marker/syndicate/afterattack(atom/target, mob/user, proximity_flag)
	if(!(user?.mind?.assigned_role in usable_roles))
		to_chat(user, span_danger("You cannot use this item, as you are not a part of a syndicate."))
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.assigned_office = "syndicate_bypass"
		to_chat(user, span_nicegreen("You gave the bypass to [H]."))

/obj/item/attribute_increase/fixer/office
	name = "office n corp training accelerator"
	desc = "A fluid used to increase the stats of a non-assocaition fixer. Use in hand to activate. Increases stats more the lower your potential. Effects eveyone a part of your office."
	amount = 1
	var/public_use = FALSE

/obj/item/attribute_increase/fixer/office/attack_self(mob/living/carbon/human/user)
	if(!public_use)
		if(!(user?.mind?.assigned_role in usable_roles))
			to_chat(user, span_danger("You cannot use this item, as you must not belong to an association."))
			return

	if(!user.assigned_office)
		to_chat(user, span_danger("You cannot use this item, as you are not a part of an office."))
		return

	for(var/mob/living/carbon/human/H in range(5, get_turf(src)))
		if(H.assigned_office == user.assigned_office && H.assigned_office != "syndicate_bypass" && H != user)
			if(!public_use)
				if(!(H?.mind?.assigned_role in usable_roles))
					to_chat(H, span_danger("You cannot use this item, as you must not belong to an association."))
					continue

			//max stats can't gain stats
			if(get_attribute_level(H, TEMPERANCE_ATTRIBUTE)>=130)
				to_chat(H, span_danger("You feel like you won't gain anything."))
				continue

			to_chat(H, span_nicegreen("You suddenly feel different."))
			//Guarantee one
			H.adjust_all_attribute_levels(amount)
			to_chat(H, "<span class='nicegreen'>You gain 1 potential!</span>")

			//Adjust by an extra attribute under level 2
			if(get_attribute_level(H, TEMPERANCE_ATTRIBUTE)<=40)
				H.adjust_all_attribute_levels(amount)
				to_chat(H, "<span class='nicegreen'>You gain 1 potential!</span>")

			//And one more under level 3
			if(get_attribute_level(H, TEMPERANCE_ATTRIBUTE)<=60)
				H.adjust_all_attribute_levels(amount)
				to_chat(H, "<span class='nicegreen'>You gain 1 potential!</span>")

			//And one last one before L4
			if(get_attribute_level(H, TEMPERANCE_ATTRIBUTE)<=80)
				H.adjust_all_attribute_levels(amount)
				to_chat(H, "<span class='nicegreen'>You gain 1 potential!</span>")
	. = ..()

/obj/machinery/scanner_gate/officescanner
	name = "office scanner gate"
	density = FALSE
	locked = TRUE
	use_power = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/list/check_times = list()
	var/list/usable_roles = list("Civilian", "Office Director", "Office Fixer",
		"Subsidary Office Director", "Fixer")

/obj/machinery/scanner_gate/officescanner/auto_scan(atom/movable/AM)
	return

/obj/machinery/scanner_gate/officescanner/attackby(obj/item/W, mob/user, params)
	return

/obj/machinery/scanner_gate/officescanner/emag_act(mob/user)
	return

#define OFFICE_MESSAGE_COOLDOWN 50
/obj/machinery/scanner_gate/officescanner/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(isobj(mover))
		return FALSE
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		set_scanline("scanning", 5)
		if(H?.mind?.assigned_role in usable_roles)
			if(!H.assigned_office)
				if(!check_times[H] || check_times[H] < world.time) //Let's not spam the message
					to_chat(H, span_boldwarning("You are moving into the backstreets without an offical office resignation! Your journey will be a painful one without your office."))
					check_times[H] = world.time + OFFICE_MESSAGE_COOLDOWN
				alarm_beep()

#undef OFFICE_MESSAGE_COOLDOWN
