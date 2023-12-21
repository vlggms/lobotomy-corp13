/obj/item/toy/plush
	name = "plush"
	desc = "This is the special coder plush, do not steal."
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"
	attack_verb_continuous = list("thumps", "whomps", "bumps")
	attack_verb_simple = list("thump", "whomp", "bump")
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	var/list/squeak_override //Weighted list; If you want your plush to have different squeak sounds use this
	var/stuffed = TRUE //If the plushie has stuffing in it
	var/obj/item/grenade/grenade //You can remove the stuffing from a plushie and add a grenade to it for *nefarious uses*
	gender = NEUTER
	var/divine = FALSE

	var/unique_pet = FALSE // LOBOTOMYCORPORATION EDIT ADDITION - unique plushie messages

/obj/item/toy/plush/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, squeak_override)
	AddElement(/datum/element/bed_tuckable, 6, -5, 90)

/obj/item/toy/plush/Destroy()
	QDEL_NULL(grenade)

	//null remaining lists
	squeak_override = null

	return ..()

/obj/item/toy/plush/handle_atom_del(atom/A)
	if(A == grenade)
		grenade = null
	..()

/obj/item/toy/plush/attack_self(mob/user)
	. = ..()
	if(unique_pet) // LOBOTOMYCORPORATION EDIT ADDITION - unique plushie messages
		to_chat(user, "<span class='notice'>[unique_pet]</span>")
		return
	if(stuffed || grenade)
		to_chat(user, "<span class='notice'>You pet [src]. D'awww.</span>")
		if(grenade && !grenade.active)
			log_game("[key_name(user)] activated a hidden grenade in [src].")
			grenade.arm_grenade(user, msg = FALSE, volume = 10)
	else
		to_chat(user, "<span class='notice'>You try to pet [src], but it has no stuffing. Aww...</span>")

/obj/item/toy/plush/attackby(obj/item/I, mob/living/user, params)
	if(I.get_sharpness())
		if(!grenade)
			if(!stuffed)
				to_chat(user, "<span class='warning'>You already murdered it!</span>")
				return
			if(!divine)
				user.visible_message("<span class='notice'>[user] tears out the stuffing from [src]!</span>", "<span class='notice'>You rip a bunch of the stuffing from [src]. Murderer.</span>")
				I.play_tool_sound(src)
				stuffed = FALSE
			else
				to_chat(user, "<span class='notice'>What a fool you are. [src] is a god, how can you kill a god? What a grand and intoxicating innocence.</span>")
				if(iscarbon(user))
					var/mob/living/carbon/C = user
					if(C.drunkenness < 50)
						C.drunkenness = min(C.drunkenness + 20, 50)
				var/turf/current_location = get_turf(user)
				var/area/current_area = current_location.loc //copied from hand tele code
				if(current_location && current_area && (current_area.area_flags & NOTELEPORT))
					to_chat(user, "<span class='notice'>There is no escape. No recall or intervention can work in this place.</span>")
				else
					to_chat(user, "<span class='notice'>There is no escape. Although recall or intervention can work in this place, attempting to flee from [src]'s immense power would be futile.</span>")
				user.visible_message("<span class='notice'>[user] lays down their weapons and begs for [src]'s mercy!</span>", "<span class='notice'>You lay down your weapons and beg for [src]'s mercy.</span>")
				user.drop_all_held_items()
		else
			to_chat(user, "<span class='notice'>You remove the grenade from [src].</span>")
			user.put_in_hands(grenade)
			grenade = null
		return
	if(istype(I, /obj/item/grenade))
		if(stuffed)
			to_chat(user, "<span class='warning'>You need to remove some stuffing first!</span>")
			return
		if(grenade)
			to_chat(user, "<span class='warning'>[src] already has a grenade!</span>")
			return
		if(!user.transferItemToLoc(I, src))
			return
		user.visible_message("<span class='warning'>[user] slides [grenade] into [src].</span>", \
		"<span class='danger'>You slide [I] into [src].</span>")
		grenade = I
		var/turf/grenade_turf = get_turf(src)
		log_game("[key_name(user)] added a grenade ([I.name]) to [src] at [AREACOORD(grenade_turf)].")
		return
	return ..()

