/obj/item/clothing/suit/armor/ego_gear/realization	// 260. You have to be a max rank agent to get these.
	name = "unknown realized ego"
	desc = "Notify Kirie immediately!"
	icon = 'icons/obj/clothing/ego_gear/realization.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/realized.dmi'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 130,
							PRUDENCE_ATTRIBUTE = 130,
							TEMPERANCE_ATTRIBUTE = 130,
							JUSTICE_ATTRIBUTE = 130
							)

/obj/item/clothing/suit/armor/ego_gear/realization/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_OCLOTHING) // Abilities are only granted when worn properly
		return TRUE

/obj/item/clothing/suit/armor/ego_gear/realization/goldexperience
	name = "gold experience"
	desc = "A jacket made of gold is hardly light. But it shines like the sun."
	icon_state = "gold_experience"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 60, PALE_DAMAGE = 70)

/obj/item/clothing/suit/armor/ego_gear/realization/bigiron
	name = "big iron"
	desc = "A hefty silk coat with a blue smock."
	icon_state = "big_iron"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 70, BLACK_DAMAGE = 70, PALE_DAMAGE = 50)

/obj/item/clothing/suit/armor/ego_gear/realization/grinder
	name = "grinder MK52"
	desc = "The blades are not just decorative."
	icon_state = "grinder"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 50)

/obj/item/clothing/suit/armor/ego_gear/realization/grinder/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/aimed/helper_dash/HD = new
	var/datum/action/spell_action/ability/item/A = HD.action
	A.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/realization/alcoda
	name = "al coda"
	desc = "Harmonizes well."
	icon_state = "coda"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 100, BLACK_DAMAGE = 70, PALE_DAMAGE = 20)

/obj/item/clothing/suit/armor/ego_gear/realization/exsanguination
	name = "exsaungination"
	desc = "It keeps your suit relatively clean."
	icon_state = "exsanguination"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 90, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/eulogy
	name = "solemn eulogy"
	desc = "Death is not extinguishing the light, it is putting out the lamp as dawn has come."
	icon_state = "eulogy"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 90, BLACK_DAMAGE = 90, PALE_DAMAGE = 40)

/obj/item/clothing/suit/armor/ego_gear/realization/death
	name = "death stare"
	desc = "Last words are for fools who haven’t said enough."
	icon_state = "death"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 90, PALE_DAMAGE = 40)

/obj/item/clothing/suit/armor/ego_gear/realization/crimson
	name = "crimson lust"
	desc = "They are always watching you."
	icon_state = "crimson"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/confessional
	name = "confessional"
	desc = "Come my child. Tell me your sins."
	icon_state = "confessional"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 100, BLACK_DAMAGE = 60, PALE_DAMAGE = 40)

/obj/item/clothing/suit/armor/ego_gear/realization/confessional/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/aimed/cross_spawn/CS = new
	var/datum/action/spell_action/ability/item/A = CS.action
	A.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/realization/universe
	name = "one with the universe"
	desc = "One with all, it all comes back to yourself."
	icon_state = "universe"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 90, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/mouth
	name = "mouth of god"
	desc = "And the mouth of god spoke: You will be punished."
	icon_state = "mouth"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/head
	name = "head of god"
	desc = "And the head of god spoke: You will be judged."
	icon_state = "head"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 90)

/obj/item/clothing/suit/armor/ego_gear/realization/eyes
	name = "eyes of god"
	desc = "And the eyes of god spoke: You will be saved."
	icon_state = "eyes"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 90, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/fear
	name = "passion of the fearless one"
	desc = "Man fears the darkness, and so he scrapes away at the edges of it with fire."
	icon_state = "fear"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 80, BLACK_DAMAGE = 80, PALE_DAMAGE = 20)
	flags_inv = null

/obj/item/clothing/suit/armor/ego_gear/realization/capitalism
	name = "capitalism"
	desc = "While the miser is merely a capitalist gone mad, the capitalist is a rational miser."
	icon_state = "capitalism"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 80, BLACK_DAMAGE = 70, PALE_DAMAGE = 40)

/obj/item/clothing/suit/armor/ego_gear/realization/laughter
	name = "laughter"
	desc = "I do not recognize them, I must not, lest I end up like them. \
		I silence my mind, I cannot help them now. I do not remember, I do not believe in what they did. \
		In my mediation, I slow my breathing, and recall everyone I've lost. \
		Do not attempt to look at them. You do not recognize them, move quickly, move on. \
		I laugh maniacally and then take a deep breath and touch my chest, expecting a heart to be beating. \
		Through the silence, I hear them, I see them. The faces of all my friends are with me laughing too. \
		He is here, I open my heart to the Smiling God."
	icon_state = "laughter"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 80, BLACK_DAMAGE = 90, PALE_DAMAGE = 20)
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR

/obj/item/clothing/suit/armor/ego_gear/realization/cruelty
	name = "wit of cruelty"
	desc = "In the face of pain there are no heroes."
	icon_state = "cruelty"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 60)
	flags_inv = HIDEJUMPSUIT|HIDEGLOVES|HIDESHOES
