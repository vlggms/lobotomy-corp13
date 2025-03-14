/obj/item/tape/resurgence
	name = "old tape"
	desc = "A magnetic tape that can hold up to ten minutes of content. YOU SHOULD NOT BE SEEING THIS!"
	icon_state = "tape_blue"
	storedinfo = list()
	timestamp = list()

/obj/item/tape/resurgence/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You take a closer look at the tape... Looks like you can't pull out the wires.</span>")

/obj/item/tape/resurgence/first
	name = "Tinkerer's Log: Moving Out"
	icon_state = "tape_red"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Resurgence Clan's first move.' written on it's back."

	storedinfo = list(
		"Loud sounds of machinery and humans screams could be heard in the background...",
		span_game_say(span_name("Unknown Robotic Voice") + span_message(" yells,") + " &quot;Dammit... WHY CAN’T YOU JUST SHUT UP!!!&quot;"),
		span_game_say(span_name("Human Voice") + span_message(" coughs")),
		span_game_say(span_name("Human Voice") + span_message(" weakly says,") + " &quot;Who- What the hell are you-u... I ju-ust wanted to&quot;"),
		span_game_say(span_name("Human Voice") + span_message(" coughs loudly yet weakly")),
		span_game_say(span_name("Human Voice ") + span_message(" weakly says,") + " &quot;Pass by thi-is town... Please, My family is waiting for me...&quot;"),
		span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " &quot;Oh, There are more of you meatbags nearby? Pleasurable to know... &quot;"),
		span_game_say(span_name("Unknown Robotic Voice") + span_message(" yells,") + " &quot;HEY YOU, YES YOU. THE SCOUT IN THE BACK, PASS OVER THE DRILL.&quot;"),
		span_game_say(span_name("Scout") + span_message(" says,") + " &quot;Ye-es Tinke-er.&quot;"),
		span_game_say(span_name("Human Voice ") + span_message(" weakly says,") + " &quot;Wha-at are you doing... Wait! I can still provide something for you! Do you need gears or me-&quot;"),
		span_game_say(span_name("Human Voice") + span_message("  screams")),
		"Sounds of drills and saws tearing into flesh are heard before a heavy door is heard screeching open…",
		span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Dear Tinkerer... Was this why you wanted me to give you this new human to you?&quot;"),
		span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;At least I could of woven them into something much more valuable than fresh gibs…&quot;"),
		"The sounds of drills and saws slowly slowed down...",
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Oh? Didn’t expect you to arrive here today Mister Weaver, Were you this worried about this human?&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;No, With the recent events that occurred here with the... FLS members and my citizens have been much more opposed to using humans as materials.&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;After all, once you get to meet the humans you are using to become more human it does feel more sinful of using them this way…&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;No, I am here to deliver some... Rather upsetting news to you...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Really now? You got to drown out my perfectly fine mood after executing a monster...&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Yet, It has to be said. After discussing this with the Historian, We have decided that this town is no place for you.&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;So I kindly ask you to kindly leave this town soon...&quot;"),
		"A loud fleshy crunch is heard coming from the human head...",
		span_game_say(span_name("The Tinkerer") + span_message(" whispers,") + " &quot;I really should of seen that one coming yet...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;No big deal, I can start moving tomorrow. This place was quite limiting after all.&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Thank you for understanding our decision, as it was not an easy one we ma-&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Yada yada... No need to exaggerate this. This ‘difficult decision’ only took you like, 12 hours to make.&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" yells,") + " &quot;ALL OF THE SCOUTS HERE, YOU BETTER START MOVING NOW!...&quot;"),
		span_game_say(span_name("Scout") + span_message(" yells,") + " &quot;Ye-es Sir, Moving o-out...&quot;"),
		span_game_say(span_name("Scout") + span_message(" yells,") + " &quot;Yes Si-ir, Moving ou-ut...&quot;"),
		span_game_say(span_name("Scout") + span_message(" yells,") + " &quot;Ye-es Sir, Mo-ov...&quot;"),
		"The Tape cuts after around 4-5 pairs of metallic footsteps move across the metal floor.")
	timestamp = list(2, 4, 8, 12, 16, 20, 26, 30, 34, 38, 41, 45, 52, 56, 59, 62, 67, 72, 77, 81, 86, 91, 94, 97, 102, 107, 110, 115, 119, 123, 126, 129, 132)

