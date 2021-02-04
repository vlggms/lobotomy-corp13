#define FLYING_AXEKICK_COMBO "HD" //Flying Axe Kick - Deals Brute and causes bleeding. Costs 20 Stamina.
#define GOAT_HEADBUTT_COMBO "DG" //Goat Headbutt - Deals Brute and Stuns, in exchange for causing Brute to the user. Costs 40 Stamina.
#define FULL_THRUST_COMBO "GH" //Full Thrust - Deals Brute and has a chance to knock the opponent down. Costs 50 Stamina.
#define MINOR_IRIS_COMBO "HHH" //Minor Iris - Deals a ton of armor penetrating slash brute. Costs 80 Stamina.

/datum/martial_art/velvetfu
	name = "Velvet-Fu"
	id = MARTIALART_VELVETFU
	allow_temp_override = FALSE
	smashes_tables = TRUE
	help_verb = /mob/living/carbon/human/proc/velvetfu_help
	var/datum/action/receding_stance/recedingstance = new/datum/action/receding_stance()
	var/datum/action/twisted_stance/twistedstance = new/datum/action/twisted_stance()

/datum/martial_art/velvetfu/teach(mob/living/carbon/human/H, make_temporary=0)
	if(..())
		to_chat(H, "<span class='userdanger'>You've mastered the arts of Velvet-Fu!</span>")
		recedingstance.Grant(H)
		twistedstance.Grant(H)

/datum/martial_art/velvetfu/on_remove(mob/living/carbon/human/H)
	to_chat(H, "<span class='userdanger'>You've forgotten the arts of Velvet-Fu...'</span>")
	recedingstance.Remove(H)
	twistedstance.Remove(H)

/datum/martial_art/velvetfu/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	switch(streak)
		if("receding_stance")
			streak = ""
			receding_stance(A,D)
			return TRUE
		if("twisted_stance")
			streak = ""
			twisted_stance(A,D)
			return TRUE
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

// Receding Stance
/datum/action/receding_stance
	name = "Receding Stance - Regenerates Stamina, takes time to do."
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "receding_stance"

/datum/action/receding_stance/Trigger(mob/living/M, mob/living/user)
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't do stances while incapacitated..</span>")
		return
	var/mob/living/carbon/human/H = owner
	if(H.mind.martial_art.streak == "receding_stance")
		owner.visible_message("<span class='danger'>[owner] stops moving back.</i></b>")
		H.mind.martial_art.streak = ""
	else
		owner.visible_message("<span class='danger'>[owner] moves back and begins to form a stance.</span>", "<b><i>You backpedal and begin to form your stance.</i></b>")
		if(do_after(H, 3 SECONDS))
			owner.visible_message("<span class='danger'>[owner] focuses on his stance.</span>", "<b><i>You focus on your stance. Stamina...</i></b>")
			H.adjustStaminaLoss(-30)
			H.mind.martial_art.streak = "receding_stance"
		else
			owner.visible_message("<span class='danger'>[owner] stops moving back.</i></b>")
			H.mind.martial_art.streak = ""
			return

/datum/martial_art/velvetfu/proc/receding_stance(mob/living/carbon/human/A)
	A.mind.martial_art.streak = ""

// Twisted Stance
/datum/action/twisted_stance
	name = "Twisted Stance - Regenerates a lot of stamina, deals brute damage."
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "twisted_stance"

/datum/action/twisted_stance/Trigger(mob/living/M, mob/living/user)
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't do stances while incapacitated..</span>")
		return
	var/mob/living/carbon/human/H = owner
	if(H.mind.martial_art.streak == "twisted_stance")
		owner.visible_message("<span class='danger'>[owner] untwists himself.</i></b>")
		H.mind.martial_art.streak = ""
	else
		if(do_after(H, 0.1 SECONDS))
			owner.visible_message("<span class='danger'>[owner] suddenly twists and turns, what a strange stance!</span>", "<b>You twist and turn, your ultimate stance is done!</b>")
			H.adjustStaminaLoss(-60)
			H.apply_damage(16, BRUTE)
			H.mind.martial_art.streak = "twisted_stance"
		else
			owner.visible_message("<span class='danger'>[owner] untwists himself.</i></b>")
			H.mind.martial_art.streak = ""
			return

/datum/martial_art/velvetfu/proc/twisted_stance(mob/living/carbon/human/A)
	A.mind.martial_art.streak = ""

//Flying Axe Kick - Deals Brute and causes bleeding. Costs 20 Stamina.
/datum/martial_art/velvetfu/proc/flyingAxekick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	log_combat(A, D, "flying kick (Velvet-Fu)")
	D.visible_message("<span class='danger'>[A] flying kicked [D], such skill!</span>", \
					"<span class='userdanger'>Your neck is flying kicked by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You flying kick [D]!</span>")
	A.adjustStaminaLoss(20)
	D.apply_damage(10, BRUTE)
	var/obj/item/bodypart/bodypart = pick(D.bodyparts)
	var/datum/wound/slash/severe/crit_wound = new
	crit_wound.apply_wound(bodypart)
	playsound(get_turf(A), 'sound/weapons/slice.ogg', 50, TRUE, -1)
	return TRUE

