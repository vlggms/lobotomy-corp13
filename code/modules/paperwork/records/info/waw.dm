//Warden
/obj/item/paper/fluff/info/waw/warden
	abno_type = /mob/living/simple_animal/hostile/abnormality/warden
	abno_code = "T-01-114"
	abno_info = list(
		"When employees with both Justice Level 3 or lower and Fortitude Level 3 or lower finished working, the Qliphoth Counter lowered.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When The Warden was escaping and killed an employee, it dragged their soul under its dress and began to move faster.",
		"The Warden was unaffected by any projectiles hitting it.",
		"NOTICE: The Warden is most effectively suppressed by groups.")

//Bee
/obj/item/paper/fluff/info/waw/queenbee
	abno_type = /mob/living/simple_animal/hostile/abnormality/queen_bee
	abno_code = "T-04-50"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered with a high probability.",
		"When the Qliphoth Counter reached 0, Queen Bee emitted spores throughout a large area.",
		"Upon observing the Abnormality, it has been confirmed that the spores attached to employees for a certain amount of time, and inflicted RED damage over that period.",
		"The spores were cured if the infected had constant medical attention and reached a healthy state.",
		"When the HP of an employee infested with spores had depleted, a giant drone burst out of their body. The drone indiscriminately attacked nearby employees. From the corpses of attacked employees, more drones emerged.")

//Jbird
/obj/item/paper/fluff/info/waw/jbird
	abno_type = /mob/living/simple_animal/hostile/abnormality/judgement_bird
	abno_code = "O-02-62"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered with a high probability.")
	abno_breach_damage_type = "Pale"
	abno_breach_damage_count = "Very High"

//Bbird
/obj/item/paper/fluff/info/waw/bbird
	abno_type = /mob/living/simple_animal/hostile/abnormality/big_bird
	abno_code = "O-02-40"
	abno_info = list(
		"After an employee died within the facility, the Qliphoth Counter decreased.",
		"When the work result was Bad, the Qliphoth Counter decreased.",
		"When the work result was Good, the Qliphoth Counter increased.",
		"Employees who are near Big Bird may become enchanted whenever Big Bird swings its lamp.")
	abno_breach_damage_type = "Instant Death"
	abno_breach_damage_count = "N/A"

//KOD
/obj/item/paper/fluff/info/waw/kod
	abno_type = /mob/living/simple_animal/hostile/abnormality/despair_knight
	abno_code = "O-01-73"
	abno_info = list(
		"The first employee who completes their Attachment Work with a Good result will receive The Knight of Despair’s blessing. (From then on, the employee will be referred to as O-01-73-1).",
		"Thanks to the blessing, RED, WHITE, and BLACK damage dealt to O-01-73-1 was halved. However, PALE damage was doubled.",
		"The blessing caused O-01-73-1 to lose most of their competence when it comes to working on abnormalities.",
		"The Knight of Despair’s blessing dissipated when O-01-73-1 died or panicked. After the blessing was gone, a new employee could receive it.",
		"When the Qliphoth Counter reached 0, The Knight of Despair was impaled with a sword.",
		"When O-01-73-1 died or panicked, or when a total of three swords impaled the abnormality, The Knight of Despair escaped from its Containment Unit.")
	abno_can_breach = TRUE
	abno_breach_damage_type = "Pale"
	abno_breach_damage_count = "Very High"

//QOH
/obj/item/paper/fluff/info/waw/qoh
	abno_type = /mob/living/simple_animal/hostile/abnormality/hatred_queen
	abno_code = "O-01-04"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When 3 Qliphoth Meltdowns occurred in the facility without the death of an employee, the Qliphoth Counter lowered.",
		"After 4 employees died within the facility while the Qliphoth Counter was at its maximum, The Queen of Hatred voluntarily helped with Abnormality suppression. However, if 50% of our employees die while help is provided, the state of the Abnormality will change and will need to be suppressed immediately.",
		"The Queen of Hatred’s status changed when her Qliphoth Counter became 1. The work success rate was low when in said status. This status has been designated as \"Hysteric\" due to her anxiety and compulsive disorders.",
		"When she was Hysteric, generating 16+ PE-Boxes raised her Qliphoth Counter.",
		"When she was Hysteric, generating 15 or fewer PE-Boxes lowered her Qliphoth Counter.")
	abno_breach_damage_type = "Black"
	abno_breach_damage_count = "High"

