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

@synthesize addressTextField=_addressTextField, postTextField=_postTextField, contentTextField=_contentTextField;
@synthesize jsonOutlineView=_jsonOutlineView, jsonTextView=_jsonTextView;
@synthesize json=_json;

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

- (void)dealloc {
    self.request = nil;
    [super dealloc];
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
    NSLog(@"url: %@, type: %@", url, fileType);
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
	NSPersistentStoreCoordinator *coordinator = [[self managedObjectContext] persistentStoreCoordinator];
	
	id pStore = [coordinator persistentStoreForURL:url];
	NSString *uniqueKey = [NSString stringWithFormat:@"%@:%@:%@", self.request.address, self.request.postdata, self.request.content];
	
	if ((pStore != nil) && (uniqueKey != nil))
	{
		// metadata auto-configured with NSStoreType and NSStoreUUID
		NSMutableDictionary *metadata = [[coordinator metadataForPersistentStore:pStore] mutableCopy];
		[metadata setObject:[NSArray arrayWithObject:uniqueKey] forKey:(NSString *)kMDItemKeywords];
		[coordinator setMetadata:metadata forPersistentStore:pStore];
		return YES;
	}
	return NO;
}

- (void)setRequest:(VJRequest *)request {
    [self->_request autorelease];
    self->_request = [request retain];
}


- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(visualize:) userInfo:nil repeats:NO];
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
    NSString *addr = self.addressTextField.stringValue;
    // do not touch content if address is blank.
    if (addr.length == 0) return;
    
    // decide local or remote
    NSURL *URL = [addr hasPrefix:@"/"] ? addr.fileURL : addr.URL;
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:URL];
    // set mimetype
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // set post if exists
    if (self.postTextField.stringValue.length > 0) {
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:[self.postTextField.stringValue dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // set content field with data
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURLRequest:req error:&error];
    if (data != nil && error == nil) {
        self.contentTextField.stringValue = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
        [self performSelector:@selector(visualize:) withObject:sender afterDelay:0.02];
    } else {
        self.contentTextField.stringValue = [NSString stringWithFormat:@"Error on getting raw JSON text: %@", error];
    }
    
    self.request.content = self.contentTextField.stringValue;
}

- (void)visualize:(id)sender {
    self.json = [JsonElement elementWithObject:[self.contentTextField.stringValue objectFromJSONString]];
    [self.jsonOutlineView performSelector:@selector(reloadData) withObject:nil afterDelay:0.02];
    self.jsonTextView.string = self.json.description;
}

- (NSString *)title {
    return self.addressTextField.stringValue;   
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
