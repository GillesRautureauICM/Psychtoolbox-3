/*
    SCREENGetMouseTransientHelper.c

    AUTHORS:

        gilles.rautureau@icm-istitute.org           gr

    PLATFORMS:

        All, with platform dependent code.
        Only effictive on Windows OS

    HISTORY:

        10/06/17	gr     Created.

    DESCRIPTION:

        * Get number of clics since last call. Requiere call to GetMouseHelper before

        * Should not be used directly. Use GetMousTransient



*/

#include "Screen.h"

// If you change the useString then also change the corresponding synopsis string in ScreenSynopsis.c
static char useString[] = "[buttonValueArray] = Screen('GetMouseTransientHelper', numButtons );";
//                          1                                                    1             
static char synopsisString[] =
    "This is a helper function called by GetMouse.  Do not call Screen(\'GetMouseTransientHelper\'), use "
    "GetMouseTransient instead.\n"
    "\"numButtons\" is the number of mouse buttons to return in buttonValueArray. 1 <= numButtons <= 32. Ignored on Linux and Windows.\n";
    

static char seeAlsoString[] = "";

PsychError SCREENGetMouseTransientHelper(void)
{
#if PSYCH_SYSTEM == PSYCH_WINDOWS
    double* buttonArray;
    double numButtons;

    PsychPushHelp(useString, synopsisString, seeAlsoString);
    if (PsychIsGiveHelp()) { PsychGiveHelp(); return(PsychError_none); };

    // Retrieve optional number of mouse buttons:
    numButtons = 0;
    PsychCopyInDoubleArg(1, FALSE, &numButtons);
    
    PsychAllocOutDoubleMatArg(1, kPsychArgOptional, (int)1, (int)numButtons, (int)1, &buttonArray);
    // Query and return mouse button clic numbers:
    PsychGetMouseButtonTransient(buttonArray);

#else
    double* buttonArray;
    double numButtons;
    int i;
    
    numButtons = 0;
    PsychCopyInDoubleArg(1, FALSE, &numButtons);
    // plateform not supported
    // return dummy value
    PsychAllocOutDoubleMatArg(1, kPsychArgOptional, (int)1, (int)numButtons, (int)1, &buttonArray);
    for (i=0;i<numButtons;i++)
    {
        buttonArray[i] = (double)0;
    }
    
#endif

    return(PsychError_none);
}
