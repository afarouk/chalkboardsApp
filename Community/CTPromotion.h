//
//  CTPromotion.h
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTPromotion : NSObject

@property (nonatomic, strong) NSData *mainPicture;
@property (nonatomic, strong) NSData *thumbnail;
@property (nonatomic, strong) NSMutableDictionary *promotionType;
@property (nonatomic, strong) NSMutableDictionary *roleType;
@property (nonatomic, strong) NSString *forEditorDayId;
@property (nonatomic, strong) NSNumber *forEditorShiftId;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *promoUUID;
@property (nonatomic, strong) NSString *serviceAccommodatorId;
@property (nonatomic, strong) NSString *serviceLocationId;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSNumber *bookable;
@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) NSNumber *localOnly;
@property (nonatomic, strong) NSString *promotionCode;
@property (nonatomic, strong) NSString *promotionSASLName;
@property (nonatomic, strong) NSString *promotionStatus;
@property (nonatomic, strong) NSString *validDays;
@property (nonatomic, strong) NSString *validTimes;
@property (nonatomic, strong) NSNumber *maxHeadCountPerSeat;
@property (nonatomic, strong) NSNumber *maxSeatCount;
@property (nonatomic, strong) NSString *reservationType;
@property (nonatomic, strong) NSNumber *isExpired;
@property (nonatomic, strong) NSString *temporalPriority;
@property (nonatomic, strong) NSString *timeSlotType;
@property (nonatomic, strong) NSNumber *floorId;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *levelType;
@property (nonatomic, strong) NSString *pictStatus;
@property (nonatomic, strong) NSNumber *promoPictureId;
@property (nonatomic, strong) NSString *promoPictureServiceAccommodatorId;
@property (nonatomic, strong) NSNumber *tierId;
@property (nonatomic, strong) NSNumber *timeRestricted;
@property (nonatomic, strong) NSString *displayFont;
@property (nonatomic, strong) NSNumber *promoIndex;
@property (nonatomic, strong) NSString *endClockHours;
@property (nonatomic, strong) NSString *endClockMinutes;
@property (nonatomic, strong) NSString *startClockHours;
@property (nonatomic, strong) NSString *startClockMinutes;
@property (nonatomic) BOOL isPatroMode;
@property (nonatomic, strong) NSString *campaignTitle;
@property (nonatomic, strong) NSString * patronUserName;
@property (nonatomic, assign) NSInteger sortNumber;

- (void)importFromDictionary:(NSDictionary *)dictionary;


@end
