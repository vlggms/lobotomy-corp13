/obj/machinery/vending/lobotomyuniform
	name = "\improper Uniform Vendor"
	desc = "A vending machine for facility uniforms."
	icon_state = "generic" //Placeholder
	icon_deny = null
	req_access = null //Shouldn't need access on lc13, can be changed
	vend_reply = "Uniform vended."
	products = list(/obj/item/clothing/under/suit/lobotomy = 4,
					/obj/item/clothing/under/suit/lobotomy/control = 4,
					/obj/item/clothing/under/suit/lobotomy/information = 4,
					/obj/item/clothing/under/suit/lobotomy/training = 4,
					/obj/item/clothing/under/suit/lobotomy/safety = 4,
					/obj/item/clothing/under/suit/lobotomy/welfare = 4,
					/obj/item/clothing/under/suit/lobotomy/discipline = 4,
					/obj/item/clothing/under/suit/lobotomy/command = 4,
					/obj/item/clothing/under/suit/lobotomy/extraction = 4,
					/obj/item/clothing/under/suit/lobotomy/records = 4,
					/obj/item/clothing/under/suit/lobotomy/architecture = 4)

	refill_canister = null //Refill it with the clothing of the dead.
	default_price = PAYCHECK_RESOURCE //Makes vended items cost 0 ahn.
	extra_price = PAYCHECK_RESOURCE //In case anything is considered a valuable item, it will also cost 0 ahn.
	payment_department = ACCOUNT_SRV //Placeholder. Has no impact on gameplay since everything is 0.

/obj/machinery/vending/lobotomyuniform/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)
