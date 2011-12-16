//
//  AppDelegate.m
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org All rights reserved.
//

#import "AppDelegate.h"

#import "VisualWindow.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)newDocument:(id)sender {
    if(self.window.isVisible) {
        [self.window newDocument:sender];
    } else {
        [self.window orderFrontRegardless];
        [self.window clearDocument:nil];
    }
}

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
