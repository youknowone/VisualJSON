//
//  VJDocument.m
//  VisualJSON
//
//  Created by 2012 youknowone.org on 12. 6. 4..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

#import "VJDocument.h"
#import "VJRequest.h"
#import "JSONKit.h"
#import "JsonElement.h"

@interface VJDocument()

- (BOOL)setMetadataForStoreAtURL:(NSURL *)URL;

@end

@implementation VJDocument

@synthesize headerItems=_headerItems, querydataItems=_querydataItems;
@synthesize addressTextField=_addressTextField, methodMatrix=_methodMatrix, methodTextField=_methodTextField, querydataTextField=_querydataTextField, contentTextField=_contentTextField;
@synthesize jsonOutlineView=_jsonOutlineView, jsonTextView=_jsonTextView;
@synthesize drawer=_drawer;
@synthesize querydataTableView=_querydataTableView, querydataTextView=_querydataTextView, headerTableView=_headerTableView, headerTextField=_headerTextField;
@synthesize json=_json;

- (NSString *)defaultHeader {
    return @"Accept:application/json#!;#!;Content-Type:application/json";
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.querydata = self.request.querydata;
    self.method = self.request.method;
    self.header = self.request.header;
}

- (NSString *)address {
    return self->_addressTextField.stringValue;
}

- (void)setAddress:(NSString *)address {
    if (address == nil) address = @"";
    self->_addressTextField.stringValue = address;
    
    self.request.address = address;
}

- (NSString *)header {
    return self->_header;
}

- (void)setHeader:(NSString *)header {
    if (header == nil) header = self.defaultHeader;
        
    [self->_header autorelease];
    self->_header = [header retain];
    
    self.request.header = header;
    self.headerTextField.stringValue = header;
    
    [self->_headerItems release];
    NSMutableArray *headerItems = [[NSMutableArray alloc] init];
    for (NSString *item in [self.header componentsSeparatedByString:@"#!;#!;"]) {
        NSRange delimeterRange = [item rangeOfString:@":"];
        NSString *field, *value = @"";
        if (delimeterRange.location == NSNotFound) {
            field = item;
        } else {
            field = [item substringToIndex:delimeterRange.location];
            value = [item substringFromIndex:delimeterRange.location + delimeterRange.length];
        }
        [headerItems addObject:[ICTuple tupleWithFirst:field second:value]];
    }
    self->_headerItems = headerItems;
    
    [self.headerTableView reloadData];
}

- (NSString *)method {
    return self->_method;
}

- (void)setMethod:(NSString *)method {
    if (method == nil) method = @"GET";
    
    [self->_method autorelease];
    self->_method = [method retain];
    
    self.request.method = method;
    self.methodTextField.stringValue = method;
    NSInteger index = [@[@"GET", @"POST", @"PUT", @"DELETE"] indexOfObject:method];
    if (index < 0) index = 0;
    [self.methodMatrix selectCellAtRow:0 column:index];
}

- (NSString *)querydata {
    return self->_querydata;
}

- (void)setQuerydata:(NSString *)data {
    if (data == nil) data = @"";
    
    [self->_querydata autorelease];
    self->_querydata = [data retain];
    
    self.request.querydata = data;
    
    [self->_querydataItems release];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSString *item in [self.querydata componentsSeparatedByString:@"&"]) {
        NSRange delimeterRange = [item rangeOfString:@"="];
        NSString *field, *value;
        if (delimeterRange.location != NSNotFound) {
            field = [item substringToIndex:delimeterRange.location];
            value = [item substringFromIndex:delimeterRange.location + delimeterRange.length];
        } else {
            field = nil;
            value = item;
        }
        [items addObject:[ICTuple tupleWithFirst:field second:value]];
    }
    self->_querydataItems = items;
    
    self->_querydataTextField.stringValue = data;
    self->_querydataTextView.string = data;
    [self->_querydataTableView reloadData];
}

- (NSString *)content {
    return self->_contentTextField.stringValue;
}

- (void)setContent:(NSString *)content {
    if (content == nil) content = @"";
    self->_contentTextField.stringValue = content;
    
    self.request.content = content;
}

- (void)dealloc {
    [self->_header release];
    [self->_method release];
    [self->_querydata release];
    
    [self->_headerItems release];
    [self->_querydataItems release];
    
    self.request = nil;
    self.drawer = nil;
    [super dealloc];
}

- (void)addressTextFieldChanged:(id)sender {
    self.address = [sender stringValue];
    [self refresh:sender];
}

- (IBAction)methodMatrixChanged:(id)sender {
    NSMatrix *methodMatrix = sender;
    NSDictionary *methods = @{@0 : @"GET", @1: @"POST", @2: @"PUT", @3: @"DELETE"};
    self.method = [methods objectForKey:[NSNumber numberWithInteger:methodMatrix.selectedColumn]];
    [self refresh:sender];
}

- (void)methodTextFieldChanged:(id)sender {
    self.method = [sender stringValue];
}

- (void)querydataTextFieldChanged:(id)sender {
    self.querydata = [sender stringValue];
    [self refresh:sender];
}

