/obj/vehicle/sealed/mecha/combat/rhino
	desc = "A combat exosuit utilized by the R Corp. Originally developed for the Rhino team, it was loaned to the Rabbit team for extra ‘cleaning’."
	name = "\improper Rhinoceros Heavy Unit"
	icon_state = "durand"
	base_icon_state = "durand"
	operation_req_access = list(ACCESS_CENT_GENERAL)
	internals_req_access = list(ACCESS_CENT_GENERAL)
	movedelay = 3
	dir_in = 1 //Facing North.
	max_integrity = 1000
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


//Gatling Rhino
/obj/vehicle/sealed/mecha/combat/rhinosupport
	name = "\improper Rhinoceros Support Unit"
	desc = "A combat exosuit utilized by the R Corp. Originally developed for the Rhino team, it was loaned to the Rabbit team for extra ‘cleaning’."
	icon_state = "durand"
	base_icon_state = "durand"
	operation_req_access = list(ACCESS_CENT_GENERAL)
	internals_req_access = list(ACCESS_CENT_GENERAL)
	movedelay = 3
	dir_in = 1 //Facing North.
	max_integrity = 1000
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)
	max_temperature = 30000
	force = 40
	wreckage = /obj/structure/mecha_wreckage/durand

//WEAPONS
/obj/vehicle/sealed/mecha/combat/rhinosupport/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gatling(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gatling/white(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gatling/black(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gatling/pale(src)
	ME.attach(src)
	max_ammo()

/obj/vehicle/sealed/mecha/combat/rhinosupport/add_cell(obj/item/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/infinite(src)


//Shotgun Rhino
/obj/vehicle/sealed/mecha/combat/rhinoshotgun
	name = "\improper Rhinoceros Pointman Unit"
	desc = "A combat exosuit utilized by the R Corp. Originally developed for the Rhino team, it was loaned to the Rabbit team for extra ‘cleaning’."
	icon_state = "durand"
	base_icon_state = "durand"
	operation_req_access = list(ACCESS_CENT_GENERAL)
	internals_req_access = list(ACCESS_CENT_GENERAL)
	movedelay = 3
	dir_in = 1 //Facing North.
	max_integrity = 1000
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)
	max_temperature = 30000
	force = 40
	wreckage = /obj/structure/mecha_wreckage/durand

//WEAPONS
/obj/vehicle/sealed/mecha/combat/rhinoshotgun/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/shotgun(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/shotgun/white(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/shotgun/black(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/shotgun/pale(src)
	ME.attach(src)
	max_ammo()

/obj/vehicle/sealed/mecha/combat/rhinoshotgun/add_cell(obj/item/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/infinite(src)

//Rifle Rhino
/obj/vehicle/sealed/mecha/combat/rhinorifle
	name = "\improper Rhinoceros Light Unit"
	desc = "A combat exosuit utilized by the R Corp. Originally developed for the Rhino team, it was loaned to the Rabbit team for extra ‘cleaning’."
	icon_state = "durand"
	base_icon_state = "durand"
	operation_req_access = list(ACCESS_CENT_GENERAL)
	internals_req_access = list(ACCESS_CENT_GENERAL)
	movedelay = 2
	dir_in = 1 //Facing North.
	max_integrity = 1000
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)
	max_temperature = 30000
	force = 40
	wreckage = /obj/structure/mecha_wreckage/durand

//WEAPONS
/obj/vehicle/sealed/mecha/combat/rhinorifle/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rifle(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rifle/white(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rifle/black(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rifle/pale(src)
	ME.attach(src)
	max_ammo()

/obj/vehicle/sealed/mecha/combat/rhinorifle/add_cell(obj/item/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/infinite(src)


//The Melee rhino
/obj/vehicle/sealed/mecha/combat/rhinomelee
	desc = "A combat exosuit utilized by the R Corp. Originally developed for the Rhino team, it was loaned to the Rabbit team for extra ‘cleaning’."
	name = "\improper Rhinoceros Hammer Unit"
	icon_state = "rhino"
	base_icon_state = "rhino"
	operation_req_access = list(ACCESS_CENT_THUNDER)
	internals_req_access = list(ACCESS_CENT_THUNDER)
	movedelay = 3
	dir_in = 1 //Facing North.
	max_integrity = 1500
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)
	max_temperature = 30000
	force = 60
	wreckage = /obj/structure/mecha_wreckage/durand

//WEAPONS
/obj/vehicle/sealed/mecha/combat/rhinomelee/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/hammer(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/hammer/rhinoblade(src)
	ME.attach(src)
	max_ammo()

//BIG POWER
/obj/vehicle/sealed/mecha/combat/rhinomelee/add_cell(obj/item/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/infinite(src)

