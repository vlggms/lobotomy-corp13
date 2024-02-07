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
	hat = /obj/item/clothing/head/ego_hat/prophet_hat

/obj/item/clothing/head/ego_hat/prophet_hat
	name = "prophet"
	desc = "For this reason, rejoice, you heavens and you who dwell in them. Woe to the earth and the sea, because the devil has come down to you with great wrath, knowing that he has only a short time."
	icon_state = "prophet"

/obj/item/clothing/suit/armor/ego_gear/realization/maiden
	name = "blood maiden"
	desc = "Soaked in blood, and yet pure in heart."
	icon_state = "maiden"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 50, BLACK_DAMAGE = 80, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/wellcheers
	name = "wellcheers"
	desc = " I’ve found true happiness in cracking open a cold one after a hard day’s work, covered in sea water and sweat. \
	I’m at the port now but we gotta take off soon to catch some more shrimp. Never know what your future holds, bros."
	icon_state = "wellcheers"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 70, BLACK_DAMAGE = 70, PALE_DAMAGE = 40)
	realized_ability = /obj/effect/proc_holder/ability/wellcheers
	hat = /obj/item/clothing/head/ego_hat/wellcheers_hat

/obj/item/clothing/head/ego_hat/wellcheers_hat
	name = "wellcheers"
	desc = "You’re really missing out on life if you’ve never tried shrimp."
	icon_state = "wellcheers"

/obj/item/clothing/suit/armor/ego_gear/realization/comatose
	name = "comatose"
	desc = "...ZZZ..."
	icon_state = "comatose"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 90, BLACK_DAMAGE = 50, PALE_DAMAGE = 40)
	realized_ability = /obj/effect/proc_holder/ability/comatose

/obj/item/clothing/suit/armor/ego_gear/realization/brokencrown
	name = "broken crown"
	desc = "Shall we get to work? All we need to do is what we’ve always done."
	icon_state = "brokencrown"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 90, BLACK_DAMAGE = 40, PALE_DAMAGE = 40)
	realized_ability = /obj/effect/proc_holder/ability/brokencrown
	hat = /obj/item/clothing/head/ego_hat/brokencrown

/obj/item/clothing/head/ego_hat/brokencrown
	name = "broken crown"
	desc = "One fell down and the rest came tumbling after."
	icon_state = "brokencrown"

/* TETH Realizations */

/obj/item/clothing/suit/armor/ego_gear/realization/mouth
	name = "mouth of god"
	desc = "And the mouth of god spoke: You will be punished."
	icon_state = "mouth"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)
	realized_ability = /obj/effect/proc_holder/ability/punishment

/obj/item/clothing/suit/armor/ego_gear/realization/universe
	name = "one with the universe"
	desc = "One with all, it all comes back to yourself."
	icon_state = "universe"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 90, PALE_DAMAGE = 60)
	realized_ability = /obj/effect/proc_holder/ability/universe_song
	hat = /obj/item/clothing/head/ego_hat/universe_hat

/obj/item/clothing/head/ego_hat/universe_hat
	name = "one with the universe"
	desc = "See. All. Together. Know. Us."
	icon_state = "universe"
	flags_inv = HIDEMASK | HIDEHAIR

/obj/item/clothing/suit/armor/ego_gear/realization/death
	name = "death stare"
	desc = "Last words are for fools who haven’t said enough."
	icon_state = "death"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 90, PALE_DAMAGE = 40)
	realized_ability = /obj/effect/proc_holder/ability/aimed/gleaming_eyes

/obj/item/clothing/suit/armor/ego_gear/realization/fear
	name = "passion of the fearless one"
	desc = "Man fears the darkness, and so he scrapes away at the edges of it with fire.\
	Grants various buffs to life of a daredevil when equipped."
	icon_state = "fear"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 80, BLACK_DAMAGE = 80, PALE_DAMAGE = 20)
	flags_inv = null

