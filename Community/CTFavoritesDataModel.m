//
//  CTRestaurantHomeControllerDataModel.m
//  Community
//
//  Created by practice on 17/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTFavoritesDataModel.h"

@implementation CTFavoritesDataModel
static CTFavoritesDataModel* sharedInstance;
+(CTFavoritesDataModel*)sharedInstance {
    if(sharedInstance == nil)
        sharedInstance = [[CTFavoritesDataModel alloc]init];
    return sharedInstance;
}
-(void)markAsFavoriteWithURLKey:(NSString*)urlKey completionBlock:(MarkAsFavoriteBlock)block{
    NSString *params=[NSString stringWithFormat:@"UID=%@&urlKey=%@",[CTCommonMethods UID],urlKey];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_FavoriteByURL,params];
    NSLog(@"url String %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(nil,JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block(error,JSON);
    }];
    [operation start];

}
-(void)deleteFavoriteRestaurant:(NSString *)urlKey completionBlock:(DeleteFavoriteBlock)block{
    
    NSString *UID=[CTCommonMethods UID];
    NSString *params=[NSString stringWithFormat:@"UID=%@&urlKey=%@",UID,urlKey];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_DeleteFavorite,params];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
   
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(nil,JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block(error,JSON);
    }];
    
    [operation start];
    
    //UID=user20.781305772384780045&urlKey=GBvOpikmQqKAAABQBM7Or0dPTRgmZyA
}
-(void)retriveFavoritesWithCompletionBlock:(GetFavoritesCompletionBlock)block{
    
    NSString *param=[NSString stringWithFormat:@"UID=%@",[CTCommonMethods UID] ];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_RetriveFavorite,param];
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];


    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(nil,JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block(error,JSON);
    }];
    [operation start];
    
}
@end
