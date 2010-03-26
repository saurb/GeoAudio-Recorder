//
//  SoundwalksTableViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 3/25/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SoundwalksTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UITableView* soundwalksTableView;
	NSMutableData* responseData;
	NSArray* soundwalkIDs;
}
@property(nonatomic, retain)NSArray* soundwalkIDs;

- (void)getSoundwalkIDs;
@end
