//
//  SoundDetailViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 3/26/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationAnnotation.h"
#import <AVFoundation/AVFoundation.h>
@class Sound;

@interface SoundDetailViewController : UIViewController <MKMapViewDelegate, AVAudioPlayerDelegate> {
	
	Sound* sound;
	NSString* soundID;
	
	// for JSON
	NSString* soundURL;
	NSMutableData* responseData;
	
	// for audio player
	AVAudioPlayer* audioPlayer;
	IBOutlet UIButton* playButton;
	IBOutlet UIButton* ffwButton;
	IBOutlet UIButton* rewButton;
	UIImage* playBtnBG, * pauseBtnBG;
	
	IBOutlet UISlider* progressBar;
	IBOutlet UILabel* currentTime;
	IBOutlet UILabel* duration;
	
	NSTimer* updateTimer;
	
	
	// for map
	IBOutlet MKMapView* mapView;
	CLLocationCoordinate2D location;
	LocationAnnotation* locationAnnotation;

}
@property (nonatomic, retain) Sound* sound;
@property (nonatomic, retain) NSString* soundID;
@property (nonatomic, retain) NSString* soundURL;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) AVAudioPlayer* audioPlayer;
@property (nonatomic, retain) IBOutlet UIButton* playButton;
@property (nonatomic, retain) IBOutlet UIButton* ffwButton;
@property (nonatomic, retain) IBOutlet UIButton* rewButton;
@property (nonatomic, retain) UISlider*	progressBar;
@property (nonatomic, retain) UILabel*	currentTime;
@property (nonatomic, retain) UILabel*	duration;
@property (nonatomic, retain) NSTimer* updateTimer;

- (void)getSoundInfo;

- (IBAction)playButtonPressed:(UIButton*)sender;
- (IBAction)ffwButtonPressed:(UIButton*)sender;
- (IBAction)rewButtonPressed:(UIButton*)sender;
- (IBAction)progressSliderMoved:(UISlider *)sender;

@end
