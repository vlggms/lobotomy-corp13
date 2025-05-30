/* Component for Bloodfeast.
	Allows bloodfiends and similar types of mobs to absorb and use blood. */

/datum/component/bloodfeast
	dupe_mode = COMPONENT_DUPE_UNIQUE
	//How much blood we have
	var/blood_amount = 0
	//Cap on blood, if we have one
	var/blood_cap = INFINITY
	//The range where blood spilled on the ground is added to bloodfeast
	var/absorb_range = 1
	//The blood amount where large visual effect indicators start to show up. Smaller fx show up at 30%
	var/warning_threshold = 3000
	//Whether or not you passively siphon blood and show off vfx - used for bloodfiends in hiding i guess
	var/passive_siphon = TRUE

/datum/component/bloodfeast/Initialize(siphon = TRUE, range = 1, starting = 0, threshold = 3000, max_amount = INFINITY)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	passive_siphon = siphon
	absorb_range = range
	blood_amount = starting
	blood_cap = max_amount
	START_PROCESSING(SSdcs, src)

/datum/component/bloodfeast/RegisterWithParent()
	if(isliving(parent))
		RegisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_PARENT_QDELETING), PROC_REF(OnDeath))

/datum/component/bloodfeast/UnregisterFromParent()
	if(isliving(parent))
		UnregisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_PARENT_QDELETING))

// On death remove this component and clean things up.
/datum/component/bloodfeast/proc/OnDeath()
	SIGNAL_HANDLER
	STOP_PROCESSING(SSdcs, src)
	qdel(src)

// Changes blood amount based on mins and maxes. If you are a coder working with bloodfeast, be familiar with this basic proc.
/datum/component/bloodfeast/proc/AdjustBlood(blood)
	blood_amount = clamp(blood_amount + blood, 0, blood_cap)

/datum/component/bloodfeast/process()
	if(!passive_siphon)
		return
	ScanForBlood()
	VisualEffect()

// Check our absorb_range for spilled blood.
/datum/component/bloodfeast/proc/ScanForBlood()
	if(blood_amount >= blood_cap) // We're already full and we can save whats on the floor for later.
		return
	var/turf/T = get_turf(parent)
	if(!T)
		return
	for(var/obj/effect/decal/cleanable/blood/B in view(T, absorb_range)) //will clean up any blood, but only heals from human blood
		if(B.blood_state == BLOOD_STATE_HUMAN)
			playsound(get_turf(B), 'sound/abnormalities/nosferatu/bloodcollect.ogg', 5, 1)
			AdjustBlood(B.bloodiness)
			new /obj/effect/temp_visual/cult/sparks(get_turf(B))
		qdel(B)

// Visual blood splatters that appear in the same range as ScanForBlood(). This is just fluff.
/datum/component/bloodfeast/proc/VisualEffect()
	if(!blood_amount)
		return
	if(blood_amount < warning_threshold)
		for(var/turf/T in view(absorb_range, get_turf(parent)))
			if(prob(3))
				new /obj/effect/disappearing_bloodsplatter/small(T)
			return
	var/multiplier = 5 * (blood_amount / warning_threshold) // Effects become more notable as more blood is collected
	for(var/turf/T in view(absorb_range, get_turf(parent)))
		if(prob(multiplier))
			new /obj/effect/disappearing_bloodsplatter(T)

/obj/effect/disappearing_bloodsplatter
	name = "blood"
	desc = "It's red and gooey."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	var/random_icon_states = list("floor1", "floor2", "floor3", "floor5", "gibbl2", "gibbl5")
	alpha = 0

/obj/effect/disappearing_bloodsplatter/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 15)
	if (random_icon_states && (icon_state == initial(icon_state)) && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)
	animate(src, alpha = 255, time = 1.5 SECONDS, easing = BOUNCE_EASING)

/obj/effect/disappearing_bloodsplatter/proc/fade_out()
	animate(src, alpha = 0, time = 1.5 SECONDS, easing = BACK_EASING)
	QDEL_IN(src, 1.5 SECONDS)

/obj/effect/disappearing_bloodsplatter/small
	random_icon_states = list("gibbl2", "gibbl5", "drip1","drip2","drip3","drip4", "drip5")
