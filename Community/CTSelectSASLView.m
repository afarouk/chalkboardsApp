//
//  CTSelectSASLView.m
//  Community
//
//  Created by My Mac on 23/02/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTSelectSASLView.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "CTParentViewController.h"
#import "ImageNamesFile.h"

@implementation CTSelectSASLView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*///
- (id)init
{
    //if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
    //{
        self = [[[NSBundle mainBundle]loadNibNamed:@"CTSelectSASLCustomerView" owner:self options:nil] objectAtIndex:0];
        self.frame = [[UIScreen mainScreen] bounds];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 276, 25)];
        headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(4, 2, 276, 20)];
        labelView.font = [UIFont boldSystemFontOfSize:15.0];
        labelView.text = @"Select Business";
        [headerView addSubview:labelView];
        tblDisplayData.tableHeaderView = headerView;
        
    //}
//    else
//    {
//        self = [[[NSBundle mainBundle]loadNibNamed:@"CTSelectSASLView" owner:self options:nil] objectAtIndex:0];
//        self.frame = [[UIScreen mainScreen] bounds];
//        
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 276, 25)];
//        headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
//        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(4, 2, 276, 20)];
//        labelView.font = [UIFont boldSystemFontOfSize:15.0];
//        labelView.text = @"Select a Business to manage";
//        [headerView addSubview:labelView];
//        tblDisplayData.tableHeaderView = headerView;
//        
//    }
    
    if (self) {
        // Initialization code
        //[self getdataForBusiness];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^(void) {
                            } completion:NULL];
            
        });
        [tblDisplayData reloadData];
    }
    return self;
}

-(IBAction)closeBtnTaped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self
                          duration:1.0f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^(void) {
                        } completion:NULL];
        
    });
    [self performSelector:@selector(removeView) withObject:nil afterDelay:0.5];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"hello restro %lu",(unsigned long)[CTCommonMethods sharedInstance].RestaurantSASLName.count);
    return [CTCommonMethods sharedInstance].RestaurantSASLName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIDentifier = @"Cell";
    
    UITableViewCell *cell = [tblDisplayData dequeueReusableCellWithIdentifier:cellIDentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDentifier];
    }
    
    else
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDentifier];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Lato-Black" size:15.0];

    [cell.accessoryView removeFromSuperview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [CTCommonMethods sharedInstance].RestaurantSASLName[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [CTCommonMethods sharedInstance].selectSa = [CTCommonMethods sharedInstance].RestaurantSA[indexPath.row];
    [CTCommonMethods sharedInstance].selectSl = [CTCommonMethods sharedInstance].RestaurantSL[indexPath.row];
    
    
    NSMutableDictionary *yourDictionary = [[NSMutableDictionary alloc] init];
    [yourDictionary setObject:[CTCommonMethods sharedInstance].selectSa forKey:@"SelectSA"];
    [yourDictionary setObject:[CTCommonMethods sharedInstance].selectSl forKey:@"SelectSL"];
    NSLog(@"select sa %@",[CTCommonMethods sharedInstance].selectSa);
    [[NSUserDefaults standardUserDefaults] setObject:yourDictionary forKey:@"SASLSelect"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self
                          duration:1.0f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^(void) {
                        } completion:NULL];
    });
    
    //
    
    if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
    {
        NSLog(@"call this-------");
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPramotion" object:nil];
    }
    else
    {
        [self performSelector:@selector(removeView) withObject:nil afterDelay:0.5];
    }
}


-(void)removeView
{
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"6"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AdAlertViewOpen" object:nil];
    }
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"7"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateEventViewOpen" object:nil];
    }
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"8"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivateEventViewOpen" object:nil];
    }
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"9"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeactivateEventViewOpen" object:nil];
    }
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"10"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PromotionViewOpen" object:nil];
    }
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"11"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivePromotionViewOpen" object:nil];
    }
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"12"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeactivePromotionViewOpen" object:nil];
    }
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"13"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PollViewOpen" object:nil];
    }
    
    if ([[CTCommonMethods sharedInstance].IdentifierNoti isEqualToString:@"101"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateScreen" object:nil];
    }

     [self removeFromSuperview];
}

- (IBAction)BackButtonPressed:(id)sender {
    [self removeFromSuperview];
}
@end
