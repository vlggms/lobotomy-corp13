GLOBAL_VAR(Pale_Librarian)

/obj/library_director
	name = "Library Director"
	desc = "The rumored pale librarian. She looks almost robotic..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "angela"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	density = TRUE
	anchored = TRUE
	var/selected_floor = null
	var/list/selected_abnos = list()
	var/list/reception_abnos = list()
	var/list/victim_list = list()
	var/total_risk = 0
	var/reception = FALSE
	var/turf/Home

	var/list/greetings = list(
		"Greetings, dear guests. This is the Library.",
		"And I am Angela, the librarian of my role's namesake.",
		"You may find what you desire here, but you also may end up yielding your precious possessions to us.",
		"When you're ready, please press the button on this table.",
		"May you find your book in this place."
	)

	var/list/special_greetings = list() //This was for special receptions, but I'm too tired
	
	//List of abnos from specific floors, some are not here due to not breaching or being too hard with shit rewards (I was thinking of making them drop realized gear like KoD, but that seems too good)
	var/list/general_floor = list(
		/mob/living/simple_animal/hostile/abnormality/pinocchio
	)

	var/list/history_floor = list(
	)

	var/list/technology_floor = list(
		/mob/living/simple_animal/hostile/abnormality/forsaken_murderer,
		/mob/living/simple_animal/hostile/abnormality/funeral,
		/mob/living/simple_animal/hostile/abnormality/helper
	)

	var/list/literature_floor = list(
		/mob/living/simple_animal/hostile/abnormality/black_swan
	)

	var/list/art_floor = list(
		/mob/living/simple_animal/hostile/abnormality/fragment
	)

	var/list/natural_floor = list(
		/mob/living/simple_animal/hostile/abnormality/hatred_queen
	)

	var/list/language_floor = list(
		/mob/living/simple_animal/hostile/abnormality/mountain,
		/mob/living/simple_animal/hostile/abnormality/nosferatu,
		/mob/living/simple_animal/hostile/abnormality/nothing_there
	)

	var/list/social_floor = list(
		/mob/living/simple_animal/hostile/abnormality/scarecrow,
		/mob/living/simple_animal/hostile/abnormality/woodsman
	)

	var/list/philosophy_floor = list(
		/mob/living/simple_animal/hostile/abnormality/judgement_bird
	)

	var/list/religion_floor = list(
	)

	var/list/floor_list = list(
	)

	var/list/aleph_list = list(
		/mob/living/simple_animal/hostile/abnormality/censored,
		/mob/living/simple_animal/hostile/abnormality/judgement_bird,
		/mob/living/simple_animal/hostile/abnormality/last_shot,
		/mob/living/simple_animal/hostile/abnormality/melting_love,
		/mob/living/simple_animal/hostile/abnormality/mountain,
		/mob/living/simple_animal/hostile/abnormality/nothing_there
	)

	// Sphinx doesn't kill, kinda fucks with the signals, and I'm not making new signals for petrify
	// Technically can add sow, but it'd take like 20+ extra lines, this code is convoluded enough
	var/list/waw_list = list(
		/mob/living/simple_animal/hostile/abnormality/apex_predator,
		/mob/living/simple_animal/hostile/abnormality/black_swan,
		/mob/living/simple_animal/hostile/abnormality/clouded_monk,
		/mob/living/simple_animal/hostile/abnormality/clown,
		/mob/living/simple_animal/hostile/abnormality/ebony_queen,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,
		/mob/living/simple_animal/hostile/abnormality/nosferatu,
		/mob/living/simple_animal/hostile/abnormality/thunder_bird,
		/mob/living/simple_animal/hostile/abnormality/warden
	)

	// Dreaming is here because it's too easy, hey free waw
	var/list/he_list = list(
		/mob/living/simple_animal/hostile/abnormality/dreaming_current,
		/mob/living/simple_animal/hostile/abnormality/blue_shepherd,
		/mob/living/simple_animal/hostile/abnormality/funeral,
		/mob/living/simple_animal/hostile/abnormality/golden_apple,
		/mob/living/simple_animal/hostile/abnormality/headless_ichthys,
		/mob/living/simple_animal/hostile/abnormality/helper,
		/mob/living/simple_animal/hostile/abnormality/kqe,
		/mob/living/simple_animal/hostile/abnormality/pinocchio,
		/mob/living/simple_animal/hostile/abnormality/pisc_mermaid,
		/mob/living/simple_animal/hostile/abnormality/puss_in_boots,
		/mob/living/simple_animal/hostile/abnormality/red_buddy,
		/mob/living/simple_animal/hostile/abnormality/scarecrow,
		/mob/living/simple_animal/hostile/abnormality/wayward,
		/mob/living/simple_animal/hostile/abnormality/woodsman
	)

	var/list/teth_list = list(
		/mob/living/simple_animal/hostile/abnormality/fairy_longlegs,
		/mob/living/simple_animal/hostile/abnormality/forsaken_murderer,
		/mob/living/simple_animal/hostile/abnormality/fragment,
		/mob/living/simple_animal/hostile/abnormality/redblooded,
		/mob/living/simple_animal/hostile/abnormality/smile
	)

	var/list/risk_list = list(
	)

