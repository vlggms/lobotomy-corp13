
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/effects/pageturn1.ogg','sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'), 30, TRUE)
	if(do_after(user, 5 SECONDS, src))
		if(remarks.len)
			to_chat(user, "<span class='notice'>[pick(remarks)]</span>")
		else
			to_chat(user, "<span class='notice'>You keep reading...</span>")
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading [name]...</span>")

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, "<span class='notice'>You stop reading...</span>")

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You finish reading [name]!</span>")

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/user)
	if(reading)
		to_chat(user, "<span class='warning'>You're already reading this!</span>")
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
	if(used)
		if(oneuse)
			recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			on_reading_stopped()
			reading = FALSE
			return
	if(do_after(user, 5 SECONDS, src))
		on_reading_finished(user)
	reading = FALSE
	return TRUE

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "catching bugs" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, "<span class='warning'>You already know all about [actionname]!</span>")
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading about [actionname]...</span>")

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You feel like you've got a good handle on [actionname]!</span>")
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

/obj/item/book/granter/action/origami
	granted_action = /datum/action/innate/origami
	name = "The Art of Origami"
	desc = "A meticulously in-depth manual explaining the art of paper folding."
	icon_state = "origamibook"
	actionname = "origami"
	oneuse = TRUE
	remarks = list("Dead-stick stability...", "Symmetry seems to play a rather large factor...", "Accounting for crosswinds... really?", "Drag coefficients of various paper types...", "Thrust to weight ratios?", "Positive dihedral angle?", "Center of gravity forward of the center of lift...")

/datum/action/innate/origami
	name = "Origami Folding"
	desc = "Toggles your ability to fold and catch robust paper airplanes."
	button_icon_state = "origami_off"
	check_flags = NONE

/datum/action/innate/origami/Activate()
	to_chat(owner, "<span class='notice'>You will now fold origami planes.</span>")
	button_icon_state = "origami_on"
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/origami/Deactivate()
	to_chat(owner, "<span class='notice'>You will no longer fold origami planes.</span>")
	button_icon_state = "origami_off"
	active = FALSE
	UpdateButtonIcon()

///SPELLS///

/obj/item/book/granter/spell
	var/spell
	var/spellname = "conjure bugs"

