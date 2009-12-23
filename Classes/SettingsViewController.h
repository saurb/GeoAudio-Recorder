//
//  SettingsViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/23/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"

@interface SettingsViewController : UIViewController {
	
	IBOutlet UISwitch* distanceFilterSwitch;
	IBOutlet UISlider* distanceFilterSlider;
	IBOutlet UILabel *distanceFilterValueLabel;
	IBOutlet UILabel *distanceFilterSliderLabel1;
	IBOutlet UILabel *distanceFilterSliderLabel2;
	IBOutlet UILabel *distanceFilterSliderLabel3;
	IBOutlet UILabel *distanceFilterSliderLabel4;
	
	NSArray* filterControls;
	
	CLLocationDistance previousFilter, filterToSet;

}

@property (nonatomic, retain) UISwitch *distanceFilterSwitch;
@property (nonatomic, retain) UISlider *distanceFilterSlider;
@property (nonatomic, retain) UILabel *distanceFilterValueLabel;
@property (nonatomic, retain) UILabel *distanceFilterSliderLabel1;
@property (nonatomic, retain) UILabel *distanceFilterSliderLabel2;
@property (nonatomic, retain) UILabel *distanceFilterSliderLabel3;
@property (nonatomic, retain) UILabel *distanceFilterSliderLabel4;
@property (nonatomic, retain) NSArray *filterControls;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)switchAction:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (void)setControlStatesFromSource:(LocationController *)clDelegate;

@end
