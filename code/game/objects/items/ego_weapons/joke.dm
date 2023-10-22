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
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/chaosdunk/Initialize()
	..()
	AddElement(/datum/element/update_icon_updates_onmob)
	addtimer(CALLBACK(src, .proc/ChangeColors), 5) //Call ourselves every 0.5 seconds to change color
	set_light(4, 3, "#FFFF00") //Range of 4, brightness of 3 - Same range as a flashlight
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(158, 4, 163))
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(27, 255, 6))

/obj/item/ego_weapon/chaosdunk/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(activated)
		return
	if(!CanUseEgo(user))
		to_chat(user, "<span class='warning'>The [src] lies dormant in your hands...</span>")
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
			visible_message("<span class='danger'>[M] barely manages to contain the power of the [src]!</span>")
			return
	else
		new /obj/effect/temp_visual/explosion(get_turf(src))
		visible_message("<span class='danger'>[src] explodes violently!</span>")
		playsound(src, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 45, FALSE, 5)
		for(var/mob/living/L in view(1, src))
			var/aoe = 50
			L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))
	activated = FALSE
