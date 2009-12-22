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

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface TrackDetailViewController : UIViewController <MKMapViewDelegate, AVAudioPlayerDelegate> {

	// for audio player
	AVAudioPlayer* audioPlayer;
	IBOutlet UIButton* playButton;
	IBOutlet UIButton* ffwButton;
	IBOutlet UIButton* rewButton;
	UIImage* playBtnBG, * pauseBtnBG;
	
	// for map
	IBOutlet MKMapView* mapView;
	IBOutlet UILabel* trackTitle;
	NSString* message;
	NSArray* locations;
	LocationAnnotation* locationAnnotation;
}

@property (nonatomic, retain) AVAudioPlayer* audioPlayer;
@property (nonatomic, retain) IBOutlet UILabel* trackTitle;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSArray* locations;
@property (nonatomic, retain) IBOutlet UIButton* playButton;
@property (nonatomic, retain) IBOutlet UIButton* ffwButton;
@property (nonatomic, retain) IBOutlet UIButton* rewButton;

- (IBAction)playButtonPressed:(UIButton*)sender;
- (IBAction)ffwButtonPressed:(UIButton*)sender;
- (IBAction)rewButtonPressed:(UIButton*)sender;
@end