//General Bee
/obj/item/paper/fluff/info/waw/generalbee
	abno_type = /mob/living/simple_animal/hostile/abnormality/general_b
	abno_code = "T-01-118"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered with a high probability.",
		"When the Qliphoth Counter reached 0, General Bee dispatched a squad of soldiers to the facility.",
		"WARNING: Do not let Queen Bee spores come in contact with General Bee.")
	abno_can_breach = TRUE
	abno_breach_damage_type = "Red & Black"
	abno_breach_damage_count = "High"

//Shrimp
/obj/item/paper/fluff/info/waw/shrimpexec
	abno_type = /mob/living/simple_animal/hostile/abnormality/shrimp_exec
	abno_code = "O-02-119"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the Qliphoth Counter reached 0, a shrimp strike force arrived at the main room of a department.",
		"After an employee completed their work, Shrimp Association Executive requested an idea or service.",
		"The abnormality repeated its request when approached by an employee.",
		"Observations have concluded that each request corresponded to a specific work type. Performing this work type will result in significantly increased work success rate.",
		"When the work result was Good, Shrimp Association Executive ordered shrimp-themed merchandise for the employee. Possible items included:<br>\
		<ol type=1>\
			<li>\"Shrimp Corporation\" brand firearms</li>\
			<li>Shrimp in a grenade</li>\
			<li>A can of Wellcheers-brand soda</li>\
		</ol>")

//SnowWhitesApple
/obj/item/paper/fluff/info/waw/snowwhitesapple
	abno_type = /mob/living/simple_animal/hostile/abnormality/snow_whites_apple
	abno_code = "F-04-42"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered with a high probability.",
		"When Snow White’s Apple escaped from its containment, it began to spread its roots and branches along the ground of the area it was in.",
		"The bitter flora produced by Snow White’s Apple becomes dormant when not in the presence of Snow White’s Apple.",
		"Snow White’s Apple can only attack through its roots and branches. It is suggested employees avoid traversing extentions of the Abnormality when in combat.")
	abno_breach_damage_type = "Black"
	abno_breach_damage_count = "High"

//Express Train to Hell
/obj/item/paper/fluff/info/waw/express
	abno_type = /mob/living/simple_animal/hostile/abnormality/express_train
	abno_code = "T-09-86"
	abno_info = list(
		"Every minute, a light of the ticket booth will illuminate and the Qliphoth Counter will decrease.",
		"When a work process began with lights on, all lights turned off and the work success rate increased.",
		"When an employee performed work with 1 light on, the employee recovered HP and SP. More HP and SP were recovered when 2 lights were on.",
		"When an employee performed work with 3 lights on, nearby employees recovered HP and SP.",
		"When an employee performed work with 4 lights on, all employees in the facility recovered HP and SP.",
		"If 1 minute passes while all 4 lights are illuminated, the train will travel through the facility on a horizontal path, dealing massive BLACK damage to everything it impacts.")

//Silence
/obj/item/paper/fluff/info/waw/silence
	abno_type = /mob/living/simple_animal/hostile/abnormality/silence
	abno_code = "O-04-65"
	abno_info = list(
		"Every 13 minutes, the bell tolled.",
		"When the work result was Good, the abnormality was satisfied with a high probability.",
		"When the work result was Normal, the abnormality was satisfied with a medium probability.",
		"If neither of the above conditions were fulfilled between the bells tolling, every employee took massive PALE damage.")

//The Dreaming Current
/obj/item/paper/fluff/info/waw/current
	abno_type = /mob/living/simple_animal/hostile/abnormality/dreaming_current
	abno_code = "T-02-71"
	abno_info = list(
		"When an employee panicked during work, the Qliphoth Counter lowered.",
		"When an employee with Temperance Level 1 finished their work, the Qliphoth Counter lowered.",
		"Upon breaching, The Dreaming Current charged through sections of the facility and dealt massive RED damage to anything in its path.")
	abno_breach_damage_type = "Red"
	abno_breach_damage_count = "Extreme"

