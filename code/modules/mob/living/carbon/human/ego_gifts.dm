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

// Helper lists
#define EGO_GIFT_BONUSES list("fortitude_bonus", "prudence_bonus", "temperance_bonus", "justice_bonus", \
						"instinct_mod", "insight_mod", "attachment_mod", "repression_mod")

#define EGO_GIFT_BONUS_WORKS list("instinct_mod", "insight_mod", "attachment_mod", "repression_mod")

/datum/ego_gifts // Currently Covers most EGO Gift Functions, most others can be done via armors
	var/name = ""
	var/desc = null
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
	var/visible = TRUE
	var/mob/living/carbon/human/owner
	var/datum/abnormality/datum_reference = null

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

/datum/ego_gifts/Topic(href, list/href_list)
	switch(href_list["choice"])
		if("lock")
			locked = locked ? FALSE : TRUE
			owner.ShowGifts()
		if("hide")
			Refresh_Gift_Sprite(visible) //for uniquely colored gifts
		if("dissolve")
			if(tgui_alert(owner, "Are you sure you want to dissolve the [src]?", "Dissolve Gift", list("Yes", "No"), 0) == "Yes") // We only go if they hit "Yes" specifically.
				if(locked)
					to_chat(owner, span_warning("[src] is locked and cannot be dissolved! Phew!"))
					return
				if(istype(src, /datum/ego_gifts/waltz)) // Blessing Rejection
					if(tgui_alert(owner, "Are you sure you want to do this? A champion should not abandon their post.", "Remove Blessing", list("Yes", "No"), 0) == "Yes")
						if(QDELETED(src) || !istype(src, /datum/ego_gifts/waltz))
							return
						to_chat(owner, span_warning("Removal of the crown leaves your mind scarred!"))
						owner.adjustSanityLoss(75)
					else
						return
				var/datum/ego_gifts/empty/dissolving = new
				dissolving.slot = src.slot
				if(!datum_reference)
					to_chat(owner, span_notice("The [src] has dissolved into... light?"))
					owner.Apply_Gift(dissolving)
					return
				var/PE_received = 0
				PE_received += (datum_reference.threat_level * datum_reference.threat_level)
				if(istype(src, /datum/ego_gifts/blossoming) || istype(src, /datum/ego_gifts/paradise)) // Why though
					PE_received *= 2
				if(ispath(datum_reference.abno_path, /mob/living/simple_animal/hostile/abnormality/crumbling_armor))
					var/answer = tgui_alert(owner, "To think one would commit such a shameful act... what have ye, weaker body or mind?", "Cowardice", list("Body", "Mind"), 0)
					if(QDELETED(src) || !ispath(src.datum_reference.abno_path, /mob/living/simple_animal/hostile/abnormality/crumbling_armor))
						return
					switch(answer)
						if("Body")
							owner.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -5)
							to_chat(owner, span_notice("Least ye have not hid from this."))
						if("Mind")
							owner.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -5)
							to_chat(owner, span_notice("Least ye have not hid from this."))
						else
							owner.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -5)
							owner.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -5)
							to_chat(owner, span_userdanger("Even now you try and run? Clearly you are lacking in both!"))
					to_chat(owner, span_warning("The once cool flames now burn your flesh!"))
					owner.adjustBruteLoss(100)
				to_chat(owner, span_notice("The [src] has dissolved into [PE_received] PE for [datum_reference.name]!"))
				datum_reference.stored_boxes += PE_received
				owner.Apply_Gift(dissolving)
		if("description")
			var/dat = "<b>[name]</b>"
			dat += "<hr><br>"
			if(desc)
				dat += desc
				dat += "<hr><br>"
			// Attempted to make it a define and failed, so here it is
			var/list/text_list = list(
				"fortitude_bonus" = FORTITUDE_ATTRIBUTE,
				"prudence_bonus" = PRUDENCE_ATTRIBUTE,
				"temperance_bonus" = TEMPERANCE_ATTRIBUTE,
				"justice_bonus" = JUSTICE_ATTRIBUTE,
				"instinct_mod" = "Instinct Work",
				"insight_mod" = "Insight Work",
				"attachment_mod" = "Attachment Work",
				"repression_mod" = "Repression Work",
				)
			for(var/thing in EGO_GIFT_BONUSES)
				var/thing_num = vars[thing]
				if(thing_num == 0)
					continue
				var/thing_name = text_list[thing]
				dat += "[thing_name]: [thing_num > 0 ? "+" : ""][thing_num][(thing in EGO_GIFT_BONUS_WORKS) ? "%" : ""]<br>"
			var/datum/browser/popup = new(owner, "gift_description", "<div align='center'>[name]</div>", 300, 350)
			popup.set_content(dat)
			popup.open(FALSE)
		else
			CRASH("Gift Topic Error in [src]. [owner] clicked a non-existant button!?")

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

/datum/ego_gifts/proc/Refresh_Gift_Sprite(option)
	switch(option)
		if(FALSE)
			owner.add_overlay(mutable_appearance(src.icon, src.icon_state, src.layer))
			visible = TRUE
		if(TRUE)
			owner.cut_overlay(mutable_appearance(src.icon, src.icon_state, src.layer))
			visible = FALSE

