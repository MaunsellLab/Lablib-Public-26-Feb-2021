//
//  LLMatlabEngine.m
//  Lablib
//
//  Created by John Maunsell on 1/2/17.
//
// Using Matlab requires the libraries libeng.dylib and libmx.dylib.  They can be found in the Matlab folder returned
// by Matlab by the command "fullfile(matlabroot,'bin',computer('arch'))".  Typically, this is something like
// /Applications/MATLAB_R2013a.app/bin/maci64.  Note: Xcode will not work with an alias like "Matlab" that points to
// the current Matlab.  You must use actual application folder (with ".app").  The path should be added to the "Search
// Library Path" in the project settings, so that the linker can resolve the Matlab refernces.  It must also be added
// to the "Runpath Search Path", so that the Matlab dylibs can be found at run time.

// We also need "engine.h", which is a location Matlab identifies when queried with
// "fullfile(matlabroot,'extern','include')".  It will be something like
// "/Applications/MATLAB_R2013a.app/extern/include".  This should be added to the "Headar Search Paths" in the
// project settings.

// The demonstration programs show starting Matlab with a null argument, but that didn't work, even when Matlab
// could be launched at the csh command line with "matlab".

//cd /usr/local/bin/
//sudo ln -s /usr/local/MATLAB/R2012a/bin/matlab matlab

typedef uint16_t char16_t;                  // Matlab engine uses a type that isn't defined by CLANG
#include <engine.h>
#import "LLMatlabEngine.h"

#define kBufferSize 256

// We make pEngine a class variable because there should only be one engine running at a time.  Additionally,
// this mean that everyone who uses "Lablib" won't have to include the path to the folde containing the Matlab
// header engine.h.

Engine  *pEngine;

@implementation LLMatlabEngine : NSObject

- (void)close;
{
    if (pEngine != nil) {
        engClose(pEngine);
    }
    pEngine = nil;
}

- (id)init;
{
    if ((self = [super init]) == nil) {
        return nil;
    }
    if (pEngine == nil) {
        //       if (!(pEngine = engOpen("/bin/csh -c /usr/local/bin/matlab"))) {
            if (!(pEngine = engOpen("/bin/csh -c /Applications/MATLAB_R2013a.app/bin/matlab"))) {
            NSLog(@"LLMatlabEngine: Can't start Matlab engine");
            return self;
        }
    }
    return self;
}

- (BOOL)runDemo;
{
    mxArray *T = NULL, *result = NULL;
    char buffer[kBufferSize+1];
    double time[10] = { 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 };

    /*
     * PART I
     *
     * For the first half of this demonstration, send data
     * to MATLAB, analyze the data, and plot the result.
     */

    /*
     * Create a variable for the data
     */

    T = mxCreateDoubleMatrix(1, 10, mxREAL);
    memcpy((void *)mxGetPr(T), (void *)time, sizeof(time));
    /*
     * Place the variable T into the MATLAB workspace
     */

    engPutVariable(pEngine, "T", T);

    /*
     * Evaluate a function of time, distance = (1/2)g.*t.^2
     * (g is the acceleration due to gravity)
     */

    engEvalString(pEngine, "D = .5.*(-9.8).*T.^2;");

    /*
     * Plot the result
     */

    engEvalString(pEngine, "plot(T,D);");
    engEvalString(pEngine, "title('Position vs. Time for a falling object');");
    engEvalString(pEngine, "xlabel('Time (seconds)');");
    engEvalString(pEngine, "ylabel('Position (meters)');");

    /*
     * use fgetc() to pause long enough to be
     * able to see the plot
     */

//    printf("Hit return to continue\n\n");
//    fgetc(stdin);

    /*
     * clean up for Part I! Free memory, close MATLAB figure.
     */

    printf("Done for Part I.\n");
    mxDestroyArray(T);
    engEvalString(pEngine, "close;");


    /*
     * PART II
     *
     * For the second half of this demonstration, we will request
     * a MATLAB string, which should define a variable X.  MATLAB
     * will evaluate the string and create the variable.  We
     * will then recover the variable, and determine its type.
     */

    /*
     * Use engOutputBuffer to capture MATLAB output, so we can
     * echo it back.  Ensure first that the buffer is always NULL
     * terminated.
     */

    buffer[kBufferSize] = '\0';
    engOutputBuffer(pEngine, buffer, kBufferSize);
    while (result == NULL) {
        char str[kBufferSize+1];
        /*
         * Get a string input from the user
         */
        printf("Enter a MATLAB command to evaluate.  This command should\n");
        printf("create a variable X.  This program will then determine\n");
        printf("what kind of variable you created.\n");
        printf("For example: X = 1:5\n");
        printf(">> ");

        fgets(str, kBufferSize, stdin);

        /*
         * Evaluate input with engEvalString
         */
        engEvalString(pEngine, str);

        /*
         * Echo the output from the command.
         */
        printf("%s", buffer);

        /*
         * Get result of computation
         */
        printf("\nRetrieving X...\n");
        if ((result = engGetVariable(pEngine,"X")) == NULL)
        printf("Oops! You didn't create a variable X.\n\n");
        else {
            printf("X is class %s\t\n", mxGetClassName(result));
        }
    }
    
    /*
     * We're done! Free memory, close MATLAB engine and exit.
     */
    printf("Done!\n");
    mxDestroyArray(result);

    return YES;
}

@end 
