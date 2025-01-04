/datum/adventure_event/wcca
	name = "Pain Machine"
	desc = "YOUR VOICE SCREAMING"
	require_abno = /mob/living/simple_animal/hostile/abnormality/we_can_change_anything
	adventure_cords = list(
		"In front of you is a machine with space for one.",

		"As you enter the machine, the door closes behind you.<br>\
		You hear a dinging noise as a spike plunges into your back,<br>\
		and something clinks to the ground outside of the machine.",

		"The machine spits you out.<br>\
		You call back to the clinking outside of the machine, seeing<br>\
		a pile of coins lie outside for you to take."
		)
	var/machine_coins = 0

/datum/adventure_event/wcca/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "ENTER THE MACHINE", M)
			BUTTON_FORMAT(2, "ENTER THE MACHINE", M)
			BUTTON_FORMAT(2, "ENTER THE MACHINE", M)
			return
		if(2)
			BUTTON_FORMAT(2, "ENJOY THE MACHINE", M)
			BUTTON_FORMAT(2, "ENJOY THE MACHINE", M)
			BUTTON_FORMAT(3, "LEAVE THE MACHINE", M)
			BUTTON_FORMAT(2, "ENJOY THE MACHINE", M)
			BUTTON_FORMAT(2, "ENJOY THE MACHINE", M)
			AdjustHitPoint(-10)
			machine_coins++
			return
		if(3)
			AdjustCurrency(machine_coins)

	return ..()