//Yang
/obj/item/paper/fluff/info/waw/yang
	abno_type = /mob/living/simple_animal/hostile/abnormality/yang
	abno_code = "O-05-103"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the work took longer than 30 seconds, O-05-102's Qliphoth Counter lowered.",
		"When the Qliphoth Counter reached 0, Yang assisted in Abnormality suppression and healed the SP of nearby employees.",
		"When struck, Yang's attacker took an equal amount of White Damage.",
		"WARNING: Upon Yang’s death, immediately evacuate the area surrounding Yang's corpse.",
		"WARNING: When Yang breached while O-05-102 was in the facility, O-05-102 breached and tried to meet with Yang.",
		"WARNING: Both Yang and O-05-102 must be suppressed at the same time or they will revive and continue their journey.",
		"When Yang and O-05-102 met, all that was became all which wasn't.",
		"When Yang and O-05-102 are in the facility together, both their work rates and maximum PE improved.")
	abno_breach_damage_type = "White"
	abno_breach_damage_count = "High"

//Yin
/obj/item/paper/fluff/info/waw/yin
	abno_type = /mob/living/simple_animal/hostile/abnormality/yin
	abno_code = "O-05-102"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the work took longer than 30 seconds, O-05-103's Qliphoth Counter lowered.",
		"When the Qliphoth Counter reached 0, Yin roamed the facility, dealing Black Damage to nearby employees.",
		"WARNING: When Yin breached while O-05-103 was in the facility, O-05-103 breached and tried to meet with Yin.",
		"WARNING: Both Yin and O-05-103 must be suppressed at the same time or they will revive and continue their journey.",
		"When Yin and O-05-103 met, all that was not became all that was.",
		"When Yin and O-05-103 are in the facility together, both their work rates and maximum PE improved.")

//Alriune
/obj/item/paper/fluff/info/waw/alriune
	abno_type = /mob/living/simple_animal/hostile/abnormality/alriune
	abno_code = "T-04-53"
	abno_info = list(
		"When the work result was Good, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"Any employee who panicked from Alriune’s attacks died insantly.")
	abno_breach_damage_type = "White"
	abno_breach_damage_count = "Extreme"

//Naked Nest
/obj/item/paper/fluff/info/waw/nakednest
	abno_type = /mob/living/simple_animal/hostile/abnormality/naked_nest
	abno_code = "O-02-74"
	abno_info = list(
		"Observations have concluded that The Naked Nest and its variants harbor serpents capable of infesting humans. These creatures have been given the designation O-02-74-1.",
		"Employees with low HP are more susceptible to infestation by O-02-74-1. In particular, taking higher damage during work raises the probability of infestation.",
		"Surgical removal of an incomplete O-02-74 resulted in the O-02-74-1 ejecting itself from the host.",
		"Getting a Good work result prevented infestation from occurring, and a single-use cure was extracted.",
		"Some employees suffering from infestation showed the following symptoms over time:<br>\
		<ol type=1>\
			<li>Green skin and a damaged nervous system</li>\
			<li>Drastically reduced movement speed</li>\
		</ol>\
		If either of these symptoms is seen on any employee, handle them immediately.",
		"When an employee, who was suffering from the aforementioned symptoms, was left alone for 4 minutes, they changed into a form akin to The Naked Nest. (O-02-74-2).",
		"Instances of O-02-74-2 produced O-02-74-1 with the same traits as those from The Naked Nest.",
		"NOTICE: Corpses of O-02-74-1 hosts must be incinerated or destroyed to prevent transformation into O-02-74-2.",
		"NOTICE: O-02-74-1 have shown extreme aversion to cold temperatures and will attempt to flee to warmer environments.")
	abno_can_breach = TRUE
	abno_breach_damage_type = "Red" // Minions do that
	abno_breach_damage_count = "Moderate"

//King of Greed
/obj/item/paper/fluff/info/waw/greedking
	abno_type = /mob/living/simple_animal/hostile/abnormality/greed_king
	abno_code = "O-01-64"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a low probability.",
		"When the work result was Bad, the Qliphoth Counter lowered with a high probability.",
		"The King of Greed's behavioral pattern is to engulf anything that lies in her path when escaping. When suppressing her, please pay attention to which direction the Abnormality is moving.")
	abno_breach_damage_type = "Red"
	abno_breach_damage_count = "Extreme"

