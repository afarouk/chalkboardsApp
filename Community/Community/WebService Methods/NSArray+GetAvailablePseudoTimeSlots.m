//
//  NSArray+GetAvailablePseudoTimeSlots.m
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSArray+GetAvailablePseudoTimeSlots.h"

@implementation NSArray (GetAvailablePseudoTimeSlots)
-(NSString *)floorId:(int)i{
     return [[self valueForKey:@"floorId"] objectAtIndex:i];
}
-(NSArray *)tiers:(int)i{
    return [[self valueForKey:@"tiers"] objectAtIndex:i];
}
-(NSString *)tierId:(int)i{
    
    return [[self valueForKey:@"tierId"]objectAtIndex:i];
}
-(NSString *)tierName:(int)i{
    
    return [[self valueForKey:@"tierName"] objectAtIndex:i];
}
-(NSArray *)timeSlots:(int)i{
    return [[self valueForKey:@"timeSlots"] objectAtIndex:i];
}
-(NSDictionary *)timePair:(int)i{
    return [[self valueForKey:@"timePair"] objectAtIndex:i];
}
-(NSString *)maxHeadPerSeat:(int)i{
    return [[self valueForKey:@"maxHeadPerSeat"] objectAtIndex:i];
}
-(NSString *)maxSeatCount:(int)i{
    return [[self valueForKey:@"maxSeatCount"] objectAtIndex:i];
}
@end
