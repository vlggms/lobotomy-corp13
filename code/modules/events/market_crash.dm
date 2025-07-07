/datum/round_event_control/lc13/company_crash
	name = "Company Crash"
	typepath = /datum/round_event/company_crash
	max_occurrences = 2
	weight = 5
	earliest_start = 30 MINUTES

/datum/round_event/company_crash
	announceWhen = 1
	endWhen = 10000

	//Only companies can get their price increased/decreased.
	var/list/viable_sales

	var/obj/structure/pe_sales/chosen_sales
	var/list/possible_sales = list()

/datum/round_event/company_crash/setup()
	endWhen = rand(200, 24000)	//Who knows when it will end?
	..()

/datum/round_event/company_crash/start()
	var/list/viable_sales = typecacheof(list(
		/obj/structure/pe_sales/l_corp,
		/obj/structure/pe_sales/k_corp,
		/obj/structure/pe_sales/r_corp,
		/obj/structure/pe_sales/s_corp,
		/obj/structure/pe_sales/w_corp,
		/obj/structure/pe_sales/n_corp))


	//Grab all possible
	for(var/obj/structure/pe_sales/P in GLOB.lobotomy_devices)
		if(P.type in viable_sales)
			possible_sales += P
	..()

/datum/round_event/company_crash/announce()
	if(!length(possible_sales))
		var/fake_company = list("Love Company", "Leyla Conglomerate", "Enix Corporation")
		priority_announce("Control HQ has received word that [pick(fake_company)] has gone under, and as such, all contracts with them have been terminated.",
		sound = 'sound/misc/notice2.ogg',
		sender_override = "HQ Control")
		return

	chosen_sales = pick(possible_sales)

	priority_announce("Control HQ has received word that there has been big moves in the wings. As such, this facility's [chosen_sales.name] will pay out significantly less.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Control")
	chosen_sales.ahn_amount /= 4


/datum/round_event/company_crash/end()
	priority_announce("The company's crash has ended. [chosen_sales.name]'s prices have returned to normal.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Control")
	chosen_sales.ahn_amount *= 4


