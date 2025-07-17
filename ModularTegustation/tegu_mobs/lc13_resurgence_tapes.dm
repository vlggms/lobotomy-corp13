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
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Resurgence Clan's first move.' written on its back."

	storedinfo = list(
		"Loud sounds of machinery and human screams could be heard in the background...",
		span_game_say(span_name("Unknown Robotic Voice") + span_message(" yells,") + " \"Dammit... WHY CAN’T YOU JUST SHUT UP!!!\""),
		span_game_say(span_name("Human Voice") + span_message(" coughs")),
		span_game_say(span_name("Human Voice") + span_message(" weakly says,") + " \"Who- What the hell are you-u... I ju-ust wanted to\""),
		span_game_say(span_name("Human Voice") + span_message(" coughs loudly yet weakly")),
		span_game_say(span_name("Human Voice") + span_message(" weakly says,") + " \"Pass by thi-is town... Please, My family is waiting for me...\""),
		span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " \"Oh, There are more of you meatbags nearby? Pleasurable to know... \""),
		span_game_say(span_name("Unknown Robotic Voice") + span_message(" yells,") + " \"HEY YOU, YES YOU. THE SCOUT IN THE BACK, PASS OVER THE DRILL.\""),
		span_game_say(span_name("Scout") + span_message(" says,") + " \"Ye-es Tinke-er.\""),
		span_game_say(span_name("Human Voice") + span_message(" weakly says,") + " \"Wha-at are you doing... Wait! I can still provide something for you! Do you need gears or me-\""),
		span_game_say(span_name("Human Voice") + span_message(" screams")),
		"Sounds of drills and saws tearing into flesh are heard before a heavy door is heard screeching open…",
		span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"Dear Tinkerer... Was this why you wanted me to give you this new human to you?\""),
		span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"At least I could have woven them into something much more valuable than fresh gibs…\""),
		"The sounds of drills and saws slowly slowed down...",
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Oh? Didn’t expect you to arrive here today Mister Weaver, Were you this worried about this human?\""),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " \"No, With the recent events that occurred here with the... FLS members and my citizens have been much more opposed to using humans as materials.\""),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " \"After all, once you get to meet the humans you are using to become more human it does feel more sinful of using them this way…\""),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " \"No, I am here to deliver some... Rather upsetting news to you...\""),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Really now? You got to drown out my perfectly fine mood after executing a monster...\""),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Yet, It has to be said. After discussing this with the Historian, We have decided that this town is no place for you.\""),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " \"So I kindly ask you to kindly leave this town soon...\""),
		"A loud fleshy crunch is heard coming from the human head...",
		span_game_say(span_name("The Tinkerer") + span_message(" whispers,") + " \"I really should have seen that one coming yet...\""),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"No big deal, I can start moving tomorrow. This place was quite limiting after all.\""),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Thank you for understanding our decision, as it was not an easy one we ma-\""),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Yada yada... No need to exaggerate this. This ‘difficult decision’ only took you like, 12 hours to make.\""),
		span_game_say(span_name("The Tinkerer") + span_message(" yells,") + " \"ALL OF THE SCOUTS HERE, YOU BETTER START MOVING NOW!...\""),
		span_game_say(span_name("Scout") + span_message(" yells,") + " \"Ye-es Sir, Moving o-out...\""),
		span_game_say(span_name("Scout") + span_message(" yells,") + " \"Yes Si-ir, Moving ou-ut...\""),
		span_game_say(span_name("Scout") + span_message(" yells,") + " \"Ye-es Sir, Mo-ov...\""),
		"The Tape cuts after around 4-5 pairs of metallic footsteps move across the metal floor.")
	timestamp = list(2, 4, 8, 12, 16, 20, 26, 30, 34, 38, 41, 45, 52, 56, 59, 62, 67, 72, 77, 81, 86, 91, 94, 97, 102, 107, 110, 115, 119, 123, 126, 129, 132)

/obj/item/tape/resurgence/podcast_seven
	name = "Historians Podcast: Seven Association"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Episode 1' written on its back."
	storedinfo = list(
		span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Is everything ready? The Podcast is starting in 3 secon- Oh!\""),
		"Lights start flickering on as a jingle plays in the background...",
		span_game_say(span_name("Soft Robotic Voice") + span_message(" whispers,") + " \"Wait, I am still not ready for this... Oh dear, Um...\""),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " \"Well, Hello my dear Citizens! What a brilliant new day in the outskirts as I, the Historian of district H will be teaching you about the different associations in the City today!\""),
		"In the background, some object slowly starts winding up…",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " \"To start us off, We will be talking about the Seven! From our current record which we have gathered from the telescope, They like the Color Green? Could they love plants? After all, they also like making tea...\" "),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " \"They are also Detectives, So they must be some real pesky ones. Poking their noses wherever possible.\""),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " \"They most often use simple shortswords in battle which are wonderful at opening up wounds in targets! So basically they use very sharp crowbars and their foes are crates to be ripped open!\""),
		"A robotic laughter in the background, the winding from the object in the background stops.",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " \"There we are! Now we can observe one of those seven fixers named...\""),
		"Sounds of papers being flipped.",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " \"Moses and Ezra? Yep, Them! They are some of the most talented members you can find in this association! As seen by their...\""),
		"Awfully long pause occurs, mechanical gasps in the background.",
		span_game_say(span_name("The Historian") + span_message(" stutters,") + " \"Well, Um... Very strong bonds? Ignore the face of the yellow haired girl, She is proud to be in this office as they call it!\""),
		"A quick sound of a gears winding back.",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " \"Okay, Moving back our usual point of view...\"")
	)

	timestamp = list(2, 5, 8, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59, 64, 69, 74)

