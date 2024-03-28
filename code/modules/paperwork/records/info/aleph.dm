// The Silent Orchestra
/obj/item/paper/fluff/info/aleph/tso
	abno_type = /mob/living/simple_animal/hostile/abnormality/silentorchestra
	abno_code = "T-01-31"
	abno_info = list(
		"When the work result was Good, the Qliphoth Counter lowered.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"The music that is played by The Silent Orchestra when it escapes consists of 4 Movements. As the piece progresses, the employees listening will suffer WHITE damage and the size of the audible area of the music will expand.",
		"For each Movement, the weakness of The Silent Orchestra changed. The 1st Movement was Pale, while the 2nd Movement was Black. For the 3rd Movement it was White, and lastly, during the 4th Movement, only Red type attacks were effective. When the music reached the climax, The Silent Orchestra became immune to all forms of attack.")
	abno_breach_damage_type = "White"
	abno_breach_damage_count = "Moderate to High"
	abno_resistances = list(
		RED_DAMAGE = "Immune/Immune/Immune/Normal/Immune",
		WHITE_DAMAGE = "Immune/Immune/Normal/Immune/Immune",
		BLACK_DAMAGE = "Immune/Normal/Immune/Immune/Immune",
		PALE_DAMAGE = "Normal/Immune/Immune/Immune/Immune")

// Blue Star
/obj/item/paper/fluff/info/aleph/bluestar
	abno_type = /mob/living/simple_animal/hostile/abnormality/bluestar
	abno_code = "O-03-93"
	abno_info = list(
		"Agents with Temperance Level 3 or lower immediately threw themselves into Blue Star upon working with the Abnormality.",
		"When an Agent with Prudence Level 4 or lower completed their work, the Qliphoth Counter lowered.",
		"When more than 40 seconds of work time had taken place, the Qliphoth Counter lowered by 1, and the Agent who was working with Blue Star threw themself in.",
		"While Blue Star is outside of its containment, all sounds will be reduced to silence, with a low pitched tone emerging. The pitch will accompany a visually disruptive effect.",
		"While Blue Star is outside of its containment, all panicking employees in the facility will be sucked into the center of the Abnormality and vanish.")
	abno_breach_damage_type = "White"
	abno_breach_damage_count = "Very High"

// White Night
/obj/item/paper/fluff/info/aleph/whitenight
	abno_type = /mob/living/simple_animal/hostile/abnormality/white_night
	abno_code = "T-03-46"
	abno_info = list(
		"Once the Qliphoth Counter reaches 0, WhiteNight and His disciples shall advent again.",
		"When the work result was Good, the Qliphoth Counter increased with a high probablility; the physical and mental health of every employee in the facility were healed.",
		"When the work result was Bad, the Qliphoth Counter lowered.")
	abno_breach_damage_type = "Pale"
	abno_breach_damage_count = "High"

// Nothing There
/obj/item/paper/fluff/info/aleph/nothingthere
	abno_type = /mob/living/simple_animal/hostile/abnormality/nothing_there
	abno_code = "O-06-20"
	abno_info = list(
		"The lower the working employee’s Fortitude, the lower the success rate was and the less stable the work was.",
		"When an employee whose Justice was lower than Level 4 completed the work, the Qliphoth Counter decreased.",
		"When the work result was Bad, the employee was attacked and turned into Nothing There’s shell.",
		"When the Qliphoth Counter reached 0, Nothing There, taking the appearance of the dead employee, disappeared from its Containment Unit.")
	abno_breach_damage_count = "Extreme" // Mainly due to "goodbye" and "hello" spam
	abno_resistances = list(
		RED_DAMAGE = "Resistant/Immune/Immune",
		WHITE_DAMAGE = "Endured/Endured/Resistant",
		BLACK_DAMAGE = "Endured/Endured/Resistant",
		PALE_DAMAGE = "Weak/Normal/Endured")

