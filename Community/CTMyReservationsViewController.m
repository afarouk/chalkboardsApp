//
//  CTMyReservationsViewController.m
//  Community
//
//  Created by practice on 07/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTMyReservationsViewController.h"
#import "CTReservationCell.h"
#import "NSArray+RetrievePseudoReservationsForUser.h"
#import "NSDictionary+RetrievePseudoReservationsForUser.h"
#import "CTModifyReservationView.h"
#import "ImageNamesFile.h"
#import "CTAppDelegate.h"
@interface CTMyReservationsViewController ()

@end

@implementation CTMyReservationsViewController
-(void)retrivePseudoReservation{
    NSString *UID=[CTCommonMethods UID];
    NSString *params=[NSString stringWithFormat:@"UID=%@&startDate=2013-10-15&endDate=2014-10-15",UID];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getPseudoReservation,params];
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.rows=(NSArray *)JSON;
        NSLog(@"COUNT %d",[self.rows count]);
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSError *validatinError = [CTCommonMethods validateJSON:JSON];
        if(validatinError) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:validatinError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }else if(error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:CT_DefaultAlertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
    [operation start];
}
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
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self retrivePseudoReservation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // hide button.
    self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:CT_BackIcon];
    [self.hideBtn setImage:img forState:UIControlStateNormal];
    [self.hideBtn setFrame:CGRectMake(0,0, img.size.width, img.size.height)];
    [self.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    self.hideBtn.center = CGPointMake(self.view.frame.size.width-(self.hideBtn.frame.size.width/2)-10, self.hideBtn.imageView.image.size.height/2);
    [view addSubview:self.hideBtn];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTReservationCell *restaurantCell=(CTReservationCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTReservationCell" owner:self options:nil];
    restaurantCell=[nib objectAtIndex:0];
    restaurantCell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    if([self.rows count]!=0){
        NSDictionary *reservation=[self.rows objectAtIndex:indexPath.row];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *reservation=[self.rows objectAtIndex:indexPath.row];
    NSLog(@"RESERVATION %@",reservation);
    CTModifyReservationView *modifyReservationView=[[CTModifyReservationView alloc]initWithFrame:self.view.frame];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"modifyReservation"];
    
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:reservation];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"modifyReservation"];
    [defaults synchronize];
    CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController.view addSubview:modifyReservationView];
//    [self.view addSubview:modifyReservationView];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