/obj/item/toy/plush/carpplushie
	name = "carp plushie"
	desc = "An adorable stuffed toy that resembles a carp."
	icon_state = "carpplush"
	inhand_icon_state = "carp_plushie"
	attack_verb_continuous = list("bites", "eats", "fin slaps")
	attack_verb_simple = list("bite", "eat", "fin slap")
	squeak_override = list('sound/weapons/bite.ogg'=1)

/obj/item/toy/plush/bubbleplush
	name = "\improper Bubblegum plushie"
	desc = "The friendly red demon that gives good miners gifts."
	icon_state = "bubbleplush"
	attack_verb_continuous = list("rents")
	attack_verb_simple = list("rent")
	squeak_override = list('sound/magic/demon_attack1.ogg'=1)

/obj/item/toy/plush/ratplush
	name = "\improper Ratvar plushie"
	desc = "An adorable plushie of the clockwork justiciar himself with new and improved spring arm action."
	icon_state = "plushvar"
	divine = TRUE
	var/obj/item/toy/plush/narplush/clash_target
	gender = MALE	//he's a boy, right?

/obj/item/toy/plush/ratplush/Moved()
	. = ..()
	if(clash_target)
		return
	var/obj/item/toy/plush/narplush/P = locate() in range(1, src)
	if(P && istype(P.loc, /turf/open) && !P.clashing)
		clash_of_the_plushies(P)

/obj/item/toy/plush/ratplush/proc/clash_of_the_plushies(obj/item/toy/plush/narplush/P)
	clash_target = P
	P.clashing = TRUE
	say("YOU.")
	P.say("Ratvar?!")
	var/obj/item/toy/plush/a_winnar_is
	var/victory_chance = 10
	for(var/i in 1 to 10) //We only fight ten times max
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		if(!Adjacent(P))
			visible_message("<span class='warning'>The two plushies angrily flail at each other before giving up.</span>")
			clash_target = null
			P.clashing = FALSE
			return
		playsound(src, 'sound/magic/clockwork/ratvar_attack.ogg', 50, TRUE, frequency = 2)
		sleep(2.4)
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		if(prob(victory_chance))
			a_winnar_is = src
			break
		P.SpinAnimation(5, 0)
		sleep(5)
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		playsound(P, 'sound/magic/clockwork/narsie_attack.ogg', 50, TRUE, frequency = 2)
		sleep(3.3)
		if(QDELETED(src))
			P.clashing = FALSE
			return
		if(QDELETED(P))
			clash_target = null
			return
		if(prob(victory_chance))
			a_winnar_is = P
			break
		SpinAnimation(5, 0)
		victory_chance += 10
		sleep(5)
	if(!a_winnar_is)
		a_winnar_is = pick(src, P)
	if(a_winnar_is == src)
		say(pick("DIE.", "ROT."))
		P.say(pick("Nooooo...", "Not die. To y-", "Die. Ratv-", "Sas tyen re-"))
		playsound(src, 'sound/magic/clockwork/anima_fragment_attack.ogg', 50, TRUE, frequency = 2)
		playsound(P, 'sound/magic/demon_dies.ogg', 50, TRUE, frequency = 2)
		explosion(P, 0, 0, 1)
		qdel(P)
		clash_target = null
	else
		say("NO! I will not be banished again...")
		P.say(pick("Ha.", "Ra'sha fonn dest.", "You fool. To come here."))
		playsound(src, 'sound/magic/clockwork/anima_fragment_death.ogg', 62, TRUE, frequency = 2)
		playsound(P, 'sound/magic/demon_attack1.ogg', 50, TRUE, frequency = 2)
		explosion(src, 0, 0, 1)
		qdel(src)
		P.clashing = FALSE

/obj/item/toy/plush/narplush
	name = "\improper Nar'Sie plushie"
	desc = "A small stuffed doll of the elder goddess Nar'Sie. Who thought this was a good children's toy?"
	icon_state = "narplush"
	divine = TRUE
	var/clashing
	gender = FEMALE	//it's canon if the toy is

/obj/item/toy/plush/narplush/Moved()
	. = ..()
	var/obj/item/toy/plush/ratplush/P = locate() in range(1, src)
	if(P && istype(P.loc, /turf/open) && !P.clash_target && !clashing)
		P.clash_of_the_plushies(src)

