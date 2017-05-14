//
//  CTModifyReservationView.m
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTModifyReservationView.h"
#import "NSArray+RetrievePseudoReservationsForUser.h"
#import "NSDictionary+RetrievePseudoReservationsForUser.h"

@implementation CTModifyReservationView
static int g_CATEGORY_COUNT=0;
-(NSDate*)getReservationDate {
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"modifyReservation"];
    self.restaurantDetail=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDictionary *timeRange=[self.restaurantDetail timeRange];
    NSDictionary *startClock=[timeRange startClock];
    // NSDictionary *endClock=[timeRange endClock];
    int hour = [[startClock hour] intValue];
    int min = [[startClock minute] intValue];
    NSString *startTime=[NSString stringWithFormat:@"%02d:%02d",hour,min];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",[self.restaurantDetail reservationDate],startTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}
-(void)getReservationModificationOptions {
    NSString *params=[NSString stringWithFormat:@"serviceLocationId=%@&serviceAccommodatorId=%@",[self.restaurantDetail serviceLocationId],[self.restaurantDetail serviceAccommodatorId]];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getReservationModificationOptions,params];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Conformation" message:[self conformation] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSError *jsonError = [CTCommonMethods validateJSON:JSON];
        //        NSDictionary *errorDict=(NSDictionary *)JSON;
        //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
        //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
        if(jsonError)
            [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
        else
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
    }];
    [operation start];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CFBridgingRetain(self);
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTModifyReservation" owner:self options:nil];
        self=[nib objectAtIndex:0];
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.22];
        self.cancelButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.sendButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
//        [self performSelector:@selector(getReservationDetails) withObject:self afterDelay:0.5];
        [self getReservationDetails];
        
    }
    return self;
}
-(void)getReservationDetails{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"modifyReservation"];
    self.restaurantDetail=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"check dictionary %@",self.restaurantDetail);
    NSDictionary *timeRange=[self.restaurantDetail timeRange];
    NSDictionary *startClock=[timeRange startClock];
    // NSDictionary *endClock=[timeRange endClock];
    NSString *startTime=[NSString stringWithFormat:@"%@:%@0",[startClock hour],[startClock minute]];
    self.contentLabel.text=[NSString stringWithFormat:@"Send request %@ to modify your reservation on %@ at %@",[self.restaurantDetail saslName],[self.restaurantDetail reservationDate],[self getOnlyStartTime:startTime]];
    self.categoryArray=[NSArray arrayWithObjects:@"Delay 30 minutes",@"Delay 1 hour", nil];
    //NSLog(@"%@",[self getOnlyStartTime:startTime]);
    
    // set date
    NSDate *date = [self getReservationDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.timeLabel.text = [dateFormatter stringFromDate:date];
}
- (IBAction)cancel:(id)sender {
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame,-275, 0);
    [UIView commitAnimations];
    [self postNotification];
}
- (IBAction)close:(id)sender {
//    [UIView beginAnimations:@"slideAnim" context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.3];
//    self.frame=CGRectOffset(self.frame,-275, 0);
//    [UIView commitAnimations];
    [self removeFromSuperview];
    [self postNotification];
}
- (IBAction)showAlert:(id)sender {
    
    [self modifyReservation];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self postNotification];
}
#pragma mark post notification
-(void)postNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observer_ReservationList object:self];
}
- (IBAction)up:(id)sender {
    if(g_CATEGORY_COUNT>0){
        g_CATEGORY_COUNT--;
        self.delayTimeLbl.text=[self.categoryArray objectAtIndex:g_CATEGORY_COUNT];
        self.contentLabel.text=[self updatedContent];
    }
}
- (IBAction)down:(id)sender {
    if(g_CATEGORY_COUNT<[self.categoryArray count]-1){
        g_CATEGORY_COUNT++;
        self.delayTimeLbl.text=[self.categoryArray objectAtIndex:g_CATEGORY_COUNT];
        self.contentLabel.text=[self updatedContent];
    }
}