/// Empty EGO GIFT Slot
/datum/ego_gifts/empty
	name = "Empty"
	desc = "An empty slot for gifts."
	icon_state = null

/**
 * Zayin EGO Gifts
 */

/datum/ego_gifts/alice
	name = "Little Alice"
	icon_state = "alice"
	temperance_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/change
	name = "Change"
	icon_state = "change"
	fortitude_bonus = 2
	slot = BROOCH

/datum/ego_gifts/doze
	name = "Dozing"
	icon_state = "doze"
	justice_bonus = 2
	slot = EYE

/datum/ego_gifts/eclipse
	name = "Eclipse of Scarlet Moths"
	icon_state = "eclipse"
	temperance_bonus = 2
	slot = BROOCH

/datum/ego_gifts/evening
	name = "Evening Twilight"
	icon_state = "evening"
	justice_bonus = 2
	slot = FACE

/datum/ego_gifts/mail
	name = "Empty Envelope"
	icon_state = "mail"
	prudence_bonus = 1
	temperance_bonus = 1
	slot = CHEEK

/datum/ego_gifts/melty_eyeball
	name = "Melty Eyeball"
	icon_state = "melty_eyeball"
	prudence_bonus = 2
	slot = EYE

/datum/ego_gifts/nightshade
	name = "Nightshade"
	icon_state = "nightshade"
	prudence_bonus = 2
	slot = HAND_1

/datum/ego_gifts/nostalgia
	name = "Nostalgia"
	icon_state = "nostalgia"
	temperance_bonus = 2
	slot = MOUTH_2

/datum/ego_gifts/oceanic
	name = "Taste of the Sea"
	icon_state = "oceanic"
	temperance_bonus = 2
	slot = HAND_2

/datum/ego_gifts/penitence
	name = "Penitence"
	desc = "Provides a 10% bonus to works with corresponding abnormality."
	icon_state = "penitence"
	prudence_bonus = 2
	slot = HAT

/datum/ego_gifts/soda
	name = "Soda"
	icon_state = "soda"
	fortitude_bonus = 2
	slot = MOUTH_2

/datum/ego_gifts/tough
	name = "Tough"
	icon_state = "tough"
	justice_bonus = 2
	slot = EYE

/datum/ego_gifts/wingbeat
	name = "Wingbeat"
	icon_state = "wingbeat"
	temperance_bonus = 2
	slot = HAND_2

/**
 * TETH EGO Gifts
 */

/datum/ego_gifts/beak
	name = "Beak"
	icon_state = "beak"
	justice_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/bean
	name = "Magic Bean"
	icon_state = "bean"
	prudence_bonus = 2
	temperance_bonus = 2
	slot = HAT

/datum/ego_gifts/blossom
	name = "Cherry Blossom"
	icon_state = "cherry"
	fortitude_bonus = 2
	justice_bonus = 2
	slot = HAT

/datum/ego_gifts/bunny
	name = "Bunny Rabbit"
	icon_state = "bunny"
	fortitude_bonus = -2
	prudence_bonus = -2
	temperance_bonus = 6
	slot = HAT

/datum/ego_gifts/curfew
	name = "Curfew"
	icon_state = "curfew"
	fortitude_bonus = -1
	prudence_bonus = 4
	slot = HAND_1

/datum/ego_gifts/cute
	name = "SO CUTE!!!"
	icon_state = "cute"
	fortitude_bonus = 4
	temperance_bonus = -2
	slot = HAT

/datum/ego_gifts/dream
	name = "Engulfing Dream"
	icon_state = "engulfing"
	prudence_bonus = 4
	slot = HAT

/datum/ego_gifts/fourleaf_clover
	name = "Four-Leaf Clover"
	icon_state = "fourleaf_clover"
	fortitude_bonus = 3
	prudence_bonus = 1
	slot = HELMET

/datum/ego_gifts/fragments
	name = "Fragments From Somewhere"
	icon_state = "fragments"
	temperance_bonus = 2
	slot = BROOCH

/datum/ego_gifts/hearth
	name = "Hearth"
	icon_state = "hearth"
	prudence_bonus = 2
	temperance_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/horn
	name = "Horn"
	icon_state = "horn"
	fortitude_bonus = 2
	prudence_bonus = 2
	slot = HAT

/datum/ego_gifts/lantern
	name = "Lantern"
	icon_state = "lantern"
	fortitude_bonus = 5
	slot = MOUTH_2

/datum/ego_gifts/lutemis
	name = "Dear Lutemis"
	icon_state = "lutemis"
	prudence_bonus = 4 // Because fuck you, this can kill you if you have 56+ prudence and don't pay attention
	slot = NECKWEAR

/datum/ego_gifts/match
	name = "Fourth Match Flame"
	icon_state = "match"
	fortitude_bonus = 4
	slot = MOUTH_2

