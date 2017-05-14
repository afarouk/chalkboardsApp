//
//  CTWebServicesMethods.m
//  Community
//
//  Created by practice on 24/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTWebServicesMethods.h"

@implementation CTWebServicesMethods
+(void)getRestaurantBySa:(NSString *)sa SL:(NSString *)sl forLatitude:(NSString *)lat andLongitude:(NSString *)lon completionBlock:(GetRestaurantBySASLCompletionBlock)block {
    //    [[NSOperationQueue new]addOperationWithBlock:^{
//    int serviceAccomodationId=[sa intValue];
//    int serviceLocationId=[sl intValue];
    double latitude=[lat doubleValue];
    double longitude=[lon doubleValue];
//    NSString *param=[NSString stringWithFormat:@"serviceLocationId=%d&serviceAccommodatorId=%d&latitude=%f&longitude=%f",serviceLocationId,serviceAccomodationId,latitude,longitude];
    
    // V: 20-05-2015 change integer to string "SL and SA"
    NSString *param=[NSString stringWithFormat:@"serviceLocationId=%@&serviceAccommodatorId=%@&latitude=%f&longitude=%f",sl,sa,latitude,longitude];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getRestaurant,param];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *requestURL=[NSURLRequest requestWithURL:url];
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
//    hud.mode=MBProgressHUDModeIndeterminate;
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            block(CT_AlertTitle,connectionError.localizedDescription,nil);
//            [MBProgressHUD hideHUDForView:self animated:YES];
//            [CTCommonMethods showErrorAlertMessageWithTitle:@"Community" andMessage:@"Service is not available please try again later"];
        }else {
            NSError *error;
            NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSError *jsonError = [CTCommonMethods validateJSON:dictionary];
            if(!error && !jsonError) {
                NSMutableDictionary *mutableDictionary = [dictionary deepMutableCopy];
                block(nil,nil,mutableDictionary);
            }else if (jsonError) {
                block(jsonError.localizedFailureReason,jsonError.localizedDescription,nil);
            }
            else if(error) {
                block(CT_AlertTitle,CT_DefaultAlertMessage,nil);
//                [MBProgressHUD hideHUDForView:self animated:YES];
//                [CTCommonMethods showErrorAlertMessageWithTitle:@"Community" andMessage:@"Service is not available please try again later"];
            }
            
        }
    }];
    //        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:requestURL success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    ////            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ////            CTRestaurantHomeViewController *restaurantController=[storyboard instantiateViewControllerWithIdentifier:@"CTRestaurantHomeViewController"];
    //            restaurantController.restaurantDetailsDict=(NSDictionary *)JSON;
    ////            [MBProgressHUD hideHUDForView:self animated:YES];
    ////            [self.navigationController pushViewController:restaurantController animated:YES];
    //        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //            [MBProgressHUD hideHUDForView:self animated:YES];
    //            [CTCommonMethods showErrorAlertMessageWithTitle:@"Community" andMessage:@"Service is not available please try again later"];
    //        }];
    //
    //        [operation start];
    
    //    }];

}

+(void)sendRequestWithURL:(NSString*)url params:(id)params method:(HTTPMethod)method contentType:(NSString*)contentType success:(void (^) (id JSON))succss failure:(void (^)(NSError *error))failure {
    //NSLog(@"method Type=%u",method);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    if(method == kHTTPMethod_GET)
        [request setHTTPMethod:@"GET"];
    else if(method == kHTTPMethod_POST) {
        [request setHTTPMethod:@"POST"];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    }
    else if(method == kHTTPMethod_PUT) {
        [request setHTTPMethod:@"PUT"];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    }
    else if(method == kHTTPMethod_DELETE)
        [request setHTTPMethod:@"DELETE"];
    NSError *jsonError =nil;
    if(params)
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&jsonError]];
    if(jsonError)
    {
        NSLog(@"json error %@",jsonError);
        failure([NSError errorWithDomain:@"com.Portal.JSONWritingFailed" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Unknown",NSLocalizedFailureReasonErrorKey,jsonError.localizedDescription,NSLocalizedDescriptionKey, nil]]);
    }else {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //        NSLog(@"data %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            if(connectionError)
                failure(connectionError);
            else {
                [CTWebServicesMethods verifyJSON:data success:^(id JSON) {
                    succss(JSON);
                } failure:^(NSError *error) {
                    failure(error);
                }];
            }
        }];
    }
}

+(void)verifyJSON:(NSData*)data success:(void (^) (id JSON))succss failure:(void (^)(NSError *error))failure {
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (! error && [JSON isKindOfClass:[NSDictionary class]] && [[JSON valueForKey:@"error"] valueForKey:@"message"] != nil) {
        error = [NSError errorWithDomain:@"com.communityportal.unabletocomplyexception" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[JSON valueForKeyPath:@"error.type"],NSLocalizedFailureReasonErrorKey,[JSON valueForKeyPath:@"error.message"],NSLocalizedDescriptionKey, nil]];
    }
    if(!error)
        return succss(JSON);
    
    NSString *title = error.localizedFailureReason;
    NSString *message = error.localizedDescription;
    if(title == nil || title.length == 0)
        title = @"Request could not be completed";
    if(message == nil || message.length == 0 )
        message = @"Server stoped responding, please try again";
    failure( [NSError errorWithDomain:@"com.communityportal.error" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:title,NSLocalizedFailureReasonErrorKey,message,NSLocalizedDescriptionKey, nil]]);
}

@end
