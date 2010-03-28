//
//  Sound.h
//  GeoAudio Recorder
//
//  Created by saurb on 3/27/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEMP_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]

@interface Sound : NSObject {
	
	NSURL* webURL;
	NSString* localFilePath;
	NSMutableData* responseData;

}
@property (nonatomic, retain) NSURL* webURL;
@property (nonatomic, retain) NSString* localFilePath;
@property (nonatomic, retain) NSMutableData* responseData;

- (id)initWithFilePath:(NSString*)URL;
- (void)downloadToFile:(NSString*)name;
@end
