//
//  JsonElement.h
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonElement : NSObject

@property(assign) id parent;
@property(retain) id object;
@property(retain) NSString *key;
@property(retain) NSArray *keys;
@property(retain) NSMutableDictionary *children;

- (id)initWithObject:(id)object;
+ (id)elementWithObject:(id)object;

- (id)childAtIndex:(NSInteger)index;
- (NSString *)outlineDescription;

@end
