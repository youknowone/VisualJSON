//
//  VJJSONPreferencesWindowController.m
//  VisualJSON
//
//  Created by Jeong YunWon on 13. 7. 27..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import "VJJSONPreferencesWindowController.h"

@interface VJJSONPreferencesWindowController ()

@end

@implementation VJJSONPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [userDefaults objectForKey:@"ShowBriefDescription"];
    self.showBriefCheckBox.integerValue = value ? value.integerValue : 1;
	value = [userDefaults objectForKey:@"ShouldAllowInvalidSSLCertificates"];
	self.allowInvalidSSLCheckBox.integerValue = value ? value.integerValue : 1;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)showBriefChanged:(NSButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(sender.integerValue) forKey:@"ShowBriefDescription"];
    [userDefaults synchronize];
}

- (void)setAllowsInvalidSSLCertificates:(NSButton *)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:@(sender.integerValue) forKey:@"ShouldAllowInvalidSSLCertificates"];
	[userDefaults synchronize];
}

@end
