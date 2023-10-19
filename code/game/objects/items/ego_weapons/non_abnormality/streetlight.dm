//Streetlight stuff, this is all Grade 7 teth stuff, leader is grade 6.
//They're generic weapons for the refinery, which is fine
/obj/item/ego_weapon/city/streetlight_greatsword
	name = "streetlight greatsword"
	desc = "A greatsword used by a fixer with big shoes to fill.'Maybe... I should have told her how I felt.'"
	icon_state = "streetlight_greatsword"
	force = 38
	attack_speed = 2
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

/obj/item/ego_weapon/city/streetlight_bat
	name = "streetlight office bat"
	desc = "A yellow and black bat, its metal is warm to the touch. Is it with the warmth of friends, or the hatred of those who've had something taken from them?"
	icon_state = "streetlight_bat"
	force = 30
	attack_speed = 1.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

/obj/item/ego_weapon/city/streetlight_bat/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//He has zwei moves in his 2nd iteration, give it to him here.
/obj/item/ego_weapon/city/zweihander/streetlight_baton
	name = "streetlight office baton"
	desc = "A  baton compatible with Zwei techniques. It carries a sense of regret..."
	icon_state = "streetlight_founder"
	inhand_icon_state = "streetlight_founder"
	force = 32
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	defense_buff_self = 0.6
	defense_buff_others = 0.9
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
