//Los Mariachis - Grade 7 with poise crits, white version of Kurokumo.
/obj/item/ego_weapon/city/mariachi
	name = "maraca"
	desc = "A single maraca used by Los Mariachis."
	special = "This weapon gains 1 poise for every attack. 1 poise gives you a 2% chance to crit at 3x damage, stacking linearly. Critical hits reduce poise to 0."
	icon_state = "maracas"
	force = 22
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	var/poise = 0

/obj/item/ego_weapon/city/mariachi/examine(mob/user)
	. = ..()
	. += "Current Poise: [poise]/20."

/obj/item/ego_weapon/city/mariachi/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	poise+=1
	if(poise>= 20)
		poise = 20

	//Crit itself.
	if(prob(poise*2))
		force*=3
		to_chat(user, "<span class='userdanger'>Critical!</span>")
		poise = 0
	..()
	force = initial(force)

//Leader, Grade 6 (She's pretty weak)
/obj/item/ego_weapon/city/mariachi/dual
	name = "maracas"
	desc = "A pair of maracas used by the leader of Los Mariachis."
	icon_state = "dualmaracas"
	force = 19		//Double the maracas twice the attack speed.
	attack_speed = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

