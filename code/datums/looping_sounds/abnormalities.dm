/datum/looping_sound/queenbee
	mid_sounds = 'sound/abnormalities/bee/queen_ambience.ogg'
	mid_length = 3.8 SECONDS
	volume = 35
	extra_range = -3

/datum/looping_sound/bluestar
	mid_sounds = 'sound/abnormalities/bluestar/breach_ambience.ogg'
	mid_length = 26.8 SECONDS
	volume = 50
	extra_range = 40

/datum/looping_sound/qoh_beam
	mid_sounds = 'sound/abnormalities/hatredqueen/beam_loop.ogg'
	mid_length = 6.7 SECONDS
	end_sound = 'sound/abnormalities/hatredqueen/beam_end.ogg'
	volume = 50
	extra_range = 10

/datum/looping_sound/apostle_beam
	mid_sounds = 'sound/abnormalities/whitenight/staff_attack.ogg'
	mid_length = 3.7 SECONDS
	end_sound = 'sound/abnormalities/whitenight/staff_end.ogg'
	volume = 75
	extra_range = 14

/datum/looping_sound/dreamingcurrent
	mid_sounds = 'sound/abnormalities/dreamingcurrent/ambience.ogg'
	mid_length = 9.8 SECONDS
	volume = 25
	extra_range = -3

/datum/looping_sound/silence
	mid_sounds = 'sound/abnormalities/silence/ambience.ogg'
	mid_length = 5.7 SECONDS
	volume = 25
	extra_range = -3

/datum/looping_sound/singing_grinding
	mid_sounds = 'sound/abnormalities/singingmachine/motor.ogg'
	mid_length = 4 SECONDS
	volume = 5
	extra_range = -8

/datum/looping_sound/singing_music
	mid_sounds = 'sound/abnormalities/singingmachine/music.ogg'
	mid_length = 4 SECONDS
	volume = 25
	extra_range = 2

/datum/looping_sound/nothingthere_ambience
	mid_sounds = 'sound/abnormalities/nothingthere/ambience.ogg'
	mid_length = 7 SECONDS
	volume = 25
	extra_range = -4

/datum/looping_sound/nothingthere_heartbeat
	mid_sounds = list('sound/abnormalities/nothingthere/heartbeat.ogg', 'sound/abnormalities/nothingthere/heartbeat2.ogg')
	mid_length = 2.5 SECONDS
	volume = 35

/datum/looping_sound/nothingthere_disguise
	mid_sounds = 'sound/abnormalities/nothingthere/disguise_loop.ogg'
	mid_length = 5 SECONDS
	volume = 15
	extra_range = -4

/datum/looping_sound/nothingthere_breach
	start_sound = 'sound/abnormalities/nothingthere/ntloop_start.ogg'
	start_length = 7.2 SECONDS
	start_volume = 35
	mid_sounds = list('sound/abnormalities/nothingthere/ntloop_1.ogg' = 1, 'sound/abnormalities/nothingthere/ntloop_2.ogg' = 1, 'sound/abnormalities/nothingthere/ntloop_3.ogg' = 1,)
	mid_length = 12 SECONDS
	end_sound = 'sound/abnormalities/nothingthere/ntloop_end.ogg'
	end_volume = 40
	volume = 25
	extra_range = -4

/datum/looping_sound/siren_musictime
	start_sound = 'sound/abnormalities/siren/needle1.ogg'
	start_volume = 25
	start_length = 1 SECONDS
	mid_sounds = 'sound/abnormalities/siren/driftingtimemisplaced.ogg'
	mid_length = 38 SECONDS
	volume = 25
	extra_range = 40
	falloff_distance = 35 //minimal falloff due to being a long sound
	end_sound = 'sound/abnormalities/siren/needle2.ogg'
	channel = CHANNEL_SIREN

/datum/looping_sound/clown_ambience
	mid_sounds = 'sound/abnormalities/clownsmiling/clownloop.ogg'
	mid_length = 30 SECONDS
	volume = 25
	extra_range = -4

/datum/looping_sound/cloudedmonk_ambience
	mid_sounds = 'sound/abnormalities/clouded_monk/run.ogg'
	mid_length = 6 SECONDS
	volume = 25
	extra_range = -4

/datum/looping_sound/orangetree_ambience
	mid_sounds = list('sound/abnormalities/orangetree/light1.ogg' = 1, 'sound/abnormalities/orangetree/light2.ogg' = 1, 'sound/abnormalities/orangetree/light3.ogg' = 1,
	'sound/abnormalities/orangetree/light4.ogg' = 1, 'sound/abnormalities/orangetree/light5.ogg' = 1, 'sound/abnormalities/orangetree/light6.ogg' = 1)
	mid_length = 15 SECONDS
	volume = 60
	extra_range = -5

/datum/looping_sound/quietday_ambience
	mid_sounds = 'sound/abnormalities/quietday/quietloop.ogg'
	mid_length = 15 SECONDS
	volume = 60
	extra_range = -4

// Ordeals
/datum/looping_sound/amberdusk
	mid_sounds = 'sound/effects/ordeals/amber/dusk_ambience.ogg'
	mid_length = 0.55 SECONDS
	volume = 20

/datum/looping_sound/ambermidnight
	mid_sounds = 'sound/effects/ordeals/amber/midnight_ambience.ogg'
	mid_length = 3.8 SECONDS
	volume = 20

/datum/looping_sound/arbiter_pillar_storm
	mid_sounds = 'sound/magic/arbiter/storm_loop.ogg'
	mid_length = 5.5 SECONDS
	volume = 50
	extra_range = 7

/datum/looping_sound/greenmidnight_laser
	mid_sounds = 'sound/effects/ordeals/green/midnight_laser_loop.ogg'
	mid_length = 0.4 SECONDS
	volume = 35
	extra_range = 128
