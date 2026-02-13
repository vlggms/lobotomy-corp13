//Armor vest
/obj/item/clothing/suit/armor/vest/alt
	desc = "A cheap plastic vest that provides practically no protection against abnormalities."
	icon_state = "armor"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest
	name = "l-corp armor vest"
	desc = "Special armor issued by L-Corp to those who cannot utilize E.G.O."
	icon_state = "armorvest"
	icon = 'icons/obj/clothing/ego_gear/lcorp.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lcorp.dmi'
	flags_inv = NONE
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20,
							PRUDENCE_ATTRIBUTE = 20,
							TEMPERANCE_ATTRIBUTE = 20,
							JUSTICE_ATTRIBUTE = 20
							)
	is_city_gear = FALSE
	custom_price = 100
	var/installed_shard
	var/equipped

/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest/examine(mob/user)
	. = ..()
	if(!installed_shard)
		. += span_warning("This armor can be enhanced with an egoshard.")
	else
		. += span_nicegreen("It has a [installed_shard] installed.")

/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("You need to put down [src] before attempting this!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src] already has an egoshard installed!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("The requirements to equip [src] have increased!"))
	armor = armor.modifyRating(red = egoshard.red_bonus, white = egoshard.white_bonus, black = egoshard.black_bonus, pale = egoshard.pale_bonus)
	to_chat(user, span_nicegreen("[src] has been successfully improved!"))
	icon_state = "armorvest_[egoshard.damage_type]"

/*Officer coats.
Scales through out the round currently but should probably get their stats boosted under a different system.
*/
/obj/item/clothing/suit/armor/ego_gear/officer
	name = "patchwork coat"
	icon = 'icons/obj/clothing/ego_gear/lcorp.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lcorp.dmi'
	desc = "A poorly made patchwork coat made from a bunch of spare cloth, dyed black. Worn by the Extraction Officer"
	icon_state = "extraction"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 10)//armor is set later 80-240
	equip_slowdown = 0
	flags_inv = null
	var/allowed_role = "Extraction Officer"//we dont want other Roles to wear this!
	var/current_holder = null
	var/current_level = 1
	var/max_level = 5//240 total
	var/armor_increase = 10
	var/inited = FALSE

/obj/item/clothing/suit/armor/ego_gear/officer/examine(mob/user)
	. = ..()
	. += span_notice("This armor can only be worn by the [allowed_role]. This armor also increase in power the more ordeals are defeated.")

/obj/item/clothing/suit/armor/ego_gear/officer/SpecialEgoCheck(mob/living/carbon/human/H)
	if(!H.mind)
		return FALSE
	if(!H.mind.assigned_role == allowed_role)
		return FALSE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/officer/CanUseEgo(mob/living/carbon/human/H)
	if(!inited)//Utter nonsense but hey it makes it so it renders in the role prefs screen.
		return TRUE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/officer/Initialize()
	. = ..()
	if(SSlobotomy_corp.next_ordeal)
		current_level = min(max_level, ceil(1 + SSlobotomy_corp.ordeal_stats/5))
	boost_stats(current_level)
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(update_stats))

/obj/item/clothing/suit/armor/ego_gear/officer/proc/update_stats()
	if(current_level >= max_level)
		return
	current_level++
	if(current_holder)
		to_chat(current_holder, span_nicegreen("[src]'s protection has been increased!"))
	boost_stats(1)

/obj/item/clothing/suit/armor/ego_gear/officer/proc/boost_stats(amount)
	var/increased_stats = amount * armor_increase
	src.armor = src.armor.modifyRating(red = increased_stats, white = increased_stats, black = increased_stats, pale = increased_stats)

/obj/item/clothing/suit/armor/ego_gear/officer/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	inited = TRUE
	current_holder = user

/obj/item/clothing/suit/armor/ego_gear/officer/dropped(mob/user)
	. = ..()
	inited = TRUE
	current_holder = null

/obj/item/clothing/suit/armor/arbiter
	name = "arbiter's armored coat"
	desc = "A coat made out of quality cloth, providing immense protection against most damage sources. It is quite heavy."
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 90, BLACK_DAMAGE = 90, PALE_DAMAGE = 90)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	w_class = WEIGHT_CLASS_BULKY
	slowdown = 1.5
	allowed = list(/obj/item/gun, /obj/item/ego_weapon, /obj/item/melee)

/obj/item/clothing/suit/armor/ego_gear/officer/records
	name = "old coat"
	desc = "A poorly made patchwork coat made from a bunch of spare cloth, dyed grey. Worn by the Records Officer"
	icon_state = "records"
	allowed_role = "Records Officer"

/obj/item/clothing/suit/armor/ego_gear/officer/training
	name = "worn coat"
	desc = "A coat that has been use for a very long time, by a very experienced officer. This one is orange with an intricate copper pattern on it. Worn by the Training Officer"
	icon_state = "training"
	allowed_role = "Training Officer"

/obj/item/clothing/suit/armor/control
	name = "ragged coat"
	icon = 'icons/obj/clothing/suits.dmi'
	worn_icon = 'icons/mob/clothing/suit.dmi'
	desc = "A coat that has been use for a very long time, by an officer that is very observant. This one is brown, from both dye and dirt. Worn by the control officer"
	icon_state = "coatcargo_t"		//Temporary sprite
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)

//Disc officer
/obj/item/clothing/suit/armor/ego_gear/officer/discipline
	name = "armored coat"
	desc = "An armored black and red coat made to be worn when suppressing threats. Worn by the Disciplinary Officer"
	icon = 'icons/obj/clothing/ego_gear/suits.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/suit.dmi'
	icon_state = "disc_officer"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 10, BLACK_DAMAGE = 20, PALE_DAMAGE = 10)//100-260
	allowed_role = "Disciplinary Officer"

//This is tutorial armor
/obj/item/clothing/suit/armor/ego_gear/rookie
	name = "rookie"
	desc = "This armor is strong to red, check it's defenses to see!"
	icon_state = "rookie"
	icon = 'icons/obj/clothing/ego_gear/lcorp.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lcorp.dmi'
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = -40, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/fledgling
	name = "fledgling"
	desc = "This armor is strong to white, check it's defenses to see!"
	icon_state = "fledgling"
	icon = 'icons/obj/clothing/ego_gear/lcorp.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lcorp.dmi'
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 40, BLACK_DAMAGE = -40, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/apprentice
	name = "apprentice"
	desc = "This armor is strong to black, check it's defenses to see!"
	icon_state = "apprentice"
	icon = 'icons/obj/clothing/ego_gear/lcorp.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lcorp.dmi'
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 40, PALE_DAMAGE = -40)

/obj/item/clothing/suit/armor/ego_gear/freshman
	name = "freshman"
	desc = "This armor is strong to pale, check it's defenses to see!"
	icon_state = "freshman"
	icon = 'icons/obj/clothing/ego_gear/lcorp.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lcorp.dmi'
	armor = list(RED_DAMAGE = -40, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 40)