- (void)contentTextFieldChanged:(id)sender {
    self.content = [sender stringValue];
    [self visualize:sender];
}

- (void)headerTextFieldChanged:(id)sender {
    self.header = [sender stringValue];
}

- (void)setDefaultHeader:(id)sender {
    self.header = self.defaultHeader;
    [self refresh:sender];
}

#pragma mark - NSPersistentDocument methods

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"VJDocument";
}

- (id)initWithType:(NSString *)typeName error:(NSError **)outError {
    self = [super initWithType:typeName error:outError];
    if (self != nil) {
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        self.request = [NSEntityDescription insertNewObjectForEntityForName:@"Request"
                                                     inManagedObjectContext:managedObjectContext];
		
		// To avoid undo registration for this insertion, removeAllActions on the undoManager.
		// First call processPendingChanges on the managed object context to force the undo registration
		// for this insertion, then call removeAllActions.
        [managedObjectContext processPendingChanges];
        [managedObjectContext.undoManager removeAllActions];
        [self updateChangeCount:NSChangeCleared];
    }
    return self;
}

- (VJRequest *)request {
    if (self->_request == nil) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSError *fetchError = nil;
        NSArray *fetchResults;
        
        @try {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
            
            [fetchRequest setEntity:entity];
            fetchResults = [context executeFetchRequest:fetchRequest error:&fetchError];
        }
        @finally {
            [fetchRequest release];
        }
        
        if ((fetchResults != nil) && (fetchResults.count == 1) && (fetchError == nil)) {
            self.request = [fetchResults objectAtIndex:0];
        }
        else if (fetchError != nil) {
            [self presentError:fetchError];
        }
        else {
            // should present custom error message...
        }
    }
    return self->_request;
}

- (void)setRequest:(VJRequest *)request {
    [self->_request autorelease];
    self->_request = [request retain];
}

-(BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)error {
    //  needed  -- configure not called for writing existing document
	if (self.fileURL != nil)
	{
		[self setMetadataForStoreAtURL:self.fileURL];
	}
	
	return [super writeToURL:absoluteURL ofType:typeName
			forSaveOperation:saveOperation
		 originalContentsURL:absoluteOriginalContentsURL
					   error:error];
}

- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url ofType:(NSString *)fileType modelConfiguration:(NSString *)configuration storeOptions:(NSDictionary *)storeOptions error:(NSError **)error {
    ICLog(TRUE, @"url: %@, type: %@", url, fileType);
	BOOL ok = [super configurePersistentStoreCoordinatorForURL:url ofType:fileType modelConfiguration:configuration storeOptions:storeOptions error:error];
	if (ok)
	{
		NSPersistentStoreCoordinator *coordinator = self.managedObjectContext.persistentStoreCoordinator;
		id pStore = [coordinator persistentStoreForURL:url];
		
		//  configurePersistentStoreCoordinatorForURL is called when document reopened
		//  Check for existing metadata to avoid overwriting unnecessarily
		
		id existingMetadata = [[coordinator metadataForPersistentStore:pStore] objectForKey:(NSString *)kMDItemKeywords];
		if (existingMetadata == nil)
		{
			ok = [self setMetadataForStoreAtURL:url];
		}
	}
	return ok;
}

- (BOOL)setMetadataForStoreAtURL:(NSURL *)url
{
	NSPersistentStoreCoordinator *coordinator = self.managedObjectContext.persistentStoreCoordinator;
	
	id pStore = [coordinator persistentStoreForURL:url];
	NSString *uniqueKey = [NSString stringWithFormat:@"%@:%@:%@:%@:%@", self.request.address, self.method, self.request.querydata, self.request.header, self.request.content];
	
	if ((pStore != nil) && (uniqueKey != nil))
	{
		// metadata auto-configured with NSStoreType and NSStoreUUID
		NSMutableDictionary *metadata = [[coordinator metadataForPersistentStore:pStore] mutableCopy];
		[metadata setObject:[NSArray arrayWithObject:uniqueKey] forKey:(NSString *)kMDItemKeywords];
		[coordinator setMetadata:metadata forPersistentStore:pStore];
        [metadata release];
		return YES;
	}
	return NO;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(visualize:) userInfo:nil repeats:NO]; // rough waiting to load document
}

- (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)printSettings error:(NSError **)outError {
    NSPrintOperation *printOperation = [NSPrintOperation printOperationWithView:self.jsonTextView];
    return printOperation;
}

//+ (BOOL)autosavesInPlace
//{
//    return YES;
//}

- (void)refresh:(id)sender {
    if (self.address.length == 0) return;
    
    NSString *address = self.address;
    
    if (self.querydata.length && (self.method.length == 0 || [self.method isEqualToString:@"GET"])) {
        address = [address stringByAppendingFormat:@"?%@", self.querydata];
    }
        
    // decide local or remote
    NSURL *URL = [address hasPrefix:@"/"] ? address.fileURL : address.URL;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:URL];
    
    for (ICTuple *item in self.headerItems) {
        if ([item.first length] == 0) continue;
        [req addValue:item.second forHTTPHeaderField:item.first];
    }
    
    if (self.method && ![self.method isEqualToString:@"GET"]) {
        [req setHTTPMethod:self.method];
        [req setHTTPBody:self.querydata.dataUsingUTF8Encoding];
    }
    
    // set content field with data
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURLRequest:req error:&error];
    if (data != nil && error == nil) {
        self.content = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
        [self performSelector:@selector(visualize:) withObject:sender afterDelay:0.02];
    } else {
        self.content = [NSString stringWithFormat:@"Error on getting raw JSON text: %@", error];
    }
}

