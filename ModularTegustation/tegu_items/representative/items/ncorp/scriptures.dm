/obj/item/scripture
	name = "debug scripture"
	desc = "A debug scripture. Notify admins!"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "scripture_blank"
	var/is_reading = FALSE
	var/list/players_affected = list()

/obj/item/scripture/attack_self(mob/living/carbon/human/user)
	..()
	if(is_reading)
		return

	is_reading = TRUE
	DurationEffect()

	if(do_after(user, 10 SECONDS, src))
		is_reading = FALSE
	DurationEnd()
	is_reading = FALSE


/obj/item/scripture/proc/DurationEffect()
	if(is_reading)
		addtimer(CALLBACK(src, PROC_REF(DurationEffect)), 0.5 SECONDS)

//This is a little bit of shitcode, but it's the cleanest way I can do it.
	for(var/mob/living/carbon/human/L in players_affected)
		RemoveEffect(L)
	players_affected = list()

	for(var/mob/living/carbon/human/L in view(7, get_turf(src)))
		players_affected|=L
		AddEffect(L)


//Keep these empty for now, you can add them later.
/obj/item/scripture/proc/AddEffect(mob/living/carbon/human/L)

/obj/item/scripture/proc/RemoveEffect(mob/living/carbon/human/L)

/obj/item/scripture/proc/DurationEnd()
	for(var/mob/living/carbon/human/L in players_affected)
		RemoveEffect(L)
	players_affected = list()



//Set of armor scriptures
/obj/item/scripture/redarmor
	name = "scripture of ordeal"
	desc = "A scripture detailing the trials of a kleinhammer who refused to fall in battle"
	icon_state = "scripture_redshield"

/obj/item/scripture/redearmor/AddEffect(mob/living/carbon/human/L)
	L.physiology.red_mod *= 0.2

/obj/item/scripture/redarmor/RemoveEffect(mob/living/carbon/human/L)
	L.physiology.red_mod /= 0.2

/obj/item/scripture/whitearmor
	name = "scripture of meditation"
	desc = "A scripture detailing the meditations of a Grand Inquisitor."
	icon_state = "scripture_whiteshield"

/obj/item/scripture/whitearmor/AddEffect(mob/living/carbon/human/L)
	L.physiology.white_mod *= 0.2

/obj/item/scripture/whitearmor/RemoveEffect(mob/living/carbon/human/L)
	L.physiology.white_mod /= 0.2

/obj/item/scripture/blackarmor
	name = "scripture of balance"
	desc = "A scripture detailing the trials of a brave mittlehammer sent through trials"
	icon_state = "scripture_blackshield"

/obj/item/scripture/blackarmor/AddEffect(mob/living/carbon/human/L)
	L.physiology.black_mod *= 0.2

/obj/item/scripture/blackarmor/RemoveEffect(mob/living/carbon/human/L)
	L.physiology.black_mod /= 0.2


//Regen
/obj/item/scripture/regen
	name = "scripture of healing"
	desc = "A scripture containing psalms of a Grand Inquisitor."
	icon_state = "scripture_regen"

/obj/item/scripture/regen/AddEffect(mob/living/carbon/human/L)
	L.adjustBruteLoss(-L.maxHealth*0.03)
	new /obj/effect/temp_visual/heal(get_turf(L), "#FF4444")

