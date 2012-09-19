//
//  AppDelegate.m
//  VisualJSON
//
//  Created by youknowone on 12. 6. 25..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (IBAction)openIssue:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://github.com/youknowone/VisualJSON/issues"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)openHelp:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://github.com/youknowone/VisualJSON/wiki"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)openIRC:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"irc://irc.freenode.org/#youknowone"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

@end
