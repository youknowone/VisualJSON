//
//  VJDocument.h
//  VisualJSON
//
//  Created by 2012 youknowone.org on 12. 6. 4..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

@class VJTabController;
@class VJRequest;
@class JsonElement;

@interface VJDocument : NSPersistentDocument {
    NSTextField *_addressTextField;
    NSTextField *_postTextField;
    NSTextField *_contentTextField;
    NSOutlineView *_jsonOutlineView;
    NSTextView *_jsonTextView;
    JsonElement *_json;
    
    VJRequest *_request;
}

@property(assign) IBOutlet NSTextField *addressTextField;
@property(assign) IBOutlet NSTextField *postTextField;
@property(assign) IBOutlet NSTextField *contentTextField;
@property(assign) IBOutlet NSOutlineView *jsonOutlineView;
@property(assign) IBOutlet NSTextView *jsonTextView;
@property(retain) JsonElement *json;
@property(retain) VJRequest *request;

- (IBAction)refresh:(id)sender;
- (IBAction)visualize:(id)sender;

@end