//Ebony queen's apple
/obj/item/paper/fluff/info/waw/ebony_queen
	abno_type = /mob/living/simple_animal/hostile/abnormality/ebony_queen
	abno_code = "F-04-141"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered with a high probability.",
		"Ebony Queen’s Apple primarily attacks through her roots. Employees should avoid standing on extentions of the Abnormality during suppressions.")
	abno_breach_damage_type = "Black"
	abno_breach_damage_count = "Very High"

//The Firebird
/obj/item/paper/fluff/info/waw/fire_bird
	abno_type = /mob/living/simple_animal/hostile/abnormality/fire_bird
	abno_code = "O-02-101"
	abno_info = list(
		"When the work result was Good, the Qliphoth Counter lowered.",
		"When the work result was Normal, the Qliphoth Counter lowered with a low probability. Furthermore, the lower the Qliphoth Counter, the more damage Agents take while working with The Firebird.",
		"When the work result was Bad, the Qliphoth Counter increased.",
		"The Firebird granted light to <name> who worked with it when the Qliphoth Counter was 1. The agent’s HP and SP were recovered, and healed over time for a while. When an Agent had less than 20% of their max HP remaining after completing the work process, The Firebird granted the same light.",
		"After escaping, The Firebird eventually returned to its Containment Unit after a short while. The Firebird only displayed aggression after it was damaged, and the employee whose HP or SP reached 0 from its attacks died. When The Firebird was attacked, the eyes of those who injured it were scorched by the light emitted by the Abnormality. Blinded employees worked at half-speed. The Firebird cured the agent’s eye injury when they finished the work process.")
	abno_breach_damage_type = "Red/White"
	abno_breach_damage_count = "Very High"

//Thunderbird
/obj/item/paper/fluff/info/waw/thunder_bird
	abno_type = /mob/living/simple_animal/hostile/abnormality/thunder_bird
	abno_code = "T-02-137"
	abno_info = list(
		"When the work result was Good and the employee's health was high, Qliphoth Counter was raised.",
		"When the work result was Normal, the Qliphoth Counter lowered with an average probability.",
		"When the work result was Bad, the Qliphoth Counter was lowered.",
		"All organic debris must be cleared from the vicinity of the abnormality's containment cell.")
	abno_breach_damage_type = "Black"
	abno_breach_damage_count = "High"

//Clown Smiling at Me
/obj/item/paper/fluff/info/waw/clown
	abno_type = /mob/living/simple_animal/hostile/abnormality/clown
	abno_code = "O-01-17"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the work result was Good, the Qliphoth Counter lowered with a high probability.",
		"O-01-17 explodes upon death, causing nearby empoloyees to take high RED damage if caught in the blast.")

//La Luna
/obj/item/paper/fluff/info/waw/luna
	abno_type = /mob/living/simple_animal/hostile/abnormality/luna
	abno_code = "D-01-105"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"The piano can be played by ordering an Agent to Perform. However, please note that the Qliphoth Counter will lower when the performance is finished.",
		"The music temporarily increased the Temperance and Justice of all employees by a small degree. However, the one who performed lost half their HP by the end of the performance.",
		"The Qliphoth Counter lowered to 0 when an employee entered the unit to play for the third time.",
		"When Il Pianto della Luna escaped, it voluntarily returned to its Containment Unit after the end of the third movement. The movement also prematurely ended when Il Pianto della Luna was suppressed.")
	abno_can_breach = TRUE
	abno_breach_damage_type = "Red/Black"
	abno_breach_damage_count = "High"

//Little Prince
/obj/item/paper/fluff/info/waw/little_prince
	abno_type = /mob/living/simple_animal/hostile/abnormality/little_prince
	abno_code = "O-04-66"
	abno_info = list(
		"The Qliphoth Counter decreased after 3 non-Insight works were performed in a row.",
		"The Qliphoth Counter increased after 2 Insight works were performed in a row.",
		"Employees who worked with The Little Prince 3 times in a row were completely infected by its spores. Send them to work with other Abnormalities regularly to counteract the infection.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"An employee who constantly worked with The Little Prince, showed signs of acute pain in the Containment Unit. After that, tissues similar to The Little Prince emerged in their body, and NAME began to transform into The Little Prince-1.",
		"The Little Prince attracted an employee to its containment unit when its Qliphoth Counter hit 0. When the lured employee entered the Containment Unit, the same phenomenon as described previously occurred.",
		"When suppressing The Little Prince-1, please pay attention to the spores that are released from its body upon death. Those spores will cause sustained mental damage, and employees who panic from the spores may attempt to enter The Little Prince’s Containment Unit, which should be immediately stopped.")
	abno_can_breach = TRUE // Info for the minion
	abno_breach_damage_type = "Black"
	abno_breach_damage_count = "High"