/obj/library_director/Initialize()
	. = ..()
	GLOB.Pale_Librarian = src
	floor_list = list(
		general_floor, history_floor, technology_floor, literature_floor, art_floor, 
		natural_floor, language_floor, social_floor, philosophy_floor, religion_floor
	)

	risk_list = list(
		aleph_list, waw_list, he_list, teth_list
	)

/obj/library_director/proc/GenerateReception()
	if(!LAZYLEN(selected_abnos))
		PickAbno()
	if(!selected_floor)
		PickFloor()
	var/TP_Landmark
	for(var/obj/effect/landmark/library_floor/LF in GLOB.landmarks_list)
		TP_Landmark = get_turf(LF)
	var/datum/map_template/shelter/template = SSmapping.shelter_templates[selected_floor]
	template.load(TP_Landmark, centered = TRUE)
	Explain()

/obj/library_director/proc/Explain()
	if(LAZYLEN(special_greetings))
		for(var/i in special_greetings)
			sleep(15)
			say(i)
	else
		for(var/i in greetings)
			sleep(15)
			say(i)
	
//Calculates the user level and armor values, weapons don't have much consistency to them (BL is quite fucked either way)
/obj/library_director/proc/PickAbno()
	for(var/mob/living/carbon/human/H in victim_list)
		total_risk += get_user_level(H)
		var/obj/item/clothing/suit/armor/E = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)	
		if(istype(E))
			//This is so fucking cursed, no we actually can't just loop armor list because some has bomb/fire/tox res being outside of ego subtype
			var/total_armor = H.getarmor(null, RED_DAMAGE)
			total_armor += H.getarmor(null, WHITE_DAMAGE)
			total_armor += H.getarmor(null, BLACK_DAMAGE)
			total_armor += H.getarmor(null, PALE_DAMAGE)
			if(total_armor >= 200)
				total_risk += 5
			else if(total_armor >= 120)
				total_risk += 3
			else if(total_armor >= 70)
				total_risk += 2

	//Small chance to face aleph even when alone
	if(total_risk >= 20)
		selected_abnos += pick_n_take(aleph_list)
	else
		if(prob(3*total_risk))
			selected_abnos += pick_n_take(aleph_list)
			total_risk -= 20
	
	if(total_risk >= 10)
		selected_abnos += pick_n_take(waw_list)
		total_risk -= 10

	for(var/i = 1 to 2)
		if(total_risk <= 0 || selected_abnos.len >= 3 || selected_abnos.len >= victim_list.len) // Don't let it spawn more than the number of victims
			break
		if(total_risk >= 10 && prob(5*total_risk))
			selected_abnos += pick_n_take(waw_list)
			total_risk -= 10
		else
			if(total_risk >= 4 && prob(14*total_risk))
				selected_abnos += pick_n_take(he_list)
				total_risk -= 4
			else
				selected_abnos += pick_n_take(teth_list)
				total_risk -= 2

/obj/library_director/proc/PickFloor()
	var/highest_risk_abno = null
	for(var/i in selected_abnos)
		for(var/j in risk_list)
			if((i in j) && (i in floor_list)) //Checks from the highest risk first
				highest_risk_abno = i
				break
		if(highest_risk_abno)
			break
	
	if(!highest_risk_abno)
		selected_floor = pick("general_floor", "history_floor", "technology_floor", "literature_floor", "art_floor", "natural_floor", "language_floor", "social_floor", "philosophy_floor", "religion_floor")
		return

	if(highest_risk_abno in general_floor)
		selected_floor = "general_floor"
	if(highest_risk_abno in history_floor)
		selected_floor = "history_floor"
	if(highest_risk_abno in technology_floor)
		selected_floor = "technology_floor"
	if(highest_risk_abno in literature_floor)
		selected_floor = "literature_floor"
	if(highest_risk_abno in art_floor)
		selected_floor = "art_floor"
	if(highest_risk_abno in natural_floor)
		selected_floor = "natural_floor"
	if(highest_risk_abno in language_floor)
		selected_floor = "language_floor"
	if(highest_risk_abno in social_floor)
		selected_floor = "social_floor"
	if(highest_risk_abno in philosophy_floor)
		selected_floor = "philosophy_floor"
	if(highest_risk_abno in religion_floor)
		selected_floor = "religion_floor"		

