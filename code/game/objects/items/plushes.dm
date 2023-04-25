#define PLUSH_ABNORMALITY "abno"
#define PLUSH_MAGICAL_GIRL "magical girl"
#define PLUSH_SINNER "sinner"
#define PLUSH_OTHER "other"
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
	name = "space carp plushie"
	desc = "An adorable stuffed toy that resembles a space carp."
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
	desc = "A stuffed toy that resembles a syndicate nuclear operative. The tag claims operatives to be purely fictitious."
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
/obj/item/toy/plush/fighter
	name = "fighting plushie"
	desc = "A plushie that will battle with other certain plushies."
	/// The plushie's type.
	var/plush_type = PLUSH_OTHER
	/// Whether or not the Plushie is currently in a fight.
	var/fighting = FALSE
	/// List of lines that can be said at fight start.
	var/list/fight_start_lines = list(
		"It's time to duel!",
		"LEEEEEEEROOOOYYYYY",
		"I'm here to kill chaos.",
		"OH YEAH!",
		"In the name of charge and draw, I'm the Magical Girl of Face Lasers~!",
		"Kill.",
		"Never should have come here!",
		"Skyrim belongs to the nords!",
		"=)",
		"They sent you against me? What a suicide mission.",
		"Yes!"
	)
	/// Sounds played when this plushie is in a fight
	var/list/fight_sfx = list()
	/// % chance to win the fight, if the src is battle target.
	var/fighting_force = 100
	/// Fight participants, used if src is battle target.
	var/list/threats = list()
	/// Sfx played when a fighter lacks SFX.
	var/list/generic_sfx = list(
		'sound/weapons/genhit1.ogg',
		'sound/weapons/genhit2.ogg',
		'sound/weapons/genhit3.ogg',
		'sound/weapons/parry.ogg',
		'sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/slash.ogg'
	)
	/// Lines that are said in combat.
	var/list/in_combat_lines = list(
		"Hya!"
	)
	/// Say all lines in "win_lines" on win, or just one randomly.
	var/say_all_win = TRUE
	/// Line(s) to say on win.
	var/list/win_lines = list(
		"HYA! I think he got. THE POINT."
	)
	/// Say all lines in "lose_lines" on loss, or just one randomly.
	var/say_all_lose = TRUE
	/// Line(s) to say on loss.
	var/list/lose_lines = list(
		":("
	)

/obj/item/toy/plush/fighter/attack_hand(mob/user)
	if(fighting)
		to_chat(user, "<span class='warning'>[src] is busy fighting!</span>")
		return FALSE
	return ..()

/obj/item/toy/plush/fighter/Moved(atom/OldLoc, Dir)
	set waitfor = FALSE
	. = ..()
	if(fighting)
		return
	for(var/obj/item/toy/plush/fighter/Fighter in view(1, src))
		if(Fighter.plush_type == plush_type)
			continue
		if(plush_type != PLUSH_ABNORMALITY)
			Fighter.Fight()
		else
			Fight()
		break
	return

/// The target acquisition that starts a fight.
/obj/item/toy/plush/fighter/proc/Fight()
	fighting = TRUE
	say(pick(fight_start_lines))
	sleep(1 SECONDS)
	threats = list()
	for(var/obj/item/toy/plush/fighter/F in view(7, src))
		if(F.plush_type == plush_type) // Abnos don't fight abnos, Sinners don't fight Sinners, Magical Girls don't fight Magical Girls.
			continue
		threats |= F
		F.fighting = TRUE
		F.say(pick(F.fight_start_lines))
	if(threats.len < 1)
		fighting = FALSE
		return
	Conflict()

