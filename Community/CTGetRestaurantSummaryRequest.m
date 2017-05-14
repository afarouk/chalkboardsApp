//
//  CTGetRestaurantSummaryRequest.m
//  Community
//
//  Created by practice on 17/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTGetRestaurantSummaryRequest.h"

@implementation CTGetRestaurantSummaryRequest
static CTGetRestaurantSummaryRequest* sharedInstance;
+(CTGetRestaurantSummaryRequest*)sharedInstance {
    if(sharedInstance == nil)
        sharedInstance = [[CTGetRestaurantSummaryRequest alloc]init];
    return sharedInstance;
}
-(void)sendRequest:(NSURLRequest *)request {
    [connection cancel];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection) {
        [mutableData setLength:0];
        mutableData = nil;
        mutableData = [NSMutableData data];
        [connection start];
    }
}
#pragma NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    [mutableData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mutableData appendData:data];
    [self.delegate didFetchData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate didFinishFetchingData:mutableData];
}
#pragma NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate didFailWithError:error];
}
@end
