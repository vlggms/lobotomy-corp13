	//Plushie Gatcha
/obj/item/plushgacha //would of made players also have to find keys to open these but im not that cruel... as of today. - IP
	name = "extraction plush lootbox"
	desc = "Theres a thank you note attached from J corp for your patronage."
	icon = 'icons/obj/storage.dmi'
	icon_state = "brassbox"
	var/rewards = list(
		/obj/item/toy/plush/beeplushie = 50, //higher values are more common
		/obj/item/toy/plush/blank = 45,
		/obj/item/toy/plush/fighter/yisang = 25,
		/obj/item/toy/plush/fighter/faust = 25,
		/obj/item/toy/plush/fighter/don = 25,
		/obj/item/toy/plush/fighter/ryoshu = 25,
		/obj/item/toy/plush/fighter/meursault = 25,
		/obj/item/toy/plush/fighter/honglu = 25,
		/obj/item/toy/plush/fighter/heathcliff = 25,
		/obj/item/toy/plush/fighter/ishmael = 25,
		/obj/item/toy/plush/fighter/rodion = 25,
		/obj/item/toy/plush/fighter/sinclair = 25,
		/obj/item/toy/plush/fighter/outis = 25,
		/obj/item/toy/plush/fighter/gregor = 25,
		/obj/item/toy/plush/fighter/dante = 18,
		/obj/item/toy/plush/fighter/magical_girl/qoh = 10,
		/obj/item/toy/plush/fighter/magical_girl/kog = 10,
		/obj/item/toy/plush/fighter/magical_girl/kod = 10,
		/obj/item/toy/plush/fighter/magical_girl/sow = 10,
		/obj/item/toy/plush/fighter/bigbird = 10,
		/obj/item/toy/plush/rabbit = 5,
		/obj/item/toy/plush/yuri = 5,
		/obj/item/toy/plush/fighter/nihil = 4)

/obj/item/plushgacha/attack_self(mob/user)
	var/obj/item/toy/plush/reward = pickweight(rewards)
	to_chat(user, "<span class='notice'>You got a prize!</span>")
	new reward(get_turf(src))
	qdel(src)
