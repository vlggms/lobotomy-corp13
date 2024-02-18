/obj/structure/pe_sales
	name = "PE Power Generation"
	desc = "A machine used to send refined PE to the respective company"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machinelcb"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/crate = /obj/structure/lootcrate
	var/ahn_amount = 200 	//gives you a random amount of ahn between this number and 1/4th this number
	var/power_timer = 120 	//How long does the box last for? You get 1 point every second
	var/crate_timer = 180	//How much time until a crate?
	var/crates_per_box		//Just used to calculate examine text
	var/our_corporation		// Whatever Representative we may be linked to

	var/generating
	var/icon_full = "machinelcb_full"

/obj/structure/pe_sales/Initialize()
	. = ..()
	crates_per_box = crate_timer/power_timer
	GLOB.lobotomy_devices += src

/obj/structure/pe_sales/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

/obj/structure/pe_sales/examine(mob/user)
	. = ..()
	. += "The number of crates required to recieve payment is [crates_per_box]"

/obj/structure/pe_sales/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rawpe) && !generating)
		to_chat(user, span_notice("You need to refine this first!."))

	else if(istype(I, /obj/item/refinedpe) && !generating)
		generating = TRUE
		to_chat(user, span_notice("You load PE into the machine."))
		qdel(I)
		counter()
		add_overlay("full")
	else if(generating)
		to_chat(user, span_notice("This is already sending power!"))

/obj/structure/pe_sales/proc/counter()
	power_timer--
	crate_timer--

	//Box is done
	if(power_timer <= 0)
		power_timer = initial(power_timer)
		generating = FALSE
		visible_message(span_notice("Payment has arrived from [src]"))
		cut_overlays()
		var/obj/item/holochip/C = new (get_turf(src))
		C.credits = rand(ahn_amount/4,ahn_amount)
		SSlobotomy_corp.AdjustGoalBoxes(100) // 50 PE for 100 PE, not including the cost of filters. This eventually gets us positive in spendable PE, once we reach goal...
		var/found_rep = FALSE
		if(our_corporation) // Don't bother trying to loop if we don't have one set.
			for(var/obj/structure/representative_console/rep_console in GLOB.lobotomy_devices)
				if(rep_console.our_corporation != our_corporation)
					continue
				rep_console.AdjustPoints(1)
				playsound(rep_console, 'sound/machines/terminal_success.ogg', 20, 1)
				found_rep = TRUE
		if(!found_rep) // No rep? Bit of a refund, but not as valuable as the rep.
			SSlobotomy_corp.AdjustAvailableBoxes(25)

	//gacha time
	if(crate_timer  <= 0)
		crate_timer = initial(crate_timer)
		new crate(get_turf(src))

	if(generating == TRUE)
		addtimer(CALLBACK(src, PROC_REF(counter)), 1 SECONDS)

/obj/structure/pe_sales/l_corp
	name = "Headquarters Power Input"
	desc = "A machine used to send PE to L-Corp headquarters."
	icon_state = "machinelc"
	crate = /obj/structure/lootcrate/l_corp
	power_timer = 60 	//L Corp is where you drain your power
	crate_timer = 60	//And it's super cheap
	our_corporation = "L corp"

/obj/structure/pe_sales/limbus
	name = "Limbus Company Power Input"
	desc = "A machine used to send PE to limbus company."
	icon_state = "machinelcb"
	crate = /obj/structure/lootcrate/limbus
	our_corporation = "P corp" // Extremely questionable P-Corp~

/obj/structure/pe_sales/k_corp
	name = "K-Corp Power Input"
	desc = "A machine used to send PE to K-Corp."
	icon_state = "machinek"
	crate = /obj/structure/lootcrate/k_corp
	crate_timer = 60	//2 per, because you get one bullet per crate
	our_corporation = "K corp"

/obj/structure/pe_sales/r_corp
	name = "R-Corp Power Input"
	desc = "A machine used to send PE to R-Corp."
	icon_state = "machiner"
	crate = /obj/structure/lootcrate/r_corp
	crate_timer = 360	//The most expensive because it's R corp stuff
	our_corporation = "R corp"

