/obj/structure/bough/mining//from rcorp's objective.dm

/obj/structure/bough/mining/RoundEndEffect(mob/living/carbon/human/user)
	if(do_after(user, 10 SECONDS))
		bastards += user.ckey
		clear_filters()
		bough.clear_filters()
		vis_contents.Cut()
		qdel(bough)
		light_on = FALSE
		update_light()

		if(!SSticker.force_ending)
			//Round End Effects
			SSvote.initiate_vote("restart", "golden bough")
			SSticker.SetRoundEndSound('sound/roundend/canto_1.ogg')
			for(var/mob/M in GLOB.player_list)
				to_chat(M, span_userdanger("[uppertext(user.real_name)] has collected the bough!"))
			//The thread of fate has severed. You can choose to end the round here, or continue the doomed timeline you've created.
		else
			var/turf/turf = get_turf(src)
			new /obj/effect/decal/cleanable/confetti(turf)
			playsound(turf, 'sound/misc/sadtrombone.ogg', 100)

	else
		user.gib()