/obj/item/tape/resurgence/podcast_seven
	name = "Historians Podcast: Seven Association"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Episode 1' written on it's back."
	storedinfo = list(
		span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Is everything ready? The Podcast is starting in 3 secon- Oh!&quot;</span></span></span>,"),
		"Lights start flickering on as a jingle plays in the background...",
		span_game_say(span_name("Soft Robotic Voice") + span_message(" whispers,") + " &quot;Wait, I am still not ready for this... Oh dear, Um...&quot;"),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;Well, Hello my dear Citizens! What a brilliant new day in the outskirts as I, the Historian of district H will be teaching you about the different associations in the City today!&quot;"),
		"In the background, some object slowly starts winding up…",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;To start us off, We will be talking about the Seven! From our current record which we have gathered from the telescope, They like the Color Green? Could they love plants? After all, they also like making tea...&quot; "),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;They are also Detectives, So they must be some real pesky ones. Poking their noses wherever possible.&quot;"),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;They most often use simple shortswords in battle which are wonderful at opening up wounds in targets! So basically they use very sharp crowbars and their foes are crates to be ripped open!&quot;"),
		"A robotic laughter in the background, the winding from the object in the background stops.",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;There we are! Now we can observe one of those seven fixers named...&quot;"),
		"Sounds of papers being flipped.",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;Moses and Ezra? Yep, Them! They are some of the most talented members you can find in this association! As seen by their...&quot;"),
		"Awfully long pause occurs, mechanical gasps in the background.",
		span_game_say(span_name("The Historian") + span_message(" stutters,") + " &quot;Well, Um... Very strong bonds? Ignore the face of the yellow haired girl, She is proud to be in this office as they call it!&quot;"),
		"A quick sound of a gears winding back.",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;Okay, Moving back our usual point of view...&quot;")
	)

	timestamp = list(2, 5, 8, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59, 64, 69, 74)

/obj/item/tape/resurgence/temple_of_motus
	name = "Expedition Log #32"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Our Temple...' written on it's back."
	storedinfo = list(
		"Mechanical Footsteps are heard moving across an empty desert, along with the sounds of wheels moving behind them…",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Hey, Head Priest. Do you have any idea of how much time is left until we reach this Temple…&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;It has been around a whole month since we started this journey…&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;We will arrive there in time, after all the Historian did say that this would be a long journey.&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Alright, Can you at least us what we will be doing there?&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;I think that we have already proven that we are dedicated to this project.&quot;"),
		"Flipping of pages comes from the “Old Robotic Voice…”",
		span_game_say(span_name("Old Robotic Voice") + span_message(" asks,") + " &quot;Scholar, Do you recognize this book?&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Of course I do! This is ‘The Exploration of Love and Fear,’ written by you. Any Scholar should know it by soul if they wish to pass the first class.&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" asks,") + " &quot;Good, and how do you think I was able to explore those emotions I wrote about?&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Well… I thought that you are an old machine, being one of the first few machines who moved during the Great Migration.&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;That you were able to learn those emotions using your experience, or something vague like that.&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Good guess Scholar, but you don’t just ‘learn things’ with experience. You need to do something to earn it…&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;You need to get close to humans, to study them to learn how they interact with those emotions.&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Okay, But it is not like we get to see them all that often, most of the time they either run away or attack us on sight…&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;And that's where our Temple comes in.&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;This temple is our  closest contact to humans without being detected. Along with holding all of the tools we need to study them.&quot;"),
		"The Mechanical footsteps stop.",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Um, Head Priest. Are we stopping now? There is still around 10 hours until the sun goes down.&quot;"),
		"4 small knocks come from the “Old Robotic Voice”",
		"The ground begins to rumble… as crumbling rocks and shifting gears rises from the ground, before ending in a thud.",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" stutters,") + " &quot;How… how could it all be hidden that easily…&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Now, Dear Scholar. Welcome to the Temple of Motus.&quot;")
	)

	timestamp = list(1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89, 93)

