//
//  CTReservationView.m
//  Community
//
//  Created by dinesh on 31/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTReservationView.h"
#import "CTTimeSlotCell.h"
#import "NSDictionary+GetRestaurantDetails.h"
#import "NSArray+RetrieveMediaMetaDataBySASL.h"
#import "NSDictionary+GetAvailablePseudoTimeSlots.h"
#import "NSArray+GetAvailablePseudoTimeSlots.h"
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#import "CTRootControllerDataModel.h"
#import "MBProgressHUD.h"
#define kTimePairStringKey @"timepairString"
#define kMaxSeatKey @"maxSeat"
#define kMaxHeadKey @"maxHead"
#define kFloorIDKey @"floorId"
#define kTierIDKey @"tierId"
#define kSelectedTimePairsKey @"selectedTimePairs"
static int g_TABLE_COUNT=0;
@implementation CTReservationView
-(void)showReservationViewWithMenuView:(UIView *)_menuView {
//    menuView = _menuView;
    [UIView animateWithDuration:0.3f animations:^{
        self.center= CGPointMake(self.frame.size.width/2, self.center.y);
        _menuView.center = CGPointMake(self.frame.size.width+(_menuView.frame.size.width/2), _menuView.center.y);
        
    } completion:^(BOOL finished) {
        // add action sheet
        self.actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        // add date picker
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, 325, 300)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode=UIDatePickerModeTime;
        [self.datePicker addTarget:self
                            action:@selector(selectedDate:)
                  forControlEvents:UIControlEventValueChanged];
        
        [self.actionSheet addSubview:self.datePicker];
        
        self.datePicker.date = [[NSDate date] dateByAddingTimeInterval:60*60];
        NSDateFormatter *timeFormatter=[[NSDateFormatter alloc]init];
        [timeFormatter setDateFormat:@"hh:mm a"];
        [self.selectTimeBtn setTitle:[timeFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
        //        self.timeLbl.text=[timeFormatter stringFromDate:self.datePicker.date];
        //
        [self getPseduoReservation];

    }];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CFBridgingRetain(self);
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTReservationView" owner:self options:nil];
        self=[nib objectAtIndex:0];
//          self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
//         self.timeSlotTableView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.22];
//        self.selectTimeBtn.backgroundColor=[UIColor colorWithRed:0.88 green:0 blue:0 alpha:0.66];
//        self.cancelBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
//        self.sendButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
//        self.tableLbl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
//        self.timeSlotTableView.tableFooterView=[[UIView alloc]init];
        
        self.timeSlotTableView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
        self.timeSlotTableView.separatorColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark observersForPostNotification
-(void)getStoredRestaurantDetails{

    NSDictionary *dict=[[CTRootControllerDataModel sharedInstance]selectedRestaurant];
    self.sa=[NSString stringWithFormat:@"%@",[dict serviceAccommodatorId]];
    self.sl=[NSString stringWithFormat:@"%@",[dict serviceLocationId]];
    self.timeSlotArray=[[NSMutableArray alloc] init];
    self.tableArray=[[NSMutableArray alloc]init];
    [self.tableArray addObject:@"All"];
    [self.tableArray addObject:@"Many Tables"];
    [self.tableArray addObject:@"Open"];
    [self.tableArray addObject:@"Closed"];
    
}
-(NSArray*)getFilteredArray {
    NSPredicate *predicate;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: {
            // all
            return self.timeSlotArray;
//            predicate = [NSPredicate predicateWithFormat:@"%K >= 1",kMaxSeatKey];
        }
            break;
        case 1: {
            // Many Tables
            predicate = [NSPredicate predicateWithFormat:@"%K == -1",kMaxSeatKey];
            
        }
            break;
        case 2: {
            // Open
           predicate = [NSPredicate predicateWithFormat:@"%K == 0",kMaxSeatKey];
            
        }
            break;
        case 3: {
            // Closed
            predicate = [NSPredicate predicateWithFormat:@"%K == -2",kMaxSeatKey];
        }
            break;
            
        default:
            break;
    }
    return [self.timeSlotArray filteredArrayUsingPredicate:predicate];

}
#pragma mark close action
- (IBAction)close:(id)sender {
    // [self removeFromSuperview];
    [self dismissView];
}
-(void)dismissView{
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame,-self.frame.size.width, 0);
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
- (IBAction)backward:(id)sender {
    if(g_TABLE_COUNT>0&&[self.tableArray count]>g_TABLE_COUNT){
        
        g_TABLE_COUNT--;
        self.tableLbl.text=[self.tableArray objectAtIndex:g_TABLE_COUNT];
    }
}
- (IBAction)forward:(id)sender {
    if(g_TABLE_COUNT<[self.tableArray count]-1){
        
        g_TABLE_COUNT++;
        self.tableLbl.text=[self.tableArray objectAtIndex:g_TABLE_COUNT];
    }
}
- (IBAction)chooseDate:(id)sender {
    
    [self showDatePicker];
}
-(IBAction)segmentedControlValueChanged:(id)sender {
    self.urlString = nil;
    params = nil;
    [self.timeSlotTableView reloadData];
}
#pragma mark get pseduo reservation
-(void)getPseduoReservation{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self getStoredRestaurantDetails];
    NSString *UID=[CTCommonMethods UID];
    NSString *params=[NSString stringWithFormat:@"UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&startDateTime=%@:UTC-08:00&endDateTime=%@:UTC-08:00",UID,self.sa,self.sl,[self getCurrentTime:[NSDate date]],[self getCurrentTime:self.datePicker.date]];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getAvailablePseudoTimeSlots,params];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSDictionary *dict=(NSDictionary *)JSON;
         [self parseReservation:dict];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        NSLog(@"FAILED");
    }];
    [operation start];
}
-(NSString *)getCurrentTime:(NSDate *)date{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr=[formatter stringFromDate:date];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *timeStr=[formatter stringFromDate:date];
    NSString *dateAndTime=[NSString stringWithFormat:@"%@T%@",dateStr,timeStr];
    return dateAndTime;
}
-(NSString *)getCurrentDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr=[formatter stringFromDate:[NSDate date]];
    return dateStr;
}
-(void)parseReservation:(NSDictionary *)dict{
    
    NSArray *floorArray=[dict floors];
    NSString *tierName=nil;
    for(int i=0;i<[floorArray count];i++){
        NSArray *tierArray=[floorArray tiers:i];
        NSString *floorId=[floorArray floorId:i];
        for(int j=0;j<[tierArray count];j++){
            tierName=[tierArray tierName:j];
            NSString *tierId=[tierArray tierId:i];
            NSArray *timeSlottedArray=[tierArray timeSlots:j];
            for(int k=0;k<[timeSlottedArray count];k++){
                NSArray *selectedTimePairs=[timeSlottedArray objectAtIndex:k];
                NSString *maxHead=[timeSlottedArray maxHeadPerSeat:k];
                NSString *maxSeat=[timeSlottedArray maxSeatCount:k];
                NSDictionary *timePairs=[timeSlottedArray timePair:k ];
                NSDictionary *startClock=[timePairs startClock];
                NSDictionary *endClock=[timePairs endClock];
                NSString *startTime=[NSString stringWithFormat:@"%@:%@0",[startClock hour],[startClock minute]];
                NSString *endTime=[NSString stringWithFormat:@"%@:%@0",[endClock hour],[endClock minute]];
                NSString *timepairString=[NSString stringWithFormat:@"%@-%@",startTime,endTime];
                NSLog(@"Start Time %@---MAX HEAD %@ and MAX SEAT %@",startTime,maxHead,maxSeat);
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:timepairString,kTimePairStringKey,maxSeat,kMaxSeatKey,maxHead,kMaxHeadKey,floorId,kFloorIDKey,tierId,kTierIDKey,selectedTimePairs,kSelectedTimePairsKey, nil];
                [self.timeSlotArray addObject:dictionary];
//                 [self.timeSlotArray insertObject:[NSArray arrayWithObjects:timepairString,maxSeat,maxHead,floorId,tierId,selectedTimePairs,nil] atIndex:k];
                /*
                NSDateFormatter *formatter1=[[NSDateFormatter alloc] init];
                [formatter1 setDateFormat:@"k:mm"];
                NSDate *formattedStartTime=[formatter1 dateFromString:startTime];
                NSDate *formattedEndTime=[formatter1 dateFromString:endTime];
                
                NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
                [formatter2 setDateFormat:@"k:mm"];
                NSString *startTimeStr=[formatter2 stringFromDate:formattedStartTime];
                NSString *endTimeStr=[formatter2 stringFromDate:formattedEndTime];
                NSString *timeSlotStr=[NSString stringWithFormat:@"%@-%@",startTimeStr,endTimeStr];
                NSLog(@"TIMS SLOT STR %@",timeSlotStr);
                 */
                
            }
        }
    }
    self.tierNameLbl.text=tierName;
     [self.timeSlotTableView reloadData];
}
#pragma mark date picker
-(void)showDatePicker{
//    self.actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//    
//    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
//    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, 325, 300)];
//    self.datePicker.datePickerMode = UIDatePickerModeDate;
//    self.datePicker.hidden = NO;
//    self.datePicker.datePickerMode=UIDatePickerModeTime;
//    [self.datePicker addTarget:self
//                   action:@selector(selectedDate:)
//         forControlEvents:UIControlEventValueChanged];
//
//    [self.actionSheet addSubview:self.datePicker];

    UISegmentedControl *doneButton=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Done", nil]];
    doneButton.momentary=YES;
    doneButton.frame=CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle=UISegmentedControlStyleBar;
    doneButton.tintColor=[UIColor redColor];
    [doneButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:doneButton];
    
    [self.actionSheet showInView:[[UIApplication sharedApplication]keyWindow]];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}
