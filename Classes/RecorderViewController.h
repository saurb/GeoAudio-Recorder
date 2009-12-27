//
//  RecorderViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "LocationController.h"
#import "RecorderViewController.h"
#import "SettingsViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecorderViewController : UIViewController <AVAudioRecorderDelegate, AVAudioSessionDelegate, LocationControllerDelegate> {
	
	// directory and date
	NSString* caldate;
	NSString* audioFilePath;
	NSString* plistFilePath;
	
	// for recorder
	AVAudioRecorder* recorder;
	BOOL recording;
	IBOutlet UIButton* recordButton;
	UIImage* recordEnabled, *recordPressed;
	IBOutlet UILabel* timer;
	NSTimer* updateTimer;
	
	// for location
	// LocationController* locationController; // try to use singleton object
	IBOutlet UILabel* locationLabel;
	
	IBOutlet UIActivityIndicatorView* spinner;
	
	NSMutableDictionary* tracksAndLocations;
	NSMutableArray* trackNames;
	NSMutableArray* trackLocations;

}

@property (nonatomic, retain) AVAudioRecorder* recorder;
@property (nonatomic, retain) IBOutlet UIButton* recordButton;
@property (nonatomic, retain) NSMutableDictionary* tracksAndLocations;
@property (nonatomic, retain) NSMutableArray* trackNames;
@property (nonatomic, retain) NSMutableArray* trackLocations;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, retain) IBOutlet UILabel* timer;
@property (nonatomic, retain) NSTimer* updateTimer;

- (IBAction)recordOrStop:(id)sender;
//- (IBAction)switchChanged:(id)sender;

@end
