//
//  ThirdLevelViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "TrackDetailViewController.h"
#import "AudioPlayer.h"


@implementation TrackDetailViewController
@synthesize audioPlayer;
@synthesize trackTitle;
@synthesize message;
@synthesize locations;
@synthesize playButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	trackTitle.text = message;
	
	playBtnBG = [[[UIImage imageNamed:@"play.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	pauseBtnBG = [[[UIImage imageNamed:@"pause.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	[playButton setImage:playBtnBG forState:UIControlStateNormal];
	//self.audioPlayer = [AudioPlayer initWithFilePath:message];
	self.audioPlayer = [[AudioPlayer alloc] init];
	[self.audioPlayer initWithFilePath:message];
	[self.audioPlayer.player setDelegate:self]; // so that will call the avaudioplayer delegate method
	//self.audioPlayer.fileName = message;
	//audioPlayer.fileName = message;
	NSLog(@"fileName in trackdetailview = %@", audioPlayer.fileName);
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.02;
	span.longitudeDelta = 0.02;
	
	// loop through locations and pin on the map
	for (int i = 0; i < [locations count]; i++) {
		NSString* loc = [locations objectAtIndex:i];
		NSArray* array = [loc componentsSeparatedByString:@","];
		double lat = [[array objectAtIndex:0] doubleValue];
		double lon = [[array objectAtIndex:1] doubleValue];
		
		CLLocationCoordinate2D location;
		location.latitude = lat;
		location.longitude = lon;
		region.span =span;
		region.center = location;
		
		locationAnnotation = [[LocationAnnotation alloc] initWithCoordinate:location];
		locationAnnotation.title = [NSString stringWithFormat:@"%f°,\n%f°", lat, lon];
		[mapView addAnnotation:locationAnnotation];
		[mapView setRegion:region animated:TRUE];
		[mapView regionThatFits:region];
		
	}
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.trackTitle = nil;
	self.locations = nil;
	self.audioPlayer = nil;
}


- (void)dealloc {
	[audioPlayer release];
	[trackTitle release];
	[message release];
	[locations release];
    [super dealloc];
}

- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView* annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.pinColor = MKPinAnnotationColorRed;
	annView.animatesDrop = TRUE;
	annView.canShowCallout = YES;
	annView.calloutOffset = CGPointMake(-5.0, 5.0);
	return annView;
}

#pragma mark -
#pragma mark Player Method
- (IBAction)playButtonPressed:(UIButton*)sender
{
	if (self.audioPlayer.player.playing) {
		[self.playButton setImage:playBtnBG forState:UIControlStateHighlighted];
		[self.playButton setImage:playBtnBG forState:UIControlStateNormal];
		[self.audioPlayer.player pause];
	}
	else {
		[self.playButton setImage:pauseBtnBG forState:UIControlStateHighlighted];
		[self.playButton setImage:pauseBtnBG forState:UIControlStateNormal];
		[self.audioPlayer.player play];
	}

}

#pragma mark -
#pragma mark AVAudioPlayerDelegate Method
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player
                        successfully: (BOOL) completed {
    if (completed == YES) {
        [self.playButton setImage: playBtnBG forState: UIControlStateNormal];
    }
}



@end
