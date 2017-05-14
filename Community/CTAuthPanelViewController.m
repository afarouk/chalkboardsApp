//
//  CTAuthPanelViewController.m
//  Community
//
//  Created by practice on 16/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTAuthPanelViewController.h"
#import "CTSignUpViewController.h"
#import "MBProgressHUD.h"
#import "CTCommonMethods.h"
@interface CTAuthPanelViewController ()

@end

@implementation CTAuthPanelViewController

-(UITableViewCell*)configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    if(indexPath.section == 0) {
        cell.textLabel.text = @"User Name";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        userNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 140, 44)];
        userNameField.autocapitalizationType= UITextAutocapitalizationTypeNone;
        userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
        userNameField.placeholder = @"Type user name";
        userNameField.delegate = self;
        userNameField.font = [UIFont systemFontOfSize:14.0f];
        cell.accessoryView = userNameField;
    }
    else if(indexPath.section == 1) {
        cell.textLabel.text = @"Password";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        passField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 140, 44)];
        [passField setSecureTextEntry:YES];
        passField.placeholder = @"Type password";
        passField.delegate = self;
        passField.font = [UIFont systemFontOfSize:14.0f];
        cell.accessoryView = passField;
    }
    return cell;
}
#pragma Control Methods
-(void)didChooseLoginOption:(id)sender {
    NSLog(@"did choose login option");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *params=[NSString stringWithFormat:@"username=%@&password=%@",userNameField.text,passField.text];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_loginUser,params];
    NSLog(@"url %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"SUCESS %@",(NSDictionary *)JSON);
        NSDictionary *successDict=(NSDictionary *)JSON;
        NSString *UID=[successDict objectForKey:@"uid"];
        NSString *userName = [successDict objectForKey:@"userName"];
        NSLog(@"UID %@ \n userName %@",UID,userName);
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [CTCommonMethods setUID:UID];
        [CTCommonMethods setUserName:userName];
        [defaults setValue:[CTCommonMethods UID] forKey:UIDInDefaults];
        [defaults setValue:[CTCommonMethods UserName] forKey:UserNameInDefaults];
        [defaults synchronize];
        [CTCommonMethods showErrorAlertMessageWithTitle:@"Successfully Logged In" andMessage:[NSString stringWithFormat:@"You have successfully logged in as %@",userNameField.text]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
-(void)didChooseRegisterOption:(id)sender {
    NSLog(@"did choose sign up option ");
    CTSignUpViewController *signUp = [[CTSignUpViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:signUp animated:YES];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        loginBtn.frame = CGRectMake(0, 10, view.frame.size.width/2, 40);
        [loginBtn setTitle:@"Log In" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(didChooseLoginOption:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn.titleLabel setTextColor:[UIColor grayColor]];
        [view addSubview:loginBtn];
        UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        signUpBtn.frame = CGRectMake(view.frame.size.width/2, 10, view.frame.size.width/2, 40);
        [signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
        [signUpBtn addTarget:self action:@selector(didChooseRegisterOption:) forControlEvents:UIControlEventTouchUpInside];
        [signUpBtn.titleLabel setTextColor:[UIColor grayColor]];

        [view addSubview:signUpBtn];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 1)
        return 100;
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // Configure the cell...
    return [self configureCell:cell forIndexPath:indexPath];
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
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end