/obj/item/tape/resurgence/temple_of_motus
	name = "Expedition Log #32"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Our Temple...' written on its back."
	storedinfo = list(
		"Mechanical Footsteps are heard moving across an empty desert, along with the sounds of wheels moving behind them…",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Hey, Head Priest. Do you have any idea of how much time is left until we reach this Temple…\""),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"It has been around a whole month since we started this journey…\""),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"We will arrive there in time, after all the Historian did say that this would be a long journey.\""),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Alright, Can you at least us what we will be doing there?\""),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"I think that we have already proven that we are dedicated to this project.\""),
		"Flipping of pages comes from the Old Robotic Voice…",
		span_game_say(span_name("Old Robotic Voice") + span_message(" asks,") + " \"Scholar, Do you recognize this book?\""),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Of course I do! This is ‘The Exploration of Love and Fear,’ written by you. Any Scholar should know it by soul if they wish to pass the first class.\""),
		span_game_say(span_name("Old Robotic Voice") + span_message(" asks,") + " \"Good, and how do you think I was able to explore those emotions I wrote about?\""),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Well… I thought that you are an old machine, being one of the first few machines who moved during the Great Migration.\""),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"That you were able to learn those emotions using your experience, or something vague like that.\""),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Good guess Scholar, but you don’t just ‘learn things’ with experience. You need to do something to earn it…\""),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"You need to get close to humans, to study them to learn how they interact with those emotions.\""),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Okay, But it is not like we get to see them all that often, most of the time they either run away or attack us on sight…\""),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"And that's where our Temple comes in.\""),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"This temple is our closest contact to humans without being detected. Along with holding all of the tools we need to study them.\""),
		"The Mechanical footsteps stop.",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Um, Head Priest. Are we stopping now? There is still around 10 hours until the sun goes down.\""),
		"4 small knocks come from the Old Robotic Voice",
		"The ground begins to rumble… as crumbling rocks and shifting gears rises from the ground, before ending in a thud.",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" stutters,") + " \"How… how could it all be hidden that easily…\""),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Now, Dear Scholar. Welcome to the Temple of Motus.\"")
	)

	timestamp = list(1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89, 93)

/obj/item/tape/resurgence/new_library
	name = "Temple Log #1"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'The Library' written on its back."
	storedinfo = list(
	"Sounds of shifting machinery and distant conversations",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Scholar, How is progress on getting everyone settled in?\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"All great sir! Everyone has been able to find their rooms in the temple and we are about to offload all of our supplies!\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Understood, It appears that I will need to speak with the Historian soon… I can give you a basic rundown of your duties before I go.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Got it sir. Where shall we begin?\""),
	"A pair of mechanical footsteps, then a heavy door slides open…",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"One of the basic responsibilities you will hold in this temple is to keep our library up to date. As studies are completed, it may cause some books to become outdated.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Either way you will not be taking part in the studies for now since you are new, but at least you will be tasked with watching them and taking notes.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Please use those opportunities to learn our ways around here...\""),
	"The Old Robotic Voice slows down.",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Now now, I know you are interested in what studies these books hold but we still need to get over your duties.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Oh, Sorry Sir. You need to understand what a change this is, Back at the town I got access to only like… 2 books a month?\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Now I have the whole library open! Holding so many new experiences! Like “Aversion” or “Contentment…”\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Oh, Sorry for taking up more of your time… Where do we need to go next?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Well, How about I show you our repair bench? You will get many chances to speak with other members about this place, old and new!\""),
	"The tape cuts right as the heavy door slides closed…"
	)

	timestamp = list(1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61)

/obj/item/tape/resurgence/joshua
	name = "Temple Log #15"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'New Friend?' written on its back."
	storedinfo = list(
	"Sounds of distant conversations slowly moving away...",
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"That was quite a procedure! Fascinating how the human brain is able to produce such emotions. \""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Thank the Historian that I was able to record all of...\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Wait, Shoot... Don't tell me that it was off the whole time...\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Well one of my seniors must have left one spare recording here...\""),
	span_game_say(span_name("Distant Robotic Voice") + span_message(" says,") + " \"Hey! Elliot! Are you still in the study room?\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Yes-s. Just give me just a moment, I think I have forgotten something here...\""),
	span_game_say(span_name("Distant Robotic Voice") + span_message(" says,") + " \"Okay... Just get out of there soon, other scholars will be using it soon.\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Of course... I would not want to prevent the study!\""),
	"Sounds of books and metallic objects being thrown around.",
	span_game_say(span_name("Human Voice") + span_message(" coughs")),
	span_game_say(span_name("Elliot") + span_message(" asks,") + " \"Oh... It appears that they are already waking up. I really should get moving.\""),
	span_game_say(span_name("Human Voice") + span_message(" says weakly,") + " \"Wait... Who are you, why am I here...\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Um... Normally we young scholars don't get the chance to speak with you.\""),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " \"Scholars... Wait, Oh fuck... What have I gotten myself into.\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Oh please don't use such rude language around here. The Priest doesn't like hearing it.\""),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " \"Well “Scholar”, Sorry for not acting all pleasant to you after waking up tied up to a metal bed.\""),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " \"Especially when I see your steel face...\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Really? Is it really that disconcerting... I tried so hard to mimic how a human face looks like...\""),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " \"Ha... That is the problem. You are trying far too hard. I heard that it causes some sort of uncanny effect.\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Oh! Now that is something to note down... “Don't try too hard when mimicking a human face...” \""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"You know what pal. We should have more talks like these!\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"It is so much more fun talking to you rather then listening to my teachers just yap on and on...\""),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " \"Well, It isn't like I have much choice...\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Wonderful! I have to get going now but what is your name so I could remember it?\""),
	span_game_say(span_name("Joshua") + span_message(" says,") + " \"... Call me Joshua.\""),
	"The tape cuts right after some quick footsteps are heard moving out of the room."
	)

	timestamp = list(1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89, 93, 97, 101, 105, 109)

/obj/item/tape/resurgence/backstage
	name = "Historians Podcast: Backstage Records"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Backstage Records' written on its back."
	storedinfo = list(
	"Sounds of robotic laughter in the background along with some clapping.",
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Thank you all for tuning in for tonight's episode! All of you learned a good amount about the Liu today!\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"It has been the Historian speaking today and see you all, Next week!\""),
	"Suddenly all of the clapping stops as a screen shuts down...",
	span_game_say(span_name("The Historian") + span_message(" sighs")),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " \"Cut! You did great, dear Historian! You followed your script perfectly.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Yes, As it always is...\""),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " \"Now, Since we have some time until the podcast is uploaded what should we discuss next week?\""),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " \"I know! I always wanted to know more about U-Cor.\""),
	span_game_say(span_name("The Historian") + span_message(" asks,") + " \"Please, Max. Can you give me a small moment. I just need to, think through some things.\""),
	span_game_say(span_name("Max") + span_message(" says,") + " \"Oh, Sorry dear Historian. I will make my way then...\""),
	"Metallic footsteps moving away, followed by a door opening and closing.",
	"Beeps and clicks coming from a device.",
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"Excuse me, I am currently working right now so if you have any complaints...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Sorry for interrupting you dear Weaver, I was just wondering if you had a moment to talk.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Oh. Sorry for not recognizing you Historian. There are so many requests today, you would not believe it.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Yep, Everyone is pretty excited about the recent cityfolk which came here.\""),
	span_game_say(span_name("The Weaver") + span_message(" asks,") + " \"So, Why did you call me at this time?\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"You know, I have been thinking... Do you think the citizens are living a contentful life?\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Well, Looking at how all of them are happy. Have goals and dreams, I would say so.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Yes, They all have dreams and recent events must have brought them hope... \""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"But what happens if they learn how those dreams are...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Flawed...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Nothing good, Nothing good will happen. I can't let that happen.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"But...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"How long can I hide this truth from them...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"They are all so innocent, They will eventually start making plans to fulfill their dreams.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"They will all start leaving with a happy smile...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"“I will finally reach it, we can leave this harrowing life to rejoice in this paradise...”\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Then they will learn its true nature, its heartless nature...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"They will even learn how he-\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"died for nothing...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"I... Wish I had an answer for that...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Sorry Weaver... I just had no one else to talk to.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"We should return to our duties. The citizens need us.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"We shall do our best for them...\""),
	"The tape ends after a beep is heard from a device.",
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116, 121, 126, 131, 136, 141, 146, 151, 156, 161, 176, 181, 186, 191, 196)

