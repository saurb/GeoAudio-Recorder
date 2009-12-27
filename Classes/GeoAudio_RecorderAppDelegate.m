//
//  GeoAudio_RecorderAppDelegate.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright Arizona State University 2009. All rights reserved.
//

#import "GeoAudio_RecorderAppDelegate.h"
#import "TracksNavController.h"

@implementation GeoAudio_RecorderAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize tracksNavController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
	application.idleTimerDisabled = YES;
}


- (void)dealloc {
	[tracksNavController release];
	[rootController release];
    [window release];
    [super dealloc];
}



@end