/datum/ego_gifts/noise
	name = "Noise"
	icon_state = "noise"
	justice_bonus = 2
	slot = BROOCH

/datum/ego_gifts/page
	name = "Page"
	icon_state = "page"
	prudence_bonus = 2
	justice_bonus = 2
	slot = HAND_1

/datum/ego_gifts/patriot
	name = "Patriot"
	icon_state = "patriot"
	fortitude_bonus = 2
	justice_bonus = 2
	temperance_bonus = -1
	slot = HAT

/datum/ego_gifts/red_sheet
	name = "Talisman Bundle"
	icon_state = "red_sheet"
	justice_bonus = 3
	slot = HELMET

/datum/ego_gifts/redeyes
	name = "Red Eyes"
	icon_state = "redeyes"
	temperance_bonus = 3
	slot = EYE

/datum/ego_gifts/regret
	name = "Regret"
	icon_state = "regret"
	fortitude_bonus = 2
	prudence_bonus = 2
	slot = MOUTH_1

/datum/ego_gifts/revelation
	name = "Revelation"
	icon_state = "revelation"
	temperance_bonus = -2
	justice_bonus = 4
	slot = EYE

/datum/ego_gifts/sanitizer
	name = "Sanitizer"
	icon_state = "sanitizer"
	justice_bonus = 2
	slot = HAND_2

/datum/ego_gifts/shy
	name = "Today's Expression"
	icon_state = "shy"
	prudence_bonus = -2
	temperance_bonus = 4
	slot = EYE

/datum/ego_gifts/sloshing
	name = "Green Spirit"
	icon_state = "sloshing"
	fortitude_bonus = 3
	prudence_bonus = -1
	justice_bonus = 1
	slot = CHEEK

/datum/ego_gifts/snapshot
	name = "Snapshot"
	icon_state = "snapshot"
	temperance_bonus = 3
	prudence_bonus = -1
	slot = NECKWEAR

/datum/ego_gifts/solitude
	name = "Solitude"
	icon_state = "solitude"
	temperance_bonus = 3
	slot = EYE

/datum/ego_gifts/sorority
	name = "Sorority"
	icon_state = "sorority"
	fortitude_bonus = 2
	prudence_bonus = 2
	temperance_bonus = -1
	slot = CHEEK

/datum/ego_gifts/sorrow
	name = "Sorrow"
	icon_state = "sorrow"
	fortitude_bonus = 1
	prudence_bonus = 3
	slot = HELMET

/datum/ego_gifts/standard
	name = "Standard Training E.G.O."
	icon_state = "standard"
	fortitude_bonus = 2
	prudence_bonus = 2
	slot = HAT

/datum/ego_gifts/trick
	name = "Hat Trick"
	icon_state = "trick"
	justice_bonus = 3
	slot = MOUTH_1

/datum/ego_gifts/visions
	name = "Fiery Down"
	icon_state = "visions"
	prudence_bonus = 3
	slot = NECKWEAR

/datum/ego_gifts/wedge
	name = "Screaming Wedge"
	icon_state = "wedge"
	temperance_bonus = -1
	prudence_bonus = 4
	slot = BROOCH

/datum/ego_gifts/wrist
	name = "Wrist Cutter"
	icon_state = "wrist"
	temperance_bonus = 2
	slot = HAND_2

/datum/ego_gifts/zauberhorn
	name = "Zauberhorn"
	icon_state = "zauberhorn"
	fortitude_bonus = 2
	prudence_bonus = 1
	justice_bonus = 1
	slot = HAND_1

/**
 * HE EGO Gifts
 */

/datum/ego_gifts/alleyway
	name = "Alleyway"
	icon_state = "alleyway"
	fortitude_bonus = 2
	prudence_bonus = 2
	temperance_bonus = -2
	justice_bonus = 2
	slot = HAND_2

/datum/ego_gifts/bearpaw
	name = "Bear Paws"
	icon_state = "bearpaws"
	prudence_bonus = 4
	attachment_mod = 3
	slot = HAT

/datum/ego_gifts/christmas
	name = "Christmas"
	icon_state = "christmas"
	fortitude_bonus = -4
	prudence_bonus = 8
	slot = HAT

/datum/ego_gifts/courage_cat //crumbling armor also has an ego gift called courage so the name has to be slightly different
	name = "Courage"
	icon_state = "courage_cat"
	fortitude_bonus = 4
	justice_bonus = -4 //people will hate that one for sure
	insight_mod = 6
	slot = EYE

/datum/ego_gifts/desire
	name = "Sanguine Desire"
	icon_state = "desire"
	fortitude_bonus = 4
	slot = MOUTH_2

/datum/ego_gifts/faelantern
	name = "Midwinter Nightmare"
	icon_state = "faelantern"
	prudence_bonus = 3
	temperance_bonus = 2
	slot = LEFTBACK

/datum/ego_gifts/fluid_sac
	name = "Fluid Sac"
	icon_state = "fluid_sac"
	fortitude_bonus = 2
	temperance_bonus = 2
	slot = MOUTH_2

