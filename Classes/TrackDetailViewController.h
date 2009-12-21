//
//  ThirdLevelViewController.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationAnnotation.h"


@interface TrackDetailViewController : UIViewController <MKMapViewDelegate> {

	IBOutlet MKMapView* mapView;
	IBOutlet UILabel* trackTitle;
	NSString* message;
	NSArray* locations;
	LocationAnnotation* locationAnnotation;
}

@property (nonatomic, retain) IBOutlet UILabel* trackTitle;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSArray* locations;

@end
