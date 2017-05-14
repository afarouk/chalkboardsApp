//
//  NSDictionary+GetRestaurantDetails.m
//  Community
//
//  Created by dinesh on 29/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSDictionary+GetRestaurantDetails.h"

@implementation NSDictionary (GetRestaurantDetails)
-(NSString*)serviceAccommodatorId{
    return [self objectForKey:@"serviceAccommodatorId"];
}
-(NSString*)serviceLocationId{
     return [self objectForKey:@"serviceLocationId"];
}
-(BOOL)hasHighlightedPromotion{
     return [[self objectForKey:@"hasHighlightedPromotion"]boolValue];
}
-(NSDictionary *)themeColor{
    NSDictionary *theme=[self objectForKey:@"themeColors"];
    return theme;
}
-(NSString *)foregroundDark{
    return [self objectForKey:@"foregroundDark"];
}
-(NSString *)foregroundLight{
    return [self objectForKey:@"foregroundLight"];
}
-(NSString *)background{
    return [self objectForKey:@"background"];
}
-(NSString *)restaurantNameIcon{
    return [self objectForKey:@"restaurantNameIcon"];
}
-(NSString *)logoURL{
    
    return [self objectForKey:@"logoURL"];
}
-(UIImage *)logoImage{
    
    return [self objectForKey:kLogoImageKey];
}

-(BOOL)inNetwork{
     return [[self objectForKey:@"inNetwork"]boolValue];
}
-(NSString *)galleryCount{
    NSDictionary *service=[self objectForKey:@"services"];
    NSDictionary *mediaServiceConfiguration=[service objectForKey:@"mediaserviceConfiguration"];
    NSString *galleryCount=[mediaServiceConfiguration objectForKey:@"maxGalleryCount"];
    return galleryCount;
}
-(NSDictionary *)address{
    
    return [self objectForKey:@"address"];
}
-(NSString *)restaurantName{
    NSString *name=[self objectForKey:@"name"];
    return name;
}
-(NSString *)street1{
    NSString *s1=[self objectForKey:@"street"];
    return s1;
}
-(NSString *)street2{
    NSString *s2=[self objectForKey:@"street2"];
    return s2;
}
-(NSString *)city{
    NSString *c=[self objectForKey:@"city"];
    return c;
}
-(NSString *)country{
    NSString *c=[self objectForKey:@"country"];
    return c;
}
-(NSString *)state{
    NSString *s=[self objectForKey:@"state"];
    return s;
}
-(NSString *)postalCode{
    NSString *ps=[self objectForKey:@"postalCode"];
    return ps;
}
-(NSDictionary *)contact{
    return [self objectForKey:@"contact"];
}
-(NSString *)telephone{
    NSString *p=[self objectForKey:@"telephoneMobile"];
    return p;
}
-(NSDictionary *)anchorURL{
    NSDictionary *anchor=[self objectForKey:@"anchorURL"];
    return anchor;
}
-(NSString *)permanentURL{
    NSString *p=[self objectForKey:@"permanentURL"];
    return p;
}

//Retrive favorite
-(NSString *)icon:(int)index{
  
    NSString *i=[[self objectForKey:@"icon"] objectAtIndex:index];
    return i;
}
-(NSString *)messageFromSASLCount:(int)index{
    NSString *message=[[self objectForKey:@"messageFromSASLCount"] objectAtIndex:index];
    return message;
}
-(NSString *)reservationWithSASLCount:(int)index{
    NSString *reservation=[[self objectForKey:@"reservationWithSASLCount"] objectAtIndex:index];
    return reservation;
}
-(NSString *)requestsFromSASLCount:(int)index{
    NSString *requests=[[self objectForKey:@"requestsFromSASLCount"] objectAtIndex:index];
    return requests;
}
-(NSString *)notificationsFromSASLCount:(int)index{
    NSString *notifications=[[self objectForKey:@"notificationsFromSASLCount"] objectAtIndex:index];
    return notifications;
}
-(NSString *)responsesFromSASLCount:(int)index{
    NSString *responses=[[self objectForKey:@"responsesFromSASLCount"] objectAtIndex:index];
    return responses;
}
-(BOOL)reservationServiceConfigurationEnabled {
    NSNumber *num = [self valueForKeyPath:@"services.reservationServiceConfiguration.masterEnabled"];
    if(num)
        return [num boolValue];
    return NO;
}
-(BOOL)mediaserviceConfigurationEnabled {
    NSNumber *num = [self valueForKeyPath:@"services.mediaserviceConfiguration.masterEnabled"];
    if(num)
        return [num boolValue];
    return NO;
}
-(BOOL)messagingServiceConfigurationEnabled {
    NSNumber *num = [self valueForKeyPath:@"services.messagingServiceConfiguration.masterEnabled"];
    if(num)
        return [num boolValue];
    return NO;
}
-(BOOL)promotionServiceConfigurationEnabled {
    NSNumber *num = [self valueForKeyPath:@"services.promotionServiceConfiguration.masterEnabled"];
    if(num)
        return [num boolValue];
    return NO;
}
-(BOOL)smsEnabled {
    id num = [self valueForKeyPath:@"services.messagingServiceConfiguration.allowSms"];
    if(num && num != [NSNull null])
        return [num boolValue];
    return NO;
}
-(BOOL)emailEnabled {
    id num = [self valueForKeyPath:@"services.messagingServiceConfiguration.allowEmail"];
    if(num && num != [NSNull null])
        return [num boolValue];
    return NO;
}
-(BOOL)allowBookable {
    NSNumber *num = [self valueForKeyPath:@"services.promotionServiceConfiguration.allowBookable"];
    if(num)
        return [num boolValue];
    return NO;
}
@end
