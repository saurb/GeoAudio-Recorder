//
//  LocationAnnotation.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/21/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "LocationAnnotation.h"


@implementation LocationAnnotation
@synthesize coordinate;
@synthesize title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c
{
	coordinate = c;
	return self;
}


@end
