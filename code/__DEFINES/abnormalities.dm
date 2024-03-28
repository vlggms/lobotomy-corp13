// Threat levels
#define ZAYIN_LEVEL 1
#define TETH_LEVEL 2
#define HE_LEVEL 3
#define WAW_LEVEL 4
#define ALEPH_LEVEL 5

// Work types
#define ABNORMALITY_WORK_INSTINCT "Instinct"
#define ABNORMALITY_WORK_INSIGHT "Insight"
#define ABNORMALITY_WORK_ATTACHMENT "Attachment"
#define ABNORMALITY_WORK_REPRESSION "Repression"

// Breach types
#define BREACH_NORMAL 0
#define BREACH_PINK 1

// List
#define THREAT_TO_NAME list(\
	ZAYIN_LEVEL = "ZAYIN",\
	TETH_LEVEL = "TETH",\
	HE_LEVEL = "HE",\
	WAW_LEVEL = "WAW",\
	ALEPH_LEVEL = "ALEPH",\
)

#define THREAT_TO_COLOR list(\
	ZAYIN_LEVEL = COLOR_GREEN,\
	TETH_LEVEL = COLOR_BLUE,\
	HE_LEVEL = COLOR_DARK_ORANGE,\
	WAW_LEVEL = COLOR_PURPLE,\
	ALEPH_LEVEL = COLOR_RED,\
)

#define THREAT_TO_CSS_COLOR list(\
	ZAYIN_LEVEL = "green",\
	TETH_LEVEL = "blue",\
	HE_LEVEL = "orange",\
	WAW_LEVEL = "purple",\
	ALEPH_LEVEL = "red",\
)

// The maximum attribute level you can get from each abnormality threat level
#define THREAT_TO_ATTRIBUTE_LIMIT list(\
	ZAYIN_LEVEL = 40,\
	TETH_LEVEL = 60,\
	HE_LEVEL = 80,\
	WAW_LEVEL = 100,\
	ALEPH_LEVEL = 200,\
)

// Origins
#define ABNORMALITY_ORIGIN_ORIGINAL "Original"
#define ABNORMALITY_ORIGIN_LOBOTOMY "Lobotomy Corporation"
#define ABNORMALITY_ORIGIN_ALTERED "Altered LC"
#define ABNORMALITY_ORIGIN_ARTBOOK "Artbook"
#define ABNORMALITY_ORIGIN_WONDERLAB "Wonderlab"
#define ABNORMALITY_ORIGIN_RUINA "Library of Ruina"
#define ABNORMALITY_ORIGIN_LIMBUS "Limbus Company"

// Persistent PE things
#define PE_GOAL_REACHED	"goal_reached"
#define PE_GOAL_SPENT	"goal_spent"
#define PE_LEFTOVER		"leftover_pe"
