//
//  CTBusinessinvitatcodeView.m
//  Community
//
//  Created by ADMIN on 4/19/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTBusinessinvitatcodeView.h"
#import "CTInviteView.h"
#import "MBProgressHUD.h"
#import "CTBussinessLogin.h"

@implementation CTBusinessinvitatcodeView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (id)init
{
    myView.layer.borderWidth = 2;
    myView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self = [[[NSBundle mainBundle]loadNibNamed:@"BussinessInviteCode" owner:self options:nil] objectAtIndex:0];
    self.frame = [[UIScreen mainScreen] bounds];
    
    self.txt_Invitation.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_Invitation.layer.borderWidth = 1;
    
    
    btnCancel.layer.borderColor = [UIColor blackColor].CGColor;
    btnCancel.layer.borderWidth = 2 ;
    btnCancel.layer.cornerRadius = 5;
    btnCancel.layer.masksToBounds = YES;
    btnSubmit.layer.borderColor = [UIColor blackColor].CGColor;
    btnSubmit.layer.borderWidth = 2 ;
    btnSubmit.layer.cornerRadius = 5;
    btnSubmit.layer.masksToBounds = YES;
    myView.layer.borderColor = [UIColor blackColor].CGColor;
    myView.layer.borderWidth = 2;
    myView.layer.cornerRadius = 5;
    myView.layer.masksToBounds = YES;
    self.txt_Invitation.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)cancleBtnPressed:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)submitBtnPressed:(id)sender
{
    [self loginUser];
}

-(void)loginUser{
    
    if (![_txt_Invitation.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter a valid invitation code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [_txt_Invitation becomeFirstResponder];
    }
    else
    {
        NSString *params=[NSString stringWithFormat:@"verifyInvitationCode?invitationCode=%@",self.txt_Invitation.text];
        
        NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],@"authentication/",params];
        NSLog(@"url %@",urlString);
        NSURL *url=[NSURL URLWithString:urlString];
        //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"url String %@",urlString);
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"GET"];
        //[request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            NSLog(@"SUCESS %@",(NSDictionary *)JSON);
            if (JSON)
            {
                NSString * stringmessage = [JSON valueForKey:@"explanation"];
                [[[UIAlertView alloc] initWithTitle:stringmessage message:nil delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
                
                
                CTBussinessLogin *bussiness = [[CTBussinessLogin alloc]init];
                
                [CTCommonMethods sharedInstance].invitationcode =_txt_Invitation.text;
                //CTInviteView *invitaionPopup = [[CTInviteView alloc]init];
                CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
                [appDelegate.window.rootViewController.view addSubview:bussiness];
                
            }
            [self removeFromSuperview];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            if(JSON) {
                NSLog(@"FAILED");
                NSError *jsonError = [CTCommonMethods validateJSON:JSON];
                //        NSDictionary *errorDict=(NSDictionary *)JSON;
                //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
                //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
                if(jsonError)
                    [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
                else
                    [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
            }else if(error) {
                NSLog(@"FAILED");
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedDescription];
                
            }
        }];
        [operation start];
    }
}

@end