/// The fight loop and decision.
/obj/item/toy/plush/fighter/proc/Conflict()
	var/atom/throw_target
	var/loop_count = 0
	do
		for(var/obj/item/toy/plush/fighter/dante/D in threats)
			for(var/obj/item/toy/plush/fighter/Sinner in view(7, D))
				if(!Sinner.fighting && Sinner.plush_type == PLUSH_SINNER)
					Sinner.fighting = TRUE
					threats |= Sinner
			break
		var/obj/item/toy/plush/fighter/F = pick(threats)
		if(!istype(F))
			threats -= F
			continue
		if(istype(F, /obj/item/toy/plush/fighter/dante))
			continue
		if(!(F in view(9, src)))
			F.say("No!")
			F.visible_message("<span class='warning'>[F] yells as it falls out of the fight!</span>")
			threats -= F
			continue
		if(threats.len <= 0)
			say("I don’t know what awaits me ahead. Could it be a cliff, or a ditch?")
			fighting = FALSE
			return
		if(F.plush_type == PLUSH_SINNER && prob(20))
			F.visible_message("[F] is killed by [src]!")
			threats -= F
			F.FightLose()
		else
			if(prob(80))
				throw_target = pick(get_adjacent_open_turfs(src))
				F.throw_at(throw_target, 4, 2, null, TRUE)
			if(prob(10))
				F.say(pick(F.in_combat_lines))
			sleep(25/(threats.len+loop_count))
			if(F.fight_sfx.len <= 0)
				playsound(F, pick(generic_sfx), rand(40, 60))
			else
				playsound(F, pick(F.fight_sfx), rand(40, 60))
		var/list/targets = threats.Copy()
		targets -= F
		if(targets.len <= 0)
			targets += F
		throw_target = pick(get_adjacent_open_turfs(pick(targets)))
		throw_at(throw_target, 5, 3, null, TRUE)
		if(prob(5))
			say(pick(in_combat_lines))
		if(fight_sfx.len <= 0)
			playsound(src, pick(generic_sfx), rand(40,60))
		else
			playsound(src, pick(fight_sfx), rand(40, 60))
		loop_count++
		sleep(30/(threats.len+loop_count))
	while(prob(100 + threats.len - loop_count))
	if(prob(CalculateWin()))
		return FightWin()
	return FightLose()

/// Does the math for if you win or not, returns a % win chance.
/obj/item/toy/plush/fighter/proc/CalculateWin()
	var/effective_force = fighting_force
	for(var/obj/item/toy/plush/fighter/F in threats)
		effective_force -= 10
	return effective_force

/obj/item/toy/plush/fighter/proc/FightWin()
	set waitfor = FALSE
	fighting = FALSE
	if(plush_type == PLUSH_ABNORMALITY)
		for(var/obj/item/toy/plush/fighter/F in threats)
			F.FightLose()
	if(say_all_win)
		for(var/line in win_lines)
			say(line)
			sleep(1 SECONDS)
	else
		say(pick(win_lines))
	return

/obj/item/toy/plush/fighter/proc/FightLose()
	set waitfor = FALSE
	fighting = FALSE
	if(say_all_lose)
		for(var/line in lose_lines)
			say(line)
			sleep(1 SECONDS)
	else
		say(pick(lose_lines))
	return

