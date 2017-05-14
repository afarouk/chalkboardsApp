//
//  NSArray+RestaurantFilterOptionsArray.h
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RestaurantFilterOptionsArray)
-(NSString *)categoryNameAtIndex:(int)i;


//Retrive Favorite Restaurant
-(NSString *)messageFromSASLCount:(int)index;
-(NSString *)reservationWithSASLCount:(int)index;
-(NSString *)requestsFromSASLCount:(int)index;
-(NSString *)notificationsFromSASLCount:(int)index;
-(NSString *)responsesFromSASLCount:(int)index;
-(NSString *)urlKey:(int)index;

//Retrive Review
-(NSString *)reviewId:(int)index;
-(NSString *)rating_img_url:(int)index;
-(NSString *)text_excerpt:(int)index;
-(NSUInteger)yelpReviewRating:(int)index;
-(NSString *)userName:(int)index;
-(NSString *)reviewDate:(int)index;
@end
