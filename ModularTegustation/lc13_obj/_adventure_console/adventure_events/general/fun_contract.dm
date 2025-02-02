/**
	*This on just started as a joke of an event that straight up killed you.
	*/
/datum/adventure_event/fun_contract
	name = "Sign away your life!"
	desc = "YOU SEE A PAPER AND PEN"
	adventure_cords = list(
	"\"Hello.\" A light turns on, illuminating a desk with only a pen and paper on it.<br>\
	\"I'm here to offer you a deal.\"<br>\
	The paper reads, sign here to die.<br>\
	\"Please,\" The voice says as a line begins to appear on the paper. \"Sign here.\"",

	"You sign the paper, and everything goes black.",

	"What sort of idiot would sign?",
	)

/datum/adventure_event/fun_contract/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "SIGN", M)
			BUTTON_FORMAT(3, "DON'T SIGN", M)
			return
		if(2)
			AdjustHitPoint(-100)
	return ..()
