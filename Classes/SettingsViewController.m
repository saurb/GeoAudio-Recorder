//
//  SettingsViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/23/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "SettingsViewController.h"

#define kSwitchesSegmentIndex 0


@implementation SettingsViewController

@synthesize distanceFilterSwitch;
@synthesize distanceFilterSlider;
@synthesize distanceFilterValueLabel;
@synthesize distanceFilterSliderLabel1, distanceFilterSliderLabel2, distanceFilterSliderLabel3, distanceFilterSliderLabel4;
@synthesize recordQualityLabel;
@synthesize filterControls;


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

// set up global variable
BOOL recordQuality;

+ (BOOL)recordQuality { return recordQuality; }
+ (void)setRecordQuality:(BOOL)new
{
	recordQuality = new;
}

- (void)viewDidLoad
{
	self.filterControls = [NSArray arrayWithObjects:distanceFilterSlider,
						   distanceFilterValueLabel,
						   distanceFilterSliderLabel1, 
						   distanceFilterSliderLabel2, 
						   distanceFilterSliderLabel3, 
						   distanceFilterSliderLabel4, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Set up the controls to the right initial values, based on the current state of the CoreLocation object
	[self setControlStatesFromSource:[LocationController sharedInstance]];
	
	recordQualityLabel.text = @"Normal";
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.distanceFilterSwitch = nil;
	self.distanceFilterSlider = nil;
	self.distanceFilterValueLabel = nil;
	self.distanceFilterSliderLabel1 = nil;
	self.distanceFilterSliderLabel2 = nil;
	self.distanceFilterSliderLabel3 = nil;
	self.distanceFilterSliderLabel4 = nil;
	self.recordQualityLabel = nil;
	self.filterControls = nil;
}


- (void)dealloc {
	[distanceFilterSwitch release];
	[distanceFilterSlider release];
	[distanceFilterValueLabel release];
	[distanceFilterSliderLabel1 release];
	[distanceFilterSliderLabel2 release];
	[distanceFilterSliderLabel3 release];
	[distanceFilterSliderLabel4 release];
	[recordQualityLabel release];
    
	[filterControls release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Control Callbacks
- (IBAction)doneButtonPressed:(id)sender
{
	if (filterToSet != previousFilter) {
		[LocationController sharedInstance].locationManager.distanceFilter = filterToSet;
	}
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Settings Changed" 
													message:@"Your new settings have been saved." 
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

// Toggles the "enabled" state all of the controls associated with the filter value
- (void) setFilterControlsEnabled:(BOOL)state {
	for (UIControl *control in filterControls) {
		control.enabled = state;
	}
}

- (IBAction)switchAction:(id)sender {
	BOOL newState = [sender isOn];
	
	// Controls are disabled if switch is off
	[self setFilterControlsEnabled:newState];
	
	// If the switch is on, distance filter is current slider value, otherwise set it to "none"
	if ( newState ) {
		[self sliderValueChanged:self];
	} else {
		filterToSet = kCLDistanceFilterNone;
	}
}

// Takes the value of the slider and puts it in a label underneath it
- (void) updateSliderLabel {
	double value = pow(10, [distanceFilterSlider value]);
	distanceFilterValueLabel.text = [NSString stringWithFormat:@"%.0f %@", value, (value < 1.5) ? NSLocalizedString(@"MeterSingular", @"meter") : NSLocalizedString(@"MeterPlural", @"meters")];
}

// Called when the slider is moved, with live updating
- (IBAction)sliderValueChanged:(id)sender {
	// The distance filter slider is an exponential scale, base 10.
	// Slider returns a value in the range 0.0 to 3.0 (set in Interface Builder).
	// Corresponds to a range of 1 to 1000, exponentially.
	filterToSet = pow(10, distanceFilterSlider.value);
	[self updateSliderLabel];
}

// Sets the state of the controls based on the state of the location manager
- (void) setControlStatesFromSource:(LocationController *) clDelegate {
	// Current values from the source object
	previousFilter = filterToSet = clDelegate.locationManager.distanceFilter;
	
	// Set up filter controls
	// Since the slider is exponential (base 10), converting the other way is done with a base 10 logarithm.
	// If the filter is set to "none", we choose a default value of 10 (log10 of which is 1, hard coded below).
	[distanceFilterSwitch setOn:(previousFilter != kCLDistanceFilterNone) animated:NO];
	[distanceFilterSlider setValue:((previousFilter == kCLDistanceFilterNone) ? 1 : log10(fabs(previousFilter))) animated:NO];
	[self updateSliderLabel];
	[self setFilterControlsEnabled:[distanceFilterSwitch isOn]];
}	

- (IBAction)toggleQuality:(id)sender
{
	if ([sender selectedSegmentIndex] == kSwitchesSegmentIndex) {
		
		recordQuality = NO;
		recordQualityLabel.text = @"Normal";
	}
	else {
		
		recordQuality = YES;
		recordQualityLabel.text = @"Best";
	}

}



@end
