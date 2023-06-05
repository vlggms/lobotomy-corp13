	//Plushie Gatcha
/obj/item/plushgacha //would of made players also have to find keys to open these but im not that cruel... as of today. - IP
	name = "extraction plush lootbox"
	desc = "Theres a thank you note attached from J corp for your patronage."
	icon = 'icons/obj/storage.dmi'
	icon_state = "brassbox"
	var/rewards = list(
		/obj/item/toy/plush/beeplushie = 50, //higher values are more common
		/obj/item/toy/plush/blank = 45,
		/obj/item/toy/plush/yisang = 25,
		/obj/item/toy/plush/faust = 25,
		/obj/item/toy/plush/don = 25,
		/obj/item/toy/plush/ryoshu = 25,
		/obj/item/toy/plush/meursault = 25,
		/obj/item/toy/plush/honglu = 25,
		/obj/item/toy/plush/heathcliff = 25,
		/obj/item/toy/plush/ishmael = 25,
		/obj/item/toy/plush/rodion = 25,
		/obj/item/toy/plush/sinclair = 25,
		/obj/item/toy/plush/outis = 25,
		/obj/item/toy/plush/gregor = 25,
		/obj/item/toy/plush/dante = 18,
		/obj/item/toy/plush/qoh = 10,
		/obj/item/toy/plush/kog = 10,
		/obj/item/toy/plush/kod = 10,
		/obj/item/toy/plush/sow = 10,
		/obj/item/toy/plush/bigbird = 10,
		/obj/item/toy/plush/rabbit = 5,
		/obj/item/toy/plush/yuri = 5,
		/obj/item/toy/plush/nihil = 4)

/obj/item/plushgacha/attack_self(mob/user)
	var/obj/item/toy/plush/reward = pickweight(rewards)
	to_chat(user, "<span class='notice'>You got a prize!</span>")
	new reward(get_turf(src))
	qdel(src)
