//
//  LocationController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "LocationController.h"


@implementation LocationController
@synthesize locationManager;
@synthesize location;
@synthesize delegate;

- (id)init
{
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	return self;
}

- (void)dealloc
{
	[self.locationManager release];
	[self.location release];
	[self.delegate release];
	[super dealloc];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
// Called when locaiton is updated
- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation
		   fromLocation:(CLLocation*)oldLocation
{
	[self.delegate locationUpdate:newLocation];
	
	if (location == nil) {
		self.location = newLocation;
	}
	NSString* latitudeString = [[NSString alloc] initWithFormat:@"%g°", newLocation.coordinate.latitude];
	NSLog(@"latitude = %@", latitudeString);
	[latitudeString release];
	
	NSString* longitudeString = [[NSString alloc] initWithFormat:@"%g°", newLocation.coordinate.longitude];
	NSLog(@"longitude = %@", longitudeString);
	[longitudeString release];
	
}

- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error
{
	[self.delegate locationError:error];
	
	NSString* errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error getting location" 
													message:errorType 
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


@end
