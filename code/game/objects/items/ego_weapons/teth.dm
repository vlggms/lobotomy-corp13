/obj/item/ego_weapon/training
	name = "training hammer"
	desc = "E.G.O intended for Manager Education"
	icon_state = "training"
	force = 22
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/fragment
	name = "fragments from somewhere"
	desc = "The spear often tries to lead the wielder into a long and endless realm of mind, \
	but they must try to not be swayed by it."
	icon_state = "fragment"
	force = 22
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/horn
	name = "horn"
	desc = "As the horn digs deep into the enemy's heart, it will turn blood red to show off the glamor that she couldn't in her life."
	icon_state = "horn"
	force = 22
	throwforce = 50		//You can only hold two so go nuts.
	throw_speed = 5
	throw_range = 7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/shield/lutemia
	name = "dear lutemia"
	desc = "Don't you want your cares to go away?"
	icon_state = "lutemia"
	force = 22
	attack_speed = 1
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	reductions = list(10, 30, 20, 0) // 60
	projectile_block_duration = 0 SECONDS //No ranged parry
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/parry.ogg'
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."

/obj/item/ego_weapon/shield/lutemia/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	return 0 //Prevents ranged  parry

/obj/item/ego_weapon/eyes
	name = "red eyes"
	desc = "It is likely able to hear, touch, smell, as well as see. And most importantly, taste."
	special = "Knocks certain enemies backwards."
	icon_state = "eyes"
	force = 35					//Still less DPS, replaces baseball bat
	attack_speed = 1.6
	damtype = RED_DAMAGE
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'

/obj/item/ego_weapon/eyes/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/mini/wrist
	name = "wrist cutter"
	desc = "The flesh cleanly cut by a sharp tool creates a grotesque pattern with the bloodstains on the suit."
	special = "Use this weapon in hand to dodgeroll."
	icon_state = "wrist"
	force = 7
	attack_speed = 0.3
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
	var/dodgelanding

/obj/item/ego_weapon/mini/wrist/attack_self(mob/living/carbon/user)
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(20, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

/obj/item/ego_weapon/regret
	name = "regret"
	desc = "Before swinging this weapon, expressing one’s condolences for the demise of the inmate who couldn't even have a funeral would be nice."
	icon_state = "regret"
	force = 38				//Lots of damage, way less DPS
	damtype = RED_DAMAGE
	attack_speed = 2 // Really Slow. This is the slowest teth we have, +0.4 to Eyes 1.6
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")
	hitsound = 'sound/weapons/fixer/generic/club3.ogg'

/obj/item/ego_weapon/mini/blossom
	name = "cherry blossoms"
	desc = "The flesh cleanly cut by a sharp tool creates a grotesque pattern with the bloodstains on the suit."
	special = "Upon throwing, this weapon returns to the user."
	icon_state = "blossoms"
	force = 17
	throwforce = 30
	throw_speed = 1
	throw_range = 7
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/mini/blossom/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, /atom/movable.proc/throw_at, thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/cute
	name = "SO CUTE!!!"
	desc = "One may think, 'How can a weapon drawn from such a cute Abnormality be any good?' \
		However, the claws are actually quite durable and sharp."
	icon_state = "cute"
	force = 13
	attack_speed = 0.5
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'

/obj/item/ego_weapon/mini/trick
	name = "hat trick"
	desc = "Imagination is the only weapon in the war with reality."
	icon_state = "trick"
	force = 16
	throwforce = 35		//You can only hold 4 so go nuts.
	throw_speed = 5
	throw_range = 7
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("jabs")
	attack_verb_simple = list("jabs")
	hitsound = 'sound/weapons/slashmiss.ogg'

/obj/item/ego_weapon/sorrow
	name = "sorrow"
	desc = "It all returns to nothing."
	special = "Use this weapon in hand to take damage and teleport to a random department."
	icon_state = "sorrow"
	force = 32					//Bad DPS, can teleport
	attack_speed = 1.5
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleave", "cut")
	hitsound = 'sound/weapons/fixer/generic/blade4.ogg'

/obj/item/ego_weapon/sorrow/attack_self(mob/living/user)
	var/area/turf_area = get_area(get_turf(user))
	if(istype(turf_area, /area/fishboat))
		to_chat(user, "<span class='warning'>[src] will not work here!.</span>")
		return
	if(do_after(user, 50, src))	//Five seconds of not doing anything, then teleport.
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(user))
		user.adjustBruteLoss(user.maxHealth*0.3)

		//teleporting half
		var/turf/T = pick(GLOB.department_centers)
		user.forceMove(T)
		new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(user))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)

