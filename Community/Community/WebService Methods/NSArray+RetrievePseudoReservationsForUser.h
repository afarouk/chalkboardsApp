//
//  NSArray+RetrievePseudoReservationsForUser.h
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RetrievePseudoReservationsForUser)
-(NSString *)serviceAccommodatorId:(int)i;
-(NSString *)serviceLocationId:(int)i;
-(NSString *)saslName:(int)i;
-(NSString *)logo:(int)i;
-(NSDictionary *)timeRange:(int)i;

@end
