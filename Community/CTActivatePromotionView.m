//
//  CTActivatePromotionView.m
//  Community
//
//  Created by My Mac on 15/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTActivatePromotionView.h"
#import "CTActivatePromotionCell.h"
#import "CTPromotion.h"
#import "MBProgressHUD.h"

@interface CTActivatePromotionView ()

@end

@implementation CTActivatePromotionView
#define kCellHeight 100.0

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self RetrivePromotionPicture];
    
}

#pragma mark - Retrive Image Api
-(void)RetrivePromotionPicture
{
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait. . .";
    self.promotionsArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@",@"promotions/retrievePromotionSATiersBySASL?"];
    NSDictionary *params=@{@"serviceAccommodatorId":[CTCommonMethods sharedInstance].selectSa, @"serviceLocationId":[CTCommonMethods sharedInstance].selectSl,@"status":@"APPROVED", @"startIndex":@(0), @"count":@(10)};
    
    NSLog(@"params =%@",params);
    NSLog(@"urlString =%@",urlString);
    
    AFHTTPClient *myclient= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]]]];
    
    NSMutableURLRequest *request = [myclient requestWithMethod:@"GET" path:urlString parameters:params];
    request.timeoutInterval = 20.0;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        // NSLog(@"jsons = %@",jsons);
        if (responseObject && [responseObject isKindOfClass:[NSData class]])
        {
            //NSLog(@"response oject = %@",[responseObject multipartArray]);
            for (NSInteger i = 0; i < [responseObject multipartArray].count; i = i+2) {
                CTPromotion *promoation = [[CTPromotion alloc] init];

                for (NSDictionary *dict in [[responseObject multipartArray] subarrayWithRange:NSMakeRange(i, 2)]) {
                    NSString *contentType = [dict valueForKey:@"Content-Type"];
                    
                
                    
                    if ([contentType hasPrefix:@"application/json"]){
                        NSDictionary *promotionMetaDatDict = [NSJSONSerialization JSONObjectWithData:dict[@"data"] options:NSJSONReadingMutableContainers error:nil];
                       // NSLog(@"data is  = %@",promotionMetaDatDict);
                        [promoation importFromDictionary:promotionMetaDatDict];
                    }
                    else if ([contentType hasPrefix:@"image"]) {
                        UIImage *image = [UIImage imageWithData:[dict valueForKey:@"data"]];
                        promoation.thumbnail = UIImageJPEGRepresentation(image, .9);
                    }
                }
//                NSLog(@"promotion = %@",promoation.promotionStatus);
                if ([promoation.promotionStatus isEqualToString:@"APPROVED"]) {
                    [self.promotionsArray addObject:promoation];
                }
                //NSLog(@"hello isPatroMode %d",promoation.isPatroMode);
                //NSLog(@"hello campaignTitle %@",promoation.campaignTitle);
                //NSLog(@"hello patronUserName %@",promoation.patronUserName);
                
                //
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            selectedIndexes = [[NSMutableDictionary alloc] init];
            for (int k = 0; k < self.promotionsArray.count;k++)
            {
                BOOL isSelected = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:k-1 inSection:0];
                
                // Store cell 'selected' state keyed on indexPath
                NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
                [selectedIndexes setObject:selectedIndex forKey:indexPath];
                //[selectedIndexes setObject:selectedIndex forKey:[NSString stringWithFormat:@"%d",k]];

            }
            
            
            [tblActivate reloadData];
        }
        // NSLog(@"promotionPictureList = %d",self.promotionPictureList.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure(request, error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([operation.response statusCode] == 403)
        {
            NSLog(@"Upload Failed");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleRequestFailed message:error.localizedDescription delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleRequestFailed message:error.localizedDescription delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"CTActivatePromotionCell" bundle:nil];
    [tblActivate registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    tblActivate.HVTableViewDataSource = self;
    tblActivate.HVTableViewDelegate = self;
    // Do any additional setup after loading the view from its nib.
}

//- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
//    // Return whether the cell at the specified index path is selected or not
//    NSNumber *selectedIndex = [selectedIndexes objectForKey:indexPath];
//    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
//}