/obj/item/tape/resurgence/new_library
	name = "Temple Log #1"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'The Library' written on it's back."
	storedinfo = list(
	"Sounds of shifting machinery and distant conversations",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Scholar, How is progress on getting everyone settled in?&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;All great sir! It everyone has been able to find their rooms in the temple and we are about to offload all of our supplies!&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Understood, It appears that I will need to speak with the Historian soon… I can give you a basic rundown of your duties before I go.&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Got it sir. Where shall we begin?&quot;"),
	"A pair of mechanical footsteps, then a heavy door slides open…",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;One of the basic responsibilities you will hold in this temple is to keep our library up to date. As studies are completed, it may cause some books to become outdated.&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Either way you will not be parting in the studies for now since you are new, but at least you will be tasked with watching them and taking notes.&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Please use those opportunities to learn our ways around here...&quot;"),
	"The “Old Robotic Voice” slows down.",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Now now, I know you are interested in what studies these books hold but we still need to get over your duties.&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Oh, Sorry Sir. You need to understand what a change this is, Back at the town I got access to only like… 2 books a month?&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Now I have the whole library open! Holding so many new experiences! Like “Aversion” or “Contentment…”&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Oh, Sorry for taking up more of your time… Where do we need to go next?&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Well, How about I show you our repair bench? You will get many chances to speak with other members about this place, old and new!&quot;"),
	"The tape cuts right as the heavy door slides closed…"
	)

	timestamp = list(1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61)

/obj/item/tape/resurgence/joshua
	name = "Temple Log #15"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'New Friend?' written on it's back."
	storedinfo = list(
	"Sounds of distant conversations slowly moving away...",
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;That was quite a procedure! Fascinating how the human brain is able to produce such emotions. &quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Thank the Historian that I was able to record all of...&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Wait, Shoot... Don't tell me that it was off the whole time...&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Well one of my seniors must have have left one spare recording here...&quot;"),
	span_game_say(span_name("Distant Robotic Voice") + span_message(" says,") + " &quot;Hey! Elliot! Are you still in the study room?&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Yes-s. Just give me just a moment, I think I have forgotten something here...&quot;"),
	span_game_say(span_name("Distant Robotic Voice") + span_message(" says,") + " &quot;Okay... Just get out of there soon, other scholars will be using it soon.&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Of course... I would not want to prevent the study!&quot;"),
	"Sounds of books and metallic objects being thrown around.",
	span_game_say(span_name("Human Voice") + span_message(" coughs")),
	span_game_say(span_name("Elliot") + span_message(" asks,") + " &quot;Oh... It appears that they are already waking up. I really should get moving.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says weakly,") + " &quot;Wait... Who are you, why am I here...&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Um... Normally we young scholars don't get the chance to speak with you.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Scholars... Wait, Oh fuck... What have I gotten myself into.&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Oh please don't use such rude language around here. The Priest doesn't like hearing it.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Well “Scholar”, Sorry for not acting all pleasant to you after waking up tied up to a metal bed.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Especially when I see your steel face...&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Really? Is it really that disconcerting... I tried so hard to mimic how a human face looks like...&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Ha... That is the problem. You are trying far too hard. I heard that it causes some sort of uncanny effect.&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Oh! Now that is something to note down... “Don't try too hard when mimicking a human face...” &quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;You know what pal. We should have more talks like these!&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;It is so much more fun talking to you rather then listening to my teachers just yap on and on...&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Well, It isn't like I have much choice...&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Wonderful! I have to get going now but what is your name so I could remember it?&quot;"),
	span_game_say(span_name("Joshua") + span_message(" says,") + " &quot;... Call me Joshua.&quot;"),
	"The tape cuts right after some quick footsteps are heard moving out of the room."
	)

	timestamp = list(1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89, 93, 97, 101, 105, 109)

