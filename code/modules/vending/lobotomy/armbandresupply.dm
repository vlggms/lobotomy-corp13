/obj/machinery/vending/lobotomyarmband
	name = "\improper Armband Vendor"
	desc = "A vending machine for facility armbands."
	icon_state = "generic" //Placeholder
	icon_deny = null
	req_access = null //Shouldn't need access on lc13, can be changed
	vend_reply = "Armband vended."
	products = list(/obj/item/clothing/accessory/armband/lobotomy = 20,
					/obj/item/clothing/accessory/armband/lobotomy/command = 20,
					/obj/item/clothing/accessory/armband/lobotomy/training = 20,
					/obj/item/clothing/accessory/armband/lobotomy/info = 20,
					/obj/item/clothing/accessory/armband/lobotomy/safety = 20,
					/obj/item/clothing/accessory/armband/lobotomy/discipline = 20,
					/obj/item/clothing/accessory/armband/lobotomy/welfare = 20,
					/obj/item/clothing/accessory/armband/lobotomy/records = 20,
					/obj/item/clothing/accessory/armband/lobotomy/extraction = 20)

	refill_canister = null //Refill it with the clothing of the dead.
	default_price = PAYCHECK_RESOURCE //Makes vended items cost 0 ahn.
	extra_price = PAYCHECK_RESOURCE //In case anything is considered a valuable item, it will also cost 0 ahn.
	payment_department = ACCOUNT_SRV //Placeholder. Has no impact on gameplay since everything is 0.

/obj/machinery/vending/lobotomyarmband/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)