/datum/ego_gifts/frost
	name = "Those who know the Cruelty of Winter and the Aroma of Roses"
	icon_state = "frost"
	fortitude_bonus = 6
	prudence_bonus = 6
	slot = CHEEK

/datum/ego_gifts/fury
	name = "Blind Fury"
	icon_state = "fury"
	fortitude_bonus = 10
	prudence_bonus = -2
	temperance_bonus = -2
	justice_bonus = -2
	slot = EYE

/datum/ego_gifts/galaxy
	name = "Galaxy"
	icon_state = "galaxy"
	fortitude_bonus = 1
	prudence_bonus = 1
	temperance_bonus = 3
	slot = NECKWEAR

/datum/ego_gifts/gaze
	name = "Gaze"
	icon_state = "gaze"
	fortitude_bonus = 4
	slot = HAND_2

/datum/ego_gifts/get_strong
	name = "Screwloose"
	icon_state = "get_strong"
	fortitude_bonus = 4
	prudence_bonus = -2
	temperance_bonus = -2
	justice_bonus = 4
	slot = HELMET

/datum/ego_gifts/grasp
	name = "Grasp"
	icon_state = "grasp"
	temperance_bonus = 3
	justice_bonus = 1
	slot = NECKWEAR

/datum/ego_gifts/grinder
	name = "Grinder Mk4"
	icon_state = "grinder"
	temperance_bonus = 4
	insight_mod = 3
	slot = EYE

/datum/ego_gifts/harmony
	name = "Harmony"
	icon_state = "harmony"
	fortitude_bonus = 8
	prudence_bonus = -4
	slot = CHEEK

/datum/ego_gifts/harvest
	name = "Harvest"
	icon_state = "harvest"
	prudence_bonus = 4
	slot = NECKWEAR

/datum/ego_gifts/homing_instinct
	name = "Homing Instinct"
	icon_state = "homing_instinct"
	fortitude_bonus = -2
	prudence_bonus = -1
	temperance_bonus = 3
	justice_bonus = 5
	slot = HAND_2

/datum/ego_gifts/impending_day
	name = "Impending Day"
	icon_state = "doomsday"
	fortitude_bonus = 4
	prudence_bonus = -2
	justice_bonus = 2
	slot = HELMET

/datum/ego_gifts/inheritance
	name = "Inheritance"
	icon_state = "inheritance"
	fortitude_bonus = 3
	prudence_bonus = -1
	temperance_bonus = -1
	justice_bonus = 3
	slot = RIGHTBACK

/datum/ego_gifts/legerdemain
	name = "Legerdemain"
	icon_state = "legerdemain"
	fortitude_bonus = 2
	prudence_bonus = 2
	slot = HAND_1

/datum/ego_gifts/lifestew
	name = "Lifetime Stew"
	icon_state = "lifestew"
	fortitude_bonus = 1
	temperance_bonus = 3
	slot = HELMET

/datum/ego_gifts/loggging
	name = "Logging"
	icon_state = "loggging"
	fortitude_bonus = 2
	temperance_bonus = 2
	slot = BROOCH

/datum/ego_gifts/magicbullet
	name = "Magic Bullet"
	icon_state = "magicbullet"
	fortitude_bonus = -5
	prudence_bonus = -5
	justice_bonus = 10
	slot = MOUTH_2

/datum/ego_gifts/maneater
	name = "Man Eater"
	icon_state = "maneater"
	fortitude_bonus = 2
	temperance_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/marionette
	name = "Marionette"
	icon_state = "marionette"
	fortitude_bonus = 3
	prudence_bonus = 3
	justice_bonus = -2
	slot = FACE

/datum/ego_gifts/metal
	name = "Bare Metal"
	icon_state = "metal"
	fortitude_bonus = 1
	prudence_bonus = 1
	temperance_bonus = 1
	justice_bonus = 1
	slot = HAND_1

/datum/ego_gifts/nixie
	name = "Nixie Divergence"
	icon_state = "nixie"
	slot = HAND_1
	fortitude_bonus  = 2
	justice_bonus = 2

/datum/ego_gifts/oppression
	name = "Oppression"
	icon_state = "oppression"
	prudence_bonus = 2
	justice_bonus = 2
	slot = MOUTH_1

/datum/ego_gifts/pleasure
	name = "Pleasure"
	icon_state = "pleasure"
	prudence_bonus = 10
	temperance_bonus = -6
	slot = NECKWEAR

/datum/ego_gifts/prank
	name = "Funny Prank"
	icon_state = "prank"
	prudence_bonus = 4
	slot = HELMET

/datum/ego_gifts/remorse // All it takes is a single crack in one's psyche...
	name = "Remorse"
	icon_state = "remorse"
	prudence_bonus = 10
	justice_bonus = -5
	slot = BROOCH

/datum/ego_gifts/replica
	name = "Pinpoint Logic Circuit"
	icon_state = "replica"
	fortitude_bonus = -3
	prudence_bonus = 1
	temperance_bonus = 2
	justice_bonus = 4
	slot = BROOCH

