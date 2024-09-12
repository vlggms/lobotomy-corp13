/obj/item/tape/resurgence
	name = "old tape"
	desc = "A magnetic tape that can hold up to ten minutes of content. YOU SHOULD NOT BE SEEING THIS!"
	icon_state = "tape_blue"
	storedinfo = list()
	timestamp = list()

/obj/item/tape/resurgence/first
	name = "Tinkerer's Log: Moving Out"
	icon_state = "tape_red"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appers to have 'Resurgence Clan's first move.' written on it's back."

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
		"*Sounds of drills and saws tearing into flesh are heard before a heavy door is heard screeching open…*",
		span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Dear Tinkerer... Was this why you wanted me to give you this new human to you?&quot;"),
		span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;At least I could of woven them into something much more valuable than fresh gibs…&quot;"),
		"*The sounds of drills and saws slowly slowed down...*",
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Oh? Didn’t expect you to arrive here today Mister Weaver, Were you this worried about this human?&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;No, With the recent events that occurred here with the... FLS members and my citizens have been much more opposed to using humans as materials.&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;After all, once you get to meet the humans you are using to become more human it does feel more sinful of using them this way…&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;No, I am here to deliver some... Rather upsetting news to you...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Really now? You got to drown out my perfectly fine mood after executing a monster...&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Yet, It has to be said. After discussing this with the Historian, We have decided that this town is no place for you.&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;So I kindly ask you to kindly leave this town soon...&quot;"),
		"*A loud fleshy crunch is heard coming from the human head...*",
		span_game_say(span_name("The Tinkerer") + span_message(" whispers,") + " &quot;I really should of seen that one coming yet...&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;No big deal, I can start moving tomorrow. This place was quite limiting after all.&quot;"),
		span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Thank you for understanding our decision, as it was not an easy one we ma-&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" says,") + " &quot;Yada yada... No need to exaggerate this. This ‘difficult decision’ only took you like, 12 hours to make.&quot;"),
		span_game_say(span_name("The Tinkerer") + span_message(" yells,") + " &quot;ALL OF THE SCOUTS HERE, YOU BETTER START MOVING NOW!...&quot;"),
		span_game_say(span_name("Scout") + span_message(" yells,") + " &quot;Ye-es Sir, Moving o-out...&quot;"),
		span_game_say(span_name("Scout") + span_message(" yells,") + " &quot;Yes Si-ir, Moving ou-ut...&quot;"),
		span_game_say(span_name("Scout") + span_message(" yells,") + " &quot;Ye-es Sir, Mo-ov...&quot;"),
		"*The Tape cuts after around 4-5 pairs of metallic footsteps move across the metal floor.*")
	timestamp = list(2, 4, 8, 12, 16, 20, 26, 30, 34, 38, 41, 45, 52, 56, 59, 62, 67, 72, 77, 81, 86, 91, 94, 97, 102, 107, 110, 115, 119, 123, 126, 129, 132)

/obj/item/tape/resurgence/podcast_seven
	name = "Historians Podcast: Seven Association"
	desc = "A magnetic tape that can hold up to ten minutes of content. It apper to have 'Episode 1' written on it's back."
	storedinfo = list(
		span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Is everything ready? The Podcast is starting in 3 secon- Oh!&quot;</span></span></span>,"),
		"*Lights start flickering on as a jingle plays in the background...*",
		span_game_say(span_name("Soft Robotic Voice") + span_message(" whispers,") + " &quot;Wait, I am still not ready for this... Oh dear, Um...&quot;"),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;Well, Hello my dear Citizens! What a brilliant new day in the outskirts as I, the Historian of district H will be teaching you about the different associations in the City today!&quot;"),
		"*In the background, some object slowly starts winding up…*",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;To start us off, We will be talking about the Seven! From our current record which we have gathered from the telescope, They like the Color Green? Could they love plants? After all, they also like making tea...&quot; "),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;They are also Detectives, So they must be some real pesky ones. Poking their noses wherever possible.&quot;"),
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;They most often use simple shortswords in battle which are wonderful at opening up wounds in targets! So basically they use very sharp crowbars and their foes are crates to be ripped open!&quot;"),
		"*A robotic laughter in the background, the winding from the object in the background stops.*",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;There we are! Now we can observe one of those seven fixers named...&quot;"),
		"*Sounds of papers being flipped.*",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;Moses and Ezra? Yep, Them! They are some of the most talented members you can find in this association! As seen by their...&quot;"),
		"*Awfully long pause occurs, mechanical gasps in the background.*",
		span_game_say(span_name("The Historian") + span_message(" stutters,") + " &quot;Well, Um... Very strong bonds? Ignore the face of the yellow haired girl, She is proud to be in this office as they call it!&quot;"),
		"*A quick sound of a gears winding back.*",
		span_game_say(span_name("The Historian") + span_message(" exclaims,") + " &quot;Okay, Moving back our usual point of view...&quot;")
	)

	timestamp = list(2, 5, 8, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59, 64, 69, 74)

