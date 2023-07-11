/obj/item/durandal
	name = "durandal"
	desc = "Greatsword. Description missing. Go kill something, will you?"
	icon_state = "claymore"
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	color = "#444444" // Because I can and it's temporary
	hitsound = 'sound/weapons/fixer/durandal1.ogg'
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 60
	throwforce = 20
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("slashes", "slices")
	attack_verb_simple = list("slash", "slice")

	var/attack_variation = 0
	var/attack_strong_cooldown
	var/attack_strong_cooldown_time = 10 SECONDS

/obj/item/durandal/attack_self(mob/living/carbon/user)
	if(attack_strong_cooldown > world.time)
		to_chat(user, "<span class='warning'>You are not ready to perform strong attack yet!</span>")
		return
	if(attack_variation == 2)
		attack_variation = 0
		to_chat(user, "<span class='notice'>You decide to use normal attacks for now.</span>")
		return
	attack_variation = 2
	to_chat(user, "<span class='notice'>You prepare a strong attack.</span>")

/obj/item/durandal/attack(mob/living/M, mob/living/user)
	var/old_force = force
	switch(attack_variation)
		if(1)
			hitsound = 'sound/weapons/fixer/durandal2.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 1.2)
			force *= 1.25
			attack_variation = 0
		if(2)
			hitsound = 'sound/weapons/fixer/durandal_strong.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 2)
			force *= 3
			attack_variation = 4
			attack_strong_cooldown = world.time + attack_strong_cooldown_time
		else
			hitsound = 'sound/weapons/fixer/durandal1.ogg'
			attack_variation = 1
	..()
	force = old_force
	if(attack_variation == 4)
		var/turf/slash_start = get_turf(user)
		var/dir_to_target = get_dir(user, M)
		var/turf/slash_end = get_step(get_step(user, dir_to_target), dir_to_target) // Funny code
		if(slash_end.density)
			return
		var/datum/beam/B = slash_start.Beam(slash_end, "blur", time=5)
		B.visuals.color = COLOR_BLACK
		animate(B.visuals, alpha = 0, time = 5)
		user.forceMove(slash_end)
		attack_variation = 0
