/**
	*Both Ruina and Lobotomy Corporation have the fairies as something that’s predatory, but they show it in two different ways.
	*In their first appearance, they attempt to eat people if they think that it endangers their food supply, and in their second they are all under the rule of a Fairy queen who eats them to sate her hunger.
	*I wanted to include both these aspects, while also keeping some of the innocence they use to attract agents as prey.
	*/
/datum/adventure_event/festival
	name = "Fairy Festival"
	desc = "YOU SEE FAIRY LIGHTS HOVERING IN THE GROVE"
	require_abno = /mob/living/simple_animal/hostile/abnormality/fairy_festival
	adventure_cords = list(
	"You enter a forest grove, ripe with dew and the scents of spring. <br>\
	Small lights flit between the trees, hiding amongst the greenery as they observe you.<br>\
	Slowy they come closer their tiny round forms coming into focus. Beating their small wings, they rush around you investigating this new intruder. <br>\
	Eventually one brave little one approaches you, hugging you it’s plump face grins up at you.<br>\
	After the first, the others follow hovering around you as they poke and prod, seemingly curious about what you are.<br>\
	Amid the commotion, one larger than the rest grabs onto you trying to tug you deeper into the grove.",

	"Following the fairy it brings you deeper and deeper into the forest, as the trees close in around you feel something's eyes.",

	"Ability Challenge",

	"Something shifts in the darkness, looking around you see it rise out of the undergrowth.<br>\
	It's gaunt, it's limbs practically skeletal, but still unmistakably a massive fairy.<br>\
	Its eyes fixate on the thing the fairy brought to it and you can feel its hungering gaze bore into you.<br>\
	Drool slowly drips from its mouth as it stares down at it's next meal.<br>\
	Thinking quickly, you grab the fairy that led you here and a few others presenting them to the beast.<br>\
	It takes them, turning its kin into a pulp in the flash of an eye before swallowing just as quickly.<br>\
	Unsatisfied, its eyes turn back to you, and you present another fairy, then another and another.<br>\
	As it feast you take the chance to sneak away, leaving the grove behind you.",

	"A sound of snapping branches and crunching leaves fills the forest as something rises out of the woods behind you.<br>\
	It looks like the fairies, but near skeletal and far far larger towering over not just them but you.<br>\
	The fairy tugs you forward, and you follow it just one more step.<br>\
	The giant grabs at you, mouth watering at the thought of the delectable meal you'll make.<br>\
	Pain erupts in your limbs as it's teeth rip into you, panicing you tear away running away from the grove.",

	"After a few minutes it stops, letting go of you and disappearing into the woods.<br>\
	The others don’t care, instead continuing to surround you as they find more and more of interest.<br>\
	Eventually either wandering away, or hunkering down around you.<br>\
	With nothing left to find you turn and leave the grove, feeling strangely refreshed though it feels like something’s watching you.",

	"With a smack the fairy turns into a green stain on your hand. The others freeze.<br>\
	Suddenly their gentle airs are gone, their lips peel back showing sharpened teeth.<br>\
	Then they swarm you. Swatting them away, you fight your way out of the grove as they gnaw at you.<br>\
	Eventually they let up, leaving gashes in your body that nothing that small should be able to.",
		)

/datum/adventure_event/festival/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			CHANCE_BUTTON_FORMAT(2, "FOLLOW IT", M)
			BUTTON_FORMAT(3, "RESIST IT", M)
			BUTTON_FORMAT(4, "SQUISH IT", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(PRIDE_STAT), "PRIDE", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustHitPoint(10)
			return
		if(4)
			AdjustHitPoint(-5)
			return
	return ..()
