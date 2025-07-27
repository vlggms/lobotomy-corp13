/datum/skill/fishing
	name = "Fishing"
	title =  "Fisher"
	desc = "A terror that lurks outside the world of fish. \
			Each level decreases the time it takes to fish by 1 second."
	modifiers = list(SKILL_SPEED_MODIFIER = list(0, 1, 2, 3, 4, 5, 6))
	skill_cape_path = /obj/item/clothing/neck/cloak/skill_reward/fishing

/datum/skill/fishing/New()
	. = ..() //may have to change these to be Lobotomy Corp lore later instead of general mythology
	levelUpMessages[1] = span_nicegreen("You understand the stillness that calms your prey...")
	levelUpMessages[2] = span_nicegreen("Your fishing mastery gives you some insight into the aquatic world...")
	levelUpMessages[3] = span_nicegreen("For a moment you swear you saw a large shrimp head watching you from the water...")
	levelUpMessages[4] = span_nicegreen("One of the fish you catch tells you about how a signet ring that could command demons was once swallowed by a fish...")
	levelUpMessages[5] = span_nicegreen("Your recent catch tells you of Nyami Nyami and how they cared for the Tonga people...")
	levelUpMessages[6] = span_nicegreen("Written on a fish you catch is a message from S-corp, it says they noticed your progress and may have a offer for you at district 19 when your shift is over...")

//Skill xp granter. Ill make this a more generalized root if its more widely used. -IP
/obj/item/book/granter/fish_skill
	name = "Fishin tips for Beginners"
	desc = "A book that can grant some experience for the aspiring fishermin."
	icon_state = "fishbook"
	var/granted_skill = /datum/skill/fishing
	var/skillname = "beginner level fishing" //might not seem nessesary but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps
	remarks = list(
		"Dont eat fish raw due to the vile fluid that they have inside...",
		"The more you fish the higher your fishing skill goes and the faster you fish...",
		"This page just has the image of a front facing fish...",
		"This page is covered in numerous stickers for wellcheers soda...",
		"The Great Lake is seperated into numerous smaller lakes that each have their own laws...",
		"The Great Lake is a large waterbody south of the city...",
		"Sailing past the coast of U corp is unadvised without a sailor and maybe 4 fixers...",
		"The next book will expand on the dangers of whales and their mermaids...",
	)

/obj/item/book/granter/fish_skill/already_known(mob/user)
	if(user.mind?.get_skill_level(granted_skill) >= 2)
		to_chat(user, span_warning("You already know all about [skillname]!"))
		return TRUE
	return FALSE

/obj/item/book/granter/fish_skill/on_reading_start(mob/user)
	to_chat(user, span_notice("You start reading about [skillname]..."))

/obj/item/book/granter/fish_skill/on_reading_finished(mob/user)
	to_chat(user, span_notice("You feel like you've got a good handle on [skillname]! <br>\
		When you read the last sentence the copyright self-destruct activates"))
	user.mind?.set_level(granted_skill, 2)
	qdel(src)