/obj/library_director/proc/BeginReception()
	var/list/Guest_TP_Potential = list()
	var/list/Abno_TP_Potential = list()
	for(var/obj/effect/landmark/library_reception_humans/LRH in GLOB.landmarks_list)
		Guest_TP_Potential += get_turf(LRH)
	for(var/obj/effect/landmark/library_reception_abno/LRA in GLOB.landmarks_list)
		Abno_TP_Potential += get_turf(LRA)
	for(var/mob/living/L in victim_list)
		new /obj/effect/temp_visual/turn_book(get_turf(L))
		playsound(L, 'sound/effects/book_turn.ogg', 75, TRUE, TRUE)
		L.forceMove(pick_n_take(Guest_TP_Potential))
		new /obj/effect/temp_visual/turn_book(get_turf(L))
		RegisterSignal(L, COMSIG_LIVING_DEATH, .proc/GuestDeath)
	for(var/i in selected_abnos)
		var/mob/living/simple_animal/hostile/abnormality/A = new i(pick_n_take(Abno_TP_Potential))
		playsound(A, 'sound/effects/book_turn.ogg', 75, TRUE, TRUE)
		new /obj/effect/temp_visual/turn_book(get_turf(A))
		reception_abnos += A
		A.fear_level = 0
		if(!SpecialCheck(A))
			A.BreachEffect() //Prevents multiple icons being silly
		RegisterSignal(A, COMSIG_LIVING_DEATH, .proc/AbnoDeath)

/obj/library_director/proc/SpecialCheck(mob/living/simple_animal/hostile/abnormality/A)
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/mountain))
		var/mob/living/simple_animal/hostile/abnormality/mountain/MoSB = A
		MoSB.BreachEffect()
		MoSB.phase = 2
		MoSB.StageChange()
		return TRUE
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/nothing_there))
		var/mob/living/simple_animal/hostile/abnormality/nothing_there/NT = A
		NT.next_stage() //Go kill the other spawns while he's transforming
		return TRUE
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/apex_predator))
		return TRUE //We just don't want it cloaking
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/black_swan))
		var/mob/living/simple_animal/hostile/abnormality/black_swan/BS = A
		BS.update_icon_state()
		return TRUE
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/ebony_queen))
		return TRUE //ALL OF YOU NEED TO STOP TELEPORTING
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/hatred_queen)) //We're deleting every abno if people lose the reception, she won't get to TP to the facility
		var/mob/living/simple_animal/hostile/abnormality/hatred_queen/QoH = A
		QoH.HostileTransform()
		QoH.fear_level = 0
		return TRUE
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		return TRUE //Another teleporter
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/kqe))
		var/mob/living/simple_animal/hostile/abnormality/kqe/KQE = A
		KQE.heart = TRUE // Don't spawn the heart, but buff the HP
		KQE.health = 2000
		return TRUE
	return FALSE

/obj/library_director/proc/EndReception(Victory = TRUE)
	for(var/i in selected_abnos)
		UnregisterSignal(i, COMSIG_LIVING_DEATH)
		qdel(i)
	for(var/i in victim_list)
		UnregisterSignal(i, COMSIG_LIVING_DEATH)
	
	if(Victory)
		addtimer(CALLBACK(src, .proc/CleanUp), 30 SECONDS)
	else
		CleanUp()

/obj/library_director/proc/CleanUp()
	//Cleans up everything to prepare for next reception
	for(var/mob/living/L in victim_list)
		if(is_library_level(L.z))
			new /obj/effect/temp_visual/turn_book(get_turf(L))
			playsound(L, 'sound/effects/book_turn.ogg', 75, TRUE, TRUE)
			L.forceMove(Home)
			new /obj/effect/temp_visual/turn_book(get_turf(L))

	var/TP_Landmark
	for(var/obj/effect/landmark/library_floor/LF in GLOB.landmarks_list)
		TP_Landmark = LF
	var/area/Arena
	for(var/obj/effect/landmark/library_floor/LF in GLOB.landmarks_list)
		Arena = get_area(LF)
	for(var/i in Arena.contents)
		if(i == TP_Landmark)
			continue
		qdel(i)

	total_risk = 0
	special_greetings = list()
	selected_abnos = list()
	reception_abnos = list()
	victim_list = list()
	reception = FALSE
	selected_floor = null
	Home = null