/obj/item/clothing/suit/armor/ego_gear/realization/exsanguination
	name = "exsaungination"
	desc = "It keeps your suit relatively clean."
	icon_state = "exsanguination"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 90, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/ember_matchlight
	name = "ember matchlight"
	desc = "If I must perish, then I'll make you meet the same fate."
	icon_state = "ember_matchlight"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 60)
	realized_ability = /obj/effect/proc_holder/ability/fire_explosion

/obj/item/clothing/suit/armor/ego_gear/realization/sakura_bloom
	name = "sakura bloom"
	desc = "The forest will never return to its original state once it dies. Cherish the rain."
	icon_state = "sakura_bloom"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 80, BLACK_DAMAGE = 50, PALE_DAMAGE = 60)
	realized_ability = /obj/effect/proc_holder/ability/petal_blizzard
	hat = /obj/item/clothing/head/ego_hat/sakura_hat

/obj/item/clothing/head/ego_hat/sakura_hat
	name = "sakura bloom"
	desc = "Spring is coming."
	worn_icon = 'icons/mob/clothing/big_hat.dmi'
	icon_state = "sakura"

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

/obj/item/clothing/suit/armor/ego_gear/realization/ourgalaxy
	name = "our galaxy"
	desc = "Walk this night sky with me. The galaxy dotted with numerous hopes. We'll count the stars and never be alone."
	icon_state = "ourgalaxy"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 80, BLACK_DAMAGE = 80, PALE_DAMAGE = 60)
	realized_ability = /obj/effect/proc_holder/ability/galaxy_gift

/obj/item/clothing/suit/armor/ego_gear/realization/forever
	name = "together forever"
	desc = "I would move Heaven and Earth to be together forever with you."
	icon_state = "forever"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 90, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/wisdom
	name = "endless wisdom"
	desc = "Poor stuffing of straw. I'll give you the wisdom to ponder over anything."
	icon_state = "wisdom"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 90, BLACK_DAMAGE = 40, PALE_DAMAGE = 60)
	flags_inv = HIDESHOES
	hat = /obj/item/clothing/head/ego_hat/wisdom_hat

/obj/item/clothing/head/ego_hat/wisdom_hat
	name = "endless wisdom"
	desc = "I was left with nothing, nothing but empty brains and rotting bodies."
	icon_state = "wisdom"

/obj/item/clothing/suit/armor/ego_gear/realization/empathy
	name = "boundless empathy"
	desc = "Tin-cold woodsman. I'll give you the heart to forgive and love anyone."
	icon_state = "empathy"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 60, BLACK_DAMAGE = 70, PALE_DAMAGE = 40)
	flags_inv = HIDEGLOVES|HIDESHOES

/obj/item/clothing/suit/armor/ego_gear/realization/valor
	name = "unbroken valor"
	desc = "Cowardly kitten, I'll give you the courage to stand up to anything and everything."
	icon_state = "valor"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 60, PALE_DAMAGE = 90)

/obj/item/clothing/suit/armor/ego_gear/realization/home //This name would SO much easier if we didnt aleady USE HOMING INSTINCT AHHHHHHHHHHHHHHHHHHH
	name = "forever home"
	desc = "Last of all, road that is lost. I will send you home."
	icon_state = "home"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 60, BLACK_DAMAGE = 90, PALE_DAMAGE = 70)
	flags_inv = HIDEGLOVES|HIDESHOES
	realized_ability = /obj/effect/proc_holder/ability/aimed/house_spawn

/obj/item/clothing/suit/armor/ego_gear/realization/dimension_ripper
	name = "dimension ripper"
	desc = "Lost and abandoned, tossed out like trash, having no place left in the City."
	icon_state = "dimension_ripper"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 50)
	realized_ability = /obj/effect/proc_holder/ability/rip_space

/* WAW Realizations */

/obj/item/clothing/suit/armor/ego_gear/realization/goldexperience
	name = "gold experience"
	desc = "A jacket made of gold is hardly light. But it shines like the sun."
	icon_state = "gold_experience"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 60, PALE_DAMAGE = 70)
	realized_ability = /obj/effect/proc_holder/ability/road_of_gold

