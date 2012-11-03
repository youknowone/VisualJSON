//
//  VJJsonDocumentDelegate.m
//  VisualJSON
//
//  Created by youknowone on 12. 10. 14..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import "JsonElement.h"

#import "VJJsonDocumentDelegate.h"

id<VJDocumentDelegate> VJDocumentDefaultDataSource() {
    return [[[VJJsonDocumentDelegate alloc] init] autorelease];
}

@implementation VJJsonDocumentDelegate

- (BOOL)document:(VJDocument *)document dataIsValid:(NSString *)rawData {
    NSInteger index = 0;
    unichar chr;
    do {
        if (index >= rawData.length) {
            return NO;
        }
        chr = [rawData characterAtIndex:index];
        index += 1;
    } while ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:chr]);

    return chr == '[' || chr == '{';
}

- (id)document:(VJDocument *)document structuredDataFromRawDataString:(NSString *)rawData {
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[rawData dataUsingUTF8Encoding] options:NSJSONReadingAllowFragments error:&error];
    // TODO: do something with error
    return [JsonElement elementWithObject:obj];
}

- (NSString *)document:(VJDocument *)document prettyTextFromData:(id)data {
    return data ? [data description] : @"";
}

- (NSUInteger)document:(VJDocument *)document outlineChildrenCountForItem:(id)item {
    return [[item keys] count];
}

- (BOOL)document:(VJDocument *)document outlineIsItemExpandable:(id)item {
    return [item keys] != nil;
}

- (NSString *)document:(VJDocument *)document outlineTitleForItem:(id)item {
    return [item key];
}

- (NSString *)document:(VJDocument *)document outlineDescriptionForItem:(id)item {
    return [item outlineDescription];
}

- (id)document:(VJDocument *)document outlineChild:(NSInteger)index ofItem:(id)item {
    return [item childAtIndex:index];
}

id VJJsonDocumentDelegateSharedObject = nil;

+ (void)initialize {
    if (self == [VJJsonDocumentDelegate class]) {
        VJJsonDocumentDelegateSharedObject = [[self alloc] init];
    }
}

+ (id)sharedObject {
    return VJJsonDocumentDelegateSharedObject;
}

@end
