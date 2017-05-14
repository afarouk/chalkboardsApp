//
//  CTYelpReviewsViewController.m
//  Community
//
//  Created by practice on 17/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTYelpReviewsViewController.h"
#import "CTRootControllerDataModel.h"
#import "MBProgressHUD.h"
#import "NSArray+RestaurantFilterOptionsArray.h"
#import "UIViewController+MJPopupViewController.h"
#import "CTYelpReviewCell.h"
#import "ImageNamesFile.h"
#import "CTAppDelegate.h"
#import "CTLoginPopup.h"
@interface CTYelpReviewsViewController ()

@end

@implementation CTYelpReviewsViewController
-(void)showYelpReviewViewWithMenuView:(UIView*)_menuView {
    menuView = _menuView;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center= CGPointMake(self.view.frame.size.width/2, self.view.center.y);
        menuView.center = CGPointMake(self.view.frame.size.width+(menuView.frame.size.width/2), menuView.center.y);
        
    } completion:^(BOOL finished) {
        
    }];
}
-(void)sendBtnTaped:(id)sender {
    if(writeView.starRatingCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Rating not mentioned" message:@"Please choose your rating and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else if(self.messageTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Review not provided" message:@"Please type your review and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else {
        [self addReview];
    }
}
-(UIView*)ratingInputView {
    [writeView.view removeFromSuperview ];
    writeView = nil;
    writeView=[[CTWriteReviewViewController alloc]initWithNibName:@"CTWriteReview" bundle:nil];
    (void)writeView.view;
    [writeView.sendBtn removeTarget:writeView action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];
    [writeView.sendBtn addTarget:self action:@selector(sendBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    return writeView.view;
}
-(void)closeBtnTaped:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center= CGPointMake(-(self.view.frame.size.width/2), self.view.center.y);
        
    } completion:^(BOOL finished) {
        // add action sheet
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}
-(void)showWriteMessageView {
    CGFloat keyboardHeight = 216;
    [UIView animateWithDuration:0.3f animations:^{
        writeMessageView.center = CGPointMake(writeMessageView.center.x, self.view.frame.size.height-keyboardHeight-(writeMessageView.frame.size.height/2));
    }];
}
-(void)hideWriteMessageView {
    [UIView animateWithDuration:0.3f animations:^{
        writeMessageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height);
    }];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self retriveReviews];
    }
    return self;
}
-(void)loadView {
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-44)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CTYelpReviewCell" bundle:nil] forCellReuseIdentifier:@"YelpReviewCell"];
    [self.view addSubview:self.tableView];
    if([UIDevice currentDevice].systemVersion.floatValue>=7) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    // write message view
    writeMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 88)];
    writeMessageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height);
    writeMessageView.backgroundColor = [UIColor darkGrayColor];
//    [self.view addSubview:writeMessageView];
//    [self.view bringSubviewToFront:writeMessageView];
//    self.tableView.tableFooterView = writeMessageView;
    [self.view addSubview:writeMessageView];
    // message text field
    self.messageTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, writeMessageView.frame.size.width-10, 44)];
    self.messageTextField.textColor = [UIColor whiteColor];
    self.messageTextField.borderStyle = UITextBorderStyleNone;
    self.messageTextField.delegate = self;
