//
//  LablibMatlab.h
//  LablibMatlab
//
//  Created by John Maunsell on 1/7/17.
//
// Lablib Matlab support is put in a separate framework to make it easier for Lablib to run on machines that do not
// have a Matlab license. Plugins that use Matlab should link against LablibMatlab, but not link any Matlab files
// directly. Further, plugins linking with LablibMatlab should use a weak link. That way, if Matlab is not available
// on a machine, they will work (without Matlab).  The weak-link is in the AllPlugins.xcconfig file, which all
// Lablib plugins should use. That xcconfig, plus the AllProjects.xconfig, will provide the following, which will
// provide access to LablibMatlab, but not require that Matlab libraries be present at run time:
//
// OTHER_LDFLAGS = -weak_framework LablibMatlab
// HEADER_SEARCH_PATHS = $(inherited) /Documents/Lablib/Frameworks/LablibMatlab
// FRAMEWORK_SEARCH_PATHS = $(inherited) /Documents/Lablib/Frameworks/LablibITC18/build/Development
//                                      /Documents/Lablib/Frameworks/LablibMatlab/build/Debug
//
// Knot always includes the LablibMatlab framework within it.  If Knot and LablibMatlab are built to run with
// Matlab, Knot will not run on a machine that doesn't have Matlab installed.  To deal with this, the Lablib
// workspace includes a build scheme called "Build All No Lablib".  This will build a version of LablibMatlab that
// doesn't link against the Matlab libraries, and a version of Knot that includes this version of LablibMatlab.
// Knot built this way of course won't provide any Matlab support, but it will run normally otherwise.  Providing
// Knot plugings are build as described above, they will also run, and simply not provide any Matlab services or
// displays.
//
// This works because LablibMatlab is the only part of Labilb that links directly against Matlab code, linking
// against libeng.dylib.
//
// Matlab library files can be found using the command "fullfile(matlabroot,'bin',computer('arch'))".  Typically,
// this is something like /Applications/MATLAB_R2013a.app/bin/maci64. LablibMatlab also needs "engine.h", which is a
// location Matlab identifies when queried with "fullfile(matlabroot,'extern','include')".  It will be something like
// "/Applications/MATLAB_R2013a.app/extern/include". These settings should be set in the LablibMatlab xcconfig,
// FrameworkMatlab.xcconfig;
//
// HEADER_SEARCH_PATHS = /Applications/MATLAB/extern/include
// LIBRARY_SEARCH_PATHS = /Applications/MATLAB/bin/maci64 /Applications/MATLAB/sys/os/maci64
//
// Finally, Lablib Matlab support isn't specific for a particular version of Matlab, but it requires that you
// create an link to the Matlab application (bundle) that is called "MATLAB" and is in the Application folder
// (where Matlab should reside).  This MUST be a symbolic link -- NOT an alias.  The link can be created using
// the terminal: cd /Applications; ln -s MATLAB_R2013a.app MATLAB
// Of course, you should change "2013a" as needed to match the version of Matlab that you have.

#import <Cocoa/Cocoa.h>

//! Project version number for LablibMatlab.
FOUNDATION_EXPORT double LablibMatlabVersionNumber;

//! Project version string for LablibMatlab.
FOUNDATION_EXPORT const unsigned char LablibMatlabVersionString[];

// In this header, you should import all the public headers of your framework using statements
// like #import <LablibMatlab/PublicHeader.h>

