//
//  AppDelegate.m
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    return YES;
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender {
    [self.window orderFrontRegardless];
    return YES;
}

@end
