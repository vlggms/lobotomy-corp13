/datum/supply_pack/emergency/freedom_fighter
	name = "Freedom Fighter Supplies"
	desc = "*!&@#GREETINGS SOLDIER! YOU HAD ENOUGH OF THIS CAPITALIST BULLSHIT? WANT TO TAKE IT ALL INTO YOUR OWN HANDS? FEAR NOT, WE GOT YOU COVERED. THIS LITTLE CRATE HAS EVERYTHING A TRUE GUERRILLA FIGHTER NEEDS!"
	hidden = TRUE // Need to emag the supply console to be able to buy it.
	cost = CARGO_CRATE_VALUE * 30 // Loads of cash
	contains = list(/obj/item/gun/ballistic/automatic/aks74u,
					/obj/item/ammo_box/magazine/ak47/aks74u,
					/obj/item/ammo_box/magazine/ak47/aks74u,
					/obj/item/clothing/mask/bandana/black,
					/obj/item/clothing/suit/armor/vest/alt,
					/obj/item/clothing/under/mercenary/camo,
					/obj/item/clothing/shoes/jackboots)

/datum/supply_pack/emergency/freedom_fighter/generate(atom/A, datum/bank_account/paying_account)
	if(prob(50))
		contains += /obj/item/clothing/gloves/combat
	if(prob(50))
		contains += /obj/item/ammo_box/magazine/ak47/aks74u
	. = ..()
