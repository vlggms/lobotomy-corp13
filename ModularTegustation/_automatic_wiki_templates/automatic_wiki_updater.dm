/proc/update_ego_weapons_wiki(token)
	var/website = "https://wiki.lc13.net"
	var/api_call = "/api.php?action=edit"
	var/format = "&format=json"
	var/website_title = "&title=[convert_text_to_URL("Automatic wiki sandbox")]"
//	var/page_content = "&text=[convert_text_to_URL(generate_ego_weapons())]"
	var/page_content = "&text=[convert_text_to_URL("Automatic API call from byond")]"
	var/summary = "&summary=Automatic%20API%20weapon%20update%20test" // (text already encoded in HTML, replace %20 with spaces for text)
	var/is_bot = "&bot=1"
	var/format_version = "&formatversion=2"

	var/one_hell_of_a_link = "[website][api_call][format][website_title][page_content][summary][is_bot][format_version]"

	var/list/headers = list()
	headers["User-Agent"] = "byond/[DM_VERSION].[DM_BUILD]"
	headers["Content-Type"] = "application/json"

	var/list/body_data = list()
	body_data["token"] = "[token]"

	var/datum/http_request/post_request = new()

	post_request.prepare(RUSTG_HTTP_METHOD_POST, one_hell_of_a_link, json_encode(body_data), headers, "tmp/response.json")
	post_request.begin_async()

/proc/convert_text_to_URL(text)
	text = replacetext(text, "{", "%7B")
	text = replacetext(text, "}", "%7D")
	text = replacetext(text, " ", "%20")
	text = replacetext(text, "\n", "%0A")
	text = replacetext(text, "\"", "%22")
	text = replacetext(text, ":", "%3A")
	text = replacetext(text, "|", "%7C")
	text = replacetext(text, "=", "%3D")
	text = replacetext(text, "+", "%2B")
	text = replacetext(text, ",", "%2C")
	text = replacetext(text, "?", "%3F")

	return text
