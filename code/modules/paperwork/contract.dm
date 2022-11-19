/* For employment contracts */

/obj/item/paper/contract
	throw_range = 3
	throw_speed = 3
	var/signed = FALSE
	var/datum/mind/target
	item_flags = NOBLUDGEON

/obj/item/paper/contract/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_blocker)

/obj/item/paper/contract/proc/update_text()
	return

/obj/item/paper/contract/employment
	icon_state = "paper_words"

/obj/item/paper/contract/employment/New(atom/loc, mob/living/nOwner)
	. = ..()
	if(!nOwner || !nOwner.mind)
		qdel(src)
		return -1
	target = nOwner.mind
	update_text()


/obj/item/paper/contract/employment/update_text()
	name = "paper- [target] employment contract"
	info = "<center>Conditions of Employment</center><BR><BR><BR><BR>This Agreement is made and entered into as of the date of last signature below, by and between [target], and Lobotomy Corporation.<BR> As per contract, [target], and their immediate family, will be given the status of L corp feathers and housing within the L corp nest. In exchange for this garenteed housing the [target] will work as an employee in one of our designated branches.<BR><BR>L Nest housing and company benifits will be revoked if said employee breaches the following rules.<BR>Disclose confidential information about their employers singularity.<BR>Allow entities whose goals conflict with those of Lobotomy Corp to obstruct or subvert Lobotomy Corp .<BR>Disobey orders given by sephirot, manager, commanding officers or the captain of their respective department. This rule does not apply when positions below manager or their orders conflict with the rules above.<BR>Explusion from the L Nest can be anulled by their departments sephirot or the replacement of their position by an immidiate family member, Company Benifits will remain revoked until future review.<BR>Signed,<BR><i>[target]</i>"
