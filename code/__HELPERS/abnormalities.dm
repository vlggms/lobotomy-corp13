/// This proc returns text explanation of simple mob's resistances
/proc/SimpleResistanceToText(resist = 1)
	switch(resist)
		if(0 to 0) //Just putting 0 doesn't work.
			return "Immune"
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
		if(0 to 15)
			return "Very Low"
		if(15 to 30)
			return "Low"
		if(30 to 50)
			return "Moderate"
		if(50 to 70)
			return "High"
		if(100 to INFINITY)
			return "Extreme"
		if(70 to 100)
			return "Very High"

	return "Unknown ([damage])"

/// Returns text description of work damage
/proc/SimpleWorkDamageToText(damage = 1)
	switch(damage)
		if(0 to 0)
			return "None"
		if(-INFINITY to 0)
			return "Healing"
		if(0 to 3)
			return "Very Low"
		if(3 to 6)
			return "Low"
		if(6 to 9)
			return "Moderate"
		if(9 to 12)
			return "High"
		if(15 to INFINITY)
			return "Extreme"
		if(12 to 15)
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
