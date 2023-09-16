#define FORTITUDE_ATTRIBUTE "Fortitude"
#define PRUDENCE_ATTRIBUTE "Prudence"
#define TEMPERANCE_ATTRIBUTE "Temperance"
#define JUSTICE_ATTRIBUTE "Justice"

#define WORK_TO_ATTRIBUTE list(\
							ABNORMALITY_WORK_INSTINCT = FORTITUDE_ATTRIBUTE,\
							ABNORMALITY_WORK_INSIGHT = PRUDENCE_ATTRIBUTE,\
							ABNORMALITY_WORK_ATTACHMENT = TEMPERANCE_ATTRIBUTE,\
							ABNORMALITY_WORK_REPRESSION = JUSTICE_ATTRIBUTE,\
							)


/// The max human health is adjusted to default define + fortitude points * this modifier
#define FORTITUDE_MOD 1

/// Same as above, but for sanity and prudence
#define PRUDENCE_MOD 1

/// How much temperance affects the success rate of the works; Higher = better.
#define TEMPERANCE_SUCCESS_MOD 0.2

/// The justice attribute is divided by this number to decide the movement speed buff; The higher it is - the lower is maximum speed
#define JUSTICE_MOVESPEED_DIVISER 230