#pragma TableView ExpandCell
//perform your expand stuff (may include animation) for cell here. It will be called when the user touches a cell
-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
//    MessageLabelText = (UILabel *)[cell viewWithTag:112];
//    MessageLabelText.alpha = 0;
//    MessageLabelText.hidden = NO;
//    
//    MessageLabel = (UILabel *)[cell viewWithTag:115];
//    MessageLabel.alpha = 0;
//    MessageLabel.hidden = NO;
//    
//    CampaignLabelText = (UILabel *)[cell viewWithTag:113];
//    CampaignLabelText.alpha = 0;
//    CampaignLabelText.hidden = NO;
//    
//    CampaignLabel = (UILabel *)[cell viewWithTag:116];
//    CampaignLabel.alpha = 0;
//    CampaignLabel.hidden = NO;
//    
//    UserLabelText = (UILabel *)[cell viewWithTag:114];
//    UserLabelText.alpha = 0;
//    UserLabelText.hidden = NO;
//    
//    UserLabel = (UILabel *)[cell viewWithTag:117];
//    UserLabel.alpha = 0;
//    UserLabel.hidden = NO;

    MainImage = (UIImageView *)[cell viewWithTag:100000];
    MainImage.alpha = 0;
    MainImage.hidden = NO;
    
    ShareImage = (UIImageView *)[cell viewWithTag:100006];
    ShareImage.alpha = 0;
    ShareImage.hidden = NO;
    
    TitleLbl = (UILabel *)[cell viewWithTag:100001];
    TitleLbl.alpha = 0;
    TitleLbl.hidden = NO;
    
    OffersLbl = (UILabel *)[cell viewWithTag:100005];
    OffersLbl.alpha = 0;
    OffersLbl.hidden = NO;
    
    MsgTitleLbl = (UILabel *)[cell viewWithTag:100002];
    MsgTitleLbl.alpha = 0;
    MsgTitleLbl.hidden = NO;
    
    MessgeLbl = (UILabel *)[cell viewWithTag:100003];
    MessgeLbl.alpha = 0;
    MessgeLbl.hidden = NO;
    
    MsgBgLbl = (UILabel *)[cell viewWithTag:100004];
    MsgBgLbl.alpha = 0;
    MsgBgLbl.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:
     ^{
//        CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
//        
//        if ([promotion.promotionStatus isEqualToString:@"APPROVED"]){
//            MessageLabelText.text = promotion.messageText;
//            if (promotion.isPatroMode == YES)
//            {
//                CampaignLabelText.text = promotion.campaignTitle;
//                UserLabelText.text = promotion.patronUserName;
//            }
//            else
//            {
//                CampaignLabelText.hidden = YES;
//                UserLabelText.hidden = YES;
//                CampaignLabel.hidden = YES;
//                UserLabel.hidden = YES;
//            }
//        }
//        
//        MessageLabelText.alpha = 1;
//        MessageLabel.alpha = 1;
//
//        CampaignLabel.alpha = 1;
//        CampaignLabelText.alpha = 1;
//         
//        UserLabel.alpha = 1;
//        UserLabelText.alpha = 1;
         
         CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
         
         if ([promotion.promotionStatus isEqualToString:@"APPROVED"]){
             MainImage.image = [UIImage imageWithData:promotion.thumbnail];
             TitleLbl.text = promotion.promotionSASLName;
             
             MessgeLbl.text = promotion.messageText;
             MsgTitleLbl.text = promotion.promotionSASLName;
             OffersLbl.text = promotion.promotionSASLName;
         }
         MainImage.alpha = 1;
         TitleLbl.alpha = 1;
         MsgBgLbl.alpha = 1;
         MessgeLbl.alpha = 1;
         MsgTitleLbl.alpha = 1;
         OffersLbl.alpha = 1;
         ShareImage.alpha = 1;
         
        [cell.contentView viewWithTag:119].transform = CGAffineTransformMakeRotation(3.14);
    }];
}


