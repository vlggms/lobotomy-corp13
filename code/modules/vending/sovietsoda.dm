/obj/machinery/vending/sovietsoda
	name = "\improper BODA"
	desc = "Old vending machine sometimes found in the backstreets, not tied to any corporation."
	icon_state = "sovietsoda"
	light_mask = "soviet-light-mask"
	product_ads = "As long as you live, the heart of this army can never be broken.;Have you fulfilled your nutrition quota today?;URA!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/reagent_containers/food/drinks/drinkingglass/filled/soda = 30)
	contraband = list(/obj/item/reagent_containers/food/drinks/drinkingglass/filled/cola = 20)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/sovietsoda
	default_price = 1
	extra_price = PAYCHECK_ASSISTANT //One credit for every state of FREEDOM
	payment_department = NO_FREEBIES
	light_color = COLOR_PALE_ORANGE

/obj/item/vending_refill/sovietsoda
	machine_name = "BODA"
	icon_state = "refill_cola"
