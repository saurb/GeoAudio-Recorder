//
//  SoundwalksTableViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 3/25/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SoundsTableViewController;


@interface SoundwalksTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UITableView* soundwalksTableView;
	NSMutableData* responseData;
	NSMutableArray* soundwalkIDs;
	NSMutableArray* soundwalkTitles;
	NSMutableArray* soundwalkSubtitles;
	SoundsTableViewController* soundsTableViewController;
}
@property(nonatomic, retain)NSMutableArray* soundwalkIDs;
@property(nonatomic, retain)NSMutableData* responseData;
@property(nonatomic, retain)NSMutableArray* soundwalkTitles;
@property(nonatomic, retain)NSMutableArray* soundwalkSubtitles;
@property(nonatomic, retain)SoundsTableViewController* soundsTableViewController;

- (void)getSoundwalkInfo;
- (IBAction)toggleEdit:(id)sender;
@end
