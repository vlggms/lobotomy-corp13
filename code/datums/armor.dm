#define ARMORID "armor-[red]-[white]-[black]-[pale]-[melee]-[bullet]-[laser]-[energy]-[bomb]-[bio]-[rad]-[fire]-[acid]-[magic]-[wound]"

/proc/getArmor(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0, magic = 0, wound = 0, red = 0, white = 0, black = 0, pale = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(melee, bullet, laser, energy, bomb, bio, rad, fire, acid, magic, wound, red, white, black, pale)

/datum/armor
	datum_flags = DF_USE_TAG
	var/red
	var/white
	var/black
	var/pale
	var/melee
	var/bullet
	var/laser
	var/energy
	var/bomb
	var/bio
	var/rad
	var/fire
	var/acid
	var/magic
	var/wound

/datum/armor/New(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0, magic = 0, wound = 0, red = 0, white = 0, black = 0, pale = 0)
	if(GLOB.damage_type_shuffler.is_enabled)
		var/list/mapping = GLOB.damage_type_shuffler.mapping_defense
		var/list/coeffs = list(RED_DAMAGE = red, WHITE_DAMAGE = white, BLACK_DAMAGE = black, PALE_DAMAGE = pale)
		red = coeffs[mapping[RED_DAMAGE]]
		white = coeffs[mapping[WHITE_DAMAGE]]
		black = coeffs[mapping[BLACK_DAMAGE]]
		pale = coeffs[mapping[PALE_DAMAGE]]
	src.red = red
	src.white = white
	src.black = black
	src.pale = pale
	src.melee = melee
	src.bullet = bullet
	src.laser = laser
	src.energy = energy
	src.bomb = bomb
	src.bio = bio
	src.rad = rad
	src.fire = fire
	src.acid = acid
	src.magic = magic
	src.wound = wound
	tag = ARMORID

/datum/armor/proc/modifyRating(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0, magic = 0, wound = 0, red = 0, white = 0, black = 0, pale = 0)
	return getArmor(src.melee+melee, src.bullet+bullet, src.laser+laser, src.energy+energy, src.bomb+bomb, src.bio+bio, src.rad+rad, src.fire+fire, src.acid+acid, src.magic+magic, src.wound+wound, src.red+red, src.white+white, src.black+black, src.pale+pale)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(melee+modifier, bullet+modifier, laser+modifier, energy+modifier, bomb+modifier, bio+modifier, rad+modifier, fire+modifier, acid+modifier, magic+modifier, wound+modifier, red+modifier, white+modifier, black+modifier, pale+modifier)

/datum/armor/proc/setRating(melee, bullet, laser, energy, bomb, bio, rad, fire, acid, magic, wound, red, white, black, pale)
	return getArmor((isnull(red) ? src.red : red),\
					(isnull(white) ? src.white : white),\
					(isnull(black) ? src.black : black),\
					(isnull(pale) ? src.pale : pale),\
					(isnull(melee) ? src.melee : melee),\
					(isnull(bullet) ? src.bullet : bullet),\
					(isnull(laser) ? src.laser : laser),\
					(isnull(energy) ? src.energy : energy),\
					(isnull(bomb) ? src.bomb : bomb),\
					(isnull(bio) ? src.bio : bio),\
					(isnull(rad) ? src.rad : rad),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(acid) ? src.acid : acid),\
					(isnull(magic) ? src.magic : magic),\
					(isnull(wound) ? src.wound : wound))

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list(MELEE = melee, BULLET = bullet, LASER = laser, ENERGY = energy, BOMB = bomb, BIO = bio, RAD = rad, FIRE = fire, ACID = acid, MAGIC = magic, WOUND = wound, RED_DAMAGE = red, WHITE_DAMAGE = white, BLACK_DAMAGE = black, PALE_DAMAGE = pale)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(melee+AA.melee, bullet+AA.bullet, laser+AA.laser, energy+AA.energy, bomb+AA.bomb, bio+AA.bio, rad+AA.rad, fire+AA.fire, acid+AA.acid, magic+AA.magic, wound+AA.wound, red+AA.red, white+AA.white, black+AA.black, pale+AA.pale)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(melee-AA.melee, bullet-AA.bullet, laser-AA.laser, energy-AA.energy, bomb-AA.bomb, bio-AA.bio, rad-AA.rad, fire-AA.fire, acid-AA.acid, magic-AA.magic, wound-AA.wound, red-AA.red, white-AA.white, black-AA.black, pale-AA.pale)

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = ARMORID // update tag in case armor values were edited

#undef ARMORID
