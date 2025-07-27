/obj/machinery/vending/lobotomyuniform
	name = "\improper Uniform Vendor"
	desc = "A vending machine for facility uniforms."
	icon_state = "generic" //Placeholder
	icon_deny = null
	req_access = null //Shouldn't need access on lc13, can be changed
	vend_reply = "Uniform vended."
	products = list(/obj/item/clothing/under/suit/lobotomy = 20,
					/obj/item/clothing/under/suit/lobotomy/control = 20,
					/obj/item/clothing/under/suit/lobotomy/information = 20,
					/obj/item/clothing/under/suit/lobotomy/training = 20,
					/obj/item/clothing/under/suit/lobotomy/safety = 20,
					/obj/item/clothing/under/suit/lobotomy/welfare = 20,
					/obj/item/clothing/under/suit/lobotomy/discipline = 20,
					/obj/item/clothing/under/suit/lobotomy/discipline/alternative = 20,
					/obj/item/clothing/under/suit/lobotomy/command = 20,
					/obj/item/clothing/under/suit/lobotomy/extraction = 20,
					/obj/item/clothing/under/suit/lobotomy/records = 20)

	refill_canister = null //Refill it with the clothing of the dead.
	default_price = PAYCHECK_RESOURCE //Makes vended items cost 0 ahn.
	extra_price = PAYCHECK_RESOURCE //In case anything is considered a valuable item, it will also cost 0 ahn.
	payment_department = ACCOUNT_SRV //Placeholder. Has no impact on gameplay since everything is 0.

/obj/machinery/vending/lobotomyuniform/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)
