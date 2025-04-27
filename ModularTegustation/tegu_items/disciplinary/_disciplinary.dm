//Egoshards - used to upgrade the armor and weapons in the lcorp files.
/obj/item/egoshard
	name = "cracked red egoshard"
	desc = "An egoshard in a pathetic, but still usable state."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "egoshard_r"
	var/stat_requirement = 60 //Stat requirements should match the E.G.O. tier +20, similar to city equipment
	//Weapon stats
	var/damage_type = RED_DAMAGE
	var/base_damage = 30 //Base damage of the tier
	var/tier = 1 //used to figure out gun damage
	//Armor stats
	var/red_bonus = 10 //40 from the base of 20 in red, so 60
	var/white_bonus = 10
	var/black_bonus = 10
	var/pale_bonus = 10

/obj/item/egoshard/examine(mob/user)
	. = ..()
	if(stat_requirement)
		. += span_warning("Equipment enhanced with this egoshard will require [stat_requirement] in all attributes to use.")
	switch(damage_type)
		if(RED_DAMAGE)
			. += span_notice("This one looks red.")
		if(WHITE_DAMAGE)
			. += span_notice("This one looks white.")
		if(BLACK_DAMAGE)
			. += span_notice("This one looks black.")
		if(PALE_DAMAGE)
			. += span_notice("This one looks pale.")
