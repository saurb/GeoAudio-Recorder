//
//  LocationAnnotation.h
//  GeoAudio Recorder
//
//  Created by saurb on 12/21/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface LocationAnnotation : NSObject <MKAnnotation>{
	
	CLLocationCoordinate2D coordinate;
	NSString* title;
	
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString* title;
@end