-(void)dismissActionSheet:(id)sender{
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
     [self getPseduoReservation];
}
-(void)selectedDate:(id)sender{
    
    NSDateFormatter *timeFormatter=[[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    [self.selectTimeBtn setTitle:[timeFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
//    self.timeLbl.text=[timeFormatter stringFromDate:self.datePicker.date];
}
#pragma mark table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getFilteredArray].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//   UIView* header=[[[NSBundle mainBundle]loadNibNamed:@"ReservationHeader" owner:self options:nil] objectAtIndex:0];
//    return header;
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    header.backgroundColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0f];
    // add 2 labels
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2,header.frame.size.height)];
    UILabel *tableHeader = [[UILabel alloc]initWithFrame:CGRectMake(timeLabel.frame.size.width, 0, self.frame.size.width/2, header.frame.size.height)];
    
    timeLabel.backgroundColor = [UIColor clearColor];
    tableHeader.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    tableHeader.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:14.0f];
    tableHeader.font = [UIFont systemFontOfSize:14.0f];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    tableHeader.textAlignment = NSTextAlignmentCenter;
    [timeLabel setText:@"Time"];
    [tableHeader setText:@"Table"];
    
    [header addSubview:timeLabel];
    [header addSubview:tableHeader];
    return header;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CTTimeSlotCell *cell=(CTTimeSlotCell *)[tableView dequeueReusableCellWithIdentifier:@"timeSlot"];