/obj/item/tape/resurgence/backstage
	name = "Historians Podcast: Backstage Records"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Backstage Records' written on it's back."
	storedinfo = list(
	"Sounds of robotic laughter in the background along with some clapping.",
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Thank you all for tuning in for tonight's episode! All of you learned a good amount about the Liu today!&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;It was been the Historian speaking today and see you all, Next week!&quot;"),
	"Suddenly all of the clapping stops as a screen shuts down...",
	span_game_say(span_name("The Historian") + span_message(" sighs")),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;Cut! You did great, dear Historian! You followed your script perfectly.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yes, As it always is...&quot;"),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;Now, Since we have some time until the podcast is uploaded what should we discuss next week?&quot;"),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;I know! I always wanted to know more about U-Cor.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" asks,") + " &quot;Please, Max. Can you give me a small moment. I just need to, think through some things.&quot;"),
	span_game_say(span_name("Max") + span_message(" says,") + " &quot;Oh, Sorry dear Historian. I will make my way then...&quot;"),
	"Metallic footsteps moving away, followed by a door opening and closing.",
	"Beeps and clicks coming from a device.",
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Excuse me, I am currently working right now so if you have any complaints...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Sorry for interrupting you dear Weaver, I was just wondering if you had a moment to talk.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Oh. Sorry for not recognizing you Historian. There are so many requests today, you would not believe it.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yep, Everyone is pretty excited about the recent cityfolk which came here.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" asks,") + " &quot;So, Why did you call me at this time?&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;You know, I have been thinking... Do you think the citizens are living a contentful life?&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Well, Looking at how all of them are happy. Have goals and dreams, I would say so.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yes, They all have dreams and recent events must have brought them hope... &quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;But what happens if they learn how those dreams are...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Flawed...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Nothing good, Nothing good will happen. I can't that happen.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;But...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;How long can I hide this truth from them...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They are all so innocent, They will eventually start making plans to fulfill their dreams.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They will all start leaving with a happy simile...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;“I will finally reach it, we can leave this harrowing life to rejoice in this paradise...”&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Then they will learn it's true nature, it's heartless nature...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They will even learn how he-&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;died for nothing...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;I... Wish I had a answer for that...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Sorry Weaver... I just had no else to talk too.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;We should return to our duties. The citizens need us.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;We shall do our best for them...&quot;"),
	"The tape ends after a beep is heard from a device.",
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116, 121, 126, 131, 136, 141, 146, 151, 156, 161, 176, 181, 186, 191, 196)

/obj/item/tape/resurgence/gateway
	name = "Tinkerer's Logs: New Invention"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'New Invention' written on it's back."
	storedinfo = list(
	"Sounds of mechanical drilling and machinery clicking.",
	"In the background, a heavy door starts sliding open... 2 pairs of footsteps walking closer",
	span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " &quot;Agh... That’s not efficient enough.&quot;"),
	span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " &quot;Gregory, It looks like this reactor will not be enough for this project.&quot;"),
	span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " &quot;Just throw it back into the factory, It perhaps might find use in another project...&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Ahm... Dear Tinkerer.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;The Historian and The Weaver! Sorry that I didn’t catch the both of you. &quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;But nevertheless, I am very thankful that you all could make it here!&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Well, You seem quite insistent on us arriving today.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;”I have something of utmost importance to present before us”, You said something like that.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;The last time you were this passionate about something was when you finally learned how to repair cores.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;It brings back memories... It has been so long since we have started this town.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;And thanks to our efforts, it seems to be growing.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;I am telling you, more and more folk are finally starting to understand us!&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Anyways, About this thing you wanted to show us...&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Right! Let me bring it over.&quot;"),
	"Mechanical sounds heard moving up...",
	"Mechanical sounds heard moving down, along with a long hydraulic sound moving closer...",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Now my Dear Elders, I now present before you...&quot;"),
	"Dramatic pause...",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;The Gateway! The invention which will bring us one step closer to City.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Hm... Looks interestingly built, I also like the details you put into it’s design.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Wow! It looks complex. The Weaver will probably better understand it, not that good with machines at this scale.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Thank you! Now, once this project will be refined, we will be able to teleport our people in and out of the city!&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Oh, Didn’t expect that we would be able to see it that soon...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Refined?&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Well, Currently it does require a large amount of power for a single use... It takes around a month to launch but only a single Citizen.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;But, It will be improved in time just letting you know to start preparations...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;We see... We shall then start prepare for it.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;You continue to amaze me, Dear Tinkerer... I can only dream of what we can do with this...&quot;"),
	"Awkward pause...",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Hm? Something bothering you? Isn't this one of your dream coming true?&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;To finally show the citizens the beauty of the City?&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;The oh so land of dreams...&quot;"),
	"A mechanical sliding sound is heard moving towards The Historian voice.",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Don’t you? Oh so dear Elder?&quot;"),
	span_game_say(span_name("The Historian") + span_message(" shudderingly says,") + " &quot;Ye-es... How could I not be excited? Ha...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;That’s enough, Tinkerer. We should be returning to our duties by now.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Very well, I shall return to my duties...&quot;"),
	"2 pairs of mechanical footsteps head walking away, along with a door sliding shut.",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;I hope you get what you wished for...&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Native Historian...&quot;")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116, 121, 126, 131, 136, 141, 146, 151, 156, 161, 166, 171, 176, 181, 186, 191, 196, 201, 206)

