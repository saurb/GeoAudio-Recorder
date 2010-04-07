//
//  SoundsTableViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 3/26/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SoundDetailViewController;

@interface SoundsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
	
	IBOutlet UITableView* soundsTableView;
	NSString* soundwalkID;
	NSMutableArray* soundIDs;
	NSString* soundsURL;
	
	NSMutableData* responseData;
	
	SoundDetailViewController* soundDetailViewController;

}
@property(nonatomic, retain)NSString* soundwalkID;
@property(nonatomic, retain)NSMutableArray* soundIDs;
@property(nonatomic, retain)NSMutableData* responseData;
@property(nonatomic, retain)NSString* soundsURL;
@property(nonatomic, retain)SoundDetailViewController* soundDetailViewController;

- (void)getSoundIDs;
- (void)toggleEdit;
@end
