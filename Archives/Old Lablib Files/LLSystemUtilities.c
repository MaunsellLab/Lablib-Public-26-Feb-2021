/*
 *  LLSystemUtilities.c
 *  Lablib
 *
 *  Created by John Maunsell on Wed Jan 29 2003.
 *  Copyright (c) 2003. All rights reserved.
 *
 */

#include "LLSystemUtilities.h"

// Return the time in seconds as a double

double LLGetTimeS(void)
{
    struct timeval tod;
	
    gettimeofday(&tod, NULL);
    return tod.tv_sec + tod.tv_usec * 1.0E-6;
}
