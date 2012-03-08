//
//  PEAppDelegate.m
//  Paginator Example
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "PEAppDelegate.h"
#import "PERootViewController.h"

@implementation PEAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	
	UIViewController *viewController = [[PERootViewController alloc] init];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
	
	[self.window makeKeyAndVisible];
	return YES;
}

@end