/obj/item/ego_weapon/sorority
	name = "sorority"
	desc = "Look to your sisters, and fight in sorority."
	special = "Use this weapon in hand to deal a small portion of damage to people around you and heal their sanity slightly."
	icon_state = "sorority"
	force = 17					//Also a support weapon
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("zaps", "prods")
	attack_verb_simple = list("zap", "prod")
	hitsound = 'sound/weapons/fixer/generic/baton4.ogg'

/obj/item/ego_weapon/sorority/attack_self(mob/user)
	if(do_after(user, 10, src))	//Just a second to heal people around you, but it also harms them
		playsound(src, 'sound/weapons/taser.ogg', 200, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(2, get_turf(user)))
			L.adjustBruteLoss(L.maxHealth*0.1)
			L.adjustSanityLoss(-10)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

/obj/item/ego_weapon/mini/bean
	name = "magic bean"
	desc = "We may never find out what lies at the top, but perhaps those who made it are doing well up there."
	icon_state = "bean"
	force = 20
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'

/obj/item/ego_weapon/hearth //From my sweet home.
	name = "hearth"
	desc = "Home sweet home. Warmth and safety aplenty."
	special = "This weapon has a ranged attack."
	icon_state = "hearth"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	var/icon_on = "hearth_glow"
	var/icon_off = "hearth"
	force = 18
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("swipes", "slashes")
	attack_verb_simple = list("swipe", "slash")
	hitsound = 'sound/weapons/fixer/generic/sword3.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 20
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 1.3 SECONDS
	var/ranged_damage = 20

	//light_system = MOVABLE_LIGHT_DIRECTIONAL
	//light_color = COLOR_ORANGE
	//light_range = 4
	//light_power = 5
	//light_on = FALSE

/obj/item/ego_weapon/hearth/proc/IconOff()
	icon_state = icon_off
	//light_on = FALSE

/obj/item/ego_weapon/hearth/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || !(target_turf in view(5, user)))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	icon_state = icon_on
	//light_on = TRUE
	addtimer(CALLBACK(src, .proc/IconOff), 20)
	playsound(target_turf, 'sound/weapons/pulse.ogg', 50, TRUE)
	var/damage_dealt = 0
	for(var/turf/open/T in range(target_turf, 0))
		new /obj/effect/temp_visual/smash1(T)
		for(var/mob/living/L in user.HurtInTurf(T, list(), ranged_damage, BLACK_DAMAGE, hurt_mechs = TRUE))
			if((L.stat < DEAD) && !(L.status_flags & GODMODE))
				damage_dealt += ranged_damage

/obj/effect/temp_visual/smash1
	icon = 'icons/effects/effects.dmi'
	icon_state = "smash1"
	duration = 3

#define LANTERN_MODE_REMOTE 1
#define LANTERN_MODE_AUTO 2

/obj/item/ego_weapon/lantern //meat lantern
	name = "lantern"
	desc = "Teeth sticking out of some spots of the equipment is a rather frightening sight."
	special = "Attack nearby turfs to create traps. Remote mode can trigger traps from a distance. \
	Automatic mode places traps that trigger when enemies walk over them. Use in hand to switch between modes."
	icon_state = "lantern"
	force = 8 //less than the baton, don't hit things with it
	damtype = BLACK_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'
	var/mode = LANTERN_MODE_REMOTE
	var/traplimit = 6
	var/list/traps = list()

