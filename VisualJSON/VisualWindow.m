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

- (void)refresh:(id)sender {
    NSString *addr = self.addressTextField.stringValue;
    if (addr.length == 0) return;
    
    NSURL *URL = [addr hasPrefix:@"/"] ? [NSURL fileURLWithPath:addr] : [NSURL URLWithString:addr];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:URL];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (self.postTextField.stringValue.length > 0) {
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:[self.postTextField.stringValue dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
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
