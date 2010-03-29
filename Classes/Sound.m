//
//  Sound.m
//  GeoAudio Recorder
//
//  Created by saurb on 3/27/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import "Sound.h"


@implementation Sound
@synthesize webURL, localFilePath, audioFile;

- (id)initWithFilePath:(NSString*)URL
{
	[super init];
	webURL = [NSURL URLWithString:URL];
	return self;
}

- (void)downloadToFile:(NSString*)name
{
	NSString* filePath = [[NSString stringWithFormat:@"%@/%@.wav", TEMP_FOLDER, name] retain];
	NSLog(@"temp file path %@", filePath);// show the saved path
	localFilePath = filePath;
	
	// create file for download
	BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
	if (!fileExist) {
		[[NSFileManager defaultManager] createFileAtPath:localFilePath contents:nil attributes:nil];
		
		// set up FileHandle
		audioFile = [[NSFileHandle fileHandleForWritingAtPath:localFilePath] retain];
		[filePath release];
		
		// Open the connection
		NSLog(@"weburl %@", webURL);
		NSURLRequest* request = [NSURLRequest 
								 requestWithURL:webURL
								 cachePolicy:NSURLRequestUseProtocolCachePolicy
								 timeoutInterval:60.0];
		NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
	

}

#pragma mark -
#pragma mark NSURLConnection methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
	//[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	[audioFile writeData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
	NSLog(@"Connection failed to downloading sound: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	[audioFile closeFile];
	
}


- (void)dealloc
{
	[webURL release];
	[localFilePath release];
	[audioFile release];
	[super dealloc];
}

@end
