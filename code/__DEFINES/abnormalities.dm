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

// Declares the Signals that should be listened for on Work Start/Attempt
#define COMSIG_INSTINCT_WORK_ATTEMPTED "instinct_attempted"
#define COMSIG_INSIGHT_WORK_ATTEMPTED "insight_attempted"
#define COMSIG_ATTACHMENT_WORK_ATTEMPTED "attachment_attempted"
#define COMSIG_REPRESSION_WORK_ATTEMPTED "repression_attempted"
#define COMSIG_WORK_ATTEMPTED "work_attempted"
/// Declares the Signals that should be listened for on Work Completion
#define COMSIG_INSTINCT_WORK_COMPLETED "instinct_completed"
#define COMSIG_INSIGHT_WORK_COMPLETED "insight_completed"
#define COMSIG_ATTACHMENT_WORK_COMPLETED "attachment_completed"
#define COMSIG_REPRESSION_WORK_COMPLETED "repression_completed"
#define COMSIG_WORK_COMPLETED "work_completed"

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

