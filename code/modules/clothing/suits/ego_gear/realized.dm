/obj/item/clothing/suit/armor/ego_gear/realization // 260. You have to be an EX level agent to get these.
	name = "unknown realized ego"
	desc = "Notify coders immediately!"
	icon = 'icons/obj/clothing/ego_gear/realization.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/realized.dmi'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	/// Type of realized ability, if any
	var/obj/effect/proc_holder/ability/realized_ability = null

/obj/item/clothing/suit/armor/ego_gear/realization/Initialize()
	. = ..()
	if(isnull(realized_ability))
		return
	var/obj/effect/proc_holder/ability/AS = new realized_ability
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/realization/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_OCLOTHING) // Abilities are only granted when worn properly
		return TRUE

/* ZAYIN Realizations */

/obj/item/clothing/suit/armor/ego_gear/realization/confessional
	name = "confessional"
	desc = "Come my child. Tell me your sins."
	icon_state = "confessional"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 100, BLACK_DAMAGE = 60, PALE_DAMAGE = 40)
	realized_ability = /obj/effect/proc_holder/ability/aimed/cross_spawn

/obj/item/clothing/suit/armor/ego_gear/realization/prophet
	name = "prophet"
	desc = "And they have conquered him by the blood of the Lamb and by the word of their testimony, for they loved not their lives even unto death."
	icon_state = "prophet"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 80, BLACK_DAMAGE = 80, PALE_DAMAGE = 60)
	flags_inv = HIDEJUMPSUIT|HIDEGLOVES|HIDESHOES

/* TETH Realizations */

/obj/item/clothing/suit/armor/ego_gear/realization/mouth
	name = "mouth of god"
	desc = "And the mouth of god spoke: You will be punished."
	icon_state = "mouth"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/universe
	name = "one with the universe"
	desc = "One with all, it all comes back to yourself."
	icon_state = "universe"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 90, PALE_DAMAGE = 60)
	realized_ability = /obj/effect/proc_holder/ability/universe_song

/obj/item/clothing/suit/armor/ego_gear/realization/death
	name = "death stare"
	desc = "Last words are for fools who haven’t said enough."
	icon_state = "death"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 90, PALE_DAMAGE = 40)

/obj/item/clothing/suit/armor/ego_gear/realization/fear
	name = "passion of the fearless one"
	desc = "Man fears the darkness, and so he scrapes away at the edges of it with fire."
	icon_state = "fear"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 80, BLACK_DAMAGE = 80, PALE_DAMAGE = 20)
	flags_inv = null

/obj/item/clothing/suit/armor/ego_gear/realization/exsanguination
	name = "exsaungination"
	desc = "It keeps your suit relatively clean."
	icon_state = "exsanguination"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 90, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/* HE Realizations */

/obj/item/clothing/suit/armor/ego_gear/realization/grinder
	name = "grinder MK52"
	desc = "The blades are not just decorative."
	icon_state = "grinder"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 50)
	realized_ability = /obj/effect/proc_holder/ability/aimed/helper_dash

/obj/item/clothing/suit/armor/ego_gear/realization/bigiron
	name = "big iron"
	desc = "A hefty silk coat with a blue smock."
	icon_state = "big_iron"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 70, BLACK_DAMAGE = 70, PALE_DAMAGE = 50)

/obj/item/clothing/suit/armor/ego_gear/realization/eulogy
	name = "solemn eulogy"
	desc = "Death is not extinguishing the light, it is putting out the lamp as dawn has come."
	icon_state = "eulogy"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 90, BLACK_DAMAGE = 90, PALE_DAMAGE = 40)

/* WAW Realizations */

/obj/item/clothing/suit/armor/ego_gear/realization/goldexperience
	name = "gold experience"
	desc = "A jacket made of gold is hardly light. But it shines like the sun."
	icon_state = "gold_experience"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 60, PALE_DAMAGE = 70)

/obj/item/clothing/suit/armor/ego_gear/realization/crimson
	name = "crimson lust"
	desc = "They are always watching you."
	icon_state = "crimson"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/eyes
	name = "eyes of god"
	desc = "And the eyes of god spoke: You will be saved."
	icon_state = "eyes"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 90, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The wearer can sense it whenever an abnormality breaches.</span>"

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(item_action_slot_check(slot, user))
		RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, .proc/OnAbnoBreach)

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/dropped(mob/user)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return ..()

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(!ishuman(loc))
		return
	if(loc.z != abno.z)
		return
	addtimer(CALLBACK(src, .proc/NotifyEscape, loc, abno), rand(1 SECONDS, 3 SECONDS))

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/proc/NotifyEscape(mob/living/carbon/human/user, mob/living/simple_animal/hostile/abnormality/abno)
	if(QDELETED(abno) || abno.stat == DEAD || loc != user)
		return
	to_chat(user, "<span class='warning'>You can sense the escape of [abno]...</span>")
	playsound(get_turf(user), 'sound/abnormalities/bigbird/hypnosis.ogg', 25, 1, -4)
	var/turf/start_turf = get_turf(user)
	var/turf/last_turf = get_ranged_target_turf_direct(start_turf, abno, 5)
	var/list/navline = getline(start_turf, last_turf)
	for(var/turf/T in navline)
		new /obj/effect/temp_visual/cult/turf/floor(T)

/obj/item/clothing/suit/armor/ego_gear/realization/cruelty
	name = "wit of cruelty"
	desc = "In the face of pain there are no heroes."
	icon_state = "cruelty"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 60)
	flags_inv = HIDEJUMPSUIT|HIDEGLOVES|HIDESHOES

/obj/item/clothing/suit/armor/ego_gear/realization/capitalism
	name = "capitalism"
	desc = "While the miser is merely a capitalist gone mad, the capitalist is a rational miser."
	icon_state = "capitalism"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 80, BLACK_DAMAGE = 70, PALE_DAMAGE = 40)

/* ALEPH Realizations */

/obj/item/clothing/suit/armor/ego_gear/realization/alcoda
	name = "al coda"
	desc = "Harmonizes well."
	icon_state = "coda"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 100, BLACK_DAMAGE = 70, PALE_DAMAGE = 20)

/obj/item/clothing/suit/armor/ego_gear/realization/head
	name = "head of god"
	desc = "And the head of god spoke: You will be judged."
	icon_state = "head"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 90)
	realized_ability = /obj/effect/proc_holder/ability/judgement

/obj/item/clothing/suit/armor/ego_gear/realization/laughter
	name = "laughter"
	desc = "I do not recognize them, I must not, lest I end up like them. \
			Through the silence, I hear them, I see them. The faces of all my friends are with me laughing too."
	icon_state = "laughter"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 80, BLACK_DAMAGE = 90, PALE_DAMAGE = 20)
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
