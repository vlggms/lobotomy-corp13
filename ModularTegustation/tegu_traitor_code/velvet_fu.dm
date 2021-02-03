#define FLYING_AXEKICK_COMBO "HD" //Flying Axe Kick - deals brute and causes bleeding
#define GOAT_HEADBUTT_COMBO "DHG" //Goat Headbutt - deals brute and stuns, in exchange for harming the user
#define FULL_THRUST_COMBO "HHH" //Full Thrust - deals brute and has a chance to knock the opponent down
#define MINOR_IRIS_COMBO "DHH" //Minor Iris - deals a ton of slash brute

/datum/martial_art/velvetfu
	name = "Velvet-Fu"
	id = MARTIALART_VELVETFU
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/velvetfu_help
	var/datum/action/stance/recending = new/datum/action/receding_stance()
	var/datum/action/stance/twisted = new/datum/action/twisted_stance()

/datum/martial_art/velvetfu/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	if(findtext(streak,FLYING_AXEKICK_COMBO))
		streak = ""
		flyingAxekick(A,D)
		return TRUE
	if(findtext(streak,GOAT_HEADBUTT_COMBO))
		streak = ""
		goatHeadbutt(A,D)
		return TRUE
	if(findtext(streak,FULL_THRUST_COMBO))
		streak = ""
		fullThrust(A,D)
		return TRUE
	if(findtext(streak,MINOR_IRIS_COMBO))
		streak = ""
		minorIris(A,D)
	return FALSE

/datum/action/receding_stance
	name = "Receding Stance - Regenerates Stamina, takes time to do."
	button_icon_state = "receding_stance"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'

/datum/action/receding_stance/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't do stances while incapacitated.</span>")
		return
	if(do_after(3 SECONDS))
		owner.visible_message("<span class='danger'>[owner] focuses on his stance.</span>", "<b><i>You focus on your stance. Stamina...</i></b>")
		owner.adjustStaminaLoss(-30)
	return

/datum/action/twisted_stance
	name = "Twisted Stance - Regenerates a lto of stamina, deals brute damage."
	button_icon_state = "twisted_stance"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'

/datum/action/twisted_stance/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't do stances while incapacitated.</span>")
		return
	owner.visible_message("<span class='danger'>[owner] suddenly twists and turns, what a strange stance!</span>", "<b>You twist and turn, your ultimate stance!</b>")
	owner.adjustStaminaLoss(-60)
	owner.apply_damage(25, BRUTE)
	return

H.adjustStaminaLoss(25)
H.Paralyze(15)

//Flying Axe Kick - deals brute and causes bleeding
/datum/martial_art/velvetfu/proc/flyingAxekick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return
//Goat Headbutt - deals brute and stuns, in exchange for harming the user
/datum/martial_art/velvetfu/proc/goatHeadbutt(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return
//Full Thrust - deals brute and has a chance to knock the opponent down
/datum/martial_art/velvetfu/proc/fullThrust(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return
//Minor Iris - deals a ton of slash brute
/datum/martial_art/velvetfu/proc/minorIris(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return

/datum/martial_art/velvetfu/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "harmed (Velvet-Fu)")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("silken wrist")
	var/bonus_damage = 10
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "iron hooved"
	D.apply_damage(bonus_damage, BRUTE)
	D.visible_message("<span class='danger'>[A] [picked_hit_type]ed [D]!</span>", \
					"<span class='userdanger'>You're [picked_hit_type]ed by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You [picked_hit_type] [D]!</span>")
	return TRUE

/datum/martial_art/velvetfu/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "grabbed (Velvet-Fu)")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("ascending claw")
	var/bonus_damage = 10
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "iron hooved"
	D.apply_damage(bonus_damage, BRUTE)
	D.visible_message("<span class='danger'>[A] [picked_hit_type]ed [D]!</span>", \
					"<span class='userdanger'>You're [picked_hit_type]ed by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You [picked_hit_type] [D]!</span>")
	return TRUE

/datum/martial_art/velvetfu/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "disarmed (Velvet-Fu)")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("side kick")
	var/bonus_damage = 10
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "iron hooved"
	D.apply_damage(bonus_damage, BRUTE)
	D.visible_message("<span class='danger'>[A] [picked_hit_type]ed [D]!</span>", \
					"<span class='userdanger'>You're [picked_hit_type]ed by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You [picked_hit_type] [D]!</span>")
	return TRUE

/mob/living/carbon/human/proc/velvetfu_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of Velvet-Fu."
	set category = "Velvet-Fu"

	to_chat(usr, "<b><i>You try to remember the VHS tapes of Velvet-Fu...</i></b>")

	to_chat(usr, "<span class='notice'>Flying Axe Kick</span>: Harm Disarm. Deals damage and causes bleeding. Costs 20 Stamina.")
	to_chat(usr, "<span class='notice'>Iron Hoof</span>: Disarm/Grab/Harm while opponent is down. Deals brute at no cost.")
	to_chat(usr, "<span class='notice'>Goat Headbutt</span>: Disarm Harm Grab. Deals brute while stunning your opponent, but hurts you. Costs 40 Stamina.")
	to_chat(usr, "<span class='notice'>Full Thrust</span>: Harm Harm Harm. Deals brute and has a chance to knock your opponent down. Costs 50 Stamina.")
	to_chat(usr, "<span class='notice'>Minor Iris</span>: Disarm Harm Harm. Devastatingly slashes your opponent. Costs 80 Stamina.")

	to_chat(usr, "<span class='notice'>Receding Stance</span>: Regenerates 30 Stamina. Requires standing still.")
	to_chat(usr, "<span class='notice'>Twisted Stance</span>: Regenerates 60 Stamina. Deals brute damage.")
