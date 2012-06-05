//
//  JsonElement.h
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @brief  JSON data to representation converter
    
    JsonElement get parsed NSArray or NSDictionary data as JSON data.
    JsonElement provides representation for data for each view type.
 */
@interface JsonElement : NSObject {
    id _parent;
    id _object;
    id _key;
    id _keys;
    id _children;
}

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
