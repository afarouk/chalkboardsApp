//
//  CTDeactivateEventView.m
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTDeactivateEventView.h"
#import "CTActivateEventCell.h"
@interface CTDeactivateEventView ()

@end


@implementation CTDeactivateEventView

#pragma mark -Date Convert
-(NSString *) convertdisplayDate_Time :(NSString *)datestr
{
    //    NSString *dateString = @"2015-11-09T06:54:00:UTC";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss:'UTC'Z"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss:Z"];
    NSDate* date = [dateFormatter dateFromString:datestr];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm aa"];
    NSString* formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self EventDataGetforActivate];
}

-(void)EventDataGetforActivate
{
    listofStatus = [[NSMutableArray alloc] init];
    listofStartdate = [[NSMutableArray alloc] init];
    listofEventName = [[NSMutableArray alloc] init];
    listofEventId = [[NSMutableArray alloc] init];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",[CTCommonMethods getChoosenServer],CT_EventSummaryAPI_URL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl];
    NSLog(@"URL get duration %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON Event Type == %@",JSON);
        if (JSON)
        {
            
            NSArray * listofevent = [JSON valueForKey:@"events"];
            //            NSLog(@"listofevent = %@",listofevent);
            for (int k =0; k < listofevent.count; k++)
            {
                NSDictionary * fetchvalue = listofevent[k];
                NSLog(@"fetchvalue Status:%@",[fetchvalue valueForKey:@"status"]);
                if ([[fetchvalue valueForKey:@"status"] isEqualToString:@"ACTIVE"]) {
                    [listofStatus addObject:[fetchvalue valueForKey:@"status"]];
                    [listofStartdate addObject:[self convertdisplayDate_Time:[fetchvalue valueForKey:@"activation"]]];
                    [listofEventName addObject:[fetchvalue valueForKey:@"displayText"]];
                    [listofEventId addObject:[fetchvalue valueForKey:@"uuid"]];
                }
            }
            
            [tbl_Activate reloadData];
            NSLog(@"listofStatus = %@",listofStatus);
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
    }];
    
    [operation start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"CTActivateEventCell" bundle:nil];
    [tbl_Activate registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableView data source and delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"arrPrizes = %d",arrPrizes.count);
    return listofEventName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CTActivateEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[CTActivateEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.font=[UIFont fontWithName:@"Lato-Black" size:15.0];
    
    
    cell.lblEventName.text = listofEventName[indexPath.row];
    NSLog(@" hello  %@,",listofEventName[indexPath.row]);
    cell.lblEventDate.text = listofStartdate[indexPath.row];
    cell.lblStatus.text = listofStatus[indexPath.row];
    
    cell.btnActivate.tag = indexPath.row;
    [cell.btnActivate setTitle:@"Deactivate" forState:UIControlStateNormal];
    [cell.btnActivate addTarget:self action:@selector(Activate:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)Activate :(UIButton *)sender {
    int temp = sender.tag;
    [self activateAPI:listofEventId[temp]:temp];
}

-(void)activateAPI : (NSString *)eventId :(int)index
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    
    NSString *promotionRequest = [NSString stringWithFormat:@"%@?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&eventUUID=%@",CT_DeactivateEventAPI_URL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,eventId];
    
    NSLog(@"promotionRequest = %@",promotionRequest);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]
                                initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
    NSMutableURLRequest *request = [httpClient
                                    requestWithMethod:@"PUT" path:promotionRequest parameters:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dict=(NSDictionary *)JSON;
        NSLog(@"SUCEESS = %@",dict);
        if (dict)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitleEventDeactivated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alertView show];
            [listofEventId removeObjectAtIndex:index];
            [listofEventName removeObjectAtIndex:index];
            [listofStatus removeObjectAtIndex:index];
            [listofStartdate removeObjectAtIndex:index];
            [tbl_Activate reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
        
    }];
    
    [operation start];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
