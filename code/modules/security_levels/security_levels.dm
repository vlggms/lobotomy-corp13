GLOBAL_VAR_INIT(security_level, SEC_LEVEL_GREEN)
//SEC_LEVEL_GREEN = code green
//SEC_LEVEL_BLUE = code blue
//SEC_LEVEL_RED = code red
//SEC_LEVEL_DELTA = code delta

//config.alert_desc_blue_downto

/proc/set_security_level(level)
	switch(level)
		if("no warning")
			level = SEC_LEVEL_GREEN
		if("first warning")
			level = SEC_LEVEL_BLUE
		if("second warning")
			level = SEC_LEVEL_RED
		if("third warning")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != GLOB.security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				minor_announce(CONFIG_GET(string/alert_green), "Attention!")
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level >= SEC_LEVEL_RED)
						SSshuttle.emergency.modTimer(4)
					else
						SSshuttle.emergency.modTimer(2)
				GLOB.security_level = SEC_LEVEL_GREEN
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
			if(SEC_LEVEL_BLUE)
				if(GLOB.security_level < SEC_LEVEL_BLUE)
					minor_announce(CONFIG_GET(string/alert_blue_upto), "Attention! First warning!",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(0.5)
				else
					minor_announce(CONFIG_GET(string/alert_blue_downto), "Attention! First warning!")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(2)
				GLOB.security_level = SEC_LEVEL_BLUE
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
			if(SEC_LEVEL_RED)
				if(GLOB.security_level < SEC_LEVEL_RED)
					minor_announce(CONFIG_GET(string/alert_red_upto), "Attention! Second warning!",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level == SEC_LEVEL_GREEN)
							SSshuttle.emergency.modTimer(0.25)
						else
							SSshuttle.emergency.modTimer(0.5)
				else
					minor_announce(CONFIG_GET(string/alert_red_downto), "Attention! Second warning!")
				GLOB.security_level = SEC_LEVEL_RED

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.locked = FALSE
			if(SEC_LEVEL_DELTA)
				minor_announce(CONFIG_GET(string/alert_delta), "Attention! Third warning!",1)
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level == SEC_LEVEL_GREEN)
						SSshuttle.emergency.modTimer(0.25)
					else if(GLOB.security_level == SEC_LEVEL_BLUE)
						SSshuttle.emergency.modTimer(0.5)
				GLOB.security_level = SEC_LEVEL_DELTA
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.locked = FALSE
		for(var/area/facility_hallway/F in GLOB.sortedAreas)
			F.RefreshLights()
		for(var/area/department_main/D in GLOB.sortedAreas)
			D.RefreshLights()
		if(level >= SEC_LEVEL_RED)
			for(var/obj/machinery/door/D in GLOB.machines)
				if(D.red_alert_access)
					D.visible_message("<span class='notice'>[D] whirrs as it automatically lifts access requirements!</span>")
					playsound(D, 'sound/machines/boltsup.ogg', 50, TRUE)
		SSblackbox.record_feedback("tally", "security_level_changes", 1, get_security_level())
		SSnightshift.check_nightshift()
	else
		return

/proc/get_security_level()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "no warning"
		if(SEC_LEVEL_BLUE)
			return "first warning"
		if(SEC_LEVEL_RED)
			return "second warning"
		if(SEC_LEVEL_DELTA)
			return "third warning"

/proc/num2seclevel(num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "no warning"
		if(SEC_LEVEL_BLUE)
			return "first warning"
		if(SEC_LEVEL_RED)
			return "second warning"
		if(SEC_LEVEL_DELTA)
			return "third warning"

/proc/seclevel2num(seclevel)
	switch( lowertext(seclevel) )
		if("no warning")
			return SEC_LEVEL_GREEN
		if("first warning")
			return SEC_LEVEL_BLUE
		if("second warning")
			return SEC_LEVEL_RED
		if("third warning")
			return SEC_LEVEL_DELTA
