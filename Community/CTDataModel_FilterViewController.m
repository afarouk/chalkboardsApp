//
//  CTDataModel_FilterViewController.m
//  Community
//
//  Created by practice on 14/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTDataModel_FilterViewController.h"

@implementation CTDataModel_FilterViewController
static CTDataModel_FilterViewController *sharedInstance;
+(CTDataModel_FilterViewController*)sharedInstance {
    if(sharedInstance == nil)
        sharedInstance = [[CTDataModel_FilterViewController alloc]init];
    return sharedInstance;
}
-(void)getDomainAndFilterOptions:(GetDomainsAndFilterOptionsBlock)block  {
    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_getSASLFilterOptions];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError) {
            NSError *jsonError;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if(jsonError)
                block(nil,jsonError);
            else {
                self.filterOptions = array;
                block(array,nil);
            }
        }else
            block(nil,connectionError);
    }];

}
//-(void)getDomainsWithCompletionBlock:(FiltersCompletionBlock)block {
//    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_getDomainOptions];
//    NSLog(@"%@",urlString);
//    NSURL *url=[NSURL URLWithString:urlString];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if(!connectionError) {
//            NSError *jsonError;
//            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
//            if(jsonError)
//                block(nil,jsonError);
//            else {
//                self.domains = array;
//                block(array,nil);
//            }
//        }else
//            block(nil,connectionError);
//    }];
//}
//-(void)getFilterOptionsForDomain:(NSString*)domain withCompletionBlock:(GetFilterOptionsCompletionBlock)block{
//    NSString *urlString=[NSString stringWithFormat:@"%@%@?domain=%@",[CTCommonMethods getChoosenServer],CT_getSASLFilterOptions,domain];
//    NSLog(@"url %@",urlString);
//    NSURL *url=[NSURL URLWithString:urlString];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if(!connectionError) {
//            NSError *jsonError;
//            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
////            NSArray *array = (NSArray*)[dictionary filterOptions];
//            if(jsonError)
//                block(nil,jsonError);
//            else {
//                self.filterOptions = array;
//                block(array,nil);
//            }
//        }else
//            block(nil,connectionError);
//    }];
//}

//-(void)getDomainOptions{
//    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_getDomainOptions];
//    NSLog(@"%@",urlString);
//    NSURL *url=[NSURL URLWithString:urlString];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
//    hud.mode=MBProgressHUDModeIndeterminate;
//    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        @try{
//            NSArray *domainOptionsArray=(NSArray *)JSON;
//            [self parseDomainOptions:domainOptionsArray];
//            [MBProgressHUD hideHUDForView:self animated:YES];
//        }
//        @catch (NSException *exception) {
//            NSLog(@"DOMAIN PARSING EXCEPTION %@",exception);
//            
//        }
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"FAILED");
//        [MBProgressHUD hideHUDForView:self animated:YES];
//    }];
//    [operation start];
//}
//#pragma mark get getSASLFilterOptions
//-(void)getSASLFilterOptions{
//    /* restaurant/getRestaurantFilterOptions is replaced by sasl/getSASLFilterOptions due to api change*/
//    NSLog(@"selected domain %@",self.selectedDomain);
//    NSString *urlString=[NSString stringWithFormat:@"%@%@?domain=%@",[CTCommonMethods getChoosenServer],CT_getSASLFilterOptions,self.selectedDomain];
//    NSLog(@"url %@",urlString);
//    NSURL *url=[NSURL URLWithString:urlString];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
//    hud.mode=MBProgressHUDModeIndeterminate;
//    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSDictionary *dict=(NSDictionary *)JSON;
//        [self getFilterOptionsArrayList:dict];
//        [MBProgressHUD hideHUDForView:self animated:YES];
//        NSLog(@"SUCCESS");
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSDictionary *errorDict=(NSDictionary *)JSON;
//        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
//        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
//        [MBProgressHUD hideHUDForView:self animated:YES];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:errorMsgStr];
//        
//    }];
//    
//    [operation start];
//}
@end