/obj/item/tape/resurgence/gateway
	name = "Tinkerer's Logs: New Invention"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'New Invention' written on its back."
	storedinfo = list(
	"Sounds of mechanical drilling and machinery clicking.",
	"In the background, a heavy door starts sliding open... 2 pairs of footsteps walking closer",
	span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " \"Agh... That’s not efficient enough.\""),
	span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " \"Gregory, It looks like this reactor will not be enough for this project.\""),
	span_game_say(span_name("Unknown Robotic Voice") + span_message(" says,") + " \"Just throw it back into the factory, It perhaps might find use in another project...\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Ahm... Dear Tinkerer.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"The Historian and The Weaver! Sorry that I didn’t catch the both of you. \""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"But nevertheless, I am very thankful that you all could make it here!\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Well, You seem quite insistent on us arriving today.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"”I have something of utmost importance to present before us”, You said something like that.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"The last time you were this passionate about something was when you finally learned how to repair cores.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"It brings back memories... It has been so long since we have started this town.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"And thanks to our efforts, it seems to be growing.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"I am telling you, more and more folk are finally starting to understand us!\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Anyways, About this thing you wanted to show us...\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Right! Let me bring it over.\""),
	"Mechanical sounds heard moving up...",
	"Mechanical sounds heard moving down, along with a long hydraulic sound moving closer...",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Now my Dear Elders, I now present before you...\""),
	"Dramatic pause...",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"The Gateway! The invention which will bring us one step closer to City.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Hm... Looks interestingly built, I also like the details you put into it’s design.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Wow! It looks complex. The Weaver will probably better understand it, not that good with machines at this scale.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Thank you! Now, once this project will be refined, we will be able to teleport our people in and out of the city!\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Oh, Didn’t expect that we would be able to see it that soon...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Refined?\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Well, Currently it does require a large amount of power for a single use... It takes around a month to launch but only a single Citizen.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"But, It will be improved in time just letting you know to start preparations...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"We see... We shall then start prepare for it.\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"You continue to amaze me, Dear Tinkerer... I can only dream of what we can do with this...\""),
	"Awkward pause...",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Hm? Something bothering you? Isn't this one of your dream coming true?\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"To finally show the citizens the beauty of the City?\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"The oh so land of dreams...\""),
	"A mechanical sliding sound is heard moving towards The Historian voice.",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Don’t you? Oh so dear Elder?\""),
	span_game_say(span_name("The Historian") + span_message(" shudderingly says,") + " \"Ye-es... How could I not be excited? Ha...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"That’s enough, Tinkerer. We should be returning to our duties by now.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Very well, I shall return to my duties...\""),
	"2 pairs of mechanical footsteps head walking away, along with a door sliding shut.",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"I hope you get what you wished for...\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Native Historian...\"")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116, 121, 126, 131, 136, 141, 146, 151, 156, 161, 166, 171, 176, 181, 186, 191, 196, 201, 206)

/obj/item/tape/resurgence/solution
	name = "Historians's Logs: The Solution"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'The Solution' written on its back."
	storedinfo = list(
	"The rustling of papers, along with a deep mechanical sigh.",
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"They... Have been planning for this all along...\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"The Gateway... They were never planning on using it to teach our citizens.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"How could I be so naive...\""),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"That is now in the past... They are now no longer here, and we need to pick ourselves back up.\""),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"Morale is not looking well right now, especially after the incident caused by The Tinkerer.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"... We could try to finally start this project, now that we have access to his blueprints.\""),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"That is a risky maneuver, we have not ever tried to use this tech without the Tinkerer’s assistance.\""),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"And we don’t even know if this plan will work in the first place.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"No wait, but look over here.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"It appears that they have been doing this already for a long time now.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Teleporting their own followers into the City...\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"And as long as they have their consciousness reduced... They will not be targeted by the City.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"This can be also seen with the spear and gun bots sometimes spotted in their backstreets. And the AI that the Devyat carry around.\""),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"Hm... Looks like they really do have quite the integrating notes about this.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"This means, we can start the shell program.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Using his tech, we will be able to build shells of our citizens, and then build a makeshift town.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Give the shells some basic functions, and then using the gateway we can send them, and the town into the city...\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Then, once we are able to bring them back in after the week, we can transfer all of the good memories of the City, back into our citizens.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"Hopefully, this can bring back hope to our citizens...\""),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"... Are you sure, Dear Historian? You are shaking...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"This... Must work, I can’t just let my citizens fall into despair... I can’t...\"")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116)

