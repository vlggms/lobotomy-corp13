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
	var/red_bonus = 20 //50 from the base of 20 in red, so 70
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


/obj/item/egoshard/white
	name = "cracked white egoshard"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = -10
	white_bonus = 40
	black_bonus = 10
	pale_bonus = 10

/obj/item/egoshard/black
	name = "cracked black egoshard"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = -10
	white_bonus = 10
	black_bonus = 40
	pale_bonus = 10

/obj/item/egoshard/bad
	name = "red egoshard"
	desc = "A small egoshard."
	tier = 2
	base_damage = 40
	stat_requirement = 80
	red_bonus = 40 //100 from the base of 20 in red, so 120
	white_bonus = 20
	black_bonus = 20
	pale_bonus = 20
	custom_price = 750

/obj/item/egoshard/bad/white
	name = "white egoshard"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 0 //100 from the base of 20 in red, so 120
	white_bonus = 60
	black_bonus = 20
	pale_bonus = 20
	custom_price = 750

/obj/item/egoshard/bad/black
	name = "black egoshard"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = 0 //100 from the base of 20 in red, so 120
	white_bonus = 20
	black_bonus = 60
	pale_bonus = 20
	custom_price = 750

/obj/item/egoshard/good
	name = "red egoshard"
	desc = "A decently sized egoshard."
	tier = 3
	base_damage = 60
	stat_requirement = 100
	red_bonus = 50 //160 from the base of 20 in red, so 180
	white_bonus = 30
	black_bonus = 40
	pale_bonus = 40
	custom_price = 2000

/obj/item/egoshard/good/white
	name = "white egoshard"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 20 //160 from the base of 20 in red, so 180
	white_bonus = 70
	black_bonus = 30
	pale_bonus = 40
	custom_price = 2000

/obj/item/egoshard/good/black
	name = "black egoshard"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = 20 //160 from the base of 20 in red, so 180
	white_bonus = 40
	black_bonus = 70
	pale_bonus = 30
	custom_price = 2000

/obj/item/egoshard/good/pale
	name = "pale egoshard"
	icon_state = "egoshard_p"
	damage_type = PALE_DAMAGE
	base_damage = 45
	red_bonus = 20 //160 from the base of 20 in red, so 180
	white_bonus = 30
	black_bonus = 40
	pale_bonus = 70
	custom_price = 2000

/obj/item/egoshard/great
	name = "flawless red egoshard"
	desc = "A pretty egoshard."
	tier = 4
	base_damage = 80
	stat_requirement = 120
	red_bonus = 60 //220 from the base of 20 in red, so 240
	white_bonus = 60
	black_bonus = 40
	pale_bonus = 60
	custom_price = 4000

/obj/item/egoshard/great/white
	name = "flawless white egoshard"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 20 //220 from the base of 20 in red, so 240
	white_bonus = 80
	black_bonus = 60
	pale_bonus = 60
	custom_price = 4000

/obj/item/egoshard/great/black
	name = "flawless black egoshard"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = 20 //220 from the base of 20 in red, so 240
	white_bonus = 60
	black_bonus = 80
	pale_bonus = 60
	custom_price = 4000

/obj/item/egoshard/great/pale
	name = "flawless pale egoshard"
	icon_state = "egoshard_p"
	damage_type = PALE_DAMAGE
	base_damage = 60
	red_bonus = 20 //220 from the base of 20 in red, so 240
	white_bonus = 60
	black_bonus = 60
	pale_bonus = 80
	custom_price = 4000

//These exist, but I'm not sure where I would put ALEPH++ tier egoshards in terms of loot
/obj/item/egoshard/excellent
	name = "perfect red egoshard"
	desc = "An expensive-looking egoshard."
	tier = 5
	base_damage = 100
	stat_requirement = 140
	red_bonus = 60 //280 from the base of 20 in red, so 300
	white_bonus = 70
	black_bonus = 70
	pale_bonus = 80

/obj/item/egoshard/excellent/white
	name = "perfect white egoshard"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 50 //280 from the base of 20 in red, so 300
	white_bonus = 80
	black_bonus = 70
	pale_bonus = 80

/obj/item/egoshard/excellent/black
	name = "perfect black egoshard"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = 60 //280 from the base of 20 in red, so 300
	white_bonus = 70
	black_bonus = 80
	pale_bonus = 70

/obj/item/egoshard/excellent/pale
	name = "perfect pale egoshard"
	icon_state = "egoshard_p"
	damage_type = PALE_DAMAGE
	base_damage = 80
	red_bonus = 50 //280 from the base of 20 in red, so 300
	white_bonus = 80
	black_bonus = 70
	pale_bonus = 80
