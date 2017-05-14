//
//  NSDictionary+RestaurantSummaryByUIDAndLocation.m
//  Community
//
//  Created by dinesh on 20/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSArray+RestaurantSummaryByUIDAndLocation.h"

@implementation NSArray (RestaurantSummaryByUIDAndLocation)
-(NSString *)name:(int)i;{
    
    NSString *n=[[self valueForKey:@"name"]objectAtIndex:i];
    return n;
}
-(NSString *)domain:(int)i{
    
    NSString *d=[[self valueForKey:@"domain"] objectAtIndex:i];
    return d;
}
-(NSString *)icon:(int)i{
    NSString *ic=[[self valueForKey:@"icon"] objectAtIndex:i];
    return ic;
}
-(NSString *)serviceStatusId:(int)i{
    NSString *ssid=[[self valueForKey:@"serviceStatusId"]objectAtIndex:i ];
    return ssid;
}
-(NSString *)permanentURL:(int)i{
    NSDictionary *a_url=[[self valueForKey:@"anchorURL"]objectAtIndex:i ];
    NSString *p_url=[a_url objectForKey:@"permanentURL"];
    return p_url;
}
-(NSString *)friendlyURL:(int)i{
    NSDictionary *a_url=[[self valueForKey:@"anchorURL"]objectAtIndex:i ];
    NSString *f_url=[[a_url objectForKey:@"friendlyURL"]objectAtIndex:i ];
    return f_url;
}
-(NSString *)visibility:(int)i{
    NSDictionary *a_url=[[self valueForKey:@"anchorURL"] objectAtIndex:i];
    NSString *v=[[a_url objectForKey:@"visibility"] objectAtIndex:i];
    return v;
}
-(NSString *)address_degreeOfMatch:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_dm=[[address objectForKey:@"degreeOfMatch"] objectAtIndex:i];
    return a_dm;
}
-(NSString *)address_rating:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_rate=[[address objectForKey:@"rating"]objectAtIndex:i ];
    return a_rate;
}
-(NSString *)city:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_city=[[address objectForKey:@"city"]objectAtIndex:i ];
    return a_city;
}
-(NSString *)county:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_country=[[address objectForKey:@"county"] objectAtIndex:i];
    return a_country;
}
-(NSNumber *)number:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSNumber *a_number=[[address objectForKey:@"number"]objectAtIndex:i ];
    return a_number;
}
-(NSString *)postalCode:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_postalCode=[[address objectForKey:@"postalCode"]objectAtIndex:i ];
    return a_postalCode;
}
-(NSString *)province:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_province=[[address objectForKey:@"province"] objectAtIndex:i];
    return a_province;

}
-(NSString *)state:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i];
    NSString *a_state=[[address objectForKey:@"state"]objectAtIndex:i ];
    return a_state;
}
-(NSString *)street:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_street=[[address objectForKey:@"street"]objectAtIndex:i ];
    return a_street;
}
-(NSString *)street2:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"]objectAtIndex:i ];
    NSString *a_street2=[[address objectForKey:@"street2"]objectAtIndex:i ];
    return a_street2;

}
-(NSString *)timeZone:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"] objectAtIndex:i];
    NSString *a_timeZone=[[address objectForKey:@"timeZone"]objectAtIndex:i ];
    return a_timeZone;
}
-(NSString *)zip:(int)i{
    NSDictionary *address=[[self valueForKey:@"address"] objectAtIndex:i];
    NSString *a_zip=[[address objectForKey:@"zip"]objectAtIndex:i ];
    return a_zip;
}
-(NSString *)emailMain:(int)i{
    NSDictionary *contact=[[self valueForKey:@"contact"] objectAtIndex:i];
    NSString *a_emailMain=[[contact objectForKey:@"emailMain"]objectAtIndex:i ];
    return a_emailMain;
}
-(NSString *)firstName:(int)i{
    NSDictionary *contact=[[self valueForKey:@"contact"]objectAtIndex:i ];
    NSString *a_firstName=[[contact objectForKey:@"firstName"]objectAtIndex:i ];
    return a_firstName;
}
-(NSString *)lastName:(int)i{
    NSDictionary *contact=[[self valueForKey:@"contact"]objectAtIndex:i ];
    NSString *a_lastName=[[contact objectForKey:@"lastName"]objectAtIndex:i ];
    return a_lastName;
}
-(NSString *)telephoneMain:(int)i{
    NSDictionary *contact=[[self valueForKey:@"contact"] objectAtIndex:i];
    NSString *a_telephoneMain=[[contact objectForKey:@"telephoneMain"]objectAtIndex:i ];
    return a_telephoneMain;
}
-(NSString *)telephoneMobile:(int)i{
    NSDictionary *contact=[self valueForKey:@"contact"];
    NSString *a_telephoneMobile=[[contact objectForKey:@"telephoneMobile"] objectAtIndex:i];
    return a_telephoneMobile;
}
-(NSString *)telephoneAux:(int)i{
    NSDictionary *contact=[[self valueForKey:@"contact"] objectAtIndex:i];
    NSString *a_telephoneAux=[[contact objectForKey:@"telephoneAux"]objectAtIndex:i ];
    return a_telephoneAux;
}
-(NSString *)serviceAccommodatorId:(int)i{
    NSString *saID=[[self valueForKey:@"serviceAccommodatorId"]objectAtIndex:i ];
    return saID;
}
-(NSString *)serviceLocationId:(int)i{
    NSString *slID=[[self valueForKey:@"serviceLocationId"]objectAtIndex:i ];
    return slID;

}
-(NSNumber *)longitude:(int)i{
    NSNumber *lot=[[self valueForKey:@"longitude"]objectAtIndex:i ];
    return lot;
}
-(NSNumber *)latitude:(int)i{
    NSNumber *lat=[[self valueForKey:@"latitude"]objectAtIndex:i ];
    return lat;
}
-(NSString *)contactInfo:(int)i{
    NSString *ct=[[self valueForKey:@"contactInfo"]objectAtIndex:i ];
    return ct;
}
-(NSNumber *)degreeOfMatch:(int)i{
    NSNumber *dm=[[self valueForKey:@"degreeOfMatch"]objectAtIndex:i ];
    return dm;
}
-(NSNumber *)rating:(int)i{
    NSNumber *rate=[[self valueForKey:@"rating"]objectAtIndex:i ];
    return rate;
}
-(NSString *)themeColor:(int)i{
    NSString *tcolor=[[self valueForKey:@"themeColor"]objectAtIndex:i ];
    return tcolor;
}
-(NSString *)promoTypeId:(int)i{
    NSString *pid=[[self valueForKey:@"promoTypeId"]objectAtIndex:i ];
    return pid;
}
-(NSNumber *)promoCount:(int)i{
    NSNumber *pct=[[self valueForKey:@"promoCount"]objectAtIndex:i ];
    return pct;
}
-(NSNumber *)iconWidth:(int)i{
    NSNumber *width=[[self valueForKey:@"iconWidth"]objectAtIndex:i ];
    return width;
}
-(NSNumber *)iconHeight:(int)i{
    NSNumber *height=[[self valueForKey:@"iconHeight"]objectAtIndex:i ];
    return height;
}
-( BOOL)inNetwork:(int)i{
    BOOL net=[[[self valueForKey:@"inNetwork"]objectAtIndex:i] boolValue];
    return net;
}
-(NSString *)serviceStatusString:(int)i{
    NSString *sss=[[self valueForKey:@"serviceStatusString"] objectAtIndex:i];
    return sss;
}
-(NSString *)serviceStatusColor:(int)i{
    NSString *ssc=[[self valueForKey:@"serviceStatusColor"]objectAtIndex:i ];
    return ssc;
}
-(NSNumber *)statusID:(int)i{
    NSNumber *sid=[[self valueForKey:@"statusID"] objectAtIndex:i];
    return sid;
}
-(NSNumber *)trendingScore:(int)i{
    NSNumber *tscr=[[self valueForKey:@"trendingScore"]objectAtIndex:i ];
    return tscr;
}
-(NSString *)communicationStatusString:(int)i{
    NSString *css=[[self valueForKey:@"communicationStatusString"]objectAtIndex:i ];
    return css;
}
-(NSString *)communicationStatusColor:(int)i{
    NSString *csc=[[self valueForKey:@"communicationStatusColor"]objectAtIndex:i ];
    return csc;
}
-(NSNumber *)communicationStatusID:(int)i{
    NSNumber *csd=[[self valueForKey:@"communicationStatusID"]objectAtIndex:i ];
    return csd;
}
-(NSString *)dateTime:(int)i{
    NSString *dt=[[self valueForKey:@"dateTime"]objectAtIndex:i ];
    return dt;
}
-(NSNumber *)gallerySize:(int)i{
    NSNumber *size=[[self valueForKey:@"gallerySize"] objectAtIndex:i];
    return size;
}
-(NSString *)category:(int)i{
    NSString *ct=[[self valueForKey:@"category"] objectAtIndex:i];
    return ct;
}
-(NSString *)marker:(int)i{
    NSString *mark=[[self valueForKey:@"marker"] objectAtIndex:i];
    return mark;
}
-(NSString*)markerURL:(int)i {
    NSString *url = [[self valueForKey:@"markerURL"] objectAtIndex:i];
    return url;
}
-(NSString*)apiMarkerURL:(int)i {
    NSString *url = [[self valueForKey:@"apiMarkerURL"] objectAtIndex:i];
    return url;
}
// newly added.
-(NSString*)markerImageKey {
    return @"markerImage";
}
-(UIImage*)markerImage:(int)i {
    return [[self valueForKey:[self markerImageKey]] objectAtIndex:i];
}
-(NSString*)messageFromSASLCount:(int)i {
    return [[self valueForKey:@"messageFromSASLCount"] objectAtIndex:i] ;
}
-(NSString*)distanceInKm:(int)i {
    return [[self valueForKey:@"distanceInKiloMeters"] objectAtIndex:i];
}
@end
