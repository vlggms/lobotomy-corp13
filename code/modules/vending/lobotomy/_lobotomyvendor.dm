/obj/machinery/vending/lobotomy
	name = "\improper Debug Vendor"
	desc = "A vending machine for testing. Report this to an admin."
	icon_state = "generic" //Placeholder
	icon_deny = null
	req_access = null //Shouldn't need access on lc13, can be changed
	vend_reply = "ERROR."
	products = list(/obj/item/food/bread/bongbread = 20,
	)

	refill_canister = null //Refill it with the clothing of the dead.
	payment_department = ACCOUNT_SRV //Placeholder. Has no impact on gameplay since everything is 0.

/obj/machinery/vending/lobotomy/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)
