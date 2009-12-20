//
//  TracksTableViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@class TrackDetailViewController;

@interface TracksTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView* tracksTableView;
	NSArray* tracks;
	TrackDetailViewController* trackDetailViewController;

}

@property (nonatomic, retain) NSArray* tracks;
@end