/obj/item/toy/plush/lizardplushie
	name = "lizard plushie"
	desc = "An adorable stuffed toy that resembles a lizardperson."
	icon_state = "plushie_lizard"
	inhand_icon_state = "plushie_lizard"
	attack_verb_continuous = list("claws", "hisses", "tail slaps")
	attack_verb_simple = list("claw", "hiss", "tail slap")
	squeak_override = list('sound/weapons/slash.ogg' = 1)

/obj/item/toy/plush/lizardplushie/space
	name = "space lizard plushie"
	desc = "An adorable stuffed toy that resembles a very determined spacefaring lizardperson. To infinity and beyond, little guy."
	icon_state = "plushie_spacelizard"
	inhand_icon_state = "plushie_spacelizard"

/obj/item/toy/plush/snakeplushie
	name = "snake plushie"
	desc = "An adorable stuffed toy that resembles a snake. Not to be mistaken for the real thing."
	icon_state = "plushie_snake"
	inhand_icon_state = "plushie_snake"
	attack_verb_continuous = list("bites", "hisses", "tail slaps")
	attack_verb_simple = list("bite", "hiss", "tail slap")
	squeak_override = list('sound/weapons/bite.ogg' = 1)

/obj/item/toy/plush/nukeplushie
	name = "operative plushie"
	desc = "A stuffed toy that resembles a syndicate nuclear operative from a popular video game"
	icon_state = "plushie_nuke"
	inhand_icon_state = "plushie_nuke"
	attack_verb_continuous = list("shoots", "nukes", "detonates")
	attack_verb_simple = list("shoot", "nuke", "detonate")
	squeak_override = list('sound/effects/hit_punch.ogg' = 1)

/obj/item/toy/plush/plasmamanplushie
	name = "plasmaman plushie"
	desc = "A stuffed toy that resembles your purple coworkers. Mmm, yeah, in true plasmaman fashion, it's not cute at all despite the designer's best efforts."
	icon_state = "plushie_pman"
	inhand_icon_state = "plushie_pman"
	attack_verb_continuous = list("burns", "space beasts", "fwooshes")
	attack_verb_simple = list("burn", "space beast", "fwoosh")
	squeak_override = list('sound/effects/extinguish.ogg' = 1)

/obj/item/toy/plush/slimeplushie
	name = "slime plushie"
	desc = "An adorable stuffed toy that resembles a slime. It is practically just a hacky sack."
	icon_state = "plushie_slime"
	inhand_icon_state = "plushie_slime"
	attack_verb_continuous = list("blorbles", "slimes", "absorbs")
	attack_verb_simple = list("blorble", "slime", "absorb")
	squeak_override = list('sound/effects/blobattack.ogg' = 1)
	gender = FEMALE	//given all the jokes and drawings, I'm not sure the xenobiologists would make a slimeboy

/obj/item/toy/plush/awakenedplushie
	name = "awakened plushie"
	desc = "An ancient plushie that has grown enlightened to the true nature of reality."
	icon_state = "plushie_awake"
	inhand_icon_state = "plushie_awake"

/obj/item/toy/plush/awakenedplushie/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/edit_complainer)

/obj/item/toy/plush/beeplushie
	name = "bee plushie"
	desc = "A cute toy that resembles an even cuter bee."
	icon_state = "plushie_h"
	inhand_icon_state = "plushie_h"
	attack_verb_continuous = list("stings")
	attack_verb_simple = list("sting")
	gender = FEMALE
	squeak_override = list('sound/voice/moth/scream_moth.ogg'=1)

/obj/item/toy/plush/goatplushie
	name = "strange goat plushie"
	icon_state = "goat"
	desc = "Despite its cuddly appearance and plush nature, it will beat you up all the same. Goats never change."
	squeak_override = list('sound/weapons/punch1.ogg'=1)

/obj/item/toy/plush/moth
	name = "moth plushie"
	desc = "A plushie depicting an adorable mothperson. It's a huggable bug!"
	icon_state = "moffplush"
	inhand_icon_state = "moffplush"
	attack_verb_continuous = list("flutters", "flaps")
	attack_verb_simple = list("flutter", "flap")
	squeak_override = list('sound/voice/moth/scream_moth.ogg'=1)