// The Mountain of Smiling Bodies
/obj/item/paper/fluff/info/aleph/mountain
	abno_type = /mob/living/simple_animal/hostile/abnormality/mountain
	abno_code = "T-01-75"
	abno_info = list(
		"When an employee died or was critically injured while working with The Mountain of Smiling Bodies, the Qliphoth Counter decreased.",
		"When a wounded employee began work on The Mountain of Smiling Bodies, the Qliphoth Counter decreased.",
		"When the work result was Bad, the Qliphoth Counter decreased.",
		"After 2 employees died within the facility, the Qliphoth Counter decreased.",
		"While The Mountain of Smiling Bodies is escaping, it will show sensitive reactions to corpses. During suppression, ensure that no one dies due to the Abnormality; if casualties do happen, try to keep Mountain of Smiling Bodies away from the dead.",
		"If The Mountain of Smiling Bodies’s suppression could not be completed on the previous level, you must be very careful to prevent any death inside the section where Mountain of Smiling Bodies is located.",
		"After other entities spawned from The Mountain of Smiling Bodies’s main body while escaping, reducing its HP to 0 did not fully suppress it. The Mountain of Smiling Bodies will only be quelled by attacking the main body after continuously reducing its HP and defeating the other spawned entities.")

// Staining Rose
/obj/item/paper/fluff/info/aleph/rose
	abno_type = /mob/living/simple_animal/hostile/abnormality/staining_rose
	abno_code = "F-04-116"
	abno_info = list(
		"The first employee who works on Staining Rose will resonate with it and become the Chosen.",
		"If anyone other than the Chosen worked on Staining Rose, they became more vulnerable to damage until Staining Rose wilted.",
		"When an employee with Justice 4 or lower finished their work, Staining Rose seemed to reset its satisfaction. The employee became more vulnerable to damage until Staining Rose wilted.",
		"Every 15 minutes, the Qliphoth Counter lowered unless Staining Rose was worked on within the time period.",
		"When the Qliphoth Counter reached 0, Staining Rose shed its petals, and everyone in the facility became more vulnerable to damage.")

// Melting Love
/obj/item/paper/fluff/info/aleph/melty
	abno_type = /mob/living/simple_animal/hostile/abnormality/melting_love
	abno_code = "D-03-109"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"Melting Love gave a lump of slime to the first employee (D-03-109-1) who performed any work other \than Repression with it. The lump healed D-03-109-1’s SP and improved their Temperance. However, further observation is needed to determine how the lump’s effects change according to the state of Melting Love.",
		"When D-03-109-1 completed Repression Work, the Qliphoth Counter lowered.",
		"When D-03-109-1 completed work on Melting Love, and the work result was Good, the Qliphoth Counter increased by 1 with a low probability.",
		"The Qliphoth Counter dropped to 0 when D-03-109-1 died.",
		"NOTICE: D-03-109-1 <strong>does not</strong> appear to carry any infectious agents.")

// CENSORED
/obj/item/paper/fluff/info/aleph/censored
	abno_type = /mob/living/simple_animal/hostile/abnormality/censored
	abno_code = "O-03-89"
	abno_info = list(
		"The Abnormality’s Qliphoth Counter can be raised by 1 via a special work type. The employee performing it will never be seen again.",
		"Employees of Level 4 and lower immediately panicked when they encountered the Abnormality.",
		"When CENSORED escaped, employees of Level 3 and lower showed the same response.",
		"When an employee panicked during work, the Qliphoth Counter lowered.",
		"When the work result was Bad, the Qliphoth Counter lowered.")