/obj/item/tape/resurgence/temple_of_motus
	name = "Expedition Log #32"
	desc = "A magnetic tape that can hold up to ten minutes of content. It apper to have 'Our Temple...' written on it's back."
	storedinfo = list(
		"Mechanical Footsteps are heard moving across an empty desert, along with the sounds of wheels moving behind them…",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Hey, Head Priest. Do you have any idea of how much time is left until we reach this Temple…&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;It has been around a whole month since we started this journey…&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;We will arrive there in time, after all the Historian did say that this would be a long journey.&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Alright, Can you at least us what we will be doing there?&quot;"),
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;I think that we have already proven that we are dedicated to this project.&quot;"),
		"*Flipping of pages comes from the “Old Robotic Voice…”*",
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
		"*The Mechanical footsteps stop.*",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Um, Head Priest. Are we stopping now? There is still around 10 hours until the sun goes down.&quot;"),
		"*4 small knocks come from the “Old Robotic Voice”*",
		"*The ground begins to rumble… as crumbling rocks and shifting gears rises from the ground, before ending in a thud.*",
		span_game_say(span_name("Rusty Robotic Voice") + span_message(" stutters,") + " &quot;How… how could it all be hidden that easily…&quot;"),
		span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Now, Dear Scholar. Welcome to the Temple of Motus.&quot;")
	)

	timestamp = list(1, 4, 8, 12, 16, 20, 26, 30, 34, 38, 41, 45, 52, 56, 59, 62, 67, 72, 77, 81, 86, 91, 94, 97)

/obj/item/tape/resurgence/new_library
	name = "Temple Log #1"
	desc = "A magnetic tape that can hold up to ten minutes of content. It apper to have 'The Library' written on it's back."
	storedinfo = list(
	"*Sounds of shifting machinery and distant conversations*",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Scholar, How is progress on getting everyone settled in?&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;All great sir! It everyone has been able to find their rooms in the temple and we are about to offload all of our supplies!&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Understood, It appears that I will need to speak with the Historian soon… I can give you a basic rundown of your duties before I go.&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Got it sir. Where shall we begin?&quot;"),
	"*A pair of mechanical footsteps, then a heavy door slides open…*",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;One of the basic responsibilities you will hold in this temple is to keep our library up to date. As studies are completed, it may cause some books to become outdated.&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Either way you will not be parting in the studies for now since you are new, but at least you will be tasked with watching them and taking notes.&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Please use those opportunities to learn our ways around here...&quot;"),
	"*The “Old Robotic Voice” slows down.*",
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Now now, I know you are interested in what studies these books hold but we still need to get over your duties.&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Oh, Sorry Sir. You need to understand what a change this is, Back at the town I got access to only like… 2 books a month?&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Now I have the whole library open! Holding so many new experiences! Like “Aversion” or “Contentment…”&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Oh, Sorry for taking up more of your time… Where do we need to go next?&quot;"),
	span_game_say(span_name("Old Robotic Voice") + span_message(" says,") + " &quot;Well, How about I show you our repair bench? You will get many chances to speak with other members about this place, old and new!&quot;"),
	"The tape cuts right as the heavy door slides closed…"
	)

	timestamp = list(1, 4, 8, 12, 16, 20, 26, 30, 34, 38, 41, 45, 52, 56, 59, 62)

