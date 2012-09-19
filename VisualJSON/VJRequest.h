//
//  Request.h
//  VisualJSON
//
//  Created by 2012 youknowone.org on 12. 6. 5..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

@interface VJRequest : NSManagedObject

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSString *querydata;
@property (nonatomic, retain) NSString *content;

@end
