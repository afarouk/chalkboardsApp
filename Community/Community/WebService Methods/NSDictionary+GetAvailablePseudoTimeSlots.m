//
//  NSDictionary+GetAvailablePseudoTimeSlots.m
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSDictionary+GetAvailablePseudoTimeSlots.h"

@implementation NSDictionary (GetAvailablePseudoTimeSlots)
-(NSArray *)floors{
    
    return [self objectForKey:@"floors"];
}
-(NSDictionary *)startClock{
     return [self  objectForKey:@"startClock"];
}
-(NSDictionary *)endClock{
     return [self objectForKey:@"endClock"];
}
-(NSString *)hour{
    return [self  objectForKey:@"hour"];
}
-(NSString *)minute{
    return [self objectForKey:@"minute"];
}
@end
