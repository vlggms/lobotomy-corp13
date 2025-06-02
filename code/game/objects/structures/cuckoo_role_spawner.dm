/obj/effect/mob_spawn/cuckoo_spawner
	mob_type = 	/mob/living/carbon/human/species/cuckoospawn
	name = "strange egg"
	desc = "A man-sized yellow egg, spawned from some unfathomable creature. A humanoid silhouette lurks within."
	mob_name = "Jiajiaren"
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	roundstart = FALSE
	death = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	short_desc = "You are an jiajiaren. You must raise your numbers by infecting humans and exexterminating humans who enter your home..."
	flavour_text = "You wake up in this strange location... Filled with unfamiliar sounds... \
	You have seen lights in the distance... they foreshadow the arrival of humans... Humans? In your sacred domain?! \
	Looks like you found some new hosts for your children..."
	//TODO: Add a statue which cuckoo birds can feed meat, to unlock heals, human heals, and one more thing.
	//TODO: Add a checker for implant, not letting dead people be planted, and the embryo does not grow if the user is dead.
	//TODO: Make it so cuckoo birds have a knock out skill, which only works on targets with 20% or less HP, and NPC cuckoo birds don't kill. Only into crit.
	//TODO: Add a cage to the cuckoo bird lair, which cuffs and key door. Along with that, embryo stuns the user when they leave.

/obj/effect/mob_spawn/cuckoo_spawner/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("An cuckoo egg is ready to hatch in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_ASHWALKER)
