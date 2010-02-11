//
//  LocationController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// protocol for sending location updates to another view controller
@protocol LocationControllerDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation*)location;
@end



@interface LocationController : NSObject <CLLocationManagerDelegate> {
	
	CLLocationManager* locationManager;
	CLLocation* location;
	NSDate* locationManagerStartDate;
	id delegate;

}

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, assign) id <LocationControllerDelegate> delegate;
@property (nonatomic, retain) NSDate* locationManagerStartDate;

+ (LocationController*)sharedInstance;
- (BOOL)isValidLocation:(CLLocation *)newLocation withOldLocation:(CLLocation *)oldLocation;

@end
