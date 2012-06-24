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
    NSURL *issueURL = [NSURL URLWithString:@"https://github.com/youknowone/VisualJSON/issues"];
    [[NSWorkspace sharedWorkspace] openURL:issueURL];
}

@end
