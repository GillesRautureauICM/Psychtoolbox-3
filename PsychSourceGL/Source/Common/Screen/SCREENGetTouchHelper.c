/*
    SCREENGetTouchHelper.c

    AUTHORS:

        gilles.rautureau@icm-institute.com	GR

    PLATFORMS:

        WIN64 for now

    HISTORY:

        10/10/17	GR  created

    DESCRIPTION:

        Get current state of touchscreen and number of touch since last call

    NOTES


*/

#include "Screen.h"

// If you change the useString then also change the corresponding synopsis string in ScreenSynopsis.c
static char useString[] = "[x, y, touchState, nbTouch]= Screen('GetTouchHelper');";
//                          1  2  3           4
static char synopsisString[] =
    "This is a helper function called by GetMouseTransient.  Do not call Screen(\'GetTouchHelper\'), use "
    "GetMouseTransient instead.\n";
    

static char seeAlsoString[] = "";

PsychError SCREENGetTouchHelper(void)
{

#if PSYCH_SYSTEM == PSYCH_OSX
    
        PsychCopyOutDoubleArg(1, kPsychArgOptional, (double) 0);
        PsychCopyOutDoubleArg(2, kPsychArgOptional, (double) 0);
        PsychCopyOutFlagArg(3, kPsychArgOptional, ((psych_bool)) 0);
        PsychCopyOutDoubleArg(4, kPsychArgOptional, (double) 0);
#endif

#if PSYCH_SYSTEM == PSYCH_WINDOWS
    bool touchState;
    int xTouch;
    int yTouch;
    int nbTouch;

    PsychPushHelp(useString, synopsisString, seeAlsoString);
    if (PsychIsGiveHelp()) { PsychGiveHelp(); return(PsychError_none); };
 
    
    // Query and return touch state:
    PsychGetTouchState(&xTouch, &yTouch, &touchState, &nbTouch);
    
    PsychCopyOutDoubleArg(1, kPsychArgOptional, (double) xTouch);
    PsychCopyOutDoubleArg(2, kPsychArgOptional, (double) yTouch);
    PsychCopyOutFlagArg(3, kPsychArgOptional, (psych_bool) touchState);
    PsychCopyOutDoubleArg(4, kPsychArgOptional, (double) nbTouch);
#endif

#if PSYCH_SYSTEM == PSYCH_LINUX
        PsychCopyOutDoubleArg(1, kPsychArgOptional, (double) 0);
        PsychCopyOutDoubleArg(2, kPsychArgOptional, (double) 0);
        PsychCopyOutFlagArg(3, kPsychArgOptional, (psych_bool) 0);
        PsychCopyOutDoubleArg(4, kPsychArgOptional, (double) 0);
#endif
    return(PsychError_none);
}