// Titania
/obj/item/paper/fluff/info/aleph/titania
	abno_type = /mob/living/simple_animal/hostile/abnormality/titania
	abno_code = "F-01-130"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the employee completed worked on Titania for the first time since her last breach, the Qliphoth Counter lowered.",
		"When breaching, Titania designated a Level 5 employee as her \"Nemesis\". Titania then continually summoned hostile fairy scouts until her demise.",
		"When the Nemesis was attacked by Titania, Titania’s attacks had different properties.",
		"After the Nemesis was killed by Titania, Titania’s strength dramatically increased.",
		"When employees of Level 3 and lower were attacked by Titania, they were immediately obliterated.")
	abno_breach_damage_type = "Red/Pale"

// Lady out of Space
/obj/item/paper/fluff/info/aleph/space_lady
	abno_type = /mob/living/simple_animal/hostile/abnormality/space_lady
	abno_code = "O-01-131"
	abno_info = list(
		"Injuries sustained when working on Lady Out of Space consisted of an equal amount of BLACK and WHITE damage.",
		"When the work result was Neutral, the Qliphoth Counter decreased.",
		"When the work result was Bad, the Qliphoth Counter decreased by 2.",
		"When employees of Level 4 and lower completed their work, the Qliphoth Counter decreased. The Counter decreased again if the employee was Level 3 and lower.",
		"When employees of Level 2 and lower attempted work, they were consumed by Lady Out of Space and the Qliphoth Counter decreased.")
	abno_work_damage_type = "White & Black"
	abno_work_damage_count = "Extreme"
	abno_breach_damage_type = "White & Black"
	abno_breach_damage_count = "Extreme"

// The Jester of Nihil
/obj/item/paper/fluff/info/aleph/nihil
	abno_type = /mob/living/simple_animal/hostile/abnormality/nihil
	abno_code = "O-01-150"
	abno_info = list(
		"When the work result was Neutral, the Qliphoth Counter decreased at a normal probability.",
		"When the work result was Bad, the Qliphoth Counter decreased by 2.",
		"When work was performed, the employee took different types of damage depending on the type of work.",
		"When the Qlipthoth counter reached 0, the faciltiy was cloaked in choking darkness.",
		"The darkness seemed to rid employees of their attributes, and caused a massive qliphoth meltdown to occur.")
	abno_work_damage_type = "All"

// God of the Seasons
/obj/item/paper/fluff/info/aleph/seasons
	abno_type = /mob/living/simple_animal/hostile/abnormality/seasons
	abno_code = "M-06-35"
	abno_info = list(
		"The abnormality shifts between four states over time. The states are hereby referred to as \"Spring\", \"Summer\", \"Autumn\", and \"Winter\".",
		"When the abnormality first appeared in the facility, it appeared in a mostly harmless, diminutive state. At this stage, any work result causes a drop in Qliphoth counter.",
		"When the Qliphoth counter reached 0 for the first time, or the abnormality is left alone for too long, the abnormality revealed its true form. The maximum Qliphoth also lowered to 1.",
		"The employee took different types of damage from the abnormality depending on its state, both during work and during a breach.",
		"When the Qlipthoth counter reached 0, the faciltiy experienced unusual weather that persisted indoors.",
		"When the work result was bad, the Qliphoth counter decreased by one.")
	abno_work_rates = list(
			ABNORMALITY_WORK_INSTINCT = "High during \"Summer\" and Common during \"Spring\"",
			ABNORMALITY_WORK_INSIGHT = "High during \"Spring\" and Common during \"Winter\"",
			ABNORMALITY_WORK_ATTACHMENT = "High during \"Autumn\" and Common during \"Summer\"",
			ABNORMALITY_WORK_REPRESSION = "High during \"Winter\" and Common during \"Autumn\"")
	abno_work_damage_type = "White/Red/Black/Pale"
	abno_breach_damage_type = "White/Red/Black/Pale"
	abno_resistances = list(
		RED_DAMAGE = "Endured/Resistant/Endured/Weak",
		WHITE_DAMAGE = "Resistant/Normal/Normal/Normal",
		BLACK_DAMAGE = "Normal/Endured/Resistant/Endured",
		PALE_DAMAGE = "Weak/Weak/Weak/Resistant")