/obj/item/tape/resurgence/his_dream
	name = "Weavers's Logs: His Dream"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'His Dream' written on its back."
	storedinfo = list(
	"Quiet gust of wind, clicking and taps from a typewriter.",
	"Slow and loud mechanical footsteps moving closer to the typewriter sounds.",
	"A pause for a moment, before a thundering thud with heavy winds moving past it.",
	"A mighty voice speaking, high above the recorder.",
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " \"There you are, Dear Weaver? What are you doing on such a quiet night, sitting all alone?\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Counting... Many more have fallen today, Over 100 guardians...\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"The Tinkerer is currently working on fixing the wounded, hopefully they will make recovery soon.\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " \"Who knows until those beasts return.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"My calculations are currently telling me that more will arrive within this week...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"It doesn’t look like they are getting any less relentless.\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"To think that our citizens are stuck in this endless cruelty...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Well, There isn't much we can do to change this, no matter where we move, danger will always follow us.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Such are the ways of the wilds...\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"Yet... There is something we could do, Dear Weaver.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Huh? What are you speaking of?\""),
	"Sounds of heavy hydraulic presses rising up.",
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"There is one place which is free from this suffering of the wilds, a place which people can go to without worry of death.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"You can’t be taking of...\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"I believe it is time to seek out that place that folks have spoken of, I believe it is called “The City”.\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"I heard it is the oasis in the wilds, the one place where people can live at peace.\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"But those are just rumors! Even if they are true there are just far too many unknown variables... \""),
	span_game_say(span_name("The Weaver") + span_message(" exclaims,") + " \"It would take hundreds of years to even reach the general area where it might be!\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"At least here, everything is stable, we have a routine here an-.\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"Yet, Even as we follow our routine, hundreds of our citizens fall every week.\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " \"Would you call that, “Living?” Living in fear of the beasts and praying that you might live to see another day?\""),
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" says,") + " \"You know just as well as I that this existence is no more than a living hell. This is not “Living.”\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"But the city, what if it rejects us? You know how fearful other clans are of strangers...\""),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"Saying out loud, you are called the “Warlord...” who knows how they will react.\""),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " \"That is but an old name, it has been millennia since I have last raised my blade against another survivor. Even still...\""),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " \"Think of it, Dear Weaver. The cityfolk must be the most hardened survivors of the wilds.\""),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " \"To build such an oasis, they must have struggled the most out of any survivors.\""),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " \"If there is anyone who would have empathy for us, it would be those who have sacrificed the most to reach this safety.\""),
	span_game_say(span_name("The Warlord") + span_message(" asks,") + " \"So, do you still have desire to stay here and endure this cruel existence.\""),
	span_game_say(span_name("The Warlord") + span_message(" asks,") + " \"Or, are you willing to make the first few steps, for a better future? Dear Weaver?\""),
	"Sounds of a heavy hydraulic hand reaching down towards the Weaver’s voice."
	)

	timestamp = list(1, 8, 15, 22, 29, 36, 43, 50, 57, 64, 71, 78, 85, 92, 99, 106, 113, 120, 127, 134, 141, 148, 155, 162, 169, 176, 183, 190, 197, 204, 211, 218, 225, 232, 239)

/obj/item/tape/resurgence/redacted
	name = "{REDACTED}"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have something scratched out on it's back."
	storedinfo = list(
	"Hundreds, upon hundreds of metallic footsteps heaving through heavy sand, with small robotic chatter between the crowd... Heavier pair of footsteps in front of all the rest...",
	"A heavy voice heard much higher than all the rest",
	span_game_say(span_name("Mighty Robotic Voice") + span_message(" asks,") + " \"Dear Tinkerer, What is our current status on reaching the first checkpoint...\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"According to my scouts... It appears that the first checkpoint is only 4 miles away from us.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"We only have a few hours before approaching it.\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"To think... That after this whole time, we are fi-inally this close to the fa-abled City...\""),
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " \"At long last, all of this suffering will be over...\""),
	"The footsteps from the Soft Robotic Voice suddenly stop, as a light thud is heard from Voice",
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"Dear Historian, Is everything alright? Did something break or crack, do you need the Tinkerer too-\""),
	"Light, sniffling? from the Soft Robotic Voice",
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"No-o worries Dear Weaver, I don’t kno-ow what's coming over me...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Oh if the other Elders could hear of this... If only they saw what we have finally reached...\""),
	"Metallic pats heard from the Historian",
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"I know it must be tough, having to leave our settlement, but it was the right thing to do.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Perhaps one day, they will hear of our success.\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Then they will finally understand us, and follow our path. What do you think, Dear Warlord?\""),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " \"I believe so, I heard that the City contains some of the most marvelous technology in the wilds. \""),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " \"Perhaps we could use one of their “W-Corp” trains, the connect back with our fellows.\""),
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " \"There are even more marvels we could find, I am personally invested in how they weave their own outfits...\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Of course you would be looking for the tailors in the City dear Weaver...\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"You know what is truly the most fascinating thing in the City, down at District 20, it’s just filled with inventors like me!\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"To think they have a whole District dedicated to inventing, the City certainly has their priorities right.\""),
	span_game_say(span_name("The Warlord") + span_message(" announces,") + " \"Wait, Hold everyone... There is something approaching us.\""),
	"All of the metallic footsteps slowly stop, as all of the muttering among the crowd quiets down.",
	span_game_say(span_name("The Weaver") + span_message(" says,") + " \"What is that? It looks like a... Strange metal worm?\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"I believe that is called a “Bullet Train” Weaver, but what is it doing out here... It would imagine that it-\""),
	"Thunderous rumble suddenly overpowers all nearby sounds, shattering the sound barrier around the recorder...",
	"Winds bursting from the sound, with mights of a storm swinging past the recorder...",
	"Eventually... The winds calm down, as a bellowing horn in this distance.",
	span_game_say(span_name("The Weaver") + span_message(" worriedly,") + " \"Is this... One of the City’s inventions? Such speed...\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"And power behind it...\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Huh... They appear to be surrounding us... \""),
	span_game_say(span_name("The Warlord") + span_message(" says,") + " \"This is a bit strange for a security check... But stay calm everyone, We don’t want to make our first impression a threatening one...\""),
	"A thud from where the thundering sound stopped, followed by a synchronized march",
	span_game_say(span_name("Unknown Human Voice") + span_message(" shouts,") + " \"Z-Corp Class 3 Security Agent Captain here, A Class 5 Warlord Titan has been found approaching the City! Restrictions on Class 4 Weapons has been lifted!\""),
	span_game_say(span_name("The Historian") + span_message(" says,") + " \"Weaponry? I-I think there is miss understanding here... We are not he-ere too-\""),
	span_game_say(span_name("Unknown Human Voice") + span_message(" shouts,") + " \" All units have been armed, Open fire!\""),
	"From all sides, blazing shots firing towards the recorder, crackling sounds sound the air...",
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " \"NO, EVERYONE BEHIND ME!\""),
	"An electric buzz quickly sounds the recorder, as quick zips around the buzz...",
	"Around the electric buzz, glitching screams quickly rise and fade with swift punctures...",
	"Metallic footsteps rush over to the electric buzz, some moving past the sound...",
	"Many more end with a thud away from the electric buzz...",
	span_game_say(span_name("The Historian") + span_message(" screams,") + " \"NO... NO!!! RUN FASTER, RUN OVER HERE!!!\""),
	span_game_say(span_name("The Weaver") + span_message(" terrifiedly,") + " \"No... They- are all melted, nothing reminds of them... Wha-at... did we do wrong...\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"Damit... They are leaving no room for us to run... They completely inclosed us...\""),
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " \"IF THEY ARE NOT LETTING US RUN BACK!...\""),
	"Sounds of an engine blazing from the Warlord...",
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " \"WE SHALL KEEP MOVING!...\""),
	"Heavy tremors heard from the Warlord, start moving towards the gunfire...",
	"Followed by an explosive crush from one side of the gunfire...",
	span_game_say(span_name("The Warlord") + span_message(" shouts,") + " \"MOVE EVERYONE, I WILL HOLD THIS OPENING!...\""),
	"Hundreds of mechanical footsteps rushing towards the Warlord’s voice...",
	span_game_say(span_name("The Historian") + span_message(" screams,") + " \"WARLORD... WE CAN’T LEAVE YOU-\""),
	span_game_say(span_name("The Tinkerer") + span_message(" says,") + " \"WE DON’T HAVE TIME TO HESITATE, FOCUS ON ESCORTING THE CIVILIANS!\""),
	"As the voices of the other Elders start moving away from the Warlord...",
	"A shot rings out towards the recorder, Quickly cutting this recording short."
	)

	timestamp = list(1, 7, 13, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91, 97, 103, 109, 115, 121, 127, 133, 139, 145, 151, 157, 163, 169, 175, 181, 187, 193, 199, 205, 211, 217, 223, 229, 235, 241, 247, 253, 259, 265, 271, 277, 283, 289, 295, 301, 307, 313, 319, 325, 331, 337)

