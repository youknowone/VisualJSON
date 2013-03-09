//
//  VJXMLDocumentDelegate.m
//  VisualJSON
//
//  Created by youknowone on 12. 10. 14..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import "ObjectXML.h"

#import "VJXMLDocumentDelegate.h"

@implementation VJXMLDocumentDelegate

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

    return chr == '<';
}

- (id)document:(VJDocument *)document structuredDataFromRawDataString:(NSString *)rawData {
    OXNode *node = [OXNode nodeWithString:rawData];
    return node;
}

- (NSString *)document:(VJDocument *)document prettyTextFromData:(id)data {
    return data ? [data description] : @"";
}

- (NSUInteger)document:(VJDocument *)document outlineChildrenCountForItem:(id)item {
    return [[(OXNode *)item children] count];
}

- (BOOL)document:(VJDocument *)document outlineIsItemExpandable:(id)item {
    return YES; // OMG
}

- (NSString *)document:(VJDocument *)document outlineTitleForItem:(id)item {
    return [item name];
}

- (NSString *)document:(VJDocument *)document outlineDescriptionForItem:(id)item {
    return [item description];
}

- (id)document:(VJDocument *)document outlineChild:(NSInteger)index ofItem:(id)item {
    return [[item children] objectAtIndex:index];
}

id VJXMLDocumentDelegateSharedObject = nil;

+ (void)initialize {
    if (self == [VJXMLDocumentDelegate class]) {
        VJXMLDocumentDelegateSharedObject = [[self alloc] init];
    }
}

+ (id)sharedObject {
    return VJXMLDocumentDelegateSharedObject;
}

@end
