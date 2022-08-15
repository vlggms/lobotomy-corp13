/obj/item/ego_weapon/grinder
	name = "grinder MK4"
	desc = "The sharp sawtooth of the grinder makes a clean cut through its enemy. \
	Its operation is simple and straightforward, but that doesn't necessarily make it easy to wield."
	icon_state = "grinder"
	force = 30
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/harvest
	name = "harvest"
	desc = "The last legacy of the man who sought wisdom. The rake tilled the human brain instead of farmland."
	icon_state = "harvest"
	force = 30
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("attacks", "bashes", "tills")
	attack_verb_simple = list("attack", "bash", "till")
	hitsound = 'sound/weapons/ego/harvest.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 20		//It's 20 to keep clerks from using it
							)

/obj/item/ego_weapon/fury
	name = "blind fury"
	desc = "A fancy black and white halberd with a sharp blade. Whose head will it cut off next?"
	special = "This weapon has a slower attack speed."
	icon_state = "fury"
	force = 45
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/ego/axe2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/fury/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.5) // Slow

/obj/item/ego_weapon/paw
	name = "bear paw"
	desc = "The paws made form, and given life."
	special = "This weapon has a very fast attack speed."
	icon_state = "bear_paw"
	force = 12
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("punches", "jabs", "slaps")
	attack_verb_simple = list("punches", "jabs", "slaps")
	hitsound = 'sound/weapons/punch1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

//ATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATAT
/obj/item/ego_weapon/paw/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 0.30)
	hitsound = "sound/weapons/punch[pick(1,2,3,4)].ogg"


/obj/item/ego_weapon/wings
	name = "torn off wings"
	desc = "He stopped, gave a deep sigh, quickly tore from his shoulders the ribbon Marie had tied around him, \
		pressed it to his lips, put it on as a token, and, bravely brandishing his bare sword, \
		jumped as nimbly as a bird over the ledge of the cabinet to the floor."
	special = "This weapon has a very fast attack speed."
	icon_state = "wings"
	force = 12
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "claws")
	attack_verb_simple = list("slashes", "claws")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

//ATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATATAT
/obj/item/ego_weapon/wings/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 0.30)

/obj/item/ego_weapon/daredevil
	name = "life for a daredevil"
	desc = "An ancient sword surrounded in death, yet it's having it in your grasp that makes you feel the most alive."
	special = "This weapon blocks ranged attacks while attacking and has a parry on command."
	icon_state = "daredevil"
	force = 12
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("decimates", "bisects")
	attack_verb_simple = list("decimate", "bisect")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)
	var/attacking = FALSE
	var/parry = 0

/obj/item/ego_weapon/daredevil/melee_attack_chain(mob/user, atom/target, params)
	..()
	if (!istype(user,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/myman = user
	if (myman.getarmor(null, RED_DAMAGE) <= 0 && myman.getarmor(null, WHITE_DAMAGE) <= 0 && myman.getarmor(null, BLACK_DAMAGE) <= 0 && myman.getarmor(null, PALE_DAMAGE) <= 0)
		user.changeNext_move(CLICK_CD_MELEE * 0.33)
		attacking = TRUE
		addtimer(CALLBACK(src, .proc/drop_stance), 0.33 SECONDS)
		return
	user.changeNext_move(CLICK_CD_MELEE * 0.5)
	attacking = TRUE
	addtimer(CALLBACK(src, .proc/drop_stance), 0.5 SECONDS)

/obj/item/ego_weapon/daredevil/proc/drop_stance()
	attacking = FALSE

/obj/item/ego_weapon/daredevil/attack_self(mob/user)
	if (parry == 0)
		parry = 1
		if (!istype(user,/mob/living/carbon/human))
			return
		var/mob/living/carbon/human/myman = user
		addtimer(CALLBACK(src, .proc/disable_parry, myman), 0.5 SECONDS) // I'd do 4 or 3, but you don't KNOW when the abno is going to attack a lot of the time. They seem to have a random delay
		to_chat(user,"<span class='userdanger'>You attempt to parry the attack!</span>")

/obj/item/ego_weapon/daredevil/proc/disable_parry(mob/living/carbon/human/user)
	parry = 2
	addtimer(CALLBACK(src, .proc/parry_cooldown, user), 3 SECONDS)
	to_chat(user,"<span class='warning'>Your stance is widened.</span>")
	user.physiology.red_mod *= 1.2
	user.physiology.white_mod *= 1.2
	user.physiology.black_mod *= 1.2
	user.physiology.pale_mod *= 1.2

/obj/item/ego_weapon/daredevil/proc/parry_cooldown(mob/living/carbon/human/user)
	parry = 0
	to_chat(user,"<span class='nicegreen'>You recollect your stance</span>")
	user.physiology.red_mod /= 1.2
	user.physiology.white_mod /= 1.2
	user.physiology.black_mod /= 1.2
	user.physiology.pale_mod /= 1.2

/obj/item/ego_weapon/daredevil/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK && attacking)
		final_block_chance = 100 //Anime Katana time
		to_chat(owner,"<span class='userdanger'>A God does not fear death!</span>")
		var/mob/living/carbon/human/other = list()
		other += oview(7, owner)
		other -= owner
		for(var/mob/living/carbon/human/person in other)
			to_chat(person,"<span class='nicegreen'>[owner.real_name] deflects the projectile!</span>")
		return ..()
	if(parry == 1)
		final_block_chance = 100 // Holy shit
		for(var/mob/living/carbon/human/person in oview(7, owner))
			to_chat(person,"<span class='userdanger'>[owner.real_name] parries the attack!</span>")
	return ..()

/obj/item/ego_weapon/christmas
	name = "christmas"
	desc = "With my infinite hatred, I give you this gift."
	special = "This weapon has a slower attack speed. \
	This weapon has knockback."
	icon_state = "christmas"
	force = 50
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/infinite_hatred/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 2) // Slow

/obj/item/ego_weapon/infinite_hatred/attack(mob/living/target, mob/living/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)
