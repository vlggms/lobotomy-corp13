/obj/item/tresmetal
	name = "tres metal"
	desc = "Metal used for forging into workshop weapons."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "tresmetal"
	w_class = WEIGHT_CLASS_BULKY
	var/quality = 0
	var/resource_type = /obj/item/tresmetal
	var/heated_type = /obj/item/hot_tresmetal

/obj/item/tresmetal/Initialize()
	. = ..()
	desc += " Put into the forge to heat it."

/obj/item/tresmetal/attack_self(mob/user)
	if(!resource_type)
		return ..()
	if(type == resource_type && quality == 0)
		return ..()
	to_chat(user, span_notice("You break [src] down into it's original parts."))
	var/make_amount = quality > 0 ? quality * 10 : 1
	if(make_amount > 1)
		var/obj/item/storage/box/materials_disposable/MD = new(get_turf(src))
		var/datum/component/storage/ST = MD.GetComponent(/datum/component/storage)
		for(var/I = 1 to make_amount)
			var/obj/item/D = new resource_type(get_turf(user))
			if(ST.can_be_inserted(D, TRUE, null)) // Try to put in the current one
				ST.handle_item_insertion(D, TRUE, null)
				continue
			MD = new(get_turf(src)) // Make a new one if full
			ST = MD.GetComponent(/datum/component/storage)
			ST.handle_item_insertion(D, TRUE, null)
	else
		new resource_type(get_turf(user))
	qdel(src)
	return

/obj/item/tresmetal/proc/SetQuality(value)
	if(!value)
		return
	quality = value
	var/name_mod = "inexplicable "
	switch(quality)
		if(0)
			name_mod = "inferior "
		if(1)
			name_mod = "standard "
		if(2)
			name_mod = "potent "
		if(3)
			name_mod = "dense "
	name = name_mod + name

/obj/item/hot_tresmetal
	name = "heated tres metal"
	desc = "Metal used for forging workshop weapons."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "tresmetal_hot"
	w_class = WEIGHT_CLASS_BULKY
	var/matname = "tressium"
	var/quality = 0 // Final multiplier to stats. 1 = 10% | 2 = 20% | 3+ = 40%
	var/force_bonus = 0
	var/force_mod = 1
	var/attack_mult = 1
	var/type_override = FALSE // Replace with damage type if overwriting.
	var/hitsound_override = FALSE // Replace with audio string if overwriting. Ex. "sound/effects/clownstep1.ogg"
	var/obj/item/tresmetal/original_mat = /obj/item/tresmetal
	var/cool_timer

/obj/item/hot_tresmetal/Initialize()
	cool_timer = addtimer(CALLBACK(src, PROC_REF(cooling)), 5 MINUTES, TIMER_STOPPABLE)
	..()
	name = "heated " + initial(original_mat.name)
	desc += " Put it on an anvil and hit with a hammer to work it."

/obj/item/hot_tresmetal/proc/cooling()
	var/obj/item/tresmetal/cooled = new original_mat(get_turf(src))
	cooled.SetQuality(quality)
	visible_message(span_notice("The [src] cooled down to it's original form."))
	qdel(src)

/obj/item/hot_tresmetal/proc/SetQuality(value)
	if(!value)
		return
	quality = value
	var/name_mod = "inexplicable "
	switch(quality)
		if(0)
			name_mod = "inferior "
		if(1)
			name_mod = "standard "
		if(2)
			name_mod = "potent "
		if(3)
			name_mod = "dense "
	name = name_mod + name
	matname = name_mod + matname

