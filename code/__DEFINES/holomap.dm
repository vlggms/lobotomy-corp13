//
// Constants and standard colors for the holomap
//

#define HOLOMAP_ICON 'icons/480x480.dmi' // Icon file to start with when drawing holomaps (to get a 480x480 canvas).
#define HOLOMAP_ICON_SIZE 480 // Pixel width & height of the holomap icon.  Used for auto-centering etc.
#define HOLOMAP_MARGIN 100 // minimum marging on sides when combining maps
#define UI_HOLOMAP "CENTER-7, CENTER-7" // Screen location of the holomap "hud"

// Holomap colors
#define HOLOMAP_OBSTACLE "#ffffffdd"	// Color of walls and barriers
#define HOLOMAP_PATH     "#66666699"	// Color of floors
#define HOLOMAP_HOLOFIER "#79ff79"	// Whole map is multiplied by this to give it a green holoish look

#define HOLOMAP_AREACOLOR_BASE        "#ffffffff"
#define HOLOMAP_AREACOLOR_COMMAND    "#ffc50b99"
#define HOLOMAP_AREACOLOR_DISCIPLINE    "#ff000099"
#define HOLOMAP_AREACOLOR_SAFETY     "#69a448a5"
#define HOLOMAP_AREACOLOR_INFORMATION     "#81339c99"
#define HOLOMAP_AREACOLOR_TRAINING "#da7f2f99"
#define HOLOMAP_AREACOLOR_WELFARE "#456fff99"
#define HOLOMAP_AREACOLOR_EXTRACTION       "#6060608b"
#define HOLOMAP_AREACOLOR_RECORDS       "#bcbcbcaf"
#define HOLOMAP_AREACOLOR_CONTROL       "#d8d55699"
#define HOLOMAP_AREACOLOR_MANAGER       "#66ccff99"
#define HOLOMAP_AREACOLOR_ARCHITECTURE       "#ffffff9f"
#define HOLOMAP_AREACOLOR_HALLWAYS    "#e7e7e757"

// Handy defines to lookup the pixel offsets for holomap
#define HOLOMAP_PIXEL_OFFSET_X ((HOLOMAP_ICON_SIZE / 2) - world.maxx / 2)
#define HOLOMAP_PIXEL_OFFSET_Y ((HOLOMAP_ICON_SIZE / 2) - world.maxy / 2)

#define HOLOMAP_LEGEND_X 96
#define HOLOMAP_LEGEND_Y 166

#define HOLOMAP_EXTRA_STATIONMAP      "stationmapformatted" //full-sized map
#define HOLOMAP_EXTRA_STATIONMAPAREAS "stationareas" //area-colored canvas
#define HOLOMAP_EXTRA_STATIONMAPSMALL "stationmapsmall" //small map for sprite
