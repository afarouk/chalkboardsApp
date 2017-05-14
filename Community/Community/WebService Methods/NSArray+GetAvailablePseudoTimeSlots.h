//
//  NSArray+GetAvailablePseudoTimeSlots.h
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GetAvailablePseudoTimeSlots)
-(NSArray *)tiers:(int)i;
-(NSString *)floorId:(int)i;
-(NSString *)tierId:(int)i;
-(NSString *)tierName:(int)i;
-(NSArray *)timeSlots:(int)i;
-(NSDictionary*)timePair:(int)i;
-(NSString *)maxHeadPerSeat:(int)i;
-(NSString *)maxSeatCount:(int)i;


@end
