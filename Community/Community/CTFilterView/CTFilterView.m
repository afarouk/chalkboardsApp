//
//  CTFilterView.m
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTFilterView.h"
#import "Constants.h"
#import "NSDictionary+RestaurantFilterOptions.h"
#import "NSArray+RestaurantFilterOptionsArray.h"
#import "NSArray+GetDomainOptions.h"
#import "MBProgressHUD.h"

@implementation CTFilterView
-(void)didTapOnView:(UITapGestureRecognizer*)tap {
    if([self.delegate respondsToSelector:@selector(didTapOnFilterView)])
        [self.delegate didTapOnFilterView];
}
-(void)enableHitDetectionArea {
    gestureView.frame = CGRectMake(container.frame.size.width, 0, [UIScreen mainScreen].applicationFrame.size.width-container.frame.size.width, self.frame.size.height);
    CGRect frame = self.frame;
    frame.size.width  = container.frame.size.width+gestureView.frame.size.width;
    self.frame = frame;
}
-(void)disableHitDetectionArea {
    gestureView.frame=CGRectMake(0, 0, 1, 1);
    CGRect frame = self.frame;
    frame.size.width  = container.frame.size.width;
    self.frame = frame;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTFilterView" owner:self options:nil];
        [self addSubview:[nib objectAtIndex:0]];
         self.backgroundColor=[UIColor clearColor];
        
        container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[nib objectAtIndex:0] frame].size.width, self.frame.size.height)];
        [self addSubview:container];
        [container addSubview:[nib objectAtIndex:0]];
        container.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        // view for gesture
        gestureView = [[UIView alloc]initWithFrame:CGRectMake(container.frame.size.width, 0, self.frame.size.width-container.frame.size.width, self.frame.size.height)];
        gestureView.backgroundColor = [UIColor clearColor];
        [self addSubview:gestureView];
        [self disableHitDetectionArea];
