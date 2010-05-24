//
//  UploadViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 5/23/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import "UploadViewController.h"
#import "JSON/JSON.h"
#import "Connection.h"
#import "ObjectiveResourceConfig.h"
#import "ConnectionManager.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"


@implementation UploadViewController
@synthesize soundwalkPicker, filename, responseData, soundwalkIDs, locations;


- (void)viewDidLoad {
	
	networkQueue = [[ASINetworkQueue alloc] init];
	
    [super viewDidLoad];
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark Upload Methods
- (IBAction)upload:(id)sender
{
	// set up networkqueue
	[networkQueue cancelAllOperations];
	[networkQueue setShowAccurateProgress:YES];
	[networkQueue setUploadProgressDelegate:progressIndicator];
	[networkQueue setDelegate:self];
	// load file to data
	 NSString* filePath = [NSString stringWithFormat:@"%@/%@/%@", DOCUMENTS_FOLDER, @"audio", filename];
	 // getting the date
	 NSFileManager* fileManager = [NSFileManager defaultManager];
	 NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
	 NSString* date = [NSString stringWithFormat:@"%@", [fileAttributes objectForKey:NSFileModificationDate]];
	 
	// getting the soundwalk id for POST
	NSInteger row = [soundwalkPicker selectedRowInComponent:0];
	NSString* selected = [NSString stringWithFormat:@"%@", [soundwalkIDs objectAtIndex:row]];
	NSString* postURL = [NSString stringWithFormat:@"http://www.soundwalks.org/soundwalks/%@/sounds", selected];
	 ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
	 
	 [request setUsername:[ObjectiveResourceConfig getUser]];
	 [request setPassword:[ObjectiveResourceConfig getPassword]];
	 [request setDelegate:self];
	 [request setDidFinishSelector:@selector(requestDone:)];
	 [request setDidFailSelector:@selector(requestWentWrong:)];
	 
	 [request setFile:filePath forKey:@"sound[uploaded_data]"];
	 [request setPostValue:filename forKey:@"sound[description]"];
	 
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
	 //[request start];
	[networkQueue addOperation:request];
	[networkQueue go];
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

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [soundwalkIDs count];
}
#pragma mark Picker Delegate Methods
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"Soundwalk - %@",[soundwalkIDs objectAtIndex:row]];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.soundwalkPicker = nil;
	self.filename = nil;
	self.responseData = nil;
	self.soundwalkIDs = nil;
	self.locations = nil;
}


- (void)dealloc {
	[soundwalkPicker release];
	[filename release];
	[responseData release];
	[soundwalkIDs release];
	[locations release];
	[networkQueue release];
    [super dealloc];
}


@end
