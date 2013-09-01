//
//  VJJSONPreferencesWindowController.h
//  VisualJSON
//
//  Created by Jeong YunWon on 13. 7. 27..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VJJSONPreferencesWindowController : NSWindowController

@property(nonatomic,strong) IBOutlet NSButton *showBriefCheckBox;

@property(nonatomic,strong) IBOutlet NSButton *allowInvalidSSLCheckBox;

- (IBAction)showBriefChanged:(id)sender;

- (IBAction)setAllowsInvalidSSLCertificates:(id)sender;

@end