// controls.
        [self initializeControls];

        // tap gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnView:)];
        [gestureView addGestureRecognizer:tap];
    
        
    }
    return self;
}
-(void)initializeControls{
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
    swipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGesture];
    self.domainFilterButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    self.categoryFilterButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    self.submitButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    self.cancelButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    self.isDomain=YES;
    self.isCategory=YES;
    self.domainList=[[NSMutableArray alloc]init];
    self.categoryList=[[NSMutableArray alloc]init];
    [self showdropdownView];
}
-(IBAction)selectDomain:(id)sender{
    [self filterButtonIsDomain:YES andIsCategory:NO];
    [self animateDropUpView];
    [self getDomainOptions];
}
-(IBAction)selectCategory:(id)sender{
    [self filterButtonIsDomain:NO andIsCategory:YES];
    [self animateDropUpView];
    [self getSASLFilterOptions ];
}
-(IBAction)submit:(id)sender{
    [UIView animateWithDuration:0.3f animations:^{
        self.frame=CGRectOffset(self.frame, -275, 0);
        [self getFilterOptionsResults];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ResetFilterPopup" object:self];


    } completion:^(BOOL finished) {
        [self disableHitDetectionArea];

    }];
}
-(IBAction)cancel:(id)sender{
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame, -275, 0);
    [UIView commitAnimations];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"ResetFilterPopup" object:self];
}
- (IBAction)back:(id)sender {
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame, -275, 0);
    [UIView commitAnimations];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ResetFilterPopup" object:self];
}
#pragma mark action sheet creation
-(void)showdropdownView{
    
    self.dropdownView=[[UIView alloc]initWithFrame:CGRectMake(0,510,self.frame.size.width, 280)];
    self.dropdownView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    self.selectorTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,40,self.frame.size.width,130)];
    self.selectorTableView.tableFooterView=[[UIView alloc]init];
    self.selectorTableView.backgroundColor=[UIColor clearColor];
    self.selectorTableView.delegate=self;
    self.selectorTableView.dataSource=self;
    [self.dropdownView addSubview:self.selectorTableView];
    
    UISegmentedControl *cancelButton=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Cancel", nil]];
    cancelButton.momentary=YES;
    cancelButton.frame=CGRectMake(210, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle=UISegmentedControlStyleBar;
    cancelButton.tintColor=[UIColor redColor];
    [cancelButton addTarget:self action:@selector(dismissdropdownView:) forControlEvents:UIControlEventValueChanged];
    [self.dropdownView addSubview:cancelButton];
    
    [self addSubview:self.dropdownView];
}
#pragma animatedDropDown
-(void)animateDropUpView{
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.dropdownView.frame=CGRectOffset(self.dropdownView.frame, 0, -230);
    [UIView commitAnimations];
    [self enableUserInteraction:NO];
}
-(void)animateDropDownView{
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.dropdownView.frame=CGRectOffset(self.dropdownView.frame, 0, 230);
    [UIView commitAnimations];
    [self enableUserInteraction:YES];
}
#pragma mark userInteraction
-(void)enableUserInteraction:(BOOL)isEnable{
    
    self.closeButton.userInteractionEnabled=isEnable;
    self.domainFilterButton.userInteractionEnabled=isEnable;
    self.categoryFilterButton.userInteractionEnabled=isEnable;
    self.cancelButton.userInteractionEnabled=isEnable;
    self.submitButton.userInteractionEnabled=isEnable;
}
#pragma mark dismiss action sheet
-(void)dismissdropdownView:(id)sender{
    
   // [self.dropdownView dismissWithClickedButtonIndex:0 animated:YES];
    [self animateDropDownView];
}
#pragma mark selected button
-(void)filterButtonIsDomain:(BOOL)domain andIsCategory:(BOOL)category{
    
    self.isCategory=category;
    self.isDomain=domain;
}
#pragma mark get domain
-(void)getDomainOptions{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_getDomainOptions];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        @try{
           NSArray *domainOptionsArray=(NSArray *)JSON;
            [self parseDomainOptions:domainOptionsArray];
            [MBProgressHUD hideHUDForView:self animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"DOMAIN PARSING EXCEPTION %@",exception);
            
        }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"FAILED");
               [MBProgressHUD hideHUDForView:self animated:YES];
    }];
    [operation start];
}
#pragma mark get getSASLFilterOptions
-(void)getSASLFilterOptions{
    /* restaurant/getRestaurantFilterOptions is replaced by sasl/getSASLFilterOptions due to api change*/
    NSLog(@"selected domain %@",self.selectedDomain);
    NSString *urlString=[NSString stringWithFormat:@"%@%@?domain=%@",[CTCommonMethods getChoosenServer],CT_getSASLFilterOptions,self.selectedDomain];
    NSLog(@"url %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dict=(NSDictionary *)JSON;
        [self getFilterOptionsArrayList:dict];
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSLog(@"SUCCESS");
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
#pragma mark parse domainoptions
-(void)parseDomainOptions:(NSArray *)domainOptionsArray{
  
    [self.domainList removeAllObjects];
    for(int i=0;i<[domainOptionsArray count];i++){
        
        NSString *displayText=[domainOptionsArray displayText:i];
        NSString *enumText=[domainOptionsArray enumText:i];
        NSLog(@"DISPLAY TEXT %@ AND ENUM TEXT %@",displayText,enumText);
        [self.domainList insertObject:[NSArray arrayWithObjects:displayText, enumText,nil] atIndex:i];
    }
    NSLog(@"SUCESS");
    [self.selectorTableView reloadData];
}
#pragma mark parse filteroptions
/*
-(void)getFilterOptionsArrayList:(NSDictionary *)dict{
    NSDictionary *dict2=[dict filterOptions];
    NSArray *allkeys=[dict2 allKeys];
    for(int i=0;i<[allkeys count];i++){
        NSString *key=[NSString stringWithFormat:@"%@",[allkeys objectAtIndex:i]];
        NSArray *array=[dict2 categoryKey:key];
        for(int j=0;j<[array count];j++){
            
            NSString *category=[array categoryNameAtIndex:j];
            [self.categoryList addObject:[NSArray arrayWithObjects:category,key,nil]];
            NSLog(@"CATEGORY %@",[array categoryNameAtIndex:j]);
        }
    }
    [self.selectorTableView reloadData];
}
 */

-(void)getFilterOptionsArrayList:(NSDictionary *)dict{
    [self.categoryList removeAllObjects];
    NSArray *filterArray=[dict objectForKey:@"filterOptions"];
    for(int i=0;i<[filterArray count];i++){
          NSString *key=[NSString stringWithFormat:@"%@",[[filterArray valueForKey:@"enumText"] objectAtIndex:i]];
          NSString *category=[NSString stringWithFormat:@"%@",[[filterArray valueForKey:@"displayText"] objectAtIndex:i]];
         [self.categoryList addObject:[NSArray arrayWithObjects:category,key,nil]];
    }
      [self.selectorTableView reloadData];
}
#pragma mark format the parsed string
-(NSString *)getParsedString:(NSString *)string{
    NSString *formatted1=[string stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    NSString *formatted2=[formatted1 lowercaseString];
    NSString *formatted3=[formatted2 capitalizedString];
    return formatted3;
}
#pragma mark domain and category selectors
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.isDomain){
        return [self.domainList count];
    }
    else if(self.isCategory){
        
        return [self.categoryList count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"cellidentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    if(self.isDomain){
        if([self.domainList count]!=0){
            NSString *domain=[NSString stringWithFormat:@"%@",[[self.domainList objectAtIndex:indexPath.row]objectAtIndex:0]];
            cell.textLabel.text=domain;
//           self.selectedDomain=[NSString stringWithFormat:@"%@",[[self.domainList objectAtIndex:indexPath.row]objectAtIndex:1]];
//            cell.textLabel.text=[self getParsedString:domain];
        }
    }
    else if (self.isCategory){
        if([self.categoryList count]!=0){
            NSString *category=[NSString stringWithFormat:@"%@",[[self.categoryList objectAtIndex:indexPath.row]objectAtIndex:0 ]];
//            self.selectedCategory=[NSString stringWithFormat:@"%@",[[self.categoryList objectAtIndex:indexPath.row]objectAtIndex:1]];
            cell.textLabel.text=[self getParsedString:category] ;
        }
    }
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     // [self.dropdownView dismissWithClickedButtonIndex:0 animated:YES];
        if(self.isDomain){
            NSString *domain=[NSString stringWithFormat:@"%@",[[self.domainList objectAtIndex:indexPath.row] objectAtIndex:0]];
            self.domainLabel.text=domain;
            self.selectedDomain=[NSString stringWithFormat:@"%@",[[self.domainList objectAtIndex:indexPath.row]objectAtIndex:1]];
            //self.domainLabel.text=[self getParsedString:domain];
            self.selectedCategory = @"";
            self.categoryLabel.text = @"";
        }
        else if(self.isCategory){
             NSString *category=[NSString stringWithFormat:@"%@",[[self.categoryList objectAtIndex:indexPath.row]objectAtIndex:0]];
            self.categoryLabel.text=[self getParsedString:category];
            self.selectedCategory=[NSString stringWithFormat:@"%@",[[self.categoryList objectAtIndex:indexPath.row]objectAtIndex:1]];
        }
}
#pragma mark getFilterOptionsResults
-(void)getFilterOptionsResults{
//    if([self.categoryList count]&&[self.domainList count]!=0){
    if(self.domainList.count!=0) {
        NSDictionary *selectedCategoryName=[NSDictionary dictionaryWithObjectsAndKeys:self.selectedDomain,@"domain",self.selectedCategory,@"category", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_FilterCategory object:self userInfo:selectedCategoryName];
    }
}
@end
