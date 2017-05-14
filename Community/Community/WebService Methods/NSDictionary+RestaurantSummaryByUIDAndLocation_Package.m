//
//  NSDictionary+RestaurantSummaryByUIDAndLocation_Package.m
//  Community
//
//  Created by dinesh on 20/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSDictionary+RestaurantSummaryByUIDAndLocation_Package.h"

@implementation NSDictionary (RestaurantSummaryByUIDAndLocation_Package)
-(NSArray *)restaurantsummary{
    NSArray *summaryArray=[self objectForKey:@"restaurantsummary"];
    return summaryArray;
}
-(NSArray *)mapmarkers{
    NSArray *summaryArray=[self objectForKey:@"restaurantsummary"];
    NSArray *mapmarkersArray=[summaryArray valueForKey:@"mapmarkers"];
    return mapmarkersArray;
}
-(NSArray *)saslMapMarkers{
    NSArray *mapmarkersArray=[self objectForKey:@"mapmarkers"];
    return mapmarkersArray;
}

@end