//Flesh Idol
/obj/item/paper/fluff/info/waw/flesh_idol
	abno_type = /mob/living/simple_animal/hostile/abnormality/flesh_idol
	abno_code = "T-09-79"
	abno_info = list(
		"When work was complete, everyone in the facility was healed.",
		"During work, the employee took random damage continuously.",
		"When work was completed 4 times, The Qliphoth counter lowered.",
		"When the Qliphoth counter reached 0, one abnormality breached containment.")
	abno_work_damage_type = "Random"

//Dimensional Refraction
/obj/item/paper/fluff/info/waw/dimensional_refraction
	abno_type = /mob/living/simple_animal/hostile/abnormality/dimensional_refraction
	abno_code = "O-03-88"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"The facility and its employees will find it difficult to detect the Abnormality in any fashion when it escapes. Manager or clerk assistance recommended.")
	abno_breach_damage_type = "Red"
	abno_breach_damage_count = "High"

//Contract, Signed
/obj/item/paper/fluff/info/waw/contract
	abno_type = /mob/living/simple_animal/hostile/abnormality/contract
	abno_code = "C-03-140"
	abno_info = list(
		"When the work result was Good or Normal, C-03-140 signed a contract with the employee, raising the respective stats slightly, but reducing their workchance on subsequent works.",
		"When the work result was Normal, the Qliphoth Counter lowered with a low probability.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"While working, if the employee signed a contract, all damage was reduced.",
		"When the Qliphoth counter reached 0, C-03-140 signed a contract with a shadowy figure, and then let them out in the facility.")

//Nosferatu
/obj/item/paper/fluff/info/waw/nosferatu
	abno_type = /mob/living/simple_animal/hostile/abnormality/nosferatu
	abno_code = "O-01-65"
	abno_info = list(
		"When repression work was performed, the Qliphoth counter lowered.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When instinct work was performed, the Qliphoth counter increased.",
		"Agent Bong Bong took constant BLACK damage during instinct work.",
		"When the Qliphoth counter increased while at max, Nosferatu immediately breached containment.",
		"While Nosferatu is escaping, it will show sensitive reactions to blood. Suppression becomes difficult if blood is readily accessible to this abnormality.")
	abno_breach_damage_type = "Red/Black"
	abno_breach_damage_count = "High"

//Servant of Wrath
/obj/item/paper/fluff/info/waw/wrath
	abno_type = /mob/living/simple_animal/hostile/abnormality/wrath_servant
	abno_code = "O-01-139"
	abno_info = list(
		"Whenever the work result was Good, the Servant of Wrath grew more unstable.",
		"Whenever Attachment Work was performed, this instabiity increased.",
		"Whenever the work result on Attachment Work was Good, the Servant of Wrath befriended the worker.",
		"Whenever a friend of the Servant of Wrath finished a work, the Servant of Wrath grew more unstable.",
		"Whenever Repression Work was performed, the instabiity decreased and did not increase regardless of result or friendship.",
		"Those who befriended the Servant of Wrath could request they hunt down the strongest threat in the facility.",
		"When this occurred, the Servant of Wrath's instability greatly increased and the Qliphoth Counter lowered by 2.",
		"When the Servant of Wrath breached, all attempts to suppress it were futile.",
		"Elsewhere in the facility, a being known as the Hermit of the Azure forest appeared.",
		"The Hermit attacked the agents around them, dealing heavy White Damage.",
		"In the end, the only way to suppress the Servant of Wrath was for them to kill the Hermit of the Azure forest.",
		"NOTE: The Hermit of the Azure forest in almost every scenario has overpowered the Servant of Wrath.")

