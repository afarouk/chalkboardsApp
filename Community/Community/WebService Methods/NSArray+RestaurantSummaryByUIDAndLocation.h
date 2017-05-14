//
//  NSDictionary+RestaurantSummaryByUIDAndLocation.h
//  Community
//
//  Created by dinesh on 20/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RestaurantSummaryByUIDAndLocation)

-(NSString *)name:(int)i;
-(NSString *)domain:(int)i;
-(NSString *)icon:(int)i;
-(NSString *)serviceStatusId:(int)i;
-(NSString *)permanentURL:(int)i;
-(NSString *)friendlyURL:(int)i;
-(NSString *)visibility:(int)i;
-(NSString *)address_degreeOfMatch:(int)i;
-(NSString *)address_rating:(int)i;
-(NSString *)city:(int)i;
-(NSString *)county:(int)i;
-(NSNumber *)number:(int)i;
-(NSString *)postalCode:(int)i;
-(NSString *)province:(int)i;
-(NSString *)state:(int)i;
-(NSString *)street:(int)i;
-(NSString *)street2:(int)i;
-(NSString *)timeZone:(int)i;
-(NSString *)zip:(int)i;
-(NSString *)emailMain:(int)i;
-(NSString *)firstName:(int)i;
-(NSString *)lastName:(int)i;
-(NSString *)telephoneMain:(int)i;
-(NSString *)telephoneMobile:(int)i;
-(NSString *)telephoneAux:(int)i;
-(NSString *)serviceAccommodatorId:(int)i;
-(NSString *)serviceLocationId:(int)i;
-(NSNumber *)longitude:(int)i;
-(NSNumber *)latitude:(int)i;
-(NSString *)contactInfo:(int)i;
-(NSNumber *)degreeOfMatch:(int)i;
-(NSNumber *)rating:(int)i;
-(NSString *)themeColor:(int)i;
-(NSString *)promoTypeId:(int)i;
-(NSNumber *)promoCount:(int)i;
-(NSNumber *)iconWidth:(int)i;
-(NSNumber *)iconHeight:(int)i;
-(BOOL)inNetwork:(int)i;
-(NSString *)serviceStatusString:(int)i;
-(NSString *)serviceStatusColor:(int)i;
-(NSNumber *)statusID:(int)i;
-(NSNumber *)trendingScore:(int)i;
-(NSString *)communicationStatusString:(int)i;
-(NSString *)communicationStatusColor:(int)i;
-(NSNumber *)communicationStatusID:(int)i;
-(NSString *)dateTime:(int)i;
-(NSNumber *)gallerySize:(int)i;
-(NSString *)category:(int)i;
-(NSString *)marker:(int)i;
-(NSString*)markerURL:(int)i;
-(NSString*)apiMarkerURL:(int)i ;
// newly added.
-(NSString*)markerImageKey;
-(UIImage*)markerImage:(int)i;
-(NSString*)messageFromSASLCount:(int)i;
-(NSString*)distanceInKm:(int)i;
@end
