/obj/item/clothing/head/beret/fishing_hat
	name = "unhinged fishing hat"
	desc = "On the white part of this hat is the words: <span class='boldwarning'>Women fear me, fish fear me, men turn their eyes away from me as i walk, no beast dare make a sound in my presence, i am alone on this barren earth...</span> at the end of this manifesto is the picture of a very silly salmon."
	icon_state = "fishing_hat"
	icon = 'ModularTegustation/fishing/icons/clothes_items.dmi'
	worn_icon = 'ModularTegustation/fishing/icons/clothes_worn.dmi'
	max_integrity = 1000000
	// how many hats do we have in ourselfes?
	var/amount = 1
	// how much should we scale the hat?
	var/scale_multiplier = 1.1
	// should we scale it at all?
	var/scaling = TRUE

/obj/item/clothing/head/beret/fishing_hat/examine(mob/user)
	. = ..()
	if(amount > 1)
		. += "<span class='boldwarning'>My god... it seems someone has stacked together [amount] of these hats!</span>"
	switch(amount)
		if(3 to 9)
			. += "<span class='warning'>You feel a strange aura coming from the hats...</span>"
		if(10 to 15)
			. += "<span class='warning'>As the hat stack grows taller, you feel dreadfull.</span>"
		if(15 to 19)
			. += "<span class='warning'>What is a wave without the ocean? a beginning without an end?</span>"
			. += "<span class='notice'>You feel as if you are approaching the limit.</span>"
		if(20)
			. += "<span class='warning'>We are different... yet we go together.</span>"

/obj/item/clothing/head/beret/fishing_hat/attackby(obj/item/attacking_item, mob/living/user)
	. = ..()
	if(istype(attacking_item, /obj/item/clothing/head/beret/fishing_hat))
		var/obj/item/clothing/head/beret/fishing_hat/attacking_hat = attacking_item
		amount += attacking_hat.amount
		if(amount > 20)
			amount = 20
			to_chat(user, "<span class='boldwarning'>The hat refuses to become any larger, yet accepts your offering anyway.</span>")
			qdel(attacking_hat)
			return
		else
			to_chat(user, "<span class='boldwarning'>You put the hat in your hand on the second hat, you feel their powers combining and forming something greater...</span>")
		if(scaling)
			scale_multiplier = (attacking_hat.scale_multiplier)
			transform = transform.Scale(scale_multiplier, scale_multiplier)
		qdel(attacking_hat)
