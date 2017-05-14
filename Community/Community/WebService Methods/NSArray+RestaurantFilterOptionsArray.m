//
//  NSArray+RestaurantFilterOptionsArray.m
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSArray+RestaurantFilterOptionsArray.h"

@implementation NSArray (RestaurantFilterOptionsArray)
-(NSString *)categoryNameAtIndex:(int)i{
    
    NSString *category=[NSString stringWithFormat:@"%@",[self objectAtIndex:i]];
    return category;
}


//Retrive favorite
-(NSString *)icon:(int)index{
    
    NSString *i=[[self valueForKey:@"icon"] objectAtIndex:index];
    return i;
}
-(NSString *)messageFromSASLCount:(int)index{
    NSString *message=[[self valueForKey:@"messageFromSASLCount"] objectAtIndex:index];
    return message;
}
-(NSString *)reservationWithSASLCount:(int)index{
    NSString *reservation=[[self valueForKey:@"reservationWithSASLCount"] objectAtIndex:index];
    return reservation;
}
-(NSString *)requestsFromSASLCount:(int)index{
    NSString *requests=[[self valueForKey:@"requestsFromSASLCount"] objectAtIndex:index];
    return requests;
}
-(NSString *)notificationsFromSASLCount:(int)index{
    NSString *notifications=[[self valueForKey:@"notificationsFromSASLCount"] objectAtIndex:index];
    return notifications;
}
-(NSString *)responsesFromSASLCount:(int)index{
    NSString *responses=[[self valueForKey:@"responsesFromSASLCount"] objectAtIndex:index];
    return responses;
}
-(NSString *)urlKey:(int)index{
    NSString *url=[[self valueForKey:@"urlKey"] objectAtIndex:index];
    return url;
}


//Retrive Review
-(NSString *)reviewId:(int)index{
    NSString *r_id=[[self valueForKey:@"id"] objectAtIndex:index];
    return r_id;
}
-(NSString *)rating_img_url:(int)index{
    NSString *r_url=[[self valueForKey:@"rating_img_url"] objectAtIndex:index];
    return r_url;
}
-(NSString *)text_excerpt:(int)index{
    NSString *r_text=[[self valueForKey:@"text_excerpt"] objectAtIndex:index];
    return r_text;
}
-(NSUInteger)yelpReviewRating:(int)index {
    NSNumber *num = [[self valueForKey:@"rating"] objectAtIndex:index];
    if(num)
        return [num intValue];
    return 0;
}
-(NSString *)userName:(int)index{
    NSString *r_name=[[self valueForKey:@"userName"] objectAtIndex:index];
    return r_name;
}
-(NSString *)reviewDate:(int)index{
    NSString *r_date=[[self valueForKey:@"reviewDate"] objectAtIndex:index];
    return r_date;
}

@end
