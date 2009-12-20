//
//  LocationController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationController : NSObject <CLLocationManagerDelegate> {
	
	CLLocationManager* locationManager;
	CLLocation* location;

}

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* location;

@end
