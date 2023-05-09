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

	var/generating
	var/icon_full = "machinelcb_full"

/obj/structure/pe_sales/Initialize()
	. = ..()
	crates_per_box = crate_timer/power_timer

/obj/structure/pe_sales/examine(mob/user)
	. = ..()
	. += "The number of crates required to recieve payment is [crates_per_box]"

/obj/structure/pe_sales/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rawpe) && !generating)
		to_chat(user, "<span class='notice'>You need to refine this first!.</span>")

	else if(istype(I, /obj/item/refinedpe) && !generating)
		generating = TRUE
		to_chat(user, "<span class='notice'>You load PE into the machine.</span>")
		qdel(I)
		counter()
		add_overlay("full")
	else if(generating)
		to_chat(user, "<span class='notice'>This is already sending power!</span>")

/obj/structure/pe_sales/proc/counter()
	power_timer--
	crate_timer--

	//Box is done
	if(power_timer <= 0)
		power_timer = initial(power_timer)
		generating = FALSE
		visible_message("<span class='notice'>Payment has arrived from [src]</span>")
		cut_overlays()
		var/obj/item/holochip/C = new (get_turf(src))
		C.credits = rand(ahn_amount/4,ahn_amount)

	//gacha time
	if(crate_timer  <= 0)
		crate_timer = initial(crate_timer)
		new crate(get_turf(src))

	if(generating == TRUE)
		addtimer(CALLBACK(src, .proc/counter), 1 SECONDS)

/obj/structure/pe_sales/limbus
	name = "Limbus Company Power Input"
	desc = "A machine used to send PE to limbus company."
	icon_state = "machinelcb"
	crate = /obj/structure/lootcrate/limbus

/obj/structure/pe_sales/k_corp
	name = "K-Corp Power Input"
	desc = "A machine used to send PE to K-Corp."
	icon_state = "machinek"
	crate = /obj/structure/lootcrate/k_corp
	crate_timer = 60	//2 per, because you get one bullet per crate

/obj/structure/pe_sales/r_corp
	name = "R-Corp Power Input"
	desc = "A machine used to send PE to R-Corp."
	icon_state = "machiner"
	crate = /obj/structure/lootcrate/r_corp
	crate_timer = 360	//The most expensive because it's R corp stuff

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

/obj/structure/pe_sales/n_corp
	name = "N-Corp Power Input"
	desc = "A machine used to send PE to N-Corp."
	icon_state = "machinen"
	crate = /obj/structure/lootcrate/n_corp
	crate_timer = 120

/obj/structure/pe_sales/leaflet
	name = "Leaflet Workshop Power Input"
	desc = "A machine used to send PE to the leaflet workshop."
	icon_state = "machineleaf"
	crate = /obj/structure/lootcrate/workshopleaf

/obj/structure/pe_sales/zwei
	name = "Zwei Association Power Input"
	desc = "A machine used to send PE to the zwei association."
	icon_state = "machinezwei"
	crate = /obj/structure/lootcrate/zwei
	crate_timer = 240	//Two boxes per

//Not available because Id on't have enough stuff for it
/obj/structure/pe_sales/seven
	name = "Seven Association Power Input"
	desc = "A machine used to send PE to seven association."
	icon_state = "machineseven"
	crate = /obj/structure/lootcrate/seven
	crate_timer = 360	//Two boxes per
