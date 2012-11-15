//
//  VJDocumentHistory.m
//  VisualJSON
//
//  Created by Jeong YunWon on 12. 11. 15..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

#import "VJDocumentHistory.h"

@implementation VJDocumentHistory

VJDocumentHistory *VJDocumentHistoryDefaultHistory = nil;

+ (void)initialize {
    if (self == [VJDocumentHistory class]) {
        VJDocumentHistoryDefaultHistory = [[VJDocumentHistory alloc] init];
    }
}

- (id)init {
    self =  [super init];
    if (self != nil) {
        self->_history = [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
        if (self->_history == nil) {
            self->_history = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    [self->_history release];
    [super dealloc];
}

- (BOOL)synchronize {
    [[NSUserDefaults standardUserDefaults] setObject:self->_history forKey:@"history"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)count {
    return self->_history.count;
}

- (VJDocumentHistoryItem *)itemAtIndex:(NSInteger)index {
    return [VJDocumentHistoryItem historyWithDataDictionary:[self->_history objectAtIndex:index]];
}

- (void)addHistory:(NSString *)value {
    NSUInteger count = self.count;
    NSInteger index = NSNotFound;
    for (NSInteger i = 0; i < count; i++) {
        if ([[[self->_history objectAtIndex:i] objectForKey:@"address"] isEqualToString:value]) {
            index = i;
            break;
        }
    }
    NSMutableDictionary *itemData;
    if (index == NSNotFound) {
        itemData = [NSMutableDictionary dictionary];
        [itemData setObject:value forKey:@"address"];
        [itemData setObject:[NSMutableArray arrayWithObject:[NSDate date]] forKey:@"dates"];
        [self->_history insertObject:itemData atIndex:0];
    } else {
        itemData = [[self->_history objectAtIndex:index] retain];
        [self->_history removeObjectAtIndex:index];
        [self->_history insertObject:itemData atIndex:0];
        [itemData release];
    }
}

+ (VJDocumentHistory *)defaultHistory {
    return VJDocumentHistoryDefaultHistory;
}

@end


@implementation VJDocumentHistoryItem
@synthesize address=_address, dates=_dates;

- (id)initWithDataDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self != nil) {
        self.address = [dictionary objectForKey:@"address"];
        self.dates = [dictionary objectForKey:@"dates"];
    }
    return self;
}

+ (id)historyWithDataDictionary:(NSDictionary *)dictionary {
    return [[[self alloc] initWithDataDictionary:dictionary] autorelease];
}

- (NSDictionary *)dataDictionary {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:self.address, @"address", self.dates, @"dates", nil];
}

@end