/obj/item/tape/resurgence/joshua
	name = "Temple Log #15"
	desc = "A magnetic tape that can hold up to ten minutes of content. It apper to have 'New Friend?' written on it's back."
	storedinfo = list(
	"*Sounds of distant conversations slowly moving away...*",
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;That was quite a procedure! Fascinating how the human brain is able to produce such emotions. &quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Thank the Historian that I was able to record all of...&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" says,") + " &quot;Wait, Shoot... Don't tell me that it was off the whole time...&quot;"),
	span_game_say(span_name("Rusty Robotic Voice") + span_message(" asks,") + " &quot;Well one of my seniors must have have left one spare recording here...&quot;"),
	span_game_say(span_name("Distant Robotic Voice") + span_message(" says,") + " &quot;Hey! Elliot! Are you still in the study room?&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Yes-s. Give me just a moment, I think I have forgotten something here...&quot;"),
	span_game_say(span_name("Distant Robotic Voice") + span_message(" says,") + " &quot;Okay... Just get out of there soon, other scholars will be using it soon.&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Of course... I would not want to prevent the study!&quot;"),
	"*Sounds of books and metallic objects being thrown around.*",
	span_game_say(span_name("Human Voice") + span_message(" coughs")),
	span_game_say(span_name("Elliot") + span_message(" asks,") + " &quot;Oh... It appears that they are already being woken up. I really should get moving.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says weakly,") + " &quot;Wait... Who are you, why am I here.&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Um... Normally we young scholars don't get the chance to speak with you.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Scholars... Wait, Oh fuck... What have I gotten myself into.&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Oh please don't use such rude language around here. The Priest doesn't like hearing it.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Well Steelface, Sorry for not acting all pleasant to you after waking up tied up to a metal bed.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Especially when I see your metal face...&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Really? Is it really that disconcerting... I tried so hard to mimic how a human face looks like...&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Ha... That is the problem. You are trying far too hard. I heard that it causes some sort of uncanny effect...&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Oh! Now that is something to note down... “Don't try too hard in mimicking a face...” &quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;You know what pal... We should have more talks like these!&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;It is so much more fun talking to you rather then listening to my teachers.&quot;"),
	span_game_say(span_name("Human Voice") + span_message(" says,") + " &quot;Well, There is not much that I can do...&quot;"),
	span_game_say(span_name("Elliot") + span_message(" says,") + " &quot;Wonderful! I have to get going now but what is your name so I could remember it?&quot;"),
	span_game_say(span_name("Joshua") + span_message(" says,") + " &quot;... Call me Joshua.&quot;"),
	"*The tape cuts right after some quick footsteps are heard moving out of the room.*"
	)

	timestamp = list(1, 4, 8, 12, 16, 20, 26, 30, 34, 38, 41, 45, 52, 56, 59, 62, 65, 68, 71, 74, 77, 80, 83, 86, 89, 92, 95, 98)

/obj/item/tape/resurgence/backstage
	name = "Historians Podcast: Backstage Records"
	desc = "A magnetic tape that can hold up to ten minutes of content. It apper to have 'Backstage Records' written on it's back."
	storedinfo = list(
	"*Sounds of robotic laughter in the background along with some clapping.*",
	span_game_say(span_name("Soft Robotic Voice") + span_message(" says,") + " &quot;Thank you all for tuning in for this episode! All of you learned a good amount about the Liu today!&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;It was the Historian speaking today and see you all, Next week!&quot;"),
	"*Suddenly all of the clapping stops as a screen shuts down...*",
	span_game_say(span_name("The Historian") + span_message(" sighs")),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;Cut! You did great, dear Historian! You followed your script perfectly.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yes, As it always is...&quot;"),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;Now, Since we have some time until the podcast is up what should we discuss next week?&quot;"),
	span_game_say(span_name("Robotic Voice") + span_message(" says,") + " &quot;I know! I always wanted to know more about U-Cor.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" asks,") + " &quot;Please, Max. Can you give me a small moment. I just need to, through some things.&quot;"),
	span_game_say(span_name("Max") + span_message(" says,") + " &quot;Oh, Sorry dear Historian. I will make my way then...&quot;"),
	"*Metallic footsteps moving away, followed by a door opening and closing.*",
	"*Beeps and clicks coming from a device.*",
	span_game_say(span_name("Slow Robotic Voice") + span_message(" says,") + " &quot;Excuse me, I am currently working right now so if you have any complaints...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Sorry for interrupting you dear Weaver, I was just wondering if you had a moment to talk.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Oh. Sorry for not recognizing you Historian. There are so many requests today, you would not believe it.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yep, Everyone is pretty excited about the recent cityfolk which came here.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" asks,") + " &quot;So, Why did you call me at this time?&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;You know, I have been thinking... Do you think the citizen are living a contentful life?&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;Well, Looking at how all of them are happy. Have goals and dreams, I would say so.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Yes, They all have dreams and recent events must have brought them hope... &quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;But what happens if they learn how those dreams are...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Ugly...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Nothing good, Nothing good will happen. I can't that happen.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;But...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;How long can I hide this.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They are all so innocent, They will eventually start making plans to fulfill them.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;They will all start leaving will a happy simile...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;“I will finally reach it, we can leave this harrowing life in this paradise...”&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Then they will it's true nature, it's heartless nature...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Even how he-&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;died for nothing...&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;I... Wish I had a answer for that...&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;Sorry Weaver... I just had no else to talk too.&quot;"),
	span_game_say(span_name("The Historian") + span_message(" says,") + " &quot;We can return to our duties. The citizens need us.&quot;"),
	span_game_say(span_name("The Weaver") + span_message(" says,") + " &quot;We shall do our best for them...&quot;"),
	"*The tape ends after a beep is heard from a device.*",
	)

	timestamp = list(1, 4, 8, 12, 16, 20, 26, 30, 34, 38, 41, 45, 52, 56, 59, 62, 65, 68, 71, 74, 77, 80, 83, 86, 89, 92, 95, 98, 101, 104, 107, 110, 113, 125, 128, 131, 134, 137)
