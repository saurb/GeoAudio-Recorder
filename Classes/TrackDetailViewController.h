//
//  ThirdLevelViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationAnnotation.h"
#import <AVFoundation/AVFoundation.h>

@class ASINetworkQueue;
@class UploadViewController;

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface TrackDetailViewController : UIViewController <MKMapViewDelegate, AVAudioPlayerDelegate> {

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
	NSString* message;
	NSArray* locations;
	LocationAnnotation* locationAnnotation;
	
	// for upload
	ASINetworkQueue* networkQueue;
	UploadViewController* uploadViewController;
	
	// for getting user's soundwalk id
	NSMutableData* responseData;
	NSMutableArray* soundwalkIDs;
}

@property (nonatomic, retain) AVAudioPlayer* audioPlayer;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSArray* locations;
@property (nonatomic, retain) IBOutlet UIButton* playButton;
@property (nonatomic, retain) IBOutlet UIButton* ffwButton;
@property (nonatomic, retain) IBOutlet UIButton* rewButton;
@property (nonatomic, retain) UISlider*	progressBar;
@property (nonatomic, retain) UILabel*	currentTime;
@property (nonatomic, retain) UILabel*	duration;
@property (nonatomic, retain) NSTimer* updateTimer;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSMutableArray* soundwalkIDs;

- (IBAction)playButtonPressed:(UIButton*)sender;
- (IBAction)ffwButtonPressed:(UIButton*)sender;
- (IBAction)rewButtonPressed:(UIButton*)sender;
- (IBAction)progressSliderMoved:(UISlider *)sender;
- (void)uploadButtonPressed:(UIButton*)sender;

-(void)getSoundwalkID;

@end
