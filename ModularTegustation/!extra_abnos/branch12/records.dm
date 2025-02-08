//All the records for this gamemodes goes into one filing cabinet
/obj/structure/filingcabinet/branch12
	name = "abnormality information cabinet"
	icon_state = "chestdrawer"
	var/virgin = TRUE

/obj/structure/filingcabinet/branch12/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/branch12)
	for(var/sheet in queue)
		new sheet(src)

/obj/structure/filingcabinet/branch12/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//	-------------TOOLS-------------
//Eye For an Eye
/obj/item/paper/fluff/info/branch12/eye
	name = "Eye for an Eye - O-09-12-193"
	info = {"<h1><center>O-09-12-193</center></h1>	<br>
	Name : Eye for an Eye<br>
	Risk Class : Teth	<br>
	- When used, O-09-12-193 swapped the current hp and sp of the employee working on it.	<br>
	- If an employee triggers the previous effect twice in a day they will immediately panic.	<br>
	- Any additional uses after the second use by the employee who received the bonus will kill them."}

//10 Seconds to Midnight
/obj/item/paper/fluff/info/branch12/midnight
	name = "10 Seconds till Midnight - O-09-12-202"
	info = {"<h1><center>O-09-12-202</center></h1>	<br>
	Name : 10 Seconds till Midnight<br>
	Risk Class : Teth	<br>
	- When an employee used T-09-12-202, the ordeal wouldn’t occur. A qliphoth meltdown of the corresponding meltdown level would take its place. <br>
	- 10 seconds till midnight can only stop ordeals 2 times per shift.	<br>
	- When used, 10 seconds till midnight would lower the qliphoth counter of 5 Abnormalities by 1.	<br>
	- When you stop an ordeal all continuing ordeals will either increase in strength and reward, or decrease in reward."}

//10 Seconds to Midnight
/obj/item/paper/fluff/info/branch12/mislocation
	name = "Mislocation - O-09-12-290"
	info = {"<h1><center>O-09-12-290</center></h1>	<br>
	Name : Mislocation<br>
	Risk Class : Teth<br>
	- Employees sitting at the bench of O-09-12-290 simply refused to die, and would not die unless they left the area under the lamp post."}

//10 Seconds to Midnight
/obj/item/paper/fluff/info/branch12/compass
	name = "Predestined Compass - O-09-12-159"
	info = {"<h1><center>O-09-12-159</center></h1>	<br>
	Name : Predestined Compass<br>
	Risk Class : He	<br>
	- Employees who carried O-09-12-159 found themselves to be luckier when working on abnormalities under a meltdown, boosting their PE production. <br>
	- Employees who carried the Predestined Compass, and worked on an abnormality not suffering a qliphoth meltdown would have incredibly terrible luck."}

//	-------------ZAYIN-------------
// Full Wave M'aider
/obj/item/paper/fluff/info/branch12/wave
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/wave
	abno_code = "O-06-12-102"
	abno_info = list(
		"It was noticed upon a good work result on attachment that a soothing song could be heard in other containment units, relaxing the other abnormalities for the rest of the shift.",
		"The relaxed abnormalities seemed more prone to testing, producing more E on average.",
		"Despite being beneficial to E production, an employee should not try to do attachment work twice in a day. Doing so will result in <Redacted> being heard across the facility, slowly doing white damage to all employees.",
		"The <Redacted> can be stopped once a employee gets a good work result on O-06-12-102",
	)

// Statue of Forgiveness
/obj/item/paper/fluff/info/branch12/statue
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/statue_of_forgiveness
	abno_code = "O-03-12-899"
	abno_info = list(
		"When an employee completed a Good work result, the employee was granted a blessing.",
		"When an employee panics while performing a work order, the employee will seek for other employees to attack.",
		"A second blessing cannot be given while an employee is already under the effect of it.",
		"The <Redacted> can be stopped once a employee gets a good work result on O-06-12-102",
	)


//	-------------TETH-------------
// Remnant of the Forest
/obj/item/paper/fluff/info/branch12/rock
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/rock
	abno_code = "O-04-12-120"
	abno_info = list(
		"<Experiment> The employee Johnson began work on O-04-12-120, and O-04-12-120 produced 1 E then promptly disappeared.",
		"Upon further examination O-04-12-120 was found in one of the corridors in the department its containment room was in.",
		"O-04-12-120 showed no signs of anomalous effects when escaped. Employee Johnson then carried O-04-12-120 back to its unit.",
		"O-04-120 has only caused 17 employee deaths to date, three of which were due to blunt force trauma as a result of being launched by breaching abnormalities. The others were a result of an unapproved bet between employees to feed O-04-12-120 to O-01-15.",
		"Please for the love of <REDACTED> do not do that again, that poor rock has had enough abuse as it is.",
		"<Experiment 3> Following the events of <Redacted>, It has been observed that abnormalities originating from the black forest demonstrate high levels of aversion to O-04-12-120. Please keep this in mind as a last-resort failsafe should an emergency involving O-02-63 occurs in the main branch."
	)

// Vow Of A Dove
/obj/item/paper/fluff/info/branch12/dove
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/dove
	abno_code = "O-02-12-251"
	abno_info = list(
		"When the work result was bad, the Qliphoth counter lowered.",
		"When worked on by an employee with 1 or lower Temperance, the Qliphoth counter lowers.",
	)

//	-------------HE-------------
// The Show Goes On
/obj/item/paper/fluff/info/branch12/show_goes_on
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on
	abno_code = "T-04-12-93"
	abno_info = list(
		"When the work result was not perfect the employee continued working until it was perfect or nearly so.",
		"When the employee was performing the stage prevented damage, death, and interference from external sources.",
		"When the work result was good the employee was healed slightly.",
		"Every time the employee didn’t perform correctly the negative energy damage increased.",
		"When an employee dies in T-04-12-93 and they haven’t performed perfectly, the dead body will continue producing E until it they completed their work.",
	)

// Ollieoxenfree
/obj/item/paper/fluff/info/branch12/ollieoxenfree
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree
	abno_code = "T-06-12-143"
	abno_info = list(
		"When the work result was bad the counter lowered by 1.",
		"T-06-12-143 prefers attachment work over all other types of work. Any other work besides attachment will lower the counter by 1.",
		"When an employee performed attachment work, T-06-12-143 created an idea.",
		"Every time the employee didn’t perform correctly the negative energy damage increased.",
		"The ideas obtained by T-06-143 are manifested into this abnormality’s strength whenever it breaches.",
	)


//	-------------WAW-------------
// Queen Keres
/obj/item/paper/fluff/info/branch12/queen_keres
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/queen_keres
	abno_code = "T-01-12-233"
	abno_info = list(
		"When the work result was normal, the Qliphoth counter decreased with a high probability.",
		"When the counter decreased, an agent was knighted by T-01-12-233.",
		"A knighted employee receives an increase in all resistances for the rest of the shift, or until the death of T-01-12-233.",
		"When an employee with level III temperance or below completed their work, the counter lowered.",
	)


// Joe Shmoe
/obj/item/paper/fluff/info/branch12/joe_shmoe
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe
	abno_code = "T-01-12-111"
	abno_info = list(
		"When the work result was bad, the Qliphoth counter decreased.",
		"When the work result was good, the Qliphoth counter decreased.",
		"When the work result was neutral, the Qliphoth counter increased.",
		"When O-01-111’s Qliphoth counter reached 0, A copy of O-01-12-111 appeared in multiple hallways of the facility",
	)

// Passion of Love in Death
/obj/item/paper/fluff/info/branch12/passion
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/passion
	abno_code = "T-01-12-244"
	abno_info = list(
		"When the work result was bad, the Qliphoth counter decreased with a high probability.",
		"When repression work was performed with T-01-244, the Qliphoth counter lowered at a high probability.",
		"When an employee with level 3 justice or higher completed their work, the Qliphoth counter lowered. The same phenomenon occurred when temperance was below level 4.",
	)



//	-------------ALEPH-------------
// Old Man and The Pale
/obj/item/paper/fluff/info/branch12/oldman_pale
	abno_type = /mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale
	abno_code = "T-01-12-127"
	abno_info = list(
		"When the work result was bad, the Qliphoth counter.",
		"When the work result was normal, the Qliphoth counter decreased with an average probability.",
		"When Repression work was performed and the work result was good, the Qliphoth counter.",
		"When an employee went insane while working on T-01-12-127 then employee gained INNOCENCE after 60 seconds.",
		"INNOCENCE could not be cleared, and slowly drained sanity.",
		"Working Inspire on T-01-12-127 with a good result would cause all of The Pale in the facility to be cleared.",
		"Working Inspire on T-01-12-127 with a bad or normal result would cause INNOCENCE to be applied to the employee working on T-01-12-127.",
	)
