/obj/item/ego_weapon/chaosdunk
	name = "chaos dunk"
	desc = "One billion b-balls dribbling simultaneously throughout the galaxy. \
	One trillion b-balls being slam dunked through a hoop throughout the cosmos. \
	I can feel every single b-ball that has ever existed at my fingertips, I can feel their collective knowledge channeling through my veins. \
	Every jumpshot, every rebound and three-pointer, every layup, dunk, and free throw. I am there. I Am B-Ball. \
	Though I have reforged the Ultimate B-Ball, there is something I must still do. There is... another basketball that cries out for an owner. \
	No, not an owner. A companion. I must find this b-ball, save it from the depths of obscurity that it so fears."
	special = "This weapon deals incredible damage when thrown."
	icon_state = "basketball"
	inhand_icon_state = "basketball"
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 30 // It attacks very fast but is rather weak
	attack_speed = 0.5
	throwforce = 90
	throw_speed = 1
	throw_range = 10
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'
	var/activated = FALSE
	var/list/random_colors = list(
		"red" = "#FF0000",
		"blue" = "#00FF00",
		"green" = "#0000FF",
		"yellow" = "#FFFF00",
		"cyan" = "#00FFFF",
		"purple" = "#FF00FF"
	)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 100,
	)

/obj/item/ego_weapon/chaosdunk/Initialize()
	..()
	AddElement(/datum/element/update_icon_updates_onmob)
	addtimer(CALLBACK(src, PROC_REF(ChangeColors)), 5) //Call ourselves every 0.5 seconds to change color
	set_light(4, 3, "#FFFF00") //Range of 4, brightness of 3 - Same range as a flashlight
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(158, 4, 163))
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(27, 255, 6))

/obj/item/ego_weapon/chaosdunk/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(activated)
		return
	if(!CanUseEgo(user))
		to_chat(user, span_warning("The [src] lies dormant in your hands..."))
		return
	activated = TRUE

/obj/item/ego_weapon/chaosdunk/proc/ChangeColors()
	set waitfor = FALSE
	animate(src, color = pick(random_colors), time=5)
	var/f1 = filters[filters.len]
	animate(f1,offset = rand(1,5),size = rand(1,20),alpha=200,time=5)
	sleep(5)
	update_icon()
	ChangeColors()

/obj/item/ego_weapon/chaosdunk/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(!activated)
		return
	if((ishuman(hit_atom)))
		var/mob/living/carbon/M = hit_atom
		M.apply_damage(10, STAMINA)
		if(prob(75))
			M.Paralyze(60)
			visible_message(span_danger("[M] barely manages to contain the power of the [src]!"))
			return
	else
		new /obj/effect/temp_visual/explosion(get_turf(src))
		visible_message(span_danger("[src] explodes violently!"))
		playsound(src, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 45, FALSE, 5)
		for(var/mob/living/L in view(1, src))
			var/aoe = 50
			L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))
	activated = FALSE

// Curse of Violet Noon be upon thee
/obj/item/ego_weapon/violet_curse //Ignore the name dream maker doesn't handle the font well.
	name = "ᓵ⚍∷ᓭᒷ 𝙹⎓ ⍊╎𝙹ꖎᒷℸ ̣  リ𝙹𝙹リ"
	desc = "We tried to understand what would refuse to listen. \
	We reached for a shred of comprehension that they could give. \
	We stared into the dark unending abyss wishing for love and compassion. \
	In the end we recived nothing but madness, there was no hope for understanding."
	special = "This weapon can be used to perform an indiscriminate heavy red damage jump attack with enough charge. \
	This weapon will also gib on kill."
	icon_state = "violet_curse"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 180
	attack_speed = 2.5
	damtype = BLACK_DAMAGE
	hitsound = 'sound/abnormalities/apocalypse/slam.ogg'
	attack_verb_continuous = list("crushes", "devastates")
	attack_verb_simple = list("crush", "devastate")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/charge = 0
	var/charge_cost = 20
	var/dash_range = 8
	var/activated
	var/aoe = 400

/obj/item/ego_weapon/violet_curse/Initialize()
	..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/violet_curse/examine(mob/user)
	. = ..()
	. += "Current Charge: [charge]/[charge_cost]."

/obj/item/ego_weapon/violet_curse/attack_self(mob/user)
	..()
	if(!CanUseEgo(user))
		return
	if(charge>=charge_cost)
		to_chat(user, span_notice("You prepare to jump."))
		activated = TRUE
	else
		to_chat(user, span_notice("You don't have enough charge."))

/obj/item/ego_weapon/violet_curse/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	charge+=1
	if(charge>=20)
		icon_state = "violet_curse_c"
		inhand_icon_state = "violet_curse_c"
		update_icon_state()
	if(charge >= charge_cost)
		charge = charge_cost
	..()
	if(target.stat == DEAD && !(GODMODE in target.status_flags))
		target.gib()

/obj/item/ego_weapon/violet_curse/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!activated)
		return
	if(!isliving(A))
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	if(do_after(user, 5, src))
		var/turf/target = get_turf(A)
		charge -= charge_cost
		activated = FALSE
		playsound(src, 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 50, FALSE, -1)
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		user.pixel_z = 16
		ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		user.forceMove(target)
		user.Stun(2 SECONDS, ignore_canstun = TRUE) //No Moving midair
		var/obj/effect/temp_visual/warning3x3/W = new(target)
		W.color = "#8700ff"
		sleep(2 SECONDS)
		REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		JumpAttack(target,user)
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		user.pixel_z = 0
		icon_state = "violet_curse"
		inhand_icon_state = "violet_curse"
		update_icon_state()

/obj/item/ego_weapon/violet_curse/proc/JumpAttack(target, mob/living/user, proximity_flag, params)
	playsound(src, 'sound/effects/ordeals/violet/monolith_down.ogg', 65, 1)
	var/obj/effect/temp_visual/v_noon/V = new(target)
	animate(V, alpha = 0, transform = matrix()*2, time = 10)
	for(var/turf/open/T in view(2, target))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in livinginrange(2, target))
		if(L.z != user.z)
			continue
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		aoe*=force_multiplier
		if(L == user) //This WILL friendly fire there is no escape
			continue
		L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		to_chat(L, span_userdanger("You are crushed by a monolith!"))
		if(L.health < 0)
			L.gib()
