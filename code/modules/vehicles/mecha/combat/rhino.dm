/obj/vehicle/sealed/mecha/combat/rhino
	desc = "A combat exosuit utilized by the R Corp. Originally developed for the Rhino team, it was loaned to the Rabbit team for extra ‘cleaning’."
	name = "\improper Rhinoceros Unit"
	icon_state = "durand"
	base_icon_state = "durand"
	operation_req_access = list(ACCESS_CENT_GENERAL)
	internals_req_access = list(ACCESS_CENT_GENERAL)
	movedelay = 3
	dir_in = 1 //Facing North.
	max_integrity = 600		//1000 Effective HP.
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)
	max_temperature = 30000
	force = 40
	wreckage = /obj/structure/mecha_wreckage/durand

//WEAPONS
/obj/vehicle/sealed/mecha/combat/rhino/Initialize()
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
/obj/vehicle/sealed/mecha/combat/rhino/add_cell(obj/item/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/infinite(src)
