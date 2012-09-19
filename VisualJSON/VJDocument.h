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

@interface VJDocument : NSPersistentDocument<NSMatrixDelegate> {
    NSString *_header;
    NSString *_method;
    NSString *_querydata;
    
    NSMutableArray *_headerItems;
    NSMutableArray *_querydataItems;
    
    NSTextField *_addressTextField;
    NSMatrix *_methodMatrix;
    NSTextField *_methodTextField;
    NSTextField *_querydataTextField;
    NSTextField *_contentTextField;
    NSOutlineView *_jsonOutlineView;
    NSTextView *_jsonTextView;
    
    NSDrawer *_drawer;
    NSTableView *_querydataTableView;
    NSTextView *_querydataTextView;
    NSTableView *_headerTableView;
    NSTextField *_headerTextField;
    
    JsonElement *_json;
    
    VJRequest *_request;
}

@property(retain) NSString *address;
@property(retain) NSString *header;
@property(retain) NSString *method;
@property(retain) NSString *querydata;
@property(retain) NSString *content;

@property(readonly) NSMutableArray *headerItems;
@property(readonly) NSMutableArray *querydataItems;

@property(assign) IBOutlet NSTextField *addressTextField;
@property(assign) IBOutlet NSMatrix *methodMatrix;
@property(assign) IBOutlet NSTextField *methodTextField;
@property(assign) IBOutlet NSTextField *querydataTextField;
@property(assign) IBOutlet NSTextField *contentTextField;
@property(assign) IBOutlet NSTextField *headerTextField;
@property(assign) IBOutlet NSOutlineView *jsonOutlineView;
@property(assign) IBOutlet NSTextView *jsonTextView;

@property(assign) IBOutlet NSDrawer *drawer;
@property(assign) IBOutlet NSTableView *querydataTableView;
@property(assign) IBOutlet NSTextView *querydataTextView;
@property(assign) IBOutlet NSTableView *headerTableView;

@property(retain) JsonElement *json;
@property(retain) VJRequest *request;

- (IBAction)setDefaultHeader:(id)sender;

- (IBAction)addressTextFieldChanged:(id)sender;
- (IBAction)methodMatrixChanged:(id)sender;
- (IBAction)methodTextFieldChanged:(id)sender;
- (IBAction)querydataTextFieldChanged:(id)sender;
- (IBAction)contentTextFieldChanged:(id)sender;
- (IBAction)headerTextFieldChanged:(id)sender;

- (IBAction)refresh:(id)sender;
- (IBAction)visualize:(id)sender;
- (IBAction)toggleDrawer:(id)sender;

- (IBAction)openWebsite:(id)sender;

@end

@interface VJHeaderTableViewController : NSObject<NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet VJDocument *document;
    
    IBOutlet NSTableView *tableView;
}

- (IBAction)addRow:(id)sender;
- (IBAction)removeRow:(id)sender;

@end

@interface VJQuerydataTableViewController : NSObject<NSTableViewDataSource, NSTableViewDelegate, NSTextViewDelegate> {
    IBOutlet VJDocument *document;
    
    IBOutlet NSTableView *tableView;
    IBOutlet NSTextView *textView;
}

- (IBAction)addRow:(id)sender;
- (IBAction)removeRow:(id)sender;

@end
