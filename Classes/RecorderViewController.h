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
#import <CoreLocation/CoreLocation.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecorderViewController : UIViewController <AVAudioRecorderDelegate, AVAudioSessionDelegate, CLLocationManagerDelegate> {
	
	// for recorder
	AVAudioRecorder* recorder;
	BOOL recording;
	IBOutlet UIButton* recordButton;
	UIImage* recordEnabled, *recordPressed;
	
	// for location
	CLLocationManager* locationManager;
	CLLocation* location;
	UISwitch* geoSwitch;
	

}

@property (nonatomic, retain) AVAudioRecorder* recorder;
@property (nonatomic, retain) IBOutlet UIButton* recordButton;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, retain) IBOutlet UISwitch* geoSwitch;

- (IBAction)recordOrStop:(id)sender;
- (IBAction)switchChanged:(id)sender;

@end
