// HE Armor should be kept at ~75 total armor.

/obj/item/clothing/suit/armor/ego_gear/grinder
	name = "grinder MK4"
	desc = "A sleek coat covered with bloodstains of an unknown origin."
	icon_state = "grinder"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = -20, BLACK_DAMAGE = 20, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/harvest
	name = "harvest"
	desc = "The last legacy of the man who sought wisdom. The rake tilled the human brain instead of farmland."
	icon_state = "harvest"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 20, BLACK_DAMAGE = -20, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/fury
	name = "blind fury"
	desc = "And all she saw was red."
	icon_state = "fury"
	//all in on red, minor negatives on all else
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = -20, BLACK_DAMAGE = -20, PALE_DAMAGE = -20) // 10
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/lutemis
	name = "dear lutemis"
	desc = "Let's all dangle down."
	icon_state = "lutemis"
	//White armor, weak to red. Red is pretty valuable.
	armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = 60, BLACK_DAMAGE = 20, PALE_DAMAGE = 20) // 80, Special armor.
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/paw
	name = "bear paw"
	desc = "The equipment is made of a material that may have been fluffy once, but now it just looks shabby."
	icon_state = "bear_paw"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 20, BLACK_DAMAGE = 0, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/wings
	name = "torn off wings"
	desc = "If she hadn’t thrown her slipper at the right time, if she hadn’t outfitted me with the pensioned colonel’s sword, \
	I’d be lying in my grave."
	icon_state = "wings"
	//Just Kinda meh. A lot of WAWs do black at the time of writing so
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 50, BLACK_DAMAGE = -20, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/remorse
	name = "remorse"
	desc = "While the armor serves to protect the users mind from the influence of others, they can never seem to quiet their own thoughts."
	icon_state = "remorse"
	//Resistant to White and Pale but weaker to the physical aspects.
	armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 50, BLACK_DAMAGE = 10, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/magicbullet
	name = "magic bullet"
	desc = "The Devil ultimately wished for despair. For despair wears down the mind and drains one's will to go forward. When one feels there's nothing left to go for, their soul falls down to Hell, the Devil's domain."
	icon_state = "magic_bullet"
	// Magic Bullet has WAW-tier requirements and goes with a WAW-tier gun, but is not quite WAW-tier itself. Still, valuable if you're a well-rounded agent doing well-rounded work. - NB
	// I kept it well-rounded, and lowered the requirements, It's now LIKE a waw with it's good, well-rounded defenses, but it was generally lowered.
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 20) // 80
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/christmas
	name = "christmas"
	desc = "When the rusty sleigh bells are ajingle, Christmas begins."
	icon_state = "christmas"
	armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/logging
	name = "logging"
	desc = "Despite it's sturdy construction, the wearer always feel hollow inside."
	icon_state = "logging"
	flags_inv = HIDESHOES
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = -20, BLACK_DAMAGE = 30, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/prank
	name = "funny prank"
	desc = "The little kid who couldn't leave her friends behind came up with a brilliant idea."
	icon_state = "prank"
	flags_inv = HIDESHOES
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = -20, BLACK_DAMAGE = 40, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/harmony
	name = "harmony"
	desc = "Oh, the sound is so beautiful."
	icon_state = "harmony"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 0, PALE_DAMAGE = 10)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/syrinx
	name = "syrinx"
	desc = "The mouth is for intimidation, and should not move"
	icon_state = "syrinx"
	flags_inv = HIDESHOES
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 10)
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/frostsplinter
	name = "frost splinter"
	desc = "Surprisingly cold to the touch."
	icon_state = "frost_splinter"
	armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 30, BLACK_DAMAGE = 0, PALE_DAMAGE = 50)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/sanguine
	name = "sanguine desire"
	desc = "Smells funny, and is surprisingly heavy."
	icon_state = "sanguine"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = -10, BLACK_DAMAGE = 30, PALE_DAMAGE = 0)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/solemnlament
	name = "solemn lament"
	desc = "The undertaker's outfit belongs to those who pay tribute to the dead.\
	Only a solemn mind is required to express condolences; there is no need for showy accessories."
	icon_state ="solemnlament"
	//The design philosophy was to be as faithful to the concept of Funeral of the Dead Butterflies as possible, but conversely be in line with the stat line with every other HE suit without having VAV tier resists.
	armor = list (RED_DAMAGE = 0, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = -30) //70
	attribute_requirements = list(
		JUSTICE_ATTRIBUTE = 40
	)

/obj/item/clothing/suit/armor/ego_gear/courage
	name = "courage"
	desc = "Their weapons did not hurt me, but when I looked back and you were not there; It felt as if I was on the verge of death."
	icon_state = "courage"
	//because SC is essentially physically immortal but a coward, he has good physical resistances and god awful "sanity" resistances
	armor = list (RED_DAMAGE = 40, WHITE_DAMAGE = -10, BLACK_DAMAGE = 0, PALE_DAMAGE = 50) //80
	attribute_requirements = list(
								FORTITUDE_ATTRIBUTE = 40
								)

/obj/item/clothing/suit/armor/ego_gear/brick
	name = "yellow brick"
	desc = "The heavy dress weighs you down, smacking against your knees."
	icon_state = "brick"
	armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 10)
	attribute_requirements = list(
							INSIGHT_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/pleasure
	name = "pleasure"
	desc = "Dying happy was my only wish, and you granted it. What more could I ask for?"
	icon_state = "pleasure"
	armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 0) //80 because requiring a level 4 stat on a HE is pretty big
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40)

/obj/item/clothing/suit/armor/ego_gear/galaxy
	name = "galaxy"
	desc = "The pebble dropped into your hand sparkles, sways, tickles, and eventually becomes the universe. "
	icon_state = "galaxy"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 20, BLACK_DAMAGE = 40, PALE_DAMAGE = 10)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40)
