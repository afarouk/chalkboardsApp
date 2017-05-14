//
//  NSDictionary+RestaurantFilterOptions.m
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSDictionary+RestaurantFilterOptions.h"

@implementation NSDictionary (RestaurantFilterOptions)
-(NSDictionary *)filterOptions{
    
    NSDictionary *options=[self objectForKey:@"filterOptions"];
    return options;
}
-(NSArray *)categoryKey:(NSString *)key{
    
    NSArray *array=[self objectForKey:key];
    return array;
}
@end
