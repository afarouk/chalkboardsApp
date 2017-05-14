//
//  CTPromotion.m
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTPromotion.h"
#import "NSDictionary+CMPortal.h"

@implementation CTPromotion

- (void)importFromDictionary:(NSDictionary*)dictionary
{
    self.bookable=[dictionary objectForKeyCheckingNull:@"bookable"];
    self.displayFont=[dictionary objectForKeyCheckingNull:@"displayFont"];
    self.floorId=[dictionary objectForKeyCheckingNull:@"floorId"];
    self.keywords=[dictionary objectForKeyCheckingNull:@"keywords"];
    self.levelType=[dictionary objectForKeyCheckingNull:@"levelType"];
    self.localOnly=[dictionary objectForKeyCheckingNull:@"localOnly"];
    self.isPatroMode=[dictionary objectForKeyCheckingNull:@"isPatroMode"];
    self.campaignTitle = [dictionary objectForKeyCheckingNull:@"campaignTitle"];
    self.patronUserName = [dictionary objectForKeyCheckingNull:@"patronUserName"];
    self.messageText=[dictionary objectForKeyCheckingNull:@"messageText"];
    self.pictStatus=[dictionary objectForKeyCheckingNull:@"pictStatus"];
    self.promoIndex=[dictionary objectForKeyCheckingNull:@"promoIndex"];
    self.promoPictureId=[dictionary objectForKeyCheckingNull:@"promoPictureId"];
    self.promoPictureServiceAccommodatorId=[dictionary objectForKeyCheckingNull:@"promoPictureServiceAccommodatorId"];
    self.promoUUID=[dictionary objectForKeyCheckingNull:@"promoUUID"];
    self.promotionCode=[dictionary objectForKeyCheckingNull:@"promotionCode"];
    self.promotionSASLName=[dictionary objectForKeyCheckingNull:@"promotionSASLName"];
    self.promotionStatus=[dictionary objectForKeyCheckingNull:@"promotionStatus"];
    self.promotionType=[dictionary objectForKeyCheckingNull:@"promotionType"];
    self.roleType=[dictionary objectForKeyCheckingNull:@"roleType"];
    self.serviceAccommodatorId=[dictionary objectForKeyCheckingNull:@"serviceAccommodatorId"];
    self.serviceLocationId=[dictionary objectForKeyCheckingNull:@"serviceLocationId"];
    self.tierId=[dictionary objectForKeyCheckingNull:@"tierId"];
    self.timeRestricted=[dictionary objectForKeyCheckingNull:@"timeRestricted"];
    if([self.timeRestricted boolValue] == FALSE)
    {
        self.forEditorDayId=(NSString *)[NSNull null];
        self.forEditorShiftId=@(1);
        self.maxHeadCountPerSeat=@(3);
        self.maxSeatCount=@(40);
        self.reservationType=@"PSEUDO";
        self.timeSlotType=@"FIXED_60MIN_INTERVALS";
        self.startTime=@"";
        self.endTime=@"";
        self.isExpired=@(0);
        self.temporalPriority=@"DATE";
        self.validTimes=@"ANYTIME";
        self.validDays=@"MON,TUE,WED,THU,FRI,SAT,SUN";
    }
    else
    {
        NSDictionary *classTimeSlotPolicyEntry=dictionary[@"classTimeSlotPolicyEntry"];
        if(classTimeSlotPolicyEntry)
        {
            self.forEditorDayId=classTimeSlotPolicyEntry[@"forEditorDayId"];
            self.forEditorShiftId=classTimeSlotPolicyEntry[@"forEditorShiftId"];
            self.maxHeadCountPerSeat=classTimeSlotPolicyEntry[@"maxHeadCountPerSeat"];
            self.maxSeatCount=classTimeSlotPolicyEntry[@"maxSeatCount"];
            self.reservationType=classTimeSlotPolicyEntry[@"reservationType"];
            self.timeSlotType=classTimeSlotPolicyEntry[@"timeSlotType"];
            NSDictionary *timeRange=classTimeSlotPolicyEntry[@"timeRange"];
            if(timeRange)
            {
                NSString *activationDate=timeRange[@"activationDate"];
                self.startTime=@"";
                if(![activationDate isKindOfClass:[NSNull class]])
                {
                    self.startTime=activationDate;
                }
                
                NSString *expirationDate=timeRange[@"expirationDate"];
                self.endTime=@"";
                if(![expirationDate isKindOfClass:[NSNull class]])
                {
                    self.endTime = expirationDate;
                }
                
                self.isExpired=timeRange[@"isExpired"];
                self.temporalPriority=timeRange[@"temporalPriority"];
                
                NSDictionary *openingHours=timeRange[@"openingHours"];
                if(openingHours)
                {
                    NSDictionary *endClock=openingHours[@"endClock"];
                    if(endClock)
                    {
                        self.endClockHours=[NSString stringWithFormat:@"%@", endClock[@"hour"]];
                        self.endClockMinutes=[NSString stringWithFormat:@"%@", endClock[@"minute"]];
                    }
                    NSDictionary *startClock=openingHours[@"startClock"];
                    if(startClock)
                    {
                        self.startClockHours=[NSString stringWithFormat:@"%@", startClock[@"hour"]];
                        self.startClockMinutes=[NSString stringWithFormat:@"%@", startClock[@"minute"]];
                    }
                }
                
                id openingDays=timeRange[@"openingDays"];
                
                if([openingDays isKindOfClass:[NSArray class]])
                {
                    NSString *validDays=@"";
                    for(NSString *day in openingDays)
                    {
                        validDays=[validDays stringByAppendingFormat:@"%@,", day];
                    }
                    self.validDays=[NSString stringWithString:validDays];
                }
                else
                {
                    if([openingDays isKindOfClass:[NSString class]])
                    {
                        self.validDays=openingDays;
                    }
                }
            }
        }
    }
}

- (void)setPromotionStatus:(NSString *)iPromotionStatus
{
    _promotionStatus=iPromotionStatus;
    if([_promotionStatus isEqualToString:@"HIGHLIGHTED"])
    {
        self.sortNumber=4;
    }
    if([_promotionStatus isEqualToString:@"ACTIVE"])
    {
        self.sortNumber=3;
    }
    if([_promotionStatus isEqualToString:@"APPROVED"])
    {
        self.sortNumber=2;
    }
    if([_promotionStatus isEqualToString:@"PROPOSED"])
    {
        self.sortNumber=1;
    }
}


@end