/obj/item/tape/resurgence/fly_research
	name = "Temple Log #47"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Parasite Study' written on its back."
	storedinfo = list(
	"Sounds of buzzing insects and bubbling liquids in the background...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Research log forty-seven, studying the peculiar insects that have infested Study Room A.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"These creatures, which we have termed 'Mad Flies', display fascinating behavioral patterns.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Unlike normal insects, they seem to target the human psyche directly.\""),
	"Sound of glass containers being moved...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Their bites inflict minimal physical damage, but cause significant mental distress.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Multiple rapid strikes overwhelm the victim's ability to focus or think clearly.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Head Priest, is it true they can... enter a human's body?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Indeed, Scholar. But only those who have completely lost their sanity.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"The swarm appears to recognize when a human's mental defenses have collapsed.\""),
	"Sounds of frantic buzzing growing louder...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Once inside, they begin consuming the host from within, dealing continuous tissue damage.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"How horrifying... But wait, what happens when the host expires?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"That is where it becomes truly fascinating. Upon the host's death...\""),
	"Sound of something wet bursting...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"The swarm bursts forth in a grotesque display, and if no other swarm was present...\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"They immediately construct a new nest from the remains.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"A nest? You mean those strange egg-like structures?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Precisely. These nests are remarkably resilient, especially against mental attacks.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"They continuously produce new swarms, maintaining up to two active at any time.\""),
	"Sound of mechanical extraction equipment activating...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Most intriguingly, the nests produce a chemical compound we can harvest.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"This substance appears to be a powerful mental stabilizer.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Mental stabilizer? From creatures that drive people mad?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Ironic, isn't it? Perhaps it's how they control their panicked victims.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"We can extract approximately five units every minute from each nest.\"")
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 102)

/obj/item/tape/resurgence/fly_research2
	name = "Temple Log #48"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Parasite Study Follow-up' written on its back."
	storedinfo = list(
	"Sounds of distant screaming and buzzing...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" urgently says,") + " \"Research log forty-eight, emergency addendum to the mad fly studies.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"One of our test subjects has... provided unexpected data.\""),
	span_game_say(span_name("Human Voice") + span_message(" screams,") + " \"GET THEM OUT! GET THEM OUT OF ME!\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Subject twelve was exposed to swarm attacks until complete sanity loss occurred.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"As predicted, the swarm immediately burrowed into his flesh upon detecting his condition.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" worriedly says,") + " \"Should we not help him, Head Priest?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"This is valuable data, Scholar. Observe how his body instinctively tries to reject them.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"But once sanity returns, even partially, the swarms are expelled violently.\""),
	"Sound of retching and buzzing...",
	span_game_say(span_name("Human Voice") + span_message(" weakly says,") + " \"Please... no more... I can feel them moving...\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Note how the internal damage accumulates rapidly - approximately five units per cycle.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"At this rate, a human host can survive perhaps... thirty cycles at most.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"The nests seem to be reacting to his distress...\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Yes, production increases when fresh hosts are nearby. Fascinating adaptation.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Scholar, prepare the harvesting equipment. We'll need more stabilizer after this.\""),
	"A wet tearing sound, followed by a thud...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" coldly states,") + " \"Subject twelve has expired. Observe the emergence pattern...\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"By the Historian... they're building a new nest right from his...\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Indeed. The cycle continues. Life from death, madness from sanity.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Perhaps these creatures understand humanity better than we thought.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"After all, they only thrive where the human mind has already shattered.\""),
	"Sounds of machinery shutting down as the recording ends..."
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94)

/obj/item/tape/resurgence/rose_research
	name = "Temple Log #52"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Botanical Study' written on its back."
	storedinfo = list(
	"Sounds of rustling vines and dripping liquids...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Research log fifty-two, examining the peculiar flora that has brought in for examination.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"The specimen we call 'Scarlet Rose' displays remarkable regenerative and defensive properties.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Head Priest, these vines... they seem to be spreading on their own?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Indeed. The rose acts as a central hub, controlling all vines within approximately ten meters.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"The vines expand continuously, creating a defensive network around the parent plant.\""),
	"Sound of footsteps on organic matter, followed by a sharp gasp...",
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Agh! The thorns... they cut right through my plating!\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Fascinating. The vines react to movement, lacerating anything that passes through.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"They inflict both immediate damage and continuous bleeding.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Is there any way to pass through safely?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Sharp implements can clear a path, but the vines often retaliate before being severed.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Multiple attempts are usually required to force passage - the vines entangle and resist.\""),
	"Sound of extraction equipment being prepared...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Most intriguingly, the rose produces a potent acid we can harvest.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Sal acid - fifteen units can be extracted every minute from a mature specimen.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"Every minute? That's much more frequent than the fly nests!\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"The rose's metabolism is quite active. Observe how it pulses with each production cycle.\""),
	"Sound of a metallic object falling, and quick spark...",
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" shouts,") + " \"Shot, shot, shot... Head Priest! I just ignited the rose... Where is the extinguisher!?!\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" calmly says,") + " \"No wait, dear scholar. Watch what happens when the central rose perishes...\""),
	"Sound of wilting and rapid decay...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"All connected vines wither within seconds. A fascinating symbiotic network.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"And see? It leaves behind a seed. Plant it, and within minutes, a new colony begins.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"The growing sprout seems more vulnerable than the mature rose...\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Yes, but it quickly develops its defenses. The cycle of growth and death continues.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Perhaps there's a lesson here about the persistence of life... even hostile life.\""),
	"The sound of vines slowly creeping across the floor as the recording ends..."
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118)