/obj/item/hot_tresmetal/attackby(obj/item/I, mob/living/user, params)
	..()
	if(istype(I, /obj/item/forginghammer))
		if(!(locate(/obj/structure/table/anvil) in loc))
			to_chat(user, span_warning("You need this to be on an anvil to work it."))
			return

		if(!do_after(user, 10 SECONDS))
			return

		var/list/display_names = generate_display_names()
		if(!display_names.len)
			return
		var/choice = input(user,"Which item would you like to make?","Select an Item") as null|anything in sortList(display_names)
		if(!choice || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
			return
		spawn_option(display_names[choice])

/obj/item/hot_tresmetal/proc/generate_display_names()
	var/static/list/template_types
	if(!template_types)
		template_types = list()
		var/list/templist = subtypesof(/obj/item/ego_weapon/template) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			template_types[initial(A.name)] = A
	return template_types

/obj/item/hot_tresmetal/proc/spawn_option(obj/item/choice)
	var/obj/item/creation = new choice(get_turf(src))
	OnCreation(creation)
	visible_message(span_notice("The tresmetal is worked into a [creation.name]."))
	deltimer(cool_timer)
	qdel(src)

/obj/item/hot_tresmetal/proc/OnCreation(obj/item/ego_weapon/template/creation)
	if(!istype(creation))
		return FALSE
	creation.force *= force_mod
	creation.force += force_bonus
	creation.attack_speed *= attack_mult
	if(type_override)
		creation.damtype = type_override
		creation.type_overriden = TRUE
	if(hitsound_override)
		creation.hitsound = hitsound_override
	if(quality)
		if(attack_mult < 1)
			creation.attack_speed /= quality > 2 ? 1.4 : (quality * 0.1) + 1
		else
			creation.force *= quality > 2 ? 1.4 : (quality * 0.1) + 1
	for(var/i = 1 to creation.finishedname.len)
		creation.finishedname[i] = matname + " " + creation.finishedname[i]
	if(color)
		creation.color = color
	return TRUE


/obj/item/tresmetal/crimson
	name = "ingot of honkium"
	desc = "There's something funny going on here..."
	icon_state = "ingot_grayscale"
	color = COLOR_RED
	resource_type = /obj/item/food/meat/slab/crimson
	heated_type = /obj/item/hot_tresmetal/crimson

/obj/item/hot_tresmetal/crimson
	desc = "Is it getting hot in here, or is it just me?"
	matname = "honkium"
	attack_mult = 0.8
	hitsound_override = "sound/effects/clownstep1.ogg"
	original_mat = /obj/item/tresmetal/crimson


/obj/item/tresmetal/violet
	name = "ingot of fractured potentium"
	desc = "What could have been will haunt you always..."
	icon_state = "ingot_grayscale"
	color = COLOR_VIOLET
	resource_type = /obj/item/food/meat/slab/fruit
	heated_type = /obj/item/hot_tresmetal/violet

/obj/item/hot_tresmetal/violet
	desc = "One of many things to break under pressure."
	matname = "fractured potentium"
	force_mod = 1.2
	type_override = WHITE_DAMAGE
	original_mat = /obj/item/tresmetal/violet


/obj/item/tresmetal/human
	name = "ingot of... oh no"
	desc = "Why would you do this?"
	icon_state = "ingot_grayscale"
	color = COLOR_OLIVE
	resource_type = /obj/item/food/meat/slab/human
	heated_type = /obj/item/hot_tresmetal/human

/obj/item/hot_tresmetal/human
	desc = "Its smell is sickening."
	matname = "sapium"
	force_bonus = 1
	force_mod = 1.05
	attack_mult = 0.95
	type_override = PALE_DAMAGE
	hitsound_override = "sound/effects/wounds/crackandbleed.ogg"
	original_mat = /obj/item/tresmetal/human


/obj/item/tresmetal/green
	name = "ingot of sentium"
	desc = "Perhaps some spark of thought still remains within?"
	icon_state = "ingot_grayscale"
	color = COLOR_GREEN
	resource_type = /obj/item/food/meat/slab/robot
	heated_type = /obj/item/hot_tresmetal/green

/obj/item/hot_tresmetal/green
	desc = "Logic tends to fail when it's needed most."
	matname = "sentium"
	force_bonus = 15
	original_mat = /obj/item/tresmetal/green


/obj/item/tresmetal/indigo
	name = "ingot of sweepium"
	desc = "The distilled essense of brooms... wait it's not?"
	icon_state = "ingot_grayscale"
	color = COLOR_DARK_CYAN
	resource_type = /obj/item/food/meat/slab/sweeper
	heated_type = /obj/item/hot_tresmetal/indigo

/obj/item/hot_tresmetal/indigo
	desc = "It's sticky, just like a broom."
	matname = "sweepium"
	attack_mult = 0.9
	force_bonus = 5
	type_override = BLACK_DAMAGE
	original_mat = /obj/item/tresmetal/indigo


/obj/item/tresmetal/amber
	name = "ingot of hungium"
	desc = "DO NOT EAT. DO NOT EAT. DO NO- Maybe just a bite?"
	icon_state = "ingot_grayscale"
	color = COLOR_ASSEMBLY_ORANGE
	resource_type = /obj/item/food/meat/slab/worm
	heated_type = /obj/item/hot_tresmetal/amber

/obj/item/hot_tresmetal/amber
	desc = "Definitely a mis-steak not to eat this."
	matname = "hungium"
	force_mod = 1.1
	force_bonus = 5
	type_override = RED_DAMAGE
	original_mat = /obj/item/tresmetal/amber

/obj/item/hot_tresmetal/amber/OnCreation(obj/item/ego_weapon/template/creation)
	if(!..())
		return
	creation.AddComponent(/datum/component/edible,\
		initial_reagents = list(
			/datum/reagent/consumable/nutriment/protein = 20*(quality+1),
			/datum/reagent/consumable/nutriment/vitamin = 6*(quality+1)),\
			foodtypes = MEAT,\
			volume = 1000,\
			tastes = list("pain", "meat", "hunger"),\
			eat_time = 0,\
		)
	return


