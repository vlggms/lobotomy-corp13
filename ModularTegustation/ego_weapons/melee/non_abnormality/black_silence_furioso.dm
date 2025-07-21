// Variant of Black Silence gloves that starts with Furioso unlocked
/obj/item/ego_weapon/black_silence_gloves/furioso_unlocked
	name = "Gloves of the Black Silence - Maestro"
	desc = "Worn out gloves that were originally used by the Black Silence. These gloves resonate with the full power of a Color from the beginning."
	special = "SHIFT+CLICK to perform Furioso immediately. All weapons are unlocked."
	icon_state = "gloves"
	locked_state = "gloves"
	exchange_cooldown_time = 5 SECONDS
	furioso_wait = 30 SECONDS
	unlocked = TRUE // Start with Furioso unlocked

/obj/item/ego_weapon/black_silence_gloves/furioso_unlocked/Initialize()
	. = ..()
	// Pre-populate the unlocked list with all weapon names
	unlocked_list = list(
		"Gloves of the Black Silence",
		"Zelkova Workshop",
		"Wheels Workshop",
		"Crystal Workshop",
		"Ranga Workshop",
		"Allas Workshop",
		"Mook Workshop",
		"Atelier Logic",
		"Durandal",
		"Old Boys Workshop"
	)
	// No need for the furioso timer since it's always available
	furioso_time = 0

/obj/item/ego_weapon/black_silence_gloves/furioso_unlocked/exchange_armaments(mob/user)
	// Override parent to ensure all weapons show as unlocked
	if(exchange_cooldown > world.time)
		to_chat(user, span_notice("Your gloves are still recharging."))
		return

	// Create list of available weapons
	var/list/display_names = list()
	var/list/armament_icons = list()
	for(var/arms in typesof(/obj/item/ego_weapon/black_silence_gloves))
		var/obj/item/ego_weapon/black_silence_gloves/armstype = arms
		if(initial(armstype.name)) // All weapons show as unlocked
			display_names[initial(armstype.name)] = armstype
			armament_icons += list(initial(armstype.name) = image(icon = initial(armstype.icon), icon_state = initial(armstype.icon_state)))

	armament_icons = sortList(armament_icons)
	// Show radial menu
	var/choice = show_radial_menu(user, src, armament_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(user))
		return

	// Create and switch to new weapon
	var/picked = display_names[choice]
	var/obj/item/ego_weapon/black_silence_gloves/selected_armament = new picked(user.drop_location())

	if(selected_armament)
		var/obj/item/ego_weapon/black_silence_gloves/Y = selected_armament
		Y.unlocked_list = unlocked_list
		Y.unlocked = TRUE // Keep Furioso unlocked
		Y.furioso_time = 0 // No timer needed
		Y.iff = iff
		qdel(src)
		user.put_in_hands(Y)
		playsound(user, 'sound/weapons/black_silence/snap.ogg', 50, 1)
		Y.exchange_cooldown = world.time + 5 SECONDS // Always 5 second cooldown for furioso variant

/obj/item/ego_weapon/black_silence_gloves/furioso_unlocked/Special(mob/living/user, atom/target)
	exchange_cooldown = 0
	if(isliving(target))
		// Can always use Furioso with this variant
		furioso(user, target)

// Variants for each weapon type with Furioso pre-unlocked
/obj/item/ego_weapon/black_silence_gloves/zelkova/furioso_unlocked
	name = "Zelkova Workshop - Maestro"
	desc = "A workshop made from a single massive tree. This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/wheels/furioso_unlocked
	name = "Wheels Workshop - Maestro"
	desc = "A speedy workshop, they work on the go! This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/crystal/furioso_unlocked
	name = "Crystal Workshop - Maestro"
	desc = "A workshop that imitates the style of Crystal Atelier. This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/ranga/furioso_unlocked
	name = "Ranga Workshop - Maestro"
	desc = "Two gauntlets, they look heavy. This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/allas/furioso_unlocked
	name = "Allas Workshop - Maestro"
	desc = "A workshop used by the most gallant of fixers. This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/mook/furioso_unlocked
	name = "Mook Workshop - Maestro"
	desc = "A workshop owned by two orphaned fixers. This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/logic/furioso_unlocked
	name = "Atelier Logic - Maestro"
	desc = "A workshop that makes logic in their own unique style. This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/durandal/furioso_unlocked
	name = "Durandal - Maestro"
	desc = "The signature weapon of the Black Silence. This variant resonates with full power."
	unlocked = TRUE

/obj/item/ego_weapon/black_silence_gloves/oldboys/furioso_unlocked
	name = "Old Boys Workshop - Maestro"
	desc = "A pair of shotgun gloves from an old workshop. This variant resonates with full power."
	unlocked = TRUE