/datum/ego_gifts/roseate_desire
	name = "Roseate Desire"
	icon_state = "roseate_desire"
	prudence_bonus = 2
	temperance_bonus = -4
	justice_bonus = 4
	slot = EYE

/datum/ego_gifts/solemnlament
	name = "Solemn Lament"
	icon_state = "solemnlament"
	fortitude_bonus = 1
	prudence_bonus = 1
	temperance_bonus = 1
	justice_bonus = 1
	slot = RIGHTBACK

/datum/ego_gifts/song
	name = "Song of the Past"
	icon_state = "song"
	prudence_bonus = 2
	justice_bonus = 2
	slot = CHEEK

/datum/ego_gifts/split
	name = "Split"
	icon_state = "split"
	fortitude_bonus = 2
	temperance_bonus = 2
	slot = MOUTH_1

/datum/ego_gifts/syrinx // Your reward for dealing with one of the worst abnormalities ever
	name = "Syrinx"
	icon_state = "syrinx"
	desc = "Provides the user with 5% resistance to white damage."
	slot = HELMET
	fortitude_bonus = 1
	prudence_bonus = 1

/datum/ego_gifts/syrinx/Initialize(mob/living/carbon/human/user) // grants resistance
	. = ..()
	user.physiology.white_mod *= 0.95

/datum/ego_gifts/syrinx/Remove(mob/living/carbon/human/user)
	user.physiology.white_mod /= 0.95
	return ..()

/datum/ego_gifts/totalitarianism
	name = "Totalitarianism"
	icon_state = "totalitarianism"
	fortitude_bonus = 2
	temperance_bonus = 2
	slot = CHEEK

/datum/ego_gifts/transmission
	name = "Transmission"
	icon_state = "transmission"
	fortitude_bonus = 4
	prudence_bonus = 2
	temperance_bonus = -1
	slot = HAT

/datum/ego_gifts/unrequited_love
	name = "Unrequited Love"
	icon_state = "unrequited_love"
	fortitude_bonus = -2
	prudence_bonus = 5
	temperance_bonus = 5
	justice_bonus = -2
	slot = CHEEK

/datum/ego_gifts/uturn
	name = "Milepost of Survival"
	icon_state = "uturn"
	slot = FACE
	fortitude_bonus  = 2
	justice_bonus = 2

/datum/ego_gifts/voodoo
	name = "Voodoo Doll"
	icon_state = "voodo"
	slot = MOUTH_1
	fortitude_bonus  = 2
	justice_bonus = 2

/datum/ego_gifts/waltz // Locked to Champions only, wearing it carries a risk but it's powerful
	name = "Flower Waltz"
	icon_state = "waltz"
	prudence_bonus = 2
	temperance_bonus = 2
	justice_bonus = 12
	slot = HELMET

/datum/ego_gifts/warp
	name = "Blue Zippo Lighter"
	icon_state = "warp"
	fortitude_bonus  = 4
	justice_bonus = 2
	slot = HAND_2

/datum/ego_gifts/sunshower
	name = "Sunshower"
	icon_state = "sunshower"
	temperance_bonus = 5
	justice_bonus = -2
	prudence_bonus = -2
	slot = LEFTBACK

/**
 * WAW EGO Gifts
 */

/datum/ego_gifts/amrita
	name = "Amrita"
	icon_state = "amrita"
	fortitude_bonus = 10
	prudence_bonus = -4
	slot = HAND_1

// Converts 10% of WHITE damage taken(before armor calculations!) as health
// tl;dr - If you were to get hit by an attack of 200 WHITE damage - you restore 20 health, regardless of how much
// damage you actually took
/datum/ego_gifts/aroma
	name = "Faint Aroma"
	desc = "Restores 10% of WHITE damage taken as health. This effect ignores armor."
	icon_state = "aroma"
	prudence_bonus = 4
	temperance_bonus = 2
	slot = HAT

/datum/ego_gifts/aroma/Initialize(mob/living/carbon/human/user)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, PROC_REF(AttemptHeal))

/datum/ego_gifts/aroma/Remove(mob/living/carbon/human/user)
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE, PROC_REF(AttemptHeal))
	return ..()

/datum/ego_gifts/aroma/proc/AttemptHeal(datum/source, damage, damagetype, def_zone)
	if(!owner && damagetype != WHITE_DAMAGE)
		return
	if(!damage)
		return
	owner.adjustBruteLoss(-damage*0.1)

/datum/ego_gifts/assonance
	name = "Assonance"
	icon_state = "assonance"
	prudence_bonus = 2
	temperance_bonus = 2
	justice_bonus = 2
	slot = HAT

/datum/ego_gifts/blahaj
	name = "Blahaj"
	icon_state = "blahaj"
	fortitude_bonus = -15
	prudence_bonus = 15
	temperance_bonus = 5
	slot = RIGHTBACK

/datum/ego_gifts/blind_obsession
	name = "Blind Obsession"
	icon_state = "slitcurrent"
	temperance_bonus = -5//People are going to hate this.
	justice_bonus = 12
	slot = HAT