/obj/item/toy/plush/fighter/yisang
	name = "yi sang plushie"
	desc = "A plushie depicting a ruminating sinner."
	icon_state = "yisang"
	attack_verb_continuous = list("shanks", "stabs")
	attack_verb_simple = list("shank", "stab")
	gender = MALE
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/faust
	name = "faust plushie"
	desc = "A plushie depicting an insufferable sinner."
	icon_state = "faust"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = FEMALE
	squeak_override = list('sound/effects/plushies/faust.ogg'=1)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/don
	name = "don quixote plushie"
	desc = "A plushie depicting a heroic sinner."
	icon_state = "don"
	attack_verb_continuous = list("impales", "jousts")
	attack_verb_simple = list("impale", "joust")
	gender = FEMALE
	squeak_override = list('sound/effects/plushies/donscream.ogg'=1)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/ryoshu
	name = "ryoshu plushie"
	desc = "A plushie depicting a artistic sinner."
	icon_state = "ryoshu"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = FEMALE
	squeak_override = list('sound/effects/plushies/ryoshu.ogg'=1)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/meursault
	name = "meursault plushie"
	desc = "A plushie depicting a neutral sinner."
	icon_state = "meursault"
	attack_verb_continuous = list("bashes", "slams", "bludgeons")
	attack_verb_simple = list("bash", "slam", "bludgeon")
	gender = MALE
	squeak_override = list(
		'sound/effects/plushies/moresalt.ogg'=90,
		'sound/effects/plushies/moresalt_long.ogg'=10
		)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/honglu
	name = "hong lu plushie"
	desc = "A plushie depicting a sheltered sinner."
	icon_state = "honglu"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = MALE
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/heathcliff
	name = "heathcliff plushie"
	desc = "A plushie depicting a brash sinner."
	icon_state = "heathcliff"
	attack_verb_continuous = list("bashes", "slams", "bludgeons")
	attack_verb_simple = list("bash", "slam", "bludgeon")
	gender = MALE
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/ishmael
	name = "ishmael plushie"
	desc = "A plushie depicting a reliable sinner."
	icon_state = "ishmael"
	attack_verb_continuous = list("bashes", "slams", "bludgeons")
	attack_verb_simple = list("bash", "slam", "bludgeon")
	gender = FEMALE
	squeak_override = list('sound/effects/plushies/ishmael.ogg'=1)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/rodion
	name = "rodion plushie"
	desc = "A plushie depicting a backstreets born sinner."
	icon_state = "rodion"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = FEMALE
	squeak_override = list('sound/effects/plushies/rodiyon.ogg'=1)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/sinclair
	name = "sinclair plushie"
	desc = "A plushie depicting a insecure sinner."
	icon_state = "sinclair"
	attack_verb_continuous = list("slices", "cleaves")
	attack_verb_simple = list("slice", "cleaves")
	gender = MALE
	squeak_override = list('sound/effects/plushies/sinclair.ogg'=1)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/dante
	name = "dante plushie"
	desc = "A plushie depicting a clock headed manager."
	icon_state = "dante"
	gender = MALE
	squeak_override = list('sound/effects/clock_tick.ogg'=1)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/outis
	name = "outis plushie"
	desc = "A plushie depicting a strategic sinner."
	icon_state = "outis"
	attack_verb_continuous = list("shanks", "stabs")
	attack_verb_simple = list("shank", "stab")
	gender = FEMALE
	squeak_override = list(
		'sound/effects/plushies/outism.ogg'=90,
		'sound/effects/plushies/oddysey.ogg'=10
		)
	plush_type = PLUSH_SINNER

/obj/item/toy/plush/fighter/gregor
	name = "bug guy plushie"
	desc = "A plushie depicting a genetically altered sinner."
	icon_state = "gregor"
	attack_verb_continuous = list("shanks", "stabs")
	attack_verb_simple = list("shank", "stab")
	gender = MALE
	squeak_override = list('sound/effects/plushies/gregor.ogg'=1)
	plush_type = PLUSH_SINNER

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
	squeak_override = list('sound/effects/plushies/yem.ogg'=1)

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

/obj/item/toy/plush/blank
	name = "plushie blank"
	desc = "A humanoid plush that had been freshly made or stripped down to its cloth. Despite its lack of identity, the mere aknowelegement of this plushie makes it unique."
	icon_state = "blank"


// Abnormalities
/obj/item/toy/plush/fighter/magical_girl
	name = "A magical girl plushie"
	desc = "You shouldn't be seeing this one!"
	gender = FEMALE
	fight_start_lines = list("In the name of Love and Justice~ Here comes Magical Girl!")
	plush_type = PLUSH_MAGICAL_GIRL
	in_combat_lines = list("Hya!")
	say_all_win = FALSE
	say_all_lose = FALSE
	var/summoned = FALSE
	var/list/adjacent_girls = list()

/obj/item/toy/plush/fighter/magical_girl/Moved(atom/OldLoc, Dir)
	var/obj/item/toy/plush/fighter/nihil/N = locate() in view(1, src)
	if(N)
		return ..()
	if(!summoned)
		SummonNihil()
		return
	return ..()

