//
//  NSDictionary+RestaurantFilterOptions.h
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RestaurantFilterOptions)
-(NSDictionary *)filterOptions;
-(NSArray *)categoryKey:(NSString *)key;
@end
