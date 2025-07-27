//Butcher
/obj/item/book/granter/action/skill/butcher
	granted_action = /datum/action/cooldown/butcher
	actionname = "Butcher"
	name = "Level 2 Skill: Butcher"
	level = 2
	custom_premium_price = 1200
	remarks = list(
		"So there is 1 pair of gloves in the backstreets that can make me a butchering god...? huh.",
		"To butcher the meat properly you have to understand the meat... what a bunch of nonsense.",
		"District 23 is the perfect place to practice butchering and get butchered at the same time...",
	)

/datum/action/cooldown/butcher
	name = "Butcher"
	desc = "Instantly butcher all dead opponents in a 5x5 range around you. If you are holding an object that can butcher more efficiently than your skill, absorb the object into the skill."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "butcher"
	cooldown_time = 2 SECONDS
	var/datum/component/butchering/butcher_component

/datum/action/cooldown/butcher/New()
	. = ..()
	AddComponent(/datum/component/butchering)
	butcher_component = src.GetComponent(/datum/component/butchering)

/datum/action/cooldown/butcher/Destroy()
	butcher_component = null
	return ..()

/datum/action/cooldown/butcher/Trigger()
	. = ..()
	if(!.)
		return
	if(owner.stat != CONSCIOUS)
		to_chat(owner, span_warning("You need to not be bleeding out on the floor to butcher creatures!"))
		return

	absorb_knife() // if our owner is holding a thing that can butcher better than we do, lets assume its form

	for(var/mob/living/the_meal in view(2, get_turf(src))) // For conviniency, do it in a range
		if(the_meal.stat == DEAD && !ishuman(the_meal) && (the_meal.butcher_results || the_meal.guaranteed_butcher_results))
			butcher_component.Butcher(owner, the_meal)
	StartCooldown()

/datum/action/cooldown/butcher/proc/absorb_knife()
	var/obj/potential_knife = owner.get_active_held_item()
	if(!potential_knife)
		return

	var/datum/component/butchering/meat_machine = potential_knife.GetComponent(/datum/component/butchering)
	if(!meat_machine)
		return

	var/their_weak_effectiveness = meat_machine.effectiveness + meat_machine.bonus_modifier
	var/our_strong_butchering = butcher_component.effectiveness + butcher_component.bonus_modifier
	if(our_strong_butchering >= their_weak_effectiveness)
		return

	butcher_component.effectiveness = meat_machine.effectiveness
	butcher_component.bonus_modifier = meat_machine.bonus_modifier
	to_chat(owner, span_nicegreen("You absorb [potential_knife] into the [name] ability, empowering its butchering effectiveness!"))
	qdel(potential_knife)

	var/difference = floor((their_weak_effectiveness - our_strong_butchering) / 5)
	for(var/i in 1 to difference)
		name = "[name]+"