/obj/item/clothing/suit/armor/ego_gear/realization/quenchedblood
	name = "quenched with blood"
	desc = "A suit of armor, forged with tears and quenched in blood. Justice will prevail."
	icon_state = "quenchedblood"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 80, BLACK_DAMAGE = 50, PALE_DAMAGE = 80)
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDEGLOVES
	realized_ability = /obj/effect/proc_holder/ability/aimed/despair_swords

/obj/item/clothing/suit/armor/ego_gear/realization/lovejustice
	name = "love and justice"
	desc = "If my duty is to defeat and reform evil, can I reform my evil self as well?"
	icon_state = "lovejustice"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 60, BLACK_DAMAGE = 90, PALE_DAMAGE = 50)
	flags_inv = HIDEGLOVES
	realized_ability = /obj/effect/proc_holder/ability/aimed/arcana_slave

/obj/item/clothing/suit/armor/ego_gear/realization/woundedcourage
	name = "wounded courage"
	desc = "'Tis better to have loved and lost than never to have loved at all."
	icon_state = "woundedcourage"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 60, BLACK_DAMAGE = 70, PALE_DAMAGE = 60)
	flags_inv = HIDEJUMPSUIT | HIDEGLOVES | HIDESHOES
	realized_ability = /obj/effect/proc_holder/ability/justice_and_balance
	hat = /obj/item/clothing/head/ego_hat/woundedcourage_hat

/obj/item/clothing/head/ego_hat/woundedcourage_hat
	name = "wounded courage"
	desc = "An excuse to overlook your own misdeeds."
	icon_state = "woundedcourage"
	flags_inv = HIDEMASK | HIDEEYES

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
	realized_ability = /obj/effect/proc_holder/ability/lamp

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The wearer can sense it whenever an abnormality breaches.</span>"

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(item_action_slot_check(slot, user))
		RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/dropped(mob/user)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return ..()

/obj/item/clothing/suit/armor/ego_gear/realization/eyes/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(!ishuman(loc))
		return
	if(loc.z != abno.z)
		return
	addtimer(CALLBACK(src, PROC_REF(NotifyEscape), loc, abno), rand(1 SECONDS, 3 SECONDS))

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

/obj/item/clothing/suit/armor/ego_gear/realization/bell_tolls
	name = "for whom the bell tolls"
	desc = "I suppose if a man has something once, always something of it remains."
	icon_state = "thirteen"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 90)

/obj/item/clothing/suit/armor/ego_gear/realization/capitalism
	name = "capitalism"
	desc = "While the miser is merely a capitalist gone mad, the capitalist is a rational miser."
	icon_state = "capitalism"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 80, BLACK_DAMAGE = 70, PALE_DAMAGE = 40)
	realized_ability = /obj/effect/proc_holder/ability/shrimp

/obj/item/clothing/suit/armor/ego_gear/realization/duality_yang
	name = "duality of harmony"
	desc = "When good and evil meet discord and assonance will be quelled."
	icon_state = "duality_yang"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 90, BLACK_DAMAGE = 40, PALE_DAMAGE = 90)
	realized_ability = /obj/effect/proc_holder/ability/tranquility

/obj/item/clothing/suit/armor/ego_gear/realization/duality_yin
	name = "harmony of duality"
	desc = "All that isn't shall become all that is."
	icon_state = "duality_yin"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 90, PALE_DAMAGE = 40)
	realized_ability = /obj/effect/proc_holder/ability/aimed/yin_laser

/obj/item/clothing/suit/armor/ego_gear/realization/repentance
	name = "repentance"
	desc = "If you pray hard enough, perhaps god will answer it?"
	icon_state = "repentance"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 90)
	realized_ability = /obj/effect/proc_holder/ability/prayer

/obj/item/clothing/suit/armor/ego_gear/realization/nest
	name = "living nest"
	desc = "Grow eternally, let our nest reach the horizon!"
	icon_state = "nest"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 50)
	realized_ability = /obj/effect/proc_holder/ability/nest
	var/CanSpawn = FALSE

/obj/item/clothing/suit/armor/ego_gear/realization/nest/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		CanSpawn = TRUE
		addtimer(CALLBACK(src, PROC_REF(Spawn),user), 10 SECONDS)