///Used to track how many people killed themselves with item/toy/plush/moth
	var/suicide_count = 0

/obj/item/toy/plush/moth/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] stares deeply into the eyes of [src] and it begins consuming [user.p_them()]!  It looks like [user.p_theyre()] trying to commit suicide!</span>")
	suicide_count++
	if(suicide_count < 3)
		desc = "A plushie depicting an unsettling mothperson. After killing [suicide_count] [suicide_count == 1 ? "person" : "people"] it's not looking so huggable now..."
	else
		desc = "A plushie depicting a creepy mothperson. It's killed [suicide_count] people! I don't think I want to hug it any more!"
		divine = TRUE
		resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	playsound(src, 'sound/hallucinations/wail.ogg', 50, TRUE, -1)
	var/list/available_spots = get_adjacent_open_turfs(loc)
	if(available_spots.len) //If the user is in a confined space the plushie will drop normally as the user dies, but in the open the plush is placed one tile away from the user to prevent squeak spam
		var/turf/open/random_open_spot = pick(available_spots)
		forceMove(random_open_spot)
	user.dust(just_ash = FALSE, drop_items = TRUE)
	return MANUAL_SUICIDE

/obj/item/toy/plush/pkplush
	name = "peacekeeper plushie"
	desc = "A plushie depicting a peacekeeper cyborg. Only you can prevent human harm!"
	icon_state = "pkplush"
	inhand_icon_state = "pkplush"
	attack_verb_continuous = list("hugs", "squeezes")
	attack_verb_simple = list("hug", "squeeze")
	squeak_override = list('sound/weapons/thudswoosh.ogg'=1)

/* LC plushes */
// The good guys
/obj/item/toy/plush/ayin
	name = "ayin plushie"
	desc = "A plushie depicting a researcher that did <b>nothing wrong</b>." // Fight me
	icon_state = "ayin"
	gender = MALE
	unique_pet = "You pet the ayin plushie, ayin did nothing wrong."

/obj/item/toy/plush/benjamin
	name = "benjamin plushie"
	desc = "A plushie depicting a researcher that resembles Hokma a bit too much."
	icon_state = "benjamin"
	gender = MALE

/obj/item/toy/plush/carmen
	name = "carmen plushie"
	desc = "A plushie depicting an ambitious and altruistic researcher."
	icon_state = "carmen"
	gender = FEMALE

// Sephirots
/obj/item/toy/plush/malkuth
	name = "malkuth plushie"
	desc = "A plushie depicting a diligent worker."
	icon_state = "malkuth"
	gender = FEMALE

/obj/item/toy/plush/yesod
	name = "yesod plushie"
	desc = "A plushie depicting a researcher in a turtleneck."
	icon_state = "yesod"
	gender = MALE

/obj/item/toy/plush/netzach
	name = "netzach plushie"
	desc = "A plushie depicting a person that likes alcohol a bit too much."
	icon_state = "netzach"
	gender = MALE

/obj/item/toy/plush/hod
	name = "hod plushie"
	desc = "A plushie depicting a person who hopes to make everything right."
	icon_state = "hod"
	gender = FEMALE

/obj/item/toy/plush/lisa
	name = "tiphereth-A plushie"
	desc = "A plushie depicting a person with high expectations."
	icon_state = "lisa"
	gender = FEMALE

/obj/item/toy/plush/enoch
	name = "tiphereth-B plushie"
	desc = "A plushie depicting an optimistic person with kind heart."
	icon_state = "enoch"
	gender = MALE

/obj/item/toy/plush/chesed
	name = "chesed plushie"
	desc = "A plushie depicting a sleepy person with a mug of coffee in their hand."
	icon_state = "chesed"
	gender = MALE

/obj/item/toy/plush/gebura
	name = "gebura plushie"
	desc = "A plushie depicting very strong and brave person."
	icon_state = "gebura"
	gender = FEMALE

/obj/item/toy/plush/hokma
	name = "hokma plushie"
	desc = "A plushie depicting a wise person with a fancy monocle. He knows much more than you."
	icon_state = "hokma"
	gender = MALE

/obj/item/toy/plush/binah
	name = "binah plushie"
	desc = "A plushie depicting a sadistic person who lacks any emotions."
	icon_state = "binah"
	gender = FEMALE

