//
//  RecorderViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "RecorderViewController.h"

@implementation RecorderViewController
@synthesize recorder;
@synthesize recordButton;
@synthesize locationController;
@synthesize spinner;
@synthesize tracksAndLocations;
@synthesize trackNames;
@synthesize trackLocations;

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
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// create a audio folder
	audioFilePath = [[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, @"audio"] retain];
	BOOL directoryExist = [[NSFileManager defaultManager] fileExistsAtPath:audioFilePath];
	if (!directoryExist) {
		[[NSFileManager defaultManager] createDirectoryAtPath:audioFilePath attributes:nil];
	}
	// create a plist folder
	plistFilePath = [[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, @"plist"] retain];
	BOOL plistDirectoryExist = [[NSFileManager defaultManager] fileExistsAtPath:plistFilePath];
	if (!plistDirectoryExist) {
		[[NSFileManager defaultManager] createDirectoryAtPath:plistFilePath attributes:nil];
	}
	
	recordEnabled = [[[UIImage imageNamed:@"RecordEnabled.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	recordPressed = [[[UIImage imageNamed:@"RecordPressed.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	
	[recordButton setImage:recordEnabled forState:UIControlStateNormal];
	
	// set up the recorder
	recording = NO;
	
	AVAudioSession* audioSession = [AVAudioSession sharedInstance];
	
	// handle error
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (!audioHWAvailable) {
		UIAlertView* cantRecordAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
																  message:@"Audio input hardware not found"
																 delegate:nil 
														cancelButtonTitle:@"OK" 
														otherButtonTitles:nil];
		[cantRecordAlert show];
		[cantRecordAlert release];
		return;
	}
	
	NSError* err = nil;
	[audioSession setCategory:AVAudioSessionCategoryRecord error:&err];
	if (err) {
		NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		return;
	}
	
	[audioSession setActive:YES error:&err];
	err = nil;
	if (err) {
		NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		return;
	}
	
	// set up for location manager
	locationController = [[LocationController alloc] init];
	locationController.delegate = self;
	
	// init trackLocations array
	trackLocations = [[NSMutableArray alloc] init];
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.recorder = nil;
	self.recordButton = nil;
	self.locationController = nil;
	self.spinner = nil;
	self.tracksAndLocations = nil;
	self.trackNames = nil;
	self.trackLocations = nil;
}


- (void)dealloc {
	[recorder release];
	[recordButton release];
	[locationController release];
	[spinner release];
	[tracksAndLocations release];
	[trackNames release];
	[tracksAndLocations release];
    [super dealloc];
}

/*- (IBAction)switchChanged:(id)sender
{
	geoSwitch = sender;
	if (geoSwitch.on) {
		NSLog(@"geoSwitch is on");
	}
	else {
		NSLog(@"geoSwitch is off");
	}

}*/

#pragma mark -
#pragma mark LocationControllerDelegate Methods
- (void)locationUpdate:(CLLocation*)location
{
	NSMutableString* update = [[NSMutableString alloc] init];
	
	if (signbit(location.horizontalAccuracy)) {
		[update appendString:@"LatLongUnavailable"];
	}
	else {
		// append location with compass direction
		NSString* latitudeString = [[NSString alloc] initWithFormat:@"%f°", location.coordinate.latitude];
		[update appendString:latitudeString];
		[latitudeString release];
		[update appendString:@" "];
		NSString* sOrN = signbit(location.coordinate.latitude) ? @"S" : @"N";
		[update appendString:sOrN];
		[update appendString:@"\n"];
		NSString* longitudeString = [[NSString alloc] initWithFormat:@"%f°", location.coordinate.longitude];
		[update appendString:longitudeString];
		[longitudeString release];
		[update appendString:@" "];
		NSString* wOrE = signbit(location.coordinate.longitude) ? @"W" : @"E";
		[update appendString:wOrE];
		
		// push location update to trackLocations
		NSString* loc = [[NSString alloc] initWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
		[trackLocations addObject:loc];
		[loc release];
		
		locationLabel.text = update;
		[update release];
		
	}

}


#pragma mark -
#pragma mark recorder methods
- (IBAction)recordOrStop:(id)sender
{
	
	if (!recording) {
		
		// start updating location
		[locationController.locationManager startUpdatingLocation];
		
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
		
		NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
		
		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
		[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
		[recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		[recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
		
		// create a new dated file
		NSDate* now = [NSDate dateWithTimeIntervalSinceNow:0];
		caldate = [now description];
		
		NSString* recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", audioFilePath, caldate] retain];
		NSLog(@"%@", recorderFilePath);// show the saved path
		NSURL* url = [NSURL fileURLWithPath:recorderFilePath];
		[caldate retain]; // retain so that when stop the location plist name will be the same as the audio file
		
		// init recorder with url
		NSError* err = nil;
		AVAudioRecorder* newRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
		if (!newRecorder) {
			NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
															message:[err localizedDescription]
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		[recordSetting release];
		self.recorder = newRecorder;
		[newRecorder release];
		
		// prepare to record
		recorder.delegate = self;
		[recorder prepareToRecord];
		
		// start recording
		[recorder record];
		
		//[recordButton setTitle:@"Stop" forState:UIControlStateNormal];
		//[recordButton setTitle:@"Stop" forState:UIControlStateHighlighted];
		[recordButton setImage:recordPressed forState:UIControlStateNormal];
		
		recording = YES;
		[spinner startAnimating];
	}
	else {
		
		[recorder stop];
		recording = NO;
		[spinner stopAnimating];
		self.recorder = nil;
		
		//[recordButton setTitle:@"Record" forState:UIControlStateNormal];
		//[recordButton setTitle:@"Record" forState:UIControlStateHighlighted];
		[recordButton setImage:recordEnabled forState:UIControlStateNormal];
		
		[[AVAudioSession sharedInstance] setActive:NO error:nil];
		
		[locationController.locationManager stopUpdatingLocation];
		NSLog(@"locationManager stopped.");
		
		// save to plist
		NSMutableString* plistName = [[NSMutableString alloc] init];
		[plistName appendString:caldate];
		[plistName appendString:@".plist"];
	
		NSString* path = [plistFilePath stringByAppendingPathComponent:plistName];
		
		//NSArray* key = [[NSArray alloc] initWithObjects:keyName, nil];
		//tracksAndLocations = [[NSMutableDictionary alloc] init];
		//[tracksAndLocations initWithObjects:trackLocations forKeys:key];
		
		//[tracksAndLocations writeToFile:path atomically:YES];
		[trackLocations writeToFile:path atomically:YES];
		[plistName release];
	}

}


@end
