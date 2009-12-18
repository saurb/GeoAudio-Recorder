//
//  TracksTableViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThirdLevelViewController;

@interface TracksTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView* tracksTableView;
	NSArray* tracks;
	ThirdLevelViewController* trackDetailViewController;

}

@property (nonatomic, retain) NSArray* tracks;
@end
