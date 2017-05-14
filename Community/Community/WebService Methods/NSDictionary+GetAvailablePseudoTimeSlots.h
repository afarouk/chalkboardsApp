//
//  NSDictionary+GetAvailablePseudoTimeSlots.h
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GetAvailablePseudoTimeSlots)
-(NSArray *)floors;
-(NSDictionary *)startClock;
-(NSDictionary *)endClock;
-(NSString *)hour;
-(NSString *)minute;

@end