//Goat Headbutt - Deals Brute and Stuns, in exchange for causing Brute to the user. Costs 40 Stamina.
/datum/martial_art/velvetfu/proc/goatHeadbutt(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	log_combat(A, D, "goat headbutt (Velvet-Fu)")
	D.visible_message("<span class='danger'>[A] headbutted [D]!</span>", \
					"<span class='userdanger'>You're headbutted by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You swiftly headbutt [D]!</span>")
	D.apply_damage(8, BRUTE)
	D.Stun(3 SECONDS)
	A.apply_damage(15, BRUTE)
	A.adjustStaminaLoss(40)
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	return TRUE

//Full Thrust - Deals Brute and has a chance to knock the opponent down. Costs 50 Stamina.
/datum/martial_art/velvetfu/proc/fullThrust(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	log_combat(A, D, "full thrust (Velvet-Fu)")
	D.visible_message("<span class='danger'>[A] thrusted into [D]!</span>", \
					"<span class='userdanger'>You're thrusted by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You quickly and fashionably thrust into [D]!</span>")
	A.adjustStaminaLoss(40)
	D.apply_damage(20, BRUTE)
	if(prob(50))
		D.Knockdown(20)
	playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
	return TRUE

//Minor Iris - Deals a ton of armor penetrating slash brute. Costs 80 Stamina.
/datum/martial_art/velvetfu/proc/minorIris(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	log_combat(A, D, "minor iris (Velvet-Fu)")
	D.visible_message("<span class='danger'>[A] slashes [D] rapidly and repeatedly!</span>", \
					"<span class='userdanger'>You're slashed several times by [A]!</span>", "<span class='hear'>You hear several sickening sounds of flesh slashing flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You swiftly and repeatedly slash at [D], truly a master attack!</span>")
	A.adjustStaminaLoss(80)
	D.apply_damage(40, BRUTE)
	var/obj/item/bodypart/bodypart = pick(D.bodyparts)
	var/datum/wound/slash/moderate/crit_wound = new
	crit_wound.apply_wound(bodypart)
	playsound(get_turf(A), 'sound/weapons/bladeslice.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/velvetfu/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "harmed (Velvet-Fu)")
	A.do_attack_animation(D)
	var/picked_hit_type = "silken wrist"
	var/bonus_damage = 10
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "iron hooved"
	D.apply_damage(bonus_damage, BRUTE)
	D.visible_message("<span class='danger'>[A] [picked_hit_type]ed [D]!</span>", \
					"<span class='userdanger'>You're [picked_hit_type]ed by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You [picked_hit_type] [D]!</span>")
	playsound(D, 'sound/weapons/punch1.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/velvetfu/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "grabbed (Velvet-Fu)")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("ascending claw", "descending claw")
	var/bonus_damage = 10
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "iron hooved"
	D.apply_damage(bonus_damage, BRUTE)
	D.visible_message("<span class='danger'>[A] [picked_hit_type]ed [D]!</span>", \
					"<span class='userdanger'>You're [picked_hit_type]ed by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You [picked_hit_type] [D]!</span>")
	playsound(D, 'sound/weapons/punch1.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/velvetfu/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("D",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "disarmed (Velvet-Fu)")
	A.do_attack_animation(D)
	var/picked_hit_type = "side kick"
	var/bonus_damage = 10
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "iron hooved"
	D.apply_damage(bonus_damage, BRUTE)
	D.visible_message("<span class='danger'>[A] [picked_hit_type]ed [D]!</span>", \
					"<span class='userdanger'>You're [picked_hit_type]ed by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>You [picked_hit_type] [D]!</span>")
	playsound(D, 'sound/weapons/punch1.ogg', 50, TRUE, -1)
	return TRUE

/mob/living/carbon/human/proc/velvetfu_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of Velvet-Fu."
	set category = "Velvet-Fu"

	to_chat(usr, "<b><i>You try to remember the VHS tapes of Velvet-Fu...</i></b>\n\

	<span class='notice'>Iron Hoof</span>: Disarm/Grab/Harm while opponent is down.\n\
	<span class='notice'>Flying Axe Kick</span>: Harm Disarm. Deals damage and causes bleeding. Costs 20 Stamina.\n\
	<span class='notice'>Goat Headbutt</span>: Disarm Grab. Deals brute while stunning your opponent, but hurts you. Costs 40 Stamina.\n\
	<span class='notice'>Full Thrust</span>: Grab Harm. Deals brute and has a chance to knock your opponent down. Costs 50 Stamina.\n\
	<span class='notice'>Minor Iris</span>: Harm Harm Harm. Devastatingly slashes your opponent. Costs 80 Stamina.\n\

	<span class='notice'>Receding Stance</span>: Regenerates 30 Stamina. Requires standing still.\n\
	<span class='notice'>Twisted Stance</span>: Regenerates 60 Stamina. Deals brute damage.</span>")

/obj/item/book/granter/martial/velvetfu
	martial = /datum/martial_art/velvetfu
	name = "Velvet-Fu cassette"
	martialname = "velvet-fu"
	desc = "A cassette labelled 'Grand-Master's Course'. This seems modified, causing it to beam the content straight into your brain."
	icon_state = "tape_white"
	icon = 'icons/obj/device.dmi'
	inhand_icon_state = "analyzer"
	greet = "You've finished watching the Velvet-Fu cassette."
	remarks = list("Smooth as Velvet...", "Show me your stance!", "Left Jab!", "Right Jab!", "Kick, kick!", "Ah, so fast...", "Now forget the basics!",)

/obj/item/book/granter/martial/velvetfu/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "A cassette labelled 'Grand-Master's Course'. This seems modified, and won't turn on."
		name = "Used cassette"