//Sphinx
/obj/item/paper/fluff/info/waw/sphinx
	abno_type = /mob/living/simple_animal/hostile/abnormality/sphinx
	abno_code = "T-03-33"
	abno_info = list(
		"Employees with a high Prudence Level had their work chance increased dramatically.",
		"When the work result was Good, the abnormality provided a treasure with a low probability.",
		"When the work result was Bad, the Qliphoth counter reduced. Additionally, employees with Prudence Level 4 or lower had one of their senses taken away.",
		"Agent Joshua, who was turned to stone by the abnormality was able to be saved using the treasure of golden needles.")

//Clouded Monk
/obj/item/paper/fluff/info/waw/clouded_monk
	abno_type = /mob/living/simple_animal/hostile/abnormality/clouded_monk
	abno_code = "D-01-110"
	abno_info = list(
		"An employee’s SP was healed when they performed Insight work.",
		"The Qliphoth Counter lowered every time 2 employees died.",
		"When the work result was Normal, the Qliphoth Counter lowered with a low probability.",
		"When the work result was Bad, the Qliphoth Counter decreased.")

//My Sweet Orange Tree
/obj/item/paper/fluff/info/waw/orange_tree
	abno_type = /mob/living/simple_animal/hostile/abnormality/orange_tree
	abno_code = "O-02-23"
	abno_info = list(
		"When the work result was Normal, the employee was infected by 0-02-23 with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered with a high probability and the employee was infected by 0-02-23.",
		"When the Qliphoth Counter reached 0, O-02-23 dispersed throughout a large area.",
		"Upon observing the Abnormality, it has been confirmed that the abnormality attached to employees for a certain amount of time, and inflicted WHITE damage over that period. The abnormality is highly contagious and difficult to recontain.",
		"The infection was potentially cured if the infected received RED damage at a very small chance, with the provided flamethrowers being a far more effective deterrent.",
		"When the SP of an infested employee had depleted, the employee in question would panic, spreading the infection rapidly.")

//Pygmalion
/obj/item/paper/fluff/info/waw/pygmalion
	abno_type = /mob/living/simple_animal/hostile/abnormality/pygmalion
	abno_code = "M-03-157"
	abno_info = list(
		"The first Employee that gets a Good work result will gain a mark from now on will be called the “Sculptor”" ,
		"The “Sculptor” will have a higher work success chance with Pygmalion and will have a higher chance of getting the E.G.O gift" ,
		"Pygmalion breaches when the “Sculptor” has 50% or less sanity or health." ,
		"When Pygmalion breaches, They will teleport to the “Sculptor” and attack any abnormality in their way and any abnormality near the “Sculptor.”" ,
		"The “Sculptor” will have their maximum sanity reduced while Pygmalion is breaching." ,
		"If the “Sculptor” goes insane or dies, Pygmalion will become enraged and start attacking everyone near them.")

//Parasite Tree
/obj/item/paper/fluff/info/waw/parasite_tree
	abno_type = /mob/living/simple_animal/hostile/abnormality/parasite_tree
	abno_code = "D-04-108"
	abno_info = list(
		"When an employee finished work with D-04-10 the employee was blessed with increased temperance and prudence.",
		"Every time an employee was blessed by D-04-108 it sprouted a glowing flower bud.",
		"When another abnormality escaped, a healing leaf from D-04-108 flew out of containment and seeked out the employee with the least sanity and health.",
		"When D-04-108's flowers bloomed, blessed employees suffered heavy mental corruption until the flowers were destroyed with repression work.",
		"D-04-108-1 secretes a contagious and highly fatal toxin, the area was easily decontaminated on removal of D-04-108-1.",
		"NOTICE: Employees preforming repression work to destroy D-04-108's flowers prevented the transformation of employees who were transforming into D-04-108-1.") //yes i did put this hint in twice.

//Dream of Black Swan
//Parasite Tree
/obj/item/paper/fluff/info/waw/black_swan
	abno_type = /mob/living/simple_animal/hostile/abnormality/black_swan
	abno_code = "F-02-70"
	abno_info = list(
		"When 2 employees died F-02-70-1 eyes suddenly melted.",
		"When 2 employees panicked F-02-70-2 arms vanished.",
		"When 2 abnormalities breached F-02-70-3 legs were reduced to a sludge.",
		"When work result was bad F-02-70-4 lost their ears and cheeks.",
		"When work result was normal F-02-70-5 lost the entire lower half of their face.",
		"When the abnormality had its Qliphoth Counter decreased due to a meltdown or sabotage one of the brothers was wounded.")