/obj/item/ego_weapon/lantern/attack_self(mob/user)
	if(mode == LANTERN_MODE_REMOTE)
		to_chat(user, "<span class='info'>You adjust any newly-placed traps to be set off by motion.</span>")
		mode = LANTERN_MODE_AUTO
	else
		to_chat(user, "<span class='info'>You can now remotely trigger any placed traps.</span>")
		mode = LANTERN_MODE_REMOTE

/obj/item/ego_weapon/lantern/proc/CreateTrap(target, mob/user, proximity_flag)
	var/turf/T = get_turf(target)
	if((get_dist(user, T) > 20))
		return
	var/obj/effect/temp_visual/lanterntrap/R = locate(/obj/effect/temp_visual/lanterntrap) in T
	if(R)
		if(!proximity_flag && mode != LANTERN_MODE_REMOTE)
			return
		R.burst()
		return
	if(proximity_flag && (LAZYLEN(traps) < traplimit))
		new /obj/effect/temp_visual/lanterntrap(T, user, src, mode)
		user.changeNext_move(CLICK_CD_MELEE)

/obj/item/ego_weapon/lantern/afterattack(atom/target, mob/living/user, proximity_flag, params)
	if(check_allowed_items(target, 1))
		CreateTrap(target, user, proximity_flag)
	. = ..()

/obj/effect/temp_visual/lanterntrap
	name = "lantern trap"
	icon_state = "shield1" //temp visual
	layer = ABOVE_ALL_MOB_LAYER
	duration = 30 SECONDS
	var/resonance_damage = 35
	var/damage_multiplier = 1
	var/mob/creator
	var/obj/item/ego_weapon/lantern/res
	var/rupturing = FALSE //So it won't recurse

/obj/effect/temp_visual/lanterntrap/Initialize(mapload, set_creator, set_resonator, mode)
	if(mode == LANTERN_MODE_AUTO)
		icon_state = "shield2" //temp visual
		resonance_damage = 25
		RegisterSignal(src, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ENTERED), .proc/burst)
	. = ..()
	creator = set_creator
	res = set_resonator
	if(res)
		res.traps += src
	playsound(src,'sound/weapons/resonator_fire.ogg',50,TRUE)
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, .proc/burst), duration, TIMER_STOPPABLE)

/obj/effect/temp_visual/lanterntrap/Destroy()
	if(res)
		res.traps -= src
		res = null
	creator = null
	. = ..()

/obj/effect/temp_visual/lanterntrap/proc/burst()
	rupturing = TRUE
	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/resonance_crush(T) //temp visual
	playsound(T,'sound/weapons/resonator_blast.ogg',50,TRUE)

	for(var/mob/living/L in creator.HurtInTurf(T, list(), resonance_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
		to_chat(L, "<span class='userdanger'>[src] bites you!</span>")
		if(creator)
			creator.visible_message("<span class='danger'>[creator] activates [src] on [L]!</span>","<span class='danger'>You activate [src] on [L]!</span>", null, COMBAT_MESSAGE_RANGE, L)
	for(var/obj/effect/temp_visual/lanterntrap/field in range(1, src))
		if(field != src && !field.rupturing)
			field.burst()
	qdel(src)

#undef LANTERN_MODE_REMOTE
#undef LANTERN_MODE_AUTO

/obj/item/ego_weapon/sloshing
	name = "sloshing"
	desc = "It hits just right! Let's help ourselves to some wine when we come back!"
	icon_state = "sloshing"
	force = 38
	attack_speed = 2
	damtype = WHITE_DAMAGE
	hitsound = 'sound/abnormalities/fairygentleman/ego_sloshing.ogg'
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")

/obj/item/ego_weapon/red_sheet
	name = "red sheet"
	desc = "A bo staff covered in talismans. Despite being tightly glued to the weapon, they flutter about as you strike."
	special = "Attacking an enemy multiple times will attach a talisman to them, raising their BLACK vulnerability."
	icon_state = "red_sheet"
	force = 22
	damtype = BLACK_DAMAGE
	hitsound = 'sound/abnormalities/nocry/ego_redsheet.ogg'
	var/hit_count = 0

/obj/item/ego_weapon/red_sheet/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(target))
		++hit_count
		if(hit_count >= 4)
			var/mob/living/simple_animal/M = target
			if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rend_black))
				playsound(src, 'sound/abnormalities/so_that_no_cry/curse_talisman.ogg', 100, 1)
				to_chat(user, "A talisman from [src] sticks onto [target]!")
				new /obj/effect/temp_visual/talisman(get_turf(M))
				M.apply_status_effect(/datum/status_effect/rend_black)
				hit_count = 0

