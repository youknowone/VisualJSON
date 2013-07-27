//
//  AppDelegate.h
//  VisualJSON
//
//  Created by youknowone on 12. 6. 25..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDelegate : NSObject

@property(nonatomic,retain) IBOutlet NSWindowController *preferenceWindowController;

- (IBAction)showPreference:(id)sender;

- (IBAction)openWebsite:(id)sender;
- (IBAction)openIssue:(id)sender;
- (IBAction)openHelp:(id)sender;
- (IBAction)openIRC:(id)sender;
- (IBAction)openTip:(id)sender;

@end