/obj/item/tape/resurgence/solution
	name = "Historians's Logs: The Solution"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'The Solution' written on it's back."
	storedinfo = list(
	"The rustling of papers, along with a deep mechanical sigh.",
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;They... Have been planning for this all along...&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;The Gateway... They were never planning on using it to teach our citizens.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;How could I be so naive...&quot;"),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;That is now in the past... The are now no longer here, and we need to pick ourselves back up.&quot;"),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Moral is not looking well right now, especially after the incident caused by The Tinkerer.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;... We could try to finally start this project, now that we have access to his blueprints.&quot;"),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;That is a risky maneuver, we have not ever tried to use this tech without the Tinkerer’s assistance.&quot;"),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;And we don’t even know if this plan will work in the first place.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;No wait, but look over here.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;It appears that they have been doing this already for a long time now.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Teleporting their own followers into the City...&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;And as long as they have their consciousness reduced... They will not be targeted by the City.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;This can be also seen with the spear and gun bots sometimes spotted in their backstreets. And the AI that the Devyat carry around.&quot;"),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Hm... Looks like they really do have quite the integrating notes about this.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;This means, we can start the shell program.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Using his tech, we will be able to build shells of our citizens, and then build a makeshift town.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Give the shells some basic functions, and then using the gateway we can send them, and the town into the city...&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Then, once we are able to bring them back in after the week, we can transfer all of the good memories of the City, back into our citizens.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Hopefully, this can bring back hope to our citizens...&quot;"),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;... Are you sure, Dear Historian? You are shaking...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;This... Must work, I can’t just let my citizens fall into despair... I can’t...&quot;")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116)

/obj/item/tape/resurgence/his_dream
	name = "Weavers's Logs: His Dream"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'His Dream' written on it's back."
	storedinfo = list(
	"Quiet gust of wind, clicking and taps from a typewriter.",
	"Slow and loud mechanical footsteps moving closer to the typewriter sounds.",
	"A pause for a moment, before a thundering thud with heavy winds moving past it.",
	"A mighty voice speaking, high above the recorder.",
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " &quot;There you are, Dear Weaver? What are you doing on such a quiet night, sitting all alone?&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Counting... Many more have fallen today, Over 100 guardians...&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;The Tinkerer is currently working on fixing the wounded, hopefully they will make recovery soon.&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " &quot;Who knows until those beasts return.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;My calculations are currently telling me that more will arrive within this week...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;It doesn’t look like they are getting any less relentless.&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;To think that our citizens are stuck in this endless cruelty...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Well, There isn't much we can do to change this, no matter where we move, danger will always follow us.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Such are the ways of the wilds...&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;Yet... There is something we could do, Dear Weaver.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Huh? What are you speaking of?&quot;"),
	"Sounds of heavy hydraulic presses rising up.",
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;There is one place which is free from this suffering of the wilds, a place which people can go to without worry of death.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;You can’t be taking of...&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;I believe it is time to seek out that place that folks have spoken of, I believe it is called “The City”.&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;I heard it is the oasis in the wilds, the one place where people can live at peace.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;But those are just rumors! Even if they are true there are just far too many unknown variables... &quot;"),
	span_game_say(span_name("The Weaver") + span_message(" exclaims,") + " &quot;It would take hundreds of years to even reach the general area where it might be!&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;At least here, everything is stable, we have a routine here an-.&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;Yet, Even as we follow our routine, hundreds of our citizens fall every week.&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " &quot;Would you call that, “Living?” Living in fear of the beasts and praying that you might live to see another day?&quot;"),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " &quot;You know just as well as I that this existence is no more than a living hell. This is not “Living.”&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;But the city, what if it rejects us? You know how fearful other clans are of strangers...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Saying out loud, you are called the “Warlord...” who knows how they will react.&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " &quot;That is but an old name, it has been millennia since I have last raised my blade against another survivor. Even still...&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " &quot;Think of it, Dear Weaver. The cityfolk must be the most hardened survivors of the wilds.&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " &quot;To build such an oasis, they must have struggled the most out of any survivors.&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " &quot;If there is anyone who would have empathy for us, it would be those who have sacrificed the most to reach this safety.&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" asks,") + " &quot;So, do you still have desire to stay here and endure this cruel existence.&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" asks,") + " &quot;Or, are you willing to make the first few steps, for a better future? Dear Weaver?&quot;"),
	"Sounds of a heavy hydraulic hand reaching down towards the Weaver’s voice."
	)

	timestamp = list(1, 8, 15, 22, 29, 36, 43, 50, 57, 64, 71, 78, 85, 92, 99, 106, 113, 120, 127, 134, 141, 148, 155, 162, 169, 176, 183, 190, 197, 204, 211, 218, 225, 232, 239)

