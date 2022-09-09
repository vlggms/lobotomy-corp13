/obj/machinery/vending/lobotomyheadset
	name = "\improper Communications Vendor"
	desc = "A vending machine for facility headsets, and encryption keys."
	icon_state = "generic" //Placeholder
	icon_deny = null
	req_access = null //Shouldn't need access on lc13, can be changed
	vend_reply = "Uniform vended."
	products = list(/obj/item/encryptionkey/headset_control = 4,
					/obj/item/encryptionkey/headset_information = 4,
					/obj/item/encryptionkey/headset_safety = 4,
					/obj/item/encryptionkey/headset_training = 4,
					/obj/item/encryptionkey/headset_command = 4,
					/obj/item/encryptionkey/headset_welfare = 4,
					/obj/item/encryptionkey/headset_discipline = 4)
					// /obj/item/encryptionkey/headset_extraction = 4, //Placeholder for when they're added.
					// /obj/item/encryptionkey/headset_records = 4) //Same as above.

	refill_canister = null //Refill it with the clothing of the dead.
	default_price = PAYCHECK_RESOURCE  //Makes vended items cost 0 ahn.
	extra_price = PAYCHECK_RESOURCE //In case anything is considered a valuable item, it will also cost 0 ahn.
	payment_department = ACCOUNT_SRV //Placeholder. Has no impact on gameplay since everything is 0.

/obj/machinery/vending/lobotomyheadset/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)
