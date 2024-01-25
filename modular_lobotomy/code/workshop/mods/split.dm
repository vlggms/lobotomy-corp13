//These are rare, but they deal two damage types
/obj/item/workshop_mod/split
	icon_state = "splitcore"
	overlay = "split"

//Split damage, currently only red and white
/obj/item/workshop_mod/split/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	var/splitdamage = justicemod*force
	var/splitdamagetype
	switch(T.damtype)
		if(RED_DAMAGE)
			splitdamagetype = PALE_DAMAGE
		if(WHITE_DAMAGE)
			splitdamagetype = BLACK_DAMAGE
	target.apply_damage(splitdamage, splitdamagetype, null, target.run_armor_check(null, splitdamagetype), spread_damage = TRUE)

/obj/item/workshop_mod/split/redpale
	name = "split damage mod A"
	desc = "A workshop mod to turn a weapon into red/pale damage. Throwing weapons will deal the first damage type."
	modname = "yin"
	color = "#d49c3b"
	weaponcolor = "#d49c3b"
	damagetype = RED_DAMAGE
	forcemod = 0.7

/obj/item/workshop_mod/split/whiteblack
	name = "split damage mod B"
	desc = "A workshop mod to turn a weapon into white/black damage. Throwing weapons will deal the first damage type."
	modname = "yang"
	color = "#b1e6a1"
	weaponcolor = "#b1e6a1"
	damagetype = WHITE_DAMAGE
	forcemod = 0.7