/obj/library_director/proc/AbnoDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	var/mob/living/L = source
	reception_abnos -= L
	L.turn_book(FALSE, FALSE, FALSE, FALSE, FALSE, round(victim_list.len*1.5)) //Kinda reverse emotion, you get more rewards for each surviving members
	if(!LAZYLEN(reception_abnos))
		EndReception(TRUE)

/obj/library_director/proc/GuestDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	var/mob/living/L = source
	victim_list -= L
	L.turn_book()
	//Make a code that puts the book in the library shelf
	if(!LAZYLEN(victim_list))
		EndReception(FALSE)

//////////////////
//FLOOR TEMPLATE//
//////////////////
/datum/map_template/shelter/general_floor
	name = "Floor of General Works"
	shelter_id = "general_floor"
	description = "A floor completely filled with gray books. Towering useless trivia that you can drown yourself in forever."
	mappath = "_maps/templates/library_floors/general_floor.dmm"

/datum/map_template/shelter/history_floor
	name = "Floor of History"
	shelter_id = "history_floor"
	description = "A floor designated for sorting books related to history, documented events, and the past."
	mappath = "_maps/templates/library_floors/history_floor.dmm"

/datum/map_template/shelter/technology_floor
	name = "Floor of Technological Sciences"
	shelter_id = "technology_floor"
	description = "A floor seemingly comprised of buildings and gears. The turning gears make an unpleasant sound."
	mappath = "_maps/templates/library_floors/technology_floor.dmm"

/datum/map_template/shelter/literature_floor
	name = "Floor of Literature"
	shelter_id = "literature_floor"
	description = "A floor storing books of Literature. You can see many books neatly placed on... moving bookshelves?!"
	mappath = "_maps/templates/library_floors/literature_floor.dmm"

/datum/map_template/shelter/art_floor
	name = "Floor of Art"
	shelter_id = "art_floor"
	description = "A floor filled with towering trees and growing moss. None of the books stored in the right section."
	mappath = "_maps/templates/library_floors/art_floor.dmm"

/datum/map_template/shelter/natural_floor
	name = "Floor of Natural Sciences"
	shelter_id = "natural_floor"
	description = "A floor storing books of natural sciences. It's filled with shiny decors that blind your eyes."
	mappath = "_maps/templates/library_floors/natural_floor.dmm"

/datum/map_template/shelter/language_floor
	name = "Floor of Language"
	shelter_id = "language_floor"
	description = "A floor filled with machinery, the heat is making you dizzy. WAIT, ARE THOSE BOOKS IN THE LAVA?!"
	mappath = "_maps/templates/library_floors/language_floor.dmm"

/datum/map_template/shelter/social_floor
	name = "Floor of Social Sciences"
	shelter_id = "social_floor"
	description = "A floor storing books of social sciences. You can see cars floating in the background."
	mappath = "_maps/templates/library_floors/social_floor.dmm"

/datum/map_template/shelter/philosophy_floor
	name = "Floor of Philosophy"
	shelter_id = "philosophy_floor"
	description = "A floor filled with beautiful stars. You feel like they're calling for you..."
	mappath = "_maps/templates/library_floors/philosophy_floor.dmm"

/datum/map_template/shelter/religion_floor
	name = "Floor of Religion"
	shelter_id = "religion_floor"
	description = "A floor filled with giant clocks. The flow of time is odd in here, but never stopping."
	mappath = "_maps/templates/library_floors/religion_floor.dmm"


////////////////
//READY BUTTON//
////////////////
/obj/machinery/button/reception_start
	name = "Library teleportation device"
	desc = "This device is used to teleport guests to the reception floor."
	use_power = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/list/ready_up = list()

/obj/machinery/button/reception_start/emag_act(mob/user)
	return

/obj/machinery/button/reception_start/attackby(obj/item/W as obj, mob/user as mob, params)
	if(user.a_intent != INTENT_HARM && !(W.item_flags & NOBLUDGEON))
		return attack_hand(user)

