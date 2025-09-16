// Special Armor doesn't have any armors or attribute requirements

//General Bee
/obj/item/clothing/suit/armor/ego_gear/aleph/praetorian
	name = "praetorian"
	desc = "The queen's last line of defense."
	icon_state = "praetorian"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 40)	//Armor was made before the abnormality.
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
//Apocalypse Bird
/obj/item/clothing/suit/armor/ego_gear/aleph/twilight
	name = "twilight"
	desc = "The three birds united their efforts to defeat the beast. \
	This could stop countless incidents, but you’ll have to be prepared to step into the Black Forest…"
	icon_state = "twilight"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 60, BLACK_DAMAGE = 80, PALE_DAMAGE = 80) // 300
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)

//Crumbling armor gift
/obj/item/clothing/suit/armor/ego_gear/he/crumbling_armor
	name = "crumbling armor"
	desc = "Looks like a replica of the crumbling armor abnormality. Boasts high defenses to those who are reckless."
	icon_state = "crumbling_armor"
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = -100) // -10
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)

//Nihil Event rewards
/obj/item/clothing/suit/armor/ego_gear/despair_nihil
	name = "meaningless despair"
	desc = "As with sorrow, perhaps sharing the burden will blunt the edge."
	icon_state = "despair_nihil"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 80, BLACK_DAMAGE = 60, PALE_DAMAGE = 80) // 280
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
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 70, BLACK_DAMAGE = 80, PALE_DAMAGE = 60) // 280
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
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 60, BLACK_DAMAGE = 80, PALE_DAMAGE = 80) // 280
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
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 60, BLACK_DAMAGE = 70, PALE_DAMAGE = 70) // 280
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