//perform your collapse stuff (may include animation) for cell here. It will be called when the user touches an expanded cell so it gets collapsed or the table is in the expandOnlyOneCell satate and the user touches another item, So the last expanded item has to collapse
-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
//    MessageLabelText = (UILabel *)[cell viewWithTag:112];
//    MessageLabel = (UILabel *)[cell viewWithTag:115];
//    
//    CampaignLabelText = (UILabel *)[cell viewWithTag:113];
//    CampaignLabel = (UILabel *)[cell viewWithTag:116];
//    
//    UserLabelText = (UILabel *)[cell viewWithTag:114];
//    UserLabel = (UILabel *)[cell viewWithTag:117];

    MainImage = (UIImageView *)[cell viewWithTag:100000];
    TitleLbl = (UILabel *)[cell viewWithTag:100001];
    
    MsgTitleLbl = (UILabel *)[cell viewWithTag:100002];
    MessgeLbl = (UILabel *)[cell viewWithTag:100003];
    MsgBgLbl = (UILabel *)[cell viewWithTag:100004];
    
    ShareImage = (UIImageView *)[cell viewWithTag:100006];
    OffersLbl = (UILabel *)[cell viewWithTag:100005];
    
    [UIView animateWithDuration:.5 animations:
     ^{
       
//        CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
//        if ([promotion.promotionStatus isEqualToString:@"APPROVED"]){
//            MessageLabelText.text = promotion.messageText;
//            
//            if (promotion.isPatroMode == YES)
//            {
//                CampaignLabelText.text = promotion.campaignTitle;
//                UserLabelText.text = promotion.patronUserName;
//            }
//            else
//            {
//                CampaignLabelText.hidden = YES;
//                UserLabelText.hidden = YES;
//                CampaignLabel.hidden = YES;
//                UserLabel.hidden = YES;
//            }
//        }
//        MessageLabelText.alpha = 0;
//        MessageLabel.alpha = 0;
//         
//        CampaignLabelText.alpha = 0;
//        CampaignLabel.alpha = 0;
//         
//        UserLabelText.alpha = 0;
//        UserLabel.alpha = 0;
         
         CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
         if ([promotion.promotionStatus isEqualToString:@"APPROVED"]){
             MainImage.image = [UIImage imageWithData:promotion.thumbnail];
             TitleLbl.text = promotion.promotionSASLName;
             MessgeLbl.text = promotion.messageText;
             MsgTitleLbl.text = promotion.promotionSASLName;
             OffersLbl.text = promotion.promotionSASLName;
         }
         MainImage.alpha = 0;
         TitleLbl.alpha = 0;
         MessgeLbl.alpha = 0;
         MsgTitleLbl.alpha = 0;
         MsgBgLbl.alpha = 0;
         OffersLbl.alpha = 0;
         ShareImage.alpha = 0;
         
        [cell.contentView viewWithTag:119].transform = CGAffineTransformMakeRotation(0);
         
    } completion:^(BOOL finished) {
        
//        MessageLabelText.hidden = YES;
//        MessageLabel.hidden = YES;
//        
//        CampaignLabelText.hidden = YES;
//        CampaignLabel.hidden = YES;
//        
//        UserLabelText.hidden = YES;
//        UserLabel.hidden = YES;
        
        MainImage.hidden = YES;
        TitleLbl.hidden = YES;
        MessgeLbl.hidden = YES;
        MsgTitleLbl.hidden = YES;
        MsgBgLbl.hidden = YES;
        OffersLbl.hidden = YES;
        ShareImage.hidden = YES;
        
    }];
}


