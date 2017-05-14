//
//  CTMessageViewController.m
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTMessageViewController.h"
#import "CTNavigationBar.h"
#import "ImageNamesFile.h"
#import "MBProgressHUD.h"

@interface CTMessageViewController ()
@property (nonatomic,strong)CTNavigationBar *ctNavigationBar;
@property (nonatomic,retain)UITextView *composedChatTextView;
@property (nonatomic,retain)UITableView *chatTableView;
@property (nonatomic,retain)UIView *msgTextHolderView;
@property (nonatomic,assign)CGSize keyboardSize;
@property (nonatomic,retain)NSMutableArray *clientMsgContentArray;
@property (weak, nonatomic) IBOutlet UITextView *serverMessageSizetxtView;
@property (nonatomic,assign)BOOL isKeyboardUp;
@end

@implementation CTMessageViewController
-(void)showMessageViewWithMenuView:(UIView *)_menuView {
    //    menuView = _menuView;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center= CGPointMake(self.view.frame.size.width/2, self.view.center.y);
        _menuView.center = CGPointMake(self.view.frame.size.width+(_menuView.frame.size.width/2), _menuView.center.y);
        
    } completion:^(BOOL finished) {
        // add action sheet
       
        
    }];
}
-(IBAction)backBtnTaped:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center = CGPointMake(-(self.view.frame.size.width/2), self.view.center.y);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"Messages";
    self.view.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.92f];