/obj/item/tape/resurgence/rose_research2
	name = "Temple Log #53"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Botanical Study - Human Testing' written on its back."
	storedinfo = list(
	"Sounds of struggling and vine movement...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Research log fifty-three, testing scarlet rose interaction with human subjects.\""),
	span_game_say(span_name("Human Voice") + span_message(" panicked,") + " \"You can't make me walk through those! They'll tear me apart!\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Subject seven, please proceed. We need to observe the vine's reaction to human flesh.\""),
	"Sound of reluctant footsteps, followed by tearing fabric and screams...",
	span_game_say(span_name("Human Voice") + span_message(" screams,") + " \"AGH! My legs! They're cutting into my legs!\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Note the immediate hemorrhaging. The vines seem particularly eager for blood.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"He's bleeding profusely... should we extract him?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Not yet. Observe how the vines pulse - they're responding to his distress.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Each movement triggers another attack. The damage compounds rapidly.\""),
	"Sound of a blade being drawn...",
	span_game_say(span_name("Human Voice") + span_message(" desperately,") + " \"I'll cut my way through! Just like you said!\""),
	"Sounds of slashing, followed by more screams...",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Fascinating. The vines retaliate when cut, causing additional lacerations.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"But with persistence, he's clearing a path. The human survival instinct is remarkable.\""),
	span_game_say(span_name("Human Voice") + span_message(" weakly,") + " \"I... I made it through... but I'm losing so much blood...\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Apply pressure to the wounds. Scholar, note the pattern of cuts.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"The vines target the legs primarily - designed to hinder movement and cause panic.\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " \"What about the rose's resistance to damage?\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Remarkably balanced. It resists all forms of attack equally - no clear weakness.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Fire might clear the vines, but the rose itself endures. A perfect defensive organism.\""),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " \"Subject seven, your sacrifice has provided valuable data. Take him to medical.\""),
	"Sound of dragging footsteps and continued vine rustling..."
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94)

/obj/item/tape/resurgence/temple_tour
	name = "Temple Log #85"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Unusual Behavior' written on its back."
	storedinfo = list(
	"Sounds of mechanical footsteps and chains dragging across stone...",
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" excitedly says,") + " \"Joshua! I got permission to show you around the temple today!\""),
	span_game_say(span_name("Joshua") + span_message(" confused,") + " \"Again... What are you gaining out of this? Dragging me around this temple?\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"Well, you see... It is fascinating to hear your perspective on this temple!\""),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " \"After all, it is best to hear from the source!\""),
	span_game_say(span_name("Robotic Voice") + span_message(" asks,") + " \"Elliot, why are you speaking to the test subject like that?\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Oh! Senior, I'm just... gathering observational data on human reactions to our architecture!\""),
	span_game_say(span_name("Robotic Voice") + span_message(" skeptically,") + " \"I see... Carry on then, I suppose.\""),
	"Footsteps continue down a hallway...",
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"This is our main library! We have thousands of books on human emotions!\""),
	span_game_say(span_name("Joshua") + span_message(" says,") + " \"That's... creepy, ain't gonna lie about that.\""),
	span_game_say(span_name("Elliot") + span_message(" proudly,") + " \"Oh my, is it really? Is it the architecture of this building? It does have an ancient vibe around it...\""),
	span_game_say(span_name("Elliot") + span_message(" proudly,") + " \"I shall send feedback right away to the Head Priest...\""),
	span_game_say(span_name("Joshua") + span_message(" sighs")),
	span_game_say(span_name("Joshua") + span_message(" mutters,") + " \"That's not exactly the case...\""),
	span_game_say(span_name("Robotic Voice") + span_message(" whispers,") + " \"Is that scholar showing a human our sacred texts?\""),
	span_game_say(span_name("Robotic Voice") + span_message(" whispers,") + " \"And he seems... excited about it? How peculiar.\""),
	span_game_say(span_name("Robotic Voice") + span_message(" whispers,") + " \"I guess they are extra invested in their studies?\""),
	"Heavy mechanical footsteps approach...",
	span_game_say(span_name("Robotic Voice") + span_message(" sternly,") + " \"Scholar Elliot, why is this human not in restraints?\""),
	span_game_say(span_name("Elliot") + span_message(" nervously,") + " \"Oh! I, um, removed them for better observations! They told me that they were quite uncomfortable!\""),
	span_game_say(span_name("Joshua") + span_message(" whispers,") + " \"Elliot, you should not have said that...\""),
	span_game_say(span_name("Elliot") + span_message(" whispers,") + " \"What is wrong, I am just being honest...\""),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " \"The Head Priest will hear about this irregularity.\""),
	span_game_say(span_name("Elliot") + span_message(" pleading,") + " \"Please, we're almost done! Just the Study Room B left!\""),
	span_game_say(span_name("Joshua") + span_message(" says,") + " \"Elliot, please don't cause any more problems for them...\""),
	span_game_say(span_name("Elliot") + span_message(" determined,") + " \"Well... I guess we end this tour for today...\""),
	"Recording device being hidden as footsteps approach the recorder's position..."
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126, 130, 134, 138)