/obj/item/toy/plush/angela
	name = "angela plushie"
	desc = "A plushie depicting Lobotomy Corporation's AI."
	icon_state = "angela"
	gender = FEMALE

	//Limbus Sinners
/obj/item/toy/plush/yisang
	name = "yi sang plushie"
	desc = "A plushie depicting a ruminating sinner."
	icon_state = "yisang"
	attack_verb_continuous = list("shanks", "stabs")
	attack_verb_simple = list("shank", "stab")
	gender = MALE

/obj/item/toy/plush/faust
	name = "faust plushie"
	desc = "A plushie depicting an insufferable sinner."
	icon_state = "faust"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = FEMALE

/obj/item/toy/plush/don
	name = "don quixote plushie"
	desc = "A plushie depicting a heroic sinner."
	icon_state = "don"
	attack_verb_continuous = list("impales", "jousts")
	attack_verb_simple = list("impale", "joust")
	gender = FEMALE

/obj/item/toy/plush/ryoshu
	name = "ryoshu plushie"
	desc = "A plushie depicting a artistic sinner."
	icon_state = "ryoshu"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = FEMALE

/obj/item/toy/plush/meursault
	name = "meursault plushie"
	desc = "A plushie depicting a neutral sinner."
	icon_state = "meursault"
	attack_verb_continuous = list("bashes", "slams", "bludgeons")
	attack_verb_simple = list("bash", "slam", "bludgeon")
	gender = MALE

/obj/item/toy/plush/honglu
	name = "hong lu plushie"
	desc = "A plushie depicting a sheltered sinner."
	icon_state = "honglu"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = MALE

/obj/item/toy/plush/heathcliff
	name = "heathcliff plushie"
	desc = "A plushie depicting a brash sinner."
	icon_state = "heathcliff"
	attack_verb_continuous = list("bashes", "slams", "bludgeons")
	attack_verb_simple = list("bash", "slam", "bludgeon")
	gender = MALE

/obj/item/toy/plush/ishmael
	name = "ishmael plushie"
	desc = "A plushie depicting a reliable sinner."
	icon_state = "ishmael"
	attack_verb_continuous = list("bashes", "slams", "bludgeons")
	attack_verb_simple = list("bash", "slam", "bludgeon")
	gender = FEMALE

/obj/item/toy/plush/rodion
	name = "rodion plushie"
	desc = "A plushie depicting a backstreets born sinner."
	icon_state = "rodion"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = FEMALE

/obj/item/toy/plush/sinclair
	name = "sinclair plushie"
	desc = "A plushie depicting a insecure sinner."
	icon_state = "sinclair"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = MALE

/obj/item/toy/plush/dante
	name = "dante plushie"
	desc = "A plushie depicting a clock headed manager."
	icon_state = "dante"
	gender = MALE

/obj/item/toy/plush/outis
	name = "outis plushie"
	desc = "A plushie depicting a strategic sinner."
	icon_state = "outis"
	attack_verb_continuous = list("shanks", "stabs")
	attack_verb_simple = list("shank", "stab")
	gender = FEMALE

/obj/item/toy/plush/gregor
	name = "bug guy plushie"
	desc = "A plushie depicting a genetically altered sinner."
	icon_state = "gregor"
	attack_verb_continuous = list("shanks", "stabs")
	attack_verb_simple = list("shank", "stab")
	gender = MALE

// Misc LC stuff
/obj/item/toy/plush/pierre
	name = "pierre plushie"
	desc = "A plushie depicting a friendly cook."
	icon_state = "pierre"
	gender = FEMALE
	squeak_override = list('sound/effects/wow.ogg'=1)

/obj/item/toy/plush/myo
	name = "myo plushie"
	desc = "A plushie depicting a mercenary captain."
	icon_state = "myo"
	gender = FEMALE
	squeak_override = list('sound/effects/yem.ogg'=1)
	unique_pet = "You pet the myo plushie, yem."

/obj/item/toy/plush/rabbit
	name = "rabbit plushie"
	desc = "A plushie depicting a mercenary."
	icon_state = "rabbit"
	squeak_override = list('sound/effects/radio_clear.ogg'=1)

