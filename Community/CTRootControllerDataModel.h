//
//  CTRootControllerDataModel.h
//  Community
//
//  Created by practice on 20/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#define kDistanceInKmKey @"DistanceInKmKey"
@interface CTRootControllerDataModel : NSObject
+(CTRootControllerDataModel*)sharedInstance;
@property(nonatomic,strong) NSMutableArray *saslSummaryArray;
@property(nonatomic,strong) NSMutableArray *listoftilesData;
@property(nonatomic,strong) NSMutableArray *listofSaslData;
@property(nonatomic,strong) NSString *selectedCategory,*selectedDomain;
@property(nonatomic,strong) NSDictionary *selectedRestaurant;
@property(nonatomic,weak) NSMutableDictionary *selectedRestDetails;
@property(nonatomic,strong)NSMutableArray *getarray;
@property(nonatomic,strong) NSMutableArray * getTilesData;
-(void)setSaslSummaryArray:(NSMutableArray *)saslSummaryArray;
@end
