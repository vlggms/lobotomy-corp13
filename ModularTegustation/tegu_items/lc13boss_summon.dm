
#define NORMAL_MODE 0
#define ACTIVE_MODE 1
#define REWARD_MODE 2

//LC13 Boss Books
/obj/item/lor_boss_book
	name = "book of gibberish"
	desc = "A collection of pages bound by some sort of leather or metal. This object has a mystical aura to it."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "lor"
	//If the book is currently releasing a monster or if the next interaction will give a reward.
	var/book_mode = NORMAL_MODE
	//If we spawn at a far away place.
	var/distant_spawn = TRUE
	//Glowing animation
	var/glow_animation = icon('icons/obj/bureaucracy.dmi', "lor_glow_overlay")
	//Reward item when the abnormality is killed
	var/obj/reward_item = /obj/item/rawpe
	//The monster we spawn
	var/mob/living/simple_animal/monster
	//The monster we currently have spawned
	var/mob/living/simple_animal/escapee
	//Abnormalities we can initialize containing
	var/list/abnos = list(
		/mob/living/simple_animal/hostile/abnormality/fragment,
		/mob/living/simple_animal/hostile/abnormality/my_sweet_home,
		/mob/living/simple_animal/hostile/abnormality/so_that_no_cry,
		/mob/living/simple_animal/hostile/abnormality/pinocchio,
		/mob/living/simple_animal/hostile/abnormality/steam,
		/mob/living/simple_animal/hostile/abnormality/jangsan,
		/mob/living/simple_animal/hostile/abnormality/helper,
		/mob/living/simple_animal/hostile/abnormality/golden_apple,
		/mob/living/simple_animal/hostile/abnormality/funeral,
		/mob/living/simple_animal/hostile/abnormality/blue_shepherd,
		)

/obj/item/lor_boss_book/Initialize()
	. = ..()
	FillBook()

/obj/item/lor_boss_book/attack_hand(mob/user)
	. = ..()
	if(book_mode == REWARD_MODE)
		WinReward(user)

/obj/item/lor_boss_book/attack_self(mob/user)
	if(book_mode == REWARD_MODE)
		WinReward(user)
		return
	if(book_mode == ACTIVE_MODE || !monster || escapee)
		to_chat(user, span_notice("The pages of the book are empty."))
		return
	if(!iscarbon(user))
		to_chat(user, span_notice("The book refuses to open."))
		return
	visible_message(span_warning("[src] opens up and begins to turn its pages rapidly!"))
	book_mode = ACTIVE_MODE
	ReleasePrisioner(user)

/obj/item/lor_boss_book/Destroy()
	UnregisterSignal(escapee, COMSIG_LIVING_DEATH)
	return ..()

/obj/item/lor_boss_book/proc/WinReward(mob/living/carbon/user)
	visible_message(span_nicegreen("The book dissolves leaving behind a reward."))
	var/obj/item/I = new reward_item(get_turf(src))
	I.name = "[initial(monster.name)] [I.name]"
	qdel(src)

/obj/item/lor_boss_book/proc/FillBook()
	if(!monster && abnos.len)
		monster = pick(abnos)
	name = "sealed [initial(monster.name)]"

//Buildup to releasing the sealed abnormality.
/obj/item/lor_boss_book/proc/ReleasePrisioner(mob/living/librarian)
	if(QDELETED(src))
		return
	src.forceMove(get_turf(src))
	icon_state = "lor_open"
	add_overlay(glow_animation)
	//In total it should take 5 minutes or five page turns to release the abnormality. This is to prevent people from opening a book in a crowd.
	for(var/i = 1 to 5)
		sleep(1 SECONDS)
		if(QDELETED(src))
			return
		if(PreventSummonCondition())
			icon_state = "lor"
			book_mode = NORMAL_MODE
			cut_overlay(glow_animation)
			return
		playsound(get_turf(src), 'sound/effects/pageturn1.ogg', 45, 3, 3)
		flick("lor_flip", src)

	escapee = BuildPrisioner(ChooseSummonLocation(), monster)
	cut_overlay(glow_animation)
	playsound(get_turf(src), 'sound/effects/whirthunk.ogg', 50, 3, 3)
	new /obj/effect/temp_visual/turn_book(get_turf(src))