/datum/ego_gifts/blind_rage
	name = "Blind Rage"
	icon_state = "blind_rage"
	fortitude_bonus = 2
	justice_bonus = 4
	slot = HAT

/datum/ego_gifts/bride
	name = "Bride"
	icon_state = "bride"
	prudence_bonus = 2
	temperance_bonus = 5
	slot = HAT

/datum/ego_gifts/cobalt
	name = "Cobalt Scar"
	icon_state = "cobalt"
	fortitude_bonus = 4
	justice_bonus = 2
	slot = FACE

/datum/ego_gifts/coiling
	name = "Coiling"
	icon_state = "coiling"
	fortitude_bonus = 5
	slot = MOUTH_2

/datum/ego_gifts/correctional
	name = "Correctional"
	icon_state = "correctional"
	fortitude_bonus = 3
	justice_bonus = 3
	slot = FACE

/datum/ego_gifts/crimson
	name = "Crimson Scar"
	icon_state = "crimson"
	fortitude_bonus = 3
	justice_bonus = 3
	slot = MOUTH_1

/datum/ego_gifts/darkcarnival
	name = "Dark Carnival"
	icon_state = "dark_carnival"
	temperance_bonus = 4
	prudence_bonus = 4
	justice_bonus = -2
	slot = FACE

/datum/ego_gifts/diffraction
	name = "Diffraction"
	icon_state = "diffraction"
	prudence_bonus = 6
	slot = HELMET

/datum/ego_gifts/dipsia
	name = "Dipsia"
	icon_state = "dipsia"
	fortitude_bonus = 4
	temperance_bonus = 2
	slot = FACE

/datum/ego_gifts/discord
	name = "Discord"
	icon_state = "discord"
	fortitude_bonus = -10
	prudence_bonus = -10
	justice_bonus = 20
	slot = HELMET

/datum/ego_gifts/ebony_stem
	name = "Ebony Stem"
	icon_state = "ebony_stem"
	prudence_bonus = 4
	justice_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/ecstasy
	name = "Ecstasy"
	icon_state = "ecstasy"
	prudence_bonus = 6
	slot = MOUTH_2

/datum/ego_gifts/executive
	name = "Executive"
	icon_state = "executive"
	prudence_bonus = 8
	justice_bonus = -2
	slot = HAND_2

/datum/ego_gifts/exuviae
	name = "Exuviae"
	icon_state = "exuviae"
	prudence_bonus = 2
	fortitude_bonus = 5
	slot = HAND_2

/datum/ego_gifts/feather
	name = "Feather of Honor"
	icon_state = "feather"
	prudence_bonus = 2
	justice_bonus = 4
	slot = HAT

/datum/ego_gifts/goldrush
	name = "Gold Rush"
	icon_state = "goldrush"
	fortitude_bonus = 6
	instinct_mod = 6
	slot = HAND_1

/datum/ego_gifts/heart
	name = "Heart"
	icon_state = "heart"
	fortitude_bonus = 3
	justice_bonus = 3
	slot = HAND_1

/datum/ego_gifts/hornet
	name = "Hornet"
	icon_state = "hornet"
	fortitude_bonus = 2
	prudence_bonus = 4
	slot = HELMET

/datum/ego_gifts/hypocrisy
	name = "Hypocrisy"
	icon_state = "hypocrisy"
	layer = BODY_BEHIND_LAYER
	prudence_bonus = 3
	fortitude_bonus = 3
	slot = HELMET
	var/ear_overlay

/datum/ego_gifts/hypocrisy/Initialize(mob/living/carbon/human/user) //have to make a new initialize since the previous one both adds stats and the normal overlay.
	user.ego_gift_list[src.slot] = src
	var/mutable_appearance/colored_overlay = mutable_appearance(src.icon, src.icon_state, src.layer)
	if(user.skin_tone)
		var/user_skin_color = skintone2hex(user.skin_tone)
		colored_overlay.color = "#[user_skin_color]"
	ear_overlay = colored_overlay
	user.add_overlay(ear_overlay)
	user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, src.fortitude_bonus)
	user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, src.prudence_bonus)

/datum/ego_gifts/hypocrisy/Remove(mob/living/carbon/human/user)
	user.cut_overlay(ear_overlay)
	user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, (src.fortitude_bonus * -1))
	user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, (src.prudence_bonus * -1))
	QDEL_NULL(src)

/datum/ego_gifts/hypocrisy/Refresh_Gift_Sprite(option) //hide and unhide to update skin color.
	switch(option)
		if(FALSE)
			var/mutable_appearance/colored_overlay = mutable_appearance(src.icon, src.icon_state, src.layer)
			if(owner.skin_tone)
				var/user_skin_color = skintone2hex(owner.skin_tone)
				colored_overlay.color = "#[user_skin_color]"
			ear_overlay = colored_overlay
			owner.add_overlay(ear_overlay)
			visible = TRUE
		if(TRUE)
			owner.cut_overlay(ear_overlay)
			visible = FALSE

/datum/ego_gifts/infinity
	name = "Infinity"
	icon_state = "infinity"
	temperance_bonus = 2
	justice_bonus = 4
	slot = EYE

