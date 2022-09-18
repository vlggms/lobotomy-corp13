#define HAT "Hat Slot"
#define HELMET "Helmet Slot"
#define EYE "Eye Slot"
#define FACE "Face Slot"
#define MOUTH_1 "Mouth Slot 1"
#define MOUTH_2 "Mouth Slot 2"
#define CHEEK "Cheek Slot"
#define BROOCH "Brooch Slot"
#define NECKWEAR "Neckwear Slot"
#define LEFTBACK "Left Back Slot"
#define RIGHTBACK "Right Back Slot"
#define HAND_1 "Hand Slot 1"
#define HAND_2 "Hand Slot 2"
#define SPECIAL "Special/Other Slot"
/datum/ego_gifts // Currently Covers most EGO Gift Functions, most others can be done via armors
	var/name = ""
	var/icon = 'icons/mob/clothing/ego_gear/ego_gifts.dmi'
	var/icon_state = ""
	var/layer = -ABOVE_MOB_LAYER
	var/slot = SPECIAL
	var/fortitude_bonus = 0
	var/prudence_bonus = 0
	var/temperance_bonus = 0
	var/justice_bonus = 0
	var/instinct_mod = 0
	var/insight_mod = 0
	var/attachment_mod = 0
	var/repression_mod = 0
	var/locked = FALSE
	var/mob/living/carbon/human/owner

/datum/ego_gifts/proc/Initialize(mob/living/carbon/human/user)
	user.ego_gift_list[src.slot] = src
	user.add_overlay(mutable_appearance(src.icon, src.icon_state, src.layer))
	user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, src.fortitude_bonus)
	user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, src.prudence_bonus)
	user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, src.temperance_bonus)
	user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, src.justice_bonus)
	user.physiology.instinct_success_mod += src.instinct_mod
	user.physiology.insight_success_mod += src.insight_mod
	user.physiology.attachment_success_mod += src.attachment_mod
	user.physiology.repression_success_mod += src.repression_mod
	owner = user
	return

/datum/ego_gifts/proc/Remove(mob/living/carbon/human/user)
	user.cut_overlay(mutable_appearance(src.icon, src.icon_state, src.layer))
	user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, (src.fortitude_bonus * -1))
	user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, (src.prudence_bonus * -1))
	user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, (src.temperance_bonus * -1))
	user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, (src.justice_bonus * -1))
	user.physiology.instinct_success_mod -= src.instinct_mod
	user.physiology.insight_success_mod -= src.insight_mod
	user.physiology.attachment_success_mod -= src.attachment_mod
	user.physiology.repression_success_mod -= src.repression_mod
	QDEL_NULL(src)
	return

/datum/ego_gifts/Topic()
	locked = locked ? FALSE : TRUE
	owner.ShowGifts()

/mob/living/carbon/human/proc/Apply_Gift(datum/ego_gifts/given) // Gives the gift and removes the effects of the old one if necessary
	if(!istype(given))
		return
	if(!isnull(ego_gift_list[given.slot]))
		var/datum/ego_gifts/removed_gift = ego_gift_list[given.slot]
		if(removed_gift.locked)
			return
		removed_gift.Remove(src)
	given.Initialize(src)
	if(istype(ego_gift_list[LEFTBACK], /datum/ego_gifts/paradise) && istype(ego_gift_list[RIGHTBACK], /datum/ego_gifts/twilight)) // If you have both, makes them not overlap
		var/datum/ego_gifts/twilight/right_wing = ego_gift_list[RIGHTBACK] // Have to do this messier because the gift_list isnt' a defined type... pain
		var/datum/ego_gifts/paradise/left_wing = ego_gift_list[LEFTBACK]
		src.cut_overlay(mutable_appearance(left_wing.icon, left_wing.icon_state, left_wing.layer))
		src.cut_overlay(mutable_appearance(right_wing.icon, right_wing.icon_state, right_wing.layer))
		left_wing.icon_state = "paradiselost_x"
		right_wing.icon_state = "twilight_x"
		src.add_overlay(mutable_appearance(left_wing.icon, left_wing.icon_state, left_wing.layer))
		src.add_overlay(mutable_appearance(right_wing.icon, right_wing.icon_state, right_wing.layer))
	else
		if(istype(ego_gift_list[LEFTBACK], /datum/ego_gifts/paradise)) // If one gets overwritten it fixes them
			var/datum/ego_gifts/paradise/left_wing = ego_gift_list[LEFTBACK]
			src.cut_overlay(mutable_appearance(left_wing.icon, left_wing.icon_state, left_wing.layer))
			left_wing.icon_state = "paradiselost"
			src.add_overlay(mutable_appearance(left_wing.icon, left_wing.icon_state, left_wing.layer))
		if(istype(ego_gift_list[RIGHTBACK], /datum/ego_gifts/twilight))
			var/datum/ego_gifts/twilight/right_wing = ego_gift_list[RIGHTBACK]
			src.cut_overlay(mutable_appearance(right_wing.icon, right_wing.icon_state, right_wing.layer))
			right_wing.icon_state = "twilight"
			src.add_overlay(mutable_appearance(right_wing.icon, right_wing.icon_state, right_wing.layer))

