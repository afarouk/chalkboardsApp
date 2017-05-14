//
//  NSDictionary+SASLSummaryByUIDAndLocation.m
//  Community
//
//  Created by dinesh on 21/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"

@implementation NSMutableDictionary (SASLSummaryByUIDAndLocation)
-(NSString *)name{
    
    NSString *n=[self objectForKey:@"name"];
    return n;
}
-(NSString *)domain{
    
    NSString *d=[self objectForKey:@"domain"] ;
    return d;
}
-(NSString *)icon{
    NSString *ic=[self objectForKey:@"icon"] ;
    return ic;
}
-(NSString *)serviceStatusId{
    NSString *ssid=[self objectForKey:@"serviceStatusId"];
    return ssid;
}
-(NSString *)permanentURL{
    NSDictionary *a_url=[self objectForKey:@"anchorURL"];
    NSString *p_url=[a_url objectForKey:@"permanentURL"];
    return p_url;
}
-(NSString *)friendlyURL{
    NSDictionary *a_url=[self objectForKey:@"anchorURL"];
    NSString *f_url=[a_url objectForKey:@"friendlyURL"];
    return f_url;
}
-(NSString *)visibility{
    NSDictionary *a_url=[self objectForKey:@"anchorURL"] ;
    NSString *v=[a_url objectForKey:@"visibility"] ;
    return v;
}
-(NSString *)address_degreeOfMatch{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_dm=[address objectForKey:@"degreeOfMatch"] ;
    return a_dm;
}
-(NSString *)address_rating{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_rate=[address objectForKey:@"rating"];
    return a_rate;
}
-(NSString *)city{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_city=[address objectForKey:@"city"];
    return a_city;
}
-(NSString *)county{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_country=[address objectForKey:@"county"] ;
    return a_country;
}
-(NSNumber *)number{
    NSDictionary *address=[self objectForKey:@"address"];
    NSNumber *a_number=[address objectForKey:@"number"];
    return a_number;
}
-(NSString *)postalCode{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_postalCode=[address objectForKey:@"postalCode"];
    return a_postalCode;
}
-(NSString *)province{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_province=[address objectForKey:@"province"] ;
    return a_province;
    
}
-(NSString *)state{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_state=[address objectForKey:@"state"];
    return a_state;
}
-(NSString *)street{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_street=[address objectForKey:@"street"];
    return a_street;
}
-(NSString *)street2{
    NSDictionary *address=[self objectForKey:@"address"];
    NSString *a_street2=[address objectForKey:@"street2"];
    return a_street2;
    
}
-(NSString *)timeZone{
    NSDictionary *address=[self objectForKey:@"address"] ;
    NSString *a_timeZone=[address objectForKey:@"timeZone"];
    return a_timeZone;
}
-(NSString *)zip{
    NSDictionary *address=[self objectForKey:@"address"] ;
    NSString *a_zip=[address objectForKey:@"zip"];
    return a_zip;
}
-(NSString *)emailMain{
    NSDictionary *contact=[self objectForKey:@"contact"] ;
    NSString *a_emailMain=[contact objectForKey:@"emailMain"];
    return a_emailMain;
}
-(NSString *)firstName{
    NSDictionary *contact=[self objectForKey:@"contact"];
    NSString *a_firstName=[contact objectForKey:@"firstName"];
    return a_firstName;
}
-(NSString *)lastName{
    NSDictionary *contact=[self objectForKey:@"contact"];
    NSString *a_lastName=[contact objectForKey:@"lastName"];
    return a_lastName;
}
-(NSString *)telephoneMain{
    NSDictionary *contact=[self objectForKey:@"contact"] ;
    NSString *a_telephoneMain=[contact objectForKey:@"telephoneMain"];
    return a_telephoneMain;
}
-(NSString *)telephoneMobile{
    NSDictionary *contact=[self objectForKey:@"contact"];
    NSString *a_telephoneMobile=[contact objectForKey:@"telephoneMobile"] ;
    return a_telephoneMobile;
}
-(NSString *)telephoneAux{
    NSDictionary *contact=[self objectForKey:@"contact"] ;
    NSString *a_telephoneAux=[contact objectForKey:@"telephoneAux"];
    return a_telephoneAux;
}
-(NSString *)serviceAccommodatorId{
    NSString *saID=[self objectForKey:@"serviceAccommodatorId"];
    if(saID == nil)
        return @"";
    return saID;
}
-(NSString *)serviceLocationId{
    NSString *slID=[self objectForKey:@"serviceLocationId"];
    if(slID == nil)
        return @"";
    return slID;
    
}
-(NSNumber *)longitude{
    NSNumber *lot=[self objectForKey:@"longitude"];
    return lot;
}
-(NSNumber *)latitude{
    NSNumber *lat=[self objectForKey:@"latitude"];
    return lat;
}
-(NSString *)contactInfo{
    NSString *ct=[self objectForKey:@"contactInfo"];
    return ct;
}
-(NSNumber *)degreeOfMatch{
    NSNumber *dm=[self objectForKey:@"degreeOfMatch"];
    return dm;
}
-(NSNumber *)rating{
    NSNumber *rate=[self objectForKey:@"rating"];
    return rate;
}
-(NSString *)themeColor{
    NSString *tcolor=[self objectForKey:@"themeColor"];
    return tcolor;
}
-(NSString *)promoTypeId{
    NSString *pid=[self objectForKey:@"promoTypeId"];
    return pid;
}
-(NSNumber *)promoCount{
    NSNumber *pct=[self objectForKey:@"promoCount"];
    return pct;
}
-(NSNumber *)iconWidth{
    NSNumber *width=[self objectForKey:@"iconWidth"];
    return width;
}
-(NSNumber *)iconHeight{
    NSNumber *height=[self objectForKey:@"iconHeight"];
    return height;
}
-( BOOL)inNetwork{
    BOOL net=[[self objectForKey:@"inNetwork"] boolValue];
    return net;
}
-(BOOL)isFavorite {
    return [[self valueForKey:@"isFavorite"] boolValue];
}
-(NSString *)serviceStatusString{
    NSString *sss=[self objectForKey:@"serviceStatusString"] ;
    return sss;
}
-(NSString *)serviceStatusColor{
    NSString *ssc=[self objectForKey:@"serviceStatusColor"];
    return ssc;
}
-(NSNumber *)statusID{
    NSNumber *sid=[self objectForKey:@"statusID"] ;
    return sid;
}
-(NSNumber *)trendingScore{
    NSNumber *tscr=[self objectForKey:@"trendingScore"];
    return tscr;
}
-(NSString *)communicationStatusString{
    NSString *css=[self objectForKey:@"communicationStatusString"];
    return css;
}
-(NSString *)communicationStatusColor{
    NSString *csc=[self objectForKey:@"communicationStatusColor"];
    return csc;
}
-(NSNumber *)communicationStatusID{
    NSNumber *csd=[self objectForKey:@"communicationStatusID"];
    return csd;
}
-(NSString *)dateTime{
    NSString *dt=[self objectForKey:@"dateTime"];
    return dt;
}
-(NSNumber *)gallerySize{
    NSNumber *size=[self objectForKey:@"gallerySize"] ;
    return size;
}
-(NSString *)category{
    NSString *ct=[self objectForKey:@"category"] ;
    return ct;
}
-(NSString *)marker{
    NSString *mark=[self objectForKey:@"marker"] ;
    return mark;
}
-(NSString *)rating_img_url{
    NSString *url=[self objectForKey:@"rating_img_url"];
    return url;
}
-(UIImage*)ratingImage {
    return [self objectForKey:@"ratingImage"];
}
-(void)setRatingImage:(UIImage*)image {
    [self setObject:image forKey:@"ratingImage"];
}

@end