/obj/item/toy/plush/fighter/magical_girl/proc/SummonNihil()
	adjacent_girls = list()
	for(var/direction in list(NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST))
		for(var/obj/item/toy/plush/fighter/magical_girl/MG1 in get_step(src, direction))
			if(MG1.type == src.type)
				continue
			var/skip = FALSE
			for(var/obj/item/toy/plush/fighter/magical_girl/MG2 in adjacent_girls)
				if(MG1.type != MG2.type)
					continue
				skip = TRUE
				break
			if(skip)
				continue
			adjacent_girls |= MG1
			break
	if(adjacent_girls.len != 2)
		return
	var/dir1 = get_dir(src, adjacent_girls[1]) // Compare directions
	var/dir2 = get_dir(src, adjacent_girls[2])
	var/dir3
	for(var/cardinal in GLOB.cardinals)
		if((dir1 & cardinal) && (dir2 & cardinal))
			dir3 = cardinal
			break
	for(var/obj/item/toy/plush/fighter/magical_girl/MG1 in get_ranged_target_turf(src, dir3, 2))
		var/skip = FALSE
		for(var/obj/item/toy/plush/fighter/magical_girl/MG2 in adjacent_girls)
			if(MG1.type != MG2.type)
				continue
			skip = TRUE
			break
		if(skip)
			continue
		adjacent_girls |= MG1
		break
	if(adjacent_girls.len != 3)
		return
	var/turf/open/target_turf = get_step(src, dir3)
	if(!istype(target_turf))
		return
	adjacent_girls += src
	var/list/dep_cent = list()
	for(var/obj/item/toy/plush/fighter/magical_girl/magical_girl in adjacent_girls)
		if(dep_cent.len <= 0)
			dep_cent = GLOB.department_centers.Copy()
		magical_girl.summoned = TRUE
		var/turf/open/move_to = pick(dep_cent)
		dep_cent -= move_to
		magical_girl.forceMove(move_to)
		playsound(magical_girl, 'sound/abnormalities/hatredqueen/beam_end.ogg', 50)
	var/obj/item/toy/plush/fighter/nihil/N = new(target_turf)
	playsound(target_turf, 'sound/abnormalities/nihil/filter.ogg', 60)
	playsound(target_turf, 'sound/abnormalities/hatredqueen/beam_end.ogg', 40)
	N.visible_message("<span class='userdanger'>[N] banishes the magical girl plushies to other departments around the facility!</span>")
	return

/obj/item/toy/plush/fighter/magical_girl/qoh
	name = "queen of hatred plushie"
	desc = "A plushie depicting a magical girl whose goal is fighting all evil in the universe!"
	icon_state = "qoh"
	fight_sfx = list(
		'sound/abnormalities/hatredqueen/gun.ogg',
		'sound/abnormalities/hatredqueen/attack.ogg'
	)
	fight_start_lines = list(
		"Don’t worry. You guys will be safe as long as I’m here!",
		"You can count on me any time! I’ll keep you safe.",
		"A true magical girl never runs away in the face of any hardships!",
		"Tell me if anything bad happens, okay? I know I can help you!",
		"Please feel free to call me whenever there’s danger~!"
		)
	win_lines = list("ARCANA SLAVE!!!")
	lose_lines = list("I swore I would protect everyone to the end…")

/obj/item/toy/plush/fighter/magical_girl/kog
	name = "king of greed plushie"
	desc = "A plushie depicting a magical girl whose desires got the best of her."
	icon_state = "kog"
	fight_sfx = list(
		'sound/abnormalities/greedking/greed_human_punch.ogg',
		'sound/abnormalities/greedking/greed_human_gold.ogg'
	)
	fight_start_lines = list(
		"Wishing for everyone’s happiness must include my own, too...",
		"Is it so bad to lust for honey when there are flowers?",
		"Alright, I’m about to get serious, so try and stop me.",
		"It’s been a long while… since I fought in this form.",
		"Are you ready? Let’s get started."
		)
	win_lines = list("I’m still going so easy... Isn’t this a pushover?")
	lose_lines = list("I’ll become happy if my stomach is full… I want to be happy…")

/obj/item/toy/plush/fighter/magical_girl/kod
	name = "knight of despair plushie"
	desc = "A plushie depicting a magical girl who abandoned those who needed her most."
	icon_state = "kod"
	fight_sfx = list(
		'sound/abnormalities/despairknight/attack.ogg',
		'sound/abnormalities/despairknight/gift.ogg'
	)
	fight_start_lines = list(
		"Worry not. I’ll keep you safe this time.",
		"I vowed to this sharp sword, whetted with tears on an anvil of despair.",
		"As with sorrow, perhaps sharing the burden will blunt the edge.",
		"The edge of this sword sharpened with tears and despair... is keen and precise..."
		)
	win_lines = list("To protect the innocent!")
	lose_lines = list("Just end me, please… So I can’t hold my blade ever again…")