/obj/item/tape/resurgence/dying_machine
	name = "Temple Log #92"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Core Failure Incident' written on its back."
	storedinfo = list(
	"Sounds of workshop machinery and footsteps entering...",
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"And this is where we perform basic maintenance and—oh no...\""),
	span_game_say(span_name("Joshua") + span_message(" flatly,") + " \"What now? Another one of your experiments gone wrong?\""),
	"Sound of static and mechanical wheezing...",
	span_game_say(span_name("Dying Machine") + span_message(" weakly,") + " \"Core... failing... can't... maintain...\""),
	span_game_say(span_name("Elliot") + span_message(" distressed,") + " \"It's Scholar Matthias! His core is critically damaged!\""),
	span_game_say(span_name("Joshua") + span_message(" curious,") + " \"Core? That's what keeps you running? How does it work exactly?\""),
	span_game_say(span_name("Elliot") + span_message(" frantically,") + " \"This isn't the time! We need to—we can't fix this! Only the Tinkerer can repair cores!\""),
	span_game_say(span_name("Workshop Assistant") + span_message(" says,") + " \"Young scholar, you shouldn't have brought the human here to see this.\""),
	"The dying machine's lights flicker erratically...",
	span_game_say(span_name("Joshua") + span_message(" coldly,") + " \"So get this Tinkerer. Unless... let me guess, they won't come?\""),
	span_game_say(span_name("Workshop Assistant") + span_message(" uncomfortably,") + " \"The Tinkerer has been... distant lately. Won't respond to our calls.\""),
	span_game_say(span_name("Elliot") + span_message(" confused,") + " \"But why? The Tinkerer has always helped before!\""),
	span_game_say(span_name("Workshop Assistant") + span_message(" says,") + " \"None of us know. They've been silent for weeks, locked in their workshop.\""),
	span_game_say(span_name("Dying Machine") + span_message(" whispers,") + " \"Tell... the Historian... I'm sorry... I failed...\""),
	span_game_say(span_name("Joshua") + span_message(" mockingly,") + " \"How convenient. Your only medic throws a tantrum and you all just... accept it?\""),
	span_game_say(span_name("Elliot") + span_message(" tearfully,") + " \"It's not like that! Core repair is sacred knowledge! We can't just—\""),
	span_game_say(span_name("Joshua") + span_message(" interrupting,") + " \"Sacred? It's machinery. What makes these cores so special anyway?\""),
	span_game_say(span_name("Workshop Assistant") + span_message(" explains,") + " \"Each core contains our essence, our memories, everything we are. Only the Tinkerer knows their secrets.\""),
	"Sound of systems shutting down, lights dimming...",
	span_game_say(span_name("Joshua") + span_message(" analytically,") + " \"Fascinating. So you're all dependent on one individual. Poor design choice.\""),
	span_game_say(span_name("Elliot") + span_message(" desperately,") + " \"There must be a reason! The Tinkerer wouldn't just abandon us!\""),
	span_game_say(span_name("Workshop Assistant") + span_message(" worried,") + " \"Something happened. We all felt it. But none of us know what.\""),
	span_game_say(span_name("Dying Machine") + span_message(" fading,") + " \"So... cold... tell them... I tried to... understand...\""),
	"A long mechanical sigh, followed by complete silence...",
	span_game_say(span_name("Elliot") + span_message(" whispering,") + " \"Matthias? Scholar Matthias?\""),
	span_game_say(span_name("Workshop Assistant") + span_message(" solemnly,") + " \"Core signature lost. He has ceased.\""),
	span_game_say(span_name("Joshua") + span_message(" dismissively,") + " \"One less captor. Though I am curious - what happens to the core now?\""),
	span_game_say(span_name("Elliot") + span_message(" crying,") + " \"How can you be so cruel? He was studying human compassion!\""),
	span_game_say(span_name("Joshua") + span_message(" bitterly,") + " \"By keeping humans in cages? How compassionate.\""),
	span_game_say(span_name("Workshop Assistant") + span_message(" quietly,") + " \"The core will be preserved. Perhaps one day the Tinkerer will return to us.\""),
	span_game_say(span_name("Joshua") + span_message(" scoffing,") + " \"You'll keep a corpse hoping for resurrection? How... fascinating of you.\""),
	"Footsteps quickly leaving as machinery powers down in the background..."
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126, 130, 134, 138)


/obj/item/tape/resurgence/shared_dreams
	name = "Temple Log #102"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Forbidden Meeting' written on its back."
	storedinfo = list(
	"Wind rustling through desert sands, footsteps on stone outside the temple walls...",
	span_game_say(span_name("Elliot") + span_message(" whispers,") + " \"Joshua! You actually came... I was worried the guards would notice.\""),
	span_game_say(span_name("Joshua") + span_message(" says,") + " \"They're too busy with their 'sacred duties' to notice one human slipping out. Why did you want to meet?\""),
	span_game_say(span_name("Elliot") + span_message(" nervously,") + " \"I... I wanted to talk to someone who might understand. About the City.\""),
	span_game_say(span_name("Joshua") + span_message(" bitterly laughs,") + " \"The City? What would a machine know about—\""),
	span_game_say(span_name("Elliot") + span_message(" interrupts,") + " \"Everything! We know everything! Or... we think we do. It's why we're here, why we do all of this!\""),
	"Sound of Elliot sitting down heavily on stone...",
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"We believe... no, we KNOW that if we become human enough, the City will finally accept us.\""),
	span_game_say(span_name("Joshua") + span_message(" scoffs,") + " \"Become human? You're made of metal and gears.\""),
	span_game_say(span_name("Elliot") + span_message(" desperately,") + " \"But we can learn! We study emotions, we mimic faces, we practice speech patterns...\""),
	span_game_say(span_name("Elliot") + span_message(" continues,") + " \"The Elders say the City has a... a detection system. It knows who's human and who isn't.\""),
	span_game_say(span_name("Elliot") + span_message(" says,") + " \"Machines are rejected. Destroyed. The City hates us for what we are.\""),
	"Long pause, wind picking up...",
	span_game_say(span_name("Joshua") + span_message(" quietly,") + " \"...I can't enter the City either.\""),
	span_game_say(span_name("Elliot") + span_message(" shocked,") + " \"What? But you're human!\""),
	span_game_say(span_name("Joshua") + span_message(" says,") + " \"Human, yes. But undocumented. No papers, no citizen ID, no district registration.\""),
	span_game_say(span_name("Joshua") + span_message(" continues,") + " \"To the City, I don't exist...\""),
	"Sound of laugher from Joshua in the distance...",
	span_game_say(span_name("Joshua") + span_message(" continues,") + " \"You know, it is funny how this City believes in this age of 'Humanity', yet they avoid helping out any humans out here, in the outskirts.\""),
	span_game_say(span_name("Joshua") + span_message(" continues,") + " \"I am unlucky enough to be born in a village that didn't specialize in learning the immigration process...\""),
	span_game_say(span_name("Joshua") + span_message(" says,") + " \"So, that dream is still far away from me. It was wise for me to give up early.\""),
	span_game_say(span_name("Elliot") + span_message(" finishes,") + " \"Oh, Joshua...\""),
	"Sound of Joshua sitting down next to Elliot...",
	span_game_say(span_name("Joshua") + span_message(" asks,") + " \"So we both dream of a place that doesn't want or care for us. Why do you keep trying?\""),
	span_game_say(span_name("Elliot") + span_message(" sadly,") + " \"What else is there? I... I don't remember anything before we came here.\""),
	span_game_say(span_name("Elliot") + span_message(" continues,") + " \"The Historian says I'm young, that my memories will develop with study, but...\""),
	span_game_say(span_name("Elliot") + span_message(" whispers,") + " \"Sometimes I wonder if there's nothing to remember. If this hope is all we have.\""),
	span_game_say(span_name("Joshua") + span_message(" says,") + " \"I remember my life before. The outskirts. Survival. Always running, always hungry.\""),
	span_game_say(span_name("Joshua") + span_message(" continues,") + " \"The City was supposed to be salvation. Streets of plenty, safety, purpose...\""),
	span_game_say(span_name("Elliot") + span_message(" asks,") + " \"Do you think it's real? What they say about the City?\""),
	span_game_say(span_name("Joshua") + span_message(" sighs,") + " \"Does it matter? Real or not, neither of us will ever see it.\""),
	span_game_say(span_name("Elliot") + span_message(" determined,") + " \"No! I refuse to believe that. We'll find a way. We have to.\""),
	span_game_say(span_name("Elliot") + span_message(" quietly,") + " \"The Elders brought us all this way. Sacrificed so much. It can't be for nothing.\""),
	span_game_say(span_name("Joshua") + span_message(" asks,") + " \"And if it is? If this whole temple, all these experiments, all of it is pointless?\""),
	span_game_say(span_name("Elliot") + span_message(" firmly,") + " \"Then at least we tried to become something more than what we were.\""),
	"Sound of footsteps approaching in the distance...",
	span_game_say(span_name("Joshua") + span_message(" whispers suddenly,") + " \"Wait... do you see that? Over there, by the stones.\""),
	span_game_say(span_name("Elliot") + span_message(" squinting,") + " \"Figures... watching us? Who would be out here at this hour?\""),
	span_game_say(span_name("Joshua") + span_message(" cautious,") + " \"Not the patrol. They move differently. More... deliberate.\""),
	span_game_say(span_name("Elliot") + span_message(" stepping forward,") + " \"Let's get closer. Maybe they know something about—\""),
	"The mysterious figures suddenly scatter, disappearing into the darkness as if they were never there...",
	span_game_say(span_name("Joshua") + span_message(" troubled,") + " \"They knew we saw them. They were waiting for us to notice.\""),
	span_game_say(span_name("Elliot") + span_message(" shaking his head,") + " \"This doesn't make sense. The Elders never mentioned... others out here.\""),
	span_game_say(span_name("Joshua") + span_message(" grimly,") + " \"There's always more they don't tell us. Come on, we should head back.\""),
	span_game_say(span_name("Elliot") + span_message(" nodding,") + " \"Together. Whatever those things were, I'd rather not meet them alone.\""),
	"Two sets of footsteps heading back toward the Temple, their shared unease binding them in silence..."
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126, 130, 134, 138, 142, 146, 150, 154, 158, 162, 166, 170, 174, 178, 182)

