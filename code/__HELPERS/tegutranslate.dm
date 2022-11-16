// Probably the worst code I've ever written
// This is a very simple "translation" tool for most important parts of the game
// It is a simple associative list of associative list in a form of:
// list("Some text" = list("Russian" = "Какой-то текст"))
// Eventually, I'd like to make it configurable just so I don't have to put it all there
// The proc itself is at the bottom, after the global list

GLOBAL_LIST_INIT(tegu_translation_list, list(
	// Generic stuff
	"Yes" = list(
		"Russian" = "Да",
		),
	"No" = list(
		"Russian" = "Нет",
		),
	// Languages
	"English" = list(
		"Russian" = "Английский",
		),
	"Russian" = list(
		"Russian" = "Русский",
		),
	"German" = list(
		"Russian" = "Немекций",
		),
	// Preferences menu
	"Interface Language" = list(
		"Russian" = "Язык Интерфейса",
		),
	"Enabled" = list(
		"Russian" = "Включено",
		),
	"Disabled" = list(
		"Russian" = "Выключено",
		),
	"Name" = list(
		"Russian" = "Имя",
		),
	"Male" = list(
		"Russian" = "Мужской",
		),
	"Female" = list(
		"Russian" = "Женский",
		),
	"UI Style" = list(
		"Russian" = "Стиль Интерфейса",
		),
	"tgui Window Mode" = list(
		"Russian" = "Режим Окна TGUI",
		),
	"tgui Window Placement" = list(
		"Russian" = "Расположение Окна TGUI",
		),
	"Widescreen" = list(
		"Russian" = "Широкий Экран",
		),
	"Play Admin MIDIs" = list(
		"Russian" = "Звуки/Музыка Проигрываемые Администрацией",
		),
	"Play Lobby Music" = list(
		"Russian" = "Музыка в Меню",
		),
	"Play End of Round Sounds" = list(
		"Russian" = "Звуки в Конце Раунда",
		),
	// New player lobby
	"New Player Options" = list(
		"Russian" = "Меню Нового Игрока",
		),
	"Setup Character" = list(
		"Russian" = "Настройка Персонажа",
		),
	"Ready" = list(
		"Russian" = "Готов",
		),
	"Not Ready" = list(
		"Russian" = "Не Готов",
		),
	"Observe" = list(
		"Russian" = "Наблюдать",
		),
	"View the Crew Manifest" = list(
		"Russian" = "Показать Список Сотрудников",
		),
	"Join Game!" = list(
		"Russian" = "Присоединиться к Игре!",
		),
	// To chat warnings in lobby
	"The round is either not ready, or has already finished..." = list(
		"Russian" = "Раунд либо ещё не готов, или уже закончился...",
		),
	"There is an administrative lock on entering the game!" = list(
		"Russian" = "Администрация запретила присоединяться к игре!",
		),
	"Server is full." = list(
		"Russian" = "Сервер заполнен.",
		),
	"Are you sure you wish to observe?" = list(
		"Russian" = "Уверены что хотите наблюдать?",
		),
	"Now teleporting." = list(
		"Russian" = "Телепортируемся.",
		),
	"Teleporting failed. Ahelp an admin please." = list(
		"Russian" = "Телепортация провалилась. Пожалуйста, свяжитесь с администрацией.",
		),
	// Messages when selecting role
	"is available" = list(
		"Russian" = "доступен",
		),
	"is unavailable" = list(
		"Russian" = "не доступен",
		),
	"You are currently banned from" = list(
		"Russian" = "Вам заблокирован доступ к",
		),
	"You do not have enough relevant playtime for" = list(
		"Russian" = "У вас недостаточно необходимого игрового времени для",
		),
	"Your account is not old enough for" = list(
		"Russian" = "Вы зарегистрировались недостаточно давно для",
		),
	"is already filled to capacity" = list(
		"Russian" = "слоты полностью заполнены",
		),
	// Miscellaneous lobby(or not lobby) stuff
	"Round Duration" = list(
		"Russian" = "Длительность Раунда",
		),
	"The station has been evacuated" = list(
		"Russian" = "Станция была эвакуирована",
		),
	"The station is currently undergoing evacuation procedures" = list(
		"Russian" = "Станция прямо сейчас проходит процедуру эвакуации",
		),
	))

// The way this proc works is very simple:
// As first argument we use the string itself, i.e. "Ready";
// As a second argument we can use either the language string(for example, "Russian"), user's client or user's mob.
// If anything fails(second argument is invalid, no such language, etc) - the proc will return first argument;
// Same will occur for English language, which is the default.

/proc/TeguTranslate(text, second_arg = "English")
	var/language = second_arg

	if(istype(language, /mob))
		var/mob/M = language
		if(M.client)
			language = M.client

	if(istype(language, /client))
		var/client/C = language
		if(C.prefs) // Technically should always be true
			language = C.prefs.client_language

	if(istype(language, /datum/preferences))
		var/datum/preferences/P = language
		language = P.client_language

	if((text in GLOB.tegu_translation_list) && (language in GLOB.tegu_translation_list[text]))
		text = GLOB.tegu_translation_list[text][language]

	return text