/obj/item/book/granter/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == spell)
			if(user.mind)
				if(iswizard(user))
					to_chat(user,"<span class='warning'>You're already far more versed in this spell than this flimsy how-to book can provide!</span>")
				else
					to_chat(user,"<span class='warning'>You've already read this one!</span>")
			return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading about casting [spellname]...</span>")

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You feel like you've experienced enough to cast [spellname]!</span>")
	var/obj/effect/proc_holder/spell/S = new spell
	user.mind.AddSpell(S)
	user.log_message("learned the spell [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/recoil(mob/user)
	user.visible_message("<span class='warning'>[src] glows in a black light!</span>")

/obj/item/book/granter/spell/onlearned(mob/user)
	..()
	if(oneuse)
		user.visible_message("<span class='warning'>[src] glows dark for a second!</span>")

/obj/item/book/granter/spell/fireball
	spell = /obj/effect/proc_holder/spell/aimed/fireball
	spellname = "fireball"
	icon_state ="bookfireball"
	desc = "This book feels warm to the touch."
	remarks = list("Aim...AIM, FOOL!", "Just catching them on fire won't do...", "Accounting for crosswinds... really?", "I think I just burned my hand...", "Why the dumb stance? It's just a flick of the hand...", "OMEE... ONI... Ugh...", "What's the difference between a fireball and a pyroblast...")

/obj/item/book/granter/spell/fireball/recoil(mob/user)
	..()
	explosion(user.loc, 1, 0, 2, 3, FALSE, FALSE, 2)
	qdel(src)

/obj/item/book/granter/spell/sacredflame
	spell = /obj/effect/proc_holder/spell/targeted/sacred_flame
	spellname = "sacred flame"
	icon_state ="booksacredflame"
	desc = "Become one with the flames that burn within... and invite others to do so as well."
	remarks = list("Well, it's one way to stop an attacker...", "I'm gonna need some good gear to stop myself from burning to death...", "Keep a fire extinguisher handy, got it...", "I think I just burned my hand...", "Apply flame directly to chest for proper ignition...", "No pain, no gain...", "One with the flame...")

/obj/item/book/granter/spell/smoke
	spell = /obj/effect/proc_holder/spell/targeted/smoke
	spellname = "smoke"
	icon_state ="booksmoke"
	desc = "This book is overflowing with the dank arts."
	remarks = list("Smoke Bomb! Heh...", "Smoke bomb would do just fine too...", "Wait, there's a machine that does the same thing in chemistry?", "This book smells awful...", "Why all these weed jokes? Just tell me how to cast it...", "Wind will ruin the whole spell, good thing we're in space... Right?", "So this is how the spider clan does it...")

/obj/item/book/granter/spell/smoke/lesser //Chaplain smoke book
	spell = /obj/effect/proc_holder/spell/targeted/smoke/lesser

/obj/item/book/granter/spell/smoke/recoil(mob/user)
	..()
	to_chat(user,"<span class='warning'>Your stomach rumbles...</span>")
	if(user.nutrition)
		user.set_nutrition(200)
		if(user.nutrition <= 0)
			user.set_nutrition(0)

/obj/item/book/granter/spell/blind
	spell = /obj/effect/proc_holder/spell/pointed/trigger/blind
	spellname = "blind"
	icon_state ="bookblind"
	desc = "This book looks blurry, no matter how you look at it."
	remarks = list("Well I can't learn anything if I can't read the damn thing!", "Why would you use a dark font on a dark background...", "Ah, I can't see an Oh, I'm fine...", "I can't see my hand...!", "I'm manually blinking, damn you book...", "I can't read this page, but somehow I feel like I learned something from it...", "Hey, who turned off the lights?")

/obj/item/book/granter/spell/blind/recoil(mob/user)
	..()
	to_chat(user,"<span class='warning'>You go blind!</span>")
	user.blind_eyes(10)

/obj/item/book/granter/spell/mindswap
	spell = /obj/effect/proc_holder/spell/pointed/mind_transfer
	spellname = "mindswap"
	icon_state ="bookmindswap"
	desc = "This book's cover is pristine, though its pages look ragged and torn."
	remarks = list("If you mindswap from a mouse, they will be helpless when you recover...", "Wait, where am I...?", "This book is giving me a horrible headache...", "This page is blank, but I feel words popping into my head...", "GYNU... GYRO... Ugh...", "The voices in my head need to stop, I'm trying to read here...", "I don't think anyone will be happy when I cast this spell...")
	/// Mob used in book recoils to store an identity for mindswaps
	var/mob/living/stored_swap

/obj/item/book/granter/spell/mindswap/onlearned()
	spellname = pick("fireball","smoke","blind","forcewall","knock","barnyard","charge")
	icon_state = "book[spellname]"
	name = "spellbook of [spellname]" //Note, desc doesn't change by design
	..()

/obj/item/book/granter/spell/mindswap/recoil(mob/user)
	..()
	if(stored_swap in GLOB.dead_mob_list)
		stored_swap = null
	if(!stored_swap)
		stored_swap = user
		to_chat(user,"<span class='warning'>For a moment you feel like you don't even know who you are anymore.</span>")
		return
	if(stored_swap == user)
		to_chat(user,"<span class='notice'>You stare at the book some more, but there doesn't seem to be anything else to learn...</span>")
		return
	var/obj/effect/proc_holder/spell/pointed/mind_transfer/swapper = new
	if(swapper.cast(list(stored_swap), user, TRUE))
		to_chat(user,"<span class='warning'>You're suddenly somewhere else... and someone else?!</span>")
		to_chat(stored_swap,"<span class='warning'>Suddenly you're staring at [src] again... where are you, who are you?!</span>")
	else
		user.visible_message("<span class='warning'>[src] fizzles slightly as it stops glowing!</span>") //if the mind_transfer failed to transfer mobs, likely due to the target being catatonic.

	stored_swap = null

/obj/item/book/granter/spell/forcewall
	spell = /obj/effect/proc_holder/spell/targeted/forcewall
	spellname = "forcewall"
	icon_state ="bookforcewall"
	desc = "This book has a dedication to mimes everywhere inside the front cover."
	remarks = list("I can go through the wall! Neat.", "Why are there so many mime references...?", "This would cause much grief in a hallway...", "This is some surprisingly strong magic to create a wall nobody can pass through...", "Why the dumb stance? It's just a flick of the hand...", "Why are the pages so hard to turn, is this even paper?", "I can't mo Oh, i'm fine...")

/obj/item/book/granter/spell/forcewall/recoil(mob/living/user)
	..()
	to_chat(user,"<span class='warning'>You suddenly feel very solid!</span>")
	user.Stun(40, ignore_canstun = TRUE)
	user.petrify(60)

/obj/item/book/granter/spell/knock
	spell = /obj/effect/proc_holder/spell/aoe_turf/knock
	spellname = "knock"
	icon_state ="bookknock"
	desc = "This book is hard to hold closed properly."
	remarks = list("Open Sesame!", "So THAT'S the magic password!", "Slow down, book. I still haven't finished this page...", "The book won't stop moving!", "I think this is hurting the spine of the book...", "I can't get to the next page, it's stuck t- I'm good, it just turned to the next page on it's own.", "Yeah, staff of doors does the same thing. Go figure...")

/obj/item/book/granter/spell/knock/recoil(mob/living/user)
	..()
	to_chat(user,"<span class='warning'>You're knocked down!</span>")
	user.Paralyze(40)

/obj/item/book/granter/spell/barnyard
	spell = /obj/effect/proc_holder/spell/pointed/barnyardcurse
	spellname = "barnyard"
	icon_state ="bookhorses"
	desc = "This book is more horse than your mind has room for."
	remarks = list("Moooooooo!","Moo!","Moooo!", "NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!", "Oink!", "Squeeeeeeee!", "Oink Oink!", "Ree!!", "Reee!!", "REEE!!", "REEEEE!!")

/obj/item/book/granter/spell/barnyard/recoil(mob/living/carbon/user)
	if(ishuman(user))
		to_chat(user,"<font size='15' color='red'><b>HORSIE HAS RISEN</b></font>")
		var/obj/item/clothing/magichead = new /obj/item/clothing/mask/animal/horsehead/cursed(user.drop_location())
		if(!user.dropItemToGround(user.wear_mask))
			qdel(user.wear_mask)
		user.equip_to_slot_if_possible(magichead, ITEM_SLOT_MASK, TRUE, TRUE)
		qdel(src)
	else
		to_chat(user,"<span class='notice'>I say thee neigh</span>") //It still lives here

/obj/item/book/granter/spell/charge
	spell = /obj/effect/proc_holder/spell/targeted/charge
	spellname = "charge"
	icon_state ="bookcharge"
	desc = "This book is made of 100% postconsumer wizard."
	remarks = list("I feel ALIVE!", "I CAN TASTE THE MANA!", "What a RUSH!", "I'm FLYING through these pages!", "THIS GENIUS IS MAKING IT!", "This book is ACTION PAcKED!", "HE'S DONE IT", "LETS GOOOOOOOOOOOO")

/obj/item/book/granter/spell/charge/recoil(mob/user)
	..()
	to_chat(user,"<span class='warning'>[src] suddenly feels very warm!</span>")
	empulse(src, 1, 1)

/obj/item/book/granter/spell/summonitem
	spell = /obj/effect/proc_holder/spell/targeted/summonitem
	spellname = "instant summons"
	icon_state ="booksummons"
	desc = "This book is bright and garish, very hard to miss."
	remarks = list("I can't look away from the book!", "The words seem to pop around the page...", "I just need to focus on one item...", "Make sure to have a good grip on it when casting...", "Slow down, book. I still haven't finished this page...", "Sounds pretty great with some other magical artifacts...", "Magicians must love this one.")

/obj/item/book/granter/spell/summonitem/recoil(mob/user)
	..()
	to_chat(user,"<span class='warning'>[src] suddenly vanishes!</span>")
	qdel(src)

/obj/item/book/granter/spell/random
	icon_state = "random_book"

/obj/item/book/granter/spell/random/Initialize()
	. = ..()
	var/static/banned_spells = list(/obj/item/book/granter/spell/mimery_blockade, /obj/item/book/granter/spell/mimery_guns)
	var/real_type = pick(subtypesof(/obj/item/book/granter/spell) - banned_spells)
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

///MARTIAL ARTS///

/obj/item/book/granter/martial
	var/martial
	var/martialname = "bug jitsu"
	var/greet = "You feel like you have mastered the art in breaking code. Nice work, jackass."


/obj/item/book/granter/martial/already_known(mob/user)
	if(!martial)
		return TRUE
	var/datum/martial_art/MA = martial
	if(user.mind.has_martialart(initial(MA.id)))
		to_chat(user,"<span class='warning'>You already know [martialname]!</span>")
		return TRUE
	return FALSE

/obj/item/book/granter/martial/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading about [martialname]...</span>")

/obj/item/book/granter/martial/on_reading_finished(mob/user)
	to_chat(user, "[greet]")
	var/datum/martial_art/MA = new martial
	MA.teach(user)
	user.log_message("learned the martial art [martialname] ([MA])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/martial/cqc
	martial = /datum/martial_art/cqc
	name = "old manual"
	martialname = "close quarters combat"
	desc = "A small, black manual. There are drawn instructions of tactical hand-to-hand combat."
	greet = "<span class='boldannounce'>You've mastered the basics of CQC.</span>"
	icon_state = "cqcmanual"
	remarks = list("Kick... Slam...", "Lock... Kick...", "Strike their abdomen, neck and back for critical damage...", "Slam... Lock...", "I could probably combine this with some other martial arts!", "Words that kill...", "The last and final moment is yours...")

/obj/item/book/granter/martial/cqc/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		to_chat(user, "<span class='warning'>[src] beeps ominously...</span>")

/obj/item/book/granter/martial/cqc/recoil(mob/living/carbon/user)
	to_chat(user, "<span class='warning'>[src] explodes!</span>")
	playsound(src,'sound/effects/explosion1.ogg',40,TRUE)
	user.flash_act(1, 1)
	user.adjustBruteLoss(6)
	user.adjustFireLoss(6)
	qdel(src)

/obj/item/book/granter/martial/carp
	martial = /datum/martial_art/the_sleeping_carp
	name = "mysterious scroll"
	martialname = "sleeping carp"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of martial art."
	greet = "<span class='sciradio'>You have learned the ancient martial art of the Sleeping Carp! Your hand-to-hand combat has become much more effective, and you are now able to deflect any projectiles \
	directed toward you while in Throw Mode. Your body has also hardened itself, granting extra protection against lasting wounds that would otherwise mount during extended combat. \
	However, you are also unable to use any ranged weaponry. You can learn more about your newfound art by using the Recall Teachings verb in the Sleeping Carp tab.</span>"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"
	worn_icon_state = "scroll"
	remarks = list("Wait, a high protein diet is really all it takes to become stabproof...?", "Overwhelming force, immovable object...", "Focus... And you'll be able to incapacitate any foe in seconds...", "I must pierce armor for maximum damage...", "I don't think this would combine with other martial arts...", "Become one with the carp...", "Glub...")

/obj/item/book/granter/martial/carp/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's completely blank."
		name = "empty scroll"
		icon_state = "blankscroll"

/obj/item/book/granter/martial/plasma_fist
	martial = /datum/martial_art/plasma_fist
	name = "frayed scroll"
	martialname = "plasma fist"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	greet = "<span class='boldannounce'>You have learned the ancient martial art of Plasma Fist. Your combos are extremely hard to pull off, but include some of the most deadly moves ever seen including \
	the plasma fist, which when pulled off will make someone violently explode.</span>"
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	remarks = list("Balance...", "Power...", "Control...", "Mastery...", "Vigilance...", "Skill...")

/obj/item/book/granter/martial/plasma_fist/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's completely blank."
		name = "empty scroll"
		icon_state = "blankscroll"

/obj/item/book/granter/martial/plasma_fist/nobomb
	martial = /datum/martial_art/plasma_fist/nobomb

// I did not include mushpunch's grant, it is not a book and the item does it just fine.

//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,"<span class='notice'>You learned how to make [initial(R.name)].</span>")

/obj/item/book/granter/crafting_recipe/cooking_sweets_101
	name = "Cooking Desserts 101"
	desc = "A cook book that teaches you how to cook basic desserts."
	crafting_recipe_types = list(
		/datum/crafting_recipe/food/pumpkinspicecake,
		/datum/crafting_recipe/food/bscccake,
		/datum/crafting_recipe/food/bscvcake,
		/datum/crafting_recipe/food/berrytart,
		/datum/crafting_recipe/food/clowncake,
		/datum/crafting_recipe/food/birthdaycake,
		/datum/crafting_recipe/food/chocolatecake,
		/datum/crafting_recipe/food/lemoncake,
		/datum/crafting_recipe/food/limecake,
		/datum/crafting_recipe/food/orangecake,
		/datum/crafting_recipe/food/applecake,
		/datum/crafting_recipe/food/cheesecake,
		/datum/crafting_recipe/food/carrotcake,
		/datum/crafting_recipe/food/pumpkinpie,
		/datum/crafting_recipe/food/bananacreampie,
		/datum/crafting_recipe/food/berryclafoutis,
		/datum/crafting_recipe/food/grapetart,
		/datum/crafting_recipe/food/dulcedebatata,
		/datum/crafting_recipe/food/baklava,
		/datum/crafting_recipe/food/chocolateegg,
		/datum/crafting_recipe/food/chocoorange,
		/datum/crafting_recipe/food/fudgedice,
		/datum/crafting_recipe/food/chococoin,
		/datum/crafting_recipe/food/candiedapple,
	)
	icon_state = "cooking_learing_sweets"
	oneuse = FALSE
	remarks = list("So that is how icing is made!", "Placing fruit on top? How simple...", "Huh layering cake seems harder then this...", "This book smells like candy", "A clown must have made this page, or they forgot to spell check it before printing...", "Why do they call it oven?")

/obj/item/book/granter/crafting_recipe/jelly_doughnuts_101
	name = "Jelly Doughnuts 101"
	desc = "A cook book that teaches you how to make jelly doughnuts."
	crafting_recipe_types = list(
	/datum/crafting_recipe/food/donut/jelly,
	/datum/crafting_recipe/food/donut/jelly/berry,
	/datum/crafting_recipe/food/donut/jelly/apple,
	/datum/crafting_recipe/food/donut/jelly/caramel,
	/datum/crafting_recipe/food/donut/jelly/choco,
	/datum/crafting_recipe/food/donut/jelly/blumpkin,
	/datum/crafting_recipe/food/donut/jelly/bungo,
	/datum/crafting_recipe/food/donut/jelly/matcha,
	/datum/crafting_recipe/food/donut/jelly/laugh,
	)
	icon_state = "cooking_learing_sweets"
	oneuse = FALSE
	remarks = list("But how do they make the hole...", "Dough-nut!", "Dough-nut?", "Dough-nut...", "The Os of the bakery.")

/obj/item/book/granter/crafting_recipe/donk_yourself
	name = "Donk Yourself Donkpocket DIY"
	desc = "A cook book that teaches you how to make uniquely flavored homemade donkpockets."
	crafting_recipe_types = list(
		/datum/crafting_recipe/food/dankpocket,
		/datum/crafting_recipe/food/donkpocket/spicy,
		/datum/crafting_recipe/food/donkpocket/teriyaki,
		/datum/crafting_recipe/food/donkpocket/pizza,
		/datum/crafting_recipe/food/donkpocket/honk,
		/datum/crafting_recipe/food/donkpocket/berry,
	)
	icon_state = "cooking_learing_sweets"
	oneuse = FALSE
	remarks = list("The secret ingredient is love?", "If you dont have the chemicals, regular preservatives can be used...", "Gotta... peel off these warning labels.", "Add more cooking oil.", "Is this stuff safe to consume?")

/obj/item/book/granter/crafting_recipe/explosives_weekly
	name = "Explosives Weekly"
	desc = "A well used book on ways to manufacture explosives."
	crafting_recipe_types = list(
		/datum/crafting_recipe/improv_explosive,
		/datum/crafting_recipe/chemical_payload,
		/datum/crafting_recipe/chemical_payload2,
	)
	icon_state = "book1"
	oneuse = FALSE
	remarks = list("So thats why it kept exploding in my hands...", "Maybe it needed more oil...", "The author sounds a bit unwell...")


/obj/item/book/granter/crafting_recipe/rifles_weekly
	name = "Rifles Weekly"
	desc = "A well used book on ways to manufacture weapons."
	crafting_recipe_types = list(
		/datum/crafting_recipe/advancedegun,
		/datum/crafting_recipe/tempgun,
		/datum/crafting_recipe/beam_rifle,
		/datum/crafting_recipe/ebow,
		/datum/crafting_recipe/xraylaser,
		/datum/crafting_recipe/hellgun,
		/datum/crafting_recipe/ioncarbine,
		/datum/crafting_recipe/frag12,
		/datum/crafting_recipe/ionslug,
		/datum/crafting_recipe/dragonsbreath,
		/datum/crafting_recipe/pulseslug,
		/datum/crafting_recipe/meteorslug,
		/datum/crafting_recipe/laserslug,
	)
	icon_state = "book1"
	oneuse = FALSE
	remarks = list("So thats why it kept exploding in my hands...", "Maybe it needed more oil...")

/obj/item/book/granter/crafting_recipe/pipegun_prime
	name = "diary of a dead assistant"
	desc = "A battered journal. Looks like he had a pretty rough life."
	crafting_recipe_types = list(
		/datum/crafting_recipe/pipegun_prime
	)
	icon_state = "book1"
	oneuse = TRUE
	remarks = list("He apparently mastered some lost guncrafting technique.", "Why do I have to go through so many hoops to get this shitty gun?", "That much Grey Bull cannot be healthy...", "Did he drop this into a moisture trap? Yuck.", "Toolboxing techniques, huh? I kinda just want to know how to make the gun.", "What the hell does he mean by 'ancient warrior tradition'?")

/obj/item/book/granter/crafting_recipe/pipegun_prime/recoil(mob/living/carbon/user)
	to_chat(user, "<span class='warning'>The book turns to dust in your hands.</span>")
	qdel(src)

/obj/item/book/granter/crafting_recipe/carnival
	pages_to_mastery = 1
	var/carnival_only = TRUE

/obj/item/book/granter/crafting_recipe/carnival/Initialize()
	. = ..()
	if(SSmaptype.maptype == "office")
		carnival_only = FALSE

/obj/item/book/granter/crafting_recipe/carnival/attack_self(mob/user)
	if (carnival_only && !(user?.mind?.assigned_role == "Carnival" || user?.mind?.assigned_role == "Workshop Attendant")) // check role
		to_chat(user, span_danger("Wow, This book seems so wacky! None of it makes sense, to you."))
		return FALSE
	. = ..()

/obj/item/book/granter/crafting_recipe/carnival/weaving_armor
	name = "Weaving Armor: Basic Edition"
	desc = "A weaving tutorial book that teaches you how to weave new armors. Carnival approved, and a best seller in District 13!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Sweeper Suit: RED = 20%, WHITE = 10%, BLACK = 20%, PALE = 10%<br>\
	-Doubting Suit: RED = 40%, WHITE = 20%, BLACK = -10%, PALE = 10%<br>\
	-Hunger Suit: RED = -10%, WHITE = 20%, BLACK = 40%, PALE = 10%<br>\
	-Soldier's Uniform: RED = 20%, WHITE = -20%, BLACK = 20%, PALE = 40%<br>\
	-Reforged Suit: RED = 10%, WHITE = -20%, BLACK = 10%, PALE = 0%, Makes you 20% faster.<br>\
	-Carnival Robes: RED = 40%, WHITE = 40%, BLACK = 60%, PALE = 0%"
	pages_to_mastery = 0
	crafting_recipe_types = list(
		/datum/crafting_recipe/indigo_armor,
		/datum/crafting_recipe/green_armor,
		/datum/crafting_recipe/amber_armor,
		/datum/crafting_recipe/steel_armor,
		/datum/crafting_recipe/azure_armor,
		/datum/crafting_recipe/carnival_robes,
		/datum/crafting_recipe/amber_silk_simple,
		/datum/crafting_recipe/steel_silk_simple,
		/datum/crafting_recipe/indigo_silk_simple,
		/datum/crafting_recipe/green_silk_simple,
		/datum/crafting_recipe/indigo_silk_advanced,
		/datum/crafting_recipe/green_silk_advanced,
		/datum/crafting_recipe/violet_silk_simple,
		/datum/crafting_recipe/crimson_silk_simple,
	)
	icon_state = "book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_kurokumo
	name = "Weaving Armor: Kurokumo Edition"
	desc = "A weaving book that teaches you how to weave kurokumo armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Kurokumo Wakashu Dress Jacket: RED = 20%, WHITE = 20%, BLACK = 20%, PALE = 20%, Makes you 20% faster.<br>\
	-Kurokumo Enforcer Dress Shirt: RED = 30%, WHITE = 30%, BLACK = 30%, PALE = 30%, Makes you 30% faster.<br>\
	-Kurokumo Captain Kimono: RED = 30%, WHITE = 30%, BLACK = 30%, PALE = 20%, Makes you 50% faster."
	crafting_recipe_types = list(
		/datum/crafting_recipe/kurokumo,
		/datum/crafting_recipe/kurokumo_jacket,
		/datum/crafting_recipe/kurokumo_captain
	)
	icon_state = "kurokumo_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_seven
	name = "Weaving Armor: Seven Edition"
	desc = "A weaving book that teaches you how to weave seven armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Seven Association armor: RED = 20%, WHITE = 20%, BLACK = 40%, PALE = 0%<br>\
	-Seven Association recon armor: RED = 0%, WHITE = 0%, BLACK = 30%, PALE = 0%, Makes you 50% faster.<br>\
	-Seven Association veteran armor: RED = 30%, WHITE = 30%, BLACK = 50%, PALE = 20%.<br>\
	-Seven Association intelligence armor: RED = 30%, WHITE = 30%, BLACK = 50%, PALE = 20%.<br>\
	-Seven Association director armor: RED = 40%, WHITE = 40%, BLACK = 70%, PALE = 20%."

	crafting_recipe_types = list(
		/datum/crafting_recipe/seven,
		/datum/crafting_recipe/seven_recon,
		/datum/crafting_recipe/seven_vet,
		/datum/crafting_recipe/seven_vet_intel,
		/datum/crafting_recipe/seven_dir
	)
	icon_state = "seven_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_ncorp
	name = "Weaving Armor: N-Corp Edition"
	desc = "A weaving book that teaches you how to weave n-corp armor. Carnival approved.<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Nagel und Hammer armor: RED = 40%, WHITE = 20%, BLACK = 20%, PALE = 50%<br>\
	-Decorated Nagel und Hammer armor:  RED = 50%, WHITE = 30%, BLACK = 40%, PALE = 60%<br>\
	-Nagel und Hammer Grosshammer armor: RED = 90%, WHITE = 70%, BLACK = 70%, PALE = 80%, Makes you 100% slower.<br>\
	-Rüstung der auserwählten Frau Gottes: RED = 60%, WHITE = 50%, BLACK = 60%, PALE = 70%."
	crafting_recipe_types = list(
		/datum/crafting_recipe/ncorp,
		/datum/crafting_recipe/ncorp_vet,
		/datum/crafting_recipe/ncorp_grosshammmer,
		/datum/crafting_recipe/ncorpcommander,
		/datum/crafting_recipe/ncorp_white_mark,
		/datum/crafting_recipe/ncorp_black_mark,
		/datum/crafting_recipe/ncorp_pale_mark
	)
	icon_state = "n-corp_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_liu
	name = "Weaving Armor: Liu Edition"
	desc = "A weaving book that teaches you how to weave liu armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Liu Association combat suit: RED = 20%, WHITE = 40%, BLACK = 20%, PALE = 0%<br>\
	-Liu Association combat jacket: RED = 20%, WHITE = 40%, BLACK = 20%, PALE = 0%<br>\
	-Liu Association combat coat (Vet):  RED = 30%, WHITE = 50%, BLACK = 30%, PALE = 20%<br>\
	-Liu Association section 2 combat coat (Vet): RED = 30%, WHITE = 50%, BLACK = 30%, PALE = 20%<br>\
	-Liu Association veteran combat jacket: RED = 30%, WHITE = 50%, BLACK = 30%, PALE = 20%<br>\
	-Liu Association heavy combat coat: RED = 40%, WHITE = 70%, BLACK = 40%, PALE = 20%."
	crafting_recipe_types = list(
		/datum/crafting_recipe/liu_suit,
		/datum/crafting_recipe/liu_jacket,
		/datum/crafting_recipe/liu_coat,
		/datum/crafting_recipe/liu_combat_coat,
		/datum/crafting_recipe/liu_combat_jacket,
		/datum/crafting_recipe/liu_heavy_coat,
		/datum/crafting_recipe/liu_officer_coat
	)
	icon_state = "liu_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_index
	name = "Weaving Armor: Index Edition"
	desc = "A weaving book that teaches you how to weave index armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Index proselyte armor: RED = 20%, WHITE = 20%, BLACK = 20%, PALE = 30%<br>\
	-Index proxy armor: RED = 30%, WHITE = 30%, BLACK = 30%, PALE = 40%<br>\
	-Index messenger armor:  RED = 50%, WHITE = 50%, BLACK = 50%, PALE = 60%"
	crafting_recipe_types = list(
		/datum/crafting_recipe/index_proselyte,
		/datum/crafting_recipe/index_proxy,
		/datum/crafting_recipe/index_mess
	)
	icon_state = "index_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_zwei
	name = "Weaving Armor: Zwei Edition"
	desc = "A weaving book that teaches you how to weave zwei armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Zwei Association casual jacket: RED = 30%, WHITE = 0%, BLACK = 0%, PALE = 0%<br>\
	-Zwei Association armor: RED = 40%, WHITE = 20%, BLACK = 20%, PALE = 0%<br>\
	-Zwei Association riot armor: RED = 70%, WHITE = 40%, BLACK = 40%, PALE = 20%, Makes you 70% slower.<br>\
	-Zwei Association veteran armor: RED = 50%, WHITE = 30%, BLACK = 30%, PALE = 20%<br>\
	-Zwei Association director armor: RED = 70%, WHITE = 40%, BLACK = 40%, PALE = 20%"
	crafting_recipe_types = list(
		/datum/crafting_recipe/zwei,
		/datum/crafting_recipe/zwei_junior,
		/datum/crafting_recipe/zwei_riot,
		/datum/crafting_recipe/zwei_vet,
		/datum/crafting_recipe/zwei_dir
	)
	icon_state = "zwei_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_zwei_west
	name = "Weaving Armor: Zwei West Edition"
	desc = "A weaving book that teaches you how to weave zwei west armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Zwei knight armor: RED = 50%, WHITE = 30%, BLACK = 30%, PALE = 10%, Makes you 40% slower.<br>\
	-Zwei veteran knight armor: RED = 60%, WHITE = 40%, BLACK = 40%, PALE = 30%, Makes you 40% slower.<br>\
	-Zwei knight director armor: RED = 70%, WHITE = 50%, BLACK = 50%, PALE = 40%, Makes you 40% slower."
	crafting_recipe_types = list(
		/datum/crafting_recipe/zweiwest,
		/datum/crafting_recipe/zweiwestvet,
		/datum/crafting_recipe/zweiwestleader
	)
	icon_state = "zwei_west_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_wedge
	name = "Weaving Armor: Wedge Office Edition"
	desc = "A weaving book that teaches you how to weave wedge office armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Wedge office dress: RED = 10%, WHITE = 10%, BLACK = 40%, PALE = 0%<br>\
	-Wedge office jacket: RED = 10%, WHITE = 10%, BLACK = 40%, PALE = 0%<br>\
	-Wedge office leader jacket: RED = 20%, WHITE = 20%, BLACK = 50%, PALE = 20%."
	crafting_recipe_types = list(
		/datum/crafting_recipe/wedge_male,
		/datum/crafting_recipe/wedge_fem,
		/datum/crafting_recipe/wedge_leader
	)
	icon_state = "wedge_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_rosespanner
	name = "Weaving Armor: Rosespanner Workshop Edition"
	desc = "A weaving book that teaches you how to weave rosespanner workshop armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Rosespanner fixer jacket: RED = 20%, WHITE = 30%, BLACK = 20%, PALE = 20%<br>\
	-Rosespanner assassin jacket: RED = 20%, WHITE = 30%, BLACK = 20%, PALE = 20%<br>\
	-Rosespanner representative jacket: RED = 30%, WHITE = 40%, BLACK = 30%, PALE = 30%."
	crafting_recipe_types = list(
		/datum/crafting_recipe/rosespanner,
		/datum/crafting_recipe/rosespanner_assassin,
		/datum/crafting_recipe/rosespannerrep
	)
	icon_state = "rosespanner_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")


/obj/item/book/granter/crafting_recipe/carnival/weaving_molar_boatworks
	name = "Weaving Armor: Molar Boatworks Edition"
	desc = "A weaving book that teaches you how to weave molar boatworks armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Molar boatworks jacket: RED = 40%, WHITE = 10%, BLACK = 10%, PALE = 0%<br>\
	-Molar boatworks director wetsuit: RED = 50%, WHITE = 20%, BLACK = 20%, PALE = 20%."
	crafting_recipe_types = list(
		/datum/crafting_recipe/boatworks,
		/datum/crafting_recipe/boatworks_director,
	)
	icon_state = "boatworks_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_masquerade
	name = "Weaving Armor: The Masquerade Edition"
	desc = "A weaving book that teaches you how to weave masquerade armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Masquerade Coat: RED = 30%, WHITE = 20%, BLACK = 10%, PALE = 0%<br>\
	-Masquerade Cloak: RED = 40%, WHITE = 20%, BLACK = 40%, PALE = 20%.<br>\
	There is a small note which also says: (All armors made in this book act like blood sponges, letting you drain blood to heal.)"
	crafting_recipe_types = list(
		/datum/crafting_recipe/bloodfiend_coat,
		/datum/crafting_recipe/bloodfiend_cloak,
	)
	icon_state = "masq_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_j_corp_gangs
	name = "Weaving Armor: J Corp Gangs Edition"
	desc = "A weaving book that teaches you how to weave armor used by gangs in J-Corp. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Red ting tang shirt: RED = 10%, WHITE = 30%, BLACK = -10%, PALE = -10%<br>\
	-Yellow ting tang shirt: RED = 10%, WHITE = 30%, BLACK = -10%, PALE = -10%<br>\
	-Blue ting tang shirt: RED = 10%, WHITE = 30%, BLACK = -10%, PALE = -10%<br>\
	-Green ting tang shirt: RED = 20%, WHITE = 40%, BLACK = 20%, PALE = 10%<br>\
	-Los mariachis poncho (alegre): RED = 20%, WHITE = 20%, BLACK = -10%, PALE = -10%<br>\
	-Los mariachis poncho (vivaz): RED = 20%, WHITE = 20%, BLACK = -10%, PALE = -10%<br>\
	-Los mariachis armor: RED = 30%, WHITE = 30%, BLACK = 10%, PALE = 20%<br>\
	-Los mariachis armor (Unlocked): RED = 40%, WHITE = 40%, BLACK = 20%, PALE = 30%."
	crafting_recipe_types = list(
		/datum/crafting_recipe/ting_tang_red,
		/datum/crafting_recipe/ting_tang_blue,
		/datum/crafting_recipe/ting_tang_yellow,
		/datum/crafting_recipe/ting_tang_boss,
		/datum/crafting_recipe/mariachi_alegre,
		/datum/crafting_recipe/mariachi_vivaz,
		/datum/crafting_recipe/aida,
		/datum/crafting_recipe/aida_boss
	)
	icon_state = "j_corp_gangs_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")


