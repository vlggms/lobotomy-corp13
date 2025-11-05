/*!
 * TGUI Chunking Support
 * Handles reassembly of large payloads sent from browser in chunks
 */

// Global storage for incoming chunks
GLOBAL_LIST_EMPTY(tgui_chunk_storage)

// Chunk data structure
/datum/tgui_chunk_transfer
	var/chunk_id
	var/total_chunks = 0
	var/chunks_received = 0
	var/list/chunk_data = list()
	var/list/small_params = list()
	var/original_path
	var/client/owner
	var/created_at
	var/timeout = 30 SECONDS // 30 second timeout for chunk transfers

/datum/tgui_chunk_transfer/New(chunk_id, client/C)
	src.chunk_id = chunk_id
	src.owner = C
	src.created_at = world.time
	GLOB.tgui_chunk_storage[chunk_id] = src

	// Set up timeout
	addtimer(CALLBACK(src, PROC_REF(timeout_check)), timeout)

/datum/tgui_chunk_transfer/proc/timeout_check()
	if(chunks_received < total_chunks)
		log_tgui(owner, "Chunk transfer timeout",
			context = "tgui_chunking/[chunk_id]")
		cleanup()

/datum/tgui_chunk_transfer/proc/cleanup()
	GLOB.tgui_chunk_storage -= chunk_id
	qdel(src)

/datum/tgui_chunk_transfer/proc/add_chunk(key, index, data)
	if(!chunk_data[key])
		chunk_data[key] = list()

	chunk_data[key]["[index]"] = data
	chunks_received++

/datum/tgui_chunk_transfer/proc/is_complete()
	return chunks_received >= total_chunks

/datum/tgui_chunk_transfer/proc/reassemble()
	var/list/final_params = list()

	// Copy small parameters if they exist
	if(small_params && istype(small_params, /list))
		for(var/key in small_params)
			final_params[key] = small_params[key]

	// Reassemble each chunked parameter
	for(var/key in chunk_data)
		var/list/chunks = chunk_data[key]
		var/reassembled = ""

		// Sort chunks by index and concatenate
		for(var/i = 0 to chunks.len - 1)
			var/chunk = chunks["[i]"]
			if(chunk)
				reassembled += chunk

		// Decode the reassembled parameter
		final_params[key] = url_decode(reassembled)

	return final_params

// Enhanced Topic handler for chunked transfers
/proc/tgui_Topic_chunked(href_list)
	if(!href_list["tgui_chunk"])
		return FALSE

	var/client/C = usr.client
	if(!C)
		return TRUE

	var/chunk_id = href_list["chunk_id"]
	var/chunk_action = href_list["chunk_action"]

	if(!chunk_id)
		log_tgui(C, "Error: Missing chunk_id",
			context = "tgui_chunking")
		return TRUE

	var/datum/tgui_chunk_transfer/transfer = GLOB.tgui_chunk_storage[chunk_id]

	switch(chunk_action)
		if("init")
			// Initialize new chunk transfer
			if(transfer)
				log_tgui(C, "Warning: Duplicate chunk_id",
					context = "tgui_chunking/[chunk_id]")
				transfer.cleanup()

			transfer = new /datum/tgui_chunk_transfer(chunk_id, C)
			transfer.total_chunks = text2num(href_list["total_chunks"])

			// Parse small parameters
			var/small_params_json = href_list["small_params"]
			if(small_params_json)
				try
					transfer.small_params = json_decode(small_params_json)
				catch(var/exception/e)
					log_tgui(C, "Error parsing small_params: [e]",
						context = "tgui_chunking/[chunk_id]")
					transfer.small_params = list()
			else
				transfer.small_params = list()

		if("data")
			// Receive chunk data
			if(!transfer)
				log_tgui(C, "Error: Unknown chunk_id",
					context = "tgui_chunking/[chunk_id]")
				return TRUE

			var/chunk_key = href_list["chunk_key"]
			var/chunk_index = text2num(href_list["chunk_index"])
			var/chunk_data = href_list["chunk_data"]

			transfer.add_chunk(chunk_key, chunk_index, chunk_data)

		if("complete")
			// Finalize chunk transfer
			if(!transfer)
				log_tgui(C, "Error: Unknown chunk_id",
					context = "tgui_chunking/[chunk_id]")
				return TRUE

			if(!transfer.is_complete())
				log_tgui(C, "Warning: Incomplete chunk transfer ([transfer.chunks_received]/[transfer.total_chunks])",
					context = "tgui_chunking/[chunk_id]")

			// Reassemble the complete payload
			var/list/complete_params = transfer.reassemble()

			// Now process the complete message as if it was sent normally
			// Remove chunk-specific parameters
			complete_params -= "tgui_chunk"
			complete_params -= "chunk_id"
			complete_params -= "chunk_action"

			// Create new href_list with original parameters (excluding chunk params)
			var/list/final_href = list()

			// Copy non-chunk parameters from original href_list
			for(var/key in href_list)
				if(key != "tgui_chunk" && key != "chunk_id" && key != "chunk_action" && \
				   key != "total_chunks" && key != "small_params" && key != "chunk_key" && \
				   key != "chunk_index" && key != "chunk_data" && key != "chunk_total")
					final_href[key] = href_list[key]

			// Add reassembled parameters
			for(var/key in complete_params)
				final_href[key] = complete_params[key]

			// Clean up the transfer
			transfer.cleanup()

			// Continue processing with the complete data
			// This will pass to the normal tgui_Topic handler
			return tgui_Topic(final_href)

	return TRUE