/obj/item/tape/resurgence/redacted
	name = "{REDACTED}"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have something scratched out on it's back."
	storedinfo = list(
	"Hundreds, upon hundreds of metallic footsteps heaving through heavy sand, with small robotic chatter between the crowd... Heavier pair of footsteps in front of all the rest...",
	"A heavy voice heard much higher than all the rest",
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " &quot;Dear Tinkerer, What is our current statues on reaching the first checkpoint...&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;According to my scouts... It appears that the first checkpoint is only 4 miles away from us.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;We only have a few hours before approaching it.&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;To think... That after this whole time, we are fi-inally this close to the fa-abled City...&quot;"),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;At long last, all of this suffering will be over...&quot;"),
	"The footsteps from the Soft Robotic Voice suddenly stop, as a light thud is heard from Voice",
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Dear Historian, Is everything alright? Did something break or crack, do you need the Tinkerer too-&quot;"),
	"Light, sniffling? from the Soft Robotic Voice",
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;No-o worries Dear Weaver, I don’t kno-ow what's coming over me...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Oh if the other Elders could hear of this... If only they saw what we have finally reached...&quot;"),
	"Metallic pats heard from the Historian",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;I know it must be tough, having to leave our settlement, but it was the right thing to do.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Perhaps one day, they will hear of our success.&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Then they will finally understand us, and follow our path. What do you think, Dear Warlord?&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " &quot;I believe so, I heard that the City contains some of the most marvelous technology in the wilds. &quot;"),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " &quot;Perhaps we could use one of their “W-Corp” trains, the connect back with our fellows.&quot;"),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;There are even more marvels we could find, I am personally invested in how they weave their own outfits...&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Of course you would be looking for the tailors in the City dear Weaver...&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;You know what is truly the most fascinating thing in the City, down at District 20, it’s just filled with inventors like me!&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;To think they have a whole District dedicated to inventing, the City certainly has their priorities right.&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" announces,") + " &quot;Wait, Hold everyone... There is something approaching us.&quot;"),
	"All of the metallic footsteps slowly stop, as all of the muttering among the crowd quiets down.",
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;What is that? It looks like a... Strange metal worm?&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;I believe that is called a “Bullet Train” Weaver, but what is it doing out here... It would imagine that it-&quot;"),
	"Thunderous rumble suddenly overpowers all nearby sounds, shattering the sound barrier around the recorder...",
	"Winds bursting from the sound, with mights of a storm swinging past the recorder...",
	"Eventually... The winds calm down, as a bellowing horn in this distance.",
	span_game_say(span_name("The Weaver") + span_message(" worriedly,") + " &quot;Is this... One of the City’s inventions? Such speed...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;And power behind it...&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Huh... They appear to be surrounding us... &quot;"),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " &quot;This is a bit strange for a security check... But stay calm everyone, We don’t want to make our first impression a threatening one...&quot;"),
	"A thud from where the thundering sound stopped, followed by a synchronized march",
	span_game_say(span_name("Unknown Human Voice") + span_message(" shouts,") + " &quot;Z-Corp Class 3 Security Agent Captain here, A Class 5 Warlord Titan has been found approaching the City! Restrictions on Class 4 Weapons has been lifted!&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Weaponry? I-I think there is miss understanding here... We are not he-ere too-&quot;"),
	span_game_say(span_name("Unknown Human Voice") + span_message(" shouts,") + " &quot; All units have been armed, Open fire!&quot;"),
	"From all sides, blazing shots firing towards the recorder, crackling sounds sound the air...",
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " &quot;NO, EVERYONE BEHIND ME!&quot;"),
	"An electric buzz quickly sounds the recorder, as quick zips around the buzz...",
	"Around the electric buzz, glitching screams quickly rise and fade with swift punctures...",
	"Metallic footsteps rush over to the electric buzz, some moving past the sound...",
	"Many more end with a thud away from the electric buzz...",
	span_game_say(span_name("The Historian") + span_message(" screams,") + " &quot;NO... NO!!! RUN FASTER, RUN OVER HERE!!!&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" terrifiedly,") + " &quot;No... They- are all melted, nothing reminds of them... Wha-at... did we do wrong...&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Damit... They are leaving no room for us to run... They completely inclosed us...&quot;"),
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " &quot;IF THEY ARE NOT LETTING US RUN BACK!...&quot;"),
	"Sounds of an engine blazing from the Warlord...",
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " &quot;WE SHALL KEEP MOVING!...&quot;"),
	"Heavy tremors heard from the Warlord, start moving towards the gunfire...",
	"Followed by an explosive crush from one side of the gunfire...",
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " &quot;MOVE EVERYONE, I WILL HOLD THIS OPENING!...&quot;"),
	"Hundreds of mechanical footsteps rushing towards the Warlord’s voice...",
	span_game_say(span_name("The Historian") + span_message(" screams,") + " &quot;WARLORD... WE CAN’T LEAVE YOU-&quot;"),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;WE DON’T HAVE TIME TO HESITATE, FOCUS ON ESCORTING THE CIVILIANS!&quot;"),
	"As the voices of the other Elders start moving away from the Warlord...",
	"A shot rings out towards the recorder, Quickly cutting this recording short."
	)

	timestamp = list(1, 7, 13, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91, 97, 103, 109, 115, 121, 127, 133, 139, 145, 151, 157, 163, 169, 175, 181, 187, 193, 199, 205, 211, 217, 223, 229, 235, 241, 247, 253, 259, 265, 271, 277, 283, 289, 295, 301, 307, 313, 319, 325, 331, 337)

