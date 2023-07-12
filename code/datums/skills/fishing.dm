/datum/skill/fishing
	name = "Fishing"
	title =  "Fisher"
	desc = "A terror that lurks outside the world of fish."
	modifiers = list(SKILL_SPEED_MODIFIER = list(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.36))
	skill_cape_path = /obj/item/clothing/neck/cloak/skill_reward/fishing

/datum/skill/fishing/New()
	. = ..() //may have to change these to be Lobotomy Corp lore later instead of general mythology
	levelUpMessages[1] = "<span class='nicegreen'>You understand the stillness that calms your prey...</span>"
	levelUpMessages[2] = "<span class='nicegreen'>Your fishing mastery seems to give you some insight into the aquatic world...</span>"
	levelUpMessages[3] = "<span class='nicegreen'>For a moment you swear you saw a large shrimp head watching you from the water...</span>"
	levelUpMessages[4] = "<span class='nicegreen'>One of the fish you catch tells you about how a signet ring that could command demons was once swallowed by a fish...</span>"
	levelUpMessages[5] = "<span class='nicegreen'>Your recent catch tells you of Nyami Nyami and how they cared for the Tonga people...</span>"
	levelUpMessages[6] = "<span class='nicegreen'>Written on a fish you catch is a message from S-corp, it says they noticed your progress and may have a offer for you at district 19 when your shift is over...</span>"