/obj/item/toy/plush/yuri
	name = "yuri plushie"
	desc = "A plushie depicting an L corp employee who had the potential to walk alongside the sinners."
	icon_state = "yuri"
	gender = FEMALE

/obj/item/toy/plush/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/food/grown/apple/gold))
		if(do_after(user, 2 SECONDS, target = user))
			user.visible_message("<span class='notice'>[src] is violently absorbed by the [I]!</span>")
			qdel(src)
			return
		to_chat(user, "<span class='notice'>You feel as if you prevented something weird and terrible from happening again.</span>")

/obj/item/toy/plush/samjo
	name = "samjo plushie"
	desc = "A plushie depicting a K corp secretary, their devotion deserved recognition."
	icon_state = "samjo"
	gender = MALE

/obj/item/toy/plush/blank
	name = "plushie blank"
	desc = "A humanoid plush that had been freshly made or stripped down to its cloth. Despite its lack of identity, the mere aknowelegement of this plushie makes it unique."
	icon_state = "blank"


// Abnormalities
/obj/item/toy/plush/qoh
	name = "queen of hatred plushie"
	desc = "A plushie depicting a magical girl whose goal is fighting all evil in the universe!"
	icon_state = "qoh"
	gender = FEMALE

/obj/item/toy/plush/kog
	name = "king of greed plushie"
	desc = "A plushie depicting a magical girl whose desires got the best of her."
	icon_state = "kog"
	gender = FEMALE
	unique_pet = "You pet the king of greed plushie, you swear it looks up to you hungirly."

/obj/item/toy/plush/kod
	name = "knight of despair plushie"
	desc = "A plushie depicting a magical girl who abandoned those who needed her most."
	icon_state = "kod"
	gender = FEMALE

/obj/item/toy/plush/sow
	name = "servant of wrath plushie"
	desc = "A plushie depicting a magical girl who was betrayed by someone they trusted dearly."
	icon_state = "sow"
	gender = FEMALE

/obj/item/toy/plush/nihil
	name = "jester of nihil plushie"
	desc = "A plushie depicting a black and white jester, usually found alongside the magical girls."
	icon_state = "nihil"

/obj/item/toy/plush/bigbird
	name = "big bird plushie"
	desc = "A plushie depicting a big bird with a lantern that burns forever. How does it even work..?"
	icon_state = "bigbird"

/obj/item/toy/plush/mosb
	name = "mountain of smiling bodies plushie"
	desc = "A plushie depicting a mountain of corpses merged into one. Yuck!"
	icon_state = "mosb"

/obj/item/toy/plush/big_bad_wolf
	name = "big and will be bad wolf plushie"
	desc = "A plushie depicting quite a not so bad and very much so marketable wolf plush."
	icon_state = "big_bad_wolf"

/obj/item/toy/plush/melt
	name = "melting love plushie"
	desc = "A plushie depicting a slime girl, you think."
	icon_state = "melt"
	attack_verb_continuous = list("blorbles", "slimes", "absorbs")
	attack_verb_simple = list("blorble", "slime", "absorb")
	squeak_override = list('sound/effects/blobattack.ogg' = 1)
	unique_pet = "You pet the melting love plushie... you swear it smiles and looks at you, yet when you blink the plushie returns to normal"

/obj/item/toy/plush/scorched
	name = "scorched girl plushie"
	desc = "A plushie depicting scorched girl."
	icon_state = "scorched"
	gender = FEMALE
	squeak_override = list('sound/abnormalities/scorchedgirl/pre_ability.ogg'=1)

/obj/item/toy/plush/pinocchio
	name = "pinocchio plushie"
	desc = "A plushie depicting pinocchio."
	icon_state = "pinocchio"

// Others
/obj/item/toy/plush/bongbong
	name = "bongbong plushie"
	desc = "A plushie depicting the Lobotomy Corporation"
	icon_state = "bongbong"
	unique_pet = "Bong"

/obj/item/toy/plush/fumo
	name = "cirno fumo"
	desc = "A plushie depicting an adorable ice fairy. It's cold to the touch."
	icon_state = "fumo_cirno"

// Special
/obj/item/toy/plush/bongy
	name = "bongy plushie"
	desc = "It looks like a raw chicken. A cute raw chicken!"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "bongy"
	squeak_override = list('sound/creatures/lc13/bongy/kweh.ogg'=1)