/obj/item/clothing/suit/armor/ego_gear/realization/nest/dropped(mob/user)
	CanSpawn = FALSE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/realization/nest/proc/Reset(mob/user)
	if(!CanSpawn)
		return
	Spawn(user)

/obj/item/clothing/suit/armor/ego_gear/realization/nest/proc/Spawn(mob/user)
	if(!CanSpawn)
		return
	addtimer(CALLBACK(src, PROC_REF(Reset),user), 10 SECONDS)
	playsound(get_turf(user), 'sound/misc/moist_impact.ogg', 30, 1)
	var/mob/living/simple_animal/hostile/naked_nest_serpent_friend/W = new(get_turf(user))
	W.origin_nest = user

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

/obj/item/clothing/suit/armor/ego_gear/realization/shell
	name = "shell"
	desc = "Armor of humans, for humans, by humans. Is it as 'human' as you?"
	icon_state = "shell"
	realized_ability = /obj/effect/proc_holder/ability/goodbye
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 60, BLACK_DAMAGE = 50, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/laughter
	name = "laughter"
	desc = "I do not recognize them, I must not, lest I end up like them. \
			Through the silence, I hear them, I see them. The faces of all my friends are with me laughing too."
	icon_state = "laughter"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 60, BLACK_DAMAGE = 90, PALE_DAMAGE = 60)
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	realized_ability = /obj/effect/proc_holder/ability/screach

/obj/item/clothing/suit/armor/ego_gear/realization/fallencolors
	name = "fallen color"
	desc = "Where does one go after falling into a black hole?"
	icon_state = "fallencolors"
	realized_ability = /obj/effect/proc_holder/ability/aimed/blackhole
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 90, BLACK_DAMAGE = 90, PALE_DAMAGE = 50)
	var/canSUCC = TRUE

/obj/item/clothing/suit/armor/ego_gear/realization/fallencolors/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, PROC_REF(OnDamaged))

/obj/item/clothing/suit/armor/ego_gear/realization/fallencolors/dropped(mob/user)
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	return ..()

/obj/item/clothing/suit/armor/ego_gear/realization/fallencolors/proc/Reset()
	canSUCC = TRUE

/obj/item/clothing/suit/armor/ego_gear/realization/fallencolors/proc/OnDamaged(mob/living/carbon/human/user)
	//goonchem_vortex(get_turf(src), 1, 3)
	if(!canSUCC)
		return
	if(user.is_working)
		return
	canSUCC = FALSE
	addtimer(CALLBACK(src, PROC_REF(Reset)), 2 SECONDS)
	for(var/turf/T in view(3, user))
		new /obj/effect/temp_visual/revenant(T)
		for(var/mob/living/L in T)
			if(user.faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, get_turf(src))))
			L.throw_at(throw_target, 1, 1)
			L.apply_damage(5, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)


/* Effloresced (Personal) E.G.O */
/obj/item/clothing/suit/armor/ego_gear/realization/farmwatch
	name = "farmwatch"
	desc = "Haha. You're right, the calf doesn't recognize me."
	icon_state = "farmwatch"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 60)
	hat = /obj/item/clothing/head/ego_hat/farmwatch_hat

/obj/item/clothing/head/ego_hat/farmwatch_hat
	name = "farmwatch"
	desc = "I'll gather a team again... hire another secretary... There'll be a lot to do."
	icon_state = "farmwatch"

/obj/item/clothing/suit/armor/ego_gear/realization/spicebush
	name = "spicebush"
	desc = "I've always wished to be a bud. Soon to bloom, bearing a scent within."
	icon_state = "spicebush"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 90, BLACK_DAMAGE = 70, PALE_DAMAGE = 60)

/obj/item/clothing/suit/armor/ego_gear/realization/desperation
	name = "Scorching Desperation"
	desc = "Those feelings only become more dull over time."
	icon_state = "desperation"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 40, BLACK_DAMAGE = 60, PALE_DAMAGE = 80)
	realized_ability = /obj/effect/proc_holder/ability/overheat