//Apex Predator
/obj/item/paper/fluff/info/waw/predator
	abno_type = /mob/living/simple_animal/hostile/abnormality/apex_predator
	abno_code = "D-04-146"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When the employee working with Apex predator started work with less than max health, the work damage was drastically increased.",
		"When the employee working with Apex predator died, or went unconcious during work, the Qliphoth Counter lowered.",
		"DANGER - When Apex Predator breached, it should be located immediately.")
	abno_breach_damage_type = "Red"
	abno_breach_damage_count = "Very High"

//Baba Yaga
/obj/item/paper/fluff/info/waw/babayaga
	abno_type = /mob/living/simple_animal/hostile/abnormality/babayaga
	abno_code = "M-04-166"
	abno_info = list(
		"When the work result was Normal, the Qliphoth Counter lowered with a normal probability.",
		"When the work result was Bad, the Qliphoth Counter lowered. In addition, the employee was attacked by a group of frozen slaves.",
		"When an employee, who had both Fortitude Levels and Temperance Levels below 4, completed the work process, the Qliphoth Counter lowered. In addition, the employee was attacked by a group of frozen slaves.",
		"When Baba Yaga breached, it caused incredibly powerful shock-waves, causing nearby employees to take extreme RED damage proportionally to how close they were to the source.",
		"Every time Baba Yaga landed, a small group of frozen slaves arrived from the scene to attack nearby employees.")
	abno_breach_damage_type = "Red"
	abno_breach_damage_count = "Extreme"

//Big and Will be Bad Wolf
/obj/item/paper/fluff/info/waw/big_wolf
	abno_type = /mob/living/simple_animal/hostile/abnormality/big_wolf
	abno_code = "F-02-58"
	abno_info = list(
		"When the work result was Bad, the Qliphoth Counter lowered and the employee working on F-02-58 was consumed.",
		"When the employee had a good result while preforming instinct work F-02-58 vomited all of the previously consumed employees.",
		"When F-02-58 is below 50% health their howl will weaken the containment of nearby abnormalities."
		)

//Poor Screenwriter's Note
/obj/item/paper/fluff/info/waw/screenwriter
	abno_type = /mob/living/simple_animal/hostile/abnormality/screenwriter
	abno_code = "O-05-29" //originally O-05-31 in lobotomy corp, but it's taken by TSO.
	abno_info = list(
		"Poor Screenwriter's Note prefers that everything goes according to its own scenario. Work will also not be an exception. If you are unsure of what to do, turn the page.",
		"When the work result was bad, the Qliphoth Counter lowered.",
		"When the Qliphoth counter reached 0, several employees were selected to play roles in a \"play\"",
		"The employee playing the \"Coward\" suffered from lowered power, the \"Broken\" lowered health, and the \"Failed\" lowered sanity.",
		"The employees chosen to play the \"Victim\" suffered perhaps the most of all, losing in all virtues and being targetted by the actor \"A\".",
		"When the \"Victim\" died or was not present, another role was picked to play the \"Victim\".",
		"When the actor \"A\" was defeated, the abnormality was suppressed.")
	abno_work_rates = list(
		"Nutrition" = "Low",
		"Cleanliness" = "Low",
		"Consensus" = "Low",
		"Amusement" = "Low",
		"Violence" = "Low")
	abno_breach_damage_type = "White"
	abno_breach_damage_count = "High"

//Sign of Roses
/obj/item/paper/fluff/info/waw/rose_sign
	abno_type = /mob/living/simple_animal/hostile/abnormality/rose_sign
	abno_code = "O-04-177" //O-04-21-22 in LCB
	abno_info = list(
		"When insight work was performed, a rose was planted in the containment cell of Sign of Roses.",
		"When insight work was performed while four roses were present, the Qliphoth counter lowered.",
		"When repression work was performed, a planted rose withered away.",
		"When repression work was performed with no roses present, the Qliphoth Counter lowered.",
		"The roses that grow in the containment cell, dubbed O-04-177-1 drastically raised the success rate and PE boxes generated from all works.",
		"Agent Orga who worked while many O-04-177-1 were present sustained far greater damage from working.",
		"When Sign of Roses breached, all agents were branded with a crown of thorns. O-04-177-1 would occasionally appear nearby and kill a branded agent after some time passed.",
		"When O-04-177-1 was suppressed, Sign of Roses became more vulnerable to damage.")
	abno_breach_damage_type = "Black"
	abno_breach_damage_count = "Low"

