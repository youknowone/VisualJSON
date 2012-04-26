//
//  VisualWindow.m
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org All rights reserved.
//

#import "VisualWindow.h"
#import "JsonElement.h"

@implementation VisualWindow
@synthesize addressTextField=_addressTextField, postTextField=_postTextField, contentTextField=_contentTextField;
@synthesize jsonOutlineView=_jsonOutlineView, jsonTextView=_jsonTextView;

@synthesize json=_json;

// after loading nib assets, load last data from standard user defautls
- (void)awakeFromNib {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"address"] == nil) {
        [userDefaults setObject:@"" forKey:@"address"];
    }
    if ([userDefaults objectForKey:@"postdata"] == nil) {
        [userDefaults setObject:@"" forKey:@"postdata"];
    }
    if ([userDefaults objectForKey:@"content"] == nil) {
        [userDefaults setObject:@"" forKey:@"content"];
    }
    
    self.addressTextField.stringValue = [userDefaults objectForKey:@"address"];
    self.postTextField.stringValue = [userDefaults objectForKey:@"postdata"];
    self.contentTextField.stringValue = [userDefaults objectForKey:@"content"];
    [self refresh:nil];
}

// reload data from local/remote address
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
}

- (void)visualize:(id)sender {
    self.json = [JsonElement elementWithObject:[self.contentTextField.stringValue JSONValue]];
    [self.jsonOutlineView performSelector:@selector(reloadData) withObject:nil afterDelay:0.02];
    self.jsonTextView.string = self.json.description;
}

#pragma mark -

- (void)clearDocument:(id)sender {
    self.addressTextField.stringValue = @"";
    self.postTextField.stringValue = @"";
    self.contentTextField.stringValue = @"";
    self.json = nil;
    [self.jsonOutlineView reloadData];
    self.jsonTextView.string = @"";
}

// fake new document. it just clear.
- (void)newDocument:(id)sender {
    if (self.contentTextField.stringValue.length == 0) return;
    NSAlert *alert = [NSAlert alertWithMessageText:@"New document" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"You may lose working document with this action. Do you want to start new document?"];
    [alert beginSheetModalForWindow:self modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)code contextInfo:(void *)info {
    if (code == 1) {
        [self clearDocument:nil];
    }
}

#pragma mark -

- (void)close {
    [super close];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.addressTextField.stringValue forKey:@"address"];
    [userDefaults setValue:self.postTextField.stringValue forKey:@"postdata"];
    [userDefaults setValue:self.contentTextField.stringValue forKey:@"content"];
    [userDefaults synchronize];
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