/obj/machinery/button/reception_start/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	flick("[skin]1",src)
	var/obj/library_director/C = GLOB.Pale_Librarian
	if(user in C.victim_list)
		ready_up |= user
	if(C.victim_list.len > ready_up.len)
		visible_message("<span class='warning'>[ready_up.len]/[C.victim_list.len] guests are ready.</span>")
		return
	visible_message("<span class='warning'>All guests are ready, reception begins in 3 seconds</span>")
	sleep(30)
	C.BeginReception()
	ready_up = list()

//////////////
//INVITATION//
//////////////
/obj/item/paper/fluff/invitation_red
	name = "Red Invitation"
	desc = "A mysterious invitation. Sign your names here and burn it to travel to the rumored library."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "invitation_red"
	show_written_words = FALSE
	slot_flags = null // No books on head, sorry
	info = "Ayin did nothing wrong"
	var/list/victim_list = list()
	var/list/selected_abnos = list()
	var/selected_floor = null
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/paper/fluff/invitation_red/ui_interact(mob/user, datum/tgui/ui)
	UpdateInfo()
	..()

/obj/item/paper/fluff/invitation_red/AltClick(mob/living/user, obj/item/I)
	return

/obj/item/paper/fluff/invitation_red/attackby(obj/item/P, mob/living/user, params)
	//Starts reception if burned
	if(burn_paper_product_attackby_check(P, user))
		if(!LAZYLEN(victim_list))
			to_chat(user, "<span class='warning'>Nobody has signed the invitation!</span>")
			return
		var/obj/library_director/C = GLOB.Pale_Librarian
		if(C.reception)
			to_chat(user, "<span class='warning'>The library is currently handling another group!</span>")
			return
		C.reception = TRUE
		C.Home = get_turf(src)
		C.victim_list += victim_list
		C.selected_abnos = selected_abnos
		C.selected_floor = selected_floor
		var/turf/TP_Landmark
		var/list/TP_Potential = list()
		for(var/obj/effect/landmark/library_entrance/LE in GLOB.landmarks_list)
			TP_Landmark = get_turf(LE)
		playsound(src, 'sound/effects/book_burn.ogg', 50, TRUE, TRUE)
		for(var/turf/TT in range(1, TP_Landmark))
			TP_Potential += TT
		for(var/mob/living/L in victim_list)
			visible_message("<span class='warning'>[L] was consumbed by the light!</span>")
			new /obj/effect/temp_visual/turn_book(get_turf(L))
			playsound(L, 'sound/effects/book_turn.ogg', 75, TRUE, TRUE)
			L.forceMove(pick(TP_Potential))
			new /obj/effect/temp_visual/turn_book(get_turf(L))
		SStgui.close_uis(src)
		C.GenerateReception()
		qdel(src)
		return
	if(istype(P, /obj/item/pen) || istype(P, /obj/item/toy/crayon))
		if(victim_list.len >= 5)
			to_chat(user, "<span class='warning'>There's already too many people going to the library!</span>")
			return
		if(user in victim_list)
			to_chat(user, "<span class='warning'>You already signed your life away!</span>")
			return
		victim_list += user
	ui_interact(user)

//This was written like this just to make it easier to read, and also shitty lines just like the real invitation
/obj/item/paper/fluff/invitation_red/proc/UpdateInfo()
	info = "<hr><h1><center>THE INVITATION</center></h1><hr>"
	info += "<center>DEAR GUEST: I FORMALLY INVITE YOU TO THE LIBRARY.</center><br>"
	info += "<center>THE LIBRARY'S BOOKS CAN PROVIDE YOU WITH ALL THE</center><br>"
	info += "<center>WISDOM, WEALTH, HONOR, AND POWER YOU SEEK.</center><br>"
	info += "<center>HOWEVER, AN ORDEAL WILL AWAIT YOU IN THE LIBRARY.</center><br>"
	info += "<center>IF YOU CANNOT OVERCOME THIS ORDEAL,</center><br>"
	info += "<center>YOU WILL BE CONVERTED INTO A BOOK YOURSELF.</center><br>"
	info += "<center><font face=\"[SIGNFONT]\"><b><i>- ANGELA</i></b></font></center><hr>"
	info += "<center><h2>BOOKS OF THE DAY</h2></center><br>"
	//Put if for special conditions
	info += "- Unknown<br>"
	info += "<br><hr><center><b>ADDRESSEE<b></center><hr>"
	for(var/mob/living/user in victim_list)
		info += "<center><font face=\"[SIGNFONT]\"><i>[user.real_name]</i></font></center><hr>"
