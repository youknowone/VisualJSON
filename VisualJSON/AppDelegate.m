//
//  AppDelegate.m
//  VisualJSON
//
//  Created by youknowone on 12. 6. 25..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [Fabric with:@[CrashlyticsKit]];
}

- (void)showPreference:(id)sender {
    [self.preferenceWindowController showWindow:sender];
}

- (void)openWebsite:(id)sender {
    NSURL *URL = @"http://youknowone.github.com/VisualJSON".URL;
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)openIssue:(id)sender {
    NSURL *URL = @"https://github.com/youknowone/VisualJSON/issues".URL;
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)openHelp:(id)sender {
    NSURL *URL = @"https://github.com/youknowone/VisualJSON/wiki".URL;
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)openIRC:(id)sender {
    NSURL *URL = @"irc://irc.freenode.org/#youknowone".URL;
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)openTip:(id)sender {
    NSURL *URL = @"http://youknowone.github.com/VisualJSON#tipme".URL;
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

@end
