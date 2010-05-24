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


@implementation UploadViewController
@synthesize soundwalkPicker, filename, responseData, soundwalkIDs;

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

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
}


- (void)dealloc {
	[soundwalkPicker release];
	[filename release];
	[responseData release];
	[soundwalkIDs release];
    [super dealloc];
}


@end
