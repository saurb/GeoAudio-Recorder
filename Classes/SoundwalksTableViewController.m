//
//  SoundwalksTableViewController.m
//  GeoAudio Recorder
//
//  Created by saurb on 3/25/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import "SoundwalksTableViewController.h"
#import "JSON/JSON.h"
#import "SoundsTableViewController.h"
#import "Response.h"
#import "Connection.h"
#import "NSObject+ObjectiveResource.h"
#import "ConnectionManager.h"

#define SOUNDWALKS_ID_URL @"http://soundwalks.org/soundwalks.json"

@implementation SoundwalksTableViewController
@synthesize soundwalkIDs, soundsTableViewController, responseData;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (IBAction)toggleEdit:(id)sender
{
	[self.tableView setEditing:!self.tableView.editing animated:YES];
}


- (void)viewDidLoad {
	
	soundwalkIDs = [[NSMutableArray alloc] init];
	
	[self getSoundwalkIDs];
	
	UIBarButtonItem* editButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Delete"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(toggleEdit:)];
	self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
	
    [super viewDidLoad];
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getSoundwalkIDs
{
	self.title = @"Getting Soundwalks ...";
	responseData = [[NSMutableData data] retain];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:SOUNDWALKS_ID_URL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark NSURLConnection methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
	NSLog(@"Connection failed to getting soundwalks: %@", [error description]);
	self.title = @"Error Getting Soundwalks";
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	self.title = @"Latest Soundwalks";
	
	NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSArray* IDs = [responseString JSONValue];
	
	// Pass object in IDs into Dictionary
	for (NSDictionary* ID in IDs) {

		NSString* soundwalkID = [ID objectForKey:@"id"];
		[soundwalkIDs addObject:soundwalkID];
	}

	[soundwalksTableView reloadData];
}




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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.soundwalkIDs = nil;
	self.soundsTableViewController = nil;
	self.responseData = nil;
	[super viewDidUnload];
}


#pragma mark Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	 return [soundwalkIDs count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSUInteger row = [indexPath row];
	NSString* rowString = [NSString stringWithFormat:@"Soundwalk %@",[soundwalkIDs objectAtIndex:row]]; // Cast to NSString first!
	//NSLog(@"%@", rowString);
	cell.textLabel.text = rowString;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (void)tableView:(UITableView*)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
{
	soundsTableViewController = [[SoundsTableViewController alloc] initWithNibName:@"SoundsTableView" bundle:nil];
	
	soundsTableViewController.title = @"Sounds";
	
	NSUInteger row = [indexPath row];
	NSString* selectedSoundwalk = [[soundwalkIDs objectAtIndex:row] retain];
	soundsTableViewController.soundwalkID = selectedSoundwalk;
	soundsTableViewController.soundsURL = [NSString stringWithFormat:@"http://soundwalks.org/soundwalks/%@/sounds.json", selectedSoundwalk];
	
	[self.navigationController pushViewController:soundsTableViewController animated:YES];
}

- (void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row = [indexPath row];
	NSString* path = [NSString stringWithFormat:@"http://soundwalks.org/soundwalks/%@",[self.soundwalkIDs objectAtIndex:row]];
	
	// Delete Request
	//TODO: Error Handling
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	NSURL *url = [[NSURL alloc] initWithString:path];
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
	[req setHTTPMethod:@"DELETE"];
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];  
	NSData *response = [NSURLConnection sendSynchronousRequest:req 
											 returningResponse:&urlResponse
														 error:&error];  
	NSString *result = [[NSString alloc] initWithData:response 
											 encoding:NSUTF8StringEncoding];
	
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
		NSLog(@"Response: %@", result);
	[url release];
	[req release];
	[result release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	
	// Remove row at tableview
	[self.soundwalkIDs removeObjectAtIndex:row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
					 withRowAnimation:UITableViewRowAnimationFade];
	
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
	[soundwalkIDs release];
	[soundsTableViewController release];
	[responseData release];
    [super dealloc];
}


@end

