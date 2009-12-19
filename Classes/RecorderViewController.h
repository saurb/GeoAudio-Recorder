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

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecorderViewController : UIViewController <AVAudioRecorderDelegate, AVAudioSessionDelegate> {
	AVAudioRecorder* recorder;
	BOOL recording;
	
	IBOutlet UIButton* recordButton;
	
	UIImage* recordEnabled, *recordPressed;

}

@property (nonatomic, retain) AVAudioRecorder* recorder;
@property (nonatomic, retain) IBOutlet UIButton* recordButton;

- (IBAction)recordOrStop:(id)sender;

@end
