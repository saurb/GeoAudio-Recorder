//
//  AudioPlayer.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/22/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "AudioPlayer.h"

// amount to skip on rewind or fast forward
#define SKIP_TIME 3.0			
// amount to play between skips
#define SKIP_INTERVAL .2
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation AudioPlayer
@synthesize playButton;
@synthesize ffwButton;
@synthesize rewButton;
@synthesize player;
@synthesize fileName;

- (id)initWithFilePath:(NSString*)p
{
	self.fileName = p;
	
	playBtnBG = [[[UIImage imageNamed:@"play.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	pauseBtnBG = [[[UIImage imageNamed:@"pause.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	[playButton setImage:playBtnBG forState:UIControlStateNormal];
	NSLog(@"fileName in audioplayer = %@", fileName);
	
	NSString* filePath = [[NSString stringWithFormat:@"%@/%@/%@", DOCUMENTS_FOLDER, @"audio", fileName] retain];
	NSLog(@"filePath = %@", filePath);
	NSURL* fileURL = [[[NSURL alloc] initFileURLWithPath:filePath] retain];
	NSLog(@"url = %@", fileURL);
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	[fileURL release];
	[filePath release];
	
	[self.player prepareToPlay];
	[self.player setDelegate:self];
	return self;
}

/*- (void)awakeFromNib
{	
	playBtnBG = [[[UIImage imageNamed:@"play.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	pauseBtnBG = [[[UIImage imageNamed:@"pause.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	[playButton setImage:playBtnBG forState:UIControlStateNormal];
	NSLog(@"fileName in audioplayer = %@", fileName);
	
	NSString* filePath = [[NSString stringWithFormat:@"%@/%@/%@", DOCUMENTS_FOLDER, @"audio", fileName] retain];
	NSURL* fileURL = [[[NSURL alloc] initFileURLWithPath:filePath] retain];
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	[fileURL release];
	[filePath release];
	
	[player prepareToPlay];
	[player setDelegate:self];

}*/

- (void)dealloc
{
	[fileName release];
	[playBtnBG release];
	[fileName release];
	[playButton release];
	[ffwButton release];
	[rewButton release];
	[player release];
	
	[super dealloc];
}

- (void)pausePlayback
{
	[self.player pause];
	[self.playButton setImage:playBtnBG forState:UIControlStateHighlighted];
}

- (void)startPlayback
{
	[self.playButton setImage:pauseBtnBG forState:UIControlStateHighlighted];
	//[self.player play];
	
	if ([self.player play]) {
		self.player.delegate = self;
	}
	else {
		NSLog(@"Could not play %@.", self.player.url);
	}

}

- (IBAction)playButtonPressed:(id)sender
{
	/*if (self.player.playing == YES) {
		[self pausePlayback];
	}
	else {
		[self startPlayback];
	}*/
	[self.player play];
}

- (IBAction)rewButtonPressed:(id)sender
{
	
}

- (IBAction)rewButtonReleased:(id)sender
{
	
}

- (IBAction)ffwButtonPressed:(id)sender
{
	
}

- (IBAction)ffwButtonReleased:(id)sender
{
	
}

/*#pragma mark AudioSession methods

void RouteChangeListener(	void *                  inClientData,
						 AudioSessionPropertyID	inID,
						 UInt32                  inDataSize,
						 const void *            inData)
{
	avTouchController* This = (avTouchController*)inClientData;
	
	if (inID == kAudioSessionProperty_AudioRouteChange) {
		
		CFDictionaryRef routeDict = (CFDictionaryRef)inData;
		NSNumber* reasonValue = (NSNumber*)CFDictionaryGetValue(routeDict, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		
		int reason = [reasonValue intValue];
		
		if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
			
			[This pausePlayback];
		}
	}
}

- (void)setupAudioSession
{
	AVAudioSession *session = [AVAudioSession sharedInstance];
	NSError *error = nil;
	
	[session setCategory: AVAudioSessionCategoryPlayback error: &error];
	if (error != nil)
		NSLog(@"Failed to set category on AVAudioSession");
	
	// AudioSession and AVAudioSession calls can be used interchangeably
	OSStatus result = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, RouteChangeListener, self);
	if (result) NSLog(@"Could not add property listener! %d\n", result);
	
	BOOL active = [session setActive: YES error: nil];
	if (!active)
		NSLog(@"Failed to set category on AVAudioSession");
	
}*/

#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
	
	if (flag == YES) {
		[self.playButton setImage:playBtnBG forState:UIControlStateNormal];
	}
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error); 
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	// the object has already been paused,	we just need to update UI
	//[self updateViewForPlayerState];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	[self startPlayback];
}


@end
