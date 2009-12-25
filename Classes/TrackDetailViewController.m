//
//  ThirdLevelViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "TrackDetailViewController.h"


@implementation TrackDetailViewController
@synthesize audioPlayer;
@synthesize message;
@synthesize locations;
@synthesize playButton;
@synthesize ffwButton;
@synthesize rewButton;
@synthesize progressBar;
@synthesize currentTime;
@synthesize duration;
@synthesize updateTimer;

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

- (void)viewDidLoad
{
	self.duration.adjustsFontSizeToFitWidth = YES;
	self.currentTime.adjustsFontSizeToFitWidth = YES;
	self.progressBar.minimumValue = 0.0;
	
	updateTimer = nil;
	
	playBtnBG = [[[UIImage imageNamed:@"play.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	pauseBtnBG = [[[UIImage imageNamed:@"pause.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	[playButton setImage:playBtnBG forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
	
	NSString* filePath = [[NSString stringWithFormat:@"%@/%@/%@", DOCUMENTS_FOLDER, @"audio", message] retain];
	NSURL* fileURL = [[[NSURL alloc] initFileURLWithPath:filePath] retain];
	AVAudioPlayer* newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	self.audioPlayer = newPlayer;
	[newPlayer release];
	[audioPlayer prepareToPlay];
	[audioPlayer setDelegate:self];
	
	// update player info
	self.duration.text = [NSString stringWithFormat:@"%d:%02d", (int)self.audioPlayer.duration / 60, (int)self.audioPlayer.duration % 60, nil];
	self.progressBar.maximumValue = self.audioPlayer.duration;
	
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
	self.locations = nil;
	self.audioPlayer = nil;
	self.playButton = nil;
	self.ffwButton = nil;
	self.rewButton = nil;
	self.progressBar = nil;
	self.currentTime = nil;
	self.duration = nil;
}


- (void)dealloc {
	[audioPlayer release];
	[message release];
	[locations release];
	[playButton release];
	[ffwButton release];
	[rewButton release];
	[progressBar release];
	[currentTime release];
	[duration release];
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
	if (self.audioPlayer.playing) {
		[self.playButton setImage:playBtnBG forState:UIControlStateHighlighted];
		[self.playButton setImage:playBtnBG forState:UIControlStateNormal];
		[self.audioPlayer pause];
		self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:self.audioPlayer repeats:YES];
	}
	else {
		[self.playButton setImage:pauseBtnBG forState:UIControlStateHighlighted];
		[self.playButton setImage:pauseBtnBG forState:UIControlStateNormal];
		[self.audioPlayer play];
		[self updateViewForPlayerState];
	}

}

- (void)updateCurrentTime
{
	self.currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)self.audioPlayer.currentTime / 60, (int)self.audioPlayer.currentTime % 60, nil];
	self.progressBar.value = self.audioPlayer.currentTime;
}

- (void)updateViewForPlayerState
{
	[self updateCurrentTime];
	
	if (self.updateTimer) {
		[self.updateTimer invalidate];
	}
	
	if (self.audioPlayer.playing) {
		self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:self.audioPlayer repeats:YES];
	}
	else {
		self.updateTimer = nil;
	}


}

- (IBAction)ffwButtonPressed:(UIButton*)sender
{
	NSTimeInterval time = self.audioPlayer.currentTime;
	time += 3.0;
	if (time > self.audioPlayer.duration) {
		[self.playButton setImage:playBtnBG forState:UIControlStateHighlighted];
		[self.playButton setImage:playBtnBG forState:UIControlStateNormal];
		[self.audioPlayer stop];
		self.progressBar.value = self.audioPlayer.duration;
	}
	else {
		self.audioPlayer.currentTime = time;
		self.progressBar.value = time;
		[self.audioPlayer play];
	}

}

- (IBAction)rewButtonPressed:(UIButton*)sender
{
	NSTimeInterval time = self.audioPlayer.currentTime;
	time -= 2.0;
	if (time < 0) {
		[self.playButton setImage:playBtnBG forState:UIControlStateHighlighted];
		[self.playButton setImage:playBtnBG forState:UIControlStateNormal];
		[self.audioPlayer stop];
		self.progressBar.value = 0;
	}
	else {
		self.audioPlayer.currentTime = time;
		self.progressBar.value = time;
		[self.audioPlayer play];
	}

}

- (IBAction)progressSliderMoved:(UISlider *)sender
{
	self.audioPlayer.currentTime = sender.value;
	[self updateCurrentTime];
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate Method
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player
                        successfully: (BOOL) completed {
    if (completed == YES) {
        [self.playButton setImage: playBtnBG forState: UIControlStateNormal];
		[self.audioPlayer setCurrentTime:0.];
    }
}


@end
