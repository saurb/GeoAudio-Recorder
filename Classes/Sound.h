//
//  Sound.h
//  GeoAudio Recorder
//
//  Created by saurb on 3/27/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface Sound : NSObject {
	
	NSURL* webURL;
	NSString* localFilePath;
	NSFileHandle* audioFile;

}
@property (nonatomic, retain) NSURL* webURL;
@property (nonatomic, retain) NSString* localFilePath;
@property (nonatomic, retain) NSFileHandle* audioFile;

- (id)initWithFilePath:(NSString*)URL;
- (void)downloadToFile:(NSString*)name;
@end
