//
//  CTChatViewController.m
//  Community
//
//  Created by practice on 10/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTChatViewController.h"
#import "MBProgressHUD.h"
#import "CTAppDelegate.h"
#import "CTRootControllerDataModel.h"
#import "SpeechBubbleView.h"
#import "MessageTableViewCell.h"
#import "ImageNamesFile.h"
#import "NSDictionary+GetRestaurantDetails.h"
@interface CTChatViewController (UITextFieldDelegate)
@end
@interface CTChatViewController ()


@end

@implementation CTChatViewController
#define kMessageTextKey @"messageBody"
#define kMessageTimeStampKey @"timeStamp"
#define kMessageSASLNameKey @"saslName"
-(void)showMessageViewWithMenuView:(UIView *)_menuView {
    //    menuView = _menuView;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center= CGPointMake(self.view.frame.size.width/2, self.view.center.y);
        _menuView.center = CGPointMake(self.view.frame.size.width+(_menuView.frame.size.width/2), _menuView.center.y);
        
    } completion:^(BOOL finished) {
        // add action sheet
        
        
    }];
}
-(NSDate*)dateFromTimeStamp:(NSString*)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@":UTC" withString:@""];
    NSDate *date = [dateFormatter dateFromString:timeStamp];
    return date;
}
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.messagesArray = [NSMutableArray array];
        [self getConversationBetweenUserSASL];
    }
    return self;
}
-(void)loadView {
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height-44)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
//    self.view.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.85f];
    self.view.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];

    // table view
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-writeMessageView.frame.size.height-44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // write message view
    writeMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    writeMessageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-(writeMessageView.frame.size.height/2));
    writeMessageView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:writeMessageView];
    [self.view bringSubviewToFront:writeMessageView];

    // message text field
    self.messageTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, writeMessageView.frame.size.width-10, writeMessageView.frame.size.height)];
    self.messageTextField.textColor = [UIColor whiteColor];
    self.messageTextField.borderStyle = UITextBorderStyleNone;
    self.messageTextField.delegate = self;
    if ([self.messageTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
        self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type your message here" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    [writeMessageView addSubview:self.messageTextField];
    
    // send button
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendBtn setBackgroundColor:[UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0f]];
    [self.sendBtn setFrame:CGRectMake(0, 0, 60, 36)];
    [self.sendBtn setCenter:CGPointMake(writeMessageView.frame.size.width-(self.sendBtn.frame.size.width/2)-5, writeMessageView.frame.size.height/2)];
    [self.sendBtn setHidden:YES];
    [self.sendBtn addTarget:self action:@selector(sendMessageToSASL:) forControlEvents:UIControlEventTouchUpInside];
    [writeMessageView addSubview:self.sendBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setMessage:(NSString*)message bubbleView:(SpeechBubbleView*)_bubbleView forCell:(UITableViewCell*)cell
{
    // Create the label
   UILabel* _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.backgroundColor = [UIColor clearColor];
    _label.opaque = YES;
    _label.clearsContextBeforeDrawing = NO;
    _label.contentMode = UIViewContentModeRedraw;
    _label.autoresizingMask = 0;
    _label.font = [UIFont systemFontOfSize:13];
    _label.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    
	CGPoint point = CGPointZero;
    
	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	NSString* senderName;
	BubbleType bubbleType;
//	if ([message isSentByUser])
//	{
		bubbleType = BubbleTypeRighthand;
		senderName = NSLocalizedString(@"You", nil);
		point.x = cell.bounds.size.width - [SpeechBubbleView sizeForText:message].width;
		_label.textAlignment = NSTextAlignmentLeft;
//	}
//	else
//	{
//		bubbleType = BubbleTypeLefthand;
//		senderName = message.senderName;
//		_label.textAlignment = NSTextAlignmentRight;
//	}
    
	// Resize the bubble view and tell it to display the message text
	CGRect rect;
	rect.origin = point;
	rect.size = [SpeechBubbleView sizeForText:message];
	_bubbleView.frame = rect;
	[_bubbleView setText:message bubbleType:bubbleType];
    
	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDoesRelativeDateFormatting:YES];
	NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
	// Set the sender's name and date on the label
	_label.text = [NSString stringWithFormat:@"%@ @ %@", senderName, dateString];
	[_label sizeToFit];
	_label.frame = CGRectMake(8, [SpeechBubbleView sizeForText:message].height, cell.contentView.bounds.size.width - 16, 16);
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
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = [self.messagesArray objectAtIndex:indexPath.row];
    return [SpeechBubbleView sizeForText:[dictionary valueForKey:kMessageTextKey]].height+16+27;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageTableViewCell* cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSDictionary *dictionary = [self.messagesArray objectAtIndex:indexPath.row];
    NSDate *date = [dictionary valueForKey:kMessageTimeStampKey];
    BOOL isSentByUser = NO;
    if([[dictionary valueForKey:@"fromUser"] boolValue] == YES) {
        isSentByUser = YES;
        [cell setMessage:[dictionary valueForKey:kMessageTextKey] isSentByUser:isSentByUser dateSent:date senderName:[dictionary valueForKey:kMessageSASLNameKey] saslImage:nil];
    }else {
        NSMutableDictionary *restDetails = [CTRootControllerDataModel sharedInstance].selectedRestDetails;
        UIImage *image = [restDetails logoImage];
        [cell setMessage:[dictionary valueForKey:kMessageTextKey] isSentByUser:isSentByUser dateSent:date senderName:[dictionary valueForKey:kMessageSASLNameKey] saslImage:image];
    }
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
-(void)getConversationBetweenUserSASL {
    NSDictionary *restaurantDetails = [[CTRootControllerDataModel sharedInstance]selectedRestaurant];
    NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
    NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
    NSString *params=[NSString stringWithFormat:@"UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",[CTCommonMethods UID],sa,sl];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_GetConversationBetweenUserSASL,params];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dict=[(NSDictionary *)JSON deepMutableCopy];
        NSArray *array=[dict objectForKey:@"messages"];
        [self.messagesArray addObjectsFromArray:array];
        // sort descending
        for(NSMutableDictionary *dictionary in self.messagesArray) {
            NSDate *date = [self dateFromTimeStamp:[dictionary valueForKey:kMessageTimeStampKey]];
            [dictionary setObject:date forKey:kMessageTimeStampKey];
        }
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:kMessageTimeStampKey ascending:YES];
        [self.messagesArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        // reload table.
        [self.tableView reloadData];
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
        [self.messagesArray addObjectsFromArray:array];
//        for(int i=0;i<[array count];i++){
//            NSString *messageBody=[NSString stringWithFormat:@"%@",[[array valueForKey:@"messageBody"] objectAtIndex:i]];
//            NSLog(@"message Body %@",messageBody);
//            [self.messagesArray addObject:messageBody];
//        }
        [self.tableView reloadData];
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

-(void)sendMessageToSASL:(UIButton*)sender{
    if(self.messageTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message should not be empty" message:@"Please type your message and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else {
        NSDictionary *restaurantDetails = [[CTRootControllerDataModel sharedInstance]selectedRestaurant];
        // NSString *UID=[[NSUserDefaults standardUserDefaults]objectForKey:CT_UID];
        NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
        NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
        NSString *params=[NSString stringWithFormat:@"UID=%@",[CTCommonMethods UID]];
        NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_SendMessageToSASL,params];
        NSLog(@"URL %@",urlString);
        NSURL *url=[NSURL URLWithString:urlString];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        NSString *msgTxt=[NSString stringWithFormat:@"{\"messageBody\":\"%@\",\"toServiceAccommodatorId\":%@,\"urgent\":true,\"toServiceLocationId\":%@,\"authorId\":\"%@\"}",self.messageTextField.text,sa,sl,[CTCommonMethods UID]];
        NSLog(@"MSG TEXT %@",msgTxt);
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])]];
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        hud.labelText=@"Please wait...";
        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"SUCEESS");
            NSMutableDictionary *dict=[(NSDictionary *)JSON deepMutableCopy];
            //        NSString *messageBody=[dict valueForKey:@"messageBody"];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"fromUser"];
            NSDate *date = [self dateFromTimeStamp:[dict valueForKey:kMessageTimeStampKey]];
            [dict setObject:date forKey:kMessageTimeStampKey];
            
            [self.messagesArray addObject:dict];
            NSLog(@"array %@",self.messagesArray);
            @try {
                [self.tableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"exception reloading row %@",exception);
            }
            if([[dict objectForKey:@"explanation"] isEqualToString:@"OK"]){
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Thanks for your review"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // resign text field.
            [self.messageTextField resignFirstResponder];
            [self.messageTextField setText:@""];
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
}

@end
@implementation CTChatViewController (UITextFieldDelegate)
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.35f animations:^{
        writeMessageView.center = CGPointMake(writeMessageView.center.x, self.view.frame.size.height-(writeMessageView.frame.size.height/2)-260+44);
        textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width-60, textField.frame.size.height);
        [textField setSelectedTextRange:[textField selectedTextRange]];
        [self.sendBtn setHidden:NO];
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25f animations:^{
        writeMessageView.center = CGPointMake(writeMessageView.center.x, self.view.frame.size.height-(writeMessageView.frame.size.height/2));
        textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, writeMessageView.frame.size.width, textField.frame.size.height);
        [self.sendBtn setHidden:YES];
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 160) ? NO : YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
