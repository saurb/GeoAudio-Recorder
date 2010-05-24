//
//  UploadViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 5/23/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UploadViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

	UIPickerView* soundwalkPicker;
	NSString* filename;
	NSMutableData* responseData;
	NSMutableArray* soundwalkIDs; //TODO: need to get titles later!
	
}
@property(nonatomic, retain) IBOutlet UIPickerView* soundwalkPicker;
@property(nonatomic, retain) NSString* filename;
@property(nonatomic, retain) NSMutableData* responseData;
@property(nonatomic, retain) NSMutableArray* soundwalkIDs;


@end
