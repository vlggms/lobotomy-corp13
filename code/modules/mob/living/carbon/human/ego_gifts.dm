#define HAT "Hat_Slot"
#define HELMET "Helmet_Slot"
#define EYE "Eye_Slot"
#define FACE "Face_Slot"
#define MOUTH_1 "Mouth_Slot_1"
#define MOUTH_2 "Mouth_Slot_2"
#define CHEEK "Cheek_Slot"
#define BROOCH "Brooch_Slot"
#define NECKWEAR "Neckwear_Slot"
#define LEFTBACK "Left_Back_Slot"
#define RIGHTBACK "Right_Back_Slot"
#define HAND_1 "Hand_Slot_1"
#define HAND_2 "Hand_Slot_2"
#define SPECIAL "Special_Other_Slot"
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

/mob/living/carbon/human/proc/Apply_Gift(datum/ego_gifts/given) // Gives the gift and removes the effects of the old one if necessary
	if(!istype(given))
		return
	if(!isnull(ego_gift_list[given.slot]))
		var/datum/ego_gifts/removed_gift = ego_gift_list[given.slot]
		removed_gift.Remove(src)
	given.Initialize(src)

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

/// All Event EGO Gifts
/datum/ego_gifts/twilight
	name = "Twilight"
	icon_state = "twilight"
	fortitude_bonus = 7
	prudence_bonus = 7
	temperance_bonus = 7
	justice_bonus = 7
	slot = RIGHTBACK