#pragma GET START TIME
-(NSString *)getOnlyStartTime:(NSString *)startTime{
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"k:mm"];
    NSDate *st_date=[dateFormatter1 dateFromString:startTime];
    
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"hh:mm a"];
    NSString *st_str=[dateFormatter2 stringFromDate:st_date];
    
    NSString *timeStr=[NSString stringWithFormat:@"%@",st_str];
    NSLog(@"TIME STR %@",timeStr);
    return timeStr;
    
}
-(NSString *)updatedTime{
    if([self.delayTimeLbl.text isEqualToString:@"Delay 30 minutes"]){
        self.delayTime=@"DELAY_30_MIN";
        NSDictionary *timeRange=[self.restaurantDetail timeRange];
        NSDictionary *startClock=[timeRange startClock];
        int updateMins=[[startClock minute] intValue]+30;
        NSString *time=[NSString stringWithFormat:@"%@:%d",[startClock hour],updateMins];
        return time;
    }else if([self.delayTimeLbl.text isEqualToString:@"Delay 1 hour"]){
        self.delayTime=@"DELAY_1_HOUR";
        NSDictionary *timeRange=[self.restaurantDetail timeRange];
        NSDictionary *startClock=[timeRange startClock];
        int updateHour=[[startClock hour] intValue]+1;
        NSString *time=[NSString stringWithFormat:@"%d:%@0",updateHour,[startClock minute]];
        return time;
       
    }
    return @"-";
}
-(NSString *)updatedContent{
    NSString *startTime=[self updatedTime];
    NSString *content=[NSString stringWithFormat:@"Send request %@ to modify your reservation on %@ at %@",[self.restaurantDetail saslName],[self.restaurantDetail reservationDate],[self getOnlyStartTime:startTime]];
    return content;
}
-(NSString *)conformation{
    NSString *startTime=[self updatedTime];
    NSString *content=[NSString stringWithFormat:@"Your reservation with %@ has been changed to %@ at %@",[self.restaurantDetail saslName],[self.restaurantDetail reservationDate],[self getOnlyStartTime:startTime]];
    return content;
}
#pragma mark modify reservation
-(void)modifyReservation{
    if(self.delayTime == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"You have not modified the reservation, please do appropriate changes and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else {
        NSLog(@"check %@",[NSNumber numberWithBool:YES]);
        NSString *UID=[CTCommonMethods UID];
        NSString *params=[NSString stringWithFormat:@"UID=%@&serviceLocationId=%@&serviceAccommodatorId=%@&bookingUUID=%@&requestType=%@",UID,[self.restaurantDetail serviceLocationId],[self.restaurantDetail serviceAccommodatorId],[self.restaurantDetail reservationUUID],self.delayTime];
        NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_modifyReservation,params];
        NSLog(@"URL STRING %@",urlString);
        NSURL *url=[NSURL URLWithString:urlString];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
//        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"PUT"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Conformation" message:[self conformation] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            //        NSDictionary *errorDict=(NSDictionary *)JSON;
            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }];
        [operation start];
    }
}
#pragma Control Methods
-(IBAction)didChangeValueForSegmentedControl:(id)sender {
    NSDate *date = [self getReservationDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLog(@"date %@",date);
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    UISegmentedControl *control = (UISegmentedControl*)sender;
    if(control.selectedSegmentIndex == 0) {
        self.delayTime = @"DELAY_30_MIN";
        self.timeLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[date dateByAddingTimeInterval:30*60]]];
    }else if(control.selectedSegmentIndex == 1) {
        self.delayTime = @"DELAY_60_MIN";
        self.timeLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[date dateByAddingTimeInterval:60*60]]];
    }

    
}
-(IBAction)cancelReservation:(id)sender {
    self.delayTime = @"CANCEL";
    [self modifyReservation];
}
@end
