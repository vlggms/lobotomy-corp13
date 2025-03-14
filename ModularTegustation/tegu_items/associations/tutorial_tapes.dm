/obj/item/tape/fixer
	name = "old tape"
	desc = "A magnetic tape that can hold up to ten minutes of content. YOU SHOULD NOT BE SEEING THIS!"
	icon_state = "tape_blue"
	storedinfo = list()
	timestamp = list()

/obj/item/tape/fixer/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You take a closer look at the tape... Looks like you can't pull out the wires.</span>")

/obj/item/tape/fixer/fishing_1
	name = "General Fishing Guide"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have Part 1 of 5' written on its back."
	storedinfo = list(
		span_game_say(span_name("Unknown") + span_message(" says,") + " &quot;Welcome to my short, general fishing guide.&quot;"),
		span_game_say(span_name("Unknown") + span_message(" says,") + " &quot;I've been tasked with making some introductory tapes for fishing by Hana.&quot;"),
		"Steps in the sand can be heard approaching in the background...",
		span_game_say(span_name("Unknown") + span_message(" says,") + " &quot;Appreciated.&quot;"),
		"Steps can be heard once more, this time heading away...",
		span_game_say(span_name("Unknown") + span_message(" says,") + " &quot;Name's Namja Bulkkoch, and I will attempt to guide you through this process.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Fishing might seem useless to you, but it proves itself very useful with shrimp for silk making and trainers for grading up.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Two types of fishing; Shrimp hunting and regular fishing.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Regular then splits into fishing for ahn and fishing for fish points.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;I'll start with the regular, consider Shrimp hunting your 'endgame'.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;First, buy a fishing tacklebox, it has the basic items.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Grab the book out of it and read it, it boosts your fishing knowledge, good baseline.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;After you've done that, assemble your rod with the two components.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" warns,") + " &quot;Don't use the net. It might seem worthwhile, but then you'll end up accidentally fishing up a shrimp with it which will promptly kill you.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Then, get to some body of water and start fishing.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Fish for a long while, get a large pile of fish beneath you.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Whenever you feel like it, pick them up with your fish bag and tap the fishing vendor with it.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Your goal should be a rod, the reinforced fishing line, and the shiny hook.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Gold is the fastest, Titanium is a strong rod, and Lunar fluctuates between weak to strongest, depending on the phase of the moon.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Gold is best for fishing for money, Titanium is decent always, Lunar is probably the best.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;So just keep fishing until you can afford a fully assembled one.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;You can of course use the rod without a hook or line, but do check its statistics compared to your ramshackle before doing so.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;As you fish you will notice you're improving, you'll see a shrimp stalking you, or have a fish tell you a tale.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Why that matters? Fishing speed, a trophy cloak, and worshipping gods.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Yes, that is a part of fishing, I'll get to that in a different tape.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;For checking your skill, buy a PDA, register on it, and open the skill tracker, fishing is at the bottom.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;You should decide on if you want to fish for Ahn or Fish Points, that matters once you become a master fisher.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;So, in summary, Get your rod, get your seat unless it was already taken, and fish.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;If you want more information, listen to the tape about gods, and after that pick either the one for Fishing for Ahn or Fishing for Fish Points.&quot;")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96, 101, 106, 111, 116, 121, 126, 131, 136, 141)

/obj/item/tape/fixer/fishing_2
	name = "The Gods and Us"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have Part 2 of 5' written on its back."
	storedinfo = list(
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;The gods, weird that worshipping something is a part of fishing, hm?&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;I don't interact with them much personally, so I'll be quick about this.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;There's a couple, your way of connecting with them is the mysterious shrine.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Though keep in mind, the gods will ignore you until you are around the skill of a master fisher.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Personally, only ones you should care about are Lir and Abena Mansa, the God of the Sea and the Goddess of Gold respectively.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Which should you go for? Depends, do you want to fish for Fish Points or Ahn?&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Lir is your go-to if you want fish points, he increases the size of caught fish by 100%, doubling it.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Abena Mansa on the other hand, gives you a small chance to fish up 50 ahn with each fish.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Each god is related to a planet, and those sometimes go in alignment with the Earth.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;When that happens, a certain bonus happens, usually useless.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Uranus however, the planet of Abena Mansa,&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;with it you can sell your fish for 1.5x their points value.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Pretty much all there is that's worth mentioning, to be honest.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Haven't done much with the others, but feel free to experiment.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Goodluck on your fishing ventures.&quot;")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71)

/obj/item/tape/fixer/fishing_3
	name = "Fishing with Purpose"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have Part 3 of 5' written on its back."
	storedinfo = list(
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Right, the split of regular fishing, either Ahn or Fish Points.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;For ahn,&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;it's as simple as getting the fastest rod you can, that being a gold one, and deciding to worship Abena Mansa, the Sea Goddess of Gold of the planet Uranus.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Your fish bag can store 100 fish, which sell for 10 ahn each, making you 1000 ahn per batch.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;That of course disregards the occasional 50 ahn you get from your Goddess.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Oh, and sometimes you may fish up wine bottles. Those go for 50 Ahn each at the selling machine.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;And for Fish Points,&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;as simple as getting either the Lunar or Titanium rod and worshipping Lir.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;If you want to be extra, wait for Uranus to be in orbit, you can check that at the altar.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;From experience that happens every 30-50 minutes.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Assuming you've already listened to the tape about fishing gods, so I'll skip the why.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Fish Points let you buy things in the vendor, ranging from the most useful, N Corp Trainers, to useless, aquarium-related things.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;If you want to go from G9 to G4 with fishing, it'll take you 7,100 Fish Points, so get to fishing.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;For how that works, refer to Vertin's (TAPE_NAME_PENDING) tape.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Good luck.&quot;")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71)

/obj/item/tape/fixer/fishing_4
	name = "Shrimp Hunting 101"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have Part 4 of 5' written on its back."
	storedinfo = list(
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Welcome to the fishing endgame.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Net fishing for shrimp.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;I do not recommend this unless you consider yourself adequately prepared.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;For a weapon, I would recommend a Pale Club, any modifier.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;The shrimp take damage from walking in the waters same as you, and a club knocks them back, forcing them to walk to you through it.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;The net made for shrimp fishing is called the Big Baited Fishing Net, 200 Fish Points per.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;3 types of shrimp that you can fish up.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Regular shrimp, those you can just stand your ground with and hit them back, the easiest of the bunch.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Gun shrimp, bit problematic, they will not come to you if you stand at the shore, so you club them in, then walk back, wait for them to close the distance and repeat until they're dead.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;And the last, the most dangerous, buff shrimp. They will knock you back, deal a ton of damage and are very tough. Your best bet is to try to stand your ground and keep pushing them in, hoping you can outlive them.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Whatever you do, do +NOT+ get yourself between a wall and the buff shrimp. They will knock you down and keep beating you until you die.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;You cannot get out of that.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Sometimes you might knock the shrimp's corpse far into the water. Do not get mad, just make a bridge of nets to the corpse and pull it back.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Walking on water is safe so long as you're standing on nets.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Goodluck with your shrimp hunting.&quot;")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71)

/obj/item/tape/fixer/fishing_5
	name = "Curiosities and Oddities of Fishing"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have Part 5 of 5' written on its back."
	storedinfo = list(
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Welcome to the extra trivia tape.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Just some fun facts I thought of including here, be it because they didn't fit anywhere or because I wanted to.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Three types of water, Saltwater, Freshwater, and Polluted water.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Not going to find any Polluted waters here, saltwater is the beach south-side, and freshwater is the river west-north.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;You can fish up different fish in each, including abnormal fish rarely from freshwater.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;The resurgence clan village has a fishing trader who sells the best line there is. He also buys abnormal fish for 100 ahn each, if you happen to get them.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;The water is safe to swim in if Saturn is in orbit, just trust me on this.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;*chuckles.* Very safe.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Nets suck, just in general.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;The lantern, going for 400 Fish Points, is the best light source, omni-directional, unlike the SECLITE.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;You can stack up to 20 unhinged fishing hats ontop of one another, increasing their size with each one.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Wood is useless.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;About all I can think of, have fun I guess?&quot;")
	)

	timestamp = list(1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61)

/obj/item/tape/fixer/fishing_6
	name = "Curiosities and Oddities of Fishing"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have Part 6 of 5' written on its back."
	storedinfo = list(
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Right, the original plan was to just make 5 tapes, but due to recent developments there’s now a need for a 6th.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;As of recent, Hana has authorized expeditions into the waters of the Great Lake.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;And with that, I was told to make an addendum tape, even though this part isn’t necessarily about fishing.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Until recently there was a sea wall blocking fixers from venturing out too far,&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;though it has now been removed, or at least pushed back rather.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;I should add, before you even think about sailing out, the waters are dangerous.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Both the water itself and the things that reside on it, so venture out at your own discretion.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Now, the basics. If you want to set sail, you first need a boat.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;For that, you’ll need 250 wooden planks.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;You can get those from fishing, but more efficiently from the recently added Botany.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Plant some tower-cap Mycelium, let it grow, then harvest it and work the logs with a hatchet down to usable planks.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;While you do need 250 to start building a vessel, not all 250 is consumed, if I recall, only around 100 is?&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Don’t ask me how or why.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Once you have that many, you can construct a One Person Boat, if you have your ‘Personal Crafting’ Guidebook, the instructions are in the “Miscellaneous” chapter, near the end.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Right below it is also the Oar that you’ll need to be able to operate it.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Once you’ve constructed your vessel and equipped it with an oar, push it out to the water.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Carefully drag yourself into your boat, and set sail, waving land goodbye.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;The largest problem you’ll likely find is an old, run down outpost that once served as a dockyard for fixers.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Nowadays, it’s been overtaken by shrimp.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;It has many valuables, but again, full of shrimp.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;There’s of course a lot more than just it out in the waters, so explore plenty. Map out the waters.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;And, to make this slightly fishing related, deeper into the lake there are different types of waters housing various kinds of fish.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;It’s that shrimple.&quot;"),
		span_game_say(span_name("Namja Bulkkoch") + span_message(" says,") + " &quot;Goodluck, don’t drown.&quot;")
	)

	timestamp = list(2, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89, 93, 97, 101)

/obj/item/tape/fixer/intro
	name = "Introductory: Where to go!"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Tape 1, V' written on its back."
	storedinfo = list(
		span_game_say(span_name("Unknown") + span_message(" says,") + " &quot;Is this thing working...Testing..&quot;"),
		"A soft creak of a door and the shuffling of papers can be heard, followed by whispers.",
		span_game_say(span_name("Unknown") + span_message(" says,") + " &quot;Oh Sonetto, is this recorder...Ah it's working already?  I see, thank you. Just put the papers on that pile over there.&quot;"),
		"More whispering, it then fades and is replaced by another creak of a door.",
		span_game_say(span_name("Unknown") + span_message(" clears their throat,")),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Hello, If this goes correctly, You are listening to the introductory tape I've made. My name is Vertin Caldwell and I have been requested by the Hana Association to make these tapes.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Assuming your location is currently at the front of the office, the beach is where all the fishing business is done. And if you plan on fishing then please refer to the General Fishing Guide Tape.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Moving on, to the right of the beach is where most of your general equipment will be located, However you will need to buy them from a vendor.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;But don't worry, you've been provided just enough to buy the bare essentials of which are an Armored coat, flashlight and a crowbar.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Upwards will lead you inside your very own office, that is if you're the office director. The office will contain everything else you will need such as a basic kitchen, workshop forge and a medbay.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;If you are the office director, I suggest now grabbing the budget that Hana provides at your desk, If you just entered the office building, it is to the right and down the hall with red curtains. Do also grab the headset on the desk as it's yours.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Now with the entire office's budget and a headset, you should forge a weapon if you've already gotten the necessities. Head to the forge and if there is one, please refer to the tape there.&quot;"),
		"Sounds of shuffling papers, a soft twinkling melody could be heard in the background.",
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;That's all I would like to provide on this tape...Goodluck.&quot;"),
	)

	timestamp = list(1, 7, 13, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79)

/obj/item/tape/fixer/grades
	name = "Potentials and Grading"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Tape 2, V' written on its back."
	storedinfo = list(
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Recorder should be working again..&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" clears her throat.")),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Potentials and Grades, both are important in their own parts as the fixer grades are especially what you are gonna be constantly checking.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Starting with potential, potential is what is needed to increase your fixer grade. The more potential you have through using training accelerators, the better grade you will be put at after reaching certain thresholds.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Training Accelerators can be obtained either for 300 Ahn in the fixer equipment vendor or for 100 fishing points if you have decided to go the fishing route.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Continuing, at grade 9 you will be getting 4 potential with each use of a training accelerator, the amount obtained will weaken the moment you are raising to higher grades.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Immediately reaching grade 8 will lower the potential obtained to 3, Grade 7 will have it sit at 2 while finally, Grade 6 and below will only provide 1 potential per training accelerator used.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;In short, this means it will take plenty more training accelerators to raise your grade as they get weaker when you yourself get stronger.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Now that we have most things about potential out of the way, we will be moving onto the topic of fixer grades. Starting with the obvious of that you will start at the lowest fixer grade, Grade 9.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;It is not a bad thing however, as grade 9 will allow you to get 5 L1 skills which will in turn assist you a lot but I will not be going over it in this tape.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Moving along, starting from grade 9 the maximum you can raise it up to is grade 4.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;You  can get your grade appraised at the potential estimation machine that is located to the right of the beach with the fixer equipment vendors and Hana’s item selling machine.&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;...Ah right, don’t think I have mentioned it yet. Grades are essential because they are your stats, without higher grades you will not be able to wear better armor or wield stronger weapons..&quot;"),
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Shit! The reel is running out on this tape, I will keep this short. It will take you 5 trainers in total to reach grade 8 and another 7 if you would like to reach grade 7.&quot;"),
		"Panicked shuffling of papers",
		span_game_say(span_name("Vertin Caldwell") + span_message(" says,") + " &quot;Then from grade 7 it will require you 10 trainers to reach grade 6, after that. 19 trainers for grade 5 and finally 20 trainers for grade 4! Additional 10 if you want to-!&quot;"),
	)

	timestamp = list(1, 7, 13, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91)

/obj/item/tape/fixer/medicine
	name = "Basics of Medicine"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Tape 3, V' written on its back."
	storedinfo = list(
		span_game_say(span_name("Unknown") + span_message(" exclaims,") + " &quot;Damn…I’ll do this tape, just make sure to get me an investor by then Vertin! I’ve got lots to make!&quot;"),
		"Distant footsteps then some beeping followed by a hiss of air could be heard",
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Now then, I’m not giving you guys anything about me. But I want the credit so I’ll refer to myself as M.P&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Right now I’m asked to instruct you with this recorded tape on how to even simply get your colleagues back up.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;If you're listening to this right now while their body is on the floor…Get them on a stasis bed! Their organs are basically rotting while you listen to this.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;But if you're listening to this just to learn, then now you know that it’s important to, if possible, always get them on a stasis bed. The technology on those devices are what gives their name.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;They halt any organ decay and the sorts, I would say chemicals too but if they’re dead. The lack of their heart beating to pump it through their blood is literally already stopping it from affecting them, also the fact that they’re dead.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Enough of that now, after you strap them onto a stasis bed, you will want to grab the red surgical bag that should be in your office’s med bay if nobody bothered to snatch it.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;And then when you’ve relocated it somewhere closer to you so you can operate on your colleague, get yourself a health analyzer from the vendor with a blue cross and white background.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Assuming that you didn’t somehow mess up the steps and you followed it correctly, you will want to use the health analyzer on your dead colleague to assess what needs to be done.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;If it shows any brute or burn damage, it won’t be a problem. A Failing liver and tons of toxin damage from being an alcoholic drunkard? That will be a whole different problem I’ll cover later.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Now that you’ve identified the damages, start off by treating their wounds. Dig into the surgical bag and take out some drapes, lay it across their torso and perform surgeries according to what damage they have.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Let’s assume your colleague has severe brute injuries and no major organ damage, perform a advanced brute tending surgery, if you don’t know how to perform this. You're free to unbuckle them from the stasis bed and move them to the surgery table to see the surgery steps on the console.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Then tend their wounds only to allow them to reach defibrillation levels, fully tending them will end up in a long waiting time due to oxygen deprivation! The spot you should get their total damage at is 170.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Scanning again with a health analyzer, once you see that their damage is a total of 170 across then you are free to grab the searing tool, then with drapes in the other hand. Cauterize their open cavity to end the surgery.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Now unbuckle them from their stasis bed, drag them to the sleeper and prepare your defibrillator by taking off your backpack and putting it on, make sure to let go of your colleague and then defibrillate them with the paddles followed up by CPR and proper medication in the sleeper.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;If there were any cerebral trauma problems detected, that is where brain surgery would come in, so I suggest strapping them back in and aiming to put the drapes over their head.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Should have also said this sooner but oh well! Make sure they also don’t have non-functional organs, severely damaged is fine as organ damage is healed with time as well, Each organ can be repaired with their according surgery except the appendix.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Just remove the appendix if it’s non-functional and toss it somewhere seeing as anybody will be fine without one, the location of the appendix is somewhere lower than the torso so it’s within the groin area where you should drape over with organ manipulation to extract it.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;Finally! With the last topic, Toxins. I’ll keep it simple and short! You make sure there’s no chemicals causing it by checking their bloodstream through interacting with a health analyzer and using it on a person or check if their liver has died.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;If there are chemicals, do a blood filtering surgery. If there isn’t, you’re free to continuously do a stomach pump surgery to slowly lower toxins at defibrillation levels and let pentetic acid from the sleeper take care of it after they’re revived.&quot;"),
		span_game_say(span_name("M.P") + span_message(" says,") + " &quot;That should be all unless I missed something, If I did. Vertin’s just gonna have to walk to me herself and scold me.&quot;")
	)

	timestamp = list(1, 7, 13, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91, 97, 103, 109, 115, 121, 127)

/obj/item/tape/fixer/forging
	name = "Creating a Weapon: Forging"
	desc = "A magnetic tape that can hold up to ten minutes of content. It appears to have 'Tape 3, D' written on its back."
	storedinfo = list(
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;Hey Hey! Must have needed a weapon if you're listening to this tape huh? Well don’t worry, Duncan’s got your back, I’ll teach you step by step how to forge a fine weapon!&quot;"),
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;Unlike the other tapes you would listen to, I’ll keep it short and sweet. You're probably aching to venture out. First, you’ll need to head into the material storage to the left.&quot;"),
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;Now if your luck is shining upon you, there should be some sweet Tres bars on a rack that you need to grab one of, if there are none you can try breaking the crates just top left of the storage if they’re there.&quot;"),
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;If it’s none of the above, you buy your own with the Tres vendor and you will know which it is since it’s the only vendor in the forge, but let’s say you have a Tres bar now. What do you do with it?&quot;"),
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;Well it’s simple Amigo! You put the Tres bar into the furnace and wait a few while it heats up, maybe grab a drink or two if it’s a fine day. But after the bar comes out piping hot, and I’m talking heated up glowing yellow, grab it and put it down on the anvil.&quot;"),
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;Now get yourself a hammer from the material storage, and hit the heated Tres bar as hard as you can with the hammer, after a while you will get results as you mold it into a weapon template of your choosing! I suggest to go for a sword as it is an all-rounder and you can’t go wrong with it.&quot;"),
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;Of Course, never forget! You cannot use a mod-less weapon template, you must grab a basic mod in the forge storage or select one of your choosing at the Tres Vendor, for recommendations I suggest white damage and either basic or healing.&quot;"),
		span_game_say(span_name("Duncan") + span_message(" says,") + " &quot;Congrats! Now you’ve got yourself a fine weapon that will last you until the end of your office hours, these are only the basics to forging, and there is more to cover, such as the Tres Association Material Extractor but these things are not essential. So go out there and explore! Make sure to bring back some loot for your Office, Ey?&quot;")
	)

	timestamp = list(1, 7, 13, 19, 25, 31, 37, 43)
