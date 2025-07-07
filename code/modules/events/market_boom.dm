//Positive version of it
/datum/round_event_control/lc13/company_crash/boom
	name = "Company Boom"
	typepath = /datum/round_event/company_crash/boom
	max_occurrences = 2
	weight = 5
	earliest_start = 30 MINUTES

/datum/round_event/company_crash/boom/announce()
	if(!length(possible_sales))
		var/fake_company = list("Love Company", "Leyla Conglomerate", "Enix Corporation")
		priority_announce("Control HQ has received word that [pick(fake_company)] has been making big moves in the sector. \
			We are seeking new investment opportunities with them.",
		sound = 'sound/misc/notice2.ogg',
		sender_override = "HQ Control")
		return

	chosen_sales = pick(possible_sales)

	priority_announce("Control HQ has received word that there has been big moves in the wings. As such, this facility's [chosen_sales.name] will pay out significantly more.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Control")
	chosen_sales.ahn_amount *= 4


/datum/round_event/company_crash/boom/end()
	priority_announce("The company's boom has ended. [chosen_sales.name]'s prices have returned to normal.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Control")
	chosen_sales.ahn_amount /= 4
