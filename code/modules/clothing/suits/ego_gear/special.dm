// Special Armor doesn't have any armors or attribute requirements, maybe we should put twi and paradise there, idk idk

/obj/item/clothing/suit/armor/ego_gear/rabbit
	name = "\improper rabbit team command suit"
	desc = "An armored combat suit worn by R-Corporation mercenaries in the field, interestingly"
	icon_state = "rabbit"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 50)

/obj/item/clothing/suit/armor/ego_gear/rabbit/grunts
	name = "\improper rabbit team suit"
	desc = "An armored combat suit worn by R-Corporation mercenaries in the field"
	icon_state = "rabbit_grunt"

//This is tutorial armor
/obj/item/clothing/suit/armor/ego_gear/rookie
	name = "rookie"
	desc = "This armor is strong to red, check it's defenses to see!"
	icon_state = "rookie"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = -40, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/fledgling
	name = "fledgling"
	desc = "This armor is strong to white, check it's defenses to see!"
	icon_state = "fledgling"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 40, BLACK_DAMAGE = -40, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/apprentice
	name = "apprentice"
	desc = "This armor is strong to black, check it's defenses to see!"
	icon_state = "apprentice"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 40, PALE_DAMAGE = -40)

/obj/item/clothing/suit/armor/ego_gear/freshman
	name = "freshman"
	desc = "This armor is strong to pale, check it's defenses to see!"
	icon_state = "freshman"
	armor = list(RED_DAMAGE = -40, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 40)
