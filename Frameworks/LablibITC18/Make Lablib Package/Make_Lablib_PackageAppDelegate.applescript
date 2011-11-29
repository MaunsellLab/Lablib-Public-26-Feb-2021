--
--  Make_Lablib_PackageAppDelegate.applescript
--  Make Lablib Package
--
--  Created by John Maunsell on 6/26/11.
--  Copyright 2011 Harvard Medical School. All rights reserved.
--

script Make_Lablib_PackageAppDelegate
	property parent : class "NSObject"
	
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened 
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
end script