//    [self setCustomNavigationBar];
    [self checkiOS7];
    // back button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:CT_BackIcon];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [btn setCenter:CGPointMake(self.view.frame.size.width-(btn.frame.size.width/2)-20, (btn.frame.size.height/2)+5)];
    [btn addTarget:self action:@selector(backBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // [self setMessageViewControllerIsOpen];
    self.serverMessageSizetxtView.hidden=YES;
    [self initializeViewSttings];
    [self getMessageForUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark create custom navigation bar
-(void)setCustomNavigationBar{
    self.ctNavigationBar=[[CTNavigationBar alloc]init];
    self.ctNavigationBar.navigationController=self.navigationController;
    self.ctNavigationBar.sliderView=self.view;
//    self.ctNavigationBar.isMainMenuSlideOut=YES;
    self.navigationItem.leftBarButtonItem=[self setBackButton];
    self.navigationItem.rightBarButtonItem=[self.ctNavigationBar setMenuButton];
   // self.navigationItem.titleView=[self.ctNavigationBar setRestaurantLogo:[UIImage imageNamed:@"Default.png"]];
    self.navigationItem.title=@"Messages";
    [self performSelector:@selector(showMainMenuView) withObject:self afterDelay:0.5];
}
#pragma mark back button
-(UIBarButtonItem *)setBackButton{
   UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;

}
-(void)backButtonAction:(id)sender{
    [self.ctNavigationBar.slideMainMenu removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Menu
-(void)showMainMenuView{
    [self.view addSubview:[self.ctNavigationBar sliderMainMenu]];
    self.ctNavigationBar.slideMainMenu.isMessageControllerIsOpen=NO;
}
#pragma mark iOS7 check
-(void)checkiOS7{
    
    if(isIOS7){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}
#pragma mark post notification
-(void)setMessageViewControllerIsOpen{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observer_MessageControllerIsOpen object:self];
}
#pragma mark Keyboard
-(void)initializeViewSttings{
    self.isKeyboardUp=NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.clientMsgContentArray=[[NSMutableArray alloc]init];
    [self setMessageControls];
}
-(void)setMessageControls{
    
     self.composedChatTextView =[[UITextView alloc]initWithFrame:CGRectMake(10,40, 270, 60)];
     self.composedChatTextView.backgroundColor=[UIColor lightGrayColor];
     self.composedChatTextView.textColor=[UIColor blackColor];
     self.composedChatTextView.text=@"Tap to write message";
     self.composedChatTextView.font=[UIFont boldSystemFontOfSize:15.0];
     self.composedChatTextView.delegate=self;
    
    UIImageView *butonImage=[[UIImageView alloc]initWithFrame:CGRectMake(280, 50,40 , 40)];
    butonImage.image=[UIImage imageNamed:@"UP.png"];
    
    UIButton *sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame=CGRectMake(280, 30, 70, 60);
    [sendButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tempTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 40,300,self.view.frame.size.height-100)];
    tempTableView.backgroundColor=[UIColor clearColor];
    tempTableView.delegate=self;
    tempTableView.dataSource=self;
    tempTableView.tableFooterView=[[UIView alloc]init];
    self.chatTableView=tempTableView;
    
    self.msgTextHolderView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
    self.msgTextHolderView.backgroundColor=[UIColor whiteColor];
    
    if([[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE5]){
        
        self.msgTextHolderView.frame=CGRectMake(0, self.view.frame.size.height-160, self.view.frame.size.width, 100);
    }
    else if ([[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE4_4S]||[[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE_3GS]){
        
        self.msgTextHolderView.frame=CGRectMake(0, self.view.frame.size.height-190, self.view.frame.size.width, 100);
    }
    [self.msgTextHolderView addSubview:self.composedChatTextView];
    [self.msgTextHolderView addSubview:butonImage];
    [self.msgTextHolderView addSubview:sendButton];
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.msgTextHolderView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.clientMsgContentArray count]!=0){
        
        return [self.clientMsgContentArray count];
    }
    else{
        
        return 0.0;
    }
}

-(GLfloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *rowHeightStr=[NSString stringWithFormat:@"%@",[[self.clientMsgContentArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    NSLog(@"ROW HEIGHT STR %@",rowHeightStr);
    float rowHeight=[rowHeightStr floatValue]+100;
    return rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId=@"cellID";
    UITextView *textView=nil;
    UILabel *dateAndTimeLbl=nil;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==nil){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor=[UIColor clearColor];
        tableView.separatorColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        textView =[[UITextView alloc]initWithFrame:CGRectMake(0,20, 310, 60)];
        textView.backgroundColor=[UIColor lightGrayColor];
        textView.textColor=[UIColor blackColor];
        textView.font=[UIFont boldSystemFontOfSize:15.0];
        textView.editable=NO;
        textView.tag=100;
        [cell addSubview:textView];
        
        dateAndTimeLbl=[[UILabel alloc]initWithFrame:CGRectMake(140,60, 180, 21)];
        dateAndTimeLbl.textAlignment=UITextAlignmentLeft;
        dateAndTimeLbl.font=[UIFont boldSystemFontOfSize:13.0];
        dateAndTimeLbl.backgroundColor=[UIColor clearColor];
        dateAndTimeLbl.textColor=[UIColor blackColor];
        dateAndTimeLbl.tag=200;
        [cell addSubview:dateAndTimeLbl];
        
        
    }
    else{
        
        textView=(UITextView *)[cell viewWithTag:100];
        dateAndTimeLbl=(UILabel *)[cell viewWithTag:200];
    }
    if([self.clientMsgContentArray count]!=0){
        
        NSString *textViewHeightStr=[NSString stringWithFormat:@"%@",[[self.clientMsgContentArray objectAtIndex:indexPath.row] objectAtIndex:1]];
        float textViewHeight=[textViewHeightStr floatValue];
        textView.frame=CGRectMake(0,20, 310, textViewHeight);
        textView.text=[NSString stringWithFormat:@"%@",[[self.clientMsgContentArray objectAtIndex:indexPath.row]objectAtIndex:0]];
        float rowHeight=[textViewHeightStr floatValue]+40;
        dateAndTimeLbl.text=[self getDateAndTime];
        dateAndTimeLbl.frame=CGRectMake(140, rowHeight, 180, 21);
    }
    return cell;
}
-(NSString *)getDateAndTime{
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"MMM dd yyyy"];
    NSString *dateStr=[dateFormatter1 stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"k:mm a"];
    NSString *timeStr=[dateFormatter2 stringFromDate:[NSDate date]];
    
    NSString *dateAndTimeStr=[NSString stringWithFormat:@"%@, %@",dateStr,timeStr];
    NSLog(@"DATE AND TIME STR %@",dateAndTimeStr);
    return dateAndTimeStr;
}
-(void)dismissKeyboard{
    if(self.composedChatTextView.text.length!=0){
        if(self.composedChatTextView.text.length<=160){
            if(self.isKeyboardUp){
                [self.composedChatTextView resignFirstResponder];
                [self sendMessageToSASL];
                NSString *contentSizeStr=[NSString stringWithFormat:@"%f",self.composedChatTextView.contentSize.height];
                [self.clientMsgContentArray addObject:[NSArray arrayWithObjects:self.composedChatTextView.text,contentSizeStr,nil]];
                NSLog(@"CONTENT %@",self.clientMsgContentArray);
                [self.chatTableView reloadData];
                [self doDownAnimationTextView];
            }else{
                 [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Message should be 160 characters"];
            }
    }
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please write your message"];
    }
}
-(void)keyboardWasShown:(NSNotification *)notification{
    
    self.keyboardSize=[[[notification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
}

-(void)keyboardWillHide:(NSNotification *)notification{
    
    self.keyboardSize=[[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.composedChatTextView.text=@"";
    [self doUpAnimationTextView];
    
}
-(void)doUpAnimationTextView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.isKeyboardUp=YES;
        if([[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE5]){
            
            self.msgTextHolderView.frame=CGRectMake(0, self.keyboardSize.height-35, self.view.frame.size.width, 100);
        }
        else if ([[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE4_4S]||[[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE_3GS]){
            
            NSLog(@"%f",self.keyboardSize.height);
            self.msgTextHolderView.frame=CGRectMake(0, self.keyboardSize.height-40, self.view.frame.size.width, 100);
        }
        
    }];
}
-(void)doDownAnimationTextView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.isKeyboardUp=NO;
        if([[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE5]){
            
            self.msgTextHolderView.frame=CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100);
        }
        else if ([[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE4_4S]||[[CTCommonMethods getCurrentDevice]isEqualToString:iPHONE_3GS]){
            self.msgTextHolderView.frame=CGRectMake(0, self.view.frame.size.height-85, self.view.frame.size.width, 100);
        }
    }];
    self.composedChatTextView.text=@" ";
}

#pragma mark GetMessageForUser
/* For Testing i have used Harcoded UID -Dinesh*/
-(void)getMessageForUser{
    
    //NSString *UID=[[NSUserDefaults standardUserDefaults]objectForKey:CT_UID];
   // NSString *params=[NSString stringWithFormat:@"UID=%@",UID]; user0.1295791792726164893
     NSString *params=[NSString stringWithFormat:@"UID=%@",[CTCommonMethods UID]];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_GetMessageForUser,params];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dict=(NSDictionary *)JSON;
        NSArray *array=[dict objectForKey:@"messages"];
        for(int i=0;i<[array count];i++){
            NSString *messageBody=[NSString stringWithFormat:@"%@",[[array valueForKey:@"messageBody"] objectAtIndex:i]];
            NSLog(@"message Body %@",messageBody);
            self.serverMessageSizetxtView.text=messageBody;
            NSString *contentSizeStr=[NSString stringWithFormat:@"%f",self.serverMessageSizetxtView.contentSize.height];
            [self.clientMsgContentArray addObject:[NSArray arrayWithObjects:messageBody,contentSizeStr,nil]];
        }
         [self.chatTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

-(void)sendMessageToSASL{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Observers_getSASL];
    NSDictionary *restaurantDetails=[NSKeyedUnarchiver unarchiveObjectWithData:data];
   // NSString *UID=[[NSUserDefaults standardUserDefaults]objectForKey:CT_UID];
    NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
    NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
    NSString *params=[NSString stringWithFormat:@"UID=user20.781305772384780045"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_SendMessageToSASL,params];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"messageBody\":\"%@\",\"toServiceAccommodatorId\":%@,\"urgent\":true,\"toServiceLocationId\":%@,\"authorId\":\"user0.1295791792726164893\"}",self.composedChatTextView.text,sa,sl];
    NSLog(@"MSG TEXT %@",msgTxt);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])]];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCEESS");
        NSDictionary *dict=(NSDictionary *)JSON;
        if([[dict objectForKey:@"explanation"] isEqualToString:@"OK"]){
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Thanks for your review"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
@end
