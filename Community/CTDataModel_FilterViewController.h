//
//  CTDataModel_FilterViewController.h
//  Community
//
//  Created by practice on 14/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+GetDomainOptions.h"
#import "NSDictionary+RestaurantFilterOptions.h"
//typedef void(^FiltersCompletionBlock)(NSArray *array,NSError* error);
//typedef void(^GetFilterOptionsCompletionBlock)(NSArray *array,NSError* error);
typedef void(^GetDomainsAndFilterOptionsBlock)(NSArray *array,NSError* error);

@interface CTDataModel_FilterViewController : NSObject
//@property(nonatomic,strong) NSArray *domains;
//@property(nonatomic,strong) NSArray *filterOptions;
@property(nonatomic,strong) NSArray *filterOptions;
+(CTDataModel_FilterViewController*)sharedInstance;
//-(void)getDomainsWithCompletionBlock:(FiltersCompletionBlock)block;
//-(void)getFilterOptionsForDomain:(NSString*)domain withCompletionBlock:(GetFilterOptionsCompletionBlock)block;
-(void)getDomainAndFilterOptions:(GetDomainsAndFilterOptionsBlock)block;
@end