#pragma mark - UITableView data source and delegate methods
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // If our cell is selected, return double height
//    if([self cellIsSelected:indexPath]) {
//        return kCellHeight * 3.0;
//    }
//    
//    // Cell isn't selected so return single height
//    return kCellHeight;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    //you can define different heights for each cell. (then you probably have to calculate the height or e.g. read pre-calculated heights from an array
//    CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
//    if (promotion.isPatroMode == NO)
//    {
//        if (isexpanded)
//            return 200;
//    }
//    else{
//        if (isexpanded)
//            return 250;
//    }

    if (isexpanded)
    {
        return 320;
    }
    
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"arrPrizes = %d",arrPrizes.count);
    return self.promotionsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded{
    
    CTActivatePromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[CTActivatePromotionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    else
    {
     //   if (indexPath.row % 2 == 0){
       //     cell.backgroundColor =[UIColor lightGrayColor];
        //} else {
          //  cell.backgroundColor =[UIColor whiteColor];
        //}
        cell.textLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
        CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
        //    NSLog(@"statss = %@",promotion.promotionStatus);
        //    NSLog(@"statss Name = %@",promotion.promotionSASLName);
        //    NSLog(@"-----------------");
        if ([promotion.promotionStatus isEqualToString:@"APPROVED"]) {
            
            cell.imgPromotion.image = [UIImage imageWithData:promotion.thumbnail];;
            cell.lblFirst.text = promotion.promotionSASLName;
            cell.lblSecond.text = [promotion.promotionType valueForKey:@"displayText"];
            //        cell.lblSecond.text = promotion.messageText;
            cell.btnActivate.tag = indexPath.row;
            [cell.btnActivate addTarget:self action:@selector(Activate:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
    
    // Update cell content from data source.
    // NSLog(@"data is name = %@",[@"  " stringByAppendingString:[[CTCommonMethods sharedInstance] validateString:[[arrPrizes valueForKeyPath:@"contestPrizeName"] objectAtIndex:indexPath.row]]]);
    
    
    //Expand Cell
//    MessageLabelText = (UILabel *)[cell viewWithTag:112];
//    MessageLabel = (UILabel *)[cell viewWithTag:115];
//    
//    CampaignLabelText = (UILabel *)[cell viewWithTag:113];
//    CampaignLabel = (UILabel *)[cell viewWithTag:116];
//    
//    UserLabelText = (UILabel *)[cell viewWithTag:114];
//    UserLabel = (UILabel *)[cell viewWithTag:117];
    
    MainImage = (UIImageView *)[cell viewWithTag:100000];
    TitleLbl = (UILabel *)[cell viewWithTag:100001];
    
    MsgTitleLbl = (UILabel *)[cell viewWithTag:100002];
    MessgeLbl = (UILabel *)[cell viewWithTag:100003];
    MsgBgLbl = (UILabel *)[cell viewWithTag:100004];
    
    ShareImage = (UIImageView *)[cell viewWithTag:100006];
    OffersLbl = (UILabel *)[cell viewWithTag:100005];
    
    if (!isExpanded) //prepare the cell as if it was collapsed! (without any animation!)
    {
        [cell.contentView viewWithTag:119].transform = CGAffineTransformMakeRotation(0);
//        MessageLabelText.hidden = YES;
//        MessageLabel.hidden = YES;
//        
//        CampaignLabelText.hidden = YES;
//        CampaignLabel.hidden = YES;
//        
//        UserLabelText.hidden = YES;
//        UserLabel.hidden = YES;

        MainImage.hidden = YES;
        TitleLbl.hidden = YES;
        MsgTitleLbl.hidden = YES;
        MessgeLbl.hidden = YES;
        MsgBgLbl.hidden = YES;
        ShareImage.hidden = YES;
        OffersLbl.hidden = YES;
    }
    else ///prepare the cell as if it was expanded! (without any animation!)
    {
        
//        CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
//        if ([promotion.promotionStatus isEqualToString:@"APPROVED"])
//        {
//            MessageLabelText.text = promotion.messageText;
//            if (promotion.isPatroMode == YES)
//            {
//                CampaignLabelText.text = promotion.campaignTitle;
//                UserLabelText.text = promotion.patronUserName;
//                
//                CampaignLabelText.hidden = NO;
//                CampaignLabel.hidden = NO;
//                
//                UserLabelText.hidden = NO;
//                UserLabel.hidden = NO;
//            }
//            else
//            {
//                CampaignLabelText.hidden = YES;
//                UserLabelText.hidden = YES;
//                CampaignLabel.hidden = YES;
//                UserLabel.hidden = YES;
//            }
//        }
//        
//        [cell.contentView viewWithTag:119].transform = CGAffineTransformMakeRotation(3.14);
//        MessageLabelText.hidden = NO;
//        MessageLabel.hidden = NO;

        CTPromotion* promotion = [self.promotionsArray objectAtIndex:indexPath.row];
        if ([promotion.promotionStatus isEqualToString:@"APPROVED"])
        {
            
            MainImage.image = [UIImage imageWithData:promotion.thumbnail];
            TitleLbl.text = promotion.promotionSASLName;
            MessgeLbl.text = promotion.messageText;
            MsgTitleLbl.text = promotion.promotionSASLName;
            OffersLbl.text = promotion.promotionSASLName;
        }
        
        [cell.contentView viewWithTag:119].transform = CGAffineTransformMakeRotation(3.14);
        MainImage.hidden = NO;
        TitleLbl.hidden = NO;
        OffersLbl.hidden = NO;
        ShareImage.hidden = NO;

    }

    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Deselect cell
//    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
//    
//    // Toggle 'selected' state
//    BOOL isSelected = ![self cellIsSelected:indexPath];
//    
//    // Store cell 'selected' state keyed on indexPath
//    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
//    
//    NSLog(@"indexPath = %@",indexPath);
//    [selectedIndexes setObject:selectedIndex forKey:indexPath];
//    NSLog(@"selectedIndexes = %@",selectedIndexes);
//
//    // This is where magic happens...
//    [tableView beginUpdates];
//    [tableView endUpdates];
//}

-(void)Activate :(UIButton *)sender {
    int temp = sender.tag;
    CTPromotion* promotion = [self.promotionsArray objectAtIndex:temp];
    [self activatePromotion:promotion.promoUUID:temp];
}

-(void)activatePromotion :(NSString *)promoUUID :(int)index
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    
     NSString *promotionRequest = [NSString stringWithFormat:CT_PromotionActivate_URL,promoUUID,[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,[CTCommonMethods UID]];
    
    NSLog(@"promotionRequest = %@",promotionRequest);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]
                                initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
    NSMutableURLRequest *request = [httpClient
                                    requestWithMethod:@"PUT" path:promotionRequest parameters:nil];
    //[request setHTTPBody:imageData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dict=(NSDictionary *)JSON;
        NSLog(@"SUCEESS = %@",dict);
        if (dict)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitlePromotionActivated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alertView show];
            [self.promotionsArray removeObjectAtIndex:index];
            [tblActivate reloadData];
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