- (void)visualize:(id)sender {
    self.json = [JsonElement elementWithObject:self.content.objectFromJSONString];
    [self.jsonOutlineView performSelector:@selector(reloadData) withObject:nil afterDelay:0.02];
    self.jsonTextView.string = self.json.description;
}

- (void)toggleDrawer:(id)sender {
    [self.drawer toggle:sender];
}

- (void)openWebsite:(id)sender {
    NSURL *URL = @"http://youknowone.github.com/VisualJSON#help".URL;
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (NSString *)title {
    return self.address;
}

#pragma mark - outline delegate for 'tree' view

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == nil) item = self.json;
    return [[item keys] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (item == nil) item = self.json;
    return [item keys] != nil;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) item = self.json;
    return [item childAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if (item == nil) item = self.json;
    NSString *title = [tableColumn.headerCell title];
    if ([title isEqualToString:@"node"]) {
        return [item key];
    } else if ([title isEqualToString:@"description"]) {
        return [item outlineDescription];
    } else {
        ICAssert(NO);
    }
    return nil;
}

@end

#pragma mark -

@implementation VJHeaderTableViewController

- (NSString *)_headerFromHeaderItems {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ICTuple *tuple in self->document.headerItems) {
        NSString *item = tuple.first ? [NSString stringWithFormat:@"%@:%@", tuple.first, tuple.second] : tuple.second;
        [array addObject:item];
    }
    return [array componentsJoinedByString:@"#!;#!;"];
}

- (void)addRow:(id)sender {
    NSInteger index = tableView.selectedRow;
    ICTuple *newItem = [ICTuple tupleWithFirst:@"field" second:@"value"];
    if (index < 0) {
        [self->document.headerItems addObject:newItem];
    } else {
        [self->document.headerItems insertObject:newItem atIndex:index];
    }
    
    self->document.header = [self _headerFromHeaderItems];
}

- (void)removeRow:(id)sender {
    NSUInteger index = tableView.selectedRow;
    if (index == NSNotFound) return;
    
    [self->document.headerItems removeObjectAtIndex:index];
    self->document.header = [self _headerFromHeaderItems];
}

#pragma mark table view delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self->document.headerItems.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ICTuple *item = [self->document.headerItems objectAtIndex:row];
    switch ([aTableView.tableColumns indexOfObjectIdenticalTo:tableColumn]) {
        case 0:
            return item.first;
        case 1:
            return item.second;
        default:
            ICAssert(NO);
            break;
    }
    ICAssert(NO);
    return nil;
}

@end

#pragma mark -

@implementation VJQuerydataTableViewController

- (NSString *)_querydataFromQuerydataItems {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ICTuple *tuple in self->document.querydataItems) {
        NSString *item = tuple.first ? [NSString stringWithFormat:@"%@=%@", tuple.first, tuple.second] : tuple.second;
        [array addObject:item];
    }
    return [array componentsJoinedByString:@"&"];
}

- (void)addRow:(id)sender {
    NSInteger index = tableView.selectedRow;
    ICTuple *newItem = [ICTuple tupleWithFirst:nil second:@""];
    if (index < 0) {
        [self->document.querydataItems addObject:newItem];
    } else {
        [self->document.querydataItems insertObject:newItem atIndex:index];
    }
    
    self->document.querydata = [self _querydataFromQuerydataItems];
}

- (void)removeRow:(id)sender {
    NSUInteger index = tableView.selectedRow;
    if (index == NSNotFound) return;
    
    [self->document.querydataItems removeObjectAtIndex:index];
    self->document.querydata = [self _querydataFromQuerydataItems];
}

#pragma mark text view delegate

- (void)textDidEndEditing:(NSNotification *)notification {
    self->document.querydata = self->textView.string;
}

#pragma mark table view delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self->document.querydataItems.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ICTuple *item = [self->document.querydataItems objectAtIndex:row];
    switch ([aTableView.tableColumns indexOfObjectIdenticalTo:tableColumn]) {
        case 0:
            return item.first;
        case 1:
            return item.second;
        default:
            ICAssert(NO);
            break;
    }
    ICAssert(NO);
    return nil;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ICTuple *tuple = [self->document.querydataItems objectAtIndex:row];
    switch ([aTableView.tableColumns indexOfObjectIdenticalTo:tableColumn]) {
        case 0:
            tuple.first = object;
            break;
        case 1:
            tuple.second = object;
            break;
        default:
            ICAssert(NO);
            break;
    }

    self->document.querydata = [self _querydataFromQuerydataItems];
}

@end