/obj/structure/pe_sales/s_corp
	name = "S-Corp Power Input"
	desc = "A machine used to send PE to S-Corp."
	icon_state = "machineshrimp"
	crate = /obj/structure/lootcrate/s_corp

/obj/structure/pe_sales/w_corp
	name = "W-Corp Power Input"
	desc = "A machine used to send PE to W-Corp."
	icon_state = "machinew"
	crate = /obj/structure/lootcrate/w_corp
	power_timer = 60 	//W Corp uses a lot of power
	crate_timer = 120
	our_corporation = "W corp"

/obj/structure/pe_sales/n_corp
	name = "N-Corp Power Input"
	desc = "A machine used to send PE to N-Corp."
	icon_state = "machinen"
	crate = /obj/structure/lootcrate/n_corp
	our_corporation = "N corp"

/obj/structure/pe_sales/leaflet
	name = "Leaflet Workshop Power Input"
	desc = "A machine used to send PE to the leaflet workshop."
	icon_state = "machineleaf"
	crate = /obj/structure/lootcrate/workshopleaf

/obj/structure/pe_sales/allas
	name = "Allas Workshop Power Input"
	desc = "A machine used to send PE to the allas workshop"
	icon_state = "machineallas"
	crate = /obj/structure/lootcrate/workshopallas

/obj/structure/pe_sales/zelkova
	name = "Zelkova Workshop Power Input"
	desc = "A machine used to send PE to the zelkova workshop"
	icon_state = "machinezelkova"
	crate = /obj/structure/lootcrate/workshopzelkova

/obj/structure/pe_sales/rosespanner
	name = "Rosespanner Workshop Power Input"
	desc = "A machine used to send PE to the rosespanner workshop"
	icon_state = "machinerosespanner"
	crate = /obj/structure/lootcrate/workshoprosespanner

/obj/structure/pe_sales/hana
	name = "Hana Assocation Power Input"
	desc = "A machine used to send PE to the hana association"
	icon_state = "machinehana"
	crate = /obj/structure/lootcrate/hana
	power_timer = 180 	//Takes a long fucking time
	crate_timer = 540	//Very expensive stuff. Takes 10 minutes to get 1 box.

/obj/structure/pe_sales/zwei
	name = "Zwei Association Power Input"
	desc = "A machine used to send PE to the zwei association."
	icon_state = "machinezwei"
	crate = /obj/structure/lootcrate/zwei

/obj/structure/pe_sales/shi
	name = "Shi Association Power Input"
	desc = "A machine used to send PE to the shi association."
	icon_state = "machineshi"
	crate = /obj/structure/lootcrate/shi
	crate_timer = 240	//Two boxes per

/obj/structure/pe_sales/liu
	name = "Liu Association Power Input"
	desc = "A machine used to send PE to the liu association."
	icon_state = "machineliu"
	crate = /obj/structure/lootcrate/liu

/obj/structure/pe_sales/seven
	name = "Seven Association Power Input"
	desc = "A machine used to send PE to seven association."
	icon_state = "machineseven"
	crate = /obj/structure/lootcrate/seven
	crate_timer = 240	//Two boxes per

/obj/structure/pe_sales/syndicate
	name = "Syndicate Workshop Power Input"
	desc = "A machine used to send PE to the syndicate workshop"
	icon_state = "machinesyndicate"
	crate = /obj/structure/lootcrate/syndicate
	crate_timer = 360	//The most expensive sales, takes about 3.5 boxes. The worst you'll get is still extremely good
	our_corporation = "P corp" // Extremely questionable P-Corp~

/obj/structure/pe_sales/backstreet
	name = "Backstreets Workshop Power Input"
	desc = "A machine used to send PE to a backstreets workshop."
	icon_state = "machinebackstreets"
	crate = /obj/structure/lootcrate/backstreets
	power_timer = 180 	//Takes a bit
	crate_timer = 180	//And it's super cheap
	our_corporation = "P corp" // Extremely questionable P-Corp~

/obj/structure/pe_sales/jcorp
	name = "J-corp Syndicate Power Input"
	desc = "A machine used to send PE to J-corp's syndicates"
	icon_state = "machinejcorp"
	crate = /obj/structure/lootcrate/jcorp
	power_timer = 180 	//Takes a bit
	crate_timer = 180	//And it's super cheap
