/client/proc/change_patreon_rank()
	set category = "Admin"
	set name = "Change Patreon Rank"
	set desc = "Change the Patreon Rank of a ckey"

	if(!check_rights(R_ADMIN))
		return

	if(!SSdbcore.IsConnected())
		return

	var/change_ckey = input(usr, "Which CKEY to change", "CKEY?", null) as null|text

	if(isnull(change_ckey) || length(change_ckey) <= 0)
		return

	var/change_rank = input(usr, "Please select the rank to change to", "Rank?", null) as null|anything in GLOB.patreon_ranks

	if(isnull(change_rank))
		return

	var/datum/db_query/query_has_patreon_rank = SSdbcore.NewQuery(
		"SELECT 1 FROM [format_table_name("patreon_ranks")] WHERE ckey = :change_ckey",
		list("change_ckey" = change_ckey)
	)

	if(!query_has_patreon_rank.warn_execute())
		qdel(query_has_patreon_rank)
		return
	if(!query_has_patreon_rank.NextRow())
		// No entry found, inserting
		QDEL_NULL(query_has_patreon_rank)
		var/datum/db_query/query_add_rank = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("patreon_ranks")] (ckey, patreon_key, patreon_rank)
			VALUES (:change_ckey, 'DUMMYKEY', :change_rank)
		"}, list("change_ckey" = change_ckey, "change_rank" = change_rank))

		if(!query_add_rank.warn_execute())
			qdel(query_add_rank)
			return
		qdel(query_add_rank)
	else
		qdel(query_has_patreon_rank)
		// Entry found, updating
		var/datum/db_query/query_change_rank = SSdbcore.NewQuery(
			"UPDATE [format_table_name("patreon_ranks")] SET patreon_rank = :change_rank WHERE ckey = :change_ckey",
			list("change_rank" = change_rank, "change_ckey" = change_ckey)
			)

		if(!query_change_rank.warn_execute())
			qdel(query_change_rank)
			return
		qdel(query_change_rank)

	message_admins("Patreon rank of ckey [change_ckey] changed to [change_rank]")
