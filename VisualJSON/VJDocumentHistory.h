//
//  VJDocumentHistory.h
//  VisualJSON
//
//  Created by Jeong YunWon on 12. 11. 15..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VJDocumentHistoryItem;

@interface VJDocumentHistory : NSObject {
    NSMutableArray *_history;
}

- (BOOL)synchronize;
- (NSUInteger)count;
- (VJDocumentHistoryItem *)itemAtIndex:(NSInteger)index;
- (void)addHistory:(NSString *)value;

+ (VJDocumentHistory *)defaultHistory;

@end


@interface VJDocumentHistoryItem: NSObject {
    NSString *_address;
    NSMutableArray *_dates;
}

@property(retain) NSString *address;
@property(retain) NSMutableArray *dates;

- (id)initWithDataDictionary:(NSDictionary *)dictionary;
+ (id)historyWithDataDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dataDictionary;

@end
