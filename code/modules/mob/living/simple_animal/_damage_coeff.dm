#define DAMCOEFFID "damage_coeff-[red]-[white]-[black]-[pale]-[brute]-[burn]-[tox]-[clone]-[stamina]-[oxy]"

/proc/getDamCoeff(red = 1, white = 1, black = 1, pale = 1, brute = 1, burn = 1, tox = 1, clone = 1, stamina = 1, oxy = 1)
	. = locate(DAMCOEFFID)
	if(!.)
		. = new /datum/dam_coeff(red, white, black, pale, brute, burn, tox, clone, stamina, oxy)

/proc/makeDamCoeff(list/dc = list())
	var/brute = 1
	var/burn = 1
	var/tox = 1
	var/clone = 1
	var/stamina = 1
	var/oxy = 1
	var/red = 1
	var/white = 1
	var/black = 1
	var/pale = 1
	for(var/I in dc)
		switch(I)
			if(BRUTE)
				brute = dc[I]
			if(BURN)
				burn = dc[I]
			if(TOX)
				tox = dc[I]
			if(CLONE)
				clone = dc[I]
			if(STAMINA)
				stamina = dc[I]
			if(OXY)
				oxy = dc[I]
			if(RED_DAMAGE)
				red = dc[I]
			if(WHITE_DAMAGE)
				white = dc[I]
			if(BLACK_DAMAGE)
				black = dc[I]
			if(PALE_DAMAGE)
				pale = dc[I]
	return getDamCoeff(red, white, black, pale, brute, burn, tox, clone, stamina, oxy)

/datum/dam_coeff
	datum_flags = DF_USE_TAG
	var/brute
	var/burn
	var/tox
	var/clone
	var/stamina
	var/oxy
	var/red
	var/white
	var/black
	var/pale

/datum/dam_coeff/New(red = 1, white = 1, black = 1, pale = 1, brute = 1, burn = 1, tox = 1, clone = 1, stamina = 1, oxy = 1)
	src.red = red
	src.white = white
	src.black = black
	src.pale = pale
	src.brute = brute
	src.burn = burn
	src.tox = tox
	src.clone = clone
	src.stamina = stamina
	src.oxy = oxy
	tag = DAMCOEFFID

/datum/dam_coeff/proc/modifyCoeff(red = 0, white = 0, black = 0, pale = 0, brute = 0, burn = 0, tox = 0, clone = 0, stamina = 0, oxy = 0)
	return getDamCoeff(src.red+red, src.white+white, src.black+black, src.pale+pale, src.brute+brute, src.burn+burn, src.tox+tox, src.clone+clone, src.stamina+stamina, src.oxy+oxy)

/datum/dam_coeff/proc/setCoeff(red, white, black, pale, brute, burn, tox, clone, stamina, oxy)
	return getDamCoeff((isnull(red) ? src.red : red),\
					(isnull(white) ? src.white : white),\
					(isnull(black) ? src.black : black),\
					(isnull(pale) ? src.pale : pale),\
					(isnull(brute) ? src.brute : brute),\
					(isnull(burn) ? src.burn : burn),\
					(isnull(tox) ? src.tox : clone),\
					(isnull(clone) ? src.clone : clone),\
					(isnull(stamina) ? src.stamina : stamina),\
					(isnull(oxy) ? src.oxy : oxy))

/datum/dam_coeff/proc/getCoeff(coeff)
	return vars[coeff]

/datum/dam_coeff/proc/getList()
	return list(RED_DAMAGE = red, WHITE_DAMAGE = white, BLACK_DAMAGE = black, PALE_DAMAGE = pale, BRUTE = brute, BURN = burn, TOX = tox, CLONE = clone, STAMINA = stamina, OXY = oxy)

/datum/dam_coeff/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = DAMCOEFFID // update tag in case damage_coeff values were edited

#undef DAMCOEFFID
