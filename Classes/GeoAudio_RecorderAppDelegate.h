//
//  GeoAudio_RecorderAppDelegate.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright Arizona State University 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TracksNavController;

@interface GeoAudio_RecorderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController* rootController;
	TracksNavController* tracksNavController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController* rootController;
@property (nonatomic, retain) IBOutlet TracksNavController* tracksNavController;


@end