/obj/item/toy/plush/fighter/magical_girl/sow
	name = "servant of wrath plushie"
	desc = "A plushie depicting a magical girl who was betrayed by someone they trusted dearly."
	icon_state = "sow"
	fight_sfx = list(
		'sound/abnormalities/wrath_servant/small_smash1.ogg',
		'sound/abnormalities/wrath_servant/small_smash2.ogg'
	)
	fight_start_lines = list(
		"That’s why I lost; I fell to my beloved companion.",
		"We were true friends.",
		"For the Justice and Balance of this land...",
		"We're friends, those who help each other."
		)
	win_lines = list("For the Justice and balance of this land!")
	lose_lines = list("Justice and balance… needed to… be upheld!!!")

/obj/item/toy/plush/fighter/nihil
	name = "jester of nihil plushie"
	desc = "A plushie depicting a black and white jester, usually found alongside the magical girls."
	icon_state = "nihil"
	fight_start_lines = list("...Did you make me, or did I make you?")
	plush_type = PLUSH_ABNORMALITY
	fight_sfx = list(
		'sound/abnormalities/nihil/filter.ogg',
		'sound/abnormalities/nihil/attack.ogg'
	)
	say_all_win = FALSE
	win_lines = list("My mind is a void, my thoughts empty. I become more fearless as they become more vacant.")
	lose_lines = list(
		"I slowly traced the road back. It’s the road you would’ve taken.",
		"Blinded by carnal desires and jealousy, willingly walking to the edge of the cliff.",
		"Everybody’s agony becomes one."
	)
	in_combat_lines = list("...")

/obj/item/toy/plush/fighter/nihil/Fight()
	. = ..()
	for(var/obj/item/toy/plush/fighter/F in threats)
		in_combat_lines |= F.in_combat_lines
	return

/obj/item/toy/plush/fighter/nihil/FightWin()
	var/turf/throw_target
	for(var/obj/item/toy/plush/P in threats)
		throw_target = get_edge_target_turf(P, get_dir(src, P))
		P.throw_at(throw_target, 2, 4, null, TRUE)
	playsound(src, 'sound/abnormalities/nihil/attack.ogg', 80)
	sleep(5)
	for(var/obj/item/toy/plush/fighter/magical_girl/MG in threats)
		MG.visible_message("<span class='warning'>[src] drags [MG] into nothingness!</span>")
		MG.Destroy()
	return ..()

/obj/item/toy/plush/fighter/nihil/FightLose()
	. = ..()
	visible_message("<span class='nicegreen'>[src] fades away into nothing.</span>")
	return Destroy()

/obj/item/toy/plush/fighter/bigbird
	name = "big bird plushie"
	desc = "A plushie depicting a big bird with a lantern that burns forever. How does it even work..?"
	icon_state = "bigbird"
	plush_type = PLUSH_ABNORMALITY

/obj/item/toy/plush/fighter/mosb
	name = "mountain of smiling bodies plushie"
	desc = "A plushie depicting a mountain of corpses merged into one. Yuck!"
	icon_state = "mosb"
	plush_type = PLUSH_ABNORMALITY

/obj/item/toy/plush/fighter/big_bad_wolf
	name = "big and will be bad wolf plushie"
	desc = "A plushie depicting quite a not so bad and very much so marketable wolf plush."
	icon_state = "big_bad_wolf"
	plush_type = PLUSH_ABNORMALITY

/obj/item/toy/plush/fighter/melt
	name = "melting love plushie"
	desc = "A plushie depicting a slime girl, you think."
	icon_state = "melt"
	attack_verb_continuous = list("blorbles", "slimes", "absorbs")
	attack_verb_simple = list("blorble", "slime", "absorb")
	squeak_override = list('sound/effects/blobattack.ogg' = 1)
	plush_type = PLUSH_ABNORMALITY

/obj/item/toy/plush/fighter/scorched
	name = "scorched girl plushie"
	desc = "A plushie depicting scorched girl."
	icon_state = "scorched"
	gender = FEMALE
	squeak_override = list('sound/abnormalities/scorchedgirl/pre_ability.ogg'=1)
	plush_type = PLUSH_ABNORMALITY

// Others
/obj/item/toy/plush/bongbong
	name = "bongbong plushie"
	desc = "A plushie depicting the Lobotomy Corporation"
	icon_state = "bongbong"

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