/// Empty EGO GIFT Slot
/datum/ego_gifts/empty
	name = "Empty"
	icon_state = ""

/// All Zayin EGO Gifts
/datum/ego_gifts/soda
	name = "Soda"
	icon_state = "soda"
	fortitude_bonus = 2
	slot = MOUTH_2

/datum/ego_gifts/penitence
	name = "Penitence"
	icon_state = "penitence"
	prudence_bonus = 2
	slot = HAT

/datum/ego_gifts/wingbeat
	name = "Wingbeat"
	icon_state = "wingbeat"
	temperance_bonus = 2
	slot = HAND_2

/datum/ego_gifts/alice
	name = "Little Alice"
	icon_state = "alice"
	temperance_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/tough
	name = "Tough"
	icon_state = "tough"
	justice_bonus = 2
	slot = EYE

/datum/ego_gifts/change
	name = "Change"
	icon_state = "change"
	fortitude_bonus = 2
	slot = BROOCH

/// All TETH EGO Gifts
/datum/ego_gifts/standard
	name = "Standard Training E.G.O."
	icon_state = "standard"
	fortitude_bonus = 2
	prudence_bonus = 2
	slot = HAT

/datum/ego_gifts/redeyes
	name = "Red Eyes"
	icon_state = "redeyes"
	temperance_bonus = 3
	slot = EYE

/datum/ego_gifts/match
	name = "Fourth Match Flame"
	icon_state = "match"
	fortitude_bonus = 4
	slot = MOUTH_2

/datum/ego_gifts/beak
	name = "Beak"
	icon_state = "beak"
	justice_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/fragments
	name = "Fragments From Somewhere"
	icon_state = "fragments"
	temperance_bonus = 2
	slot = BROOCH

/datum/ego_gifts/horn
	name = "Horn"
	icon_state = "horn"
	fortitude_bonus = 2
	prudence_bonus = 2
	slot = HAT

/datum/ego_gifts/wrist
	name = "Wrist Cutter"
	icon_state = "wrist"
	temperance_bonus = 2
	slot = HAND_2

/datum/ego_gifts/cherry
	name = "Cherry Blossom"
	icon_state = "cherry"
	fortitude_bonus = 2
	justice_bonus = 2
	slot = HAT

/datum/ego_gifts/engulfing
	name = "Engulfing Dream"
	icon_state = "engulfing"
	prudence_bonus = 4
	slot = HAT

/datum/ego_gifts/regret
	name = "Regret"
	icon_state = "regret"
	fortitude_bonus = 2
	prudence_bonus = 2
	slot = MOUTH_1

/datum/ego_gifts/noise
	name = "Noise"
	icon_state = "noise"
	justice_bonus = 2
	slot = BROOCH

/datum/ego_gifts/lutemis
	name = "Dear Lutemis"
	icon_state = "lutemis"
	prudence_bonus = 4 // Because fuck you, this can kill you if you have 56+ prudence and don't pay attention
	slot = NECKWEAR