//    self.messageTextField.inputAccessoryView = [self ratingInputView];
    if ([self.messageTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
        self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Please type your reivew" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    [writeMessageView addSubview:self.messageTextField];
    // add rating view as well
    UIView *ratingView = [self ratingInputView];
    ratingView.center = CGPointMake(writeMessageView.frame.size.width/2, writeMessageView.frame.size.height-(ratingView.frame.size.height/2));
    [writeMessageView addSubview:ratingView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor darkGrayColor]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, btn.imageView.image.size.width, btn.imageView.image.size.height)];
    [btn setCenter:CGPointMake(view.frame.size.width-5-(btn.frame.size.width/2), view.frame.size.height/2)];
    [btn addTarget:self action:@selector(closeBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView* writeMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    writeMessageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-(writeMessageView.frame.size.height/2));
//    writeMessageView.backgroundColor = [UIColor darkGrayColor];
//    //    [self.view addSubview:writeMessageView];
//    //    [self.view bringSubviewToFront:writeMessageView];
//    self.tableView.tableFooterView = writeMessageView;
//    // message text field
//    self.messageTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, writeMessageView.frame.size.width-10, writeMessageView.frame.size.height)];
//    self.messageTextField.textColor = [UIColor whiteColor];
//    self.messageTextField.borderStyle = UITextBorderStyleNone;
//    self.messageTextField.delegate = self;
//    self.messageTextField.inputAccessoryView = [self ratingInputView];
//    if ([self.messageTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//        UIColor *color = [UIColor lightGrayColor];
//        self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Please type your reivew" attributes:@{NSForegroundColorAttributeName: color}];
//    } else {
//        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
//        // TODO: Add fall-back code to set placeholder color.
//    }
//    [writeMessageView addSubview:self.messageTextField];
//    return writeMessageView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 44;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reviewArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *userName = [self.reviewArray userName:indexPath.row];
    NSString *message = [self.reviewArray text_excerpt:indexPath.row];
//    CGFloat userNameHeight = [userName sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]].height;
    CGFloat messageHeight =[message sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(294, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    return 30+messageHeight+20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CTYelpReviewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YelpReviewCell"];
    if(cell == nil)
        cell = [[CTYelpReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YelpReviewCell"];
//    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTYelpReviewCell" owner:self options:nil];
//    cell=[nib objectAtIndex:0];
    cell.backgroundColor=[UIColor whiteColor];
    if([self.reviewArray count]!=0){
        cell.nameLbl.text=[NSString stringWithFormat:@"%@",[self.reviewArray userName:indexPath.row]];
        cell.reviewTxt.text=[NSString stringWithFormat:@"%@",[self.reviewArray text_excerpt:indexPath.row]];
        NSInteger rating = [self.reviewArray yelpReviewRating:indexPath.row];
        NSUInteger counter = 1;
        for(UIImageView *imageView in cell.ratingImageViews) {
            if(rating>=counter && counter<=5) {
                [imageView setImage:[UIImage imageNamed:@"gold_star.png"]];
            }else
                [imageView setImage:[UIImage imageNamed:@"grey_star.png"]];
            counter++;
        }
//        cell.ratingImg.image=[UIImage imageWithData:[self.ratingImageUrlArray objectAtIndex:indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLbl.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.reviewTxt.font =[UIFont systemFontOfSize:14.0f];
    // set size
    NSLog(@"LOAD FOR %d",indexPath.row);
//    [cell.nameLbl sizeToFit];
    [cell.reviewTxt sizeToFit];
//    NSLog(@"frame %@",NSStringFromCGRect(cell.reviewTxt.frame));
    cell.reviewTxt.frame = CGRectMake(cell.reviewTxt.frame.origin.x, cell.nameLbl.frame.origin.y+cell.nameLbl.frame.size.height+15, cell.reviewTxt.frame.size.width, cell.reviewTxt.frame.size.height);
    if(indexPath.row%2==0)
        cell.contentView.backgroundColor = [UIColor whiteColor];
    else
        cell.contentView.backgroundColor = [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1.0f];
    return cell;
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
-(void)addReview{
    NSDictionary *restaurantDetails=[[CTRootControllerDataModel sharedInstance] selectedRestaurant];
    NSString *UID=[CTCommonMethods UID];
    NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
    NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
    NSString *urlParams=[NSString stringWithFormat:@"UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",UID,sa,sl];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_AddReview,urlParams];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"text_excerpt\":\"%@\",\"rating\":%d}",self.messageTextField.text,writeView.starRatingCount];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])]];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.tableView endEditing:YES];
        [self.messageTextField resignFirstResponder];
        NSLog(@"SUCEESS");
        NSDictionary *dict=(NSDictionary *)JSON;
        if([[dict objectForKey:@"explanation"] isEqualToString:@"OK"]){
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Thanks for your review"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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

-(void)retriveReviews{
    //    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Observers_getSASL];
    NSDictionary *dict=[[CTRootControllerDataModel sharedInstance]selectedRestaurant];
    NSString* sa=[NSString stringWithFormat:@"%@",[dict objectForKey:@"serviceAccommodatorId"]];
    NSString* sl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"serviceLocationId"]];
    NSString *params=[NSString stringWithFormat:@"serviceAccommodatorId=%@&serviceLocationId=%@&lastId=0&count=10",sa,sl];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_RetriveReview,params];
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCCESS %@",(NSDictionary *)JSON);
        NSDictionary *dict=(NSDictionary *)JSON;
        self.reviewArray=[dict objectForKey:@"reviews"];
        [self placeHolderRatingImg];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self setRatingStar];
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
                [self.tableView reloadData];
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([CTCommonMethods isUIDStoredInDevice]){
        //        [self openReview];
        return YES;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
        return NO;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self writeReview:nil];
    [self showWriteMessageView];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideWriteMessageView];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex) {
        CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
        CTLoginPopup *loginPopup = [[CTLoginPopup alloc]init];
        [appDelegate.window.rootViewController.view addSubview:loginPopup];
    }
}
@end
