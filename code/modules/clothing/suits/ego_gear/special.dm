// Special Armor doesn't have any armors or attribute requirements, maybe we should put twi and paradise there, idk idk

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

//Nihil Event rewards
/obj/item/clothing/suit/armor/ego_gear/despair_nihil
	name = "meaningless despair"
	desc = "As with sorrow, perhaps sharing the burden will blunt the edge."
	icon_state = "despair_nihil"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 80, BLACK_DAMAGE = 50, PALE_DAMAGE = 90) // 280
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/hatred_nihil
	name = "pointless hate"
	desc = "She vowed to love everything in the world, but all that was left was a collapsing heart."
	icon_state = "hate"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 60, BLACK_DAMAGE = 90, PALE_DAMAGE = 60) // 280
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/blind_rage_nihil
	name = "shameless wrath"
	desc = "The Servant was betrayed after abandoning her principles and ingenuously trusting someone with her whole heart."
	icon_state = "wrath"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 20, BLACK_DAMAGE = 90, PALE_DAMAGE = 80) // 280
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/goldrush_nihil
	name = "worthless greed"
	desc = "Now, only visceral greed remains."
	icon_state = "greed"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 60, BLACK_DAMAGE = 70, PALE_DAMAGE = 60) // 280
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
