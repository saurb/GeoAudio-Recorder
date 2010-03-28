//
//  Sound.m
//  GeoAudio Recorder
//
//  Created by saurb on 3/27/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import "Sound.h"


@implementation Sound
@synthesize webURL, localFilePath, responseData;

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
	[filePath release];

	// Open the connection
	NSLog(@"weburl %@", webURL);
	NSURLRequest* request = [NSURLRequest requestWithURL:webURL];
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		responseData = [[NSMutableData data] retain];
	}
	else {
		NSLog(@" Downloading Sound Connection Failed");
	}

}

#pragma mark -
#pragma mark NSURLConnection methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
	NSLog(@"Connection failed to downloading sound: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
	//[responseData writeToFile:localFilePath atomically:YES];
	/*NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:localFilePath];
	[handle seekToEndOfFile];
	[handle writeData:responseData];
	[handle closeFile];*/
	
}


- (void)dealloc
{
	[webURL release];
	[localFilePath release];
	[responseData release];
	[super dealloc];
}

@end
