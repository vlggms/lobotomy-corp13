/obj/vehicle/sealed/mecha/combat/tank
	desc = "What did you expect?."
	name = "\improper R Corp tank"
	icon = 'icons/mecha/mecha_96x96.dmi'
	icon_state = "five_stars"
	base_icon_state = "five_stars"
	operation_req_access = list()//ACCESS_CENT_GENERAL
	internals_req_access = list()
	movedelay = 2
	dir_in = 1 //Facing North.
	max_integrity = 1000
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)
	max_temperature = 30000
	force = 40
	mecha_flags = ADDING_ACCESS_POSSIBLE | IS_ENCLOSED | HAS_LIGHTS
	max_buckled_mobs = 4
	pixel_x = -32
	pixel_y = -32

//WEAPONS
/obj/vehicle/sealed/mecha/combat/tank/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/red(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/white(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/black(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/pale(src)
	ME.attach(src)
	max_ammo()

//BIG POWER
/obj/vehicle/sealed/mecha/combat/tank/add_cell(obj/item/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/infinite(src)

/obj/vehicle/sealed/mecha/combat/tank/generate_actions()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_eject)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_internals)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_cycle_equip)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_lights)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_view_stats)
