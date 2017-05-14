//
//  NSArray+RetrievePseudoReservationsForUser.m
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSArray+RetrievePseudoReservationsForUser.h"

@implementation NSArray (RetrievePseudoReservationsForUser)
-(NSString *)serviceAccommodatorId:(int)i{
    
    return [[self valueForKey:@"serviceAccommodatorId"]objectAtIndex:i];
}
-(NSString *)serviceLocationId:(int)i{
     return [[self valueForKey:@"serviceLocationId"]objectAtIndex:i];
}
-(NSString *)saslName:(int)i{
     return [[self valueForKey:@"saslName"]objectAtIndex:i];
}
-(NSDictionary *)timeRange:(int)i{
     return [[self valueForKey:@"timeRange"]objectAtIndex:i];
}
-(NSString *)logo:(int)i{
     return [[self valueForKey:@"logo"]objectAtIndex:i];
}
@end
