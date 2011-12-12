//
//  VisualWindow.h
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org All rights reserved.
//

#import <AppKit/AppKit.h>

@class JsonElement;
@interface VisualWindow : NSWindow<NSOutlineViewDataSource, NSOutlineViewDelegate>

@property(assign) IBOutlet NSTextField *addressTextField;
@property(assign) IBOutlet NSTextField *postTextField;
@property(assign) IBOutlet NSTextField *contentTextField;
@property(assign) IBOutlet NSOutlineView *jsonOutlineView;
@property(assign) IBOutlet NSTextView *jsonTextView;
@property(retain) JsonElement *json;

- (IBAction)refresh:(id)sender;
- (IBAction)visualize:(id)sender;

@end
