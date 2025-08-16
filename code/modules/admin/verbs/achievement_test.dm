/client/proc/unlock_achievement_test()
	set name = "Unlock Achievement (Test)"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/list/all_achievements = list()
	for(var/achievement_type in SSachievements.achievements)
		var/datum/award/achievement/A = SSachievements.achievements[achievement_type]
		if(!A.name)
			continue
		all_achievements[A.name] = achievement_type

	var/choice = input("Select an achievement to unlock:", "Achievement Test") as null|anything in all_achievements
	if(!choice)
		return

	var/achievement_type = all_achievements[choice]
	player_details.achievements.unlock(achievement_type, mob)
	to_chat(src, "<span class='adminnotice'>Unlocked achievement: [choice]</span>")

/client/proc/reset_achievement_test()
	set name = "Reset Achievement (Test)"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/list/unlocked = list()
	for(var/achievement_type in player_details.achievements.data)
		if(!player_details.achievements.data[achievement_type])
			continue
		var/datum/award/achievement/A = SSachievements.achievements[achievement_type]
		if(!A || !A.name)
			continue
		unlocked[A.name] = achievement_type

	if(!unlocked.len)
		to_chat(src, "<span class='warning'>You have no unlocked achievements!</span>")
		return

	var/choice = input("Select an achievement to reset:", "Achievement Reset") as null|anything in unlocked
	if(!choice)
		return

	var/achievement_type = unlocked[choice]
	player_details.achievements.reset(achievement_type)
	to_chat(src, "<span class='adminnotice'>Reset achievement: [choice]</span>")

/client/proc/view_my_achievements()
	set name = "View My Achievements"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/list/output = list("<b>Your Achievements:</b>")
	for(var/achievement_type in SSachievements.achievements)
		var/datum/award/achievement/A = SSachievements.achievements[achievement_type]
		if(!A.name)
			continue
		var/unlocked = player_details.achievements.data[achievement_type]
		var/color = unlocked ? "#00FF00" : "#FF0000"
		output += "<span style='color: [color]'>[A.name] ([A.difficulty]) - [unlocked ? "UNLOCKED" : "LOCKED"]</span>"

	to_chat(src, output.Join("<br>"))
