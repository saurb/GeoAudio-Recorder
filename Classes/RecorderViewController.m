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
	
	//TODO: set up the recorder
	recording = NO;
	
	AVAudioSession* audioSession = [AVAudioSession sharedInstance];
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
}


- (void)dealloc {
	[recorder release];
	[recordButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark recorder methods
- (IBAction)recordOrStop:(id)sender
{
	if (recording) {
		[recorder stop];
		recording = NO;
		self.recorder = nil;
		
		[recordButton setTitle:@"Record" forState:UIControlStateNormal];
		[recordButton setTitle:@"Record" forState:UIControlStateHighlighted];
		
		[[AVAudioSession sharedInstance] setActive:NO error:nil];
	}
	else {
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
		
		NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
		
		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
		[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
		[recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		[recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
		
		// create a new dated file
		NSDate* now = [NSDate dateWithTimeIntervalSinceNow:0];
		NSString* caldate = [now description];
		NSString* recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
		NSLog(@"%@", recorderFilePath);// show the saved path
		NSURL* url = [NSURL fileURLWithPath:recorderFilePath];
		
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
		[recorder record];
		[recordButton setTitle:@"Stop" forState:UIControlStateNormal];
		[recordButton setTitle:@"Stop" forState:UIControlStateHighlighted];
		
		recording = YES;
	}

}


@end
