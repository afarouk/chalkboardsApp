//
//  CTWebServicesMethods.h
//  Community
//
//  Created by practice on 24/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "CTCommonMethods.h"
typedef void(^GetRestaurantBySASLCompletionBlock)(NSString *errorTitle,NSString *errorMessage,id JSON);

@interface CTWebServicesMethods : NSObject
+(void)getRestaurantBySa:(NSString *)sa SL:(NSString *)sl forLatitude:(NSString *)lat andLongitude:(NSString *)lon completionBlock:(GetRestaurantBySASLCompletionBlock)block;

+(void)sendRequestWithURL:(NSString*)url params:(id)params method:(HTTPMethod)method contentType:(NSString*)contentType success:(void (^) (id JSON))succss failure:(void (^)(NSError *error))failure;
@end
