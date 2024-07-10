#define PREF_NO_TGUI (1<<0)
#define PREF_TGUI (1<<1)

GLOBAL_LIST_INIT(allowed_auxiliary_console_tgui, list(PREF_NO_TGUI, PREF_TGUI))
