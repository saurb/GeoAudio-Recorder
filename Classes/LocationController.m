//
//  LocationController.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "LocationController.h"

static LocationController* sharedCLDelegate = nil;

@implementation LocationController
@synthesize locationManager;
@synthesize location;
@synthesize delegate;
@synthesize locationManagerStartDate;

- (id)init
{
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.locationManagerStartDate = [[NSDate date] retain];
	}
	return self;
}

- (void)dealloc
{
	[self.locationManager release];
	[self.location release];
	[self.delegate release];
	[self.locationManagerStartDate release];
	[super dealloc];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
// Called when locaiton is updated
- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation
		   fromLocation:(CLLocation*)oldLocation
{
	BOOL isLocationGood = [self isValidLocation:newLocation
								withOldLocation:oldLocation];
	
	if (isLocationGood) {
		[self.delegate locationUpdate:newLocation];
	}
	
	if (location == nil) {
		self.location = newLocation;
	}
	NSString* latitudeString = [[NSString alloc] initWithFormat:@"%f°", newLocation.coordinate.latitude];
	NSLog(@"latitude = %@", latitudeString);
	[latitudeString release];
	
	NSString* longitudeString = [[NSString alloc] initWithFormat:@"%f°", newLocation.coordinate.longitude];
	NSLog(@"longitude = %@", longitudeString);
	[longitudeString release];
	
}

- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error
{
	
	NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];
	
	if ([error domain] == kCLErrorDomain) {
		
		// handle CoreLocation-related errors
		
		switch ([error code]) {
				// This error code is usually returned whenever user taps "Don't Allow" in response to
				// being told your app wants to access the current location. Once this happens, you cannot
				// attempt to get the location again until the app has quit and relaunched.
				//
				// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
				// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
				//
			case kCLErrorDenied:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationDenied", nil)];
				break;
				
				// This error code is usually returned whenever the device has no data or WiFi connectivity,
				// or when the location cannot be determined for some other reason.
				//
				// CoreLocation will keep trying, so you can keep waiting, or prompt the user.
				//
			case kCLErrorLocationUnknown:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
				break;
				
				// Shouldn't ever get an unknown error code, but just in case...
				//
			default:
				[errorString appendFormat:@"%@ %d\n", NSLocalizedString(@"GenericLocationError", nil), [error code]];
				break;
		}
	} else {
		// We handle all non-CoreLocation errors here
		// (we depend on localizedDescription for localization)
		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
		[errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
	}
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error getting location" 
													message:errorString 
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Bad Location Filter Methods

- (BOOL)isValidLocation:(CLLocation *)newLocation
		withOldLocation:(CLLocation *)oldLocation
{
    // Filter out nil locations
    if (!newLocation)
    {
        return NO;
    }
    
    // Filter out points by invalid accuracy
    if (newLocation.horizontalAccuracy < 0)
    {
        return NO;
    }
    
    // Filter out points that are out of order
    NSTimeInterval secondsSinceLastPoint =
	[newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    
    if (secondsSinceLastPoint < 0)
    {
        return NO;
    }
    
    // Filter out points created before the manager was initialized
    NSTimeInterval secondsSinceManagerStarted =
	[newLocation.timestamp timeIntervalSinceDate:locationManagerStartDate];
    
    if (secondsSinceManagerStarted < 0)
    {
        return NO;
    }
    
    // The newLocation is good to use
    return YES;
}

#pragma mark -
#pragma mark Singleton Object Methods

+ (LocationController*)sharedInstance {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedCLDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [super allocWithZone:zone];
            return sharedCLDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}



@end
