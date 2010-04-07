//
//  GeoAudio_RecorderAppDelegate.m
//  GeoAudio Recorder
//
//  Created by saurb on 12/17/09.
//  Copyright Arizona State University 2009. All rights reserved.
//

#import "GeoAudio_RecorderAppDelegate.h"
#import "TracksNavController.h"
#import "SoundwalksNavController.h"
#import "User.h"
#import "ObjectiveResourceConfig.h"
#import "AuthenticationViewController.h"
#import "Helpers.h"

@interface GeoAudio_RecorderAppDelegate ()
- (void)configureObjectiveResource;
- (void)authenticate;
- (void)showAuthentication:(User *)user;
- (void)addUserObservers:(User *)user;
- (void)removeUserObservers:(User *)user;
@end

@implementation GeoAudio_RecorderAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize tracksNavController;
@synthesize soundwalksNavController;
@synthesize user;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    
	// Override point for customization after application launch
	[self configureObjectiveResource];
	[self authenticate];
	
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
	application.idleTimerDisabled = YES;
	
}

- (void)configureObjectiveResource {    

    [ObjectiveResourceConfig setSite:@"http://soundwalks.org/"];

    [ObjectiveResourceConfig setResponseType:XmlResponse];
    [ObjectiveResourceConfig setUser:self.user.login];
    [ObjectiveResourceConfig setPassword:self.user.password];
}

- (User *)user {
    if (user == nil) {
        NSURL *url = [NSURL URLWithString:[ObjectiveResourceConfig getSite]];
        self.user = [User currentUserForSite:url];
        [self addUserObservers:user];
    }
    return user;
}

- (void)showAuthentication:(User *)aUser {
    AuthenticationViewController *controller = 
	[[AuthenticationViewController alloc] initWithCurrentUser:aUser];
    //[self.tracksNavController pushViewController:controller animated:YES];
	[window addSubview:controller.view];
    [controller release];
}

- (void)authenticate {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // indicate authentication
	
    if ([user hasCredentials]) {
        NSError *error = nil;
        BOOL authenticated = [self.user authenticate:&error];
        if (authenticated == NO) {
            [UIHelpers handleRemoteError:error];
            [self showAuthentication:self.user];
        }
    } else {
        [self showAuthentication:self.user];
    }
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

- (void)addUserObservers:(User *)aUser {
    [aUser addObserver:self forKeyPath:kUserLoginKey options:NSKeyValueObservingOptionNew context:nil];
    [aUser addObserver:self forKeyPath:kUserPasswordKey options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeUserObservers:(User *)aUser {
    [aUser removeObserver:self forKeyPath:kUserLoginKey];
    [aUser removeObserver:self forKeyPath:kUserPasswordKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object change:(NSDictionary *)change 
                       context:(void *)context {
    if ([keyPath isEqualToString:kUserLoginKey]) { 
        [ObjectiveResourceConfig setUser:[object valueForKeyPath:keyPath]];
    } else if ([keyPath isEqualToString:kUserPasswordKey]){
        [ObjectiveResourceConfig setPassword:[object valueForKeyPath:keyPath]];
    }
}

- (void)dealloc {
	
	[tracksNavController release];
	[soundwalksNavController release];
	[rootController release];
    [window release];
	[self removeUserObservers:user];
    [user release];
    [super dealloc];
}



@end