/datum/ego_gifts/innocence
	name = "Innocence"
	icon_state = "innocence"
	prudence_bonus = 3
	temperance_bonus = 3
	slot = MOUTH_2

/datum/ego_gifts/justitia
	name = "Justitia"
	icon_state = "justitia"
	justice_bonus = 6
	repression_mod = 6
	slot = EYE

/datum/ego_gifts/lamp
	name = "Lamp"
	icon_state = "lamp"
	prudence_bonus = 3
	temperance_bonus = 3
	slot = HELMET

/datum/ego_gifts/love_and_hate
	name = "In the Name of Love and Hate"
	icon_state = "lovehate"
	temperance_bonus = 2
	justice_bonus = 4
	slot = HAT

/datum/ego_gifts/loyalty
	name = "Loyalty"
	icon_state = "loyalty"
	fortitude_bonus = 10
	prudence_bonus = -4
	slot = BROOCH

/datum/ego_gifts/moonlight
	name = "Moonlight"
	icon_state = "moonlight"
	fortitude_bonus = 1
	instinct_mod = 1
	prudence_bonus = 1
	insight_mod = 1
	temperance_bonus = 1
	justice_bonus = 1
	slot = BROOCH

/datum/ego_gifts/pharaoh
	name = "Pharaoh"
	icon_state = "pharaoh"
	prudence_bonus = 6
	slot = MOUTH_1

/datum/ego_gifts/psychic
	name = "Psychic Dagger"
	icon_state = "psychic"
	fortitude_bonus = -1
	prudence_bonus = 4
	temperance_bonus = 4
	justice_bonus = -1
	slot = CHEEK

/datum/ego_gifts/rimeshank
	name = "Rimeshank"
	icon_state = "rimeshank"
	fortitude_bonus = 4
	temperance_bonus = 2
	slot = NECKWEAR

/datum/ego_gifts/rosa
	name = "Crown of Roses"
	icon_state = "penitence"//TODO: make an actual sprite
	prudence_bonus = 3
	temperance_bonus = 3
	slot = HAT

/datum/ego_gifts/scene
	name = "As Written in the Scenario"
	icon_state = "scene"
	temperance_bonus = -2
	prudence_bonus = 4
	justice_bonus = 4
	slot = FACE

/datum/ego_gifts/spore
	name = "Spore"
	icon_state = "spore"
	prudence_bonus = 5
	temperance_bonus = 2
	slot = HAND_2

/datum/ego_gifts/stem
	name = "Green Stem"
	icon_state = "green_stem"
	prudence_bonus = 6 //originally a SP bonus
	slot = BROOCH

//reduces sanity and fortitude for a 10% buff to work success. Unfortunately this translates to 200 temp
//so right now its 10 temp
/datum/ego_gifts/swan
	name = "Black Swan"
	icon_state = "swan"
	fortitude_bonus = -4
	prudence_bonus = -4
	temperance_bonus = 10
	slot = HAT

/datum/ego_gifts/tears
	name = "Sword Sharpened With Tears"
	icon_state = "tears"
	prudence_bonus = 2
	justice_bonus = 4
	slot = CHEEK

/datum/ego_gifts/thirteen
	name = "Thirteen"
	icon_state = "thirteen"
	fortitude_bonus = 4
	prudence_bonus = -2
	justice_bonus = 4
	slot = HELMET

/datum/ego_gifts/warring
	name = "Feather of Valor"
	icon_state = "warring"
	fortitude_bonus = 2
	justice_bonus = 4
	slot = HAT

/**
 * ALEPH EGO Gifts
 */

/datum/ego_gifts/adoration
	name = "Adoration"
	icon_state = "adoration"
	fortitude_bonus = 5
	prudence_bonus = 10
	temperance_bonus = -5
	slot = HELMET

/datum/ego_gifts/amogus
	name = "Imposter"
	icon_state = "amogus"
	fortitude_bonus = -5
	prudence_bonus = -5
	justice_bonus = 15
	slot = EYE

/datum/ego_gifts/blossoming
	name = "100 Paper Flowers"
	desc = "Provides the user with 10% resistance to all damage sources."
	icon_state = "blooming"
	justice_bonus = 8
	slot = SPECIAL

/datum/ego_gifts/blossoming/Initialize(mob/living/carbon/human/user) // As a boost, undoes the debuff it applies to you
	. = ..()
	user.physiology.red_mod *= 0.9
	user.physiology.white_mod *= 0.9
	user.physiology.black_mod *= 0.9
	user.physiology.pale_mod *= 0.9

/datum/ego_gifts/blossoming/Remove(mob/living/carbon/human/user) // Niceness can be taken away, I suppose
	user.physiology.red_mod /= 0.9
	user.physiology.white_mod /= 0.9
	user.physiology.black_mod /= 0.9
	user.physiology.pale_mod /= 0.9
	return ..()

/datum/ego_gifts/censored
	name = "CENSORED"
	icon_state = "censored"
	prudence_bonus = 10
	slot = EYE

