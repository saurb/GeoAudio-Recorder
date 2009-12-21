//
//  ThirdLevelViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrackDetailViewController : UIViewController {

	IBOutlet UILabel* trackTitle;
	NSString* message;
}
@property (nonatomic, retain) IBOutlet UILabel* trackTitle;
@property (nonatomic, retain) NSString* message;

@end
