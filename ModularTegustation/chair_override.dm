/obj/structure/chair/post_buckle_mob(mob/living/M)
	. = ..()
	M.pixel_x += pixel_x
	M.pixel_y += pixel_y

/obj/structure/chair/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.pixel_x -= pixel_x
	M.pixel_y -= pixel_y

/obj/structure/chair/plastic/post_unbuckle_mob(mob/living/Mob)
	. = ..()
	Mob.pixel_x -= pixel_x
	Mob.pixel_y -= pixel_y
