#define DAMCOEFFID "damage_coeff-[red]-[white]-[black]-[pale]-[brute]-[burn]-[tox]-[clone]-[stamina]-[oxy]"

/proc/getDamCoeff(red = 1, white = 1, black = 1, pale = 1, brute = 1, burn = 1, tox = 1, clone = 1, stamina = 1, oxy = 1)
	. = locate(DAMCOEFFID)
	if(!.)
		. = new /datum/dam_coeff(red, white, black, pale, brute, burn, tox, clone, stamina, oxy)

/proc/makeDamCoeff(list/dc = list())
	var/list/coeffs = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1, BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)
	for(var/I in dc)
		coeffs[I] = dc[I]
	return getDamCoeff(coeffs[RED_DAMAGE], coeffs[WHITE_DAMAGE], coeffs[BLACK_DAMAGE], coeffs[PALE_DAMAGE], coeffs[BRUTE], coeffs[BURN], coeffs[TOX], coeffs[CLONE], coeffs[STAMINA], coeffs[OXY])

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
	. = 0
	switch(coeff)
		if(BRUTE)
			. = brute
		if(BURN)
			. = burn
		if(TOX)
			. = tox
		if(CLONE)
			. = clone
		if(STAMINA)
			. = stamina
		if(OXY)
			. = oxy
		if(RED_DAMAGE)
			. = red
		if(WHITE_DAMAGE)
			. = white
		if(BLACK_DAMAGE)
			. = black
		if(PALE_DAMAGE)
			. = pale
	return

/datum/dam_coeff/proc/getList()
	return list(RED_DAMAGE = red, WHITE_DAMAGE = white, BLACK_DAMAGE = black, PALE_DAMAGE = pale, BRUTE = brute, BURN = burn, TOX = tox, CLONE = clone, STAMINA = stamina, OXY = oxy)

/datum/dam_coeff/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = DAMCOEFFID // update tag in case damage_coeff values were edited

#undef DAMCOEFFID
