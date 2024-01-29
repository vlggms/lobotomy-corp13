/obj/item/slime_extract
	var/sparkly = FALSE //if true, cargo gets 2x the money for them

/mob/living/simple_animal/slime
// Transformative extract effects - get passed down
	var/transformeffects = SLIME_EFFECT_DEFAULT
	var/effectsapplied = 0 //for use in the slime scanner

/mob/living/simple_animal/slime/attack_ghost(mob/user)
	. = ..()
	if(. || !(GLOB.ghost_role_flags & GHOSTROLE_SPAWNER))
		return
	if (transformeffects & SLIME_EFFECT_RAINBOW)
		humanize_slime(user)

/mob/living/simple_animal/slime/proc/humanize_slime(mob/user)
	if(key || stat)
		return
	var/slime_ask = alert("Become a slime?", "Slime time?", "Yes", "No")
	if(slime_ask == "No" || QDELETED(src))
		return
	if(key)
		to_chat(user, span_warning("Someone else already took this slime!"))
		return
	key = user.key
	log_game("[key_name(src)] took control of [name].")

/mob/living/simple_animal/slime/proc/make_baby(drop_loc, new_adult, new_nutrition, new_powerlevel, force_original_colour=FALSE, step_away=TRUE,datum/component/nanites/original_nanites=null)
	var/child_colour = colour
	if (!force_original_colour)
		if(mutation_chance >= 100)
			child_colour = "rainbow"
		else if(prob(mutation_chance))
			child_colour = slime_mutation[rand(1,4)]
		else
			child_colour = colour
	var/mob/living/simple_animal/slime/M
	M = new(drop_loc, child_colour, new_adult)
	M.transformeffects = transformeffects
	M.effectsapplied = effectsapplied
	if(ckey || transformeffects & SLIME_EFFECT_CERULEAN)
		M.set_nutrition(new_nutrition) //Player slimes are more robust at spliting. Once an oversight of poor copypasta, now a feature!
	M.powerlevel = new_powerlevel
	if (transformeffects & SLIME_EFFECT_DARK_PURPLE)
		M.cores = cores
	if (transformeffects & SLIME_EFFECT_METAL)
		M.maxHealth = round(M.maxHealth * 1.5)
		M.health = M.maxHealth
	if (transformeffects & SLIME_EFFECT_PINK)
		M.grant_language(/datum/language/common, TRUE, TRUE)
	if (transformeffects & SLIME_EFFECT_RED)
		M.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/slime_redmod, multiplicative_slowdown = -1)
	M.Friends = Friends.Copy()
	if(step_away)
		step_away(M,src)
	M.mutation_chance = clamp(mutation_chance+(rand(5,-5)),0,100)
	SSblackbox.record_feedback("tally", "slime_babies_born", 1, M.colour)
	if(original_nanites)
		M.AddComponent(/datum/component/nanites, original_nanites.nanite_volume*0.25)
		SEND_SIGNAL(M, COMSIG_NANITE_SYNC, original_nanites, TRUE, TRUE) //The trues are to copy activation as well
	return M

/datum/movespeed_modifier/slime_redmod
	variable = TRUE
