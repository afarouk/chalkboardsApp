//
//  CTFavoriteView.m
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTFavoriteView.h"
#import "CTFavoriteTableCell.h"
#import "NSDictionary+GetRestaurantDetails.h"
#import "NSArray+RestaurantFilterOptionsArray.h"
#import "MBProgressHUD.h"
@implementation CTFavoriteView
-(void)didTapOnView:(UITapGestureRecognizer*)tap {
    if([self.delegate respondsToSelector:@selector(didTapOnFavoriteView)])
        [self.delegate didTapOnFavoriteView];
}
-(void)enableHitDetectionArea {
    self.gestureView.frame = CGRectMake(self.container.frame.size.width, 0, [UIScreen mainScreen].applicationFrame.size.width-self.container.frame.size.width, self.frame.size.height);
    CGRect frame = self.frame;
    frame.size.width  = self.container.frame.size.width+self.gestureView.frame.size.width;
    self.frame = frame;
}
-(void)disableHitDetectionArea {
    self.gestureView.frame=CGRectMake(0, 0, 1, 1);
    CGRect frame = self.frame;
    frame.size.width  = self.container.frame.size.width;
    self.frame = frame;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTFavoriteView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(retriveFavorite) name:@"retriveFav" object:nil];
//        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTFavoriteView" owner:self options:nil];
//        [self addSubview:[nib objectAtIndex:0]];
        self.backgroundColor=[UIColor clearColor];
        if([CTCommonMethods isUIDStoredInDevice]){
        [self retriveFavorite];
        }
//            container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[nib objectAtIndex:0] frame].size.width, self.frame.size.height)];
//            [self addSubview:container];
//            [container addSubview:[nib objectAtIndex:0]];
            self.container.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
            // view for gesture
//            gestureView = [[UIView alloc]initWithFrame:CGRectMake(container.frame.size.width, 0, self.frame.size.width-container.frame.size.width, self.frame.size.height)];
            self.gestureView.backgroundColor = [UIColor clearColor];
//            [self addSubview:gestureView];
            [self disableHitDetectionArea];
            // tap gesture
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnView:)];
            [self.gestureView addGestureRecognizer:tap];
            self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
#pragma mark close action
-(IBAction)close:(id)sender{
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame,-275, 0);
    [UIView commitAnimations];
    [self postNotification];
}
#pragma mark post notification
-(void)postNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ResetFavoriteList" object:self];
}
#pragma mark Restaurant List Table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.favoriteDict count];
}
-(GLfloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTFavoriteTableCell *restaurantCell=(CTFavoriteTableCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTFavoriteTableCell" owner:self options:nil];
    restaurantCell=[nib objectAtIndex:0];
    NSString *icon=[self.favoriteDict icon:indexPath.row];
    NSString *messagecount=[NSString stringWithFormat:@"%@",[[self.favoriteDict valueForKey:@"messageFromSASLCount"] objectAtIndex:indexPath.row]];
    restaurantCell.restaurantImg.image=[UIImage imageWithData:[NSData dataFromBase64String:icon]];
    restaurantCell.notificationCount.text=messagecount;
    return restaurantCell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *url=[NSString stringWithFormat:@"%@",[[self.favoriteDict valueForKey:@"urlKey"] objectAtIndex:indexPath.row]];
    NSLog(@"URL KEY %@",url);
    [self deleteFavoriteRestaurant:url];

    //[MBProgressHUD hideHUDForView:self animated:YES];
}
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
   
}

-(void)retriveFavorite{
   
    NSString *param=[NSString stringWithFormat:@"UID=%@",[CTCommonMethods UID] ];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_RetriveFavorite,param];
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCCESS");
        self.favoriteDict=(NSDictionary *)JSON;
          [MBProgressHUD hideHUDForView:self animated:YES];
        [self.favoriteRestaurantListTableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"FAIL %@",(NSDictionary *)JSON);
//        NSDictionary *errorDict=(NSDictionary *)JSON;
//        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
//        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
//        [MBProgressHUD hideHUDForView:self animated:YES];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:errorMsgStr];
    }];
    [operation start];
    
}

-(void)deleteFavoriteRestaurant:(NSString *)urlKey{
    
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
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
          [MBProgressHUD hideHUDForView:self animated:YES];
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Item removed from your favorite list"];
        self.favoriteDict=nil;
        [self retriveFavorite];      
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            //        NSDictionary *errorDict=(NSDictionary *)JSON;
            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
    }];
    
    [operation start];
    
//UID=user20.781305772384780045&urlKey=GBvOpikmQqKAAABQBM7Or0dPTRgmZyA
}
@end
