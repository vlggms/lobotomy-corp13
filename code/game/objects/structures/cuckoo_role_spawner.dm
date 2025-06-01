/obj/effect/mob_spawn/human/cuckoo_spawner
	name = "strange egg"
	desc = "A man-sized yellow egg, spawned from some unfathomable creature. A humanoid silhouette lurks within."
	mob_name = "Jiajiaren"
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	mob_species = /datum/species/cuckoospawn
	roundstart = FALSE
	death = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	short_desc = "You are an jiajiaren. Your tribe worships the Gray Bird statue. You must raise your numbers by infecting humans and exexterminating humans who enter your home..."
	flavour_text = "You wake up in this strange location... Filled with unfamiliar sounds... \
	You have seen lights in the distance... they foreshadow the arrival of humans... Humans? In your sacred domain?! \
	Looks like you found some new hosts for your children..."
	assignedrole = "Jiajiaren"

/obj/effect/mob_spawn/human/cuckoo_spawner/special(mob/living/new_spawn)
	if(ishuman(new_spawn))
		var/mob/living/carbon/human/H = new_spawn
		H.underwear = "Nude"
		H.update_body()
		ADD_TRAIT(H, TRAIT_PRIMITIVE, ROUNDSTART_TRAIT)

/obj/effect/mob_spawn/human/cuckoo_spawner/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("An cuckoo egg is ready to hatch in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_ASHWALKER)
