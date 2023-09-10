/// Turns Target Into A Book
/datum/smite/book
	name = "Book"

/datum/smite/book/effect(client/user, mob/living/target)
	. = ..()
	target.turn_book()
