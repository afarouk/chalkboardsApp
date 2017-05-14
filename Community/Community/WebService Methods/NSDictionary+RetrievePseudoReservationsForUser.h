//
//  NSDictionary+RetrievePseudoReservationsForUser.h
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RetrievePseudoReservationsForUser)
-(NSString *)saslName;
-(NSString *)serviceAccommodatorId;
-(NSString *)serviceLocationId;
-(NSString *)reservationUUID;
-(NSDictionary *)timeRange;
-(NSString *)reservationDate;
-(NSString *)logo;
-(NSDictionary *)startClock;
-(NSDictionary *)endClock;
-(NSString *)hour;
-(NSString *)minute;
@end