//Last Shot
/obj/item/paper/fluff/info/aleph/last_shot
	abno_type = /mob/living/simple_animal/hostile/abnormality/last_shot
	abno_code = "C-06-152"
	abno_info = list(
		"Employees with Temperance level 3 or below had their work chance increased dramatically.",
		"Employees with Temperance level 5 or above had their work chance reduced dramatically.",
		"Employees with Fortitude under level 5 received more work damage.",
		"Employees with Justice under level 5 received more work damage.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the Qliphtoh Counter reached 0, last shot bred flesh until it was destroyed in it's containment.")

// The Crying Children
/obj/item/paper/fluff/info/aleph/crying_children
	abno_type = /mob/living/simple_animal/hostile/abnormality/crying_children
	abno_code = "O-01-430" // Philip's Birthday April 30th
	abno_info = list(
		"When 2 employees died, the Qliphoth Counter decreased.",
		"When Attachment work was completed, the Qliphoth Counter increased.",
		"When the work result was Neutral, the employee has a chance to be cursed with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter decreased and the employee was cursed.",
		"Employees who were cursed regained their lost senses after a while.",
		"When the abnormality breached, it sets the whole facility ablaze over time. Reducing it's health seems to delay the process.",
		"When the abnormality split up into 3 children, all employees were cursed. Killing the children seems to lift said curse.",
		"When all of the children died, they unite again and become stronger.")

//Army in Black
/obj/item/paper/fluff/info/aleph/army
	abno_type = /mob/living/simple_animal/hostile/abnormality/army
	abno_code = "D-01-106"
	abno_info = list(
	"Army in Black can be ordered to protect an employee. However, it should be noted that the Qliphoth Counter lowered when the order was given.",
	"When Repression work was performed, the Qliphoth Counter lowered.",
	"The Qliphoth Counter lowered after every 2 employee deaths.",
	"When the work result was Bad, the Qliphoth Counter decreased.",
	"When an Abnormality was suppressed, the Qliphoth Counter raised.")

// Distorted Form
/obj/item/paper/fluff/info/aleph/distortedform
	abno_type = /mob/living/simple_animal/hostile/abnormality/distortedform
	abno_code = "O-06-38"
	abno_info = list(
		"WARNING: O-06-38 will periodically take on the appearance of another abnormality. The abnormality will reveal its true form when work is attempted.",
		"When an employee with Justice 4 or lower finished their work, or work result was a failure, O-06-38 let out a horrifying screech.",
		"Other abnormalities became agitated by the screech. The situation needed to be handled as a Qliphoth Meltdown.",
		"If agitated abnormalities were not worked on, multiple abnormalities breached simultaneously.",
		"When the work result was Good, the Qliphoth Counter increased by 1.",
		"When a Qliphoth Meltdown was ignored, the Qliphoth Counter decreased by 1.")
	abno_work_damage_type = "All"
	abno_breach_damage_type = "Random"

// Nobody Is
/obj/item/paper/fluff/info/aleph/nobodyis
	abno_type = /mob/living/simple_animal/hostile/abnormality/nobody_is
	abno_code = "O-06-180"
	abno_info = list(
		"The lower the working employee’s Prudence, the lower the success rate was and the less stable the work was.",
		"When an employee whose Justice was lower than Level 4 completed the work, the Qliphoth Counter decreased.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"An employee in the facility will be reflected upon the mirror on the face of Nobody Is.",
		"When the selected employee completed work, they were assimilated into the abnormality.")
	abno_breach_damage_count = "Extreme" // Once it transforms its over
	abno_resistances = list(
		RED_DAMAGE = "Endured/Endured/Resistant",
		WHITE_DAMAGE = "Endured/Endured/Resistant",
		BLACK_DAMAGE = "Resistant/Immune/Immune",
		PALE_DAMAGE = "Weak/Normal/Endured")
