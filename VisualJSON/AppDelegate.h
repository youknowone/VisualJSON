//
//  AppDelegate.h
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VisualWindow;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet VisualWindow *window;

- (IBAction)newDocument:(id)sender;

@end
