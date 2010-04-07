//
//  Sound.m
//  GeoAudio Recorder
//
//  Created by saurb on 3/27/10.
//  Copyright 2010 Arizona State University. All rights reserved.
//

#import "Sound.h"


@implementation Sound
@synthesize webURL, localFilePath, audioFile, delegate;


- (id)initWithFilePath:(NSString*)URL
{
	[super init];
	self.webURL = [NSURL URLWithString:URL];
	//self.delegate = self;
	return self;
}

- (void)downloadToFile
{
	
	// create file for download
	[[NSFileManager defaultManager] createFileAtPath:localFilePath contents:nil attributes:nil];
		
	// set up FileHandle
	audioFile = [[NSFileHandle fileHandleForWritingAtPath:localFilePath] retain];
		
	// Open the connection
	//NSLog(@"weburl %@", webURL);
	NSURLRequest* request = [NSURLRequest 
								requestWithURL:webURL
								cachePolicy:NSURLRequestUseProtocolCachePolicy
								timeoutInterval:60.0];
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	

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
	
	[delegate finished]; // notify delegate download finished
	
}


- (void)dealloc
{
	[webURL release];
	[localFilePath release];
	[audioFile release];
	[delegate release];
	[super dealloc];
}

@end