//    cell.backgroundColor=[UIColor clearColor];
//    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TimeSlotCell" owner:self options:nil];
//    cell.backgroundColor = [UIColor clearColor];
//    cell=[nib objectAtIndex:0];
//    if([self.timeSlotArray count]!=0){
//        int MAX_SEAT=[[[self.timeSlotArray objectAtIndex:indexPath.row]objectAtIndex:1]intValue];
//        if(MAX_SEAT==0){
//            cell.timeLabel.text=[NSString stringWithFormat:@"%@",[[self.timeSlotArray objectAtIndex:indexPath.row] objectAtIndex:0]];
//            cell.tabelLabel.text=@"Open";
//        }
//        else if (MAX_SEAT>=1){
//            cell.timeLabel.text=[NSString stringWithFormat:@"%@",[[self.timeSlotArray objectAtIndex:indexPath.row] objectAtIndex:0]];
//            cell.tabelLabel.text=[NSString stringWithFormat:@"%d Table",MAX_SEAT];
//        }
//        else if (MAX_SEAT==-1){
//            cell.timeLabel.text=[NSString stringWithFormat:@"%@",[[self.timeSlotArray objectAtIndex:indexPath.row] objectAtIndex:0]];
//            cell.tabelLabel.text=@"Many Tables";
//        }
//        else if (MAX_SEAT==-2){
//            cell.timeLabel.text=[NSString stringWithFormat:@"%@",[[self.timeSlotArray objectAtIndex:indexPath.row] objectAtIndex:0]];
//            cell.tabelLabel.text=@"Closed";
//        }
//        
//    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    UILabel *tableLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 44)];
    tableLabel.textAlignment = NSTextAlignmentCenter;
    tableLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryView = tableLabel;
    tableLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    tableLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSArray *filtered = [self getFilteredArray];
    if(filtered!=0){
        NSDictionary *dictionary = [filtered objectAtIndex:indexPath.row];
        int MAX_SEAT=[[dictionary valueForKey:kMaxSeatKey] intValue];
        if(MAX_SEAT==0){
            cell.textLabel.text=[dictionary valueForKey:kTimePairStringKey];
           tableLabel.text=@"Open";
        }
        else if (MAX_SEAT>=1){
            cell.textLabel.text=[dictionary valueForKey:kTimePairStringKey];
            tableLabel.text=[NSString stringWithFormat:@"%d Table",MAX_SEAT];
        }
        else if (MAX_SEAT==-1){
            cell.textLabel.text=[dictionary valueForKey:kTimePairStringKey];
            tableLabel.text=@"Many Tables";
        }
        else if (MAX_SEAT==-2){
            cell.textLabel.text=[dictionary valueForKey:kTimePairStringKey];
            tableLabel.text=@"Closed";
        }
        
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0f];
    }else{
        cell.backgroundColor=[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.timeSlotArray count ]!=0){
        [self createReservation:[self getFilteredArray] atIndex:indexPath.row];
    }
}
#pragma mark send reservation
-(void)createReservation:(NSArray *)chosenReservation atIndex:(int)i{
    NSDictionary *dictionary = [chosenReservation objectAtIndex:i];
    NSLog(@"SELECTED TIME PAIRS %@",dictionary);
    NSString *partySize=[dictionary valueForKey:kMaxHeadKey];
    NSString *floorId=[dictionary valueForKey:kFloorIDKey];
    NSString *tierId=[dictionary valueForKey:kTierIDKey];
    NSArray *selectedTimePairs=[dictionary valueForKey:kSelectedTimePairsKey];
    NSDictionary *timePairs=[selectedTimePairs valueForKey:@"timePair"];
    NSDictionary *startClock=[timePairs startClock];
    NSDictionary *endClock=[timePairs endClock];

    NSString *UID=[CTCommonMethods UID];
    params=[NSString stringWithFormat:@"UID=%@&serviceLocationId=%@&serviceAccommodatorId=%@&date=%@&startHour=%@&startMin=%@&endHour=%@&endMin=%@&partySize=%@&tierId=%@&floorId=%@",UID,self.sl,self.sa,[self getCurrentDate],[startClock hour],[startClock minute],[endClock hour],[endClock minute],partySize,tierId,floorId];
    NSLog(@"PARAMS %@",params);
    
    self.urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_createPseduoReservation,params];
    NSLog(@"url string %@",self.urlString);
}
-(void)sendReservation{
    if(self.urlString!=NULL){
    NSURL *url=[NSURL URLWithString: self.urlString];
    NSLog(@"URL STRING %@",self.urlString);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[ self.urlString UTF8String] length:strlen([ self.urlString UTF8String])]];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"RESPONSE %@",(NSDictionary *)JSON);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Your reservation is created successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
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
    }else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please select the table"];
    }
}
- (IBAction)cancel:(id)sender {
    
    [self dismissView];
}
- (IBAction)send:(id)sender {
    
    [self sendReservation];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissView];
}

@end
