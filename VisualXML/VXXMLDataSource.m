//
//  VXXMLDataSource.m
//  VisualJSON
//
//  Created by youknowone on 12. 10. 14..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import "ObjectXML.h"

#import "VXXMLDataSource.h"

id<VJDocumentDataSource> VJDocumentDefaultDataSource() {
    return [[[VXXMLDataSource alloc] init] autorelease];
}

@implementation VXXMLDataSource

- (id)document:(VJDocument *)document structuredDataFromRawDataString:(NSString *)rawData {
    return [OXNode nodeWithString:rawData];
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

@end
