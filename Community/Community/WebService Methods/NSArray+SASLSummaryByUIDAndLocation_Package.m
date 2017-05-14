//
//  NSArray+SASLSummaryByUIDAndLocation_Package.m
//  Community
//
//  Created by dinesh on 21/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSArray+SASLSummaryByUIDAndLocation_Package.h"

@implementation NSArray (SASLSummaryByUIDAndLocation_Package)
-(NSDictionary *)restaurantSASLSummary:(int)i{
    
    return [self objectAtIndex:i];
}
-(NSArray *)mapmarkers:(int)i{
    NSArray *mapmarkersArray=[[self valueForKey:@"mapmarkers"]objectAtIndex:i];
    return mapmarkersArray;
}
@end