/datum/ego_gifts/dacapo
	name = "Da Capo"
	icon_state = "dacapo"
	temperance_bonus = 4
	slot = EYE

/datum/ego_gifts/distortion
	name = "Distortion"
	icon_state = "distortion"
	fortitude_bonus = 3
	prudence_bonus = 3
	temperance_bonus = 2
	justice_bonus = 2
	slot = BROOCH

/datum/ego_gifts/inconsolable
	name = "Inconsolable Grief"
	icon_state = "inconsolable"
	fortitude_bonus = 10
	prudence_bonus = -5
	justice_bonus = 5
	slot = EYE

/datum/ego_gifts/mimicry
	name = "Mimicry"
	icon_state = "mimicry"
	fortitude_bonus = 10
	slot = CHEEK

/datum/ego_gifts/mockery
	name = "Mockery"
	icon_state = "mockery"
	fortitude_bonus = 5
	prudence_bonus = 5
	slot = HAND_1

/datum/ego_gifts/nihil //May be subject to change when the event is added proper
	name = "Nihil"
	icon_state = "nihil"
	fortitude_bonus = 10
	temperance_bonus = 10
	justice_bonus = 10
	slot = HAT

/datum/ego_gifts/paradise
	name = "Paradise Lost"
	icon_state = "paradiselost"
	fortitude_bonus = 10
	prudence_bonus = 10
	justice_bonus = 10
	slot = LEFTBACK

/datum/ego_gifts/pink
	name = "Pink"
	icon_state = "pink"
	justice_bonus = 10
	slot = HELMET

/datum/ego_gifts/seasons
	name = "Season's Greetings"
	icon_state = "seasons"
	prudence_bonus = 10
	slot = HAND_2

/datum/ego_gifts/smile
	name = "Smile"
	icon_state = "smile"
	fortitude_bonus = 5
	prudence_bonus = 5
	slot = EYE

/datum/ego_gifts/soulmate
	name = "Soulmate"
	icon_state = "soulmate"
	fortitude_bonus = 15
	justice_bonus = -5
	slot = HELMET

/datum/ego_gifts/space
	name = "Space"
	icon_state = "space"
	fortitude_bonus = -5
	prudence_bonus = 15
	slot = FACE

/datum/ego_gifts/star
	name = "Sound of a Star"
	icon_state = "star"
	justice_bonus = 10
	slot = EYE

/datum/ego_gifts/christmas/buff
	name = "Ultimate Christmas"
	fortitude_bonus = 25
	prudence_bonus = -5

/**
 * Event EGO Gifts
 */

/datum/ego_gifts/blessing
	name = "Blessing"
	desc = "Provides the user with 20% resistance to PALE damage."
	icon_state = "blessing"
	fortitude_bonus = 4
	prudence_bonus = 4
	temperance_bonus = 4
	justice_bonus = 4
	slot = SPECIAL

/datum/ego_gifts/blessing/Initialize(mob/living/carbon/human/user) // Lowered Stats but Pale Resist
	. = ..()
	user.physiology.pale_mod *= 0.8

/datum/ego_gifts/blessing/Remove(mob/living/carbon/human/user)
	user.physiology.pale_mod /= 0.8
	return ..()

/datum/ego_gifts/fervor
	name = "Fervor"
	desc = "Provides the user with 5% resistance to all damage types."
	icon_state = "fervor"
	fortitude_bonus = 4
	prudence_bonus = 4
	temperance_bonus = 4
	justice_bonus = 4
	slot = SPECIAL

/datum/ego_gifts/fervor/Initialize(mob/living/carbon/human/user) // Lowered Stats but grants resistance
	. = ..()
	user.physiology.red_mod *= 0.95
	user.physiology.white_mod *= 0.95
	user.physiology.black_mod *= 0.95
	user.physiology.pale_mod *= 0.95

/datum/ego_gifts/fervor/Remove(mob/living/carbon/human/user)
	user.physiology.red_mod /= 0.95
	user.physiology.white_mod /= 0.95
	user.physiology.black_mod /= 0.95
	user.physiology.pale_mod /= 0.95
	return ..()

/datum/ego_gifts/oberon
	name = "Oberon"
	icon_state = "oberon"
	desc = "Provides the user with 10% resistance to RED and BLACK damage."
	fortitude_bonus = 6
	temperance_bonus = 6
	justice_bonus = 6
	slot = LEFTBACK

/datum/ego_gifts/oberon/Initialize(mob/living/carbon/human/user) // Lowered Stats but grants resistance
	. = ..()
	user.physiology.red_mod *= 0.9
	user.physiology.black_mod *= 0.9

/datum/ego_gifts/oberon/Remove(mob/living/carbon/human/user)
	user.physiology.red_mod /= 0.9
	user.physiology.black_mod /= 0.9
	return ..()

/datum/ego_gifts/twilight
	name = "Twilight"
	icon_state = "twilight"
	fortitude_bonus = 7
	prudence_bonus = 7
	temperance_bonus = 7
	justice_bonus = 7
	slot = RIGHTBACK