//Conditions to prevent summmoning.
/obj/item/lor_boss_book/proc/PreventSummonCondition()
	if(iscarbon(loc))
		//If the book isnt on the floor then it wont open.
		var/mob/living/carbon/C = loc
		to_chat(C, span_notice("The book is held closed in your inventory."))
		return TRUE
	if(!isturf(loc))
		return TRUE

/* Chooses where to summon based on if there is
	distortion landmarks. If no distortion landmarks
	just put it where the book is.
	Yes i know there is also the visible message included
	in this proc im just too tired to seperate that into
	its own thing and it only changes based on the same
	criteria.*/
/obj/item/lor_boss_book/proc/ChooseSummonLocation()
	if(distant_spawn && LAZYLEN(SScityevents.distortion))
		//What are the visual or signature differences between distortions and abnormalities?
		minor_announce("DANGER: Distortion located in the backstreets. Hana has issued a suppression order.", "Local Activity Alert:", TRUE)
		visible_message(span_warning("Light pours out of [src] before darting into the backstreets!"))
		return get_turf(pick(SScityevents.distortion))
	visible_message(span_warning("Something crawls out of [src]!"))
	return get_turf(src)


//Builds the prisioner.
/obj/item/lor_boss_book/proc/BuildPrisioner(turf/spawn_turf, mob/living/L)
	anchored = TRUE
	name = "weird book"
	desc = "An open book that appears to be stuck in place."
	var/mob/living/mon = new L(spawn_turf)
	if(isabnormalitymob(mon))
		var/mob/living/simple_animal/hostile/abnormality/A = mon
		if(!A)
			return
		A.BreachEffect(null, BREACH_PINK)
	RegisterSignal(mon, COMSIG_LIVING_DEATH, .proc/Reward)
	return mon

//Deletes released abno and changes to reward mode.
/obj/item/lor_boss_book/proc/Reward()
	SIGNAL_HANDLER

	//Abnormalities auto clean up themselves.
	if(escapee && !isabnormalitymob(escapee))
		qdel(escapee)
	book_mode = REWARD_MODE
	color = COLOR_VIVID_YELLOW


/*
* Book that contains Waw Level Abnormalities
*/
/obj/item/lor_boss_book/waw
	abnos = list(
		/mob/living/simple_animal/hostile/abnormality/big_bird,
		/mob/living/simple_animal/hostile/abnormality/nosferatu,
		/mob/living/simple_animal/hostile/abnormality/sphinx,
		/mob/living/simple_animal/hostile/abnormality/warden,
		)
/*
* Book that contains Aleph Level Abnormalities
* Now is the time of monsters.
*/
/obj/item/lor_boss_book/aleph
	abnos = list(
		/mob/living/simple_animal/hostile/abnormality/mountain,
		/mob/living/simple_animal/hostile/abnormality/nothing_there,
		/mob/living/simple_animal/hostile/abnormality/melting_love,
		/mob/living/simple_animal/hostile/abnormality/censored,
		/mob/living/simple_animal/hostile/abnormality/distortedform,
		)

//Special Varient for people who summon abnormalities.
/obj/item/lor_boss_book/librarian
	distant_spawn = FALSE

/obj/item/lor_boss_book/librarian/Initialize()
	. = ..()
	name += " librarian copy"

/obj/item/lor_boss_book/librarian/PreventSummonCondition()
	return

/obj/item/lor_boss_book/librarian/ReleasePrisioner(mob/living/librarian)
	. = ..()
	escapee.faction = librarian.faction.Copy()

#undef NORMAL_MODE
#undef ACTIVE_MODE
#undef REWARD_MODE