/// All HE EGO Gifts
/datum/ego_gifts/loggging
	name = "Logging"
	icon_state = "loggging"
	fortitude_bonus = 2
	temperance_bonus = 2
	slot = BROOCH

/datum/ego_gifts/harvest
	name = "Harvest"
	icon_state = "harvest"
	prudence_bonus = 4
	slot = NECKWEAR

/datum/ego_gifts/christmas
	name = "Christmas"
	icon_state = "christmas"
	fortitude_bonus = -4
	prudence_bonus = 8
	slot = HAT

/datum/ego_gifts/grinder
	name = "Grinder Mk4"
	icon_state = "grinder"
	temperance_bonus = 4
	insight_mod = 3
	slot = EYE

/datum/ego_gifts/bearpaw
	name = "Bear Paws"
	icon_state = "bearpaws"
	prudence_bonus = 4
	attachment_mod = 3
	slot = HAT

/datum/ego_gifts/magicbullet
	name = "Magic Bullet"
	icon_state = "magicbullet"
	fortitude_bonus = -5
	prudence_bonus = -5
	justice_bonus = 10
	slot = MOUTH_2

/datum/ego_gifts/oppression
	name = "Oppression"
	icon_state = "oppression"
	prudence_bonus = 2
	justice_bonus = 2
	slot = MOUTH_1

/datum/ego_gifts/prank
	name = "Funny Prank"
	icon_state = "prank"
	prudence_bonus = 4
	slot = HELMET

/datum/ego_gifts/desire
	name = "Sanguine Desire"
	icon_state = "desire"
	fortitude_bonus = 4
	slot = MOUTH_2

/datum/ego_gifts/frost
	name = "Those who know the Cruelty of Winter and the Aroma of Roses"
	icon_state = "frost"
	fortitude_bonus = 6
	prudence_bonus = 6
	slot = CHEEK

/datum/ego_gifts/harmony
	name = "Harmony"
	icon_state = "harmony"
	fortitude_bonus = 8
	prudence_bonus = -4
	slot = CHEEK

/datum/ego_gifts/waltz // Locked to Champions only, so Improved it
	name = "Flower Waltz"
	icon_state = "waltz"
	fortitude_bonus = 2
	prudence_bonus = 2
	justice_bonus = 2
	slot = HELMET

/datum/ego_gifts/remorse // All it takes is a single crack in one's psyche...
	name = "Remorse"
	icon_state = "remorse"
	prudence_bonus = 10
	justice_bonus = -5
	slot = BROOCH

/datum/ego_gifts/fury
	name = "Blind Fury"
	icon_state = "fury"
	fortitude_bonus = 10
	prudence_bonus = -2
	temperance_bonus = -2
	justice_bonus = -2
	slot = EYE

/datum/ego_gifts/solemnlament
	name = "Solemn Lament"
	icon_state = "solemnlament"
	fortitude_bonus = 1
	prudence_bonus = 1
	temperance_bonus = 1
	justice_bonus = 1
	slot = RIGHTBACK

/datum/ego_gifts/courage_cat //crumbling armor also has an ego gift called courage so the name has to be slightly different
	name = "Courage"
	icon_state = "courage_cat"
	fortitude_bonus = 4
	justice_bonus = -4 //people will hate that one for sure
	insight_mod = 6
	slot = EYE

/// All WAW EGO Gifts
/datum/ego_gifts/correctional
	name = "Correctional"
	icon_state = "correctional"
	fortitude_bonus = 3
	justice_bonus = 3
	slot = FACE

/datum/ego_gifts/hornet
	name = "Hornet"
	icon_state = "hornet"
	fortitude_bonus = 2
	prudence_bonus = 4
	slot = HELMET

/datum/ego_gifts/justitia
	name = "Justitia"
	icon_state = "justitia"
	justice_bonus = 6
	repression_mod = 6
	slot = EYE

/datum/ego_gifts/love_and_hate
	name = "In the Name of Love and Hate"
	icon_state = "lovehate"
	temperance_bonus = 2
	justice_bonus = 4
	slot = HAT

/datum/ego_gifts/tears
	name = "Sword Sharpened With Tears"
	icon_state = "tears"
	prudence_bonus = 2
	justice_bonus = 4
	slot = CHEEK

