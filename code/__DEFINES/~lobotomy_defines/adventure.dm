// defines used in ModularTegustation/_adventure_console

#define DEBUG_TEXT_DISPLAY (1<<0)
#define NORMAL_TEXT_DISPLAY (1<<1)
#define ADVENTURE_TEXT_DISPLAY (1<<2)

//Modes for what is displayed on the adventure panel.
#define ADVENTURE_MODE_TRAVEL (1<<0)
#define ADVENTURE_MODE_BATTLE (1<<1)
#define ADVENTURE_MODE_EVENT_BATTLE (1<<2)

//Stats defined. I honestly didnt want to make it have limbus company sins but here we are.
#define WRATH_STAT 1
#define LUST_STAT 2
#define SLOTH_STAT 3
#define GLUTT_STAT 4
#define GLOOM_STAT 5
#define PRIDE_STAT 6
#define ENVY_STAT 7
#define RAND_STAT rand(1,7)

//Enemy Standardization. Basically what is considered HARD and what is considered EASY.
#define MON_HP_RAND_EASY rand(10,50)
#define MON_HP_RAND_NORMAL rand(75,100)

#define MON_DAMAGE_EASY "1d6"
#define MON_DAMAGE_NORMAL "2d7"
#define MON_DAMAGE_HARD "2d12"

#define MON_DAMAGE_RAND "[rand(1,2)]d[rand(3,7)]"

/**
 * Easy define for html button format.
 * Place a <br> after this to make the buttons not be right next to eachother.
 * WARNING: Only works if the proc is returning nothing or has no returns.
 */
#define GENERAL_BUTTON(button_controller,topic,returned_value,button_text) . += " <A href='byond://?src=[button_controller];[topic]=[returned_value]'>[button_text]</A>"

/**
 * This definition requires the destination of the path change,
 * the description of the choice, and the interface recieving this
 * definition. Hopefully this definition makes creating these easier.
 */
#define BUTTON_FORMAT(path_change,choice_desc,interface_caller) . += " <A href='byond://?src=[REF(interface_caller)];choice=[path_change]'>[choice_desc]</A><br>"
#define CHANCE_BUTTON_FORMAT(number,button_text,interface_caller) . += " <A href='byond://?src=[REF(interface_caller)];event_misc=[number]'>[button_text]</A><br>"

//Defines for things that may need to be changed in the future.
#define EXTRA_CHANCE_MULTIPLIER 3
