//
//  NSDictionary+GetRestaurantDetails.h
//  Community
//
//  Created by dinesh on 29/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kLogoImageKey @"LogoImage"
@interface NSDictionary (GetRestaurantDetails)

-(NSString*)serviceAccommodatorId;
-(NSString*)serviceLocationId;
-(BOOL)hasHighlightedPromotion;
-(NSDictionary *)themeColor;
-(NSString *)foregroundDark;
-(NSString *)foregroundLight;
-(NSString *)background;
-(NSString *)restaurantNameIcon;
-(NSString *)restaurantName;
-(NSDictionary *)address;
-(NSString *)street1;
-(NSString *)street2;
-(NSString *)city;
-(NSString *)country;
-(NSString *)state;
-(NSString *)postalCode;
-(NSDictionary *)contact;
-(NSString *)telephone;
-(BOOL)inNetwork;
-(NSString *)galleryCount;
-(NSDictionary *)anchorURL;
-(NSString *)permanentURL;
-(NSString *)logoURL;
-(UIImage *)logoImage;

//Retrive Favorite
-(NSString *)icon:(int)index;
-(NSString *)messageFromSASLCount:(int)index;
-(NSString *)reservationWithSASLCount:(int)index;
-(NSString *)requestsFromSASLCount:(int)index;
-(NSString *)notificationsFromSASLCount:(int)index;
-(NSString *)responsesFromSASLCount:(int)index;

-(BOOL)reservationServiceConfigurationEnabled;
-(BOOL)mediaserviceConfigurationEnabled;
-(BOOL)messagingServiceConfigurationEnabled;
-(BOOL)promotionServiceConfigurationEnabled;
-(BOOL)smsEnabled;
-(BOOL)emailEnabled;
-(BOOL)allowBookable;
@end