/datum/ego_gifts/lamp
	name = "Lamp"
	icon_state = "lamp"
	prudence_bonus = 3
	temperance_bonus = 3
	slot = HELMET

/datum/ego_gifts/crimson
	name = "Crimson Scar"
	icon_state = "crimson"
	fortitude_bonus = 3
	justice_bonus = 3
	slot = MOUTH_1

/datum/ego_gifts/cobalt
	name = "Cobalt Scar"
	icon_state = "cobalt"
	fortitude_bonus = 4
	justice_bonus = 2
	slot = FACE

/datum/ego_gifts/goldrush
	name = "Gold Rush"
	icon_state = "goldrush"
	fortitude_bonus = 6
	instinct_mod = 6
	slot = HAND_1

/datum/ego_gifts/aroma
	name = "Faint Aroma"
	icon_state = "aroma"
	prudence_bonus = 4
	temperance_bonus = 2 // This is techincally a buff from base game.
	slot = HAT

/// All ALEPH EGO Gifts
/datum/ego_gifts/paradise
	name = "Paradise Lost"
	icon_state = "paradiselost"
	fortitude_bonus = 10
	prudence_bonus = 10
	justice_bonus = 10
	slot = LEFTBACK

/datum/ego_gifts/dacapo
	name = "Da Capo"
	icon_state = "dacapo"
	temperance_bonus = 4
	slot = EYE

/datum/ego_gifts/mimicry
	name = "Mimicry"
	icon_state = "mimicry"
	fortitude_bonus = 10
	slot = CHEEK

/datum/ego_gifts/smile
	name = "Smile"
	icon_state = "smile"
	fortitude_bonus = 5
	prudence_bonus = 5
	slot = EYE

/datum/ego_gifts/amogus
	name = "Imposter"
	icon_state = "amogus"
	fortitude_bonus = -5
	prudence_bonus = -5
	justice_bonus = 15
	slot = EYE

/datum/ego_gifts/adoration
	name = "Adoration"
	icon_state = "adoration"
	fortitude_bonus = 5
	prudence_bonus = 10
	temperance_bonus = -5
	slot = HELMET

/datum/ego_gifts/star
	name = "Sound of a Star"
	icon_state = "star"
	justice_bonus = 10
	slot = EYE

/datum/ego_gifts/blossoming
	name = "100 Paper Flowers"
	icon_state = "blooming"
	justice_bonus = 8
	slot = SPECIAL

/datum/ego_gifts/blossoming/Initialize(mob/living/carbon/human/user) // As a boost, undoes the debuff it applies to you
	.=..()
	user.physiology.red_mod *= 0.9
	user.physiology.white_mod *= 0.9
	user.physiology.black_mod *= 0.9
	user.physiology.pale_mod *= 0.9

/datum/ego_gifts/blossoming/Remove(mob/living/carbon/human/user) // Niceness can be taken away, I suppose
	user.physiology.red_mod /= 0.9
	user.physiology.white_mod /= 0.9
	user.physiology.black_mod /= 0.9
	user.physiology.pale_mod /= 0.9
	.=..()

/// All Event EGO Gifts
/datum/ego_gifts/twilight
	name = "Twilight"
	icon_state = "twilight"
	fortitude_bonus = 7
	prudence_bonus = 7
	temperance_bonus = 7
	justice_bonus = 7
	slot = RIGHTBACK

/datum/ego_gifts/blessing
	name = "Blessing"
	icon_state = "blessing"
	fortitude_bonus = 4
	prudence_bonus = 4
	temperance_bonus = 4
	justice_bonus = 4
	slot = SPECIAL

/datum/ego_gifts/blessing/Initialize(mob/living/carbon/human/user) // Lowered Stats but Pale Resist
	.=..()
	user.physiology.pale_mod *= 0.8

/datum/ego_gifts/blessing/Remove(mob/living/carbon/human/user)
	user.physiology.pale_mod /= 0.8
	.=..()

/datum/ego_gifts/censored
	name = "CENSORED"
	icon_state = "censored"
	prudence_bonus = 10
	slot = EYE
