//
//  NSDictionary+SASLSummaryByUIDAndLocation.h
//  Community
//
//  Created by dinesh on 21/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SASLSummaryByUIDAndLocation)
-(NSString *)name;
-(NSString *)domain;
-(NSString *)icon;
-(NSString *)serviceStatusId;
-(NSString *)permanentURL;
-(NSString *)friendlyURL;
-(NSString *)visibility;
-(NSString *)address_degreeOfMatch;
-(NSString *)address_rating;
-(NSString *)city;
-(NSString *)county;
-(NSNumber *)number;
-(NSString *)postalCode;
-(NSString *)province;
-(NSString *)state;
-(NSString *)street;
-(NSString *)street2;
-(NSString *)timeZone;
-(NSString *)zip;
-(NSString *)emailMain;
-(NSString *)firstName;
-(NSString *)lastName;
-(NSString *)telephoneMain;
-(NSString *)telephoneMobile;
-(NSString *)telephoneAux;
-(NSString *)serviceAccommodatorId;
-(NSString *)serviceLocationId;
-(NSNumber *)longitude;
-(NSNumber *)latitude;
-(NSString *)contactInfo;
-(NSNumber *)degreeOfMatch;
-(NSNumber *)rating;
-(NSString *)themeColor;
-(NSString *)promoTypeId;
-(NSNumber *)promoCount;
-(NSNumber *)iconWidth;
-(NSNumber *)iconHeight;
-(BOOL)inNetwork;
-(BOOL)isFavorite;
-(NSString *)serviceStatusString;
-(NSString *)serviceStatusColor;
-(NSNumber *)statusID;
-(NSNumber *)trendingScore;
-(NSString *)communicationStatusString;
-(NSString *)communicationStatusColor;
-(NSNumber *)communicationStatusID;
-(NSString *)dateTime;
-(NSNumber *)gallerySize;
-(NSString *)category;
-(NSString *)marker;
-(NSString *)rating_img_url;
-(UIImage*)ratingImage;
-(void)setRatingImage:(UIImage*)image;
@end
