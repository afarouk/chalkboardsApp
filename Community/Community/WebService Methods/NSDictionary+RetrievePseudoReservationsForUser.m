//
//  NSDictionary+RetrievePseudoReservationsForUser.m
//  Community
//
//  Created by dinesh on 02/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSDictionary+RetrievePseudoReservationsForUser.h"

@implementation NSDictionary (RetrievePseudoReservationsForUser)
-(NSString *)saslName{
        return [self objectForKey:@"saslName"];
}
-(NSString *)serviceAccommodatorId{
     return [self objectForKey:@"serviceAccommodatorId"];
}
-(NSString *)serviceLocationId{
     return [self objectForKey:@"serviceLocationId"];
}
-(NSString *)reservationUUID{
    return [self objectForKey:@"reservationUUID"];
}
-(NSDictionary *)timeRange{
    return [self objectForKey:@"timeRange"];
}
-(NSString *)reservationDate{
    return [self objectForKey:@"reservationDate"];
}
-(NSString *)logo{
    return [self objectForKey:@"logo"];
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
