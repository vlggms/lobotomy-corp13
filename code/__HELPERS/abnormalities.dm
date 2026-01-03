/// This proc returns text explanation of simple mob's resistances
/proc/SimpleResistanceToText(resist = 1)
	switch(resist)
		if(0 to 0) //Just putting 0 doesn't work.
			return "Immune"
		if(1 to 1)
			return "Normal"
		if(-INFINITY to 0)
			return "Absorbed"
		if(0 to 0.5)
			return "Resistant"
		if(0.5 to 1)
			return "Endured"
		if(1 to 1.5)
			return "Weak"
		if(2 to INFINITY)
			return "Fatal"
		if(1.5 to 2)
			return "Vulnerable"
	return "Unknown ([resist])"

/// Returns text description for combat damage
/proc/SimpleDamageToText(damage = 10)
	switch(damage)
		if(0 to 0)
			return "None"
		if(-INFINITY to 0)
			return "Healing"
		if(0 to 8)
			return "Very Low"
		if(8 to 15)
			return "Low"
		if(15 to 25)
			return "Moderate"
		if(25 to 35)
			return "High"
		if(50 to INFINITY)
			return "Extreme"
		if(35 to 50)
			return "Very High"

	return "Unknown ([damage])"

/// Returns text description of work damage
/proc/SimpleWorkDamageToText(damage = 1)
	switch(damage)
		if(0 to 0)
			return "None"
		if(-INFINITY to 0)
			return "Healing"
		if(0 to 2)
			return "Very Low"
		if(2 to 4)
			return "Low"
		if(4 to 5)
			return "Moderate"
		if(5 to 6)
			return "High"
		if(8 to INFINITY)
			return "Extreme"
		if(6 to 7)
			return "Very High"

	return "Unknown ([damage])"

/// Returns text description of work success rate
/proc/SimpleSuccessRateToText(rate = 50)
	switch(rate)
		if(-INFINITY to 10)
			return "Very Low"
		if(10 to 30)
			return "Low"
		if(30 to 50)
			return "Common"
		if(70 to INFINITY)
			return "Very High"
		if(50 to 70)
			return "High"

	return "Unknown ([rate])"

/*
	Try to keep images 256px on at least one side to keep file sizes small - Coxswain
*/
GLOBAL_LIST_EMPTY(abnormality_portraits)
#define PORTRAIT_PATH "icons/UI_Icons/abnormality_portraits/"
/proc/create_portrait_paths()
	. = list()
	for(var/file in flist(PORTRAIT_PATH))
		if(copytext("[file]", -1) == "/")
			continue
		. += file("[PORTRAIT_PATH][file]")
	GLOB.abnormality_portraits = .
#undef PORTRAIT_PATH
