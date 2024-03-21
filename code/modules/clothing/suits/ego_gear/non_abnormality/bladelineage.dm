
/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_salsu
	name = "blade lineage salsu robe"
	desc = "A light robe worn by blade lineage salsus. Increases your running speed by 25%, allowing for quick strikes."
	icon_state = "bladelineagesalsu"
	slowdown = -0.25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 55,
							PRUDENCE_ATTRIBUTE = 55,
							TEMPERANCE_ATTRIBUTE = 55,
							JUSTICE_ATTRIBUTE = 55
							)

/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_cutthroat
	name = "blade lineage cutthroat robe"
	desc = "A light robe worn by blade lineage cutthroats. Increases your running speed by 40%, allowing for quick strikes."
	icon_state = "bladelineage_cuttthroat"
	slowdown = -0.40
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 70,
							PRUDENCE_ATTRIBUTE = 70,
							TEMPERANCE_ATTRIBUTE = 70,
							JUSTICE_ATTRIBUTE = 70
							)


/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin
	name = "blade lineage admin robe"
	desc = "A light robe worn by blade lineage admins. Increases your running speed by 60%, allowing for quick strikes."
	icon_state = "bladelineageadmin"
	slowdown = -0.6
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

//For the PVE(inputs)
/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_salsu/gacha
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 10)

/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_cutthroat/gacha
	desc = "A light robe worn by blade lineage cutthroats. Increases your running speed by 50%, allowing for quick strikes."
	slowdown = -0.5
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)

/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin/gacha
	desc = "A light robe worn by blade lineage admins. Increases your running speed by 75%, allowing for quick strikes."
	slowdown = -0.75
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 30)