// /obj/item/tape/resurgence/dreams
// 	name = "Historians Podcast: Elliot's Day"
// 	desc = "A magnetic tape that can hold up to ten minutes of content. It apper to have 'Elliot's Big Day' written on it's back."
// 	storedinfo = list(
// 	"Sounds of robotic laughter in the background along with some clapping.",
// 	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Thank you all for tuning in for tonight's episode! All of you learned a good amount about the Liu today!&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;It was been the Historian speaking today and see you all, Next week!&quot;"),
// 	"Suddenly all of the clapping stops as a screen shuts down...",
// 	span_game_say(span_name("The Historian") + span_message(" sighs")),
// 	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;Cut! You did great, dear Historian! You followed your script perfectly.&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yes, As it always is...&quot;"),
// 	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;Now, Since we have some time until the podcast is uploaded what should we discuss next week?&quot;"),
// 	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;I know! I always wanted to know more about U-Cor.&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" asks,") + " &quot;Please, Max. Can you give me a small moment. I just need to, think through some things.&quot;"),
// 	span_game_say(span_name("Max") + span_message(" says,") + " &quot;Oh, Sorry dear Historian. I will make my way then...&quot;"),
// 	"Metallic footsteps moving away, followed by a door opening and closing.",
// 	"Beeps and clicks coming from a device.",
// 	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Excuse me, I am currently working right now so if you have any complaints...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Sorry for interrupting you dear Weaver, I was just wondering if you had a moment to talk.&quot;"),
// 	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Oh. Sorry for not recognizing you Historian. There are so many requests today, you would not believe it.&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yep, Everyone is pretty excited about the recent cityfolk which came here.&quot;"),
// 	span_game_say(span_name("The Weaver") + span_message(" asks,") + " &quot;So, Why did you call me at this time?&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;You know, I have been thinking... Do you think the citizens are living a contentful life?&quot;"),
// 	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Well, Looking at how all of them are happy. Have goals and dreams, I would say so.&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yes, They all have dreams and recent events must have brought them hope... &quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;But what happens if they learn how those dreams are...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Flawed...&quot;"),
// 	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Nothing good, Nothing good will happen. I can't that happen.&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;But...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;How long can I hide this truth from them...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They are all so innocent, They will eventually start making plans to fulfill their dreams.&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They will all start leaving with a happy simile...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;“I will finally reach it, we can leave this harrowing life to rejoice in this paradise...”&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Then they will learn it's true nature, it's heartless nature...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They will even learn how he-&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;died for nothing...&quot;"),
// 	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;I... Wish I had a answer for that...&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Sorry Weaver... I just had no else to talk too.&quot;"),
// 	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;We should return to our duties. The citizens need us.&quot;"),
// 	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;We shall do our best for them...&quot;"),
// 	"The tape ends after a beep is heard from a device.",
// 	)

// 	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116, 121, 126, 131, 136, 141, 146, 151, 156, 161, 176, 181, 186, 191, 196)