/obj/item/book/granter/crafting_recipe/carnival/weaving_shi
	name = "Weaving Armor: Shi Edition"
	desc = "A weaving book that teaches you how to weave shi armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Shi association jacket: RED = 20%, WHITE = 10%, BLACK = 10%, PALE = 20%, Makes you 20% faster.<br>\
	-Shi association veteran jacket: RED = 30%, WHITE = 20%, BLACK = 20%, PALE = 30%, Makes you 20% faster.<br>\
	-Shi association director jacket: RED = 50%, WHITE = 20%, BLACK = 20%, PALE = 50%, Makes you 20% faster<br>\
	-Shi association combat suit: RED = 20%, WHITE = 0%, BLACK = 0%, PALE = 10%, Makes you 40% faster.<br>\
	-Shi association veteran jacket: RED = 30%, WHITE = 0%, BLACK = 0%, PALE = 20%, Makes you 40% faster.<br>\
	-Shi association director jacket: RED = 40%, WHITE = 20%, BLACK = 20%, PALE = 30%, Makes you 40% faster."
	crafting_recipe_types = list(
		/datum/crafting_recipe/shi_2,
		/datum/crafting_recipe/shi_5,
		/datum/crafting_recipe/shi_2_vet,
		/datum/crafting_recipe/shi_5_vet,
		/datum/crafting_recipe/shi_2_dir,
		/datum/crafting_recipe/shi_5_dir
	)
	icon_state = "shi_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_blade
	name = "Weaving Armor: Blade Lineage Edition"
	desc = "A weaving book that teaches you how to weave blade lineage armor. Carnival approved!<br>\
	On the back, it says that reading this book will teach how to make: <br>\
	-Blade lineage salsu robe: RED = 0%, WHITE = 0%, BLACK = 0%, PALE = 0%, Makes you 25% faster.<br>\
	-Blade lineage cutthroat robe: RED = 0%, WHITE = 0%, BLACK = 0%, PALE = 0%, Makes you 40% faster.<br>\
	-Blade lineage admin robe: RED = 0%, WHITE = 0%, BLACK = 0%, PALE = 0%, Makes you 60% faster."
	crafting_recipe_types = list(
		/datum/crafting_recipe/blade_lineage_salsu,
		/datum/crafting_recipe/blade_lineage_cutthroat,
		/datum/crafting_recipe/blade_lineage_admin
	)
	icon_state = "blade_lineage_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_basic_converstion
	name = "Weaving Armor: Common Conversation/Transfers Edition"
	desc = "A weaving book that teaches you how to weave common types of silk into another. Carnival approved!"
	pages_to_mastery = 0
	crafting_recipe_types = list(
		/datum/crafting_recipe/converted_green_silk_advanced,
		/datum/crafting_recipe/converted_green_silk_elegant,
		/datum/crafting_recipe/converted_green_silk_masterpiece,
		/datum/crafting_recipe/converted_indigo_silk_advanced,
		/datum/crafting_recipe/converted_indigo_silk_elegant,
		/datum/crafting_recipe/converted_indigo_silk_masterpiece,
		/datum/crafting_recipe/converted_amber_silk_advanced,
		/datum/crafting_recipe/converted_amber_silk_elegant,
		/datum/crafting_recipe/converted_amber_silk_masterpiece,
		/datum/crafting_recipe/converted_steel_silk_advanced,
		/datum/crafting_recipe/converted_steel_silk_elegant,
		/datum/crafting_recipe/converted_steel_silk_masterpiece,
		/datum/crafting_recipe/converted_human_silk_advanced,
		/datum/crafting_recipe/converted_human_silk_elegant,
		/datum/crafting_recipe/converted_human_silk_masterpiece,
		/datum/crafting_recipe/steel_silk_transfer,
		/datum/crafting_recipe/amber_silk_transfer,
		/datum/crafting_recipe/steel_silk_de_transfer,
		/datum/crafting_recipe/amber_silk_de_transfer
	)
	icon_state = "basic_converstion_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_advanced_converstion
	name = "Weaving Armor: Rare Conversation/Transfers Edition"
	desc = "A weaving book that teaches you how to weave rare types of silk into another. Carnival approved!"
	pages_to_mastery = 0
	crafting_recipe_types = list(
		/datum/crafting_recipe/converted_crimson_silk_advanced,
		/datum/crafting_recipe/converted_crimson_silk_elegant,
		/datum/crafting_recipe/converted_crimson_silk_masterpiece,
		/datum/crafting_recipe/converted_violet_silk_advanced,
		/datum/crafting_recipe/converted_violet_silk_elegant,
		/datum/crafting_recipe/converted_violet_silk_masterpiece,
		/datum/crafting_recipe/converted_shrimple_silk_advanced,
		/datum/crafting_recipe/converted_shrimple_silk_elegant,
		/datum/crafting_recipe/converted_shrimple_silk_masterpiece,
		/datum/crafting_recipe/converted_azure_silk_advanced,
		/datum/crafting_recipe/converted_azure_silk_elegant,
		/datum/crafting_recipe/converted_azure_silk_masterpiece,
		/datum/crafting_recipe/azure_silk_transfer,
		/datum/crafting_recipe/crimson_silk_transfer,
		/datum/crafting_recipe/violet_silk_transfer,
		/datum/crafting_recipe/shrimple_silk_transfer,
		/datum/crafting_recipe/shrimple_silk_de_transfer_amber,
		/datum/crafting_recipe/shrimple_silk_de_transfer_steel
	)
	icon_state = "advanced_converstion_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/human_replacements
	name = "Weaving Armor: Advanced Human Replacements"
	desc = "A weaving book that teaches you how to make human silk out of normal silk! Carnival approved!"
	pages_to_mastery = 0
	crafting_recipe_types = list(
		/datum/crafting_recipe/human_silk_transfer
	)
	icon_state = "human_replacements_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")

/obj/item/book/granter/crafting_recipe/carnival/weaving_ordeal
	name = "Weaving Armor: Masterpiece Armor"
	desc = "A weaving book that teaches you how to weave some of the best armor in the City... Carnival approved!"
	pages_to_mastery = 3
	crafting_recipe_types = list(
		/datum/crafting_recipe/ordeal_familial_strength,
		/datum/crafting_recipe/ordeal_painful_purpose,
		/datum/crafting_recipe/ordeal_eternal_feast,
		/datum/crafting_recipe/ordeal_meaningless_march,
		/datum/crafting_recipe/ordeal_god_delusion
	)
	icon_state = "ordeal_silkweaving_book"
	remarks = list("Make sure that you always have your weaving knife on you? I already knew that.", "Using sweepers as silk? That is brand new...", "Huh, it says here that 'Be careful around the fixer association...' ", "This book smells quite well, Like it was just made just for me!", "A rookie must have made this page, or they forgot to spell check it before printing...", "Wait, how will this turn a profit? I spent like 1000 ahn for this book!")
