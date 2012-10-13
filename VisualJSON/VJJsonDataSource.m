//
//  VJJsonDataSource.m
//  VisualJSON
//
//  Created by youknowone on 12. 10. 14..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import "JSONKit.h"
#import "JsonElement.h"

#import "VJJsonDataSource.h"

id<VJDocumentDataSource> VJDocumentDefaultDataSource() {
    return [[[VJJsonDataSource alloc] init] autorelease];
}

@implementation VJJsonDataSource

- (id)document:(VJDocument *)document structuredDataFromRawDataString:(NSString *)rawData {
    return [JsonElement elementWithObject:rawData.objectFromJSONString];
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

@end
