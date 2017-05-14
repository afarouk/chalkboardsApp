//
//  CTGetRestaurantSummaryRequest.h
//  Community
//
//  Created by practice on 17/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CTGetRestaurantSummaryRequestDelegate <NSObject>
-(void)didFetchData:(NSData*)data;
-(void)didFinishFetchingData:(NSData*)data;
-(void)didFailWithError:(NSError*)error;
@end
@interface CTGetRestaurantSummaryRequest : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate> {
    NSMutableData *mutableData;
    NSURLConnection *connection;
}
+(CTGetRestaurantSummaryRequest*)sharedInstance;
@property(nonatomic,assign) id<CTGetRestaurantSummaryRequestDelegate> delegate;
-(void)sendRequest:(NSURLRequest*)request;
@end
