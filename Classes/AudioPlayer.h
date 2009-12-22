//
//  AudioPlayer.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/22/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate> {
	
	IBOutlet UIButton* playButton;
	IBOutlet UIButton* ffwButton;
	IBOutlet UIButton* rewButton;
	
	AVAudioPlayer* player;
	UIImage* playBtnBG, * pauseBtnBG;
	NSString* fileName;

}

@property (nonatomic, retain) UIButton* playButton;
@property (nonatomic, retain) UIButton* ffwButton;
@property (nonatomic, retain) UIButton* rewButton;

@property (nonatomic, retain) AVAudioPlayer* player;
@property (nonatomic, retain) NSString* fileName;

- (IBAction)playButtonPressed:(id)sender;
- (IBAction)rewButtonPressed:(id)sender;
- (IBAction)rewButtonReleased:(id)sender;
- (IBAction)ffwButtonPressed:(id)sender;
- (IBAction)ffwButtonReleased:(id)sender;

@end
