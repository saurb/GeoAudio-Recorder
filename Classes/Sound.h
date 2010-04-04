//
//  Sound.h
//  GeoAudio Recorder
//
//  Created by saurb on 3/27/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol DownloadCompleteDelegate <NSObject>
@required
- (void)finished;
@end


@interface Sound : NSObject <DownloadCompleteDelegate> {
	
	NSURL* webURL;
	NSString* localFilePath;
	NSFileHandle* audioFile;
	id delegate;

}
@property (nonatomic, retain) NSURL* webURL;
@property (nonatomic, retain) NSString* localFilePath;
@property (nonatomic, retain) NSFileHandle* audioFile;
@property (nonatomic, assign) id <DownloadCompleteDelegate> delegate; 

- (id)initWithFilePath:(NSString*)URL;
- (void)downloadToFile;
@end
