//
//  ThirdLevelViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "TrackDetailViewController.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ObjectiveResourceConfig.h"



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
@synthesize uploadButton;


- (void)viewDidLoad
{
	self.duration.adjustsFontSizeToFitWidth = YES;
	self.currentTime.adjustsFontSizeToFitWidth = YES;
	self.progressBar.minimumValue = 0.0;
	
	updateTimer = nil;
	
	playBtnBG = [[[UIImage imageNamed:@"play.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	pauseBtnBG = [[[UIImage imageNamed:@"pause.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	[playButton setImage:playBtnBG forState:UIControlStateNormal];
	
	// init networkqueue
	networkQueue = [[ASINetworkQueue alloc] init];
	
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
	//TODO: what if file exceeds in minutes?
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
	[networkQueue release]; // release networkqueue
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

// TODO:exceeds minutes?
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

#pragma mark -
#pragma mark Upload Method
- (IBAction)uploadButtonPressed:(UIButton*)sender
{
	/*[networkQueue cancelAllOperations];
	[networkQueue setShowAccurateProgress:YES];
	//[networkQueue setUploadProgressDelegate:progressIndicator];
	[networkQueue setDelegate:self];*/
	
	// load file to data
	NSString* filePath = [NSString stringWithFormat:@"%@/%@/%@", DOCUMENTS_FOLDER, @"audio", message];
	// getting the date
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
	NSString* date = [NSString stringWithFormat:@"%@", [fileAttributes objectForKey:NSFileModificationDate]];

	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.soundwalks.org/soundwalks/33/sounds"]];
	
	[request setUsername:[ObjectiveResourceConfig getUser]];
	[request setPassword:[ObjectiveResourceConfig getPassword]];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDone:)];
	[request setDidFailSelector:@selector(requestWentWrong:)];
	
	[request setFile:filePath forKey:@"sound[uploaded_data]"];
	[request setPostValue:message forKey:@"sound[description]"];
	
	// get location
	//ISSUE: location different from website after uploading
	// Only use the first location for now!
	NSString* loc = [locations objectAtIndex:0];
	NSArray* array = [loc componentsSeparatedByString:@","];
	NSString* lat = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
	NSString* lon = [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
	[request setPostValue:lat forKey:@"sound[lat]"];
	[request setPostValue:lon forKey:@"sound[lng]"];
	[request setPostValue:date forKey:@"sound[recorded_at]"];
	[request setTimeOutSeconds:500];
	[request start];
	
	//[networkQueue addOperation:request];
	
	//[networkQueue go];
	
	
	/*NSString* filePath = [NSString stringWithFormat:@"%@/%@/%@", DOCUMENTS_FOLDER, @"audio", message];
	NSData* audioData = [[[NSData alloc] initWithContentsOfFile:filePath] autorelease];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:@"http://www.soundwalks.org/soundwalks/33/sounds"]];
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sound[uploaded_data]\"; filename=\"s161.wav\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];	
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:audioData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sound[description]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"test"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sound[lat]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"37.331689"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sound[lng]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"-122.030731"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sound[recorded_at]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"2009-11-28 10:57:51 UTC"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"return %@",returnString);*/
	
	
}

- (void)requestDone:(ASIFormDataRequest *)request
{
	NSString *response = [request responseString];
	NSLog(@"response %@", response);
}

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
	NSError *error = [request error];
	NSLog(@"error %@",[error localizedDescription]);

}



@end