/obj/item/tape/resurgence/morning_raid
	name = "Temple Log #103"
	icon_state = "tape_red"
	desc = "A magnetic tape that can hold up to ten minutes of content. The label reads 'EMERGENCY RECORDING - TEMPLE OF MOTUS' in hasty handwriting."

	storedinfo = list(
		"Sound of morning bells ringing through stone halls...",
		span_game_say(span_name("Temple Guard") + span_message(" skeptically,") + " \"Figures watching you? In the dead of night? You're certain?\""),
		span_game_say(span_name("Joshua") + span_message(" insistent,") + " \"They weren't human. The way they moved, how they scattered when spotted...\""),
		span_game_say(span_name("Elliot") + span_message(" adding,") + " \"He's right. I've never seen machines move like that. They were... studying us.\""),
		span_game_say(span_name("Head Priest") + span_message(" thoughtfully,") + " \"This is troubling. In all our years here, we've never—\""),
		"CRASH! The temple doors explode inward with tremendous force...",
		span_game_say(span_name("Temple Guard") + span_message(" shouting,") + " \"INTRUDERS! SOUND THE ALAR—\""),
		"The guard's voice cuts off with a sickening mechanical crunch...",
		"Multiple heavy metallic footsteps thunder through the breach, accompanied by the distinctive whir of red optical sensors...",
		span_game_say(span_name("Red-Eyed Raider") + span_message(" mechanically,") + " \"PURGE THE FLESH. CLAIM THE TEMPLE. TAKE THEIR CORES.\""),
		"Screams and laser fire fill the air as the raiders systematically slaughter the temple inhabitants...",
		span_game_say(span_name("Joshua") + span_message(" grabbing a fallen guard's weapon,") + " \"Elliot! Get to cover!\""),
		"Rapid laser fire echoes through the chamber - the distinct sound of a temple guard's rifle being discharged repeatedly...",
		span_game_say(span_name("Elliot") + span_message(" rushing to the Head Priest,") + " \"Father! You're wounded!\""),
		span_game_say(span_name("Head Priest") + span_message(" coughing,") + " \"The... the sacred program... must not die with me...\""),
		"A strange electronic hum fills the air, accompanied by the sound of data transfer protocols initiating...",
		span_game_say(span_name("Head Priest") + span_message(" weakly,") + " \"Golden Time... our last hope... uploading...\""),
		span_game_say(span_name("Elliot") + span_message(" feeling strange sensations,") + " \"What are you—\""),
		"Heavy metallic footsteps shake the temple floor...",
		span_game_say(span_name("Joshua") + span_message(" backing away,") + " \"What in the name of—\""),
		"Tremendously heavy footsteps approach, each impact causing nearby debris to rattle and fall...",
		span_game_say(span_name("The Keeper") + span_message(" voice booming,") + " \"PATHETIC FLESH-THING. YOU DARE RESIST THE TINKERER'S WILL?\""),
		span_game_say(span_name("Joshua") + span_message(" firing desperately,") + " \"The Tinkerer? That's who sent you?!\""),
		"Sound of metal striking metal violently, followed by a weapon clattering across stone - then Joshua's strangled gasp...",
		span_game_say(span_name("The Keeper") + span_message(" mockingly,") + " \"THE TINKERER SENDS HIS REGARDS. YOUR TEMPLE, YOUR FALSE DREAMS, ALL WILL BURN.\""),
		span_game_say(span_name("Elliot") + span_message(" struggling to stand,") + " \"No! Let him go!\""),
		span_game_say(span_name("The Keeper") + span_message(" raising their weapon,") + " \"WATCH AS I END THIS FLESH-THING, MACHINE-WHO-LOST-THEIR-PURPOSE.\""),
		span_game_say(span_name("The Keeper") + span_message(" charging weapon,") + " \"REMEMBER YOUR TRUE FOES, THE MONSTERS WHO TOOK YOUR PURPOSE!\""),
		"An overwhelming electrical surge crackles through the air, systems overloading with cascading power readings...",
		span_game_say(span_name("Elliot") + span_message(" voice distorting,") + " \"GOLDEN TIME... ACTIVATING... SYSTEM OVERRIDE INITIATED...\""),
		"The recording dissolves into static as electromagnetic interference overwhelms all sensors..."
	)

	timestamp = list(2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126, 136, 140, 144, 148, 152, 156, 160, 164)

