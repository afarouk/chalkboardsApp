//
//  CTReviewView.m
//  Community
//
//  Created by dinesh on 16/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTReviewView.h"
#import "CTYelpReviewCell.h"
#import "MBProgressHUD.h"
#import "NSArray+RestaurantFilterOptionsArray.h"
#import "CTWriteReviewViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "CTRootControllerDataModel.h"
@implementation CTReviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CFBridgingRetain(self);
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTReviewView" owner:self options:nil];
        [self addSubview:[nib objectAtIndex:0]];
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        [self retriveReviews];
    }
    return self;
}
- (IBAction)backAction:(id)sender {
    [self dismissView];
}
-(void)dismissView{
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame,-275, 0);
    [UIView commitAnimations];
    [self postNotification];
    [self performSelector:@selector(removeFromView) withObject:self afterDelay:0.5];
    
}
#pragma mark removeFromView
-(void)removeFromView{
    [self removeFromSuperview];
}
#pragma mark post notification
-(void)postNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_RestaurantMenu object:self];
}

#pragma mark table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reviewArray count];
}

-(GLfloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 155.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CTYelpReviewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YelpReviewCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTYelpReviewCell" owner:self options:nil];
    cell=[nib objectAtIndex:0];
    cell.backgroundColor=[UIColor clearColor];
    if([self.reviewArray count]!=0){
    cell.nameLbl.text=[NSString stringWithFormat:@"%@",[self.reviewArray userName:indexPath.row]];
    cell.reviewTxt.text=[NSString stringWithFormat:@"%@",[self.reviewArray text_excerpt:indexPath.row]];
//    cell.ratingImg.image=[UIImage imageWithData:[self.ratingImageUrlArray objectAtIndex:indexPath.row]];
    }

    return cell;
}

-(void)retriveReviews{
//    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Observers_getSASL];
    NSDictionary *dict=[[CTRootControllerDataModel sharedInstance]selectedRestaurant];
    self.sa=[NSString stringWithFormat:@"%@",[dict objectForKey:@"serviceAccommodatorId"]];
    self.sl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"serviceLocationId"]];
    NSString *params=[NSString stringWithFormat:@"serviceAccommodatorId=%@&serviceLocationId=%@&lastId=0&count=10",self.sa
                      ,self.sl];
    NSLog(@"SA %@ SL %@",self.sa,self.sl);
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_RetriveReview,params];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCCESS %@",(NSDictionary *)JSON);
        NSDictionary *dict=(NSDictionary *)JSON;
        self.reviewArray=[dict objectForKey:@"reviews"];
        [self placeHolderRatingImg];
        [self.reviewTableView reloadData];
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self setRatingStar];
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
}
-(void)setRatingStar{
    NSOperationQueue *backgroundQueue=[[NSOperationQueue alloc]init];
    [backgroundQueue addOperationWithBlock:^{
        for(int i=0;i<[self.reviewArray count];i++){
            NSString *rating=[NSString stringWithFormat:@"%@",[self.reviewArray rating_img_url:i]];
            NSLog(@"URL %@",rating);
            NSURL *url=[NSURL URLWithString:rating];
            NSData *data=[NSData dataWithContentsOfURL:url];
            if(data!=NULL){
                NSLog(@"REPLACE INDEX %d",i);
                @try{
                    [self.ratingImageUrlArray replaceObjectAtIndex:i withObject:data];
                }@catch (NSException *exception) {
                    NSLog(@"Replace exception %@",exception);
                }
            }else{
                NSLog(@"NULL DATA AT INDEX %d",i);
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.reviewTableView reloadData];
            }];
        }
    }];
    
}

-(void)placeHolderRatingImg{
    self.ratingImageUrlArray=[[NSMutableArray alloc]init];
    for(int i=0;i<[self.reviewArray count];i++){
         NSLog(@"Insert INDEX %d",i);
        UIImage *image=[UIImage imageNamed:@"rating-star-empty.png"];
        NSData *data=[NSData dataWithData:UIImagePNGRepresentation(image)];
        [self.ratingImageUrlArray insertObject:data atIndex:i];
    }
    
}
- (IBAction)writeReview:(id)sender {
    
    //[CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Feature working in progress"];
    CTWriteReviewViewController *writeView=[[CTWriteReviewViewController alloc]initWithNibName:@"CTWriteReview" bundle:nil];
    [self.viewController presentPopupViewController:writeView animationType:MJPopupViewAnimationSlideBottomTop];
}
@end
