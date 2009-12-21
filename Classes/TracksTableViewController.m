//
//  TracksTableViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "TracksTableViewController.h"
#import "TrackDetailViewController.h"
#import "GeoAudio_RecorderAppDelegate.h"


@implementation TracksTableViewController
@synthesize tracks;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidLoad
{
	self.title = @"Tracks";
	
	NSString* audioPath = [[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, @"audio"] retain];
	NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:audioPath error:nil];
	
	self.tracks = files;
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tracks = nil;
	[trackDetailViewController release];
	trackDetailViewController = nil;
	[super viewDidUnload];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tracks count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell
	NSUInteger row = [indexPath row];
	NSString* rowString = [tracks objectAtIndex:row];
	cell.textLabel.text = rowString;
	cell.textLabel.font = [UIFont systemFontOfSize:13.0];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
    return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Hey, do you see the disclosure button?" 
													message:@"If you wanna see detailed infomation, touch that instead." 
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)tableView:(UITableView*)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
{
	if (trackDetailViewController == nil) {
		trackDetailViewController = [[TrackDetailViewController alloc] initWithNibName:@"TrackDetailViewController" bundle:nil];
	}
	
	trackDetailViewController.title = @"Detailed Info";
	
	NSUInteger row = [indexPath row];
	NSString* selectedTrack = [tracks objectAtIndex:row];
	NSString* detailMessage = [[NSString alloc] initWithFormat:@"You selected track %@.", selectedTrack];
	trackDetailViewController.message = detailMessage;
	[detailMessage release];
	[self.navigationController pushViewController:trackDetailViewController animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[tracks release];
	[trackDetailViewController release];
    [super dealloc];
}


@end

