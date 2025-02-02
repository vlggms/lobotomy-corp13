/mob/living/simple_animal/hostile/abnormality/branch12/moon_book
	name = "Book of Moon"
	desc = "A book with no text inside."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "book_moon"
	icon_living = "book_moon"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 70,
	)
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	threat_level = TETH_LEVEL

	ego_list = list(
		/datum/ego_datum/weapon/branch12/starry_night,
		/datum/ego_datum/armor/branch12/starry_night,
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/moon_book/SuccessEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type!= ABNORMALITY_WORK_REPRESSION)
		return
	var/list/not_understood = list()
	for(var/mob/living/simple_animal/hostile/abnormality/V in GLOB.abnormality_mob_list)
		if(V.datum_reference.understanding != V.datum_reference.max_understanding)
			not_understood+=V

	//don't use the ability if you're full on understanding.
	if(!length(not_understood))
		return

	for(var/mob/living/simple_animal/hostile/abnormality/to_understand in not_understood)
		//increase understanding of 3 abnormalities and take from your pool. Get a bigger bonus for doing this
		to_understand.datum_reference.understanding*=1.2

		if(to_understand.datum_reference.understanding > to_understand.datum_reference.max_understanding)
			to_understand.datum_reference.understanding = to_understand.datum_reference.max_understanding

		datum_reference.understanding*=0.8

	//Use understanding percentage as a chance to return.
	if(prob(datum_reference.understanding*10))
		return

	//get a list of shit to meltdown
	var/list/possible_breachers = list()
	for(var/mob/living/simple_animal/hostile/abnormality/V in GLOB.abnormality_mob_list)
		if(V.datum_reference.qliphoth_meter && V.IsContained() && V.z == z)
			possible_breachers+=V

	if(!length(possible_breachers))
		return
	//okay melt it
	var/mob/living/simple_animal/hostile/abnormality/breaching = pick(possible_breachers)
	breaching.datum_reference.qliphoth_change(-99)
