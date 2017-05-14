//
//  CTReservation.m
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTReservation.h"
#import "CTReservationCell.h"
#import "NSArray+RetrievePseudoReservationsForUser.h"
#import "NSDictionary+RetrievePseudoReservationsForUser.h"

@implementation CTReservation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CFBridgingRetain(self);
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTReservation" owner:self options:nil];
        self=[nib objectAtIndex:0];
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.reservationTableView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        [self retrivePseudoReservation];
        [self observerForPostNotification];
        
    }
    return self;
}
#pragma mark Post Notification observers
-(void)observerForPostNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showReservationView) name:CT_Observer_ReservationList object:nil];
}
-(void)showReservationView{
    CFBridgingRetain(self);
    CFBridgingRetain(self);
    [self hideControls:NO];
    [self.modifyReservationView removeFromSuperview];
    NSLog(@"OBSERVERS");
}
- (IBAction)back:(id)sender {
    
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
}
#pragma mark Restaurant List Table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reservationListArray count];
}
-(GLfloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTReservationCell *restaurantCell=(CTReservationCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTReservationCell" owner:self options:nil];
    restaurantCell=[nib objectAtIndex:0];
    restaurantCell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    if([self.reservationListArray count]!=0){
       NSDictionary *reservation=[self.reservationListArray objectAtIndex:indexPath.row];
        NSDictionary *timeRange=[reservation timeRange];
        NSDictionary *startClock=[timeRange startClock];
       // NSDictionary *endClock=[timeRange endClock];
        NSString *startTime=[NSString stringWithFormat:@"%@:%@0",[startClock hour],[startClock minute]];
        //NSString *endTime=[NSString stringWithFormat:@"%@:%@",[endClock hour],[endClock minute]];
        
        NSLog(@"RESERVATION SASL NAME %@",[reservation valueForKey:@"saslName"]);
        restaurantCell.restaurantLogo.image=[UIImage imageWithData:[NSData dataFromBase64String:[reservation logo]]];
        restaurantCell.dateLbl.text=[reservation reservationDate];
        restaurantCell.timeLbl.text=[self getOnlyStartTime:startTime];
    }
    return restaurantCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideControls:YES];
     NSDictionary *reservation=[self.reservationListArray objectAtIndex:indexPath.row];
    NSLog(@"RESERVATION %@",reservation);
    self.modifyReservationView=[[CTModifyReservationView alloc]initWithFrame:self.frame];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"modifyReservation"];
    
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:reservation];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"modifyReservation"];
    [defaults synchronize];
    
    [self addSubview:self.modifyReservationView];

}
-(void)hideControls:(BOOL)isHide{
    
    self.reservationTableView.hidden=isHide;
    self.backIcon.hidden=isHide;
    self.backButton.hidden=isHide;
    self.titleLbl.hidden=isHide;
}
-(void)retrivePseudoReservation{
    NSString *UID=[CTCommonMethods UID];
    NSString *params=[NSString stringWithFormat:@"UID=%@&startDate=2013-10-15&endDate=2014-10-15",UID];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getPseudoReservation,params];
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.reservationListArray=(NSArray *)JSON;
        NSLog(@"COUNT %d",[self.reservationListArray count]);
        [self.reservationTableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
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
@end