//Dream-Devouring Siltcurrent
/obj/item/paper/fluff/info/waw/siltcurrent
	abno_type = /mob/living/simple_animal/hostile/abnormality/siltcurrent
	abno_code = "T-02-179"
	abno_info = list(
		"When an employee with Fortitude Level 2 or lower finished their work, the Qliphoth Counter lowered.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When an employee fainted due to a lack of oxygen, the Qliphoth Counter lowered.",
		"While working, Jimbo noticed he was losing oxygen during the work.",
		"Upon breaching, the facility became flooded until Dream-Devouring Siltcurrent was recontained.",
		"While the facility was flooded, all employees took constant oxygen damage when near Dream-Devouring Siltcurrent.",
		"Upon breaching, Flotsams appeared throughout the facility.",
		"When LaVerne damaged the Flotsams or Dream-Devouring Siltcurrent some of his oxygen was replenished.",
		"When Dream-Devouring Siltcurrent tried to dive into a broken down Frotsam it became briefly stunned and was heavily damaged.",
		"While stunned, Dream-Devouring Siltcurrent took extra damage.")
	abno_breach_damage_type = "Red"
	abno_breach_damage_count = "Extreme"

//Little Red Riding Hooded Mercenary
/obj/item/paper/fluff/info/waw/red_hood
	abno_type = /mob/living/simple_animal/hostile/abnormality/red_hood
	abno_code = "F-01-57"
	abno_info = list(
		"Requesting F-01-57 to suppress escaping Abnormalities or manifested Ordeals is a very useful resource. However, making such a request is not free.",
		"Requesting to suppress an abnormality will cost more PE depending on the abnormality's risk level. For other targets, F-01-57 will charge more as the day progresses.",
		"F-01-57 did not attack employees during a quest, and returned to containment after the suppression was completed.",
		"The Qliphoth Counter decreased every time an Abnormality escaped. However, it did not respond similarly to the escape of O-02-56.",
		"The abnormality had particularly strong reactions when encountering F-01-117 (Blue-Smocked Shepherd), F-02-127 (Reddened Buddy), and especially F-02-58 (Big and will be Bad Wolf).",
		"When the above occurred, F-01-57 entered a state of apparent heightened emotion, attacking more rapidly, dealing and taking more damage, and tracking the encountered abnormality.",
		"When F-01-57 was denied a killing blow to F-02-58, the abnormality went on a rampage."
	)

//My Form Empties
/obj/item/paper/fluff/info/waw/my_form_empties
	abno_type =  /mob/living/simple_animal/hostile/abnormality/my_form_empties
	abno_code = "M-04-199"//M-04-04-04 in limbus company
	abno_info = list(
		"When Qliphoth Counter was 2, My Form Empties chanted sutras in its cell, restoring the SP of nearby employees.",
		"When Qliphoth Counter lowered to 1, My Form Empties entered a state of Anatman (Non-Self), raising work success rate.",
		"When the employee had a good result during a state of Anatman, Qliphoth Counter lowered.",
		"When the employee had a neutral result during a state of Anatman, Qliphoth Counter rose. Otherwise, it lowered at a low probability.",
		"When the work result was bad, Qliphoth Counter decreased.",
		"When My Form Empties escaped, a few hostile entities dubbed M-04-199-1 followed it.",
		"When My Form Empties escaped, all agents were affected by Karma, increasing damage taken.",
		"Karma was transferred when the agent with karma attacked other entities, excluding M-04-199."
	)
	abno_breach_damage_type = "White"
	abno_breach_damage_count = "Extreme"

//Hookah Caterpillar
/obj/item/paper/fluff/info/waw/caterpillar
	abno_type = /mob/living/simple_animal/hostile/abnormality/caterpillar
	abno_code = "F-02-190"
	abno_info = list(
		"Working on F-02-190 on a work type other than repression will increase work damage and PE gained until next breach.",
		"When Work damage and PE generated increased, so did the danger to the employee.",
		"Eventually, works other than repression on F-02-190 will lower it's Qliphoth Counter.",

	)
	abno_breach_damage_type = "Pale"
	abno_breach_damage_count = "Very High"