/obj/item/ego_weapon/shield/capote
	name = "capote"
	desc = "Charge me with all your strength! Your horns cannot pierce my soul!"//yes this is a SMT quote
	icon_state = "capote"
	worn_icon = 'icons/obj/clothing/belt_overlays.dmi'
	worn_icon_state = "capote"
	force = 22
	attack_speed = 1
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	reductions = list(20, 20, 20, 0)
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/fixer/generic/dodge.ogg'
	block_message = "You attempt to dodge the attack!"
	hit_message = "avoids a direct hit!"
	block_cooldown_message = "You catch your breath."

/obj/item/ego_weapon/mini/fourleaf_clover
	name = "four-leaf clover"
	desc = "A weapon fit for those that would backstab someone after gaining their trust."
	special = "This weapon gains 1 poise for every attack. 1 poise gives you a 2% chance to crit at 3x damage, stacking linearly. Critical hits reduce poise to 0."
	icon_state = "fourleaf_clover"
	force = 12
	attack_speed = 0.5
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
	var/poise = 0

/obj/item/ego_weapon/mini/fourleaf_clover/examine(mob/user)
	. = ..()
	. += "Current Poise: [poise]/20."

/obj/item/ego_weapon/mini/fourleaf_clover/attack(mob/living/target, mob/living/carbon/human/user)
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

/obj/item/ego_weapon/zauberhorn
	name = "zauberhorn"
	desc = "Falada, Falada, thou art dead, and all the joy in my life has fled."
	special = "This E.G.O. functions as both a gun and a melee weapon."
	icon_state = "zauberhorn"
	force = 10
	damtype = BLACK_DAMAGE
	attack_speed = 0.5
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'

	var/gun_cooldown
	var/gun_cooldown_time = 1.2 SECONDS

/obj/item/ego_weapon/zauberhorn/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, .proc/projectile_hit)
	..()

/obj/item/ego_weapon/zauberhorn/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/ego_bullet/zauberhorn/G = new /obj/projectile/ego_bullet/zauberhorn(proj_turf)
		G.fired_from = src //for signal check
		playsound(user, 'sound/abnormalities/pagoda/throw.ogg', 100, TRUE) //yes im reusing a sound bite me
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		G.damage*=force_multiplier
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/zauberhorn/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE

/obj/projectile/ego_bullet/zauberhorn
	name = "flying horseshoe"
	icon_state = "horseshoe"
	hitsound = 'sound/weapons/fixer/generic/club3.ogg'
	damage = 20
	damage_type = BLACK_DAMAGE

/obj/item/ego_weapon/sanitizer
	name = "sanitizer"
	desc = "It's very shocking."
	special = "Knocks certain enemies backwards."
	icon_state = "sanitizer"
	force = 35					//Still less DPS, replaces baseball bat
	attack_speed = 1.6
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'

/obj/item/ego_weapon/sanitizer/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/lance/curfew
	name = "curfew"
	desc = "The thing itself had never forgotten its glory days."
	icon_state = "curfew"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 22
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.8// really slow
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/fixer/generic/spear2.ogg'
